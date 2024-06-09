# !/usr/bin/bash
echo 'system tests'
echo '1 test suites in "system"'

# TODO: probably need more
programs=(
  pacman
  zsh
  alacritty
  xterm
  vim
  curl
)

echo '  checking programs in path:'
count=0
failed_tests=0
for name in ${programs[@]}; do
  # TODO: table view?
  # TODO: make errors red and pass green?
  if which $name &> /dev/null; then
    echo "    $name .. yes"
  else
    let count+=1
    echo "    $name .. missing"
  fi
done

# TODO: config tests
# grub2 / efi / linux
# notifications
# networkmanager (applet, has no passwords exposed)

if (( count > 0)); then
  echo "  $count programs missing"
  let failed_tests+=1
else
  echo "  pass"
fi

if (( failed_tests > 0)); then
  echo "$failed_tests failed test suites"
  exit 1
else
  exit 0
fi

