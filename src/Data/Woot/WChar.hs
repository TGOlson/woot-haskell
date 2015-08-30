module Data.Woot.WChar where


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
    compare = compareWCharIds


compareWCharIds :: WCharId -> WCharId -> Ordering
compareWCharIds (WCharId sA iA) (WCharId sB iB) = compare (sA, iA) (sB, iB)
