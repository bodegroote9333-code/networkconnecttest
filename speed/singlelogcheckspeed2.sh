#! /bin/bash
SLEEPTIME=60
REPITICIONS=60
echo hoi
for i in $(seq 1 $REPITICIONS)
do
START=$(date '+%s')
echo hoi
speedtest-cli | awk -v ts="$(date '+%Y-%m-%dT%H:%M:%S')" '
  /Download/ { down = $2 }
  /Upload/   { up = $2 }
  END        { print ts "," down "," up >> "/home/bo/mygit/networkconnecttest/speed/speedtest.log" }
'
gnuplot -e "
set terminal png size 1200,600;
set output 'speedtest.png';
set datafile separator ',';
set xdata time;
set timefmt '%Y-%m-%dT%H:%M:%S';
set format x '%H:%M';
set xlabel 'Tijd';
set ylabel 'Mbit/s';
set title 'Internetsnelheid';
plot 'speedtest.log' using 1:2 with lines title 'Download',
     'speedtest.log' using 1:3 with lines title 'Upload'"
echo "hoi :3"
ELAPSED=$(( $(date '+%s') - START ))
WAIT=$(( SLEEPTIME - ELAPSED ))
echo hoi
if [ $WAIT -gt 0 ]; then
echo "Meting $i/$REPITICIONS | elapsed: ${ELAPSED}s | wacht: ${WAIT}s"
sleep $WAIT
fi
done

