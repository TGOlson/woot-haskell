module Woot
  ( module Woot.WString
  , module Woot.WChar
  ) where

import Woot.WString
import Woot.WChar

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
