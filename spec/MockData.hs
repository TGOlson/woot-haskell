module MockData where


import Data.Woot.Operation
import Data.Woot.WChar
import Data.Woot.WString


mockWString :: WString
mockWString = fromList [
      WChar (WCharId 0 (-2)) False '_' Nothing                 (Just $ WCharId 0 1)
    , WChar (WCharId 0 0)    True  'b' (Just $ WCharId 0 (-1)) (Just $ WCharId 0 1)
    , WChar (WCharId 0 1)    False 'x' (Just $ WCharId 0 0)    (Just $ WCharId 0 2)
    , WChar (WCharId 0 2)    True  'a' (Just $ WCharId 0 1)    (Just $ WCharId 0 3)
    , WChar (WCharId 0 3)    True  'r' (Just $ WCharId 0 2)    (Just $ WCharId 0 (-2))
    , WChar (WCharId 0 (-1)) False '_' (Just $ WCharId 0 2)    Nothing
    ]


validInsertOp :: Operation
validInsertOp = Operation Insert 0
    (WChar (WCharId 0 10) True 'q' (Just $ WCharId 0 2) (Just $ WCharId 0 3))


validInsertOpAmbiguous :: Operation
validInsertOpAmbiguous = Operation Insert 0
    (WChar (WCharId 1 0) True 'W' (Just $ WCharId 0 (-2)) (Just $ WCharId 0 (-1)))


invalidInsertOp :: Operation
invalidInsertOp = Operation Insert 0
    (WChar (WCharId 0 10) True 'q' (Just $ WCharId 0 10) (Just $ WCharId 0 20))



validDeleteOp :: Operation
validDeleteOp = Operation Delete 0
    (WChar (WCharId 0 0) True 'b' (Just $ WCharId 0 (-1)) (Just $ WCharId 0 1))


invalidDeleteOp :: Operation
invalidDeleteOp = Operation Delete 0
    (WChar (WCharId 0 50) True 'M' (Just $ WCharId 0 (-1)) (Just $ WCharId 0 1))


validInsertToValidateDelete :: Operation
validInsertToValidateDelete = Operation Insert 0
    (WChar (WCharId 0 50) True 'M' (Just $ WCharId 0 0) (Just $ WCharId 0 2))
