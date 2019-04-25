#!/bin/bash
export $(xargs <.env)
set -e

# add shard to cluster
cmd="
    db.getSiblingDB('admin').auth('cfg_admin', 'pwd');
    sh.addShard('rs1/rs1_1:27017');
    sh.addShard('rs1/rs1_2:27017');
    sh.addShard('rs1/rs1_3:27017');

    sh.enableSharding('test');

    db.getSiblingDB('admin').auth('test', 'pwd');
    test = db.getSiblingDB('test');
    test.fs.chunks.createIndex({ files_id : 'hashed' });

    db.getSiblingDB('admin').auth('cfg_admin', 'pwd');
    sh.shardCollection( 'test.fs.chunks', { 'files_id' : 'hashed' });
    test.printShardingStatus();
"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE \
  mongo \
  --host router:27017 \
  --username cfg_admin \
  --password pwd \
  --authenticationDatabase admin \
  --eval "$cmd"
