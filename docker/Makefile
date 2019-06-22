
# Makefile
# see https://www.gnu.org/software/make/manual/make.html


# VARIABLES

NAME := spring-hateoas
GROUP := samples

BUILD_TOOL := ./mvnw
JAR_FILE := $(shell find target -name '*.jar' 2>/dev/null)

IMAGE_NAME := $(GROUP)/$(NAME)
IMAGE_TAG := 0.0.1
IMAGE_EXPOSE_PORT := 9000
IMAGE_EXPOSE_METRICS_PORT := 9000
IMAGE_DEBUG_PORT := 5005
DOCKER_REGISTRY_HOST := 10.132.0.3
DOCKER_REGISTRY_PORT := 5000
DOCKER_HOST := dockerhost
# Retrieving docker IP address on localhost
DOCKER_IP := $$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $$2}')
DOCKER_IMAGE_PORTS := -p $(IMAGE_EXPOSE_PORT):$(IMAGE_EXPOSE_PORT) -p $(IMAGE_EXPOSE_METRICS_PORT):$(IMAGE_EXPOSE_METRICS_PORT) -p $(IMAGE_DEBUG_PORT):$(IMAGE_DEBUG_PORT)
SONARQUBE_VERSION := 7.1-alpine

# see https://docs.spring.io/spring-boot/docs/2.0.3.RELEASE/maven-plugin/run-mojo.html#jvmArguments
MEM_OPTS := -Xms128m -Xmx128m -XX:MaxMetaspaceSize=64m
JMX_OPTS := -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -Dcom.sun.management.jmxremote.port=3$(IMAGE_EXPOSE_METRICS_PORT) -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false
DEBUG_OPTS := -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=$(IMAGE_DEBUG_PORT)
#OTHER_OPTS :=

.PHONY: help
.DEFAULT_GOAL := help


# BUILDING

dependencies :		## Show dependency tree
	$(BUILD_TOOL) dependency:tree -Dverbose

clean :		## Clean the application
	$(BUILD_TOOL) clean

compile :		## Compile the application
	$(BUILD_TOOL) compile

build :		## Build the application package including unit tests only
	$(BUILD_TOOL) -Dtest=*UnitTest package

verify :		## Verify that the code coverage metrics are being met
	$(BUILD_TOOL) verify

install :		## Install the application package including all tests and push to artifact repo
	$(BUILD_TOOL) install

clean-compile :		## Clean and Compile the application including unit tests only
	$(BUILD_TOOL) clean compile

clean-build :		## Clean and Build the application package including unit tests only
	$(BUILD_TOOL) -Dtest=*UnitTest -DfailIfNoTests=false clean package

clean-install :		## Clean and Install the application package including all tests and push to artifact repo
	$(BUILD_TOOL) -DfailIfNoTests=false clean install


# TESTING

test :		## Run all tests
	$(BUILD_TOOL) test

unit-test :		## Run Unit tests only
	$(BUILD_TOOL) -Dtest=*UnitTest -DfailIfNoTests=false test

integration-test :		## Run Integration tests only
	$(BUILD_TOOL) -Dtest=*IntegrationTest -DfailIfNoTests=false test

contract-test :		## Run Contract tests only
	$(BUILD_TOOL) -Dtest=*ContractTest -DfailIfNoTests=false test

startup-test :		## Run Startup tests only
	$(BUILD_TOOL) -Dtest=*StartupTest -DfailIfNoTests=false test


# RUNNING

run :		## Run the application through Spring Boot plugin
	$(BUILD_TOOL) spring-boot:run -DskipTests -Dspring-boot.run.jvmArguments='$(MEM_OPTS) $(JMX_OPTS) $(OTHER_OPTS)'

debug :		## Run the application in debug mode through Spring Boot plugin
	$(BUILD_TOOL) spring-boot:run -DskipTests -Dspring-boot.run.jvmArguments='$(MEM_OPTS) $(JMX_OPTS) $(DEBUG_OPTS) $(OTHER_OPTS)'

java-run :		## Run the application through the generated fat-jar
	java $(MEM_OPTS) $(JMX_OPTS) $(OTHER_OPTS) -jar $(JAR_FILE)

java-debug :		## Run the application in debug mode through the generated fat-jar
	java $(MEM_OPTS) $(JMX_OPTS) $(DEBUG_OPTS) $(OTHER_OPTS) -jar $(JAR_FILE)


