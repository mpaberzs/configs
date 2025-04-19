#!/usr/bin/env bash
rm -rf ~/.cabal
cabal update
cabal install --ghc-options=-dynamic --ghc --lib assoc-list xmonad xmonad-utils xmonad-contrib xmonad-extras X11 --allow-newer --overwrite-policy=always
cabal install xmonad --ghc-options=-dynamic --ghc --overwrite-policy=always --allow-newer
cabal install xmobar --ghc-options=-dynamic --ghc --flags="all_extensions" --overwrite-policy=always --allow-newer
