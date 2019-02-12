FROM ubuntu:16.04

# Install deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python-minimal \
        ruby-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*
RUN gem install --no-document fpm

# Set version
ARG VERSION=18.08.5-2

# Get source
WORKDIR /workdir
RUN wget -q -O slurm.tar.bz2 "https://download.schedmd.com/slurm/slurm-${VERSION}.tar.bz2"
WORKDIR /workdir/src
RUN tar xjf ../slurm.tar.bz2 --strip-components=1

# Build
RUN mkdir -p /workdir/build
RUN ./configure --prefix=/workdir/build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
RUN make "-j$(nproc)"
RUN make contrib "-j$(nproc)"
RUN make install "-j$(nproc)"

# Make package
WORKDIR /workdir
RUN fpm -s dir -t deb -v 1 -n "slurm-$VERSION" --prefix=/usr -C /workdir/build .

# Copy deb to /dist/
RUN mkdir -p /dist
RUN cp *.deb /dist/
