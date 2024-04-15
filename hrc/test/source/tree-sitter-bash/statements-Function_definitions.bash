

do_something() {
  echo ok
}

run_subshell_command() (
  true
)

run_test_command() [[ -e foo ]]

function do_something_else() {
  a | xargs -I{} find xml/{} -type f
}

function do_yet_another_thing {
  echo ok
} 2>&1

do_nothing() { return 0; }

foo::bar() {
  echo what
}

foo::baz() {
  echo how
}

assert()
  if ! $1; then
    return 1
  fi
