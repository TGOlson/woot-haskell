module Data.Woot.WChar where


data WChar = WChar
    { wCharId      :: WCharId
    , wCharVisible :: Bool
    , wCharAlpha   :: Char
    , wCharPrevId  :: WCharId
    , wCharNextId  :: WCharId
    } deriving (Eq)


-- host id and incremental num
data WCharId = WCharId Int Int deriving (Eq)


instance Ord WCharId where
    compare = compareWCharIds


compareWCharIds :: WCharId -> WCharId -> Ordering
compareWCharIds (WCharId sidA _) (WCharId sidB _) | sidA /= sidB = compare sidA sidB
compareWCharIds (WCharId _ incA) (WCharId _ incB) = compare incA incB
