module Data.Woot.WString
    ( WString(..)
    , isEmpty
    , lengthW
    , insertChar
    , hasChar
    , hideChar
    , indexOf
    , subsection
    , fromList
    , nthVisible
    ) where


import Data.Maybe (isJust)
import Data.Vector ((//), (!))
import qualified Data.Vector as V

import Data.Woot.WChar


newtype WString = WString { wStringChars :: V.Vector WChar } deriving (Eq)


instance Show WString where
    show = toString


toString :: WString -> String
toString = V.toList . V.map wCharAlpha . visibleWChars


-- emptyWString :: WString
-- emptyWString = WString V.empty
fromList :: [WChar] -> WString
fromList = WString . V.fromList

isEmpty :: WString -> Bool
isEmpty = V.null . wStringChars


lengthW :: WString -> Int
lengthW = V.length . wStringChars


visibleWChars :: WString -> V.Vector WChar
visibleWChars = V.filter wCharVisible . wStringChars


-- this is used for local integration only
-- locally we only deal with visible chars (insert at x, delete y)

nthVisible :: Int -> WString -> WChar
nthVisible n wcs = visibleWChars wcs ! n


-- insert before index i
-- insert 2 'x' "abc" -> abxc
insertChar :: Int -> WChar -> WString -> WString
insertChar i wc (WString wcs) = WString $ V.concat [V.take i wcs, V.singleton wc, V.drop i wcs]


hideChar :: WCharId -> WString -> WString
hideChar wid ws@(WString wcs) = WString $ maybe wcs (\i -> wcs // [(i, hide $ wcs ! i)]) mindex
  where
    mindex = indexOf wid ws


indexOf :: WCharId -> WString -> Maybe Int
indexOf wcid = V.findIndex ((==) wcid . wCharId) . wStringChars


hasChar :: WCharId -> WString -> Bool
hasChar wcid ws = isJust $ indexOf wcid ws


subsection :: WCharId -> WCharId -> WString -> WString
subsection prev next ws = WString $ maybe V.empty slice indices
  where
    prevIndex = indexOf prev ws
    nextIndex = indexOf next ws
    indices = sequence [prevIndex, nextIndex]
    slice ([i, j]) = V.slice i (j - i) (wStringChars ws)
    -- should never reach this case since we own the indices coming in
    slice _ = V.empty
