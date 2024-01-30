#!/usr/bin/env bash

# 3.1.2.4 ANSI-C Quoting

$'\nfoo\e'
A=$'\\\'\"\?no special meaning'
CDPATH=$'octal \1 \12 \123 foo' $'octal error \9 \19 \181 foo'
command ${CDPATH%$'test\rtest'} `in backquote $'test\1test'`
( in subshell $'\1' )
{ in group $'1'; }
command $'hex \x1 \x1a \xFFnospecial meaning'
A=$(foo $'unicode \u1 \uF1 \uFFA \udeadno special meaning')
$'unicode \U1 \UF1 \UFFA \Udead \UDEAD1 \U12345 \U123456 \U1234567 \U12345678no special meaning'
$'control-x \cx no cpecial meaning'

# 3.1.2.5 Locale-Specific Translation

$"some message"
A=$"some message $VAR inside"
CDPATH=$"msg $'ansi-c\\here\r'"
command ${CDPATH%$"msg $(command)"}
( in subshell $"msg" )
{ in group $"msg"; }
A=$(foo $"something $'ansi-c\t\\' ${CDPATH#$"msg"}") `in bq $"some\$th\\i\ng"`

# 5.1 Bourne Shell Variables

$CDPATH $HOME $IFS $MAIL $MAILPATH $OPTARG $OPTIND $PATH $PS1 $PS2

${#CDPATH}

CDPATH=1 CDPATH=somestring

# 5.2 Bash Variables

$_ $BASH $BASHOPTS $BASHPID $BASH_ALIASES $BASH_ARGC
$BASH_ARGV $BASH_ARGV0 $BASH_CMDS $BASH_COMMAND $BASH_COMPAT $BASH_ENV
$BASH_EXECUTION_STRING $BASH_LINENO $BASH_LOADABLES_PATH $BASH_REMATCH
$BASH_SOURCE $BASH_SUBSHELL $BASH_VERSINFO $BASH_VERSION $BASH_XTRACEFD
$CHILD_MAX $COLUMNS $COMP_CWORD $COMP_LINE $COMP_POINT $COMP_TYPE $COMP_KEY
$COMP_WORDBREAKS $COMP_WORDS $COMPREPLY $COPROC $DIRSTACK $EMACS $ENV $EPOCHREALTIME
$EPOCHSECONDS $EUID $EXECIGNORE $FCEDIT $FIGNORE $FUNCNAME $FUNCNEST $GLOBIGNORE
$GROUPS $histchars $HISTCMD $HISTCONTROL $HISTFILE $HISTFILESIZE $HISTIGNORE
$HISTSIZE $HISTTIMEFORMAT $HOSTFILE $HOSTNAME $HOSTTYPE $IGNOREEOF $INPUTRC
$INSIDE_EMACS $LANG $LC_ALL $LC_COLLATE $LC_CTYPE $LC_MESSAGES $LC_NUMERIC
$LC_TIME $LINENO $LINES $MACHTYPE $MAILCHECK $MAPFILE $OLDPWD $OPTERR $OSTYPE
$PIPESTATUS $POSIXLY_CORRECT $PPID $PROMPT_COMMAND $PROMPT_DIRTRIM $PS0 $PS3 $PS4
$PWD $RANDOM $READLINE_ARGUMENT $READLINE_LINE $READLINE_MARK $READLINE_POINT
$REPLY $SECONDS $SHELL $SHELLOPTS $SHLVL $SRANDOM $TIMEFORMAT $TMOUT $TMPDIR $UID

${#BASH}

BASH=1 BASH=somestring

# Bash variables in for loop

for CDPATH; do
    foo
done

for CDPATH in 1 2 3; do
    foo
done

# Bash variables in commands that take variable names

export CDPATH CDPATH=123
unset CDPATH

