FROM pypy:2

MAINTAINER Richard Mathie "Richard.Mathie@amey.co.uk"

RUN pip install six futures lz4 twisted gevent eventlet cython pytz scales
RUN pip install cassandra-driver

COPY cassandradump.py /
WORKDIR /

ENV CASSANDRA=cassandra
ENV KEYSPACE=keyspace
ENV DUMP=dump.cql.gz

RUN mkfifo tempfile

CMD ["python cassandradump.py --host=$CASSANDRA  --keyspace $KEYSPACE --export-file tempfile & cat tempfile | gzip > $DUMP "]
