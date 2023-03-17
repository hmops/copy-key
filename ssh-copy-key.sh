# !/usr/bin/env bash

######## USAGE ########
function _usage(){
	echo "Usage: 
	-c --create	- create a new ssh with given name
	-n --name	- exist ssh-key filename
	-p --pass	- hosts passwords
	-i --host	- hostsnames or ips
	-u --user	- usernames
	"
}

######## CREATE SSH - KEY ########
function _create_ssh_key(){
	echo "creating ssh ..."

	#  -N new_passphrase provides the new passphrase.
	#  -q                silence ssh-keygen.
	#  -f filename       specifies the filename of the key file.
	ssh-keygen -q -t rsa -N '' -f $HOME/.ssh/$1 <<<y >/dev/null 2>&1
}

######## COPY SSH-KEY ID ########
function _cp_ssh_key(){

	echo "copying ssh keys.pub ..."
	IFS=','
	read -ra users <<< "$1"
	read -ra hosts <<< "$2"
	read -ra pass <<< "$3"

	## single user - multiple pass
	if [[ ${#users[@]} -eq 1 && ${#pass[@]} -gt 1 && ${#pass[@]} -eq ${#hosts[@]} ]]; then
		
		i=0
		while [ $i -lt ${#hosts[@]} ]; do
			echo "sshpass -p ${pass[$i]} ssh-copy-id -i /$HOME/.ssh/$4.pub -f -o StrictHostKeyChecking=no ${users[0]}@${hosts[$i]}"
			i=$(( $i + 1 ))
		done
	
	## single user/pass
	elif [[ ${#users[@]} -eq 1 && ${#pass[@]} -eq 1 ]]; then
		
		for host in "${hosts[@]}"; do
			sshpass -p ${pass[0]} ssh-copy-id -i /$HOME/.ssh/$4.pub -f -o StrictHostKeyChecking=no ${users[0]}@$host
		done
	
	
	## multiple user/pass
	elif [[ ${#users[@]} -gt 1 && ${#pass[@]} -gt 1 && ${#pass[@]} -eq ${#hosts[@]} ]]; then
	
		i=0
		while [ $i -lt ${#hosts[@]} ]; do
		
			sshpass -p ${pass[$i]} ssh-copy-id -i /$HOME/.ssh/$4.pub -f -o StrictHostKeyChecking=no ${users[$i]}@${hosts[$i]}
			i=$(( $i + 1 ))	
		done
	
	## single pass multiple users
	elif [[ ${#users[@]} -gt 1 && ${#pass[@]} -eq 1 && ${#users[@]} -eq ${#hosts[@]} ]]; then
		
		i=0
		while [ $i -lt ${#hosts[@]} ]; do
			sshpass -p ${pass[0]} ssh-copy-id -i /$HOME/.ssh/$4.pub -f -o StrictHostKeyChecking=no ${users[$i]}@${hosts[$i]}
			i=$(( $i + 1 ))
		done
	

	else
		_usage
		exit 1
	fi
}


for param in "$@"; do
	shift
	case "$param" in
		"--help") set -- "$@" "-h" ;;
		"--create") set -- "$@" "-c" ;;
		"--pass") set -- "$@" "-p" ;;
		"--host") set -- "$@" "-i" ;;
		"--user") set -- "$@" "-u" ;;
		*) set -- "$@" "$param" ;;

	esac
done

OPTIND=1
while getopts ":c:h:u:i:p:" opt; do
	case "$opt" in
		h)
			_usage
			exit 0
			;;
		c)
			create_ssh_key=true
			key_name=${OPTARG}
			;;
		i)
			hosts=true; ips=${OPTARG}
			;;
		p)
			pass=true
			passwords=${OPTARG}
			;;
		u)
			user=true
			users=${OPTARG}
			;;
		?)
			_usage >&2
			exit 1
			;;
	esac
done

shift $((OPTIND - 1))

if [[ -n "${create_ssh_key}" ]]; then 
	_create_ssh_key $key_name
fi


if [[ -n "${hosts}" && -n "${pass}" && -n "${user}" ]]; then
	_cp_ssh_key $users $ips $passwords $key_name
else
	_usage >&2
	exit 1
fi
