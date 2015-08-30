module Data.Woot.Operation
    ( OperationType(..)
    , Operation(..)
    -- , makeOperation
    ) where


-- import Data.Woot.WString
import Data.Woot.WChar


data OperationType = Insert | Delete deriving (Eq, Show)


data Operation = Operation
    { operationType   :: OperationType
    , operationSiteId :: Int
    , operationWChar  :: WChar
    } deriving (Eq, Show)


-- makeDeleteOperation :: Int -> WChar -> Operation
-- makeDeleteOperation = Operation Delete
--
-- -- will throw an error if passed an operation with illegal indices
-- makeInsertOperation :: OperationType -> (Int, Int) -> Int -> Char -> WString -> Operation
-- makeInsertOperation Delete (sid, cid) index char ws = Operation opType sid wChar
-- makeOperation opType (sid, cid) index char ws = Operation opType sid wChar
--   where
--     wChar = WChar (WCharId sid cid) True char prevId nextId
--     prevId = undefined
--     nextId = undefined
