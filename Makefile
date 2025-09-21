COMPOSE_PREFIX := docker/docker-compose.
COMPOSE_EXT := yml
# Detecta automaticamente todos os arquivos docker-compose-*.yaml
COMPOSE_FILES := $(wildcard $(COMPOSE_PREFIX)*.$(COMPOSE_EXT))
# Cria targets dinâmicos para up e down
UP_TARGETS := $(COMPOSE_FILES:$(COMPOSE_PREFIX)%.$(COMPOSE_EXT)=%-up)
DOWN_TARGETS := $(COMPOSE_FILES:$(COMPOSE_PREFIX)%.$(COMPOSE_EXT)=%-down)

.PHONY: up down

# Pattern rule: sobe cada arquivo individualmente
%-up: $(COMPOSE_PREFIX)%.$(COMPOSE_EXT)
	@echo "Starting services in docker-compose-$*.$(COMPOSE_EXT)..."
	@podman compose -p $* -f $(COMPOSE_PREFIX)$*.$(COMPOSE_EXT) up -d

# Pattern rule: derruba cada arquivo individualmente
%-down: $(COMPOSE_PREFIX)%.$(COMPOSE_EXT)
	@echo "Stopping services in docker-compose-$*.$(COMPOSE_EXT)..."
	@podman compose -p $* -f $(COMPOSE_PREFIX)$*.yml down

# Redes externas (que devem ser compartilhadas entre diferentes composes)
networks-create:
	@echo "Creating Docker networks..."
	@podman network create cassandra-network || true

networks-delete:
	@echo "Deleting Docker networks..."
	@podman network rm cassandra-network || true

# Sobe todos
up: networks-create $(UP_TARGETS)
	@echo "All services are up."

# Derruba todos
down: $(DOWN_TARGETS) networks-delete
	@echo "All services stopped."


get-spark-casssandra-connector:
	@echo "Downloading Spark Cassandra Connector..."
	@rm -rf libs/*
	mkdir -p libs
	cd libs

	# Download all required JARs
	wget https://repo1.maven.org/maven2/com/datastax/spark/spark-cassandra-connector_2.12/3.4.1/spark-cassandra-connector_2.12-3.4.1.jar
	wget https://repo1.maven.org/maven2/com/datastax/oss/java-driver-core/4.15.0/java-driver-core-4.15.0.jar
	wget https://repo1.maven.org/maven2/com/datastax/oss/java-driver-query-builder/4.15.0/java-driver-query-builder-4.15.0.jar
	wget https://repo1.maven.org/maven2/com/datastax/oss/java-driver-mapper-runtime/4.15.0/java-driver-mapper-runtime-4.15.0.jar
	wget https://repo1.maven.org/maven2/com/datastax/oss/java-driver-shaded-guava/25.1-jre-graal-sub-1/java-driver-shaded-guava-25.1-jre-graal-sub-1.jar
	wget https://repo1.maven.org/maven2/org/reactivestreams/reactive-streams/1.0.4/reactive-streams-1.0.4.jar
