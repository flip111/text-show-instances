{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
Module:      TextShow.Data.Bifunctor
Copyright:   (C) 2014-2017 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

Monomorphic 'TextShow' functions for data types in the @bifunctors@ library.

/Since: 2/
-}
module TextShow.Data.Bifunctor (
      showbBiffPrec
    , liftShowbBiffPrec2
    , showbClownPrec
    , liftShowbClownPrec
    , showbFixPrec
    , liftShowbFixPrec
    , showbFlipPrec
    , liftShowbFlipPrec2
    , showbJoinPrec
    , liftShowbJoinPrec
    , showbJokerPrec
    , liftShowbJokerPrec
    , showbProductPrec
    , liftShowbProductPrec2
    , showbSumPrec
    , liftShowbSumPrec2
    , showbTannenPrec
    , liftShowbTannenPrec2
    , showbWrappedBifunctorPrec
    , liftShowbWrappedBifunctorPrec2
    ) where

import Data.Bifunctor.Biff (Biff)
import Data.Bifunctor.Clown (Clown)
import Data.Bifunctor.Fix (Fix(..))
import Data.Bifunctor.Flip (Flip)
import Data.Bifunctor.Join (Join(..))
import Data.Bifunctor.Joker (Joker)
import Data.Bifunctor.Product (Product)
import Data.Bifunctor.Sum (Sum)
import Data.Bifunctor.Tannen (Tannen)
import Data.Bifunctor.Wrapped (WrappedBifunctor)

import TextShow (TextShow(..), TextShow1(..), TextShow2(..), Builder)
import TextShow.TH (deriveTextShow2, makeShowbPrec, makeLiftShowbPrec)