# DOCKER

docker-prepare :		## Prepare the application to be containerised
	$(BUILD_TOOL) -DfailIfNoTests=false clean package

docker-build : docker-prepare		## Build the docker IMAGE_NAME of the application
	docker build -f Dockerfile_local -t $(IMAGE_NAME):$(IMAGE_TAG) .

docker-run :		## Run the containerised application through docker
	@echo Docker host [$(DOCKER_HOST)] ip [$(DOCKER_IP)]
	docker run --rm -it --name $(NAME) $(DOCKER_IMAGE_PORTS) --net bridge --add-host=$(DOCKER_HOST):$(DOCKER_IP) $(IMAGE_NAME):$(IMAGE_TAG)

docker-run-daemon :		## Run the containerised application as daemon through docker
	@echo Docker host [$(DOCKER_HOST)] ip [$(DOCKER_IP)]
	docker run --rm -d --name $(NAME) $(DOCKER_IMAGE_PORTS) --net bridge --add-host=$(DOCKER_HOST):$(DOCKER_IP) $(IMAGE_NAME):$(IMAGE_TAG)

docker-stop :		## Stop the containerised application
	docker container stop -f $(NAME)

docker-delete-local : docker-stop		## Delete the docker IMAGE_NAME of the application
	docker container rm -f $(NAME)
	docker image rm -f $(NAME)

docker-push : docker-build		## Push the docker application to the docker registry
	@echo Docker Registry host [$(DOCKER_REGISTRY_HOST)] ip [$(DOCKER_REGISTRY_PORT)]
	docker push $(DOCKER_REGISTRY_HOST):$(DOCKER_REGISTRY_PORT)/$(IMAGE_NAME):$(IMAGE_TAG)

docker-delete-remote : docker-stop		## Delete the docker IMAGE_NAME of the application from the docker registry
	@echo Docker Registry host [$(DOCKER_REGISTRY_HOST)] ip [$(DOCKER_REGISTRY_PORT)]
	docker image rm $(DOCKER_REGISTRY_HOST):$(DOCKER_REGISTRY_PORT)/$(IMAGE_NAME):$(IMAGE_TAG)


# GENERAL

help :		## Help
	@echo ""
	@echo "*** $(NAME) Makefile help ***"
	@echo ""
	@echo "Targets list:"
	@grep -E '^[a-zA-Z_-]+ :.*?## .*$$' $(MAKEFILE_LIST) | sort -k 1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

print-variables :		## Print variables values
	@echo "MAKE: $(MAKE)"
	@echo "MAKEFILES: $(MAKEFILES)"
	@echo "MAKEFILE_LIST: $(MAKEFILE_LIST)"
	@echo "- - - "
	@echo "NAME: $(NAME)"
	@echo "- - - "
	@echo "BUILD_TOOL: $(BUILD_TOOL)"
	@echo "JAR_FILE: $(JAR_FILE)"
	@echo "- - - "
	@echo "IMAGE_NAME: $(IMAGE_NAME)"
	@echo "IMAGE_TAG: $(IMAGE_TAG)"
	@echo "- - - "
	@echo "IMAGE_EXPOSE_PORT: $(IMAGE_EXPOSE_PORT)"
	@echo "IMAGE_EXPOSE_METRICS_PORT: $(IMAGE_EXPOSE_METRICS_PORT)"
	@echo "IMAGE_DEBUG_PORT: $(IMAGE_DEBUG_PORT)"
	@echo "- - - "
	@echo "DOCKER_REGISTRY_HOST: $(DOCKER_REGISTRY_HOST)"
	@echo "DOCKER_REGISTRY_PORT: $(DOCKER_REGISTRY_PORT)"
	@echo "DOCKER_HOST: $(DOCKER_HOST)"
	@echo "DOCKER_IP: $(DOCKER_IP)"
	@echo "DOCKER_IMAGE_PORTS: $(DOCKER_IMAGE_PORTS)"
	@echo "- - - "
	@echo "SONARQUBE_VERSION: $(SONARQUBE_VERSION)"
	@echo "- - - "
	@echo "MEM_OPTS: $(MEM_OPTS)"
	@echo "JMX_OPTS: $(JMX_OPTS)"
	@echo "DEBUG_OPTS: $(DEBUG_OPTS)"
	@echo "OTHER_OPTS: $(OTHER_OPTS)"
