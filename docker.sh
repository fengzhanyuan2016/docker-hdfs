docker run -p 22022:22 -p 8020:8020 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -d -v hdfs:/data/hadoop/dfs/name --network=spark-net fengzhanyuan/hdfs
docker run -p 21022:22 -p 8080:8080 -d  --network=spark-net fengzhanyuan/zeppelin