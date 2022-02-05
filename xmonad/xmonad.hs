import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import Graphics.X11.ExtraTypes.XF86

main = do
  xmonad $ desktopConfig
    { terminal    = "alacritty"
    , modMask     = mod4Mask
    , borderWidth = 2
    , startupHook = setWMName "LG3D"
    , workspaces  = myWorkspaces
--    , keys        = myKeys
    }
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layoutHook def
    , manageHook  = manageHook def <+> manageDocks
    }

myWorkspaces = ["web","code","db","chat","personal","6","7","8","9"]

-- myKeys :: [(String, X ())]

-- myKeys = [
--    ((0, xF86XK_PowerDown),         spawn "systemctl suspend")
--  , ((0, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 10%+")
--  , ((0, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 10%-")
--  , ((0, xF86XK_AudioMute),         spawn "amixer -D pulse sset Master toggle")
--  , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +10%")
--  , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
--  ] 
