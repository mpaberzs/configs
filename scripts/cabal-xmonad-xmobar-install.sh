#!/usr/bin/bash
# --ghc-options=-dynamic --ghc
rm -rf ~/.cabal
cabal update
cabal install --lib xmonad xmonad-utils xmonad-contrib xmonad-extras X11 --allow-newer --overwrite-policy=always
cabal install xmonad --overwrite-policy=always --allow-newer
cabal install xmobar --flags="all_extensions" --overwrite-policy=always --allow-newer
