module Data.Woot.WChar
    ( WChar(..)
    , WCharId(..)
    , ClientId
    , hide
    ) where


data WChar = WChar
    { wCharId      :: WCharId
    , wCharVisible :: Bool
    , wCharAlpha   :: Char
    , wCharPrevId  :: Maybe WCharId
    , wCharNextId  :: Maybe WCharId
    } deriving (Eq, Show)


type ClientId = Int


data WCharId = WCharId
    { wCharIdClientId :: ClientId
    , wCharIdClock    :: Int
    } deriving (Eq, Show)


instance Ord WCharId where
    compare = compareCharIds


compareCharIds :: WCharId -> WCharId -> Ordering
compareCharIds (WCharId cA iA) (WCharId cB iB) = compare (cA, iA) (cB, iB)


hide :: WChar -> WChar
hide (WChar wid _ a p n) = WChar wid False a p n
