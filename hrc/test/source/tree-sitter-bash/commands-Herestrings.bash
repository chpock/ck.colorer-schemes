

node <<< foo

while read -u 3 entry; do
  echo $entry
done 3<<<"$ENTRIES"

$(tc-getCC) -Werror -Wl,-l:libobjc.so.${ver} -x objective-c \
		- <<<$'int main() {}' -o /dev/null 2> /dev/null;

<<<string cmd arg

cmd arg <<<string

cmd <<<string arg

<<<string
