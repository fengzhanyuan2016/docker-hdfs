#!/bin/bash
service ssh start
start-dfs.sh
httpfs.sh start
hadoop-daemon.sh start portmap
hadoop-daemon.sh start nfs3
hive --service metastore &
hive -–service hiveserver2 &
