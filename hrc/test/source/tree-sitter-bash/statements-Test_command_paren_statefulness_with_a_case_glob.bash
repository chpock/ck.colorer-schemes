

[[ ${test} == @($(IFS='|'; echo "${skip[*]}")) ]]

case ${out} in
*"not supported"*|\
*"operation not supported"*)
	;;
esac

case $1 in
-o)
	owner=$2
	shift
	;;
-g) ;;
esac

[[ a == \"+(?)\" ]]
