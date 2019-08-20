#!/bin/bash
# Roku management script

host="192.168.1.65"

# Get active app
getactive() {
	# Args: none
	# Output: active roku app
	wget -q -O - http://$host:8060/query/active-app
}

getinstalled() {
	# Args: none
	# Output: list of installed apps
	wget -q -O - http://$host:8060/query/apps
}

getinfo() {
	# Args: none
	# Output: device info
	wget -q -O - http://$host:8060/query/device-info
}

mvup() {
	# Args: none
	# Output: none
	wget -q --post-data="" http://$host:8060/keypress/up
}

mvdown() {
	# args: none
	# output: none
	wget -q --post-data="" http://$host:8060/keypress/down
}

mvleft() {
	# args: none
	# output: none
	wget -q --post-data="" http://$host:8060/keypress/left
}

mvright() {
	# args: none
	# output: none
	wget -q --post-data="" http://$host:8060/keypress/right
}

remote() {
	# args: none
	# output: none
	commands=(home rev fwd play select left right up down back instant replay info backspace search enter)
	while :
	do
		read -p "roku:~# " input
		if [ $input == "exit" ]; then
			break
		fi
		if [ $input == "help" ]; then
			echo -e "home\nrev\nfwd\nplay\nselect\nleft\nright\ndown\nup\nback\ninfo\nbackspace\ninstantreplay\nsearch\nenter"
		fi
		wget -q --post-data="" http://$host:8060/keypress/$input
	done
}

killapp() {
	# args: app to kill
	# output: none
	while :
	do
		echo "[i] Killing $1"
		wget -q -O - http://$host:8060/query/active-app | grep -q -i "$1"
		if [ $? == 0 ]; then
			wget -q --post-data="" http://$host:8060/keypress/home
		fi
		sleep 10
	done
}

office() {
	# start the office
	# intended to be started from the home screen
	wget -q --post-data="" http://$host:8060/keypress/right
	wget -q --post-data="" http://$host:8060/keypress/select
	sleep 12
	wget -q --post-data="" http://$host:8060/keypress/search
	sleep 8
	wget -q --post-data="" http://$host:8060/keypress/down
	wget -q --post-data="" http://$host:8060/keypress/down
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/right
	wget -q --post-data="" http://$host:8060/keypress/right
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/select
	wget -q --post-data="" http://$host:8060/keypress/right
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/right
	wget -q --post-data="" http://$host:8060/keypress/right
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/up
	wget -q --post-data="" http://$host:8060/keypress/up
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/select
	wget -q --post-data="" http://$host:8060/keypress/select
	sleep 0.5
	wget -q --post-data="" http://$host:8060/keypress/right
	wget -q --post-data="" http://$host:8060/keypress/select
	sleep 15
	wget -q --post-data="" http://$host:8060/keypress/right
	wget -q --post-data="" http://$host:8060/keypress/select
	exit
}

if [ $# == 0 ] || [ $1 == "-h" ] || [ $1 == "--help" ]; then
	echo "usage: $0 <command>"
	echo -e "# commands #\ngetactive - get the active app\ngetinstalled - get list of installed apps\ngetinfo - get roku device info\nmv(up/down/left/right) - move roku cursor in specified direction\nremote - use interactive cli remote\nkillapp <app> - return to home screen if specified app is in use"
fi

$1
