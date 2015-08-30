module Data.Woot.WStringSpec where

import Data.Vector

import Data.Woot.WChar
import Data.Woot.WString
import Test.Hspec

main :: IO ()
main = hspec spec

-- dummyWChar ::

dummyWString :: WString
dummyWString = WString $ fromList [
      WChar (WCharId 0 (-2)) False '_' Nothing                 (Just $ WCharId 0 1)
    , WChar (WCharId 0 0)    True  'b' (Just $ WCharId 0 (-1)) (Just $ WCharId 0 1)
    , WChar (WCharId 0 1)    False 'x' (Just $ WCharId 0 0)    (Just $ WCharId 0 2)
    , WChar (WCharId 0 2)    True  'a' (Just $ WCharId 0 1)    (Just $ WCharId 0 3)
    , WChar (WCharId 0 3)    True  'r' (Just $ WCharId 0 2)    (Just $ WCharId 0 (-2))
    , WChar (WCharId 0 (-1)) False '_' (Just $ WCharId 0 2)    Nothing
    ]

spec :: Spec
spec =
    describe "WString" $ do
        describe "show" $
            it "should convert a woot string to a generic string" $
                show dummyWString `shouldBe` "bar"

        describe "nthVisible" $
            it "should return the nth visible char" $
                fmap wCharAlpha (nthVisible 1 dummyWString) `shouldBe` Just 'a'

        describe "insert" $
            it "should insert a character before the specified index" $
                let newChar = WChar (WCharId 0 4) True  'P' (Just $ WCharId 0 1) (Just $ WCharId 0 2) in
                show (insert 4 newChar dummyWString) `shouldBe` "baPr"

        describe "subsection" $
            it "should return a subsection specified by the provided ids" $ do
                -- let newChar = WChar (WCharId 0 4) True  'P' (Just $ WCharId 0 1) (Just $ WCharId 0 2) in
                show (subsection (WCharId 5 5) (WCharId 7 7) dummyWString) `shouldBe` ""
                show (subsection (WCharId 0 1) (WCharId 0 (-1)) dummyWString) `shouldBe` "ar"
