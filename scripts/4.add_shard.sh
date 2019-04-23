#!/bin/bash
export $(xargs <.env)
set -e

#shard 2 repllica
rs2_init="rs.initiate({
    _id: 'rs2',
    members: [
        { _id: 0, host : 'rs2_1:27017' },
        { _id: 1, host : 'rs2_2:27017' },
        { _id: 2, host : 'rs2_3:27017' }
    ]
})"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs2_1:27017 --eval "$rs2_init"

sleep 10

#add shards to cluster
shards_init="
    sh.addShard('rs2/rs2_1:27017');
    sh.addShard('rs2/rs2_2:27017');
    sh.addShard('rs2/rs2_3:27017');
"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host router:27017 --eval "$shards_init"
