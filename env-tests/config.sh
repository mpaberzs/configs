echo 'config tests'
echo '1 test suites in "config"'

failed_tests=0

if ! file -L ~/.config/nvim/init.lua &> /dev/null; then
  let failed_tests+=1
  echo '  nvim config exists .. failed'
else
  echo '  nvim config exists .. yes'
fi

if (( failed_tests > 0)); then
  echo "$failed_tests failed tests"
  exit 1
else
  exit 0
fi
