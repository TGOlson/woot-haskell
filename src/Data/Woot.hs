module Data.Woot
    ( WootClient
    , wootClientId
    , wootClientClock
    , wootClientString
    , wootClientOperationQueue
    , makeWootClient
    , makeWootClientEmpty
    , sendOperation
    , sendOperations
    , sendLocalDelete
    , sendLocalInsert
    -- TODO: figure out core exports
    , WString
    ) where


import Data.Woot.WString.Builder
import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation
import Data.Woot.Core


-- do not expose constructor
data WootClient = WootClient
    { wootClientId             :: Int
    , wootClientClock          :: Int
    , wootClientString         :: WString
    , wootClientOperationQueue :: [Operation]
    }


incClock :: WootClient -> WootClient
incClock (WootClient cid clock ws ops) = WootClient cid (succ clock) ws ops


makeWootClient :: ClientId -> WString -> WootClient
makeWootClient cid ws = WootClient cid 0 ws []


makeWootClientEmpty :: ClientId -> WootClient
makeWootClientEmpty cid = makeWootClient cid $ makeEmptyWString cid


sendOperation :: Operation -> WootClient -> WootClient
sendOperation op (WootClient cid clock ws ops) = WootClient cid clock ws' ops'
    where
      (ops', ws') = integrateAll (op:ops) ws


sendOperations :: [Operation] -> WootClient -> WootClient
sendOperations ops client = foldl (flip sendOperation) client ops


-- note: local operations can throw index out of bounds errors - they are unsafe
-- the assumption is that anything done locally should already be verified
sendLocalDelete :: Int -> WootClient -> WootClient
sendLocalDelete pos client = incClock $ sendOperation op client
  where
    op = makeDeleteOperation (wootClientId client) pos (wootClientString client)


sendLocalInsert :: Int -> Char -> WootClient -> WootClient
sendLocalInsert pos a client@(WootClient cid clock ws _) = incClock $ sendOperation op client
  where
    op = makeInsertOperation cid clock pos a ws
