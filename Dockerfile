ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION:-15}

ENV DEBIAN_FRONTEND='noninteractive'
ARG POSTGRES_VERSION
ARG POSTGRES_DB
ARG FDW_PATH
ARG LOCAL_UID

ARG TIMEZONE
ENV TZ=${TIMEZONE:-America/New_York}

# Install packges
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        postgresql-server-dev-${POSTGRES_VERSION:-15} \
        postgresql-client-${POSTGRES_VERSION:-15} \
        postgresql-${POSTGRES_VERSION:-15}-cron \
        curl \
        libcurl4 \
        libcurl4-openssl-dev \
        uuid-dev \
        build-essential \
        gnupg \
        apt-transport-https \
        ca-certificates \
        dirmngr \
        debconf-utils \
        lsb-release \
        wget \
        build-essential \
        cmake \
        pkg-config \
        git \
        unzip \
        zip \
        jq \
        python3 \
        python3-dev \
        python3-pip \
        python3-pycurl \
        nasm \
        yasm \
        less \
        libisal2 \
        libisal-dev \
        libdeflate0 \
        libdeflate-dev \
        libdeflate-tools \
        autoconf \
        automake \
        groff \
        libpq5 \
        libpq-dev \
        zlib1g \
        zlib1g-dev \
        libevent-pthreads-* \
        libssl-dev \
        libzstd-dev && \
    curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor | tee /usr/share/keyrings/fluentbit-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/debian/$(lsb_release -cs) $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/fluent-bit.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        fluent-bit && \
    apt-get clean && \
    ln -s /opt/fluent-bit/bin/fluent-bit /usr/local/bin/fluent-bit && \
    cd ${FDW_PATH:-/usr/src} && \
    git clone https://github.com/adjust/clickhouse_fdw.git && \
    cd clickhouse_fdw && \
    mkdir build && cd build && \
    cmake .. && \
    make && make install && \
    usermod -u ${LOCAL_UID:-1000} postgres && \
    mkdir -p /var/lib/postgresql/archive && \
    mkdir -p /var/lib/postgresql/pipeline && \
    mkdir -p /var/lib/postgresql/data && \
    mkdir -p /var/lib/postgresql/logs && \
    chown postgres:postgres /var/lib/postgresql/data && \
    chown postgres:postgres /var/lib/postgresql/logs && \
    chown postgres:postgres /var/lib/postgresql/archive && \
    chown postgres:postgres /var/lib/postgresql/pipeline && \
    mkdir /data && \
    mkdir /fieldsets-lib && \
    mkdir /fieldsets-bin && \
    mkdir /fieldsets-sql && \
    chown postgres:postgres /data && \
    chown postgres:postgres /fieldsets-lib && \
    chown postgres:postgres /fieldsets-bin && \
    chown postgres:postgres /fieldsets-sql

# Clickhouse ports
EXPOSE 9000
EXPOSE 9009

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
