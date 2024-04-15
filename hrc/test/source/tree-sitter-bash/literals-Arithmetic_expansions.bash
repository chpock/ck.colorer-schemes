

echo $((1 + 2 - 3 * 4 / 5))
a=$((6 % 7 ** 8 << 9 >> 10 & 11 | 12 ^ 13))
$(((${1:-${SECONDS}} % 12) + 144))
((foo=0))
echo $((bar=1))
echo $((-1, 1))
echo $((! -a || ~ +b || ++c || --d))
echo $((foo-- || bar++))
(("${MULTIBUILD_VARIANTS}" > 1))
$(("$(stat --printf '%05a' "${save_file}")" & 07177))
soft_errors_count=$[soft_errors_count + 1]
