#! /bin/bash

#set variable time per check and repiticions
SLEEPTIME=60
REPITICIONS=600
echo hoi
for i in $(seq 1 $REPITICIONS)
do
START=$(date '+%s')
echo hoi

#the speedcheck itself and using awk to filter output of speedtest-cli into csv logfile
speedtest-cli | awk -v timestamp="$(date '+%Y-%m-%dT%H:%M:%S')" '
  /Download/ { down = $2 }
  /Upload/   { up = $2 }
  END        { print timestamp "," down "," up >> "/home/bo/mygit/networkconnecttest/speed/speedtest.log" }
'
#Plotting log with all data
gnuplot -e "
set terminal png size 1200,600;
set output 'speedtest.png';
set datafile separator ',';
set xdata time;
set timefmt '%Y-%m-%dT%H:%M:%S';
set format x '%d:%H:%M';
set xlabel 'Tijd';
set ylabel 'Mbit/s';
set title 'Internetsnelheid';
plot 'speedtest.log' using 1:2 with lines title 'Download',
     'speedtest.log' using 1:3 with lines title 'Upload'"
echo "hoi :3"

#filter out only the data from the last 24h into a separate logfile
awk -F',' -v cutoff="$(date -d '24 hours ago' '+%Y-%m-%dT%H:%M:%S')" '$1 >= cutoff' speedtest.log > 24hspeed.log

#plotting last 24h
gnuplot -e "
set terminal png size 1200,600;
set output '24hspeedtest.png';
set datafile separator ',';
set xdata time;
set timefmt '%Y-%m-%dT%H:%M:%S';
set format x '%H:%M';
set xlabel 'Tijd';
set ylabel 'Mbit/s';
set title 'Internetsnelheid_afgelopen24h';
plot '24hspeed.log' using 1:2 with lines title 'Download',
     '24hspeed.log' using 1:3 with lines title 'Upload'"

#filtering out only the last hour into another separate log file
awk -F',' -v cutoff="$(date -d '1 hours ago' '+%Y-%m-%dT%H:%M:%S')" '$1 >= cutoff' speedtest.log > 1hspeed.log

#plotting the 1hour logfile
gnuplot -e "
set terminal png size 1200,600;
set output '1hspeed.png';
set datafile separator ',';
set xdata time;
set timefmt '%Y-%m-%dT%H:%M:%S';
set format x '%H:%M:%S';
set xlabel 'Tijd';
set ylabel 'Mbit/s';
set title 'Internetsnelheid_afgelopen_uur';
plot '1hspeed.log' using 1:2 with lines title 'Download',
     '1hspeed.log' using 1:3 with lines title 'Upload'"

#filtering out only the last week into another separate log file
awk -F',' -v cutoff="$(date -d '1 week ago' '+%Y-%m-%dT%H:%M:%S')" '$1 >= cutoff' speedtest.log > 1weekspeed.log

#plotting out last week logfile
gnuplot -e "
set terminal png size 1200,600;
set output '1weekspeedtest.png';
set datafile separator ',';
set xdata time;
set timefmt '%Y-%m-%dT%H:%M:%S';
set format x '%H:%M';
set xlabel 'Tijd';
set ylabel 'Mbit/s';
set title 'Internetsnelheid_afgelopen_week';
plot '1weekspeed.log' using 1:2 with lines title 'Download',
     '1weekspeed.log' using 1:3 with lines title 'Upload'"

#finding out howlong its been since the start of this loop so 
#it can wait until a minute since the start of the loop
ELAPSED=$(( $(date '+%s') - START ))
WAIT=$(( SLEEPTIME - ELAPSED ))
echo :3
if [ $WAIT -gt 0 ]; then
echo "Meting $i/$REPITICIONS | elapsed: ${ELAPSED}s | wacht: ${WAIT}s"
sleep $WAIT
fi
done


