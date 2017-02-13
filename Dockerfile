FROM pypy:2-slim

MAINTAINER Richard Mathie "Richard.Mathie@amey.co.uk"

RUN apt-get update \
    && apt-get install -y gcc python-dev \
    && apt-get install -y libev4 libev-dev \
    && pip install --no-cache-dir six futures lz4 twisted gevent eventlet cython pytz scales \
    && apt-get -y purge gcc python python-dev \
    && apt-get autoremove -y \
    && rm -rf ~/.cache
RUN  pip install --no-cache-dir cassandra-driver && rm -rf ~/.cache

COPY cassandradump.py /
WORKDIR /

ENV CASSANDRA=cassandra \
    KEYSPACE=keyspace \
    DUMP=dump.cql.gz

RUN mkfifo tempfile

CMD ["pypy cassandradump.py --host=$CASSANDRA  --keyspace $KEYSPACE --export-file tempfile & cat tempfile | gzip > $DUMP "]
