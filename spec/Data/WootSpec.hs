module Data.WootSpec where

import MockData

import Data.Woot
import Test.Hspec


wootClient :: WootClient
wootClient = makeWootClient mockWString 0


spec :: Spec
spec = do
    describe "sendOperation" $ do
        it "should pass an operation to the woot client and return the result" $ do
            let result = sendOperation validInsertOp wootClient
            show (wootClientString result) `shouldBe` "baqr"

        it "should queue failed operations to try later" $ do
            let client = sendOperation invalidDeleteOp wootClient
            show (wootClientString client) `shouldBe` "bar"
            let client' = sendOperation validInsertToValidateDelete client
            show (wootClientString client') `shouldBe` "bar" -- would be "bMar" if original delete didnt go

    describe "sendOperations" $
        it "should process a queue of operations" $ do
            let ops = [ validInsertOp
                      -- will become valid after validInsertToValidateDelete
                      , validInsertAfterQueuedInsert
                      , validInsertOpAmbiguous
                      , invalidInsertOp
                      , validDeleteOp
                      -- will become valid after validInsertToValidateDelete
                      , invalidDeleteOp
                      -- will make invalid delete operation valid
                      , validInsertToValidateDelete
                      ]

            let client = sendOperations ops wootClient
            show (wootClientString client) `shouldBe` "aq#rW"

    describe "sendLocalInsert" $ do
        it "should insert a new character" $ do
            let client = sendLocalInsert 0 'T' $ makeWootClientEmpty 0
            let client' = sendLocalInsert 1 'y' client
            show (wootClientString client') `shouldBe` "Ty"

        it "should increment the client clock" $ do
            let client = sendLocalInsert 0 'T' $ makeWootClientEmpty 0
            let client' = sendLocalInsert 1 'y' client
            wootClientClock client' `shouldBe` 2

    describe "sendLocalDelete" $ do
        it "should delete a character" $ do
            let client = sendLocalDelete 2 wootClient
            let client' = sendLocalDelete 1 client
            show (wootClientString client') `shouldBe` "b"

        it "should increment the client clock" $ do
            let client = sendLocalDelete 2 wootClient
            let client' = sendLocalDelete 1 client
            wootClientClock client' `shouldBe` 2
