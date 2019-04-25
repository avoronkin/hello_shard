#!/bin/bash
export $(xargs <.env)
set -e

# fill rs1 replica
for (( c=1; c<=100; c++ ))
do
    docker run -it \
    --volume $(pwd)/test.jpg:/test.jpg \
    --network="$NETWORK" \
    --rm $MONGODB_IMAGE \
    mongofiles \
    --db test \
    --username test \
    --password pwd \
    --authenticationDatabase admin \
    --host rs1/rs1_1:27017,rs1_2:27017,rs1_3:27017 \
    put test.jpg
done