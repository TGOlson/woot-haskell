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
    , sendLocalOperation
    , sendLocalDelete
    , sendLocalInsert
    , WString(..)
    , WChar(..)
    , WCharId(..)
    , Operation(..)
    , ClientId
    ) where


import Data.Woot.WString.Builder
import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation
import Data.Woot.Core


data WootClient = WootClient
    { wootClientId             :: Int
    , wootClientClock          :: Int
    , wootClientString         :: WString
    , wootClientOperationQueue :: [Operation]
    } deriving (Eq, Show)


incClock :: WootClient -> WootClient
incClock (WootClient cid clock ws ops) = WootClient cid (succ clock) ws ops


makeWootClient :: WString -> ClientId -> WootClient
makeWootClient ws cid = WootClient cid 0 ws []


makeWootClientEmpty :: ClientId -> WootClient
makeWootClientEmpty cid = makeWootClient (makeEmptyWString cid) cid


sendOperation :: WootClient -> Operation -> WootClient
sendOperation (WootClient cid clock ws ops) op = WootClient cid clock ws' ops'
    where
      (ops', ws') = integrateAll (op:ops) ws


sendOperations :: WootClient -> [Operation] -> WootClient
sendOperations = foldl sendOperation


-- identical to sendOperation, but increments the clients internal clock
-- most use cases should use sendLocalDelete or sendLocalInsert
sendLocalOperation :: WootClient -> Operation -> WootClient
sendLocalOperation client = incClock . sendOperation client


-- note: local operations can result in no-ops if the underlying operation is invalid
-- the assumption is that anything done locally should already be verified
-- if you are concerned with whether the operation may have failed,
-- try using makeDeleteOperation in conjunction with sendLocalOperation
sendLocalDelete :: WootClient -> Int -> WootClient
sendLocalDelete client pos = maybe client (sendLocalOperation client) op
  where
    op = makeDeleteOperation (wootClientId client) pos (wootClientString client)


sendLocalInsert :: WootClient -> Int -> Char -> WootClient
sendLocalInsert client@(WootClient cid clock ws _) pos a =
    maybe client (sendLocalOperation client) op
  where
    op = makeInsertOperation cid clock pos a ws
