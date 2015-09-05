module Data.Woot.WString
    ( WString(..)
    , fromList
    , toList
    , isEmpty
    , length'
    , (!?)
    , indexOf
    , hasChar
    , insertChar
    , hideChar
    , visibleChars
    , nthVisible
    , subsection
    ) where


import Data.Maybe (isJust, fromMaybe)
import qualified Data.Vector as V

import Data.Woot.WChar


newtype WString = WString { wStringChars :: V.Vector WChar } deriving (Eq)


instance Show WString where
    show = map wCharAlpha . toList . visibleChars


fromList :: [WChar] -> WString
fromList = WString . V.fromList


toList :: WString -> [WChar]
toList = V.toList . wStringChars


isEmpty :: WString -> Bool
isEmpty = V.null . wStringChars


length' :: WString -> Int
length' = V.length . wStringChars


-- unsafe, make sure you know what you are doing
(!) :: WString -> Int -> WChar
(!) ws n = wStringChars ws V.! n


(!?) :: WString -> Int -> Maybe WChar
(!?) ws n = wStringChars ws V.!? n


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


nthVisible :: Int -> WString -> Maybe WChar
nthVisible n = (!? n) . visibleChars


subsection :: WCharId -> WCharId -> WString -> WString
subsection prev next ws = WString . fromMaybe V.empty $ do
    i <- indexOf prev ws
    j <- indexOf next ws
    return $ slice' i (j - i) (wStringChars ws)
  where
    -- safe version of slice - returns empty when passed illegal indices
    slice' i n = V.take n . V.drop i
