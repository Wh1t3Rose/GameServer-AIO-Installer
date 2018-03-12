#!/bin/bash
 
##
# Multi-select menu in bash script
#
# bash-only code that does exactly what you want. It's short (~20 lines), but a
# bit cryptic for a begginner. Besides showing "+" for checked options, it also
# provides feedback for each user action ("invalid option", "option X was
# checked"/unchecked, etc). -- http://serverfault.com/a/298312
##
 
# customize with your own.
options=("AAA" "BBB" "CCC" "DDD")
 
menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}
 
prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
done
 
printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done
echo "$msg"