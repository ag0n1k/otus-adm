# Working with (io)nice

### Task:
- Create script with two competing processes by IO with different ionice
- Create script with twi competing processes by CPU with different nice
## How to:

```bash
# start first console and start script:
$ time nice -n 0 bash ionice_test.sh
# there will be output with pid and updating speed stat

# start another console and start script:
$ time nice -n 10 bash ionice_test.sh
# there will be output with pid and updating speed stat

# start third console and play with ionice parameters by:
$ ionice -c2 -n 0 ${pid_from_first_console}
$ ionice -c2 -n 0 ${pid_from_second_console}

```

## Sample:
```bash
# first console:
$ time nice -n 0 bash ionice_test.sh 
#pid is 14763
#2939806208 bytes (2,9 GB, 2,7 GiB) copied, 45 s, 65,3 MB/s^C
#5951176+0 records in
#5951175+0 records out
#3047001600 bytes (3,0 GB, 2,8 GiB) copied, 45,8236 s, 66,5 MB/s


#real    0m45,846s
#user    0m1,811s
#sys     0m43,774s

# second console
$ time nice -n 20 bash ionice_test.sh 
#pid is 14755
#3566696448 bytes (3,6 GB, 3,3 GiB) copied, 49 s, 72,8 MB/s^C
#6985562+0 records in
#6985561+0 records out
#3576607232 bytes (3,6 GB, 3,3 GiB) copied, 49,1537 s, 72,8 MB/s


#real    0m49,203s
#user    0m2,129s
#sys     0m46,863s

# third console
$ ionice -c 2 -n 0 -p 14755
$ ionice -c 2 -n 7 -p 14763
```