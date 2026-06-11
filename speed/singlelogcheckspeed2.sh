#! /bin/bash
SLEEPTIME=60
REPITICIONS=60
for i in $(seq 1 $REPITICIONS)
do
START=$(date '+%s')

speedtest-cli | awk -v ts="$(date '+%Y-%m-%dT%H:%M:%S')" '
  /Download/ { down = $2 }
  /Upload/   { up = $2 }
  END        { print ts "," down "," up >> "/home/bo/mygit/networkconnecttest/speed/speedtest.log" }
'

ELAPSED=$(( $(date '+%s') - START ))
WAIT=$(( SLEEPTIME - ELAPSED ))

if [ $WAIT -gt 0 ]; then
sleep $WAIT
fi
echo "Meting $i/$REPITICIONS | elapsed: ${ELAPSED}s | wacht: ${WAIT}s"
done

