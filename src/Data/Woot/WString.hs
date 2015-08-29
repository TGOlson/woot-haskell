module Data.Woot.WString where


import Data.Maybe (isJust)
import Data.Vector ((!?))
import qualified Data.Vector as V

import Data.Woot.WChar


data WString = WString (V.Vector WChar)

instance Show WString where
    show = toString


toString :: WString -> String
toString = V.toList . V.map wCharAlpha . visibleWChars


emptyWString :: WString
emptyWString = WString V.empty


isEmpty :: WString -> Bool
isEmpty (WString wcs) = V.null wcs


visibleWChars :: WString -> V.Vector WChar
visibleWChars (WString wcs) = V.filter wCharVisible wcs


nthVisible :: Int -> WString -> Maybe WChar
nthVisible n wcs = visibleWChars wcs !? n


-- insert before index i
-- insert 2 'x' "abc" -> abxc
insert :: Int -> WChar -> WString -> WString
insert i wc (WString wcs) = WString $ V.concat [front, V.singleton wc, back]
  where
    front = V.take i wcs
    back = V.drop i wcs
    -- parts = V.splitAt i wcs


indexOf :: WCharId -> WString -> Maybe Int
indexOf wcid (WString wcs) = V.findIndex ((==) wcid . wCharId) wcs

hasWChar :: WCharId -> WString -> Bool
hasWChar wcid ws = isJust $ indexOf wcid ws


subsection :: WCharId -> WCharId -> WString -> WString
subsection prev next ws@(WString wcs) = WString $ maybe V.empty slice indices
  where
    prevIndex = indexOf prev ws
    nextIndex = indexOf next ws
    indices = sequence [prevIndex, nextIndex]
    slice ([i, j]) = V.slice i j wcs
    -- should never reach this case since we own the indices coming in
    slice _ = V.empty
