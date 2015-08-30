module Data.Woot.Core where


import Data.Woot.WString
import qualified Data.Woot.WString as W
import Data.Woot.WChar
import Data.Woot.Operation


-- return the new WString on success, on failure returns an integration error
integrate :: Operation -> WString -> Either String WString
integrate op ws = if canIntegrate op ws then Right $ integrateOp op ws else integrationError
  where
    integrationError = Left "Cannot integrate. Operation should be added to a queue and retried."


integrateOp :: Operation -> WString -> WString
integrateOp (Operation Insert _ wc) ws = integrateInsert (wCharPrevId wc) (wCharNextId wc) wc ws
integrateOp (Operation Delete _ _) _ = undefined


integrateInsert :: Maybe WCharId -> Maybe WCharId -> WChar -> WString -> WString

-- if at the very start or end of the wString
integrateInsert Nothing _ wc ws = insert 1 wc ws
integrateInsert _ Nothing wc ws = insert (W.length ws - 2) wc ws

integrateInsert (Just prevId) (Just nextId) wc ws = if isEmpty sub
    -- should always be safe to get index and insert since we have flagged this as 'canIntegrate'
    -- but use a maybe anyways
    then maybe ws (\i -> insert i wc ws) $ indexOf nextId ws
    else compareIds [prevId, nextId]
  where
    sub = subsection prevId nextId ws

    compareIds :: [WCharId] -> WString
    -- current id is less than the previous id
    -- is this possible? or should we only look at subsection
    compareIds (prevId':_) | wCharId wc < prevId' = maybe ws (\i -> insert i wc ws) $ indexOf prevId' ws
     -- recurse to integrateInsert with next id in the subsection
    compareIds (_:i:_) = integrateInsert (Just i) (Just nextId) wc ws
    -- should next have a pattern fall through to here
    -- but for good measure...
    compareIds _  = ws


canIntegrate :: Operation -> WString -> Bool
canIntegrate (Operation Insert _ wc) ws = all (\(Just wid) -> wid `hasWChar` ws) [wCharPrevId wc, wCharNextId wc]
canIntegrate (Operation Delete _ wc) ws = hasWChar (wCharId wc) ws
