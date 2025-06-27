#!/usr/bin/env bash
echo '"env tests deps" tests'

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
  yq
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

if (( failed_main_tests > 0)); then
  echo "$failed_main_tests failed tests"
  exit 1
else
  echo "all tests pass in \"env tests deps\""
  exit 0
fi

