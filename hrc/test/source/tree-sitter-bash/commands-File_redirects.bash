

whoami > /dev/null
cat a b > /dev/null
2>&1 whoami
echo "foobar" >&2
[ ! command -v go &>/dev/null ] && return

if [ ]; then
	>aa >bb
fi

exec {VIRTWL[0]} {VIRTWL[1]} <&- >&-
exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-

grep 2>/dev/null -q "^/usr/bin/scponly$" /etc/shells

x <x a b c
