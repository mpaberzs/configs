import XMonad hiding ( (|||) )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutCombinators    -- use the one from LayoutCombinators instead
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import System.IO (hPutStrLn)
import qualified XMonad.StackSet as W
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Spacing


startup = do
    setWMName "LG3D"
    spawnOnce "picom &"
    spawn "nitrogen --set-tiled ~/Downloads/tilel.png &"
    -- spawnOnce "/usr/bin/gnome-keyring-daemon --start --foreground --components=secrets && nm-applet --indicator &"
    spawnOnce "nm-applet --indicator &"
    spawnOnce "trayer --monitor 1 --widthtype pixel --width 80 --align right --edge top --height 22 --tint 0x00000000 --transparent true --alpha 1 &"

myFadeInactiveLogHook :: X ()
myFadeInactiveLogHook = fadeInactiveLogHook fadeAmount
  where fadeAmount = 0.95

main = do
  -- when in work with primary horizontal and left of it vertical secondary
  -- xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc2"
  -- xmproc <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrc1"
  -- when only laptop screen
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc_mobile"
  xmonad $ desktopConfig
    { terminal    = "alacritty"
    , modMask     = mod4Mask
    , borderWidth = 1
    , focusedBorderColor = "#FD7F39" -- orange
    , startupHook = startup
    , layoutHook  = layout
    , logHook     = myFadeInactiveLogHook
--    , logHook     = dynamicLogWithPP $ xmobarPP {
--    }
    }
    `additionalKeys` myKeys
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layout
    , manageHook  = manageHook def <+> manageDocks
    }

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
--     , ((mod4Mask, xK_F12), spawn "loginctl lock-session")
     -- , ((mod4Mask, xK_F12), spawn "xss-lock -- i3lock --no-fork")
     , ((mod4Mask, xK_F12), spawn "i3lock --nofork -t -i ~/Downloads/tileb.png")
--     , ((mod4Mask .|. shiftMask, xK_F12), spawn "xss-lock --transfer-sleep-lock -- i3lock --no-fork")
     , ((mod4Mask .|. shiftMask, xK_F12), spawn "i3lock -t -i ~/Downloads/tileb.png && systemctl suspend")
     , ((mod4Mask, xK_F10), prompt "nmcli c u martins_parsiq_staging" greenXPConfig)
     , ((mod4Mask .|. shiftMask, xK_F10), prompt "nmcli c d martins_parsiq_staging" greenXPConfig)
     , ((mod4Mask, xK_F11), prompt "nmcli c u martins_parsiq_prod" greenXPConfig)
     , ((mod4Mask .|. shiftMask, xK_F11), prompt "nmcli c d martins_parsiq_prod" greenXPConfig)
     , ((mod4Mask, xK_d), spawn "dmenu_run -m 0 -fn 'Inconsolata 12'")
     , ((mod4Mask, xK_p), spawn "autorandr --change")
     , ((mod4Mask, xK_n), spawn "xterm -e 'nmtui-connect'")
     , ((mod4Mask, xK_Print), spawn "spectacle -rc")
     , ((mod4Mask .|. shiftMask, xK_r), shellPrompt def)
     , ((mod4Mask .|. shiftMask, xK_m), sendMessage $ JumpToLayout "Full")
    ] ++

    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]
layout = avoidStruts(tiled ||| Mirror tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartSpacing 10 $ Tall nmaster delta ratio
     
     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
