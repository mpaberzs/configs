module MyXmonadConfig where

import Data.AssocList.List.Eq

config = [
    ("home", "/home/user")
  , ("wallpaper", "")
  , ("screen-lock-wallpaper", "")
  , ("xmobarrc", "/home/user/.config/xmobar/xmobarrc")
  ]

extraKeys = []

fromJust :: Maybe a -> a
fromJust (Just a) = a
fromJust Nothing = error "no value"

getConfigValue key = do
  let configVal = lookupFirst key config
  show $ fromJust configVal
