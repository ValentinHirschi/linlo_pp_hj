ps -ef | grep 'mathem' | grep -v grep | awk '{print $2}' | xargs -r kill -9
# killall -9 wolframscript
# killall -9 /opt/mathematica-12.0/Executables/wolframscript
