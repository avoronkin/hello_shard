## init replica
```
docker-compose -f docker-compose.replica.yml up
./scripts/init_replica.sh
```

## fill repllica
```
scripts/2.fill_repllica.sh
```

## init sharding
```
docker-compose -f docker-compose.shard.yml up
./scripts/3.init_shard.sh
```

## start sharding
```
sh.enableSharding('test')
use test
db.fs.chunks.createIndex({ files_id : 'hashed' })
sh.shardCollection( 'test.fs.chunks', { 'files_id' : 'hashed' })
db.printShardingStatus()
```

## add shard
```
docker-compose -f docker-compose.final.yml up
./scripts/4.add_shard.sh
```


## connect to replica 1
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host rs1/rs1_1:27017,rs1_2:27017,rs1_3:27017
```

## connect to replica 2
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host rs2/rs2_1:27017,rs2_2:27017,rs2_3:27017
```

## connect to mongos
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host router:27017
```

## check configs
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host config/config1:27017,config2:27017,config3:27017
```