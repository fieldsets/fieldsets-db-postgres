ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION:-15}-bookworm

ENV DEBIAN_FRONTEND='noninteractive'
ARG POSTGRES_VERSION
ARG POSTGRES_DB
ARG FDW_PATH
ARG LOCAL_UID

ARG TIMEZONE
ENV TZ=${TIMEZONE:-America/New_York}

# If the certs directory exists, copy the certs and utilize them.
ARG BUILD_CONTEXT_PATH
COPY ${BUILD_CONTEXT_PATH}bin/root-certs.sh /root/.local/bin/root-certs.sh
COPY ${BUILD_CONTEXT_PATH}cert[s]/* /tmp/certs/

# Install packges
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        postgresql-server-dev-${POSTGRES_VERSION:-15} \
        postgresql-client-${POSTGRES_VERSION:-15} \
        postgresql-${POSTGRES_VERSION:-15}-cron \
        postgresql-plpython3-${POSTGRES_VERSION:-15} \
        curl \
        openssl \
        coreutils \
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
        dnsutils \
        openssh-client \
        net-tools \
        cmake \
        pkg-config \
        git \
        procps \
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
    bash /root/.local/bin/root-certs.sh /tmp/certs/ && \
    curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor | tee /usr/share/keyrings/fluentbit-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/debian/$(lsb_release -cs) $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/fluent-bit.list && \
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -P /tmp/ && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends \
        powershell \
        fluent-bit && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
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
    mkdir -p /var/lib/postgresql/fieldsets && \
    mkdir -p /var/lib/postgresql/filters && \
    mkdir -p /var/lib/postgresql/documents && \
    mkdir -p /var/lib/postgresql/records && \
    mkdir -p /var/lib/postgresql/lookups && \
    mkdir -p /var/lib/postgresql/sequences && \
    mkdir -p /var/lib/postgresql/streams && \
    chown postgres:postgres /var/lib/postgresql/data && \
    chown postgres:postgres /var/lib/postgresql/logs && \
    chown postgres:postgres /var/lib/postgresql/archive && \
    chown postgres:postgres /var/lib/postgresql/pipeline && \
    chown postgres:postgres /var/lib/postgresql/fieldsets && \
    chown postgres:postgres /var/lib/postgresql/filters && \
    chown postgres:postgres /var/lib/postgresql/documents && \
    chown postgres:postgres /var/lib/postgresql/records && \
    chown postgres:postgres /var/lib/postgresql/lookups && \
    chown postgres:postgres /var/lib/postgresql/sequences && \
    chown postgres:postgres /var/lib/postgresql/streams && \
    mkdir /data && \
    chown postgres:postgres /data

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
