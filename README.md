# cron

### task:
check logs. If current-time > n -> execute pgsql script. Is that it? 

### solution:
1. cron file:
    1. Change `/5` to `/n`, where `n` - period of minutes, after which script will be executed
    2. Change `cd ~/Workplace/Cron` to `cd path_to_your_dir`
2. task.sh:
    1. Change all the variables inside the task.sh file (seconds gap, path to log)
    2. Change psql code call
3. Start cron executable with `crontab cron`


### result:

```
kirylmi@kirylmi-VirtualBox:~/Workplace/Cron$ ./task.sh 
last log time : 03:02:15
current time  : 03:08:55
time diff     : 400
installed gap : 300 seconds
doing stuff...
action        : done
log           : updated
kirylmi@kirylmi-VirtualBox:~/Workplace/Cron$ ./task.sh 
last log time : 03:08:55
current time  : 03:09:01
time diff     : 6
installed gap : 300 seconds
action	      : none

```

### P.S.
Is checking for log existance required?
