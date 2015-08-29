module Woot.Operation where

import Woot.WChar

data OperationType = Insert | Delete

data Operation = Operation
  { operationType   :: OperationType
  , operationSiteId :: Int
  , operationWChar  :: WChar
  }
