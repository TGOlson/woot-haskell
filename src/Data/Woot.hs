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
    , WString(..)
    , WChar(..)
    , WCharId(..)
    , Operation(..)
    , ClientId
    ) where


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


-- TODO: should this check is the client id already exists in the provided string
-- and then start the client clock at the correct value?
makeWootClient :: WString -> ClientId -> WootClient
makeWootClient ws cid = WootClient cid 0 ws []


makeWootClientEmpty :: ClientId -> WootClient
makeWootClientEmpty = makeWootClient emptyWString


sendOperation :: WootClient -> Operation -> WootClient
sendOperation (WootClient cid clock ws ops) op = WootClient cid clock ws' ops'
    where
      (ops', ws') = integrateAll (op:ops) ws


sendOperations :: WootClient -> [Operation] -> WootClient
sendOperations = foldl sendOperation


-- identical to sendOperation, but increments the clients internal clock
-- not exposed - consumers should use sendLocalDelete or sendLocalInsert
sendLocalOperation :: WootClient -> Operation -> WootClient
sendLocalOperation client = incClock . sendOperation client


-- note: failed local operations can result in no-ops if the underlying operation is invalid
-- they will not be added to a client's operation queue
-- the assumption is that anything done locally should already be verified
-- if the local operation was successful, the operation should be broadcasted to other clients
sendLocalDelete :: WootClient -> Int -> (Maybe Operation, WootClient)
sendLocalDelete client pos = (op,) $ maybe client (sendLocalOperation client) op
  where
    op = makeDeleteOperation (wootClientId client) pos (wootClientString client)


sendLocalInsert :: WootClient -> Int -> Char -> (Maybe Operation, WootClient)
sendLocalInsert client@(WootClient cid clock ws _) pos a =
    (op,) $ maybe client (sendLocalOperation client) op
  where
    op = makeInsertOperation cid clock pos a ws
