#!/bin/sh

RECVLATENCY=200



while :; do
  sleep 2
  gst-launch-1.0 -v \
    srtserversrc uri="srt://:7001" latency=$RECVLATENCY ! \
    queue leaky=2 ! srtserversink uri="srt://:7002"
done