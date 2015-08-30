module Data.Woot
    ( WootClient
    , makeWootClient
    , makeWootClientEmpty
    , sendOperation
    ) where


import Data.Woot.WString.Builder
import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation


-- data OperationQueue = OperationQueue [Operation] -- should be a TMVar


-- do not expose constructor
data WootClient a = WootClient
    { _wootClientId             :: Int
    , _wootClientClock          :: Int
    , _wootClientString         :: WString -- should be a TMVar
    , _wootClientOperationQueue :: [Operation]
    , _wootClientOnChange       :: WString -> a
    }


makeWootClient :: ClientId -> (WString -> a) -> WString -> WootClient a
makeWootClient cid f ws = WootClient cid 0 ws [] f


makeWootClientEmpty :: ClientId -> (WString -> a) -> WootClient a
makeWootClientEmpty cid f = makeWootClient cid f $ makeEmptyWString cid


sendOperation :: WootClient a -> Operation -> a
-- get current operation queue
-- cons new operation to front
-- integrateAll opQueue currentString
-- invoke change handler
sendOperation = undefined

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
