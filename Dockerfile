FROM ricmathie/python_cassandra:pypy_2

MAINTAINER Richard Mathie "Richard.Mathie@amey.co.uk"

COPY cassandradump.py /
WORKDIR /

ENV CASSANDRA=cassandra \
    KEYSPACE=keyspace \
    DUMP=dump.cql.gz

RUN mkfifo tempfile

CMD ["bash", "-c", "sleep 2; /usr/local/bin/pypy cassandradump.py --hosts $(getent hosts $CASSANDRA | awk '{print $1}')  --keyspace $KEYSPACE --export-file tempfile & cat tempfile | gzip > $DUMP"]
