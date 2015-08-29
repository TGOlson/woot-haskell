-- integrations operations into a WString
-- find a better place for this
module Integrate where

import Woot.WString
import Woot.WChar
import Woot.Operation

-- return the new WString on success, on failure returns an integration error
integrate :: Operation -> WString -> Either String WString
integrate op ws = if canIntegrate op ws then undefined else integrationError
  where
    integrationError = Left $ "Cannot integrate. Operation should be added to a queue and retried."

integrateOp :: Operation -> WString -> WString
integrateOp (Operation Insert _ wc) ws = integrateInsert wc ws
integrateOp (Operation Delete _ _) ws = undefined


integrateInsert :: WChar -> WString -> WString
integrateInsert wc ws = if isEmpty sub then maybeInsert (indexOf (wCharNextId wc) ws) wc ws else undefined
  where
    sub = subsection (wCharPrevId wc) (wCharNextId wc) ws
    -- should always be safe to get index and insert since we have flagged this as 'canIntegrate'
    maybeInsert mi wc ws = maybe ws (\i -> insert i wc ws) mi

canIntegrate :: Operation -> WString -> Bool
canIntegrate (Operation Insert sid wc) ws = undefined
canIntegrate (Operation Delete _ wc) ws = hasWChar wc ws
