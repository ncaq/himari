{-# LANGUAGE OverloadedStrings #-}

-- | Tests for functor-related re-exports in Himari.Prelude.
module Himari.Prelude.FunctorSpec (spec) where

import Data.Text qualified as T
import Himari
import Test.Syd

spec :: Spec
spec = do
  describe "Data.Bifunctor" $ do
    it "bimap is available and works correctly" $ do
      bimap (+ 1) (* 2) (Left 5 :: Either Int Int) `shouldBe` Left 6
      bimap (+ 1) (* 2) (Right 3 :: Either Int Int) `shouldBe` Right 6

    it "bifunctorインスタンスが使える" $ do
      bimap (convert . show) T.length (42 :: Int, "hello") `shouldBe` ("42" :: Text, 5 :: Int)

  describe "Data.Functor.Const" $ do
    it "Const functor is available" $ do
      let x = Const 42 :: Const Int Text
      getConst x `shouldBe` (42 :: Int)

    it "Const functor maps correctly (ignores function)" $ do
      let x = Const 42 :: Const Int Text
      let y = fmap (const ("ignored" :: Text)) x
      getConst y `shouldBe` (42 :: Int)

  describe "Data.Functor.Identity" $ do
    it "Identity functor is available" $ do
      let x = Identity (42 :: Int)
      runIdentity x `shouldBe` (42 :: Int)

    it "Identity functor maps correctly" $ do
      let x = Identity (5 :: Int)
      let y = fmap (* 2) x
      runIdentity y `shouldBe` (10 :: Int)

    it "Identity applicative works" $ do
      let f = Identity ((+ 1) :: Int -> Int)
      let x = Identity (10 :: Int)
      runIdentity (f <*> x) `shouldBe` (11 :: Int)
