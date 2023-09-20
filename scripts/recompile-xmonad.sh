cd $HOME/.config/xmonad
mkdir $HOME/.scripts || true
mkdir $HOME/.scripts/xmonad || true
# -dynamic
ghc --make xmonad.hs -i -ilib -fforce-recomp -main-is main -v0 -outputdir $HOME/.scripts/xmonad/build-x86_64-linux -o $HOME/.scripts/xmonad/xmonad-x86_64-linux
