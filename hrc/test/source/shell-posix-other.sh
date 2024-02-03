#!/bin/sh

# -------------------------------------------------------------
# some random tests
# -------------------------------------------------------------

# simple comment

    # comment here with indent

"double quote string" "double quote $VAR here"111 "double quote $ error here" "escape does \work here"

'single'mix"double"string'double inside"here'or"single inside'here"

var1="test" var2='test' run command this_is_not=variable

var1="test" var2='test' run command this_is_not=variable | but_this_is_variable=1 run command not_variable=1

VAR2="test" "string after variable" ,sdkfljalkjf

    VAR=1 command & VAR2=1wordwithnum command2
VAR=1 command & VAR2= command2 ; VAR3= command 3; VAR4= command4; # comment here
VAR=1 command && VAR2=wordwithnum1 command2
VAR=1 command || VAR2= command2
VAR=1 command >/test 2>/test2 3>/test3 || VAR2= command2 < space_here

VAR=1 ! command

! VAR12=123123 ! SSDF=23234 command sfljsdfj ! slkdfjalsdj

VAR=1 command escaped ampersand \& VAR2= command2 \
    THIS_IS_NOT_VAR=1 because the above line continues

command plain \# quoted comment

( VAR=foo subshell && VAR3= run command >/test 2>&1 )
$(VAR1=foo another subshell;)

( command
)

{ VAR=rrrt group1 PARAM= PARAM=1; VAR=4 group2 TEST=1 && VAR5=Xxx test it }
}

2.7. writes '2' into file a: echo \2>a
     writes '2>a' to standard output: echo 2\>a

2>$TEST 4>>"$TEST"
2>/test
1</test
>/test
</test

2>&1
2>&1
2>&-
3<&1
echo>&1
echo >&1
echo >$foo/bar

func() { VAR=123 safasdfasdfasdf >&12
}

foo() {
}

[ -x bla ] || set -1

[
      ]

while [ $IDX -le 10 ]; do
     sdf; done
if; then
fi

if ! bla bla;
    teJst commanJd; then
    if F=123 lfkjlkj >dev/null 2>&1; then
        sdfsdfasdfsdf
    elif [ test -x 123 ]; then
        doit something
fi
else
    doit else
fi

[ J[st
J]en]; [
Jst ]

's`df`as'sdfas"df$TESTas.df"as$df'd$TESTbf'with-mixed-$VARIABLES-error-at-the-end$ # comment here

special variables1 $0 x $1 x $2 x $3 x $4 x $5 x $6 x $7 x $8 x $9 x
special variables1 ${0} x ${1} x ${2} x ${3} x ${4} x ${5} x ${6} x ${7} x ${8} x ${9} x
special variables2 $# $* $@ $? $! $$ $- no variables
special variables2 ${#} ${*} ${@} ${?} ${!} ${$} ${-} no variables

test >123

"do\"ub'skdfjjkafa\0x0000jkfffffsh'dkjhle" sdkalskjfla l lak sldfk alsk dflkaj

# sdfasf

asd="test" test= sdkfjj= runcmd NOGL= | && slkfjkj >1

asd=123123 runcmd param NOGL= | VAR2=dkfjsk dkfjkj

echo cmd param\; # comment now

A="ffff"
A="fff $(test do) aaa"
B=

fn() {
    echo 123 >&1
    run cmd

}
