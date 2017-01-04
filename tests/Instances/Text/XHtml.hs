{-# LANGUAGE CPP                #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell    #-}
{-# LANGUAGE TypeFamilies       #-}

#if __GLASGOW_HASKELL__ >= 702
{-# LANGUAGE DeriveGeneric      #-}
#endif

{-# OPTIONS_GHC -fno-warn-orphans #-}
{-|
Module:      Instances.Text.XHtml
Copyright:   (C) 2014-2017 Ryan Scott
License:     BSD-style (see the file LICENSE)
Maintainer:  Ryan Scott
Stability:   Provisional
Portability: GHC

Provides 'Arbitrary' instances for data types in the @xhtml@ library.
-}
module Instances.Text.XHtml () where

#if __GLASGOW_HASKELL__ >= 704
import           GHC.Generics (Generic)
#else
import qualified Generics.Deriving.TH as Generics (deriveAll0)
#endif

import           Instances.Utils.GenericArbitrary (genericArbitrary)

import           Prelude ()
import           Prelude.Compat

import           Test.QuickCheck (Arbitrary(..), Gen)

import           Text.XHtml.Frameset (Html, HtmlAttr, HotLink(..), strAttr, toHtml)
import           Text.XHtml.Table (HtmlTable, cell)

instance Arbitrary Html where
    arbitrary = toHtml <$> (arbitrary :: Gen String)

instance Arbitrary HtmlAttr where
    arbitrary = strAttr <$> arbitrary <*> arbitrary

instance Arbitrary HotLink where
    arbitrary = genericArbitrary

instance Arbitrary HtmlTable where
    arbitrary = cell <$> (arbitrary :: Gen Html)

#if __GLASGOW_HASKELL__ >= 704
deriving instance Generic HotLink
#else
$(Generics.deriveAll0 ''HotLink)
#endif
