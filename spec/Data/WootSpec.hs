module Data.WootSpec where

import MockData

import Data.Woot
import Test.Hspec

main :: IO ()
main = hspec spec


wootClient :: WootClient
wootClient = makeWootClient 0 mockWString


spec :: Spec
spec =
    describe "Woot" $
        describe "sendOperation" $ do
            it "should pass an operation to the woot client and return the result" $ do
                let result = sendOperation validInsertOp wootClient
                show (wootClientString result) `shouldBe` "baqr"

            it "should queue failed operations to try later" $ do
                let client = sendOperation invalidDeleteOp wootClient
                show (wootClientString client) `shouldBe` "bar"
                let client' = sendOperation validInsertToValidateDelete client
                show (wootClientString client') `shouldBe` "bar" -- would be "bMar" if original delete didnt go
