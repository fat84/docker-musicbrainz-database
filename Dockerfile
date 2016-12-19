FROM postgres:9.5

RUN mkdir -p /etc/apt

ADD sources.list /etc/apt/sources.list

RUN \
    apt-get update && \
    apt-get install -y --force-yes python python-psycopg2 && \
    rm -rf /var/lib/apt/lists/*

ADD mbslave /mbslave
ADD mbslave.conf.default /mbslave/mbslave.conf
ADD run.sh /mbslave/run.sh
