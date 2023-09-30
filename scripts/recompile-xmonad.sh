cd $HOME/.config/xmonad
mkdir $HOME/.scripts || true
mkdir $HOME/.scripts/xmonad || true
ghc -dynamic --make xmonad.hs -i$HOME/.config/xmonad/ -ilib -fforce-recomp -main-is main -v0 -outputdir $HOME/.scripts/xmonad/build-x86_64-linux -o $HOME/.scripts/xmonad/xmonad-x86_64-linux
