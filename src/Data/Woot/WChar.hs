module Data.Woot.WChar
    ( WChar(..)
    , WCharId(..)
    , hide
    ) where


data WChar = WChar
    { wCharId      :: WCharId
    , wCharVisible :: Bool
    , wCharAlpha   :: Char
    , wCharPrevId  :: Maybe WCharId
    , wCharNextId  :: Maybe WCharId
    } deriving (Eq)


data WCharId = WCharId
    { wCharIdHostId :: Int
    , wCharIdClock  :: Int
    } deriving (Eq)


instance Ord WCharId where
    compare = compareCharIds


compareCharIds :: WCharId -> WCharId -> Ordering
compareCharIds (WCharId sA iA) (WCharId sB iB) = compare (sA, iA) (sB, iB)


hide :: WChar -> WChar
hide (WChar wid _ a p n) = WChar wid False a p n
