module Data.Woot.Operation
    ( OperationType(..)
    , Operation(..)
    ) where


import Data.Woot.WChar


data OperationType = Insert | Delete deriving (Eq, Show)


data Operation = Operation
    { operationType     :: OperationType
    , operationClientId :: Int
    , operationWChar    :: WChar
    } deriving (Eq, Show)
