#!/bin/bash
export $(xargs <.env)
set -e

#!/bin/bash
for (( c=1; c<=100; c++ ))
do
    docker run -it \
    --volume $(pwd)/test.jpg:/test.jpg \
    --network="$NETWORK" \
    --rm $MONGODB_IMAGE \
    mongofiles \
    --host router:27017 \
    --username test \
    --password pwd \
    --authenticationDatabase admin \
    put test.jpg
done