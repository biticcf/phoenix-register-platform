#!/bin/bash

APP_NAME="cougar"

#取当前目录
BASE_PATH=`cd "$(dirname "$0")"; pwd`

#设置java运行参数
DEFAULT_JAVA_OPTS=" -server -Xmx3g -Xms3g -Xmn256m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "

#定义变量:
APP_PATH=${APP_PATH:-`dirname "$BASE_PATH"`}
CLASS_PATH=${CLASS_PATH:-$APP_PATH/config:$APP_PATH/classes:$APP_PATH/lib/*}
JAVA_OPTS=${JAVA_OPTS:-$DEFAULT_JAVA_OPTS}
MAIN_CLASS=${MAIN_CLASS:-"com.wanda.cougar.app.Main"}
LOG_PATH=${LOG_PATH:-"/var/wd/cougar_logs/"}
if [ ! -d "$LOG_PATH" ]; then 
	mkdir -p $LOG_PATH
fi

#设置spring boot初始化参数
SPRING_BOOT_OPTS=" -Dspring.config.location=./config/application.properties "


exist(){
			if test $( pgrep -f "$APP_NAME" | wc -l ) -eq 0 
			then
				return 1
			else
				return 0
			fi
}

start(){
		if exist; then
				echo "$APP_NAME is already running."
				exit 1
		else
	    	cd $APP_PATH
				nohup java $JAVA_OPTS -cp $CLASS_PATH $MAIN_CLASS $SPRING_BOOT_OPTS $APP_NAME 2 > $LOG_PATH/console.log & 
				echo "$APP_NAME is started."
		fi
}

stop(){
		runningPID=`pgrep -f "$APP_NAME"`
		if [ "$runningPID" ]; then
				echo "$APP_NAME pid: $runningPID"
        count=0
        kwait=5
        echo "$APP_NAME is stopping, please wait..."
        kill -15 $runningPID
					until [ `ps --pid $runningPID 2> /dev/null | grep -c $runningPID 2> /dev/null` -eq '0' ] || [ $count -gt $kwait ]
		        do
		            sleep 1
		            let count=$count+1;
		        done

	        if [ $count -gt $kwait ]; then
	            kill -9 $runningPID
	        fi
        clear
        echo "$APP_NAME is stopped."
    else
    		echo "$APP_NAME has not been started."
    fi
}

check(){
   if exist; then
   	 echo "$APP_NAME is alive."
   	 exit 0
   else
   	 echo "$APP_NAME is dead."
   	 exit -1
   fi
}

restart(){
        stop
        start
}

case "$1" in

start)
        start
;;
stop)
        stop
;;
restart)
        restart
;;
check)
        check
;;
*)
        echo "available operations: [start|stop|restart|check]"
        exit 1
;;
esac
