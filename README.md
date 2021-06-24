# cron

### task:
check logs. If current-time > n -> execute pgsql script. Is that it? 

### solution:
0. psql should be in 'trust' mode, or md5 (in latter case password should be used)
1. cron file:
    1. Change `/5` to `/n`, where `n` - period of minutes, after which script will be executed
    2. Change `cd ~/Workplace/Cron` to `cd path_to_your_dir`
2. task.sh:
    1. Change all the variables inside the task.sh file (seconds gap, path to log)
    2. Change psql code call
    3. Change `'{print $1}'` to `'{print $n}'` based on where the time is in the logs
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

task.sh executes this function:
```
#DECLARE hello_world text default 'hello world';
BEGIN 
RETURN 'hello world';
END;
```

### P.S.
Is checking for log existance required?


## Russian

### Подготовка:

0. Процедура должна быть доступна для вызова через терминал, вполне возможно, что для этого необходимо **одно** из:
    1. Права администратора (sudo)
    2. Настройка psql в режим trust, либо md5
    3. Создание отдельного пользователя для работы с БД
1. Внести необходимые изменения в cron файл:
    1. Сменить `/5` на `/n`, где `n` - периодичность в минутах, с которой будет *вызываться* скрипт
    2. Сменить `cd ~/Workplace/Cron` на `cd путь_до_папки_с_файлом_task.sh`
2. Внести необходимые изменения в task.sh файл:
    1. Сменить переменные:
        1. PATH_TO_LOG (путь до файла с логом)
        2. SECONDS_GAP (количество секунд, по истечению которых последний лог считается устаревшим, и появляеться необходимость в выполнениии  скрипта)
    2. Сменить вызов процедуры на свой (строчка под `#enter your code below`), а также, при необходимости, ключи команды psql (-U ваш_юзернейм и т.д.)
    3. Сменить `$1` в `awk '{print $1}'` на `$n`, где n - порядковый номер времени в логе (т.е. если лог представляет из себя some_info 05:05:05, то нужно $2, если лог 05:05:05 info, то нужно $1, если там еще дата сцеплена со временем, то возможно надо чутка поменять код)
3. Запустить cron сервис при помощи `crontab путь_до_файла_cron`)

### Тестирование:

Сверху есть раздел result, в котором видно, что логика скрипта работает (Вначале последний лог тайм является устаревшим, т.к. разница во времени - 400 секунд (больше установленных 300) -> происходит перезапись лога и выполняется действие), потом скрипт вызывается еще раз, но время с последнего лога меньше установленного `SECONDS_GAP` (т.к. лог был дополнен при последнем вызове скрипта), следовательно действие не происходит)

Поставл postgres, сделал БД test_db и написал хранимую мини процедуру my_function() :
```
#DECLARE hello_world text default 'hello world';
BEGIN 
RETURN 'hello world';
END;
```
Установил `SECONDS_GAP=1`, и cron в * * * ... (т.е. каждую минуту), таким образом каждую минуту будет вызываться скрипт, и будет выполнять действие, т.к. период в 60 секунд больше чем 1 секундный `SECONDS_GAP`. Происходит выполнение :
```
echo `printf '%(%T)T\n'` `psql -U postgres test_db -t -c "select my_function();"` >> "$PATH_TO_LOG"
```
Который записывает в `PATH_TO_LOG` текущую дату, и результат выполнения обращения к функции my_function() в БД test_db в среде psql.

Результат:
```
18:52:01 hello world
18:53:01 hello world
18:54:01 hello world
18:55:01 hello world
18:56:01 hello world
18:57:01 hello world
18:58:01 hello world
18:59:01 hello world
19:00:01 hello world
19:01:01 hello world
19:02:01 hello world
19:03:02 hello world
19:04:01 hello world
19:05:01 hello world
19:06:01 hello world
19:07:01 hello world
19:08:01 hello world
19:09:01 hello world
```








