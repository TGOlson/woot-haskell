module Data.Woot
    ( WootClient
    , wootClientId
    , wootClientClock
    , wootClientString
    , makeWootClient
    , makeWootClientEmpty
    , sendOperation
    , sendOperations
    , sendLocalDelete
    , sendLocalInsert
    , WString
    ) where


import Data.Woot.WString.Builder
import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation
import Data.Woot.Core


-- do not expose constructor
data WootClient = WootClient
    { wootClientId              :: Int
    , wootClientClock           :: Int
    , wootClientString          :: WString
    , _wootClientOperationQueue :: [Operation]
    }


incClock :: WootClient -> WootClient
incClock (WootClient cid clock ws ops) = WootClient cid (clock + 1) ws ops


makeWootClient :: ClientId -> WString -> WootClient
makeWootClient cid ws = WootClient cid 0 ws []


makeWootClientEmpty :: ClientId -> WootClient
makeWootClientEmpty cid = makeWootClient cid $ makeEmptyWString cid


-- note: local operations can throw index error if passed illegal indicies
-- the assumption is anything done locally should be passed off a tangible visible string
sendLocalDelete :: Int -> WootClient -> WootClient
sendLocalDelete pos client = incClock $ sendOperation op client
  where
    op = Operation Delete (wootClientId client) $
        hide (nthVisible pos $ wootClientString client)


sendLocalInsert :: Int -> Char -> WootClient -> WootClient
sendLocalInsert pos a client@(WootClient cid clock ws _) = incClock $ sendOperation op client
  where
    op = Operation Insert cid char
    char = WChar (WCharId cid clock) True a (Just $ wCharId prev) (Just $ wCharId next)
    prev = if pos == 0 then ws ! 0 else nthVisible (pos - 1) ws
    next = if pos >= numVis then ws ! (length' ws - 1) else nthVisible pos ws
    numVis = length' $ visibleChars ws


sendOperation :: Operation -> WootClient -> WootClient
sendOperation op (WootClient cid clock ws ops) = WootClient cid clock ws' ops'
    where
      (ops', ws') = integrateAll (op:ops) ws


sendOperations :: [Operation] -> WootClient -> WootClient
sendOperations ops client = foldl (flip sendOperation) client ops
