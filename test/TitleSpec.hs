{-# LANGUAGE OverloadedStrings #-}

module TitleSpec (spec) where

import Data.List.NonEmpty qualified as NE
import Himari
import Himari.Title
import Test.Syd

spec :: Spec
spec = do
  describe "titleComponents" $ do
    it "最初の要素が「超」であること" $ do
      NE.head titleComponents `shouldBe` "超"

    it "6つの要素を持つこと" $ do
      length titleComponents `shouldBe` 6

  describe "generateAllCombinations" $ do
    it "空でないリストを生成すること" $ do
      generateAllCombinations `shouldNotSatisfy` null

    it "各組み合わせが空でないこと" $ do
      any null generateAllCombinations `shouldBe` False

  describe "renderTitle" $ do
    it "単一要素の肩書きを正しく変換すること" $ do
      renderTitle ("超" NE.:| []) `shouldBe` "超"

    it "複数要素の肩書きを連結すること" $ do
      renderTitle ("超" NE.:| ["天才"]) `shouldBe` "超天才"

    it "全要素を連結すること" $ do
      renderTitle titleComponents `shouldBe` "超天才清楚系病弱美少女ハッカー"
