import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86

startup = do
    setWMName "LG3D"
    spawn "tint2 &"
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"

main = do
--  xmproc <- spawnPipe "xmobar /home/dt/.config/xmobar/xmobarrc"
  xmonad $ desktopConfig
    { terminal    = "alacritty"
    , modMask     = mod4Mask
    , borderWidth = 3
    , startupHook = startup
    }
    `additionalKeys` myKeys
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layoutHook def
    , manageHook  = manageHook def <+> manageDocks
    }

myKeys = [
       ((0, xF86XK_PowerDown),         spawn "systemctl suspend")
     , ((0, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 10%+")
     , ((0, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 10%-")
     , ((0, xF86XK_AudioMute),         spawn "amixer -D pulse sset Master toggle")
     , ((0, xF86XK_AudioMicMute),         spawn "amixer -D pulse sset Capture toggle")
     , ((0, xF86XK_AudioPrev),         spawn "playerctl prev")
     , ((0, xF86XK_AudioNext),         spawn "playerctl next")
     , ((0, xF86XK_AudioStop),         spawn "playerctl stop")
     , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +10%")
     , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
     , ((mod4Mask, xK_F12), spawn "i3lock")
     , ((mod4Mask, xK_p), spawn "dmenu_run -fn 'Inconsolata 12'")
    ]
