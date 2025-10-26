import XMonad hiding ( (|||) )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeWindows
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
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
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
import Control.Arrow (first)
import XMonad.Layout.Renamed
import XMonad.Hooks.InsertPosition

import Graphics.X11.ExtraTypes.XF86

main = do
  xmonad $ easyStatusBar $ ewmh $ myConfig
  xmonad $ docks def
    { layoutHook = myLayoutHook
    , manageHook = manageHook def <+> myManageHook <+> manageDocks
    }

myConfig = desktopConfig
  { terminal           = "wezterm"
  , modMask            = mod4Mask
  , borderWidth        = 0
  , focusedBorderColor = "#FD7F39" -- orange
  , startupHook        = startup
  , layoutHook         = myLayoutHook
  , workspaces         = myWorkspaces
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


myWorkspaces = ["web", "code", "db", "chat", "misc", "doc", "run", "cfg", "term", ""] -- TODO ["empty"] for "show desktop" to see conky or whatnot

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

clickable ws = "<action=`xdotool key \"Super_L+"++show i++"\"`>" ++ ws ++ "</action>"
    where
      i  = fromJust $ M.lookup ws myWorkspaceIndices

clickableLayout layout = "<action=`xdotool key \"Super_L+space\"`>" ++ layout ++ "</action>"
clickableWindowTitle windowTitle = "<action=`xdotool key \"Super_L+j\"`>" ++ windowTitle ++ "</action>"

easyStatusBar = withEasySB (statusBarProp "xmobar -x 0 ~/.config/xmobar/xmobar.hs" (pure myXmobarPP)) defToggleStrutsKey

myXmobarPP :: PP
myXmobarPP = def
  { ppSep             = " "
  , ppTitleSanitize   = ppWindowTitle
  , ppCurrent         = orangeBg      . preWrapWithSpace . clickable
  , ppHidden          = white         . preWrapWithSpace . clickable
  -- quick way of hiding
  , ppHiddenNoWindows = grey          . preWrapWithSpace . clickable
  , ppUrgent          = red           . preWrapWithSpace
  , ppOrder           = \[ws, layout, _, wins] -> [ws, layout, wins]
  , ppExtras          = [logTitles formatFocused formatUnfocused]
  , ppLayout          = white         . wrapInPipes      . clickableLayout
  }
  where
    wrapInPipes      = wrap " - " " - " 
    preWrapWithSpace = wrap " " " "
    formatFocused    = orange . ppWindowTitle
    emptyString      = \x -> "" 
    -- don't show unfocused name
    formatUnfocused  = emptyString

    ppWindowTitle :: String -> String
    ppWindowTitle = clickableWindowTitle . xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 85

    green, grey, lowWhite, red, white, orange :: String -> String

    orange   = xmobarColor "#ee9a00" ""
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
    -- statusbar main
    spawnOnce "xmobar -x 0 ~/.config/xmobar/xmobar1.hs &"
    -- statusbar main
    -- FIXME: vsync doesn't work too methinks
    spawnOnce "picom --daemon --vsync --fade-delta=1 --unredir-if-possible" -- --unredir-if-possible prevents from dunst leaking notifications in lock screen
    -- wallpaper
    spawn     $ "nitrogen --set-tiled /home/martins/Downloads/wave-Dark-arch.jpg &"
    -- NetworkManager applet for auto-connect using pw from vault and NM UI
    spawnOnce "nm-applet --indicator &"
    -- systray
    spawnOnce "trayer --monitor 0 --widthtype pixel --align center --edge top --height 40  --transparent true --tint 0x111111 --alpha 1 --iconspacing 7 &"
    spawnOnce $ "xss-lock --transfer-sleep-lock -- i3lock --nofork -f -t --color 000000 &"
    -- 10 mins to turn off & lock the screen
    spawn     "xset s 600"
    -- triggers optimal autorandr profile in case it was not automatically switched
    spawnOnce "autorandr --change"

customXPKeymap :: M.Map (KeyMask, KeySym) (XP ())
customXPKeymap = M.fromList $
     map (first $ (,) controlMask)      -- control + <key>
     [ (xK_u, killBefore)               -- kill line backwards
     , (xK_k, killAfter)                -- kill line forwards
     , (xK_a, startOfLine)              -- move to the beginning of the line
     , (xK_e, endOfLine)                -- move to the end of the line
     , (xK_d, deleteString Next)        -- delete a character foward
     , (xK_h, deleteString Prev)        -- delete a character backwards
     , (xK_b, moveCursor Prev)          -- move cursor forward
     , (xK_f, moveCursor Next)          -- move cursor backward
     , (xK_w, killWord Prev)    -- kill the previous word
     , (xK_y, pasteString)              -- paste a string
     , (xK_q, quit)                     -- quit out of prompt
     -- , (xK_bracketleft, quit)
     , (xK_p, moveHistory W.focusUp')   -- move up thru history
     , (xK_n, moveHistory W.focusDown') -- move down thru history
     , (xK_m, setSuccess True >> setDone True)
     , (xK_c, quit)
     ]
     ++
     map (first $ (,) mod1Mask)         -- meta key + <key>
     [ (xK_BackSpace, killWord Prev)    -- kill the prev word
     , (xK_f,         moveWord Next)    -- move a word forward
     , (xK_b,         moveWord Prev)    -- move a word backward
     , (xK_d,         killWord Next)    -- kill the next word
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

myKeys = [
     ((0, xF86XK_PowerDown),                   spawn "systemctl suspend")
     -- audio output volume ------
     -- step by step
     , ((0, xF86XK_AudioRaiseVolume),          spawn "amixer -D pulse sset Master 5%+")
     , ((0, xF86XK_AudioLowerVolume),          spawn "amixer -D pulse sset Master 5%-")

     -- 0% to 100%
     , ((shiftMask, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 100%")
     , ((shiftMask, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 0%")
     -----------------------------

     , ((0, xF86XK_AudioMute),                 spawn "amixer -D pulse sset Master toggle")
     , ((0, xF86XK_AudioMicMute),              spawn "amixer -D pulse sset Capture toggle")
     , ((0, xF86XK_AudioPrev),                 spawn "playerctl previous")
     , ((0, xF86XK_AudioNext),                 spawn "playerctl next")
     , ((0, xF86XK_AudioStop),                 spawn "playerctl stop")

     -- display brightness -------
     -- step by step
     , ((0, xF86XK_MonBrightnessUp),           spawn "brightnessctl set +5%")
     , ((0, xF86XK_MonBrightnessDown),         spawn "brightnessctl set 5%-")

     -- 0% to 100%
     , ((shiftMask, xF86XK_MonBrightnessUp),   spawn "brightnessctl set 100%")
     , ((shiftMask, xF86XK_MonBrightnessDown), spawn "brightnessctl set 1%")
     , ((mod4Mask,    xK_d),                   spawn "dmenu_run -m 0 -fn 'Roboto 11'")
     -----------------------------

     -- TODO: improve prompt, could be better
     , ((mod4Mask .|. shiftMask, xK_r),        shellPrompt def { promptBorderWidth = 0, historySize = 100, promptKeymap = customXPKeymap })
     , ((mod4Mask,               xK_Return),   sendMessage $ JumpToLayout "Full")
     , ((mod4Mask .|. shiftMask, xK_m),        windows W.swapMaster)
     , ((mod4Mask,               xK_o),        spawn "xsel -bo | grep -E 'https?://' | xargs firefox -P Professional --new-tab --url")

     , ((mod4Mask .|. shiftMask, xK_n),        spawn "cat /home/martins/.scripts/network/choices.sh | dmenu | xargs /home/martins/.scripts/network/network.sh")

     , ((mod4Mask .|. shiftMask, xK_h),        spawn "dunstctl history-pop")
     -- close all displayed notifications
     , ((mod4Mask .|. shiftMask, xK_g),        spawn "dunstctl close-all")
     , ((mod4Mask,    xK_p),                   spawn "autorandr --change")
     -- switch to laptop screen only
     , ((mod4Mask .|. shiftMask, xK_p),        spawn "autorandr --load mobile")
     -- TODO: video screen recording
     -- take & save screenshot to ~/Pictures/  
     , ((0,           xK_Print),               spawn "flameshot gui --path /home/martins/Pictures/")
     , ((mod4Mask,    xK_Print),               spawn "flameshot gui --clipboard")
     -- delay more for frontend dev work
     , ((mod4Mask .|. shiftMask, xK_Print),    spawn "flameshot gui --clipboard --delay 3000")
     -- screen lock
     , ((mod4Mask,               xK_F12),      spawn "xset s activate")
     -- deprecated in favour for 1pass/passman shortcut
     -- , ((mod4Mask,               xK_l),        spawn "xset s activate")
     , ((mod1Mask,               xK_F4),       kill)

     -- FIXME: can be created by a loop?
     , ((mod4Mask,               xK_1),        windows $ W.view $ myWorkspaces !! 0)
     , ((mod4Mask,               xK_2),        windows $ W.view $ myWorkspaces !! 1)
     , ((mod4Mask,               xK_3),        windows $ W.view $ myWorkspaces !! 2)
     , ((mod4Mask,               xK_4),        windows $ W.view $ myWorkspaces !! 3)
     , ((mod4Mask,               xK_5),        windows $ W.view $ myWorkspaces !! 4)
     , ((mod4Mask,               xK_6),        windows $ W.view $ myWorkspaces !! 5)
     , ((mod4Mask,               xK_7),        windows $ W.view $ myWorkspaces !! 6)
     , ((mod4Mask,               xK_8),        windows $ W.view $ myWorkspaces !! 7)
     , ((mod4Mask,               xK_9),        windows $ W.view $ myWorkspaces !! 8)
     -- FIXME: for empty workspace
     -- , ((mod4Mask,               xK_0),        windows $ W.view $ myWorkspaces !! 9)
     --
     , ((mod4Mask .|. shiftMask, xK_1),        windows $ W.shift $ myWorkspaces !! 0)
     , ((mod4Mask .|. shiftMask, xK_2),        windows $ W.shift $ myWorkspaces !! 1)
     , ((mod4Mask .|. shiftMask, xK_3),        windows $ W.shift $ myWorkspaces !! 2)
     , ((mod4Mask .|. shiftMask, xK_4),        windows $ W.shift $ myWorkspaces !! 3)
     , ((mod4Mask .|. shiftMask, xK_5),        windows $ W.shift $ myWorkspaces !! 4)
     , ((mod4Mask .|. shiftMask, xK_6),        windows $ W.shift $ myWorkspaces !! 5)
     , ((mod4Mask .|. shiftMask, xK_7),        windows $ W.shift $ myWorkspaces !! 6)
     , ((mod4Mask .|. shiftMask, xK_8),        windows $ W.shift $ myWorkspaces !! 7)
     , ((mod4Mask .|. shiftMask, xK_9),        windows $ W.shift $ myWorkspaces !! 8)

     -- , ((mod4Mask .|. shiftMask, xK_h),      sendMessage MirrorShrink)
     -- , ((mod4Mask .|. shiftMask, xK_l),      sendMessage MirrorExpand)
     -- , ((mod4Mask .|. shiftMask, xK_h),      sendMessage MirrorShrink)
     -- , ("M-a", sendMessage MirrorExpand)
    ]
    -- ] ++

    -- extraKeys ++

    -- [((m .|. mod4Mask, k), windows $ f i)
    --      | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
    --      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    -- ]

    -- []

-- avoidStruts() not needed here it seems?
myLayoutHook = fullRenamed ||| tiledRenamed ||| mirrorTiledRenamed ||| simpleTabbedRenamed ||| twoPaneRenamed
  where
     -- layout definitions
     full                = noBorders Full

     twoPane             = TwoPane (3/100) (1/2)

     tiled               = Tall nmaster delta ratio

     mirrorTiled         = Mirror tiled

     ---------
     -- layout renamings

     fullRenamed         = renamed [Replace "FF"] full

     twoPaneRenamed      = renamed [Replace "TP"] twoPane
     
     tiledRenamed        = renamed [Replace "TT"] tiled

     mirrorTiledRenamed  = renamed [Replace "TM"] mirrorTiled

     simpleTabbedRenamed = renamed [Replace "TA"] simpleTabbed

     ---------
     -- values

     -- The default number of windows in the master pane
     nmaster             = 1
     
     -- Default proportion of screen occupied by master pane
     ratio               = 1/2
     
     -- Percent of screen to increment by when resizing panes
     delta               = 3/100
