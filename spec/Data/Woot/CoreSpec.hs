module Data.Woot.CoreSpec where


import MockData (mockWString
               , validInsertOp
               , invalidInsertOp
               , validInsertOpAmbiguous
               , validDeleteOp
               , invalidDeleteOp)

import Data.Woot.Core
import Test.Hspec


main :: IO ()
main = hspec spec


spec :: Spec
spec =
    describe "Core" $
        describe "integrate" $ do
            it "should integrate an operation into the string if given a valid op" $ do
                fmap show (integrate validInsertOp mockWString) `shouldBe` Just "baqr"
                fmap show (integrate validInsertOpAmbiguous mockWString) `shouldBe` Just "barW"
                fmap show (integrate validDeleteOp mockWString) `shouldBe` Just "ar"

            it "should not integrate an operation if given an invalid op" $ do
                integrate invalidInsertOp mockWString `shouldBe` Nothing
                integrate invalidDeleteOp mockWString `shouldBe` Nothing
