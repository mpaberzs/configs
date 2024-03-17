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
    { layoutHook = layout }

myConfig = kde4Config
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 0
  , startupHook = startup
  , layoutHook  = layout
  , logHook     = myFadeInactiveLogHook
  , manageHook = manageHook kde4Config <+> myManageHook
  }
  `additionalKeys` myKeys

myManageHook = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myFloats]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "2") | c <- webApps]
    , [ className   =? c --> doF (W.shift "3") | c <- ircApps]
    ]
  where myFloats      = ["plasmashell", "krunner", "MPlayer", "Gimp"]
        myOtherFloats = ["alsamixer"]
	-- TODO: configure
        webApps       = ["Firefox-bin", "Opera"] -- open on desktop 2
        ircApps       = ["Ksirc"]                -- open on desktop 3

startup = do
    -- mainly for WebStorm
    setWMName "LG3D"
    spawnOnce "nm-applet --indicator &"

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
     -- TODO: does not work
     , ((mod4Mask .|. shiftMask, xK_q), spawn "dbus-send --print-reply --dest=org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout int32:1 int32:0 int32:1")
     -- TODO: change for KDE
     , ((mod4Mask, xK_Print), spawn "flameshot launcher")
     , ((mod4Mask .|. shiftMask, xK_r), shellPrompt def)
     , ((mod4Mask .|. shiftMask, xK_Print), spawn "flameshot gui --delay 3000 --clipboard")
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
