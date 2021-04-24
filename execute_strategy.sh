#!/bin/bash

TIMEFRAME=$1
TIMERANGE=$2

bash download.sh $TIMEFRAME $TIMERANGE


python -m freqtrade backtesting --strategy-path alfred/strategies --strategy MACDStrategy_crossed --export trades --timeframe ${TIMEFRAME} --timerange ${TIMERANGE} --config alfred/config.json

#---- Plot ----
python -m freqtrade plot-dataframe \
  --timeframe ${TIMEFRAME} \
  --config alfred/config.json \
  --strategy-path alfred/strategies \
  --strategy MACDStrategy_crossed \
  --timerange ${TIMERANGE}