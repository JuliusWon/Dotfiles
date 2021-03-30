import System.IO
import System.Exit
import XMonad.Hooks.EwmhDesktops -- Firefox fullscreen
import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.SpawnOn
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
---import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens


import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D
import XMonad.Util.SpawnOnce

myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"
    spawn "bash ~/.config/polybar/launch.sh --forest &"
    --spawnOnce "nitrogen --set-zoom-fill --random &"
    spawnOnce "devilspie &"
    spawnOnce "killall picom &"
    spawnOnce "picom --experimental-backends &"
    spawnOnce "dwall -s forest"
    spawnOnce "dunst -config .config/dunst/dunst/dunstrc &"
    spawnOnce "lxsession &"
    spawnOnce "deadbeef --stop"
    --spawnOnce "konsole --hide-menubar --profile cava -e cava --geometry 1400x800+15+100"
    --spawnOnce "konsole --hide-menubar --fullscreen --profile cava -e gtop --geometry 500x500+850+275"
    --spawnOnce "konsole --hide-menubar --profile cava --geometry 600x800+525+599 -e tty-clock -f '%a, %d %b %Y %T'"
-- colours
normBord = "#0096ff"
focdBord = "#00ff91"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 0
--myWorkspaces    = ["\61612","\61729","\61947","\61635","\61502","\61501","\61502","\61564","\61595","\61613"]
myWorkspaces    = ["\62057","\61723","\61729","\62940","\62527","6","7","\61595","\62074","\61613"]
--myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [className =? "Cairo-dock"     --> doIgnore]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61564" | x <- my8Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\62150" | x <- my9Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61872" | x <- my10Shifts]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv","cairo-dock"]
    myTFloats = ["Downloads", "Save As...", "Devbook"]
    myRFloats = ["konsole"]
    myIgnores = ["desktop_window","konsole"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    -- my8Shifts = ["Thunar"]
    -- my9Shifts = []
    -- my10Shifts = ["discord"]




myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [ ((modMask, xK_e), spawn $ "atom" )
  , ((modMask, xK_c), spawn $ "conky-toggle" )
  , ((modMask, xK_f), sendMessage $ Toggle NBFULL)
  , ((modMask, xK_h), spawn $ "st 'htop task manager' -e htop" )
  , ((modMask, xK_m), spawn $ "pragha" )
  , ((modMask, xK_q), kill )
  , ((modMask, xK_r), spawn $ "rofi-theme-selector" )
  , ((modMask, xK_t), spawn $ "st" )
  , ((modMask, xK_v), spawn $ "pavucontrol" )
  , ((modMask, xK_y), spawn $ "polybar-msg cmd toggle" )
  , ((modMask, xK_x), spawn $ "arcolinux-logout" )
  , ((modMask, xK_Escape), spawn $ "xkill" )
  , ((modMask, xK_Return), spawn $ "sakura" )
  , ((modMask, xK_b), spawn $ "firefox" )
  , ((modMask, xK_r), spawn $ "rider" )
  , ((modMask, xK_u), spawn $ "unityhub" )
  , ((modMask, xK_g), spawn $ "gimp" )
  , ((modMask, xK_z), spawn $ "thunderbird" )
  , ((modMask, xK_d), spawn $ "discord" )
  , ((modMask, xK_w), spawn $ "libreoffice.writer" )
  , ((modMask, xK_F8), spawn $ "thunar" )
  , ((modMask, xK_F9), spawn $ "evolution" )
  , ((modMask, xK_F10), spawn $ "spotify" )
  , ((modMask, xK_p), spawn $ "rofi -show drun -config /home/juliusw/.config/rofi/themes/rofi-themes/OfficialThemes/Monokai.rasi")
  , ((modMask, xK_semicolon), spawn $ "rofi -show window -config /home/juliusw/.config/rofi/themes/rofi-themes/OfficialThemes/Monokai.rasi" )
  , ((modMask, xK_x), spawn $ "rofi -show p -modi p:rofi-power-menu -theme /home/juliusw/.config/rofi/themes/powermenu.rasi -width 20   -lines 6" )
  -- FUNCTION KEYS
  , ((0, xK_F12), spawn $ "xfce4-terminal --drop-down" )

  -- SUPER + SHIFT KEYS

  , ((modMask .|. shiftMask , xK_Return ), spawn $ "thunar")
  , ((modMask .|. shiftMask , xK_d ), spawn $ "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_c ), kill)
  -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))

  -- CONTROL + ALT KEYS

  , ((controlMask .|. mod1Mask , xK_Next ), spawn $ "conky-rotate -n")
  , ((controlMask .|. mod1Mask , xK_Prior ), spawn $ "conky-rotate -p")
  , ((controlMask .|. mod1Mask , xK_a ), spawn $ "xfce4-appfinder")
  , ((controlMask .|. mod1Mask , xK_b ), spawn $ "thunar")
  , ((controlMask .|. mod1Mask , xK_c ), spawn $ "catfish")
  , ((controlMask .|. mod1Mask , xK_e ), spawn $ "arcolinux-tweak-tool")
  , ((controlMask .|. mod1Mask , xK_f ), spawn $ "firefox")
  , ((controlMask .|. mod1Mask , xK_g ), spawn $ "chromium -no-default-browser-check")
  , ((controlMask .|. mod1Mask , xK_i ), spawn $ "nitrogen")
  , ((controlMask .|. mod1Mask , xK_k ), spawn $ "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_l ), spawn $ "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_m ), spawn $ "xfce4-settings-manager")
  , ((controlMask .|. mod1Mask , xK_o ), spawn $ "$HOME/.xmonad/scripts/picom-toggle.sh")
  , ((controlMask .|. mod1Mask , xK_p ), spawn $ "pamac-manager")
  , ((controlMask .|. mod1Mask , xK_r ), spawn $ "rofi-theme-selector")
  , ((controlMask .|. mod1Mask , xK_s ), spawn $ "spotify")
  , ((controlMask .|. mod1Mask , xK_t ), spawn $ "urxvt")
  , ((controlMask .|. mod1Mask , xK_u ), spawn $ "pavucontrol")
  , ((controlMask .|. mod1Mask , xK_v ), spawn $ "vivaldi-stable")
  , ((controlMask .|. mod1Mask , xK_Return ), spawn $ "urxvt")
  , ((controlMask .|. mod1Mask , xK_Delete ), spawn $ "sysmontask")

  -- ALT + ... KEYS

  , ((mod1Mask, xK_f), spawn $ "variety -f" )
  , ((mod1Mask, xK_n), spawn $ "variety -n" )
  , ((mod1Mask, xK_p), spawn $ "variety -p" )
  , ((mod1Mask, xK_r), spawn $ "xmonad --restart" )
  , ((mod1Mask, xK_t), spawn $ "variety -t" )
  , ((mod1Mask, xK_Up), spawn $ "variety --pause" )
  , ((mod1Mask, xK_Down), spawn $ "variety --resume" )
  , ((mod1Mask, xK_Left), spawn $ "variety -p" )
  , ((mod1Mask, xK_Right), spawn $ "variety -n" )
  , ((mod1Mask, xK_F2), spawn $ "gmrun" )
  , ((mod1Mask, xK_F3), spawn $ "xfce4-appfinder" )

  --VARIETY KEYS WITH PYWAL

  , ((mod1Mask .|. shiftMask , xK_f ), spawn $ "variety -f && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_n ), spawn $ "variety -n && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_p ), spawn $ "variety -p && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_t ), spawn $ "variety -t && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_u ), spawn $ "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")

  --CONTROL + SHIFT KEYS

  , ((controlMask .|. shiftMask , xK_Escape ), spawn $ "xfce4-taskmanager")

  --SCREENSHOTS

  , ((0, xK_Print), spawn $ "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")
  , ((controlMask, xK_Print), spawn $ "xfce4-screenshooter" )
  , ((controlMask .|. shiftMask , xK_Print ), spawn $ "gnome-screenshot -i")
  , ((modMask , xK_n ), spawn $ "nitrogen --set-zoom-fill --random")


  --MULTIMEDIA KEYS
  , ((0, xK_F7), spawn $ "amixer -q set Master 10%+")
  , ((0, xK_F6), spawn $ "amixer -q set Master 10%-")

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")

  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 10%-")

  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 10%+")

  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn $ "echo '392781243' | sudo --stdin lxqt-backlight_backend --inc 10")

  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn $ "echo '392781243' | sudo --stdin lxqt-backlight_backend --dec 10")

