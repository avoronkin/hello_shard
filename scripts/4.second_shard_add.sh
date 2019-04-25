#!/bin/bash
export $(xargs <.env)
set -e

#add shard to cluster
cmd="
    sh.addShard('rs2/rs2_1:27017');
    sh.addShard('rs2/rs2_2:27017');
    sh.addShard('rs2/rs2_3:27017');
"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE \
  mongo \
  --host router:27017 \
  --username cfg_admin \
  --password pwd \
  --authenticationDatabase admin \
  --eval "$cmd"
