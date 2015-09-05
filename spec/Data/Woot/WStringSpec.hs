module Data.Woot.WStringSpec where


import MockData (mockWString)

import Data.Woot.WChar
import Data.Woot.WString
import Test.Hspec


spec :: Spec
spec = do
    describe "show" $
        it "should convert a woot string to a generic string" $
            show mockWString `shouldBe` "bar"

    describe "insertChar" $
        it "should insert a character before the specified index" $
            let newChar = WChar (WCharId 0 4) True  'P' (Just $ WCharId 0 1) (Just $ WCharId 0 2) in
            show (insertChar 4 newChar mockWString) `shouldBe` "baPr"

    describe "subsection" $ do
        it "should return a subsection specified by the provided ids" $ do
            show (subsection (WCharId 5 5) (WCharId 7 7) mockWString) `shouldBe` ""
            show (subsection (WCharId 0 1) (WCharId 0 (-1)) mockWString) `shouldBe` "ar"

        it "should return nothing when passed valid ids that produce an invalid splice" $
            show (subsection (WCharId 0 (-1)) (WCharId 0 1) mockWString) `shouldBe` ""
