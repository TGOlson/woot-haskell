module SpecHelper where


import Test.Hspec


shouldShowJust :: Show a => Maybe a -> String -> Expectation
shouldShowJust a str = fmap show a `shouldBe` Just str
