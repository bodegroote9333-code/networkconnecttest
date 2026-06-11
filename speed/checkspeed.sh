#! /bin/bash
SLEEPTIME=60
REPITICIONS=60
for i in $(seq 1 $REPITICIONS)
do
START=$(date '+%s')
OUTPUT=$(speedtest-cli)
if echo "$OUTPUT" | grep -q "Download"; then
echo "$OUTPUT" | awk -v ts="$(date '+%Y-%m-%dT%H:%M:%S')" '
  /Download/ { down = $2 }
  /Upload/   { up = $2 }
  END        { print ts "," down "," up >> "/home/bo/mygit/networkconnecttest/speed/speedtest.log" }
'
else
  echo "$(date '+%Y-%m-%dT%H:%M:%S') - Fout: $(echo "$OUTPUT" | tail -1)" >> /home/bo/mygit/networkconnecttest/speed/speedtest_errors.log
fi

ELAPSED=$(( $(date '+%s') - START ))
WAIT=$(( SLEEPTIME - ELAPSED ))
echo "Meting $i/$REPITICIONS | elapsed: ${ELAPSED}s | wacht: ${WAIT}s"
if [ $WAIT -gt 0 ]; then
sleep $WAIT
fi

done

