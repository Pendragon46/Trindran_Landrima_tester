#!/bin/bash

cleanup(){
	rm -rf void tmp resultat 
	exit 1
}

trap cleanup SIGINT

touch void ; rm -rf tmp resultat

if [ "$1" = "" ];then
	iteration=5
else
	iteration=$1
fi
if [ "$2" = "" ];then
	time=5
else
	time=$2
fi
progress_bar(){
	local 	space=$((iteration-1))
	local	bar_width=25
	local	hash_bar=$((bar_width/iteration))

	printf "\033[37;7mPhilo $1 $2 $3 $4\033[0m\t: ["
	for b in $(seq 0 $5);
	do
		for i in $(seq 0 $hash_bar);do printf "#";done
	done
	for b in $(seq $b $space);
	do
		for i in $(seq 0 $hash_bar);do printf " ";done
	done
	if [[ $5 -eq $iteration ]]; then
			printf "] "
		else
			printf "]\r"; 
	fi
}

check_death(){
	if cmp -s resultat void ; then
		printf "\033[01;32m OK \033[0m\n"
	else
		printf "\033[01;31m KO \033[0m\n"
		rm -f resultat tmp
		exit 1
	fi
}

philo(){
	for i in $(seq 0 $iteration)
	do
	progress_bar $1 $2 $3 $4 $i
	timeout $time ./philo $1 $2 $3 $4 >tmp
	grep " died" < tmp >> resultat;
	done
	check_death $1 $2 $3 $4
}

printf "\033[01;34m"
printf "\t╔═══════════════════════════════════════╗\n"
printf "\t║             DEBUT DU TEST             ║\n"
printf "\t╚═══════════════════════════════════════╝\n"
printf "\033[0m\n"
philo 3 800 200 60
philo 4 401 200 200
philo 200 40 200 200
rm -rf void tmp resultat 
