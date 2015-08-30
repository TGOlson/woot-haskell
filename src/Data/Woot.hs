module Data.Woot
    ( WootClient
    , makeWootClient
    , makeWootClientEmpty
    , sendOperation
    , sendOperations
    , sendLocalDelete
    , sendLocalInsert
    , wootClientString
    ) where


import Data.Woot.WString.Builder
import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation
import Data.Woot.Core


-- data OperationQueue = OperationQueue [Operation] -- should be a TMVar


-- do not expose constructor
data WootClient = WootClient
    { wootClientId             :: Int
    , wootClientClock          :: Int
    , wootClientString         :: WString
    , wootClientOperationQueue :: [Operation]
    }

-- data WootClientMutable = WootClientMutable
--     { wootClientId             :: Int
--     , wootClientClock          :: Int
--     , wootClientString         :: IO WString
--     , wootClientOperationQueue :: IO [Operation]
--     }



makeWootClient :: ClientId -> WString -> WootClient
makeWootClient cid ws = WootClient cid 0 ws []


makeWootClientEmpty :: ClientId -> WootClient
makeWootClientEmpty cid = makeWootClient cid $ makeEmptyWString cid


-- note: local operations can throw index error if passed illegal indicies
sendLocalDelete :: Int -> WootClient -> WootClient
sendLocalDelete pos client = sendOperation op client
  where
    op = Operation Delete (wootClientId client) $ hide (nthVisible pos $ wootClientString client)

-- TODO: increment clocks on both local ops ^^^ \/ \/

sendLocalInsert :: Int -> Char -> WootClient -> WootClient
sendLocalInsert pos a client@(WootClient cid clock ws _) = sendOperation op client
  where
    op = Operation Insert cid char
    char = WChar (WCharId cid clock) True a (Just $ wCharId prev) (Just $ wCharId next)
    prev = nthVisible (pos - 1) ws
    next = nthVisible pos ws


sendOperation :: Operation -> WootClient -> WootClient
sendOperation op (WootClient cid clock ws ops) = WootClient cid clock ws' ops'
    where
      (ops', ws') = integrateAll (op:ops) ws


sendOperations :: [Operation] -> WootClient -> WootClient
sendOperations ops client = foldl (flip sendOperation) client ops
    -- where
      -- (ops', ws') = integrateAll (op:ops) ws


-- makeWootClientMutable :: WootClient IO

-- sendOperationMutable :: Operation -> WootClient IO -> IO ()



-- Haskell server is a passive peer in the process
-- only needs a remote integration function

-- https://github.com/kroky/woot/blob/master/src/woot.coffee
-- https://bitbucket.org/d6y/woot

-- Might be best served as an evented JS library
-- Could be used on both client and server
-- Woot.onChange((newModel) -> ...)


-- handleOperation :: [WChar] -> Operation -> [WChar]

-- onRemoteOperation :: Operation -> IO ()
-- onRemoteOperation op = do
  -- chars <- readVar charRef
  -- newChars = handleOperation chars op
  -- writeVar charRef newChars

-- POST /operation -> onRemoteOperation

-- https://hackage.haskell.org/package/websockets-0.9.5.0/docs/Network-WebSockets.html
-- receiveDataMessage connection -> onRemoteOperation

-- runStatefulWootClient ::
