#!/bin/bash
source "/opt/loxberry/data/plugins/pv_forecast/strings.txt"
source "/opt/loxberry/data/plugins/pv_forecast/strings1.txt"
configfile_pv="/opt/loxberry/config/plugins/pv_forecast/pv_forecast.cfg"
data_failed_log="/opt/loxberry/log/plugins/pv_forecast/get_data_failed.log"
configfile_general="/opt/loxberry/config/system/general.cfg"
log="/opt/loxberry/log/plugins/pv_forecast/pv_forecast.log"
timeout=30


ini_parser() {

    INI_FILE=$1
    INI_SECTION=$2

    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/;.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/$INI_SECTION\1=\"\2\"/" \
        < $INI_FILE \
        | sed -n -e "/^\[$INI_SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`
}

get_data() {
req_ok=0
D=`date "+%b %d %H:%M:%S"`
echo "$D - Daten holen von URL: $url" >> $log
data=$(curl -s -m $timeout $url)
D=`date "+%b %d %H:%M:%S"`
if [ "$data" != "" ];then
echo "$D - PV Forecast werden aufgerufen: OK..." >> $log
req_ok=1
else
echo "$D - PV Forecast werden aufgerufen: 1. Fehler... Wiederholen..." >> $log
data=$(curl -s -m $timeout $url)
if [ "$data" != "" ];then
echo "$D - PV Forecast werden aufgerufen: OK..." >> $log
req_ok=1
else
echo "$D - PV Forecast werden aufgerufen: 2. Fehler... Abbruch..." >> $log
req_ok=0
fi
fi
data=$(echo $data | tr " " ";")
if [ $DEBUGDEBUG == 1 ]; then
echo "$D - URL: "$url >> $log
echo "$D - DATA: "$data >> $log
fi
}


ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "LON"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "LAT"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "DEC"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "AZ"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "KWP"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "DAMP"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "RESERVE"
ini_parser $configfile_pv "FORECAST_1"
ini_parser $configfile_pv "SYSTEM_ACTIVE"

ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "LON"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "LAT"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "DEC"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "AZ"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "KWP"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "DAMP"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "RESERVE"
ini_parser $configfile_pv "FORECAST_2"
ini_parser $configfile_pv "SYSTEM_ACTIVE"

ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "LON"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "LAT"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "DEC"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "AZ"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "KWP"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "DAMP"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "RESERVE"
ini_parser $configfile_pv "FORECAST_3"
ini_parser $configfile_pv "SYSTEM_ACTIVE"


ini_parser $configfile_pv "MINISERVER"
ini_parser $configfile_pv "MINISERVER"
ini_parser $configfile_pv "MINISERVER"
ini_parser $configfile_pv "UDPPORT"
ini_parser $configfile_pv "CRON"
ini_parser $configfile_pv "CRON"
ini_parser $configfile_pv "DEBUG"
ini_parser $configfile_pv "DEBUG"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TODAY_MORN_AFTER"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TODAY_3_6"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "KW"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TOMORROW_HOUR"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TODAY_TOMORROW_SUM"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TODAY_HOUR"
ini_parser $configfile_pv "DATA"
ini_parser $configfile_pv "TODAY_TOMORROW_SEP"
ini_parser $configfile_pv "API_KEY"
ini_parser $configfile_pv "API_KEY"

ini_parser $configfile_general "BASE"
ini_parser $configfile_general "$MINISERVERMINISERVER"

if [ "$MINISERVERMINISERVER" == "MINISERVER1" ]; then
MINISERVER_IP=$MINISERVER1IPADDRESS
elif [ "$MINISERVERMINISERVER" == "MINISERVER2" ]; then
MINISERVER_IP=$MINISERVER2IPADDRESS
elif [ "$MINISERVERMINISERVER" == "MINISERVER3" ]; then
MINISERVER_IP=$MINISERVER3IPADDRESS
elif [ "$MINISERVERMINISERVER" == "MINISERVER4" ]; then
MINISERVER_IP=$MINISERVER4IPADDRESS
else
MINISERVER_IP=$MINISERVER1IPADDRESS
fi

#Prepare Date
DATE=`date '+%Y-%m-%d'`
HOUR=`date '+%k'`
MINUTE=`date '+%M'`
if [ $MINUTE -gt 30 ]; then
HOUR=$(echo "scale=0; $HOUR + 1" | bc)
fi

#CHECK IF API KEY IS AVAILABLE AND AMEND URL ACCORDINGLY
if [ -z $API_KEYAPI_KEY ]; then
	api=""
else
	api="/$API_KEYAPI_KEY"
fi

#GET VALUES FROM FORECAST.SOLAR
i=1
while [ $i -lt 4 ]
do
data=""
source "/opt/loxberry/data/plugins/pv_forecast/strings1.txt"
if [ $FORECAST_1SYSTEM_ACTIVE == 1 ] && [ $i = 1 ]; then
url=$(echo "https://api.forecast.solar$api/estimate/watts/$FORECAST_1LAT/$FORECAST_1LON/$FORECAST_1DEC/$FORECAST_1AZ/$FORECAST_1KWP.csv?damping=$FORECAST_1DAMP")
get_data
fi
if [ $FORECAST_2SYSTEM_ACTIVE == 1 ] && [ $i = 2 ] ; then
url=$(echo "https://api.forecast.solar$api/estimate/watts/$FORECAST_2LAT/$FORECAST_2LON/$FORECAST_2DEC/$FORECAST_2AZ/$FORECAST_2KWP.csv?damping=$FORECAST_2DAMP")
get_data
fi
if [ $FORECAST_3SYSTEM_ACTIVE == 1 ] && [ $i = 3 ] ; then
url=$(echo "https://api.forecast.solar$api/estimate/watts/$FORECAST_3LAT/$FORECAST_3LON/$FORECAST_3DEC/$FORECAST_3AZ/$FORECAST_3KWP.csv?damping=$FORECAST_3DAMP")
get_data
fi

echo "Calc..."
while IFS=';' read -ra ADDR; do

