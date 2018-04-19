sudo mkdir import
sudo mkdir plugins

sudo wget -P /root/import https://github.com/datsoftlyngby/soft2018spring-databases-teaching-material/raw/master/data/archive_graph.tar.gz
sudo tar -xvzf /root/import/archive_graph.tar.gz
sudo rm /root/import/archive_graph.tar.gz
sudo sed -i -E '1s/.*/:ID,name,job,birthday/' import/social_network_nodes.csv
sudo sed -i -E '1s/.*/:START_ID,:END_ID/' import/social_network_edges.csv

sudo wget -P /root/plugins https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.3.0.1/apoc-3.3.0.1-all.jar
sudo wget -P /root/plugins https://github.com/neo4j-contrib/neo4j-graph-algorithms/releases/download/3.3.2.0/graph-algorithms-algo-3.3.2.0.jar
sudo docker run -d --name neo4j --rm --publish=7474:7474 --publish=7687:7687 --volume=/root/import:/import --volume=/root/plugins:/plugins --env NEO4J_dbms_memory_pagecache_size=6G --env NEO4J_dbms_memory_heap_max_size=10G --env NEO4J_AUTH=neo4j/class --env=NEO4J_dbms_security_procedures_unrestricted=apoc.\\\*,algo.\\\* neo4j
sudo docker exec neo4j sh -c 'neo4j stop'
sudo docker exec neo4j sh -c 'rm -rf data/databases/graph.db'
sudo docker exec neo4j sh -c 'neo4j-admin import \
      --nodes:Person import/social_network_nodes_small.csv \
      --relationships:ENDORSES import/social_network_edges_small.csv \
      --ignore-missing-nodes=true \
      --ignore-duplicate-nodes=true \
      --id-type=INTEGER'
sudo docker restart neo4j	  

	