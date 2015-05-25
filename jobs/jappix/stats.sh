#!/bin/bash

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

CACHE_DIR="${web_path}stats.jappix.com/cache"
METRONOME_DB=/usr/local/var/lib/metronome

# GET STATS
echo $(find ${METRONOME_DB}/jappix%2ecom/accounts -maxdepth 1 -type f -print | wc -l) > "${CACHE_DIR}/registered"
echo $(find ${METRONOME_DB}/muc%2ejappix%2ecom/config -maxdepth 1 -type f -print | wc -l) > "${CACHE_DIR}/muc"
echo $(find ${METRONOME_DB}/pubsub%2ejappix%2ecom/pubsub -maxdepth 1 -type f -print | wc -l) > "${CACHE_DIR}/pubsub"
