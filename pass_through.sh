#!/bin/sh

# helpオプション
function usage{
    cat <<EOM
Usage: $(basename "$0") [OPTION]...
  -h          Display help
  -l VALUE    latency (default: 125)
  -r VALUE    RX Port (default: 7001)
  -t VALUE    TX Port (default: 7002)
EOM
}

# 引数別の処理定義
while getopts ":l:r:t:h" optKey; do
  case "$optKey" in
    l)
      LATENCY=${OPTARG:-125}
      echo "latency = ${OPTARG}"
      ;;
    r)
      RXP=${OPTARG:-7001}
      echo "RX Port = ${OPTARG}"
      ;;
    t)
      TXP=${OPTARG:-7002}
      echo "TX Port = ${OPTARG}"
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