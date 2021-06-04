# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lfrasson <lfrasson@student.42sp.org.br     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 16:53:09 by lfrasson          #+#    #+#              #
#    Updated: 2021/06/04 16:53:38 by lfrasson         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

GREEN="\033[32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
MUTED="\033[1;30m"
RESET="\033[0m"
BOLD="\033[1m"

error()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	RET=$(./push_swap $ARG 2>&1)
	if [ "$RET" != "Error" ];
		then
		echo -e "${RED}Fail${RESET}"
	else
		echo -e "${GREEN}Success${RESET}"
	fi
}

do_noting()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	RET=$(./push_swap $ARG 2>&1)
	if [ "$RET" != "" ];
		then
		echo -e "${RED}Fail${RESET}"
	else
		echo -e "${GREEN}Success${RESET}"
	fi
}

checker3()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	RET1=`./push_swap $ARG | ./checker $ARG`
	RET2=`./push_swap $ARG | wc -l | bc`
	if [ "$RET1" == "OK" ] && (($RET2 == 2)) || (($RET2 == 3));
		then
			echo -e "${GREEN}Success (checker $RET1 | $RET2 instructions)${RESET}"
	else
		echo -e "${RED}Fail (checker $RET1 | $RET2 instructions)${RESET}"
	fi
}

checker5()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	RET1=`./push_swap $ARG | ./checker $ARG`
	RET2=`./push_swap $ARG | wc -l | bc`
	if [ "$RET1" == "OK" ] && (($RET2 <= 12));
		then
			echo -e "${GREEN}Success (checker $RET1 | $RET2 instructions)${RESET}"
	else
		echo -e "${RED}Fail (checker $RET1 | $RET2 instructions)${RESET}"
	fi
}

random_checker()
{
	echo -e "${RESET}$1"
	ERR=0
	sum=0
	count=0
	for i in range {1..9}
		do 
			ARG=`ruby -e "puts $2.to_a.shuffle.join(' ')"`
			RET1=`./push_swap $ARG | ./checker $ARG`
			RET2=`./push_swap $ARG | wc -l | bc`
			if [ "$RET1" != "OK" ];
				then
				((ERR++))
				echo -en "${RED}▓$RET2▓${RESET}"
			else
				echo -en "${GREEN}▓${RESET}"
			fi

			sum=$((sum + $RET2))
			((count++))
	done

	sum=$((sum / $count))
	if [ $ERR -eq 0 ] && [ $sum -le $3 ];
		then
		echo -en "${GREEN} Success"
		echo -e " - Average $sum ${RESET}$"
	else
		echo -en "${RED} Fail $ERR / $count"
		echo -e " - Average $sum ${RESET}$"
	fi
}

echo -e "\n${BOLD}Error management${RESET}\n"
error "Non numeric parameters" "3 aa 1"
error "Duplicate numeric parameter" "3 3 1"
error "Only numeric parameters including one greater than MAX INT" "3 1 2147483648"
error "Only numeric parameters including one greater than MIN INT" "3 1 -2147483649"

echo -e "\n${BOLD}Identity test${RESET}\n"
do_noting "Without any parameters"
do_noting "With a list that has already been sorted" "42"
do_noting "With a list that has already been sorted" "0 1 2 3"
do_noting "With a list that has already been sorted" "0 1 2 3 4 5 6 7 8 9"

echo -e "\n${BOLD}Simple version${RESET}\n"
checker3 "Three numbers" "2 1 0"
checker5 "Five numbers" "1 5 2 4 3"
random_checker "Random list of Five numbers" "(0..4)" 12

echo -e "\n${BOLD}Middle version${RESET}\n"
echo -e "less than 700\t-> 5\nless than 900\t-> 4\nless than 1100\t-> 3\nless than 1300\t-> 2\nless than 1500\t-> 1\n"
random_checker "Random list of hundred numbers -50 to 49" "(-50..49)" 1500
random_checker "Random list of hundred numbers -99 to 0" "(-99..0)" 1500
random_checker "Random list of hundred numbers 0 to 99" "(0..99)" 1500

echo -e "\n${BOLD}Advanced version${RESET}\n"
echo -e "less than 5500\t-> 5\nless than 7000\t-> 4\nless than 8500\t-> 3\nless than 10000\t-> 2\nless than 11500\t-> 1\n"
random_checker "Random list of five hundred numbers 0 to 499" "(0..499)" 11500
