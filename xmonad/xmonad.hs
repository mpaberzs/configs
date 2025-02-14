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
import XMonad.Layout.BinaryColumn
import XMonad.Layout.LayoutCombinators    -- use the one from LayoutCombinators instead
import XMonad.Layout.Fullscreen
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

-- FIXME: separate
myXmonadConfig = [
    ("home", "/home/martins")
  , ("wallpaper", "/home/martins/Downloads/wave-Dark-arch.jpg")
  , ("screen-lock-wallpaper", "/home/martins/Downloads/wave-Light-arch.png")
  , ("xmobarrc", "/home/martins/.config/xmobar/xmobarrc")
  , ("xmobarrc1", "/home/martins/.config/xmobar/xmobarrc1")
  , ("xmobarrc2", "/home/martins/.config/xmobar/xmobarrc2")
  ]

main = do
  xmonad $ easyStatusBar $ ewmh $ myConfig
  xmonad $ docks def
    { layoutHook  = layout
    , manageHook  = manageHook def <+> myManageHook <+> manageDocks
    }

xmobarEscape :: String -> String
xmobarEscape [] = []
xmobarEscape s = "<raw="++len++":"++s++"/>"
  where len = show $ length s

myConfig = desktopConfig
  { terminal    = "wezterm"
  , modMask     = mod4Mask
  -- border setup
  , borderWidth = 3
  , focusedBorderColor = "#FD7F39" -- orange
  , startupHook = startup
  , layoutHook  = layout
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
easyStatusBar = withEasySB (statusBarProp "xmobar -x 0 ~/.config/xmobar/xmobar.hs" (pure myXmobarPP)) defToggleStrutsKey

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
    spawnOnce "xmobar -x 0 ~/.config/xmobar/xmobar.hs &"
    -- vsync doesn't work too methinks
    spawnOnce "picom --daemon --vsync"
    -- wallpaper
    spawn     $ "nitrogen --set-tiled /home/martins/Downloads/wave-Dark-arch.jpg &"
    -- NetworkManager applet for auto-connect using pw from vault and NM UI
    spawnOnce "nm-applet --indicator &"
    -- systray
    spawnOnce "trayer --monitor 0 --widthtype pixel --width 80 --align center --edge top --height 40 --tint 0x00000000 --transparent true --alpha 1 &"
    -- could edit i3lock (or use slock) compile manually making it 'dunstctl set-paused toggle &'
    -- TODO: use slock?
    spawnOnce $ "xss-lock --transfer-sleep-lock -- i3lock --nofork -f -t -i /home/martins/Downloads/wave-Light-arch.png &"
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
     -- , ((mod4Mask .|. shiftMask, xK_n), spawn "notify-send -t 1000 'Notification state change' `dunstctl is-paused` && sleep 1.5 && dunstctl set-paused toggle")
     , ((mod4Mask .|. shiftMask, xK_n), spawn "alacritty -e node")
     , ((mod4Mask .|. shiftMask, xK_v), spawn "alacritty -e nvim")
     , ((mod4Mask .|. shiftMask, xK_h), spawn "dunstctl history-pop")
     -- trigger change to related profile if didn't switch automatically
     , ((mod4Mask, xK_p), spawn "autorandr --change")
     -- switch to laptop screen only
     , ((mod4Mask .|. shiftMask, xK_p), spawn "autorandr --load mobile")
     -- take & save screenshot to ~/Pictures/
     , ((mod4Mask, xK_Print), spawn "flameshot gui --path /home/martins/Pictures/")
     , ((mod4Mask .|. shiftMask, xK_Print), spawn "flameshot gui --clipboard --delay 3000")
     , ((mod4Mask, xK_F12), spawn "xset s activate")
    ] ++

    -- extraKeys ++

    -- TODO: document what is this doing in details
    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

-- FIXME: old, deprecated solution
myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape)
           -- $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
           $ [" web ", " code ", " util ", " comm ", " pers ", " doc ", " run ", " cfg ", " term "]
    where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                  (i,ws) <- zip [1..9] l,
                  let n = i ]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

layout = avoidStruts(noBorders Full ||| tiled ||| Mirror tiled)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartSpacing 10 $ Tall nmaster delta ratio
     
     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
