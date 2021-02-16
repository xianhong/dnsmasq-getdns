FROM alpine AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories


RUN apk update && apk add git g++ openssl-dev yaml-dev check-dev make cmake autoconf automake
RUN git clone https://github.com/getdnsapi/getdns.git && \
    cd getdns && git checkout master && git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake \
        -DBUILD_STUBBY=ON \
        -DENABLE_STUB_ONLY=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DOPENSSL_INCLUDE_DIR=/usr/include/openssl \
        -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so \
        -DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.so \
        -DUSE_LIBIDN2=OFF \
        -DBUILD_LIBEV=OFF \
        -DBUILD_LIBEVENT2=OFF \
        -DCHECK_INCLUDE_DIR=/usr/include \
        -DCHECK_LIBRARY=/usr/lib/libcheck.so \
        -DBUILD_LIBUV=OFF .. && \
    cmake .. && \
    make && \
    make install
# Build runtime container

FROM alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache check openssl yaml dnsmasq libsodium ldns

COPY --from=builder /usr/local/lib/libgetdns.so.10 /usr/local/lib/
COPY --from=builder /usr/local/bin/stubby /usr/local/bin/

#EXPOSE 8053/udp
COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh
CMD ["/etc/entrypoint.sh"]

