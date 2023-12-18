ARG TAG
ARG POSTGRES_VERSION=14
FROM scratch as nothing
ARG TARGETARCH
FROM tensorchord/pgvecto-rs-binary:${TAG}-${TARGETARCH} as binary

FROM bitnami/postgresql:$POSTGRES_VERSION
COPY --from=binary /pgvecto-rs-binary-release.deb /tmp/vectors.deb

USER 0

# TODO replace static path using env variables
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb
RUN mv /usr/share/postgresql/14/extension/vectors* /opt/bitnami/postgresql/share/extension/
RUN mv /usr/lib/postgresql/14/lib/vectors.so /opt/bitnami/postgresql/lib/vectors.so

USER 1001

CMD [ "/opt/bitnami/scripts/postgresql/run.sh","-c","shared_preload_libraries=vectors.so" ]