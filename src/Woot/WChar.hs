module Woot.WChar where

-- import Data.Maybe

data WChar = WChar
  { wCharId      :: WCharId
  , wCharVisible :: Bool
  , wCharAlpha   :: Char
  , wCharPrevId  :: WCharId
  , wCharNextId  :: WCharId
  } deriving (Eq)

-- isBeginningChar :: WChar -> Bool
-- isBeginningChar = isNothing . wCharPrev
--
-- isEndingChar :: WChar -> Bool
-- isEndingChar = isNothing . wCharNext

-- host id and incremental num
data WCharId = WCharId (Int, Int) deriving (Eq)

-- setVisibility
-- lense?
