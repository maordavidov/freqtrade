#!/bin/bash
TIMEFRAME=$1
TIMERANGE=$2
python -m freqtrade download-data --timeframes ${TIMEFRAME} --timerange ${TIMERANGE} --exchange binance --config alfred/config.json