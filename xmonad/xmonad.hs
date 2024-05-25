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
import XMonad.Actions.WorkspaceNames as WN

import Graphics.X11.ExtraTypes.XF86

import MyXmonadConfig (getConfigValue, extraKeys)


main = do
  xmonad $ easyStatusBar $ ewmh $ myConfig
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layout
    , manageHook  = manageHook def <+> myManageHook <+> manageDocks
    }

myConfig = desktopConfig
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  -- border setup
  , borderWidth = 0
  , focusedBorderColor = "#FD7F39" -- orange
  --
  , startupHook = startup
  , layoutHook  = layout
  , logHook     = myFadeInactiveLogHook
  --    , logHook     = dynamicLogWithPP $ xmobarPP {
  --    }
  }
  `additionalKeys` myKeys

myManageHook = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myFloats]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "2") | c <- webApps]
    , [ className   =? c --> doF (W.shift "3") | c <- ircApps]
    ]
  where myFloats      = ["plasmashell", "krunner", "Gimp"]
        myOtherFloats = []
        webApps       = [] -- open on desktop 2
        ircApps       = [] -- open on desktop 3

-- TODO: this needs to use MyXmonadConfig
easyStatusBar = withEasySB (statusBarProp "xmobar -x 0 ~/.config/xmobar/xmobarrc.hs" (pure myXmobarPP)) defToggleStrutsKey

myXmobarPP :: PP
myXmobarPP = def
  { ppSep             = "     "
  , ppTitleSanitize   = xmobarStrip
  , ppCurrent         = green       . preWrapWithSpace
  , ppHidden          = white       . preWrapWithSpace
  -- quick way of hiding
  , ppHiddenNoWindows = emptyString . grey     . preWrapWithSpace
  , ppUrgent          = red         . preWrapWithSpace
  , ppOrder           = \[ws, l, _, wins] -> [ws, wins]
  , ppExtras          = [logTitles formatFocused formatUnfocused]
  }
  where
    preWrapWithSpace = wrap " " ""
    formatFocused    = orange   . ppWindowTitle
    -- formatUnfocused  = (\x -> "") . lowWhite . ppWindowTitle
    emptyString      = \x -> ""
    -- don't show unfocused name
    formatUnfocused  = emptyString

    ppWindowTitle :: String -> String
    ppWindowTitle = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 255

    green, grey, lowWhite, red, white, orange :: String -> String
    orange   = xmobarColor "#ee9a00" ""
    white    = xmobarColor "#f8f8f2" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
    grey     = xmobarColor "#444444" ""
    green    = xmobarColor "#009484" ""

startup = do
    -- mainly for WebStorm
    setWMName "LG3D"
    -- notifications
    spawnOnce "dunst &"
    -- statusbar
    spawnOnce "xmobar -x 0 ~/.config/xmobar/xmobarrc.hs &"
    -- vsync doesn't work too methinks
    spawnOnce "picom --daemon --vsync"
    -- wallpaper
    spawn     $ "nitrogen --set-tiled " ++ (getConfigValue "wallpaper") ++ " &"
    -- NetworkManager applet for auto-connect using pw from vault and NM UI
    spawnOnce "nm-applet --indicator &"
    -- systray
    spawnOnce "trayer --monitor 0 --widthtype pixel --width 80 --align center --edge top --height 40 --tint 0x00000000 --transparent true --alpha 1 &"
    -- could edit i3lock (or use slock) compile manually making it 'dunstctl set-paused toggle &'
    -- TODO: use slock?
    spawnOnce $ "xss-lock --transfer-sleep-lock -- i3lock --nofork -f -t -i " ++ (getConfigValue "screen-lock-wallpaper") ++ " &"
    spawn     "xset s 600"
    spawnOnce "autorandr --change"
    -- TODO: this did not work
    -- WN.setWorkspaceName "web"  "1"
    -- WN.setWorkspaceName "code" "2"
    -- WN.setWorkspaceName "db"   "3"
    -- WN.setWorkspaceName "com"  "4"
    -- WN.setWorkspaceName "pers" "5"
    -- WN.setWorkspaceName "doc"  "6"
    -- WN.setWorkspaceName "misc" "7"
    -- WN.setWorkspaceName "run"  "8"
    -- WN.setWorkspaceName "sh"   "9"

myFadeInactiveLogHook :: X ()
myFadeInactiveLogHook = fadeInactiveLogHook fadeAmount
  where fadeAmount = 0.90

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
     , ((mod4Mask, xK_d), spawn "dmenu_run -m 0 -fn 'Roboto 11'")
     , ((mod4Mask .|. shiftMask, xK_r), shellPrompt def)
     , ((mod4Mask, xK_Return), sendMessage $ JumpToLayout "Full")
     , ((mod4Mask .|. shiftMask, xK_m), windows W.swapMaster)
     , ((mod4Mask .|. shiftMask, xK_n), spawn "notify-send -t 1000 'Notification state change' `dunstctl is-paused` && sleep 1.5 && dunstctl set-paused toggle")
     , ((mod4Mask .|. shiftMask, xK_h), spawn "dunstctl history-pop")
     , ((mod4Mask, xK_p), spawn "autorandr --change")
     , ((mod4Mask, xK_Print), spawn "flameshot launcher")
     , ((mod4Mask .|. shiftMask, xK_Print), spawn "flameshot gui --delay 3000 --raw | xsel -b")
     , ((mod4Mask, xK_F12), spawn "xset s activate")
    ] ++

    extraKeys ++

    -- TODO: document what is this doing in details
    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

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