--toggle pause
  , ((0, xF86XK_AudioPlay), spawn $ "deadbeef --toggle-pause")
  , ((myModMask .|. shiftMask,xK_q), spawn $ "deadbeef --toggle-pause")
--Next Song
  , ((0, xF86XK_AudioNext), spawn $ "deadbeef --next")
  , ((myModMask .|. shiftMask,xK_Right), spawn $ "deadbeef --next")
--Previous Song
  , ((0, xF86XK_AudioPrev), spawn $ "deadbeef --prev")
  , ((myModMask .|. shiftMask,xK_Left), spawn $ "deadbeef --prev")
--Stop DeaDBeeF
  , ((0, xF86XK_AudioStop), spawn $ "deadbeef --stop")
--DeaDBeeF Volume Controls
  , ((myModMask .|. shiftMask,xK_Up), spawn $ "deadbeef --volume +10")
  , ((myModMask .|. shiftMask,xK_Down), spawn $ "deadbeef --volume -10")

  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  --Focus selected desktop
  , ((mod1Mask, xK_Tab), nextWS)

  --Focus selected desktop
  , ((modMask, xK_Tab), nextWS)
  , ((modMask .|. shiftMask, xK_Tab), prevWS)
  --Focus selected desktop
  , ((modMask , xK_Left ), prevWS)

  --Focus selected desktop
  , ((modMask , xK_Right ), nextWS)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k), windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask .|. shiftMask, xK_m), windows W.focusMaster  )

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

  -- Swap the focused window with the next window.
  , ((controlMask .|. modMask, xK_Down), windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

  -- Swap the focused window with the previous window.
  , ((controlMask .|. modMask, xK_Up), windows W.swapUp  )

  -- Shrink the master area.
  , ((modMask .|. shiftMask , xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask .|. shiftMask , xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((mod1Mask .|. shiftMask , xK_t), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

  --French Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_minus, xK_egrave, xK_underscore, xK_ccedilla , xK_agrave]

  --Belgian Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]

      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_q, xK_e] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

--myStartupHook = spawn "polybar mainbar-xmonad --config=/home/juliusw/.polybar/config" spawn "nitrogen --set-zoom-fill --random" return ()
main :: IO ()
main = do 

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    xmonad $ ewmh $ myBaseConfig {
  logHook = ewmhDesktopsLogHook
, startupHook = myStartupHook
, layoutHook = gaps [(U,30), (D,5), (R,5), (L,5)] $ myLayout ||| layoutHook myBaseConfig
, manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
, modMask = myModMask
, borderWidth = myBorderWidth
, handleEventHook = docksEventHook <+> fullscreenEventHook 
, focusFollowsMouse = myFocusFollowsMouse
, workspaces = myWorkspaces
, focusedBorderColor = focdBord
, normalBorderColor = normBord
, keys = myKeys
, mouseBindings = myMouseBindings
}