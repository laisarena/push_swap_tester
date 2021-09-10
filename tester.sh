# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    tester.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lmartins <lmartins@student.42sp.org.br>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 16:53:09 by lfrasson          #+#    #+#              #
#    Updated: 2021/09/10 08:48:44 by lmartins         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

NUM_TESTS=100
PUSH_SWAP=./push_swap
CKER=1
RET_CKER="is not working"

GREEN="\033[32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
MUTED="\033[1;30m"
RESET="\033[0m"
BOLD="\033[1m"

rm -rf log_error
mkdir log_error
mkdir log_error/five
mkdir log_error/hundred
mkdir log_error/five_hundred

FLAG=all
while getopts f:n: flag
do
	case "${flag}" in
		f) FLAG=${OPTARG};;
		n) NUM_TESTS=${OPTARG};;
	esac
done

if ! command -v ruby &> /dev/null
then
	echo -e "${RED}${BOLD}Ruby not found. Aborting"
	echo -e "If using Linux, try 'sudo apt-get install ruby' to install${RESET}"
	exit
fi

if [ "$(eval uname)" == "Linux" ]
then
	CHECKER=./checker_linux
else
	CHECKER=./checker
fi

if ! command -v $CHECKER &> /dev/null
then
	echo -en "${RED}${BOLD}\n./checker is not working.\nSo this script will only check the number of operations\n${RESET}"
	CKER=0
fi

seq 1 5 | shuf > /dev/null
if [ $? == 0 ]
then
	SHUF_OK=1
else
	SHUF_OK=0
fi

echo $SHUF_OK

error()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	RET=`$PUSH_SWAP $ARG 2>&1`
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
	RET=`$PUSH_SWAP $ARG 2>&1`
	if [ "$RET" != "" ];
		then
		echo -e "${RED}Fail${RESET}"
	else
		echo -e "${GREEN}Success${RESET}"
	fi
}

checker2()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	if (( $CKER == 1))
	then
		RET_CKER=`$PUSH_SWAP $ARG | $CHECKER $ARG`
	fi
	RET2=`$PUSH_SWAP $ARG | wc -l | bc`
	if [ "$RET_CKER" == "OK" ] && (($RET2 == 1));
		then
			echo -e "${GREEN}Success (checker $RET_CKER | $RET2 instructions)${RESET}"
	else
		echo -e "${RED}Fail (checker $RET_CKER | $RET2 instructions)${RESET}"
	fi
}

checker3()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	if (( $CKER == 1))
	then
		RET_CKER=`$PUSH_SWAP $ARG | $CHECKER $ARG`
	fi
	RET2=`$PUSH_SWAP $ARG | wc -l | bc`
	if [ "$RET_CKER" == "OK" ] && (($RET2 == 2)) || (($RET2 == 3));
		then
			echo -e "${GREEN}Success (checker $RET_CKER | $RET2 instructions)${RESET}"
	else
		echo -e "${RED}Fail (checker $RET_CKER | $RET2 instructions)${RESET}"
	fi
}

checker5()
{
	echo -en "${RESET}$1 => ${YELLOW} ./push_swap $2 => "
	ARG="$2"
	if (( $CKER == 1))
	then
		RET_CKER=`$PUSH_SWAP $ARG | $CHECKER $ARG`
	fi
	RET2=`$PUSH_SWAP $ARG | wc -l | bc`
	if [ "$RET_CKER" == "OK" ] && (($RET2 <= 12));
		then
			echo -e "${GREEN}Success (checker $RET_CKER | $RET2 instructions)${RESET}"
	else
		echo -e "${RED}Fail (checker $RET_CKER | $RET2 instructions)${RESET}"
	fi
}

random_checker()
{
	echo -e "${RESET}$1"
	if (($3 == 12));
		then
		FILE="log_error/five/test_"
		fi
	if (($3 == 1500));
		then
		FILE="log_error/hundred/test_"
		fi
	if (($3 == 11500));
		then
		FILE="log_error/five_hundred/test_"
		fi
	ERR=0
	sum=0
	count=0
	for ((i = 0; i < NUM_TESTS; i++))
		do
			if [ $SHUF_OK == 1 ]
			then
				unset n
				n=$4
				ARG=$(seq 1 $n | awk '{print $1 - a}' a=$(expr $n / 2) | shuf | tr '\n' ' ')
			else
				ARG=`ruby -e "puts $2.to_a.shuffle.join(' ')"`
			fi
			if (( $CKER == 1))
			then
				RET_CKER=`$PUSH_SWAP $ARG | $CHECKER $ARG`
			fi
			RET2=`$PUSH_SWAP $ARG | wc -l | bc`
			if [ "$RET_CKER" != "OK" ];
				then
				((ERR++))
				echo -en "${RED}▓$RET2▓${RESET}"
				echo "$1" > $FILE$i
				echo "$ARG" >> $FILE$i
				if (($3 == 12))
					then
					COMMANDS= $PUSH_SWAP $ARG >> $FILE$i
					fi
				echo "Qtt commands = $RET2" >> $FILE$i
				echo "Test Checker = $RET_CKER" >> $FILE$i
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

echo $FLAG

if [ "$FLAG" = "all" ] || [ "$FLAG" = "error" ]; then
	echo -e "\n${BOLD}Error management${RESET}\n"
	error "Non numeric parameters" "3 aa 1"
	error "Duplicate numeric parameter" "3 3 1"
	error "Only numeric parameters including one greater than MAX INT" "3 1 2147483648"
	error "Only numeric parameters including one less than MIN INT" "3 1 -2147483649"
fi

if [ "$FLAG" = "all" ] || [ "$FLAG" = "sorted" ]; then
	echo -e "\n${BOLD}Identity test${RESET}\n"
	do_noting "Without any parameters"
	do_noting "With a list that has already been sorted" "42"
	do_noting "With a list that has already been sorted" "0 1 2 3"
	do_noting "With a list that has already been sorted" "0 1 2 3 4 5 6 7 8 9"
fi

if [ "$FLAG" = "all" ] || [ "$FLAG" = "simple" ]; then
	echo -e "\n${BOLD}Simple version${RESET}\n"
	checker2 "Two numbers" "2 1"
	checker3 "Three numbers" "2 1 0"
	checker5 "Five numbers" "1 5 2 4 3"
	random_checker "Random list of Five numbers" "(0..4)" 12 5
fi

if [ "$FLAG" = "all" ] || [ "$FLAG" = "middle" ]; then
	echo -e "\n${BOLD}Middle version${RESET}\n"
	echo -e "less than 700\t-> 5\nless than 900\t-> 4\nless than 1100\t-> 3\nless than 1300\t-> 2\nless than 1500\t-> 1\n"
	random_checker "Random list of hundred numbers -50 to 49" "(-50..49)" 1500 100
fi

if [ "$FLAG" = "all" ] || [ "$FLAG" = "advanced" ]; then
	echo -e "\n${BOLD}Advanced version${RESET}\n"
	echo -e "less than 5500\t-> 5\nless than 7000\t-> 4\nless than 8500\t-> 3\nless than 10000\t-> 2\nless than 11500\t-> 1\n"
	random_checker "Random list of five hundred numbers 0 to 499" "(0..499)" 11500 500
fi
