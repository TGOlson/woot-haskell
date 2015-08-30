module Data.Woot.WString.Builder where


import Data.Woot.WString
import Data.Woot.WChar


beginningCharClock :: Int
beginningCharClock = -1


endingCharClock :: Int
endingCharClock = -2


makeEmptyWString :: ClientId -> WString
makeEmptyWString cid = fromList
    [ WChar beginId False '_' Nothing        (Just endId)
    , WChar endId   False '_' (Just beginId) Nothing ]
  where
    beginId = WCharId cid beginningCharClock
    endId = WCharId cid endingCharClock
