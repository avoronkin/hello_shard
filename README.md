## init rs1,rs2,config replicas and add users
```
docker-compose -f docker-compose.init.yml up
./scripts/1.init.sh
```

## start all with auth
```
docker-compose up
```

## fill rs1 repllica
```
./scripts/2.replica_fill.sh
```

## init sharding
```
./scripts/3.first_shard_init.sh
```

## add shard
```
docker-compose -f docker-compose.final.yml up
./scripts/4.second_shard_add.sh
```

## connect to replica 1
user admin: rs1_useradmin|pwd
cluster admin: rs1_admin|pwd
test db: test|pwd
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host rs1/rs1_1:27017,rs1_2:27017,rs1_3:27017
```

## connect to config replica
user admin: cfg_useradmin|pwd
cluster admin: cfg_admin|pwd
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host config/config1:27017,config2:27017,config3:27017
```

## connect to replica 2
user admin: rs2_useradmin|pwd
cluster admin: rs2_admin|pwd
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host rs2/rs2_1:27017,rs2_2:27017,rs2_3:27017
```

## connect to mongos
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host router:27017
```