#!/usr/bin/env bash

function log {
  echo "[$(date)]: $*"
}

if ! [ -f $LOGFILE ]; then
  log 'file does not exist' # >> $LOG
  exit 2
fi
log 'working on '$LOGFILE # >> $LOG
log 'find this: '$PHRASE
if ! [ -f $LAST_LINE_FILE ]; then
  LAST_LINE=0
  echo $LAST_LINE > $LAST_LINE_FILE
else
  LAST_LINE=$(cat $LAST_LINE_FILE)
fi
log last line $LAST_LINE > $LOG

TEMP_LINE=$(cat $LOGFILE | wc -l)
log last line $LAST_LINE
res=$(sed -n $LAST_LINE,\$p $LOGFILE | sed -n "/$PHRASE/p")
log last line $LAST_LINE $TEMP_LINE >> $LOG
LAST_LINE=$TEMP_LINE
echo $LAST_LINE > $LAST_LINE_FILE
