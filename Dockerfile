	
FROM	python:3-alpine	as	builder
LABEL   org.opencontainers.image.source="Toni Tauro <eye@eyenx.ch>"	
RUN	apk add --no-cache \
	--update \
	gcc \
    cargo \
	musl-dev \
	libffi-dev \
	openssl-dev \
	&& mkdir /app \
	&& cd /tmp \
	&& wget https://github.com/github/octodns/archive/master.zip \
	&& cd /app \
	&& unzip /tmp/master.zip \
	&& pip install virtualenv \
	&& virtualenv /app \
	&& source /app/bin/activate \
	&& cd octodns-master \
	&& pip install -r requirements.txt \
	&& python setup.py install \
	&& cd /app \
	&& rm -rf octodns-master
FROM	python:3-alpine
LABEL	maintainer="eye@eyenx.ch"
RUN	apk add --no-cache \
	ca-certificates
WORKDIR	/app/
COPY --from=builder	/app	.
ENV	PATH	/app/bin:$PATH
CMD	["octodns-sync"]