for((n=0;n<${#ADDR[@]};n++)); do
if (( $(($n % 3 )) == 0 )); then
day=${ADDR[$n]}
hour=${ADDR[n+1]}
value=${ADDR[n+2]}

hour=$(echo $hour | cut -c 1-5)
if [ "$DATE" == "$day" ]; then
today=1
else
today=0
fi

#Calc Total Energy / Day - Values are read in 30 Minute interval
if [ $today == 1 ];then
if [ $hour == "01:00" ]; then today1_1_int=$value; fi
if [ $hour == "01:30" ]; then today1_2_int=$value; fi
if [ $hour == "02:00" ]; then today2_1_int=$value; fi
if [ $hour == "02:30" ]; then today2_2_int=$value; fi
if [ $hour == "03:00" ]; then today3_1_int=$value; fi
if [ $hour == "03:30" ]; then today3_2_int=$value; fi
if [ $hour == "04:00" ]; then today4_1_int=$value; fi
if [ $hour == "04:30" ]; then today4_2_int=$value; fi
if [ $hour == "05:00" ]; then today5_1_int=$value; fi
if [ $hour == "05:30" ]; then today5_2_int=$value; fi
if [ $hour == "06:00" ]; then today6_1_int=$value; fi
if [ $hour == "06:30" ]; then today6_2_int=$value; fi
if [ $hour == "07:00" ]; then today7_1_int=$value; fi
if [ $hour == "07:30" ]; then today7_2_int=$value; fi
if [ $hour == "08:00" ]; then today8_1_int=$value; fi
if [ $hour == "08:30" ]; then today8_2_int=$value; fi
if [ $hour == "09:00" ]; then today9_1_int=$value; fi
if [ $hour == "09:30" ]; then today9_2_int=$value; fi
if [ $hour == "10:00" ]; then today10_1_int=$value; fi
if [ $hour == "10:30" ]; then today10_2_int=$value; fi
if [ $hour == "11:00" ]; then today11_1_int=$value; fi
if [ $hour == "11:30" ]; then today11_2_int=$value; fi
if [ $hour == "12:00" ]; then today12_1_int=$value; fi
if [ $hour == "12:30" ]; then today12_2_int=$value; fi
if [ $hour == "13:00" ]; then today13_1_int=$value; fi
if [ $hour == "13:30" ]; then today13_2_int=$value; fi
if [ $hour == "14:00" ]; then today14_1_int=$value; fi
if [ $hour == "14:30" ]; then today14_2_int=$value; fi
if [ $hour == "15:00" ]; then today15_1_int=$value; fi
if [ $hour == "15:30" ]; then today15_2_int=$value; fi
if [ $hour == "16:00" ]; then today16_1_int=$value; fi
if [ $hour == "16:30" ]; then today16_2_int=$value; fi
if [ $hour == "17:00" ]; then today17_1_int=$value; fi
if [ $hour == "17:30" ]; then today17_2_int=$value; fi
if [ $hour == "18:00" ]; then today18_1_int=$value; fi
if [ $hour == "18:30" ]; then today18_2_int=$value; fi
if [ $hour == "19:00" ]; then today19_1_int=$value; fi
if [ $hour == "19:30" ]; then today19_2_int=$value; fi
if [ $hour == "20:00" ]; then today20_1_int=$value; fi
if [ $hour == "20:30" ]; then today20_2_int=$value; fi
if [ $hour == "21:00" ]; then today21_1_int=$value; fi
if [ $hour == "21:30" ]; then today21_2_int=$value; fi
if [ $hour == "22:00" ]; then today22_1_int=$value; fi
if [ $hour == "22:30" ]; then today22_2_int=$value; fi
if [ $hour == "23:00" ]; then today23_1_int=$value; fi
if [ $hour == "23:30" ]; then today23_2_int=$value; fi
if [ $hour == "00:00" ]; then today0_1_int=$value; fi
if [ $hour == "00:30" ]; then today0_2_int=$value; fi

today1=$(echo "scale=1; ($today1_1_int + $today1_2_int)/2" | bc)
today2=$(echo "scale=1; ($today2_1_int + $today2_2_int)/2" | bc)
today3=$(echo "scale=1; ($today3_1_int + $today3_2_int)/2" | bc)
today4=$(echo "scale=1; ($today4_1_int + $today4_2_int)/2" | bc)
today5=$(echo "scale=1; ($today5_1_int + $today5_2_int)/2" | bc)
today6=$(echo "scale=1; ($today6_1_int + $today6_2_int)/2" | bc)
today7=$(echo "scale=1; ($today7_1_int + $today7_2_int)/2" | bc)
today8=$(echo "scale=1; ($today8_1_int + $today8_2_int)/2" | bc)
today9=$(echo "scale=1; ($today9_1_int + $today9_2_int)/2" | bc)
today10=$(echo "scale=1; ($today10_1_int + $today10_2_int)/2" | bc)
today11=$(echo "scale=1; ($today11_1_int + $today11_2_int)/2" | bc)
today12=$(echo "scale=1; ($today12_1_int + $today12_2_int)/2" | bc)
today13=$(echo "scale=1; ($today13_1_int + $today13_2_int)/2" | bc)
today14=$(echo "scale=1; ($today14_1_int + $today14_2_int)/2" | bc)
today15=$(echo "scale=1; ($today15_1_int + $today15_2_int)/2" | bc)
today16=$(echo "scale=1; ($today16_1_int + $today16_2_int)/2" | bc)
today17=$(echo "scale=1; ($today17_1_int + $today17_2_int)/2" | bc)
today18=$(echo "scale=1; ($today18_1_int + $today18_2_int)/2" | bc)
today19=$(echo "scale=1; ($today19_1_int + $today19_2_int)/2" | bc)
today20=$(echo "scale=1; ($today20_1_int + $today20_2_int)/2" | bc)
today21=$(echo "scale=1; ($today21_1_int + $today21_2_int)/2" | bc)
today22=$(echo "scale=1; ($today22_1_int + $today22_2_int)/2" | bc)
today23=$(echo "scale=1; ($today23_1_int + $today23_2_int)/2" | bc)
today0=$(echo "scale=1; ($today0_1_int + $today0_2_int)/2" | bc)

#TOTAL MORING
if ( $(echo "$hour > "1:00"" | bc) ) && ( $(echo "$hour > "12:00"" | bc) ); then
total_value_morning=$(echo "scale=0; ($total_value_morning + $value)/2" | bc)
fi
#TOTAL AFTERNOON
if ( $(echo "$hour > "12:30"" | bc) ) && ( $(echo "$hour > "00:30"" | bc) ); then
total_value_afternoon=$(echo "scale=0; ($total_value_afternoon + $value)/2" | bc)
fi
#TOTAL TODAY
total_value_today=$(echo "scale=0; ($total_value_today + $value)/2" | bc)
fi

if [ $today == 0 ];then
if [ $hour == "01:00" ]; then tomorrow1_1_int=$value; fi
if [ $hour == "01:30" ]; then tomorrow1_2_int=$value; fi
if [ $hour == "02:00" ]; then tomorrow2_1_int=$value; fi
if [ $hour == "02:30" ]; then tomorrow2_2_int=$value; fi
if [ $hour == "03:00" ]; then tomorrow3_1_int=$value; fi
if [ $hour == "03:30" ]; then tomorrow3_2_int=$value; fi
if [ $hour == "04:00" ]; then tomorrow4_1_int=$value; fi
if [ $hour == "04:30" ]; then tomorrow4_2_int=$value; fi
if [ $hour == "05:00" ]; then tomorrow5_1_int=$value; fi
if [ $hour == "05:30" ]; then tomorrow5_2_int=$value; fi
if [ $hour == "06:00" ]; then tomorrow6_1_int=$value; fi
if [ $hour == "06:30" ]; then tomorrow6_2_int=$value; fi
if [ $hour == "07:00" ]; then tomorrow7_1_int=$value; fi
if [ $hour == "07:30" ]; then tomorrow7_2_int=$value; fi
if [ $hour == "08:00" ]; then tomorrow8_1_int=$value; fi
if [ $hour == "08:30" ]; then tomorrow8_2_int=$value; fi
if [ $hour == "09:00" ]; then tomorrow9_1_int=$value; fi
if [ $hour == "09:30" ]; then tomorrow9_2_int=$value; fi
if [ $hour == "10:00" ]; then tomorrow10_1_int=$value; fi
if [ $hour == "10:30" ]; then tomorrow10_2_int=$value; fi
if [ $hour == "11:00" ]; then tomorrow11_1_int=$value; fi
if [ $hour == "11:30" ]; then tomorrow11_2_int=$value; fi
if [ $hour == "12:00" ]; then tomorrow12_1_int=$value; fi
if [ $hour == "12:30" ]; then tomorrow12_2_int=$value; fi
if [ $hour == "13:00" ]; then tomorrow13_1_int=$value; fi
if [ $hour == "13:30" ]; then tomorrow13_2_int=$value; fi
if [ $hour == "14:00" ]; then tomorrow14_1_int=$value; fi
if [ $hour == "14:30" ]; then tomorrow14_2_int=$value; fi
if [ $hour == "15:00" ]; then tomorrow15_1_int=$value; fi
if [ $hour == "15:30" ]; then tomorrow15_2_int=$value; fi
if [ $hour == "16:00" ]; then tomorrow16_1_int=$value; fi
if [ $hour == "16:30" ]; then tomorrow16_2_int=$value; fi
if [ $hour == "17:00" ]; then tomorrow17_1_int=$value; fi
if [ $hour == "17:30" ]; then tomorrow17_2_int=$value; fi
if [ $hour == "18:00" ]; then tomorrow18_1_int=$value; fi
if [ $hour == "18:30" ]; then tomorrow18_2_int=$value; fi
if [ $hour == "19:00" ]; then tomorrow19_1_int=$value; fi
if [ $hour == "19:30" ]; then tomorrow19_2_int=$value; fi
if [ $hour == "20:00" ]; then tomorrow20_1_int=$value; fi
if [ $hour == "20:30" ]; then tomorrow20_2_int=$value; fi
if [ $hour == "21:00" ]; then tomorrow21_1_int=$value; fi
if [ $hour == "21:30" ]; then tomorrow21_2_int=$value; fi
if [ $hour == "22:00" ]; then tomorrow22_1_int=$value; fi
if [ $hour == "22:30" ]; then tomorrow22_2_int=$value; fi
if [ $hour == "23:00" ]; then tomorrow23_1_int=$value; fi
if [ $hour == "23:30" ]; then tomorrow23_2_int=$value; fi
if [ $hour == "00:00" ]; then tomorrow0_1_int=$value; fi
if [ $hour == "00:30" ]; then tomorrow0_2_int=$value; fi

tomorrow1=$(echo "scale=0; ($tomorrow1_1_int + $tomorrow1_2_int)/2" | bc)
tomorrow2=$(echo "scale=0; ($tomorrow2_1_int + $tomorrow2_2_int)/2" | bc)
tomorrow3=$(echo "scale=0; ($tomorrow3_1_int + $tomorrow3_2_int)/2" | bc)
tomorrow4=$(echo "scale=0; ($tomorrow4_1_int + $tomorrow4_2_int)/2" | bc)
tomorrow5=$(echo "scale=0; ($tomorrow5_1_int + $tomorrow5_2_int)/2" | bc)
tomorrow6=$(echo "scale=0; ($tomorrow6_1_int + $tomorrow6_2_int)/2" | bc)
tomorrow7=$(echo "scale=0; ($tomorrow7_1_int + $tomorrow7_2_int)/2" | bc)
tomorrow8=$(echo "scale=0; ($tomorrow8_1_int + $tomorrow8_2_int)/2" | bc)
tomorrow9=$(echo "scale=0; ($tomorrow9_1_int + $tomorrow9_2_int)/2" | bc)
tomorrow10=$(echo "scale=0; ($tomorrow10_1_int + $tomorrow10_2_int)/2" | bc)
tomorrow11=$(echo "scale=0; ($tomorrow11_1_int + $tomorrow11_2_int)/2" | bc)
tomorrow12=$(echo "scale=0; ($tomorrow12_1_int + $tomorrow12_2_int)/2" | bc)
tomorrow13=$(echo "scale=0; ($tomorrow13_1_int + $tomorrow13_2_int)/2" | bc)
tomorrow14=$(echo "scale=0; ($tomorrow14_1_int + $tomorrow14_2_int)/2" | bc)
tomorrow15=$(echo "scale=0; ($tomorrow15_1_int + $tomorrow15_2_int)/2" | bc)
tomorrow16=$(echo "scale=0; ($tomorrow16_1_int + $tomorrow16_2_int)/2" | bc)
tomorrow17=$(echo "scale=0; ($tomorrow17_1_int + $tomorrow17_2_int)/2" | bc)
tomorrow18=$(echo "scale=0; ($tomorrow18_1_int + $tomorrow18_2_int)/2" | bc)
tomorrow19=$(echo "scale=0; ($tomorrow19_1_int + $tomorrow19_2_int)/2" | bc)
tomorrow20=$(echo "scale=0; ($tomorrow20_1_int + $tomorrow20_2_int)/2" | bc)
tomorrow21=$(echo "scale=0; ($tomorrow21_1_int + $tomorrow21_2_int)/2" | bc)
tomorrow22=$(echo "scale=0; ($tomorrow22_1_int + $tomorrow22_2_int)/2" | bc)
tomorrow23=$(echo "scale=0; ($tomorrow23_1_int + $tomorrow23_2_int)/2" | bc)
tomorrow0=$(echo "scale=0; ($tomorrow0_1_int + $tomorrow0_2_int)/2" | bc)

#TOTAL TOMORROW
total_value_tomorrow=$(echo "scale=0; ($total_value_tomorrow + $value)/2" | bc)
fi

fi
done
done <<< "$data"

if [ $i == 1 ]; then FORECASTRESERVE=$FORECAST_1RESERVE; elif [ $i == 2 ]; then FORECASTRESERVE=$FORECAST_2RESERVE ;elif [ $i == 3 ]; then FORECASTRESERVE=$FORECAST_2RESERVE; else FORECASTRESERVE=0 ;fi

total_value_today=$(echo "scale=0; ($total_value_today * (100 - $FORECASTRESERVE) / 100 )" | bc);
total_value_tomorrow=$(echo "scale=0; ($total_value_tomorrow * (100 - $FORECASTRESERVE) / 100 )" | bc);
total_value_morning=$(echo "scale=0; ($total_value_morning * (100 - $FORECASTRESERVE) / 100 )" | bc);
total_value_afternoon=$(echo "scale=0; ($total_value_afternoon * (100 - $FORECASTRESERVE) / 100 )" | bc);
next3=$(echo "scale=0; ($next3 * (100 - $FORECASTRESERVE) / 100 )" | bc);
next6=$(echo "scale=0; ($next6 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today0=$(echo "scale=0; ($today0 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today1=$(echo "scale=0; ($today1 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today2=$(echo "scale=0; ($today2 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today3=$(echo "scale=0; ($today3 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today4=$(echo "scale=0; ($today4 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today5=$(echo "scale=0; ($today5 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today6=$(echo "scale=0; ($today6 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today7=$(echo "scale=0; ($today7 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today8=$(echo "scale=0; ($today8 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today9=$(echo "scale=0; ($today9 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today10=$(echo "scale=0; ($today10 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today11=$(echo "scale=0; ($today11 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today12=$(echo "scale=0; ($today12 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today13=$(echo "scale=0; ($today13 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today14=$(echo "scale=0; ($today14 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today15=$(echo "scale=0; ($today15 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today16=$(echo "scale=0; ($today16 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today17=$(echo "scale=0; ($today17 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today18=$(echo "scale=0; ($today18 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today19=$(echo "scale=0; ($today19 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today20=$(echo "scale=0; ($today20 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today21=$(echo "scale=0; ($today21 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today22=$(echo "scale=0; ($today22 * (100 - $FORECASTRESERVE) / 100 )" | bc);
today23=$(echo "scale=0; ($today23 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow0=$(echo "scale=0; ($tomorrow0 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow1=$(echo "scale=0; ($tomorrow1 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow2=$(echo "scale=0; ($tomorrow2 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow3=$(echo "scale=0; ($tomorrow3 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow4=$(echo "scale=0; ($tomorrow4 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow5=$(echo "scale=0; ($tomorrow5 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow6=$(echo "scale=0; ($tomorrow6 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow7=$(echo "scale=0; ($tomorrow7 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow8=$(echo "scale=0; ($tomorrow8 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow9=$(echo "scale=0; ($tomorrow9 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow10=$(echo "scale=0; ($tomorrow10 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow11=$(echo "scale=0; ($tomorrow11 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow12=$(echo "scale=0; ($tomorrow12 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow13=$(echo "scale=0; ($tomorrow13 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow14=$(echo "scale=0; ($tomorrow14 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow15=$(echo "scale=0; ($tomorrow15 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow16=$(echo "scale=0; ($tomorrow16 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow17=$(echo "scale=0; ($tomorrow17 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow18=$(echo "scale=0; ($tomorrow18 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow19=$(echo "scale=0; ($tomorrow19 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow20=$(echo "scale=0; ($tomorrow20 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow21=$(echo "scale=0; ($tomorrow21 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow22=$(echo "scale=0; ($tomorrow22 * (100 - $FORECASTRESERVE) / 100 )" | bc);
tomorrow23=$(echo "scale=0; ($tomorrow23 * (100 - $FORECASTRESERVE) / 100 )" | bc);

kw_total_value_today=$(echo "scale=3; $total_value_today / 1000" | bc);
kw_total_value_tomorrow=$(echo "scale=3; $total_value_tomorrow / 1000" | bc);
kw_total_value_morning=$(echo "scale=3; $total_value_morning / 1000" | bc);
kw_total_value_afternoon=$(echo "scale=3; $total_value_afternoon / 1000" | bc);
kw_next3=$(echo "scale=3; $next3 / 1000" | bc);
kw_next6=$(echo "scale=3; $next6 / 1000" | bc);
kw_today0=$(echo "scale=3; $today0 / 1000" | bc);
kw_today1=$(echo "scale=3; $today1 / 1000" | bc);
kw_today2=$(echo "scale=3; $today2 / 1000" | bc);
kw_today3=$(echo "scale=3; $today3 / 1000" | bc);
kw_today4=$(echo "scale=3; $today4 / 1000" | bc);
kw_today5=$(echo "scale=3; $today5 / 1000" | bc);
kw_today6=$(echo "scale=3; $today6 / 1000" | bc);
kw_today7=$(echo "scale=3; $today7 / 1000" | bc);
kw_today8=$(echo "scale=3; $today8 / 1000" | bc);
kw_today9=$(echo "scale=3; $today9 / 1000" | bc);
kw_today10=$(echo "scale=3; $today10 / 1000" | bc);
kw_today11=$(echo "scale=3; $today11 / 1000" | bc);
kw_today12=$(echo "scale=3; $today12 / 1000" | bc);
kw_today13=$(echo "scale=3; $today13 / 1000" | bc);
kw_today14=$(echo "scale=3; $today14 / 1000" | bc);
kw_today15=$(echo "scale=3; $today15 / 1000" | bc);
kw_today16=$(echo "scale=3; $today16 / 1000" | bc);
kw_today17=$(echo "scale=3; $today17 / 1000" | bc);
kw_today18=$(echo "scale=3; $today18 / 1000" | bc);
kw_today19=$(echo "scale=3; $today19 / 1000" | bc);
kw_today20=$(echo "scale=3; $today20 / 1000" | bc);
kw_today21=$(echo "scale=3; $today21 / 1000" | bc);
kw_today22=$(echo "scale=3; $today22 / 1000" | bc);
kw_today23=$(echo "scale=3; $today23 / 1000" | bc);
kw_tomorrow0=$(echo "scale=3; $tomorrow0 / 1000" | bc);
kw_tomorrow1=$(echo "scale=3; $tomorrow1 / 1000" | bc);
kw_tomorrow2=$(echo "scale=3; $tomorrow2 / 1000" | bc);
kw_tomorrow3=$(echo "scale=3; $tomorrow3 / 1000" | bc);
kw_tomorrow4=$(echo "scale=3; $tomorrow4 / 1000" | bc);
kw_tomorrow5=$(echo "scale=3; $tomorrow5 / 1000" | bc);
kw_tomorrow6=$(echo "scale=3; $tomorrow6 / 1000" | bc);
kw_tomorrow7=$(echo "scale=3; $tomorrow7 / 1000" | bc);
kw_tomorrow8=$(echo "scale=3; $tomorrow8 / 1000" | bc);
kw_tomorrow9=$(echo "scale=3; $tomorrow9 / 1000" | bc);
kw_tomorrow10=$(echo "scale=3; $tomorrow10 / 1000" | bc);
kw_tomorrow11=$(echo "scale=3; $tomorrow11 / 1000" | bc);
kw_tomorrow12=$(echo "scale=3; $tomorrow12 / 1000" | bc);
kw_tomorrow13=$(echo "scale=3; $tomorrow13 / 1000" | bc);
kw_tomorrow14=$(echo "scale=3; $tomorrow14 / 1000" | bc);
kw_tomorrow15=$(echo "scale=3; $tomorrow15 / 1000" | bc);
kw_tomorrow16=$(echo "scale=3; $tomorrow16 / 1000" | bc);
kw_tomorrow17=$(echo "scale=3; $tomorrow17 / 1000" | bc);
kw_tomorrow18=$(echo "scale=3; $tomorrow18 / 1000" | bc);
kw_tomorrow19=$(echo "scale=3; $tomorrow19 / 1000" | bc);
kw_tomorrow20=$(echo "scale=3; $tomorrow20 / 1000" | bc);
kw_tomorrow21=$(echo "scale=3; $tomorrow21 / 1000" | bc);
kw_tomorrow22=$(echo "scale=3; $tomorrow22 / 1000" | bc);
kw_tomorrow23=$(echo "scale=3; $tomorrow23 / 1000" | bc);

if [ $i = 1 ]; then
req_ok_1=$req_ok
total_value_today_1=$total_value_today
total_value_tomorrow_1=$total_value_tomorrow
total_value_morning_1=$total_value_morning
total_value_afternoon_1=$total_value_afternoon
next3_1=$next3
next6_1=$next6
today0_1=$today0
today1_1=$today1
today2_1=$today2
today3_1=$today3
today4_1=$today4
today5_1=$today5
today6_1=$today6
today7_1=$today7
today8_1=$today8
today9_1=$today9
today10_1=$today10
today11_1=$today11
today12_1=$today12
today13_1=$today13
today14_1=$today14
today15_1=$today15
today16_1=$today16
today17_1=$today17
today18_1=$today18
today19_1=$today19
today20_1=$today20
today21_1=$today21
today22_1=$today22
today23_1=$today23
tomorrow0_1=$tomorrow0
tomorrow1_1=$tomorrow1
tomorrow2_1=$tomorrow2
tomorrow3_1=$tomorrow3
tomorrow4_1=$tomorrow4
tomorrow5_1=$tomorrow5
tomorrow6_1=$tomorrow6
tomorrow7_1=$tomorrow7
tomorrow8_1=$tomorrow8
tomorrow9_1=$tomorrow9
tomorrow10_1=$tomorrow10
tomorrow11_1=$tomorrow11
tomorrow12_1=$tomorrow12
tomorrow13_1=$tomorrow13
tomorrow14_1=$tomorrow14
tomorrow15_1=$tomorrow15
tomorrow16_1=$tomorrow16
tomorrow17_1=$tomorrow17
tomorrow18_1=$tomorrow18
tomorrow19_1=$tomorrow19
tomorrow20_1=$tomorrow20
tomorrow21_1=$tomorrow21
tomorrow22_1=$tomorrow22
tomorrow23_1=$tomorrow23

kw_total_value_today_1=$kw_total_value_today
kw_total_value_tomorrow_1=$kw_total_value_tomorrow
kw_total_value_morning_1=$kw_total_value_morning
kw_total_value_afternoon_1=$kw_total_value_afternoon
kw_next3_1=$kw_next3
kw_next6_1=$kw_next6
kw_today0_1=$kw_today0
kw_today1_1=$kw_today1
kw_today2_1=$kw_today2
kw_today3_1=$kw_today3
kw_today4_1=$kw_today4
kw_today5_1=$kw_today5
kw_today6_1=$kw_today6
kw_today7_1=$kw_today7
kw_today8_1=$kw_today8
kw_today9_1=$kw_today9
kw_today10_1=$kw_today10
kw_today11_1=$kw_today11
kw_today12_1=$kw_today12
kw_today13_1=$kw_today13
kw_today14_1=$kw_today14
kw_today15_1=$kw_today15
kw_today16_1=$kw_today16
kw_today17_1=$kw_today17
kw_today18_1=$kw_today18
kw_today19_1=$kw_today19
kw_today20_1=$kw_today20
kw_today21_1=$kw_today21
kw_today22_1=$kw_today22
kw_today23_1=$kw_today23
kw_tomorrow0_1=$kw_tomorrow0
kw_tomorrow1_1=$kw_tomorrow1
kw_tomorrow2_1=$kw_tomorrow2
kw_tomorrow3_1=$kw_tomorrow3
kw_tomorrow4_1=$kw_tomorrow4
kw_tomorrow5_1=$kw_tomorrow5
kw_tomorrow6_1=$kw_tomorrow6
kw_tomorrow7_1=$kw_tomorrow7
kw_tomorrow8_1=$kw_tomorrow8
kw_tomorrow9_1=$kw_tomorrow9
kw_tomorrow10_1=$kw_tomorrow10
kw_tomorrow11_1=$kw_tomorrow11
kw_tomorrow12_1=$kw_tomorrow12
kw_tomorrow13_1=$kw_tomorrow13
kw_tomorrow14_1=$kw_tomorrow14
kw_tomorrow15_1=$kw_tomorrow15
kw_tomorrow16_1=$kw_tomorrow16
kw_tomorrow17_1=$kw_tomorrow17
kw_tomorrow18_1=$kw_tomorrow18
kw_tomorrow19_1=$kw_tomorrow19
kw_tomorrow20_1=$kw_tomorrow20
kw_tomorrow21_1=$kw_tomorrow21
kw_tomorrow22_1=$kw_tomorrow22
kw_tomorrow23_1=$kw_tomorrow23
fi

if [ $i = 2 ]; then
req_ok_2=$req_ok
total_value_today_2=$total_value_today
total_value_tomorrow_2=$total_value_tomorrow
total_value_morning_2=$total_value_morning
total_value_afternoon_2=$total_value_afternoon
next3_1=$next3
next6_1=$next6
today0_2=$today0
today1_2=$today1
today2_2=$today2
today3_2=$today3
today4_2=$today4
today5_2=$today5
today6_2=$today6
today7_2=$today7
today8_2=$today8
today9_2=$today9
today10_2=$today10
today11_2=$today11
today12_2=$today12
today13_2=$today13
today14_2=$today14
today15_2=$today15
today16_2=$today16
today17_2=$today17
today18_2=$today18
today19_2=$today19
today20_2=$today20
today21_2=$today21
today22_2=$today22
today23_2=$today23
tomorrow0_2=$tomorrow0
tomorrow1_2=$tomorrow1
tomorrow2_2=$tomorrow2
tomorrow3_2=$tomorrow3
tomorrow4_2=$tomorrow4
tomorrow5_2=$tomorrow5
tomorrow6_2=$tomorrow6
tomorrow7_2=$tomorrow7
tomorrow8_2=$tomorrow8
tomorrow9_2=$tomorrow9
tomorrow10_2=$tomorrow10
tomorrow11_2=$tomorrow11
tomorrow12_2=$tomorrow12
tomorrow13_2=$tomorrow13
tomorrow14_2=$tomorrow14
tomorrow15_2=$tomorrow15
tomorrow16_2=$tomorrow16
tomorrow17_2=$tomorrow17
tomorrow18_2=$tomorrow18
tomorrow19_2=$tomorrow19
tomorrow20_2=$tomorrow20
tomorrow21_2=$tomorrow21
tomorrow22_2=$tomorrow22
tomorrow23_2=$tomorrow23

kw_total_value_today_2=$kw_total_value_today
kw_total_value_tomorrow_2=$kw_total_value_tomorrow
kw_total_value_morning_2=$kw_total_value_morning
kw_total_value_afternoon_2=$kw_total_value_afternoon
kw_next3_2=$kw_next3
kw_next6_2=$kw_next6
kw_today0_2=$kw_today0
kw_today1_2=$kw_today1
kw_today2_2=$kw_today2
kw_today3_2=$kw_today3
kw_today4_2=$kw_today4
kw_today5_2=$kw_today5
kw_today6_2=$kw_today6
kw_today7_2=$kw_today7
kw_today8_2=$kw_today8
kw_today9_2=$kw_today9
kw_today10_2=$kw_today10
kw_today11_2=$kw_today11
kw_today12_2=$kw_today12
kw_today13_2=$kw_today13
kw_today14_2=$kw_today14
kw_today15_2=$kw_today15
kw_today16_2=$kw_today16
kw_today17_2=$kw_today17
kw_today18_2=$kw_today18
kw_today19_2=$kw_today19
kw_today20_2=$kw_today20
kw_today21_2=$kw_today21
kw_today22_2=$kw_today22
kw_today23_2=$kw_today23
kw_tomorrow0_2=$kw_tomorrow0
kw_tomorrow1_2=$kw_tomorrow1
kw_tomorrow2_2=$kw_tomorrow2
kw_tomorrow3_2=$kw_tomorrow3
kw_tomorrow4_2=$kw_tomorrow4
kw_tomorrow5_2=$kw_tomorrow5
kw_tomorrow6_2=$kw_tomorrow6
kw_tomorrow7_2=$kw_tomorrow7
kw_tomorrow8_2=$kw_tomorrow8
kw_tomorrow9_2=$kw_tomorrow9
kw_tomorrow10_2=$kw_tomorrow10
kw_tomorrow11_2=$kw_tomorrow11
kw_tomorrow12_2=$kw_tomorrow12
kw_tomorrow13_2=$kw_tomorrow13
kw_tomorrow14_2=$kw_tomorrow14
kw_tomorrow15_2=$kw_tomorrow15
kw_tomorrow16_2=$kw_tomorrow16
kw_tomorrow17_2=$kw_tomorrow17
kw_tomorrow18_2=$kw_tomorrow18
kw_tomorrow19_2=$kw_tomorrow19
kw_tomorrow20_2=$kw_tomorrow20
kw_tomorrow21_2=$kw_tomorrow21
kw_tomorrow22_2=$kw_tomorrow22
kw_tomorrow23_2=$kw_tomorrow23
fi

if [ $i = 3 ]; then
req_ok_3=$req_ok
total_value_today_3=$total_value_today
total_value_tomorrow_3=$total_value_tomorrow
total_value_morning_3=$total_value_morning
total_value_afternoon_3=$total_value_afternoon
next3_3=$next3
next6_3=$next6
today0_3=$today0
today1_3=$today1
today2_3=$today2
today3_3=$today3
today4_3=$today4
today5_3=$today5
today6_3=$today6
today7_3=$today7
today8_3=$today8
today9_3=$today9
today10_3=$today10
today11_3=$today11
today12_3=$today12
today13_3=$today13
today14_3=$today14
today15_3=$today15
today16_3=$today16
today17_3=$today17
today18_3=$today18
today19_3=$today19
today20_3=$today20
today21_3=$today21
today22_3=$today22
today23_3=$today23
tomorrow0_3=$tomorrow0
tomorrow1_3=$tomorrow1
tomorrow2_3=$tomorrow2
tomorrow3_3=$tomorrow3
tomorrow4_3=$tomorrow4
tomorrow5_3=$tomorrow5
tomorrow6_3=$tomorrow6
tomorrow7_3=$tomorrow7
tomorrow8_3=$tomorrow8
tomorrow9_3=$tomorrow9
tomorrow10_3=$tomorrow10
tomorrow11_3=$tomorrow11
tomorrow12_3=$tomorrow12
tomorrow13_3=$tomorrow13
tomorrow14_3=$tomorrow14
tomorrow15_3=$tomorrow15
tomorrow16_3=$tomorrow16
tomorrow17_3=$tomorrow17
tomorrow18_3=$tomorrow18
tomorrow19_3=$tomorrow19
tomorrow20_3=$tomorrow20
tomorrow21_3=$tomorrow21
tomorrow22_3=$tomorrow22
tomorrow23_3=$tomorrow23

kw_total_value_today_3=$kw_total_value_today
kw_total_value_tomorrow_3=$kw_total_value_tomorrow
kw_total_value_morning_3=$kw_total_value_morning
kw_total_value_afternoon_3=$kw_total_value_afternoon
kw_next3_3=$kw_next3
kw_next6_3=$kw_next6
kw_today0_3=$kw_today0
kw_today1_3=$kw_today1
kw_today2_3=$kw_today2
kw_today3_3=$kw_today3
kw_today4_3=$kw_today4
kw_today5_3=$kw_today5
kw_today6_3=$kw_today6
kw_today7_3=$kw_today7
kw_today8_3=$kw_today8
kw_today9_3=$kw_today9
kw_today10_3=$kw_today10
kw_today11_3=$kw_today11
kw_today12_3=$kw_today12
kw_today13_3=$kw_today13
kw_today14_3=$kw_today14
kw_today15_3=$kw_today15
kw_today16_3=$kw_today16
kw_today17_3=$kw_today17
kw_today18_3=$kw_today18
kw_today19_3=$kw_today19
kw_today20_3=$kw_today20
kw_today21_3=$kw_today21
kw_today22_3=$kw_today22
kw_today23_3=$kw_today23
kw_tomorrow0_3=$kw_tomorrow0
kw_tomorrow1_3=$kw_tomorrow1
kw_tomorrow2_3=$kw_tomorrow2
kw_tomorrow3_3=$kw_tomorrow3
kw_tomorrow4_3=$kw_tomorrow4
kw_tomorrow5_3=$kw_tomorrow5
kw_tomorrow6_3=$kw_tomorrow6
kw_tomorrow7_3=$kw_tomorrow7
kw_tomorrow8_3=$kw_tomorrow8
kw_tomorrow9_3=$kw_tomorrow9
kw_tomorrow10_3=$kw_tomorrow10
kw_tomorrow11_3=$kw_tomorrow11
kw_tomorrow12_3=$kw_tomorrow12
kw_tomorrow13_3=$kw_tomorrow13
kw_tomorrow14_3=$kw_tomorrow14
kw_tomorrow15_3=$kw_tomorrow15
kw_tomorrow16_3=$kw_tomorrow16
kw_tomorrow17_3=$kw_tomorrow17
kw_tomorrow18_3=$kw_tomorrow18
kw_tomorrow19_3=$kw_tomorrow19
kw_tomorrow20_3=$kw_tomorrow20
kw_tomorrow21_3=$kw_tomorrow21
kw_tomorrow22_3=$kw_tomorrow22
kw_tomorrow23_3=$kw_tomorrow23
fi

total_value_today_sum=$(echo "scale=0; $total_value_today_1 + $total_value_today_2 + $total_value_today_3" | bc);
total_value_tomorrow_sum=$(echo "scale=0; $total_value_tomorrow_1 + $total_value_tomorrow_2 + $total_value_tomorrow_3" | bc);
total_value_morning_sum=$(echo "scale=0; $total_value_morning_1 + $total_value_morning_2 + $total_value_morning_3" | bc);
total_value_afternoon_sum=$(echo "scale=0; $total_value_afternoon_1 + $total_value_afternoon_2 + $total_value_afternoon_3" | bc);
next3_sum=$(echo "scale=0; $next3_1 + $next3_2 + $next3_3" | bc);
next6_sum=$(echo "scale=0; $next6_1 + $next6_2 + $next6_3" | bc);
today0_sum=$(echo "scale=0; $today0_1 + $today0_2 + $today0_3" | bc);
today1_sum=$(echo "scale=0; $today1_1 + $today1_2 + $today1_3" | bc);
today2_sum=$(echo "scale=0; $today2_1 + $today2_2 + $today2_3" | bc);
today3_sum=$(echo "scale=0; $today3_1 + $today3_2 + $today3_3" | bc);
today4_sum=$(echo "scale=0; $today4_1 + $today4_2 + $today4_3" | bc);
today5_sum=$(echo "scale=0; $today5_1 + $today5_2 + $today5_3" | bc);
today6_sum=$(echo "scale=0; $today6_1 + $today6_2 + $today6_3" | bc);
today7_sum=$(echo "scale=0; $today7_1 + $today7_2 + $today7_3" | bc);
today8_sum=$(echo "scale=0; $today8_1 + $today8_2 + $today8_3" | bc);
today9_sum=$(echo "scale=0; $today9_1 + $today9_2 + $today9_3" | bc);
today10_sum=$(echo "scale=0; $today10_1 + $today10_2 + $today10_3" | bc);
today11_sum=$(echo "scale=0; $today11_1 + $today11_2 + $today11_3" | bc);
today12_sum=$(echo "scale=0; $today12_1 + $today12_2 + $today12_3" | bc);
today13_sum=$(echo "scale=0; $today13_1 + $today13_2 + $today13_3" | bc);
today14_sum=$(echo "scale=0; $today14_1 + $today14_2 + $today14_3" | bc);
today15_sum=$(echo "scale=0; $today15_1 + $today15_2 + $today15_3" | bc);
today16_sum=$(echo "scale=0; $today16_1 + $today16_2 + $today16_3" | bc);
today17_sum=$(echo "scale=0; $today17_1 + $today17_2 + $today17_3" | bc);
today18_sum=$(echo "scale=0; $today18_1 + $today18_2 + $today18_3" | bc);
today19_sum=$(echo "scale=0; $today19_1 + $today19_2 + $today19_3" | bc);
today20_sum=$(echo "scale=0; $today20_1 + $today20_2 + $today20_3" | bc);
today21_sum=$(echo "scale=0; $today21_1 + $today21_2 + $today21_3" | bc);
today22_sum=$(echo "scale=0; $today22_1 + $today22_2 + $today22_3" | bc);
today23_sum=$(echo "scale=0; $today23_1 + $today23_2 + $today23_3" | bc);
tomorrow0_sum=$(echo "scale=0; $tomorrow0_1 + $tomorrow0_2 + $tomorrow0_3" | bc);
tomorrow1_sum=$(echo "scale=0; $tomorrow1_1 + $tomorrow1_2 + $tomorrow1_3" | bc);
tomorrow2_sum=$(echo "scale=0; $tomorrow2_1 + $tomorrow2_2 + $tomorrow2_3" | bc);
tomorrow3_sum=$(echo "scale=0; $tomorrow3_1 + $tomorrow3_2 + $tomorrow3_3" | bc);
tomorrow4_sum=$(echo "scale=0; $tomorrow4_1 + $tomorrow4_2 + $tomorrow4_3" | bc);
tomorrow5_sum=$(echo "scale=0; $tomorrow5_1 + $tomorrow5_2 + $tomorrow5_3" | bc);
tomorrow6_sum=$(echo "scale=0; $tomorrow6_1 + $tomorrow6_2 + $tomorrow6_3" | bc);
tomorrow7_sum=$(echo "scale=0; $tomorrow7_1 + $tomorrow7_2 + $tomorrow7_3" | bc);
tomorrow8_sum=$(echo "scale=0; $tomorrow8_1 + $tomorrow8_2 + $tomorrow8_3" | bc);
tomorrow9_sum=$(echo "scale=0; $tomorrow9_1 + $tomorrow9_2 + $tomorrow9_3" | bc);
tomorrow10_sum=$(echo "scale=0; $tomorrow10_1 + $tomorrow10_2 + $tomorrow10_3" | bc);
tomorrow11_sum=$(echo "scale=0; $tomorrow11_1 + $tomorrow11_2 + $tomorrow11_3" | bc);
tomorrow12_sum=$(echo "scale=0; $tomorrow12_1 + $tomorrow12_2 + $tomorrow12_3" | bc);
tomorrow13_sum=$(echo "scale=0; $tomorrow13_1 + $tomorrow13_2 + $tomorrow13_3" | bc);
tomorrow14_sum=$(echo "scale=0; $tomorrow14_1 + $tomorrow14_2 + $tomorrow14_3" | bc);
tomorrow15_sum=$(echo "scale=0; $tomorrow15_1 + $tomorrow15_2 + $tomorrow15_3" | bc);
tomorrow16_sum=$(echo "scale=0; $tomorrow16_1 + $tomorrow16_2 + $tomorrow16_3" | bc);
tomorrow17_sum=$(echo "scale=0; $tomorrow17_1 + $tomorrow17_2 + $tomorrow17_3" | bc);
tomorrow18_sum=$(echo "scale=0; $tomorrow18_1 + $tomorrow18_2 + $tomorrow18_3" | bc);
tomorrow19_sum=$(echo "scale=0; $tomorrow19_1 + $tomorrow19_2 + $tomorrow19_3" | bc);
tomorrow20_sum=$(echo "scale=0; $tomorrow20_1 + $tomorrow20_2 + $tomorrow20_3" | bc);
tomorrow21_sum=$(echo "scale=0; $tomorrow21_1 + $tomorrow21_2 + $tomorrow21_3" | bc);
tomorrow22_sum=$(echo "scale=0; $tomorrow22_1 + $tomorrow22_2 + $tomorrow22_3" | bc);
tomorrow23_sum=$(echo "scale=0; $tomorrow23_1 + $tomorrow23_2 + $tomorrow23_3" | bc);

kw_total_value_today_sum=$(echo "scale=3; $kw_total_value_today_1 + $kw_total_value_today_2 + $kw_total_value_today_3" | bc);
kw_total_value_tomorrow_sum=$(echo "scale=3; $kw_total_value_tomorrow_1 + $kw_total_value_tomorrow_2 + $kw_total_value_tomorrow_3" | bc);
kw_total_value_morning_sum=$(echo "scale=3; $kw_total_value_morning_1 + $kw_total_value_morning_2 + $kw_total_value_morning_3" | bc);
kw_total_value_afternoon_sum=$(echo "scale=3; $kw_total_value_afternoon_1 + $kw_total_value_afternoon_2 + $kw_total_value_afternoon_3" | bc);
kw_next3_sum=$(echo "scale=3; $kw_next3_1 + $kw_next3_2 + $kw_next3_3" | bc);
kw_next6_sum=$(echo "scale=3; $kw_next6_1 + $kw_next6_2 + $kw_next6_3" | bc);
kw_today0_sum=$(echo "scale=3; $kw_today0_1 + $kw_today0_2 + $kw_today0_3" | bc);
kw_today1_sum=$(echo "scale=3; $kw_today1_1 + $kw_today1_2 + $kw_today1_3" | bc);
kw_today2_sum=$(echo "scale=3; $kw_today2_1 + $kw_today2_2 + $kw_today2_3" | bc);
kw_today3_sum=$(echo "scale=3; $kw_today3_1 + $kw_today3_2 + $kw_today3_3" | bc);
kw_today4_sum=$(echo "scale=3; $kw_today4_1 + $kw_today4_2 + $kw_today4_3" | bc);
kw_today5_sum=$(echo "scale=3; $kw_today5_1 + $kw_today5_2 + $kw_today5_3" | bc);
kw_today6_sum=$(echo "scale=3; $kw_today6_1 + $kw_today6_2 + $kw_today6_3" | bc);
kw_today7_sum=$(echo "scale=3; $kw_today7_1 + $kw_today7_2 + $kw_today7_3" | bc);
kw_today8_sum=$(echo "scale=3; $kw_today8_1 + $kw_today8_2 + $kw_today8_3" | bc);
kw_today9_sum=$(echo "scale=3; $kw_today9_1 + $kw_today9_2 + $kw_today9_3" | bc);
kw_today10_sum=$(echo "scale=3; $kw_today10_1 + $kw_today10_2 + $kw_today10_3" | bc);
kw_today11_sum=$(echo "scale=3; $kw_today11_1 + $kw_today11_2 + $kw_today11_3" | bc);
kw_today12_sum=$(echo "scale=3; $kw_today12_1 + $kw_today12_2 + $kw_today12_3" | bc);
kw_today13_sum=$(echo "scale=3; $kw_today13_1 + $kw_today13_2 + $kw_today13_3" | bc);
kw_today14_sum=$(echo "scale=3; $kw_today14_1 + $kw_today14_2 + $kw_today14_3" | bc);
kw_today15_sum=$(echo "scale=3; $kw_today15_1 + $kw_today15_2 + $kw_today15_3" | bc);
kw_today16_sum=$(echo "scale=3; $kw_today16_1 + $kw_today16_2 + $kw_today16_3" | bc);
kw_today17_sum=$(echo "scale=3; $kw_today17_1 + $kw_today17_2 + $kw_today17_3" | bc);
kw_today18_sum=$(echo "scale=3; $kw_today18_1 + $kw_today18_2 + $kw_today18_3" | bc);
kw_today19_sum=$(echo "scale=3; $kw_today19_1 + $kw_today19_2 + $kw_today19_3" | bc);
kw_today20_sum=$(echo "scale=3; $kw_today20_1 + $kw_today20_2 + $kw_today20_3" | bc);
kw_today21_sum=$(echo "scale=3; $kw_today21_1 + $kw_today21_2 + $kw_today21_3" | bc);
kw_today22_sum=$(echo "scale=3; $kw_today22_1 + $kw_today22_2 + $kw_today22_3" | bc);
kw_today23_sum=$(echo "scale=3; $kw_today23_1 + $kw_today23_2 + $kw_today23_3" | bc);
kw_tomorrow0_sum=$(echo "scale=3; $kw_tomorrow0_1 + $kw_tomorrow0_2 + $kw_tomorrow0_3" | bc);
kw_tomorrow1_sum=$(echo "scale=3; $kw_tomorrow1_1 + $kw_tomorrow1_2 + $kw_tomorrow1_3" | bc);
kw_tomorrow2_sum=$(echo "scale=3; $kw_tomorrow2_1 + $kw_tomorrow2_2 + $kw_tomorrow2_3" | bc);
kw_tomorrow3_sum=$(echo "scale=3; $kw_tomorrow3_1 + $kw_tomorrow3_2 + $kw_tomorrow3_3" | bc);
kw_tomorrow4_sum=$(echo "scale=3; $kw_tomorrow4_1 + $kw_tomorrow4_2 + $kw_tomorrow4_3" | bc);
kw_tomorrow5_sum=$(echo "scale=3; $kw_tomorrow5_1 + $kw_tomorrow5_2 + $kw_tomorrow5_3" | bc);
kw_tomorrow6_sum=$(echo "scale=3; $kw_tomorrow6_1 + $kw_tomorrow6_2 + $kw_tomorrow6_3" | bc);
kw_tomorrow7_sum=$(echo "scale=3; $kw_tomorrow7_1 + $kw_tomorrow7_2 + $kw_tomorrow7_3" | bc);
kw_tomorrow8_sum=$(echo "scale=3; $kw_tomorrow8_1 + $kw_tomorrow8_2 + $kw_tomorrow8_3" | bc);
kw_tomorrow9_sum=$(echo "scale=3; $kw_tomorrow9_1 + $kw_tomorrow9_2 + $kw_tomorrow9_3" | bc);
kw_tomorrow10_sum=$(echo "scale=3; $kw_tomorrow10_1 + $kw_tomorrow10_2 + $kw_tomorrow10_3" | bc);
kw_tomorrow11_sum=$(echo "scale=3; $kw_tomorrow11_1 + $kw_tomorrow11_2 + $kw_tomorrow11_3" | bc);
kw_tomorrow12_sum=$(echo "scale=3; $kw_tomorrow12_1 + $kw_tomorrow12_2 + $kw_tomorrow12_3" | bc);
kw_tomorrow13_sum=$(echo "scale=3; $kw_tomorrow13_1 + $kw_tomorrow13_2 + $kw_tomorrow13_3" | bc);
kw_tomorrow14_sum=$(echo "scale=3; $kw_tomorrow14_1 + $kw_tomorrow14_2 + $kw_tomorrow14_3" | bc);
kw_tomorrow15_sum=$(echo "scale=3; $kw_tomorrow15_1 + $kw_tomorrow15_2 + $kw_tomorrow15_3" | bc);
kw_tomorrow16_sum=$(echo "scale=3; $kw_tomorrow16_1 + $kw_tomorrow16_2 + $kw_tomorrow16_3" | bc);
kw_tomorrow17_sum=$(echo "scale=3; $kw_tomorrow17_1 + $kw_tomorrow17_2 + $kw_tomorrow17_3" | bc);
kw_tomorrow18_sum=$(echo "scale=3; $kw_tomorrow18_1 + $kw_tomorrow18_2 + $kw_tomorrow18_3" | bc);
kw_tomorrow19_sum=$(echo "scale=3; $kw_tomorrow19_1 + $kw_tomorrow19_2 + $kw_tomorrow19_3" | bc);
kw_tomorrow20_sum=$(echo "scale=3; $kw_tomorrow20_1 + $kw_tomorrow20_2 + $kw_tomorrow20_3" | bc);
kw_tomorrow21_sum=$(echo "scale=3; $kw_tomorrow21_1 + $kw_tomorrow21_2 + $kw_tomorrow21_3" | bc);
kw_tomorrow22_sum=$(echo "scale=3; $kw_tomorrow22_1 + $kw_tomorrow22_2 + $kw_tomorrow22_3" | bc);
kw_tomorrow23_sum=$(echo "scale=3; $kw_tomorrow23_1 + $kw_tomorrow23_2 + $kw_tomorrow23_3" | bc);

((i++))
done

#Next3
if [ $HOUR == "1" ]; then next3_sum=$(echo "scale=0; $today1_1 + $today2_1 + $today3_1 + $today1_2 + $today2_2 + $today3_2 + $today1_3 + $today2_3 + $today3_3" | bc); fi
if [ $HOUR == "2" ]; then next3_sum=$(echo "scale=0; $today2_1 + $today3_1 + $today4_1 + $today2_2 + $today3_2 + $today4_2 + $today2_3 + $today3_3 + $today4_3" | bc); fi
if [ $HOUR == "3" ]; then next3_sum=$(echo "scale=0; $today3_1 + $today4_1 + $today5_1 + $today3_2 + $today4_2 + $today5_2 + $today3_3 + $today4_3 + $today5_3" | bc); fi
if [ $HOUR == "4" ]; then next3_sum=$(echo "scale=0; $today4_1 + $today5_1 + $today6_1 + $today4_2 + $today5_2 + $today6_2 + $today4_3 + $today5_3 + $today6_3" | bc); fi
if [ $HOUR == "5" ]; then next3_sum=$(echo "scale=0; $today5_1 + $today6_1 + $today7_1 + $today5_2 + $today6_2 + $today7_2 + $today5_3 + $today6_3 + $today7_3" | bc); fi
if [ $HOUR == "6" ]; then next3_sum=$(echo "scale=0; $today6_1 + $today7_1 + $today8_1 + $today6_2 + $today7_2 + $today8_2 + $today6_3 + $today7_3 + $today8_3" | bc); fi
if [ $HOUR == "7" ]; then next3_sum=$(echo "scale=0; $today7_1 + $today8_1 + $today9_1 + $today7_2 + $today8_2 + $today9_2 + $today7_3 + $today8_3 + $today9_3" | bc); fi
if [ $HOUR == "8" ]; then next3_sum=$(echo "scale=0; $today8_1 + $today9_1 + $today10_1 + $today8_2 + $today9_2 + $today10_2 + $today8_3 + $today9_3 + $today10_3" | bc); fi
if [ $HOUR == "9" ]; then next3_sum=$(echo "scale=0; $today9_1 + $today10_1 + $today11_1 + $today8_2 + $today9_2 + $today10_2 + $today8_3 + $today9_3 + $today10_3" | bc); fi
if [ $HOUR == "10" ]; then next3_sum=$(echo "scale=0; $today10_1 + $today11_1 + $today12_1 + $today10_2 + $today11_2 + $today12_2 + $today10_3 + $today11_3 + $today12_3" | bc); fi
if [ $HOUR == "11" ]; then next3_sum=$(echo "scale=0; $today11_1 + $today12_1 + $today13_1 + $today11_2 + $today12_2 + $today13_2 + $today11_3 + $today12_3 + $today13_3" | bc); fi
if [ $HOUR == "12" ]; then next3_sum=$(echo "scale=0; $today12_1 + $today13_1 + $today14_1 + $today12_2 + $today13_2 + $today14_2 + $today12_3 + $today13_3 + $today14_3" | bc); fi
if [ $HOUR == "13" ]; then next3_sum=$(echo "scale=0; $today13_1 + $today14_1 + $today15_1 + $today13_2 + $today14_2 + $today15_2 + $today13_3 + $today14_3 + $today15_3" | bc); fi
if [ $HOUR == "14" ]; then next3_sum=$(echo "scale=0; $today14_1 + $today15_1 + $today16_1 + $today14_2 + $today15_2 + $today16_2 + $today14_3 + $today15_3 + $today16_3" | bc); fi
if [ $HOUR == "15" ]; then next3_sum=$(echo "scale=0; $today15_1 + $today16_1 + $today17_1 + $today15_2 + $today16_2 + $today17_2 + $today15_3 + $today16_3 + $today17_3" | bc); fi
if [ $HOUR == "16" ]; then next3_sum=$(echo "scale=0; $today16_1 + $today17_1 + $today18_1 + $today16_2 + $today17_2 + $today18_2 + $today16_3 + $today17_3 + $today18_3" | bc); fi
if [ $HOUR == "17" ]; then next3_sum=$(echo "scale=0; $today17_1 + $today18_1 + $today19_1 + $today17_2 + $today18_2 + $today19_2 + $today17_3 + $today18_3 + $today19_3" | bc); fi
if [ $HOUR == "18" ]; then next3_sum=$(echo "scale=0; $today18_1 + $today19_1 + $today20_1 + $today18_2 + $today19_2 + $today20_2 + $today18_3 + $today19_3 + $today20_3" | bc); fi
if [ $HOUR == "19" ]; then next3_sum=$(echo "scale=0; $today19_1 + $today20_1 + $today21_1 + $today19_2 + $today20_2 + $today21_2 + $today19_3 + $today20_3 + $today21_3" | bc); fi
if [ $HOUR == "20" ]; then next3_sum=$(echo "scale=0; $today20_1 + $today21_1 + $today22_1 + $today20_2 + $today21_2 + $today22_2 + $today20_3 + $today21_3 + $today22_3" | bc); fi
if [ $HOUR == "21" ]; then next3_sum=$(echo "scale=0; $today21_1 + $today22_1 + $today23_1 + $today21_2 + $today22_2 + $today23_2 + $today21_3 + $today22_3 + $today23_3" | bc); fi
if [ $HOUR == "22" ]; then next3_sum=$(echo "scale=0; $today22_1 + $today23_1 + $today0_1 + $today22_2 + $today23_2 + $today0_2 + $today22_3 + $today23_3 + $today0_3" | bc); fi
if [ $HOUR == "23" ]; then next3_sum=$(echo "scale=0; $today23_1 + $today0_1 + $tomorrow1_1 + $today23_2 + $today0_2 + $tomorrow1_2 + $today23_3 + $today0_3 + $tomorrow1_3" | bc); fi
if [ $HOUR == "0" ]; then  next3_sum=$(echo "scale=0; $today0_1 + $tomorrow1_1 + $tomorrow2_1 + $today0_2 + $tomorrow1_2 + $tomorrow2_2 + $today0_3 + $tomorrow1_3 + $tomorrow2_3" | bc); fi

#NEXT6
if [ $HOUR == "1" ]; then next6_sum=$(echo "scale=0; $today1_1 + $today2_1 + $today3_1 + $today4_1 + $today5_1 + $today6_1 + $today1_2 + $today2_2 + $today3_2 + $today4_2 + $today5_2 + $today6_2 + $today1_3 + $today2_3 + $today3_3 + $today4_3 + $today5_3 + $today6_3" | bc); fi
if [ $HOUR == "2" ]; then next6_sum=$(echo "scale=0; $today2_1 + $today3_1 + $today4_1 + $today5_1 + $today6_1 + $today7_1 + $today2_2 + $today3_2 + $today4_2 + $today5_2 + $today6_2 + $today7_2 + $today2_3 + $today3_3 + $today4_3 + $today5_3 + $today6_3 + $today7_3 " | bc); fi
if [ $HOUR == "3" ]; then next6_sum=$(echo "scale=0; $today3_1 + $today4_1 + $today5_1 + $today6_1 + $today7_1 + $today8_1 + $today3_2 + $today4_2 + $today5_2 + $today6_2 + $today7_2 + $today8_2 + $today3_3 + $today4_3 + $today5_3 + $today6_3 + $today7_3 + $today8_3" | bc); fi
if [ $HOUR == "4" ]; then next6_sum=$(echo "scale=0; $today4_1 + $today5_1 + $today6_1 + $today7_1 + $today8_1 + $today9_1 + $today4_2 + $today5_2 + $today6_2 + $today7_2 + $today8_2 + $today9_2 + $today4_3 + $today5_3 + $today6_3 + $today7_3 + $today8_3 + $today9_3" | bc); fi
if [ $HOUR == "5" ]; then next6_sum=$(echo "scale=0; $today5_1 + $today6_1 + $today7_1 + $today8_1 + $today9_1 + $today10_1 + $today5_2 + $today6_2 + $today7_2 + $today8_2 + $today9_2 + $today10_2 + $today5_3 + $today6_3 + $today7_3 + $today8_3 + $today9_3 + $today10_3" | bc); fi
if [ $HOUR == "6" ]; then next6_sum=$(echo "scale=0; $today6_1 + $today7_1 + $today8_1 + $today9_1 + $today10_1 + $today11_1 + $today6_2 + $today7_2 + $today8_2 + $today9_2 + $today10_2 + $today11_2 + $today6_3 + $today7_3 + $today8_3 + $today9_3 + $today10_3 + $today11_3" | bc); fi
if [ $HOUR == "7" ]; then next6_sum=$(echo "scale=0; $today7_1 + $today8_1 + $today9_1 + $today10_1 + $today11_1 + $today12_1 + $today7_2 + $today8_2 + $today9_2 + $today10_2 + $today11_2 + $today12_2 + $today7_3 + $today8_3 + $today9_3 + $today10_3 + $today11_3 + $today12_3" | bc); fi
if [ $HOUR == "8" ]; then next6_sum=$(echo "scale=0; $today8_1 + $today9_1 + $today10_1 + $today11_1 + $today12_1 + $today13_1 + $today8_2 + $today9_2 + $today10_2 + $today11_2 + $today12_2 + $today13_2 + $today8_3 + $today9_3 + $today10_3 + $today11_3 + $today12_3 + $today13_3" | bc); fi
if [ $HOUR == "9" ]; then next6_sum=$(echo "scale=0; $today9_1 + $today10_1 + $today11_1 + $today12_1 + $today13_1 + $today14_1 + $today9_2 + $today10_2 + $today11_2 + $today12_2 + $today13_2 + $today14_2 + $today9_3 + $today10_3 + $today11_3 + $today12_3 + $today13_3 + $today14_3" | bc); fi
if [ $HOUR == "10" ]; then next6_sum=$(echo "scale=0; $today10_1 + $today11_1 + $today12_1 + $today13_1 + $today14_1 + $today15_1 + $today10_2 + $today11_2 + $today12_2 + $today13_2 + $today14_2 + $today15_2 + $today10_3 + $today11_3 + $today12_3 + $today13_3 + $today14_3 + $today15_3" | bc); fi
if [ $HOUR == "11" ]; then next6_sum=$(echo "scale=0; $today11_1 + $today12_1 + $today13_1 + $today14_1 + $today15_1 + $today16_1 + $today11_2 + $today12_2 + $today13_2 + $today14_2 + $today15_2 + $today16_2 + $today11_3 + $today12_3 + $today13_3 + $today14_3 + $today15_3 + $today16_3" | bc); fi
if [ $HOUR == "12" ]; then next6_sum=$(echo "scale=0; $today12_1 + $today13_1 + $today14_1 + $today15_1 + $today16_1 + $today17_1 + $today12_2 + $today13_2 + $today14_2 + $today15_2 + $today16_2 + $today17_2 + $today12_3 + $today13_3 + $today14_3 + $today15_3 + $today16_3 + $today17_3" | bc); fi
if [ $HOUR == "13" ]; then next6_sum=$(echo "scale=0; $today13_1 + $today14_1 + $today15_1 + $today16_1 + $today17_1 + $today18_1 + $today13_2 + $today14_2 + $today15_2 + $today16_2 + $today17_2 + $today18_2 + $today13_3 + $today14_3 + $today15_3 + $today16_3 + $today17_3 + $today18_3" | bc); fi
if [ $HOUR == "14" ]; then next6_sum=$(echo "scale=0; $today14_1 + $today15_1 + $today16_1 + $today17_1 + $today18_1 + $today19_1 + $today14_2 + $today15_2 + $today16_2 + $today17_2 + $today18_2 + $today19_2 + $today14_3 + $today15_3 + $today16_3 + $today17_3 + $today18_3 + $today19_3" | bc); fi
if [ $HOUR == "15" ]; then next6_sum=$(echo "scale=0; $today15_1 + $today16_1 + $today17_1 + $today18_1 + $today19_1 + $today20_1 + $today15_2 + $today16_2 + $today17_2 + $today18_2 + $today19_2 + $today20_2 + $today15_3 + $today16_3 + $today17_3 + $today18_3 + $today19_3 + $today20_3" | bc); fi
if [ $HOUR == "16" ]; then next6_sum=$(echo "scale=0; $today16_1 + $today17_1 + $today18_1 + $today19_1 + $today20_1 + $today21_1 + $today16_2 + $today17_2 + $today18_2 + $today19_2 + $today20_2 + $today21_2 + $today16_3 + $today17_3 + $today18_3 + $today19_3 + $today20_3 + $today21_3" | bc); fi
if [ $HOUR == "17" ]; then next6_sum=$(echo "scale=0; $today17_1 + $today18_1 + $today19_1 + $today20_1 + $today21_1 + $today22_1 + $today17_2 + $today18_2 + $today19_2 + $today20_2 + $today21_2 + $today22_2 + $today17_3 + $today18_3 + $today19_3 + $today20_3 + $today21_3 + $today22_3" | bc); fi
if [ $HOUR == "18" ]; then next6_sum=$(echo "scale=0; $today18_1 + $today19_1 + $today20_1 + $today21_1 + $today22_1 + $today23_1 + $today18_2 + $today19_2 + $today20_2 + $today21_2 + $today22_2 + $today23_2 + $today18_3 + $today19_3 + $today20_3 + $today21_3 + $today22_3 + $today23_3" | bc); fi
if [ $HOUR == "19" ]; then next6_sum=$(echo "scale=0; $today19_1 + $today20_1 + $today21_1 + $today22_1 + $today23_1 + $today0_1 + $today19_2 + $today20_2 + $today21_2 + $today22_2 + $today23_2 + $today0_2 + $today19_3 + $today20_3 + $today21_3 + $today22_3 + $today23_3 + $today0_3" | bc); fi
if [ $HOUR == "20" ]; then next6_sum=$(echo "scale=0; $today20_1 + $today21_1 + $today22_1 + $today23_1 + $today0_1 + $tomorrow1_1 + $today20_2 + $today21_2 + $today22_2 + $today23_2 + $today0_2 + $tomorrow1_2 + $today20_3 + $today21_3 + $today22_3 + $today23_3 + $today0_3 + $tomorrow1_3" | bc); fi
if [ $HOUR == "21" ]; then next6_sum=$(echo "scale=0; $today21_1 + $today22_1 + $today23_1 + $today0_1 + $tomorrow1_1 + tomorrow2_1 + $today21_2 + $today22_2 + $today23_2 + $today0_2 + $tomorrow1_2 + tomorrow2_2 + $today21_3 + $today22_3 + $today23_3 + $today0_3 + $tomorrow1_3 + tomorrow2_3" | bc); fi
if [ $HOUR == "22" ]; then next6_sum=$(echo "scale=0; $today22_1 + $today23_1 + $today0_1 + $tomorrow1_1 + tomorrow2_1 + $tomorrow3_1 + $today22_2 + $today23_2 + $today0_2 + $tomorrow1_2 + tomorrow2_2 + $tomorrow3_2 + $today22_3 + $today23_3 + $today0_3 + $tomorrow1_3 + tomorrow2_3 + $tomorrow3_3" | bc); fi
if [ $HOUR == "23" ]; then next6_sum=$(echo "scale=0; $today23_1 + $today0_1 + $tomorrow1_1 + $tomorrow2_1 + tomorrow3_1 + $tomorrow4_1 + $today23_2 + $today0_2 + $tomorrow1_2 + $tomorrow2_2 + tomorrow3_2 + $tomorrow4_2 + $today23_3 + $today0_3 + $tomorrow1_3 + $tomorrow2_3 + tomorrow3_3 + $tomorrow4_3" | bc); fi
if [ $HOUR == "0" ]; then next6_sum=$(echo "scale=0; $today0_1 + $tomorrow1_1 + tomorrow2_1 + $tomorrow3_1 + tomorrow4_1 + $tomorrow5_1 + $today0_2 + $tomorrow1_2 + tomorrow2_2 + $tomorrow3_2 + tomorrow4_2 + $tomorrow5_2 + $today0_3 + $tomorrow1_3 + tomorrow2_3 + $tomorrow3_3 + tomorrow4_3 + $tomorrow5_3" | bc); fi

kw_next3_sum=$(echo "scale=3; $next3_sum / 1000" | bc);
kw_next6_sum=$(echo "scale=3; $next6_sum / 1000" | bc);

D=`date "+%b %d %H:%M:%S"`
if [ $DEBUGDEBUG == 1 ]; then
echo "$D - Rquest OK 1/2/3 "$req_ok_1"/"$req_ok_2"/"$req_ok_3
echo "$D - Total Today 1/2/3 " $total_value_today_1"/"$total_value_today_2"/"$total_value_today_3 >> $log
echo "$D - Total Today 1/2/3 " $total_value_tomorrow_1"/"$total_value_tomorrow_2"/"$total_value_tomorrow_3 >> $log
echo "$D - Total Today: "$total_value_today_sum >> $log
echo "$D - Total Tomorrow: "$total_value_tomorrow_sum >> $log
echo "$D - Total Morning: "$total_value_morning_sum >> $log
echo "$D - Total Afternoon: "$total_value_afternoon_sum >> $log
echo "$D - Next 3 / 6: "$next3_sum" / "$next6_sum >> $log
echo "$D - Today h: "$today0_sum"/"$today1_sum"/"$today2_sum"/"$today3_sum"/"$today4_sum"/"$today5_sum"/"$today6_sum"/"$today7_sum"/"$today8_sum"/"$today9_sum"/"$today10_sum"/"$today11_sum"/"$today12_sum"/"$today13_sum"/"$today14_sum"/"$today15_sum"/"$today16_sum"/"$today17_sum"/"$today18_sum"/"$today19_sum"/"$today20_sum"/"$today21_sum"/"$today22_sum"/"$today23_sum >> $log
echo "$D - Tomorrow h: "$tomorrow0_sum"/"$tomorrow1_sum"/"$tomorrow2_sum"/"$tomorrow3_sum"/"$tomorrow4_sum"/"$tomorrow5_sum"/"$tomorrow6_sum"/"$tomorrow7_sum"/"$tomorrow8_sum"/"$tomorrow9_sum"/"$tomorrow10_sum"/"$tomorrow11_sum"/"$tomorrow12_sum"/"$tomorrow13_sum"/"$tomorrow14_sum"/"$tomorrow15_sum"/"$tomorrow16_sum"/"$tomorrow17_sum"/"$tomorrow18_sum"/"$tomorrow19_sum"/"$tomorrow20_sum"/"$tomorrow21_sum"/"$tomorrow22_sum"/"$tomorrow23_sum >> $log
fi

if [ $FORECAST_1SYSTEM_ACTIVE = 1 ];then
echo -n "req.1.ok=$req_ok_1" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $FORECAST_2SYSTEM_ACTIVE = 1 ];then
echo -n "req.2ok=$req_ok_2" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $FORECAST_3SYSTEM_ACTIVE = 1 ];then
echo -n "req.ok.3=$req_ok_3" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi

if [ ! -f $data_failed_log ]; then
failed_counter_old=0
else
failed_counter_old=$(cat $data_failed_log)
fi

if [ $failed_counter_old -ge 4 ]; then
req_ok_1=1
req_ok_2=1
req_ok_3=1
D=`date "+%b %d %H:%M:%S"`
echo "$D - Fehler Anzahl ist > 5 alle Daten werden auf 0 gesetzt" >> $log
echo "$D - Daten werden an MiniServer gesendet" >> $log
fi

if [ $req_ok_1 == 0 ] || [ $req_ok_2 == 0 ] || [ $req_ok_3 == 0 ]; then
D=`date "+%b %d %H:%M:%S"`
echo "$D - Es wurden keine Daten an den MiniServer gesendet" >> $log
failed_counter_new=$(echo "scale=0; $failed_counter_old + 1" | bc)
echo $failed_counter_new > $data_failed_log
echo "$D - Fehler Anzahl: "$failed_counter_new >> $log

else

echo "0" > $data_failed_log

if [ $DATAKW == 1 ]; then

if [ $DATATODAY_TOMORROW_SEP == 1 ]; then
echo -n "total.value.today.system.1=$total_value_today_1 total.value.today.system.1.kw=$kw_total_value_today_1 total.value.today.system.2=$total_value_today_2 total.value.today.system.2.kw=$kw_total_value_today_2 total.value.today.system.3=$total_value_today_3 total.value.today.system.3.kw=$kw_total_value_today_3 total.value.tomorrow.system.1=$total_value_tomorrow_1 total.value.tomorrow.system.1.kw=$kw_total_value_tomorrow_1 total.value.tomorrow.system.2=$total_value_tomorrow_2 total.value.tomorrow.system.2.kw=$kw_total_value_tomorrow_2 total.value.tomorrow.system.3=$total_value_tomorrow_3 total.value.tomorrow.system.3.kw=$kw_total_value_tomorrow_3" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_TOMORROW_SUM == 1 ];then
echo -n "total.today=$total_value_today_sum total.today.kw=$kw_total_value_today_sum  total.tomorrow=$total_value_tomorrow_sum  total.tomorrow.kw=$kw_total_value_tomorrow_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_MORN_AFTER == 1 ];then
echo -n "total.morning=$total_value_morning_sum total.morning.kw=$kw_total_value_morning_sum total.afternoon=$total_value_afternoon_sum total.afternoon.kw=$kw_total_value_afternoon_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_3_6 == 1 ];then
echo -n "next.3.hours=$next3_sum next.3.hours.kw=$kw_next3_sum next.6.hours=$next6_sum next.6.hours.kw=$kw_next6_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_HOUR == 1 ];then
echo -n "today.0=$today0_sum today.24.kw=$kw_today0_sum today.1=$today1_sum today.1.kw=$kw_today1_sum today.2=$today2_sum today.2.kw=$kw_today2_sum today.3=$today3_sum today.3.kw=$kw_today3_sum today.4=$today4_sum today.4.kw=$kw_today4_sum today.5=$today5_sum today.5.kw=$kw_today5_sum today.6=$today6_sum today.6.kw=$kw_today6_sum today.7=$today7_sum today.7.kw=$kw_today7_sum today.8=$today8_sum today.8.kw=$kw_today8_sum today.9=$today9_sum today.9.kw=$kw_today9_sum today.10=$today10_sum today.10.kw=$kw_today10_sum today.11=$today11_sum today.11.kw=$kw_today11_sum today.12=$today12_sum today.12.kw=$kw_today12_sum today.13=$today13_sum today.13.kw=$kw_today13_sum today.14=$today14_sum today.14.kw=$kw_today14_sum today.15=$today15_sum today.15.kw=$kw_today15_sum today.16=$today16_sum today.16.kw=$kw_today16_sum today.17=$today17_sum today.17.kw=$kw_today17_sum today.18=$today18_sum_sum today.18.kw=$kw_today18_sum today.19=$today19_sum today.19.kw=$kw_today19_sum today.20=$today20_sum today.20.kw=$kw_today20_sum today.21=$today21_sum today.21.kw=$kw_today21_sum today.22=$today22_sum today.22.kw=$kw_today22_sum today.23=$today23_sum today.23.kw=$kw_today23_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATOMORROW_HOUR == 1 ];then
echo -n "tomorrow.0=$tomorrow0_sum tomorrow.24.kw=$kw_tomorrow0_sum tomorrow.1=$tomorrow1_sum tomorrow.1.kw=$kw_tomorrow1_sum tomorrow.2=$tomorrow2_sum tomorrow.2.kw=$kw_tomorrow2_sum tomorrow.3=$tomorrow3_sum tomorrow.3.kw=$kw_tomorrow3_sum tomorrow.4=$tomorrow4_sum tomorrow.4.kw=$kw_tomorrow4_sum tomorrow.5=$tomorrow5_sum tomorrow.5.kw=$kw_tomorrow5_sum tomorrow.6=$tomorrow6_sum tomorrow.6.kw=$kw_tomorrow6_sum tomorrow.7=$tomorrow7_sum tomorrow.7.kw=$kw_tomorrow7_sum tomorrow.8=$tomorrow8_sum tomorrow.8.kw=$kw_tomorrow8_sum tomorrow.9=$tomorrow9_sum tomorrow.9.kw=$kw_tomorrow9_sum tomorrow.10=$tomorrow10_sum tomorrow.10.kw=$kw_tomorrow10_sum tomorrow.11=$tomorrow11_sum tomorrow.11.kw=$kw_tomorrow11_sum tomorrow.12=$tomorrow12_sum tomorrow.12.kw=$kw_tomorrow12_sum tomorrow.13=$tomorrow13_sum tomorrow.13.kw=$kw_tomorrow13_sum tomorrow.14=$tomorrow14_sum tomorrow.14.kw=$kw_tomorrow14_sum tomorrow.15=$tomorrow15_sum tomorrow.15.kw=$kw_tomorrow15_sum tomorrow.16=$tomorrow16_sum tomorrow.16.kw=$kw_tomorrow16_sum tomorrow.17=$tomorrow17_sum tomorrow.17.kw=$kw_tomorrow17_sum tomorrow.18=$tomorrow18_sum tomorrow.18.kw=$kw_tomorrow18_sum tomorrow.19=$tomorrow19_sum tomorrow.19.kw=$kw_tomorrow19_sum tomorrow.20=$tomorrow20_sum tomorrow.20.kw=$kw_tomorrow20_sum tomorrow.21=$tomorrow21_sum tomorrow.21.kw=$kw_tomorrow21_sum tomorrow.22=$tomorrow22_sum tomorrow.22.kw=$kw_tomorrow22_sum tomorrow.23=$tomorrow23_sum tomorrow.23.kw=$kw_tomorrow23_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi

else

if [ $DATATODAY_TOMORROW_SEP== 1 ]; then
echo -n "total.value.today.system.1=$total_value_today_1 total.value.today.system.2=$total_value_today_2 total.value.today.system.3=$total_value_today_3 total.value.tomorrow.system.1=$total_value_tomorrow_1 total.value.tomorrow.system.2=$total_value_tomorrow_2 total.value.tomorrow.system.3=$total_value_tomorrow_3" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_TOMORROW_SUM == 1 ];then
echo -n "total.today=$total_value_today_sum total.tomorrow=$total_value_tomorrow_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_MORN_AFTER == 1 ];then
echo -n "total.morning=$total_value_morning_sum total.afternoon=$total_value_afternoon_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_3_6 == 1 ];then
echo -n "next.3.hours=$next3_sum next.6.hours=$next6_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATODAY_HOUR == 1 ];then
echo -n "today.0=$today0_sum today.1=$today1_sum today.2=$today2_sum today.3=$today3_sum today.4=$today4_sum today.5=$today5_sum today.6=$today6_sum today.7=$today7_sum today.8=$today8_sum today.9=$today9_sum today.10=$today10_sum today.11=$today11_sum today.12=$today12_sum today.13=$today13_sum today.14=$today14_sum today.15=$today15_sum today.16=$today16_sum today.17=$today17_sum today.18=$today18_sum today.19=$today19_sum today.20=$today20_sum today.21=$today21_sum today.22=$today22_sum today.23=$today23_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi
if [ $DATATOMORROW_HOUR == 1 ];then
echo -n "tomorrow.0=$tomorrow0_sum tomorrow.1=$tomorrow1_sum tomorrow.2=$tomorrow2_sum tomorrow.3=$tomorrow3_sum tomorrow.4=$tomorrow4_sum tomorrow.5=$tomorrow5_sum tomorrow.6=$tomorrow6_sum tomorrow.7=$tomorrow7_sum tomorrow.8=$tomorrow8_sum tomorrow.9=$tomorrow9_sum tomorrow.10=$tomorrow10_sum tomorrow.11=$tomorrow11_sum tomorrow.12=$tomorrow12_sum tomorrow.13=$tomorrow13_sum tomorrow.14=$tomorrow14_sum tomorrow.15=$tomorrow15_sum tomorrow.16=$tomorrow16_sum tomorrow.17=$tomorrow17_sum tomorrow.18=$tomorrow18_sum tomorrow.19=$tomorrow19_sum tomorrow.20=$tomorrow20_sum tomorrow.21=$tomorrow21_sum tomorrow.22=$tomorrow22_sum tomorrow.23=$tomorrow23_sum" >/dev/udp/$MINISERVER_IP/$MINISERVERUDPPORT &
fi

fi

fi
exit 0
