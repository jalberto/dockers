IP=$(scw-metadata PRIVATE_IP)

# docker run -d --name es --restart=always -p 9200:9200 -p 9300:9300 \
# 		-h "${HOSTNAME}" \ 
# 			-e "ES_HEAP_SIZE=1g" \
# 			-v /mnt/data/esplugins:/usr/share/elasticsearch/plugins \
# 			-v /mnt/data/esdata:/usr/share/elasticsearch/data \
# 			-v /mnt/data/esconfig:/usr/share/elasticsearch/config vl/elasticsearch-arm  \
# 			-Des.discovery.zen.ping.unicast.hosts=10.1.22.114,10.1.0.201 \
# 			-Des.network.publish_host=${IP} \
# 			-Dnode.master=true \
# 			-Dnode.data=false \
# 			-Dnode.client=false

docker run -d \
  -p 9200:9200 \
  -p 9300:9300 \
	-h "${HOSTNAME}" \
  mangoraft/elasticsearch-arm \
  --cluster.name=vlprod \
	--network.publish_host=${IP} \
  --discovery.zen.ping.multicast.enabled=false \
  --discovery.zen.ping.unicast.hosts=192.168.1.20 \
  --discovery.zen.ping.timeout=3s \
  --discovery.zen.minimum_master_nodes=1
