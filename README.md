## Using Kali-Linux to access FileVault encrytped APFS disk

Inspired by the [work published here](https://null-byte.wonderhowto.com/how-to/hacking-macos-break-into-macbook-encrypted-with-filevault-0185177/). Attempting to access an encrypted disk may be considered illegal; proceed with caution.

As the Kali Iso requires a number of steps to build the apfs-fuse extension, it's frustrating to do so on a live ISO. Here the code can be taken directly and the runMe.sh scrpt can be run to setup and build the full package. The only requirement will be the need to have `git` installed. 

Get your Kali distro here (why Kali: it's lightweight and supports a lot of tools already!)
https://cdimage.kali.org/kali-2022.3/kali-linux-2022.3-live-amd64.iso

Next, use distutils to create your boot disk
`diskutil list` to identify your USB disk

```
diskutil list
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         1.0 TB     disk0
   1:             Apple_APFS_ISC                         524.3 MB   disk0s1
   2:                 Apple_APFS Container disk3         994.7 GB   disk0s2
   3:        Apple_APFS_Recovery                         5.4 GB     disk0s3

/dev/disk3 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +994.7 GB   disk3
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            15.4 GB    disk3s1
   2:              APFS Snapshot com.apple.os.update-... 15.4 GB    disk3s1s1
   3:                APFS Volume Preboot                 407.9 MB   disk3s2
   4:                APFS Volume Recovery                822.1 MB   disk3s3
   5:                APFS Volume Data                    697.7 GB   disk3s5
   6:                APFS Volume VM                      3.2 GB     disk3s6

/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *61.5 GB    disk4
   1:                 DOS_FAT_32 RECOVERY                34.4 GB    disk4s1
                    (free space)                         27.2 GB    -
```

So my disk is /dev/disk4.

Use this command to unmount disk first: `diskutil unmountDisk /dev/disk4` followed by the lovely `dd` command: 
```
dd if=/path/to/kali-linux-2022.3-live-amd64.iso of=/dev/disk4 bs=4M
```
NOTE: dd is a low level copy command; use it with extreme caution. It's silent in its execution and will only show an output when it's done:
```
893+1 records in
893+1 records out
3748147200 bytes transferred in 915.043994 secs (4096139 bytes/sec)
```

## Instructions:
1. follow the above to create your bootable Kali USB
2. insert USB into your target Mac, hold the `option` key pressed and choose the USB drive (EFI) when prompted
3. choose the Kali live option & establish an internet connection once Kali comes up
4. get this repository: `git clone https://github.com/zimmerst/apfs-fuse-filevault.git`
5. go to the folder `cd apfs-fuse-filevault` and make sure you are root `sudo su`
6. once done, call `build-fuse.sh` and follow instructions
7. use `fdisk -l` (as root) to identify your target device, in my case it was `/dev/sda`
8. when everything is finished, use the `apfs_brute.sh` script to attempt accessing your filevault-encrypted disk

## Goodies:
The repo contains two additional folders: `utils` and `seclists`. 

#### SecList
The latter contains an excerpt from the [brilliant work by Daniel Miessler](https://github.com/danielmiessler/SecLists) which however was too big for the live image to be included. seclist contains a set of commonly used passwords that have been leaked through the past.

#### Utils:
Currently only one helper script: `gen_dates.sh` which can be used to generate a sequence of dates between a start date and an end date, use as below
```
./utils/gen_dates.sh "20220101" "20220131" > output.txt
```
which will generate the sequence and [pipe](https://www.geeksforgeeks.org/piping-in-unix-or-linux/) it to `output.txt`. The script generates sequences following the 'YYYY-MM-DD' format but contains a commented line that shows different formattings. Follow instructions in script to switch.

#### Cracken: 
See [here for a detailed account on what cracken does](https://github.com/shmuelamar/cracken) and why it's been included in this package. The `build_fuse.sh` will build the cracken tool to be used in conjunction. Should, against all odds, `cracken` not work in your terminal (remember being root), use this to re-source the package: `export PATH=${HOME}/.cargo/bin:${PATH}` 
