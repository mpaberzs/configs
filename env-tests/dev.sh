# !/usr/bin/bash
echo '"dev" tests'

failed_main_tests=0
failed_tests=0

# TODO: test utils?
function test_cmd() {
  local cmd="$1"
  local text_pass=$2
  local text_fail=$3

  if bash -c "$cmd &> /dev/null"; then
    echo "$text_pass"
  else
    echo "$text_fail"
    let failed_tests+=1
  fi
}

programs=(
  nvim
  node
  git
  ssh
  curl
  alacritty
  zsh
  docker
  npm
  python3
  mysql-workbench
  code
  libreoffice
  chromium
  firefox
  yq
  jq
)

echo '  checking programs in path:'
failed_tests=0
for name in ${programs[@]}; do
  # TODO: table view
  # TODO: make errors red and passing green
  text_exists="    $name .. yes"
  text_missing="    $name .. missing"
  
  test_cmd "which $name" "$text_exists" "$text_missing"
done

if (( failed_tests > 0)); then
  echo "  $failed_tests programs missing"
  let failed_main_tests+=1
else
  echo "  pass"
fi

echo '  checking config:'
let failed_tests=0

# nvim
test_cmd "file -L ~/.config/nvim/inits.lua" '    nvim config exists .. pass' '    nvim config exists .. failed'
test_cmd "nvim -l ~/.config/nvim/init.lua" '    nvim config compiles .. pass' '    nvim config compiles .. failed'
# alacritty
test_cmd "file -L ~/.config/alacritty/alacritty.toml" '    nvim config exists .. pass' '    nvim config exists .. failed'
# TODO: yq didn't like this file while it seems correct
# test_cmd "yq ~/.config/alacritty/alacritty.toml" '    nvim config compiles .. pass' '    nvim config compiles .. failed'

if (( failed_tests > 0)); then
  echo "  $failed_tests config issues"
  let failed_main_tests+=1
else
  echo "  pass"
fi

if (( failed_main_tests > 0)); then
  echo "$failed_main_tests failed tests"
  exit 1
else
  echo "all tests pass in \"dev\""
  exit 0
fi

