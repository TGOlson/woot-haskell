module Data.Woot.Operation where


import Data.Woot.WChar


data OperationType = Insert | Delete


data Operation = Operation
    { operationType   :: OperationType
    , operationSiteId :: Int
    , operationWChar  :: WChar
    }
