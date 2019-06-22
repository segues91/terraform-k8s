FROM openjdk:8-jre-alpine

COPY target/spring-hateoas.jar /opt/

WORKDIR /opt

ENV JVM_LIMIT_OPTS='-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap'
ENV HEAP_SIZE=128m
ENV META_SIZE=64m

EXPOSE 8080 8090

ENTRYPOINT exec java -server $JVM_LIMIT_OPTS -Xms$HEAP_SIZE -Xmx$HEAP_SIZE -XX:MaxMetaspaceSize=$META_SIZE $JAVA_OPTS -jar spring-hateoas.jar