-- | Convert a 'Biff' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbBiffPrec :: TextShow (p (f a) (g b)) => Int -> Biff p f g a b -> Builder
showbBiffPrec = showbPrec
{-# INLINE showbBiffPrec #-}

-- | Convert a 'Biff' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbBiffPrec2 :: (TextShow2 p, TextShow1 f, TextShow1 g)
                   => (Int -> a -> Builder) -> ([a] -> Builder)
                   -> (Int -> b -> Builder) -> ([b] -> Builder)
                   -> Int -> Biff p f g a b -> Builder
liftShowbBiffPrec2 = liftShowbPrec2
{-# INLINE liftShowbBiffPrec2 #-}

-- | Convert a 'Clown' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbClownPrec :: TextShow (f a) => Int -> Clown f a b -> Builder
showbClownPrec = showbPrec
{-# INLINE showbClownPrec #-}

-- | Convert a 'Clown' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbClownPrec :: TextShow1 f => (Int -> a -> Builder) -> ([a] -> Builder)
                   -> Int -> Clown f a b -> Builder
liftShowbClownPrec sp sl = liftShowbPrec2 sp sl undefined undefined
{-# INLINE liftShowbClownPrec #-}

-- | Convert a 'Fix' value to a 'Builder' with the given precedence.
--
-- /Since: 3/
showbFixPrec :: TextShow (p (Fix p a) a) => Int -> Fix p a -> Builder
showbFixPrec = showbPrec
{-# INLINE showbFixPrec #-}

-- | Convert a 'Fix' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbFixPrec :: TextShow2 p => (Int -> a -> Builder) -> ([a] -> Builder)
                 -> Int -> Fix p a -> Builder
liftShowbFixPrec sp sl p =
    liftShowbPrec2 (liftShowbPrec sp sl) (liftShowbList sp sl) sp sl p . out
{-# INLINE liftShowbFixPrec #-}

-- | Convert a 'Flip' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbFlipPrec :: TextShow (p b a) => Int -> Flip p a b -> Builder
showbFlipPrec = showbPrec
{-# INLINE showbFlipPrec #-}

-- | Convert a 'Flip' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbFlipPrec2 :: TextShow2 p
                   => (Int -> a -> Builder) -> ([a] -> Builder)
                   -> (Int -> b -> Builder) -> ([b] -> Builder)
                   -> Int -> Flip p a b -> Builder
liftShowbFlipPrec2 = liftShowbPrec2
{-# INLINE liftShowbFlipPrec2 #-}

-- | Convert a 'Join' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbJoinPrec :: TextShow (p a a) => Int -> Join p a -> Builder
showbJoinPrec = showbPrec
{-# INLINE showbJoinPrec #-}

-- | Convert a 'Join' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbJoinPrec :: TextShow2 p => (Int -> a -> Builder) -> ([a] -> Builder)
                  -> Int -> Join p a -> Builder
liftShowbJoinPrec sp sl p = liftShowbPrec2 sp sl sp sl p . runJoin
{-# INLINE liftShowbJoinPrec #-}

-- | Convert a 'Joker' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbJokerPrec :: TextShow (g b) => Int -> Joker g a b -> Builder
showbJokerPrec = showbPrec
{-# INLINE showbJokerPrec #-}

-- | Convert a 'Joker' value to a 'Builder' with the given show functions and precedence.
--
-- /Since: 3/
liftShowbJokerPrec :: TextShow1 g => (Int -> b -> Builder) -> ([b] -> Builder)
                   -> Int -> Joker g a b -> Builder
liftShowbJokerPrec = liftShowbPrec2 undefined undefined
{-# INLINE liftShowbJokerPrec #-}

-- | Convert a 'Product' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbProductPrec :: (TextShow (f a b), TextShow (g a b))
                 => Int -> Product f g a b -> Builder
showbProductPrec = showbPrec
{-# INLINE showbProductPrec #-}

-- | Convert a 'Product' value to a 'Builder' with the given show functions
-- and precedence.
--
-- /Since: 3/
liftShowbProductPrec2 :: (TextShow2 f, TextShow2 g)
                      => (Int -> a -> Builder) -> ([a] -> Builder)
                      -> (Int -> b -> Builder) -> ([b] -> Builder)
                      -> Int -> Product f g a b -> Builder
liftShowbProductPrec2 = liftShowbPrec2
{-# INLINE liftShowbProductPrec2 #-}

-- | Convert a 'Sum' value to a 'Builder' with the given precedence.
--
-- /Since: 3/
showbSumPrec :: (TextShow (f a b), TextShow (g a b))
             => Int -> Sum f g a b -> Builder
showbSumPrec = showbPrec
{-# INLINE showbSumPrec #-}

-- | Convert a 'Sum' value to a 'Builder' with the given show functions
-- and precedence.
--
-- /Since: 3/
liftShowbSumPrec2 :: (TextShow2 f, TextShow2 g)
                  => (Int -> a -> Builder) -> ([a] -> Builder)
                  -> (Int -> b -> Builder) -> ([b] -> Builder)
                  -> Int -> Sum f g a b -> Builder
liftShowbSumPrec2 = liftShowbPrec2
{-# INLINE liftShowbSumPrec2 #-}

-- | Convert a 'Tannen' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbTannenPrec :: TextShow (f (p a b)) => Int -> Tannen f p a b -> Builder
showbTannenPrec = showbPrec
{-# INLINE showbTannenPrec #-}

-- | Convert a 'Tannen' value to a 'Builder' with the given show functions
-- and precedence.
--
-- /Since: 3/
liftShowbTannenPrec2 :: (TextShow1 f, TextShow2 p)
                     => (Int -> a -> Builder) -> ([a] -> Builder)
                     -> (Int -> b -> Builder) -> ([b] -> Builder)
                     -> Int -> Tannen f p a b -> Builder
liftShowbTannenPrec2 = liftShowbPrec2
{-# INLINE liftShowbTannenPrec2 #-}

-- | Convert a 'WrappedBifunctor' value to a 'Builder' with the given precedence.
--
-- /Since: 2/
showbWrappedBifunctorPrec :: TextShow (p a b) => Int -> WrappedBifunctor p a b -> Builder
showbWrappedBifunctorPrec = showbPrec
{-# INLINE showbWrappedBifunctorPrec #-}

-- | Convert a 'WrappedBifunctor' value to a 'Builder' with the given show functions
-- and precedence.
--
-- /Since: 3/
liftShowbWrappedBifunctorPrec2 :: TextShow2 p
                               => (Int -> a -> Builder) -> ([a] -> Builder)
                               -> (Int -> b -> Builder) -> ([b] -> Builder)
                               -> Int -> WrappedBifunctor p a b -> Builder
liftShowbWrappedBifunctorPrec2 = liftShowbPrec2
{-# INLINE liftShowbWrappedBifunctorPrec2 #-}

instance TextShow (p (f a) (g b)) => TextShow (Biff p f g a b) where
    showbPrec = $(makeShowbPrec ''Biff)
instance (TextShow2 p, TextShow1 f, TextShow1 g, TextShow a) => TextShow1 (Biff p f g a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''Biff)

instance TextShow (f a) => TextShow (Clown f a b) where
    showbPrec = $(makeShowbPrec ''Clown)
instance TextShow (f a) => TextShow1 (Clown f a) where
    liftShowbPrec = $(makeLiftShowbPrec ''Clown)
$(deriveTextShow2 ''Clown)

instance TextShow (p (Fix p a) a) => TextShow (Fix p a) where
    showbPrec = $(makeShowbPrec ''Fix)
instance TextShow2 p => TextShow1 (Fix p) where
    liftShowbPrec = liftShowbFixPrec

instance TextShow (p b a) => TextShow (Flip p a b) where
    showbPrec = $(makeShowbPrec ''Flip)
instance (TextShow2 p, TextShow a) => TextShow1 (Flip p a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''Flip)

instance TextShow (p a a) => TextShow (Join p a) where
    showbPrec = $(makeShowbPrec ''Join)
instance TextShow2 p => TextShow1 (Join p) where
    liftShowbPrec = liftShowbJoinPrec

instance TextShow (g b) => TextShow (Joker g a b) where
    showbPrec = $(makeShowbPrec ''Joker)
instance TextShow1 g => TextShow1 (Joker g a) where
    liftShowbPrec = $(makeLiftShowbPrec ''Joker)
$(deriveTextShow2 ''Joker)

instance (TextShow (f a b), TextShow (g a b)) => TextShow (Product f g a b) where
    showbPrec = $(makeShowbPrec ''Product)
instance (TextShow2 f, TextShow2 g, TextShow a) => TextShow1 (Product f g a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''Product)

instance (TextShow (f a b), TextShow (g a b)) => TextShow (Sum f g a b) where
    showbPrec = $(makeShowbPrec ''Sum)
instance (TextShow2 f, TextShow2 g, TextShow a) => TextShow1 (Sum f g a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''Sum)

instance TextShow (f (p a b)) => TextShow (Tannen f p a b) where
    showbPrec = $(makeShowbPrec ''Tannen)
instance (TextShow1 f, TextShow2 p, TextShow a) => TextShow1 (Tannen f p a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''Tannen)

instance TextShow (p a b) => TextShow (WrappedBifunctor p a b) where
    showbPrec = $(makeShowbPrec ''WrappedBifunctor)
instance (TextShow2 p, TextShow a) => TextShow1 (WrappedBifunctor p a) where
    liftShowbPrec = liftShowbPrec2 showbPrec showbList
$(deriveTextShow2 ''WrappedBifunctor)
