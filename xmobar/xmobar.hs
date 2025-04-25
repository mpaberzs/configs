-- cabal install --overwrite-policy=always --flags=with_xft --flags=with_iwlib --flags=with_alsa
-- font awesome 6
-- Roboto font
-- https://archives.haskell.org/projects.haskell.org/xmobar/#dynnetwork-args-refreshrate
Config { font = "Roboto 14"
       , additionalFonts = [ 
             "Font Awesome 6 Free Solid 14"
         ]
       , bgColor = "#111111"
       , fgColor = "#EE9A00"
       -- , position = Static { xpos = 0, ypos = 0, width = 3360, height = 24 }
       , position = TopH 40
       , lowerOnStart = True
       , commands = [
    		   Run Date "<fn=1></fn><hspace=10/>%a %_d/%m<hspace=15/>%H:%M" "date" 10
           , Run Network "wlp0s20f3"   ["-L","0","-H","32","-x","","--normal","","--high","", "-t", "<hspace=5/>"] 10
           -- regular ethernet
           , Run Network "enp0s31f6"   ["-L","0","-H","32","-x","","--normal","","--high","", "-t", "<hspace=5/>"] 10
           -- phone USB ethernet tethering
           , Run Network "enp0s13f0u1" ["-L","0","-H","32","-x","","--normal","","--high","", "-t", "<hspace=5/>"] 10
           , Run Network "eeedo-vpn" ["-L","0","-H","32","-x","","--normal","","--high","", "-t", "<hspace=15/>"] 10
           -- regular volume
           , Run Volume "default" "Master" ["-t", "<status>", "--", "-o", "<fn=1></fn>", "-O", "", "-C", "#ee9a00", "-c", "#ee9a00", "-l", "", "-m", "", "-h", ""] 10
           , Run Kbd []
           -- mic volume
           , Run Volume "default" "Capture" ["-t", "<status>", "--", "-o", "<fn=1></fn>", "-O", "<fn=1></fn>", "-C", "#ee9a00", "-c", "#ee9a00"] 10
           , Run Wireless "wlp0s20f3" ["-t", "<fn=1></fn>"] 10
		       , Run Battery [
               "-t", "<acstatus><hspace=8/><left>%",
               "--",
               "-O", "<fn=1></fn>",
               "-i", "<fn=1></fn>",
               "-o", "<fn=1></fn>"
    	     ] 10
           , Run Com "/home/martins/.config/xmobar/passman.sh" [] "passman" 10
           , Run UnsafeXMonadLog
       ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "<hspace=20/>%UnsafeXMonadLog% }{ %passman%<hspace=25/>%enp0s13f0u1%%wlp0s20f3%%enp0s31f6%<hspace=25/>%eeedo-vpn%%default:Master%<hspace=30/>%default:Capture%<hspace=15/>|<hspace=15/>%battery%<hspace=15/>|<hspace=15/><hspace=10/>%kbd%<hspace=15/>|<hspace=15/>%date%<hspace=20/>"
       , textOffsets = [-1,40,-1]
       -- , iconOffset = 1
       }
