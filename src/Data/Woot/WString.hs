module Data.Woot.WString
    ( WString(..)
    , fromList
    , isEmpty
    , length'
    , (!)
    , indexOf
    , hasChar
    , insertChar
    , hideChar
    , visibleChars
    , nthVisible
    , subsection
    ) where


import Data.Maybe (isJust)
import qualified Data.Vector as V

import Data.Woot.WChar


newtype WString = WString { wStringChars :: V.Vector WChar } deriving (Eq)


instance Show WString where
    show = toString


toString :: WString -> String
toString = V.toList . V.map wCharAlpha . wStringChars . visibleChars


fromList :: [WChar] -> WString
fromList = WString . V.fromList


isEmpty :: WString -> Bool
isEmpty = V.null . wStringChars


length' :: WString -> Int
length' = V.length . wStringChars


-- unsafe, make sure you know what you are doing
(!) :: WString -> Int -> WChar
(!) ws n= wStringChars ws V.! n


indexOf :: WCharId -> WString -> Maybe Int
indexOf wcid = V.findIndex ((==) wcid . wCharId) . wStringChars


hasChar :: WCharId -> WString -> Bool
hasChar wcid ws = isJust $ indexOf wcid ws


hideChar :: WCharId -> WString -> WString
hideChar wid ws@(WString wcs) = WString $
    maybe wcs (\i -> wcs V.// [(i, hide $ ws ! i)]) mindex
  where
    mindex = indexOf wid ws

-- insert before index i
-- insert 2 'x' "abc" -> abxc
insertChar :: Int -> WChar -> WString -> WString
insertChar i wc (WString wcs) = WString $ V.concat [V.take i wcs, V.singleton wc, V.drop i wcs]


visibleChars :: WString -> WString
visibleChars = WString . V.filter wCharVisible . wStringChars


-- equally unsafe
nthVisible :: Int -> WString -> WChar
nthVisible n = (! n) . visibleChars


subsection :: WCharId -> WCharId -> WString -> WString
subsection prev next ws = WString $ maybe V.empty slice indices
  where
    prevIndex = indexOf prev ws
    nextIndex = indexOf next ws
    indices = sequence [prevIndex, nextIndex]
    slice ([i, j]) = V.slice i (j - i) (wStringChars ws)
    -- should never reach this case since we own the indices coming in
    slice _ = V.empty
