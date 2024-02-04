#!/bin/sh

# -------------------------------------------------------------
# some random tests
# -------------------------------------------------------------

VAR[1]=foo#bar VAR2=foo2 # <- here is VAR = 'foo#bar'
VAR[1]=foo)bar VAR2=foo2 # <- here is 'syntax error'
VAR[1]=foo;command       # <- here is 'VAR=foo' and a command
VAR[1]=foo&command       # <- here is 'VAR=foo' in background and a command
VAR[1]=foo|command       # <- here is 'VAR=foo' and a command
VAR[1]=foo>command       # <- here is 'VAR=foo' redirected to 'command'
VAR[1]=foo<command       # <- here is 'VAR=foo' with redirected stdin
VAR[1]=foo2>command      # <- here is 'VAR=foo2' redirected to 'command'
VAR[1]=foo1<command      # <- here is 'VAR=foo1' with redirected stdin
VAR[1]=foo1>&2           # <- here is 'VAR=foo1' with redirected stdout
