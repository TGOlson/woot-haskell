module Data.Woot.WCharSpec where

import Data.Woot.WChar
import Test.Hspec

main :: IO ()
main = hspec spec


spec :: Spec
spec =
    describe "WChar" $
        it "should know how to order char ids" $ do
            compare (WCharId 1 1) (WCharId 1 1) `shouldBe` EQ

            -- different site ids
            compare (WCharId 1 1) (WCharId 2 1) `shouldBe` LT
            compare (WCharId 2 1) (WCharId 1 1) `shouldBe` GT

            -- different incremental values
            compare (WCharId 1 1) (WCharId 1 2) `shouldBe` LT
            compare (WCharId 1 2) (WCharId 1 1) `shouldBe` GT
