FROM alpine:latest AS builder

ARG APK_MIRROR
WORKDIR /tmp

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN set -xe\
 && [ ! -z ${APK_MIRROR} ] \
 && sed -i "s/dl-cdn.alpinelinux.org/${APK_MIRROR}/g" /etc/apk/repositories ;\
 apk add --no-cache --virtual .build-deps \
    gcc libc-dev make openssl-dev pcre-dev \
    zlib-dev linux-headers libxslt-dev gd-dev \
    geoip-dev perl-dev libedit-dev mercurial \
    gnupg bash alpine-sdk findutils \
    # For add ngx_http_geoip2_module
    libmaxminddb-dev

ARG GEOIP2_VERSION=3.3
ARG TENGINE_VERSION=2.3.2

# Download sources
RUN set -xe\
 && wget "https://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz" -O tengine.tar.gz\
 && wget "https://github.com/leev/ngx_http_geoip2_module/archive/${GEOIP2_VERSION}.tar.gz" -O geoip2.tar.gz

ARG MULTITHREAD_BUILD=0

# Reuse same cli arguments as the nginx:alpine image used to build
RUN set -xe\
 && [ ${MULTITHREAD_BUILD} -eq 1 ]\
 && PROCESS_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)\
 && MAKEARG="-j${PROCESS_NUM:-1}";\
    mkdir -p /usr/src | true\
 && tar -zxC /usr/src -f tengine.tar.gz\
 && tar -xzvf "geoip2.tar.gz"\
 && GEOIP2DIR="$(pwd)/ngx_http_geoip2_module-${GEOIP2_VERSION}"\
 && ADD_MODULES="--add-module=${GEOIP2DIR}"\
 && WITH_MODULES="--with-http_v2_module --with-http_ssl_module"\
 && cd /usr/src/tengine-${TENGINE_VERSION}\
 && [ -d "modules/ngx_http_reqstat_module" ]\
 && ADD_MODULES="$ADD_MODULES --add-module=modules/ngx_http_reqstat_module";\
    ./configure --prefix="/tengine" --user=tengine --group=tengine \
    ${WITH_MODULES} ${ADD_MODULES}\
 && make ${MAKEARG} && make install 

FROM alpine:latest
ENV PATH=$PATH:/tengine/sbin
COPY --from=builder /tengine /tengine
WORKDIR /tengine
ARG APK_MIRROR
RUN set -xe\
 && [ ! -z ${APK_MIRROR} ] \
 && sed -i "s/dl-cdn.alpinelinux.org/${APK_MIRROR}/g" /etc/apk/repositories ;\
    apk add --update --no-cache libmaxminddb pcre\
 && addgroup tengine\
 && adduser -s /sbin/nologin -G tengine -D -H tengine\
 # Create custom environment for tengine
 && mkdir -p /tengine/conf\
 && sed -e '/\s*server {$/,/^}$/!d' /tengine/conf/nginx.conf > /tengine/conf/example.conf\
 && sed -e '/\s*server {$/,/^}$/d' -i /tengine/conf/nginx.conf\
 && echo "    include /tengine/conf.d/*.conf;" >> /tengine/conf/nginx.conf\
 && echo "}" >> /tengine/conf/nginx.conf\
 && sed -e 's/^}$//g;s/^    //g;/^$/d' -i /tengine/conf/example.conf
STOPSIGNAL SIGTERM
VOLUME [ "/tengine/conf.d", "/tengine/logs" ]
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]