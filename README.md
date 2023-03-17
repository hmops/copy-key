# ssh-copy-key
Generate and Copy ssh-key ids to multiple servers 


### Usage

```console
$ chmod +x ssh-copy-key.sh 
$ ./ssh-copy-key.sh --help
# output:
Usage:
	-c --create	- create a new ssh with given name
	-n --name	- exist ssh-key filename
	-p --pass	- hosts passwords
	-i --host	- hostsnames or ips
	-u --user	- usernames

```

### Example


```console

# ./ssh-copy-key.sh -c foo-bar-sshkey -p foo-pass,bar-pass,... --host foo,bar,... --user foo-user,bar-user,...

$ ./ssh-copy-key.sh -c foo-bar-sshkey -p foo-pass,bar-pass --host foo,bar --user foo-user,bar-user
```