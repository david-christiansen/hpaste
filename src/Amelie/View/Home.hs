{-# OPTIONS -Wall -fno-warn-name-shadowing #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

-- | Home page view.

module Amelie.View.Home
  (page)
  where

import Amelie.Types
import Amelie.View.Html
import Amelie.View.Layout
import Amelie.View.Paste  (pasteLink)

import Data.Text          (Text)
import Data.Time.Show     (showDateTime)
import Prelude            hiding ((++))
import Text.Blaze.Html5   as H hiding (map)

-- | Render the home page.
page :: [Channel] -> [Language] -> [Paste] -> Html -> Html
page chans langs ps form =
  layoutPage $ Page {
    pageTitle = "Recent pastes"
  , pageBody = content chans langs ps form
  , pageName = "home"
  }

-- | Render the home page body.
content :: [Channel] -> [Language] -> [Paste] -> Html -> Html
content chans langs ps form = do
  createNew form
  latest chans langs ps

-- | Create a new paste section.
createNew :: Html -> Html
createNew = lightSection "Create new paste"

-- | View the latest pastes.
latest :: [Channel] -> [Language] -> [Paste] -> Html
latest channels languages ps = do
  darkSection "Latest pastes" $ do
    table ! aClass "latest-pastes" $ do
      tr $ mapM_ (th . toHtml) $ words "Title Author When Language Channel"
      pastes ps
    p ! aClass "browse-link" $ browse

    where pastes = mapM_ $ \paste@Paste{..} -> tr $ do
                     td $ pasteLink paste pasteTitle
                     td $ toHtml pasteAuthor
                     td $ toHtml $ showDateTime $ pasteDate
                     td $ showLanguage languages pasteLanguage
                     td $ showChannel channels pasteChannel

-- | Browse link.
browse :: Html
browse = href ("/browse" :: Text) ("Browse all pastes" :: Text)
