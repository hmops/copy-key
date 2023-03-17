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
$ ./ssh-copy-key.sh -c foo-bar-sshkey -p foo-pass,bar-pass,... --host foo,bar,... --user foo-user,bar-user,...
```

```console
$ ./ssh-copy-key.sh -c foo-bar-sshkey -p foo-pass,bar-pass --host foo,bar --user foo-user,bar-user

# output:
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "~/.ssh/mykeytest.pub"

    Number of key(s) added:        1

    Now try logging into the machine, with:   "ssh -o 'StrictHostKeyChecking=no' 'foo-user@foo'"
    and check to make sure that only the key(s) you wanted were added.


    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "~/.ssh/mykeytest.pub"

    Number of key(s) added:        1

    Now try logging into the machine, with:   "ssh -o 'StrictHostKeyChecking=no' 'bar-user@bar'"
    and check to make sure that only the key(s) you wanted were added.
```