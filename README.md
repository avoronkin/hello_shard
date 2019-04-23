## init shards
```
docker-compose up
./scripts/init.sh
```

## connect to mongos
```
docker run -it --network="mongodbshard_mongo" --rm mongo:4 mongo --host router:27017
```
