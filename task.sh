#!/bin/bash
#TO BE EDITED BASED ON THE ENVIRONMENT:
PATH_TO_LOG="./log.txt"
SECONDS_GAP=300

LAST_LOG=`tail -1 "$PATH_TO_LOG"`

#if log exists? to be done

LAST_DATETIME=`echo $LAST_LOG | awk '{print $1}'`


TIME_DIFF=$(expr `date +"%s"` - `date -d "$LAST_DATETIME" +"%s"`)

echo "last log time :" $LAST_DATETIME
echo "current time  :" `printf '%(%T)T\n'`
echo "time diff     :" $TIME_DIFF
echo "installed gap :" $SECONDS_GAP seconds

if [ $TIME_DIFF -le $SECONDS_GAP ]
then
  #if time difference is less(equals) than seconds gap -> do nothing 
  echo "action	      : none"
else
  echo "doing stuff..."
  #else we need to invoke pgsql procedure
  #enter your code below
  #psql -U postgres -d database_name -c 'SELECT SOMETHING...'
  echo "action        : done"
  echo `printf '%(%T)T\n'` some_info >> "$PATH_TO_LOG"
  echo "log           : updated"
fi 


