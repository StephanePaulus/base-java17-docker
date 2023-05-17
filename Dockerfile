FROM eclipse-temurin:17 as jre-build

# Create a custom Java runtime
RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM debian:11-slim as debian

#COPY ROOT certificate if needed
#COPY root-ca/* /usr/local/share/ca-certificates/home/


ARG DOCKER_FILE_CREATED

# Download and trust the root certificates of public CAs (list from Mozilla)
# and pick up the copied root certificates
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    # Create system user {COMPANY_NAME}
    groupadd --system home && \
    useradd --system --create-home --home-dir /home --gid home home

# Use {COMPANY_NAME} UID to run the container
# This behaviour might be overrided with:
#     docker run -u $(id -u):$(id -g) ...
# or
#     docker run -u 0 ...
USER home

# Set the work directory
WORKDIR /home

FROM debian

USER root

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

#RUN keytool -import -noprompt -trustcacerts -storepass changeit -file /usr/local/share/ca-certificates/.../....crt -alias CA -keystore /opt/java/openjdk/lib/security/cacerts


# Use {COMPANY_NAME} UID to run the container
# This behaviour might be overrided with:
#     docker run -u $(id -u):$(id -g) ...
# or
#     docker run -u 0 ...
USER home

# Labels
LABEL base-java17.created=$DOCKERFILE_CREATED