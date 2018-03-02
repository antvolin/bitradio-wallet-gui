FROM debian:jessie

MAINTAINER antvolin@gmail.com

ARG USER_NAME
ARG BITRADIO_DATA
ENV WALLET_ROOT /bitradio-wallet/
ENV WALLET_WORK ${WALLET_ROOT}Bitradio/

WORKDIR $WALLET_ROOT

RUN printf 'path-exclude=/usr/share/locale/*\npath-exclude=/usr/share/doc/*\npath-include=/usr/share/locale/en/*' > /etc/dpkg/dpkg.cfg.d/purge && \
apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-swx11 \
    wget git \
    build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils \
    libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler && \
    git config --global http.sslVerify false && \
    git clone https://github.com/thebitradio/Bitradio && \
    wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    tar -xzvf db-4.8.30.NC.tar.gz && rm db-4.8.30.NC.tar.gz && \
    wget --no-check-certificate https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz && \
    tar -xzvf boost_1_64_0.tar.gz && rm boost_1_64_0.tar.gz && \
    mkdir -p ${WALLET_WORK}db4

WORKDIR ${WALLET_ROOT}boost_1_64_0/
RUN ./bootstrap.sh && ./bjam install && ln -s /usr/local/lib/libboost_system.so.1.64.0 /usr/lib/libboost_system.so.1.64.0 && ldconfig

WORKDIR ${WALLET_ROOT}db-4.8.30.NC/build_unix/
RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${WALLET_WORK}db4 && make install

WORKDIR ${WALLET_WORK}
RUN sed -i '/TEMPLATE = app/a BDB_INCLUDE_PATH = db4\/include\nBDB_LIB_PATH = db4\/lib' Bitradio.pro && qmake -qt=qt5 USE_UPNP=- && make && \
    cp ./Bitradio-qt /usr/local/bin

RUN adduser --disabled-password --gecos '' $USER_NAME
USER $USER_NAME
WORKDIR $BITRADIO_DATA

ENTRYPOINT ["Bitradio-qt"]
