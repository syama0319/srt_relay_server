#!/bin/bash
LATENCY=125
RXP=7001
TXP=7002

# helpオプション
function usage {
    cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  -l VALUE    latency (default: 125)
  -r VALUE    RX Port (default: 7001)
  -t VALUE    TX Port (default: 7002)
EOM
  exit 2
}

# 引数別の処理定義
while getopts ":l:r:t:h" optKey; do
  case "$optKey" in
    l)
      LATENCY=${OPTARG}
      echo "latency = ${LATENCY}"
      ;;
    r)
      RXP=${OPTARG}
      echo "RX Port = ${RXP}"
      ;;
    t)
      TXP=${OPTARG}
      echo "TX Port = ${TXP}"
      ;;
    '-h'|'--help'|* )
      usage
      ;;
  esac
done

while :; do
  sleep 2
  gst-launch-1.0 -v \
    srtserversrc uri="srt://:$RXP" latency=$LATENCY ! \
    queue leaky=2 ! srtserversink uri="srt://:$TXP"
done