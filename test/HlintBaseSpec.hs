module HlintBaseSpec (spec) where

import Himari
import HlintRunner
import Test.Syd

spec :: Spec
spec = do
  describe "hlint base library rules" . withSample "BasePartial.hs" $ do
    describe "Data.List partial functions" $ do
      itWithOuter "head through Himari should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useHead" "head" "headMay"

      itWithOuter "Data.List.head should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useHeadQualified" "L.head" "headMay"

    describe "NonEmpty.head should be safe" $ do
      itWithOuter "Data.List.NonEmpty.head should NOT warn (it's safe)" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useNonEmptyHead"

    describe "Debug.Trace functions suggest pTrace*" $ do
      itWithOuter "Debug.Trace.trace should suggest pTrace" $ \sample ->
        shouldSuggestIn sample "useTrace" "Use pTrace"

      itWithOuter "Debug.Trace.traceShow should suggest pTraceShow" $ \sample ->
        shouldSuggestIn sample "useTraceShow" "Use pTraceShow"

      itWithOuter "Debug.Trace.traceM should suggest pTraceM" $ \sample ->
        shouldSuggestIn sample "useTraceM" "Use pTraceM"

    describe "Numeric integer-showing functions are partial" $ do
      itWithOuter "showHex should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowHex" "showHex" "non-negative"

      itWithOuter "showInt should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowInt" "showInt" "non-negative"

      itWithOuter "showOct should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowOct" "showOct" "non-negative"

      itWithOuter "showBin should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowBin" "showBin" "non-negative"

      itWithOuter "showIntAtBase should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowIntAtBase" "showIntAtBase" "base > 1"

    describe "Data.Char partial functions" $ do
      itWithOuter "intToDigit should warn (partial function)" $ \sample ->
        shouldWarnFunction sample "useShowIntAtBase" "intToDigit" "intToDigitMay"
