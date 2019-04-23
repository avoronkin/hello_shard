#!/bin/bash
export $(xargs <.env)
set -e

#config server replica
configserver_init="rs.initiate({
    _id: 'config',
    configsvr: true,
    members: [
        { _id: 0, host : 'config1:27017' },
        { _id: 1, host : 'config2:27017' },
        { _id: 2, host : 'config3:27017' }
    ]
})"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host config1:27017 --eval "$configserver_init"

sleep 10

#add shards to cluster
shards_init="
    sh.addShard('rs1/rs1_1:27017');
    sh.addShard('rs1/rs1_2:27017');
    sh.addShard('rs1/rs1_3:27017');
"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host router:27017 --eval "$shards_init"
