#!/bin/bash

set -e
image=mongo:4
network=mongodbshard_mongo

#shard 1 replica
rs1_init="rs.initiate({
    _id: 'rs1',
    members: [
        { _id: 0, host : 'rs1_1:27017' },
        { _id: 1, host : 'rs1_2:27017' },
        { _id: 2, host : 'rs1_3:27017' }
    ]
})"

docker run -it --network="$network" --rm $image mongo --host rs1_1:27017 --eval "$rs1_init"

#shard 2 repllica
rs2_init="rs.initiate({
    _id: 'rs2',
    members: [
        { _id: 0, host : 'rs2_1:27017' },
        { _id: 1, host : 'rs2_2:27017' },
        { _id: 2, host : 'rs2_3:27017' }
    ]
})"

docker run -it --network="$network" --rm $image mongo --host rs2_1:27017 --eval "$rs2_init"

#config server replica
configserver_init="rs.initiate({
    _id: 'config',
    members: [
        { _id: 0, host : 'config1:27017' },
        { _id: 1, host : 'config2:27017' },
        { _id: 2, host : 'config3:27017' }
    ]
})"

docker run -it --network="$network" --rm $image mongo --host config1:27017 --eval "$configserver_init"

sleep 5

#shards
shards_init="
    sh.addShard('rs1/rs1_1:27017');
    sh.addShard('rs1/rs1_2:27017');
    sh.addShard('rs1/rs1_3:27017');

    sh.addShard('rs2/rs2_1:27017');
    sh.addShard('rs2/rs2_2:27017');
    sh.addShard('rs2/rs2_3:27017');
"

docker run -it --network="$network" --rm $image mongo --host router:27017 --eval "$shards_init"
