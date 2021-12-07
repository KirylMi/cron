#!/bin/bash
#TO BE EDITED BASED ON THE ENVIRONMENT:
PATH_TO_LOG="./log-with-date.txt"
SECONDS_GAP=300

LAST_LOG=`tail -1 "$PATH_TO_LOG"`

#if log exists? to be done

LAST_DATE=`echo $LAST_LOG | awk '{print $1}'`
LAST_TIME=`echo $LAST_LOG | awk '{print $2}'`


TIME_DIFF=$(expr `date +"%s"` - `date -d "$LAST_DATE $LAST_TIME" +"%s"`)

echo "last log time :" $LAST_DATE $LAST_TIME
echo "current time  :" `printf '%(%T)T\n'`
echo "time diff     :" $TIME_DIFF
echo "installed gap :" $SECONDS_GAP seconds

if [ $TIME_DIFF -gt $SECONDS_GAP ]
then
  echo "doing stuff..."
  #enter your code below
  echo `date '+%Y-%m-%d'` `printf '%(%T)T\n'` `psql -U postgres test_db -t -c "select my_function();"` >> "$PATH_TO_LOG"
  echo "action        : done"
  echo "log           : updated"  
else
  #if time difference is less(equals) than seconds gap -> do nothing 
  echo "action        : none"
fi 


