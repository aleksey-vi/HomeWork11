#!/bin/bash
echo "PID     TTY     STAT     TIME     COMMAND" # выведем заголовок
for ITEM in `ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq`
do
if [ -d /proc/$ITEM/ ]; then  # допусловие проверки существования процесса
  PIDVAR=`cat /proc/$ITEM/stat | awk '{ print $1 }'`
  TTYCOMMAND=`sudo ls -l /proc/$ITEM/fd | head -n2 | tail -n1 | sed 's%.*/dev/%%'`
    if [[ $TTYCOMMAND == "total 0" ]] || [[ $TTYCOMMAND == "null" ]] || [[ $TTYCOMMAND == *"socket"* ]]; then
      TTYNUMBER="?"
    else
      TTYNUMBER=$TTYCOMMAND
    fi

  STATVAR=`cat /proc/$ITEM/stat | awk '{ print $3 }'`
  UTIMEVAR=`cat /proc/$ITEM/stat | awk '{ print $14 }'`
  STIMEVAR=`cat /proc/$ITEM/stat | awk '{ print $15 }'`
  CLKTCK=`getconf CLK_TCK`
  FULLTIME=$((UTIMEVAR+STIMEVAR))
  CPUTIME=$((FULLTIME/CLKTCK))
  TIMEVAR=`date -u -d @${CPUTIME} +"%T"`

  COMMANDVAR=`cat /proc/$ITEM/cmdline | strings -n 1 | tr '\n' ' '`
  if [[ -z $COMMANDVAR ]]; then COMMANDVAR=`cat /proc/$ITEM/stat | awk '{ print $2 }'`; fi

  echo "$PIDVAR     $TTYNUMBER     $STATVAR     $TIMEVAR     $COMMANDVAR"
fi
done
