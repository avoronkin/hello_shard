#!/bin/bash
export $(xargs <.env)
set -e

#1 replica
rs1_init="rs.initiate({
    _id: 'rs1',
    members: [
        { _id: 0, host : 'rs1_1:27017' },
        { _id: 1, host : 'rs1_2:27017' },
        { _id: 2, host : 'rs1_3:27017' }
    ]
})"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs1_1:27017 --eval "$rs1_init"