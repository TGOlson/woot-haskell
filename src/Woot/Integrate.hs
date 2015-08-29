-- integrations operations into a WString
-- find a better place for this
-- should be moved to Woot.Core
module Woot.Integrate where

import Woot.WString
import Woot.WChar
import Woot.Operation

-- return the new WString on success, on failure returns an integration error
integrate :: Operation -> WString -> Either String WString
integrate op ws = if canIntegrate op ws then Right $ integrateOp op ws else integrationError
  where
    integrationError = Left "Cannot integrate. Operation should be added to a queue and retried."

integrateOp :: Operation -> WString -> WString
integrateOp (Operation Insert _ wc) ws = integrateInsert (wCharPrevId wc) (wCharNextId wc) wc ws
integrateOp (Operation Delete _ _) _ = undefined


integrateInsert :: WCharId -> WCharId -> WChar -> WString -> WString
integrateInsert prevId nextId wc ws = if isEmpty sub
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
    compareIds (_:i:_) = integrateInsert i nextId wc ws
    -- should next have a pattern fall through to here
    -- but for good measure...
    compareIds _  = ws


canIntegrate :: Operation -> WString -> Bool
canIntegrate (Operation Insert _ wc) ws = all (`hasWChar` ws) [wCharPrevId wc, wCharNextId wc]
canIntegrate (Operation Delete _ wc) ws = hasWChar (wCharId wc) ws
