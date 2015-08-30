module Data.Woot where


import Data.Woot.WString
import Data.Woot.Operation


data OperationQueue = OperationQueue [Operation] -- should be a TMVar


-- do not expose constructor
data WootHandler a = WootHandler
    { wootHandlerString         :: WString -- should be a TMVar
    , wootHandlerOperationQueue :: OperationQueue
    , wootHandlerOnChange       :: WString -> a
    }

-- does this need to be exposed? maybe register?
-- makeWootHandler :: (WString -> a) -> WootHandler a
-- makeWootHandler = WootHandler emptyWString (OperationQueue [])


sendOperation :: WootHandler a -> Operation -> a
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
