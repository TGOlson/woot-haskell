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
            let result = sendOperation wootClient validInsertOp
            show (wootClientString result) `shouldBe` "baqr"

        it "should queue failed operations to try later" $ do
            let client = sendOperation wootClient invalidDeleteOp
            show (wootClientString client) `shouldBe` "bar"
            let client' = sendOperation client validInsertToValidateDelete
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

            let client = sendOperations wootClient ops
            show (wootClientString client) `shouldBe` "aq#rW"

    describe "sendLocalInsert" $ do
        it "should insert a new character" $ do
            let (_, client) = sendLocalInsert (makeWootClientEmpty 0) 0 'T'
            let (_, client') = sendLocalInsert client 1 'y'
            show (wootClientString client') `shouldBe` "Ty"

        it "should increment the client clock" $ do
            let (_, client) = sendLocalInsert (makeWootClientEmpty 0) 0 'T'
            let (_, client') = sendLocalInsert client 1 'y'
            wootClientClock client' `shouldBe` 2

        it "should return the original client when passed an invalid position" $ do
            let (_, client) = sendLocalInsert wootClient 100 'x'
            client `shouldBe` wootClient

    describe "sendLocalDelete" $ do
        it "should delete a character" $ do
            let (_, client) = sendLocalDelete wootClient 2
            let (_, client') = sendLocalDelete client 1
            show (wootClientString client') `shouldBe` "b"

        it "should increment the client clock" $ do
            let (_, client) = sendLocalDelete wootClient 2
            let (_, client') = sendLocalDelete client 1
            wootClientClock client' `shouldBe` 2

        it "should return the original client when passed an invalid position" $ do
            let (_, client) = sendLocalDelete wootClient 100
            client `shouldBe` wootClient
