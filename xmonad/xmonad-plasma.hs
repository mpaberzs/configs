import XMonad hiding ( (|||) )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutCombinators    -- use the one from LayoutCombinators instead
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import qualified XMonad.StackSet as W
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Spacing
import XMonad.Util.Loggers
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Kde

import Graphics.X11.ExtraTypes.XF86

import MyXmonadConfig (getConfigValue, extraKeys)


main = do
  xmonad $ ewmh $ myConfig
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layout
    , manageHook  = manageHook def <+> manageDocks
    }

myConfig = kdeConfig
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  -- , borderWidth = 1
  , borderWidth = 0
  , focusedBorderColor = "#FD7F39" -- orange
  , startupHook = startup
  , layoutHook  = layout
  , logHook     = myFadeInactiveLogHook
  --    , logHook     = dynamicLogWithPP $ xmobarPP {
  --    }
  }
  `additionalKeys` myKeys

startup = do
    -- mainly for WebStorm
    setWMName "LG3D"
    -- vsync doesn't work too methinks
    spawnOnce "picom --daemon --vsync"
    spawn     $ "nitrogen --set-tiled " ++ (getConfigValue "wallpaper") ++ " &"
    spawnOnce "nm-applet --indicator &"
    spawnOnce "trayer --monitor 0 --widthtype pixel --width 80 --align right --edge top --height 22 --tint 0x00000000 --transparent true --alpha 1 &"
    -- could edit i3lock (or use slock) compile manually making it 'dunstctl set-paused toggle &'
    spawnOnce $ "xss-lock --transfer-sleep-lock -- i3lock --nofork -f -t -i " ++ (getConfigValue "screen-lock-wallpaper") ++ " &"
    spawn     "xset s 600"
    spawnOnce "autorandr --change"

myFadeInactiveLogHook :: X ()
myFadeInactiveLogHook = fadeInactiveLogHook fadeAmount
  where fadeAmount = 0.95

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myKeys = [
       ((0, xF86XK_PowerDown),         spawn "systemctl suspend")
     , ((0, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 5%+")
     , ((0, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 5%-")
     , ((0, xF86XK_AudioMute),         spawn "amixer -D pulse sset Master toggle")
     , ((0, xF86XK_AudioMicMute),      spawn "amixer -D pulse sset Capture toggle")
     , ((0, xF86XK_AudioPrev),         spawn "playerctl previous")
     , ((0, xF86XK_AudioNext),         spawn "playerctl next")
     , ((0, xF86XK_AudioStop),         spawn "playerctl stop")
     , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +5%")
     , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-")
     , ((mod4Mask .|. shiftMask, xK_m), sendMessage $ JumpToLayout "Full")
     , ((mod4Mask, xK_d), spawn "krunner")
     , ((mod4Mask .|. shiftMask, xK_q), spawn "dbus-send --print-reply --dest=org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout int32:1 int32:0 int32:1")
     -- TODO: change for KDE?
     , ((mod4Mask, xK_Print), spawn "flameshot launcher")
     , ((mod4Mask .|. shiftMask, xK_r), shellPrompt def)
     , ((mod4Mask .|. shiftMask, xK_Print), spawn "flameshot gui --delay 3000 --clipboard")
     , ((mod4Mask, xK_F12), spawn "xset s activate")
     , ((mod4Mask .|. shiftMask, xK_h), spawn "dunstctl history-pop")
     , ((mod4Mask .|. shiftMask, xK_n), spawn "notify-send -t 1000 'Notification state change' `dunstctl is-paused` && sleep 1.5 && dunstctl set-paused toggle")
     -- 
    ] ++

    extraKeys ++

    -- TODO: document what is this doing in details
    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

layout = avoidStruts(tiled ||| Mirror tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartSpacing 10 $ Tall nmaster delta ratio
     
     -- The default number of windows in the master pane
     -- TODO: I think this needs to be something like 5 for me, give it a try
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100