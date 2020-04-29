# container ids
CONTAINER_WEB_ID     = php-fpm

# connect to containers
EXEC_WEB_BASH     = docker exec -itu www-data $(CONTAINER_WEB_ID) bash
EXEC_ROOT_BASH    = docker exec -it $(CONTAINER_WEB_ID) bash

docker-start: ## docker-compose up --build without -d mode
docker-start:
	docker-compose up --build

docker-start-d: ## docker-compose up -d --build with -d mode
docker-start-d:
	docker-compose up -d --build

docker-back-user: ## Access the web container as www-data
docker-back-user:
	$(EXEC_WEB_BASH)

docker-back-root: ## Access the web container as root
docker-back-root:
	$(EXEC_ROOT_BASH)

docker-composer-install: ## Composer install
docker-composer-install:
	$(EXEC_WEB_BASH) -c "composer install"

elasticsearch-cluster-memory:
	$(EXEC_WEB_BASH) -c "curl -X PUT http://elasticsearch:9200/_cluster/settings -H 'Content-Type: application/json' -d '{\"transient\": {\"cluster.routing.allocation.disk.watermark.low\": \"100mb\", \"cluster.routing.allocation.disk.watermark.high\": \"90mb\", \"cluster.routing.allocation.disk.watermark.flood_stage\": \"80mb\", \"cluster.info.update.interval\": \"1m\"}}'"

elasticsearch-cluster-index-read:
	$(EXEC_WEB_BASH) -c "curl -XPUT -H 'Content-Type: application/json' http://elasticsearch:9200/_all/_settings -d '{\"index.blocks.read_only_allow_delete\": null}'"

elasticsearch-cluster-fix: ## Add memory to Elasticsearch cluster and reset the read-only index
elasticsearch-cluster-fix: elasticsearch-cluster-memory elasticsearch-cluster-index-read

.PHONY: docker-start docker-start-d docker-back-root docker-back-user docker-composer-install elasticsearch-cluster-fix elasticsearch-cluster-memory elasticsearch-cluster-index-read

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help