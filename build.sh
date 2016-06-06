docker build --build-arg https_proxy=$http_proxy \
						 --build-arg http_proxy=$http_proxy \
						 --build-arg HTTP_PROXY=$http_proxy \
						 -t vl/elasticsearch-arm \
						 --rm=true .
