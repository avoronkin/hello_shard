#!/bin/bash
export $(xargs <.env)
set -e

rs1_init="
rs.initiate({
    _id: 'rs1',
    members: [
        { _id: 0, host : 'rs1_1:27017' },
        { _id: 1, host : 'rs1_2:27017' },
        { _id: 2, host : 'rs1_3:27017' }
    ]
});"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs1_1:27017 --eval "$rs1_init"

rs2_init="rs.initiate({
    _id: 'rs2',
    members: [
        { _id: 0, host : 'rs2_1:27017' },
        { _id: 1, host : 'rs2_2:27017' },
        { _id: 2, host : 'rs2_3:27017' }
    ]
})"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs2_1:27017 --eval "$rs2_init"

cfg_init="rs.initiate({
    _id: 'config',
    configsvr: true,
    members: [
        { _id: 0, host : 'config1:27017' },
        { _id: 1, host : 'config2:27017' },
        { _id: 2, host : 'config3:27017' }
    ]
})"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host config1:27017 --eval "$cfg_init"

sleep 10

rs1_users="
admin = db.getSiblingDB('admin');
admin.createUser(
  {
    user: 'rs1_useradmin',
    pwd: 'pwd',
    roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ]
  }
);
admin.auth('rs1_useradmin', 'pwd')
admin.createUser(
  {
    user : 'rs1_admin',
    pwd : 'pwd',
    roles: [ { 'role' : 'clusterAdmin', 'db' : 'admin' } ]
  }
);
admin.createUser(
  {
    user : 'test',
    pwd : 'pwd',
    roles: [ { 'role' : 'readWrite', 'db' : 'test' } ]
  }
);"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs1/rs1_1:27017,rs1_2:27017,rs1_3:27017 --eval "$rs1_users"

cfg_users="
admin = db.getSiblingDB('admin');
admin.createUser(
  {
    user: 'cfg_useradmin',
    pwd: 'pwd',
    roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ]
  }
);
admin.auth('cfg_useradmin', 'pwd')
admin.createUser(
  {
    user : 'cfg_admin',
    pwd : 'pwd',
    roles: [ { 'role' : 'clusterAdmin', 'db' : 'admin' } ]
  }
);"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host config/config1:27017,config2:27017,config3:27017 --eval "$cfg_users"

rs2_users="
admin = db.getSiblingDB('admin');
admin.createUser(
  {
    user: 'rs2_useradmin',
    pwd: 'pwd',
    roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ]
  }
);
admin.auth('rs2_useradmin', 'pwd')
admin.createUser(
  {
    user : 'rs2_admin',
    pwd : 'pwd',
    roles: [ { 'role' : 'clusterAdmin', 'db' : 'admin' } ]
  }
);"

docker run -it --network="$NETWORK" --rm $MONGODB_IMAGE mongo --host rs2/rs2_1:27017,rs2_2:27017,rs2_3:27017 --eval "$rs2_users"
