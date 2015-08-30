module Data.Woot.Core
    ( integrate
    , integrateAll
    ) where


import Data.Woot.WString
import Data.Woot.WChar
import Data.Woot.Operation


integrate :: Operation -> WString -> Maybe WString
integrate op ws = if canIntegrate op ws then Just $ integrateOp op ws else Nothing


-- iterate through operation list until stable
-- return any remaining operations, along with new string
integrateAll :: [Operation] -> WString -> ([Operation], WString)
integrateAll = undefined


canIntegrate :: Operation -> WString -> Bool
canIntegrate (Operation Insert _ wc) ws = all (\(Just wid) -> wid `hasChar` ws) [wCharPrevId wc, wCharNextId wc]
canIntegrate (Operation Delete _ wc) ws = hasChar (wCharId wc) ws


integrateOp :: Operation -> WString -> WString
-- do we need site id here?
integrateOp (Operation Insert _ wc) ws = integrateInsert (wCharPrevId wc) (wCharNextId wc) wc ws
integrateOp (Operation Delete _ wc) ws = integrateDelete wc ws


integrateInsert :: Maybe WCharId -> Maybe WCharId -> WChar -> WString -> WString
-- if at the very start or end of the wString
integrateInsert Nothing _ wc ws = insertChar 1 wc ws
integrateInsert _ Nothing wc ws = insertChar (lengthW ws - 2) wc ws

integrateInsert (Just prevId) (Just nextId) wc ws = if isEmpty sub
    -- should always be safe to get index and insert since we have flagged this as 'canIntegrate'
    -- but use a maybe anyways
    then maybe ws (\i -> insertChar i wc ws) $ indexOf nextId ws
    else compareIds [prevId, nextId]
  where
    sub = subsection prevId nextId ws

    compareIds :: [WCharId] -> WString
    -- current id is less than the previous id
    -- is this possible? or should we only look at subsection
    compareIds (prevId':_) | wCharId wc < prevId' = maybe ws (\i -> insertChar i wc ws) $ indexOf prevId' ws
     -- recurse to integrateInsert with next id in the subsection
    compareIds (_:i:_) = integrateInsert (Just i) (Just nextId) wc ws
    -- should next have a pattern fall through to here
    -- but for good measure...
    compareIds _  = ws


integrateDelete :: WChar -> WString -> WString
integrateDelete wc = hideChar (wCharId wc)
