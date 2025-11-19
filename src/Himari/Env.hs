{-# LANGUAGE TypeFamilies #-}

-- | Core environment monad for Himari.
module Himari.Env
  ( Himari (..)
  , runHimari
  , liftHimari
  , mapHimari
  ) where

import Himari.Prelude

-- | The Reader + IO monad.
-- It is nearly equal to `RIO`.
newtype Himari env a = Himari
  { unHimari :: ReaderT env IO a
  }
  deriving newtype (Applicative, Functor, Monad, MonadIO, MonadReader env, MonadThrow, MonadUnliftIO)

instance (Semigroup a) => Semigroup (Himari env a) where
  (<>) = liftA2 (<>)

instance (Monoid a) => Monoid (Himari env a) where
  mempty = pure mempty

instance PrimMonad (Himari env) where
  type PrimState (Himari env) = PrimState IO
  primitive = Himari . ReaderT . const . primitive

-- | Given an environment, runs the action that requires it in IO.
runHimari :: (MonadIO m) => env -> Himari env a -> m a
runHimari env (Himari (ReaderT f)) = liftIO (f env)

-- | Abstract `Himari` to an arbitrary `MonadReader` instance, which can handle IO.
liftHimari :: (MonadIO m, MonadReader env m) => Himari env a -> m a
liftHimari rio = do
  env <- ask
  runHimari env rio

-- | Lift one Himari env to another.
mapHimari :: (outer -> inner) -> Himari inner a -> Himari outer a
mapHimari f m = do
  outer <- ask
  runHimari (f outer) m
