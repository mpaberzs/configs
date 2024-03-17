module MyXmonadConfig where

import Data.AssocList.List.Eq

config = [
    ("home", "/home/user")
  , ("wallpaper", "")
  , ("screen-lock-wallpaper", "")
  , ("xmobarrc1", "/home/user/.config/xmobar/xmobarrc1")
  , ("xmobarrc2", "/home/user/.config/xmobar/xmobarrc2")
  ]

extraKeys = []

fromJust :: Maybe a -> a
fromJust (Just a) = a
fromJust Nothing = error "no value"

getConfigValue key = do
  let configVal = lookupFirst key config
  show $ fromJust configVal
