import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import XMonad.Prompt
import XMonad.Prompt.Shell

startup = do
    setWMName "LG3D"
    spawnOnce "picom &"
    -- spawn "tint2 &"
    spawn "nitrogen --restore &"
    spawn "xmobar /home/martins/.config/xmobar/xmobarrc"
    spawnOnce "stalonetray -bg '#000000' -i 14 --geometry=3x1-0+0"

main = do
--  xmproc <- spawnPipe "xmobar /home/dt/.config/xmobar/xmobarrc"
  xmonad $ desktopConfig
    { terminal    = "alacritty"
    , modMask     = mod4Mask
    , borderWidth = 2
    , startupHook = startup
    }
    `additionalKeys` myKeys
  xmonad $ docks def
    { layoutHook  = avoidStruts $ layout
    , manageHook  = manageHook def <+> manageDocks
    }

myKeys = [
       ((0, xF86XK_PowerDown),         spawn "systemctl suspend")
     , ((0, xF86XK_AudioRaiseVolume),  spawn "amixer -D pulse sset Master 10%+")
     , ((0, xF86XK_AudioLowerVolume),  spawn "amixer -D pulse sset Master 10%-")
     , ((0, xF86XK_AudioMute),         spawn "amixer -D pulse sset Master toggle")
     , ((0, xF86XK_AudioMicMute),         spawn "amixer -D pulse sset Capture toggle")
     , ((0, xF86XK_AudioPrev),         spawn "playerctl previous")
     , ((0, xF86XK_AudioNext),         spawn "playerctl next")
     , ((0, xF86XK_AudioStop),         spawn "playerctl stop")
     , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +10%")
     , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
     , ((mod4Mask, xK_F12), spawn "i3lock --image ~/Downloads/leopard-3440-2560.png")
     , ((mod4Mask .|. shiftMask, xK_F12), spawn "i3lock --image ~/Downloads/leopard-3440-2560.png && systemctl suspend")
     , ((mod4Mask, xK_r), spawn "dmenu_run -fn 'Inconsolata 12'")
     , ((mod4Mask, xK_p), spawn "autorandr --change")
     , ((mod4Mask, xK_n), spawn "xterm -e 'nmtui-connect'")
     -- , ((mod4Mask, xK_n), spawn "networkmanager_dmenu -fn 'Inconsolata 12'")
     , ((mod4Mask, xK_Print), spawn "spectacle -rc")
     , ((mod4Mask .|. shiftMask, xK_r), shellPrompt def)
    ]

layout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     
     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 3/4
     
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
