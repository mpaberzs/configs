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
import qualified Data.Map as M
import Data.Maybe (fromJust)

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
  , ppTitleSanitize   = ppWindowTitle
  , ppCurrent         = orangeBg       . preWrapWithSpace . clickable
  , ppHidden          = white          . preWrapWithSpace . clickable
  -- quick way of hiding
  , ppHiddenNoWindows = grey           . preWrapWithSpace . clickable
  -- TODO: does this really work?
  , ppUrgent          = red         . preWrapWithSpace
  , ppOrder           = \[ws, l, _, wins] -> [ws, wins]
  , ppExtras          = [logTitles formatFocused formatUnfocused]
  -- TODO: why doesn't show layout?
  , ppLayout          = \x -> x
  }
  where
    preWrapWithSpace = wrap " " " "
    -- TODO: like this idea but seems need to optimize
    -- formatFocused    = orangeBg   . ppWindowTitle
    formatFocused    = orange   . ppWindowTitle
    -- formatUnfocused  = (\x -> "") . lowWhite . ppWindowTitle
    -- emptyString      = \x -> ""
    emptyString      = \x -> "" 
    -- don't show unfocused name
    formatUnfocused  = emptyString

    ppWindowTitle :: String -> String
    -- TODO: dynamic for mobile mode
    ppWindowTitle = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 85

    green, grey, lowWhite, red, white, orange :: String -> String
    orange   = xmobarColor "#ee9a00" ""
    -- orangeBg = xmobarColor "#111111" "#ee9a00" . xmobarBorder "Top" "#ee9a00" 5
    orangeBg = xmobarColor "#111111" "#ee9a00"
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
    -- TODO: make it adjust
    spawn     $ "nitrogen --set-tiled /home/martins/Downloads/wave-Dark-arch.jpg &"
    -- NetworkManager applet for auto-connect using pw from vault and NM UI
    spawnOnce "nm-applet --indicator &"
    -- systray
    spawnOnce "trayer --monitor 0 --widthtype pixel --align center --edge top --height 40  --transparent true --tint 0x111111 --alpha 1 --iconspacing 7 &"
    -- could edit i3lock (or use slock) compile manually making it 'dunstctl set-paused toggle &'
    -- TODO: use slock?
    spawnOnce $ "xss-lock --transfer-sleep-lock -- i3lock --nofork -f -t -i /home/martins/Downloads/wave-Light-arch.png &"
    -- 10 mins to turn off & lock the screen
    -- TODO: it's possible to kill locking process from outside currently, should be part of xmonad process or so
    spawn     "xset s 600"
    spawnOnce "autorandr --change"

