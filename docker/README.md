# Spring HATEOAS sample project
###### Hypermedia As The Engine Of Application State

## Description

This is a really simple example of how to implement RESTful APIs compliant to HATEOAS best practices.

---

## Tech stack

#### Application
* Java 8
* Maven Wrapper 3.x
* Spring Boot 2.0.x
* Spring Actuator
* Spring Data
* Spring HATEOAS
* H2 in-memory database
* Slf4j 1.7.x
* Lombok 1.18.x

#### Testing
* JUnit 4
* Spring Boot 2.0.x

---

## Build & run

#### Pre-requisites
No specific pre-requisites

#### Make
* just compile

		make clean compile

* build and run unit tests

		make clean build

* install

		make install

* run

		make run

* debug

		make debug

* run integration tests

		make integration-test

* run all tests

		make test

* docker
	* build image
	
			make docker-build
	
	* run container
	
			make docker-run
	
	* run container as daemon
	
			make docker-run-daemon
	
	* stop daemon container
	
			make docker-stop

#### Maven & Docker
* just compile

		./mvnw clean compile

* build and run unit tests

		./mvnw -Dtest=*UnitTest clean package

* install

		./mvnw clean install

* run

		./mvnw spring-boot:run -DskipTests -Dspring-boot.run.jvmArguments='$(MEM_OPTS) $(JMX_OPTS) $(OTHER_OPTS)'

* debug

		./mvnw spring-boot:run -DskipTests -Dspring-boot.run.jvmArguments='$(MEM_OPTS) $(JMX_OPTS) $(OTHER_OPTS) -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=$(IMAGE_DEBUG_PORT)'

* run integration tests

		./mvnw -Dtest=*IntegrationTest -DfailIfNoTests=false test

* run all tests

		./mvnw test

* docker
	* build image
			
			./mvnw clean package
			docker build -f Dockerfile_local -t $(IMAGE_NAME):$(IMAGE_TAG) .
	
	* run container
	
			docker run --rm -it --name $(NAME) $(DOCKER_IMAGE_PORTS) --net bridge --add-host=$(DOCKER_HOST):$(DOCKER_IP) $(IMAGE_NAME):$(IMAGE_TAG)
	
	* run container as daemon
	
			docker run --rm -d --name $(NAME) $(DOCKER_IMAGE_PORTS) --net bridge --add-host=$(DOCKER_HOST):$(DOCKER_IP) $(IMAGE_NAME):$(IMAGE_TAG)
	
	* stop daemon container
	
			docker container stop -f $(NAME)

---

## Links

#### Theory
https://martinfowler.com/articles/richardsonMaturityModel.html

#### Techs

###### DONE
* https://www.baeldung.com/spring-hateoas-tutorial
* https://dzone.com/articles/applying-hateoas-to-a-rest-api-with-spring-boot

###### IN-PROG
/

###### TODO
* https://docs.spring.io/spring-hateoas/docs/current/reference/html/

#### Issues
* https://stackoverflow.com/questions/20985481/java-compile-conflict-return-type-is-incompatible-with-hateoas-resourcesupport
* https://github.com/spring-projects/spring-hateoas/issues/709
* https://stackoverflow.com/questions/41430166/how-to-initialize-one-to-many-relationship-in-spring-data-jpa-in-data-sql-initia

#### Repos
* https://github.com/eugenp/tutorials/tree/master/spring-security-rest
* https://github.com/lankydan/spring-boot-hateoas
* https://github.com/Baeldung/spring-hypermedia-api