-- myWorkspaces = [" web ", " code ", " util ", " comm ", " misc ", " doc ", " run ", " cfg ", " term "]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=`xdotool key \"Super_L+"++show i++"\"`>" ++ ws ++ "</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myKeys = [
       ((0, xF86XK_PowerDown),                 spawn "systemctl suspend")
     -- increase step by step
     , ((0, xF86XK_AudioRaiseVolume),          spawn "amixer -D pulse sset Master 5%+")
     , ((0, xF86XK_AudioLowerVolume),          spawn "amixer -D pulse sset Master 5%-")

     -- 0% to 100%
     , ((shiftMask, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 100%")
     , ((shiftMask, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 0%")

     , ((0, xF86XK_AudioMute),                 spawn "amixer -D pulse sset Master toggle")
     , ((0, xF86XK_AudioMicMute),              spawn "amixer -D pulse sset Capture toggle")
     , ((0, xF86XK_AudioPrev),                 spawn "playerctl previous")
     , ((0, xF86XK_AudioNext),                 spawn "playerctl next")
     , ((0, xF86XK_AudioStop),                 spawn "playerctl stop")

     , ((0, xF86XK_MonBrightnessUp),           spawn "brightnessctl set +5%")
     , ((0, xF86XK_MonBrightnessDown),         spawn "brightnessctl set 5%-")
     --
     -- 0% to 100%
     , ((shiftMask, xF86XK_MonBrightnessUp),   spawn "brightnessctl set 100%")
     , ((shiftMask, xF86XK_MonBrightnessDown), spawn "brightnessctl set 1%")
     , ((mod4Mask,    xK_d),                   spawn "dmenu_run -m 0 -fn 'Roboto 11'")

     -- TODO: improve prompt, could be better
     , ((mod4Mask .|. shiftMask, xK_r),        shellPrompt def)
     , ((mod4Mask,               xK_Return),   sendMessage $ JumpToLayout "Full")
     , ((mod4Mask .|. shiftMask, xK_m),        windows W.swapMaster)
     -- , ((mod4Mask .|. shiftMask, xK_n), spawn "notify-send -t 1000 'Notification state change' `dunstctl is-paused` && sleep 1.5 && dunstctl set-paused toggle")

     -- , ((mod4Mask,               xK_o),      spawn "xsel -bo | xargs firefoxt --new-tab --url")
     -- FIXME: should be dmenu prompt with more options
     , ((mod4Mask,               xK_o),        spawn "xsel -bo | grep -E 'https?://' | xargs firefoxt --new-tab --url")

     -- TODO: doesn't work but I also kind of don't use it... maybe should work differently
     , ((mod4Mask .|. shiftMask, xK_n),        spawn "wezterm -e node")
     -- TODO: kind of not using it.. think about it
     -- , ((mod4Mask .|. shiftMask, xK_v),        spawn "wezterm -e nvim")
     , ((mod4Mask .|. shiftMask, xK_h),        spawn "dunstctl history-pop")
     -- TODO: should maybe live on some other dir not xmobar related
     , ((mod4Mask,               xK_v),        spawn "/home/martins/.config/xmobar/passmanaction.sh")
     , ((mod4Mask .|. shiftMask, xK_v),        spawn "/home/martins/.config/xmobar/passmanactionlock.sh")
     -- trigger change to relevant profile if didn't switch automatically
     , ((mod4Mask,    xK_p),                   spawn "autorandr --change")
     -- switch to laptop screen only
     , ((mod4Mask .|. shiftMask, xK_p),        spawn "autorandr --load mobile")
     -- TODO: video screen
     -- TODO: do not work properly
     -- take & save screenshot to ~/Pictures/  
     , ((mod4Mask,    xK_Print),               spawn "flameshot gui --path /home/martins/Pictures/")
     , ((mod4Mask .|. shiftMask, xK_Print),    spawn "flameshot gui --clipboard --delay 3000")
     -- screen lock
     , ((mod4Mask,               xK_F12),      spawn "xset s activate")
     -- deprecated in favour for 1pass/passman shortcut
     -- , ((mod4Mask,               xK_l),        spawn "xset s activate")
     , ((mod1Mask,               xK_F4),       kill)


     -- , ((mod4Mask,               xK_1),        windows $ W.view $ myWorkspaces !! 0)
     -- , ((mod4Mask,               xK_2),        windows $ W.view $ myWorkspaces !! 1)
     -- , ((mod4Mask,               xK_3),        windows $ W.view $ myWorkspaces !! 2)
     -- , ((mod4Mask,               xK_4),        windows $ W.view $ myWorkspaces !! 3)
     -- , ((mod4Mask,               xK_5),        windows $ W.view $ myWorkspaces !! 4)
     -- , ((mod4Mask,               xK_6),        windows $ W.view $ myWorkspaces !! 5)
     -- , ((mod4Mask,               xK_7),        windows $ W.view $ myWorkspaces !! 6)
     -- , ((mod4Mask,               xK_8),        windows $ W.view $ myWorkspaces !! 7)
     -- , ((mod4Mask,               xK_9),        windows $ W.view $ myWorkspaces !! 8)
     --
     -- , ((mod4Mask .|. shiftMask, xK_1),        windows $ W.shift $ myWorkspaces !! 0)
     -- , ((mod4Mask .|. shiftMask, xK_2),        windows $ W.shift $ myWorkspaces !! 1)
     -- , ((mod4Mask .|. shiftMask, xK_3),        windows $ W.shift $ myWorkspaces !! 2)
     -- , ((mod4Mask .|. shiftMask, xK_4),        windows $ W.shift $ myWorkspaces !! 3)
     -- , ((mod4Mask .|. shiftMask, xK_5),        windows $ W.shift $ myWorkspaces !! 4)
     -- , ((mod4Mask .|. shiftMask, xK_6),        windows $ W.shift $ myWorkspaces !! 5)
     -- , ((mod4Mask .|. shiftMask, xK_7),        windows $ W.shift $ myWorkspaces !! 6)
     -- , ((mod4Mask .|. shiftMask, xK_8),        windows $ W.shift $ myWorkspaces !! 7)
     -- , ((mod4Mask .|. shiftMask, xK_9),        windows $ W.shift $ myWorkspaces !! 8)

     -- , ((mod4Mask .|. shiftMask, xK_h),      sendMessage MirrorShrink)
     -- , ((mod4Mask .|. shiftMask, xK_l),      sendMessage MirrorExpand)
     -- , ((mod4Mask .|. shiftMask, xK_h),      sendMessage MirrorShrink)
     -- , ("M-a", sendMessage MirrorExpand)
    ] ++

    -- extraKeys ++

    -- TODO: document what is this doing in details
    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

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
