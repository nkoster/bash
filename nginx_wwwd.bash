#!/bin/bash

SRC_DIRECTORY=/slot/home/w3b/src
cd $SRC_DIRECTORY

LATEST_OPENSSL_TAR_GZ=$(curl -s ftp://ftp.openssl.org/source/ | \
  grep 'tar\.gz$' | \
  egrep -v 'beta|fips|pre' | \
  tail -1 | awk '{print $9}')

LATEST_OPENSSL_VERSION=$(echo "${LATEST_OPENSSL_TAR_GZ}" | \
  sed 's/^.*openssl-//' | \
  sed 's/.tar.gz//')

LATEST_PCRE_TAR_GZ=$(curl -s ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/ | \
  awk '{print $9}' | \
  grep 'tar.gz$' | \
  tail -1)

LATEST_PCRE_VERSION=$(echo "${LATEST_PCRE_TAR_GZ}" | \
  sed 's/^.*pcre-//' | \
  sed 's/.tar.gz//')

LATEST_ZLIB12_VERSION=$(curl -sL http://sourceforge.net/projects/libpng/files/zlib/ | \
  grep 'Click to enter ' | \
  sort -u | \
  tail -1 | \
  awk '{print $4}'|sed 's/"//')

LATEST_ZLIB12_TAR_GZ="zlib-${LATEST_ZLIB12_VERSION}.tar.gz"

LATEST_NGINX_MAJOR=0
LATEST_NGINX_MINOR=0
LATEST_NGINX_PATCH=0
LATEST_NGINX_VERSION=0.0.0

while read VERSION
do
  NGINX_MAJOR=$(echo $VERSION | awk -F '.' '{print $1}')
  NGINX_MINOR=$(echo $VERSION | awk -F '.' '{print $2}')
  NGINX_PATCH=$(echo $VERSION | awk -F '.' '{print $3}')
  V=$(expr "($NGINX_MAJOR * 100) + ($NGINX_MINOR * 10) + $NGINX_PATCH")

  LATEST_NGINX_MAJOR=$(echo $LATEST_NGINX_VERSION | awk -F '.' '{print $1}')
  LATEST_NGINX_MINOR=$(echo $LATEST_NGINX_VERSION | awk -F '.' '{print $2}')
  LATEST_NGINX_PATCH=$(echo $LATEST_NGINX_VERSION | awk -F '.' '{print $3}')
  LV=$(expr "($LATEST_NGINX_MAJOR * 100) + ($LATEST_NGINX_MINOR * 10) + $LATEST_NGINX_PATCH")

  if (( $V > $LV ))
  then
    LATEST_NGINX_VERSION=$VERSION
  fi

done < <(curl -s http://nginx.org/download/ | \
sort -u | \
grep 'nginx-' | \
awk -F '"' '{print $2}' | \
egrep -v 'asc$|zip$' | \
sed 's/^nginx-//' | \
sed 's/\.tar\.gz$//')

LATEST_NGINX_TAR_GZ="nginx-${LATEST_NGINX_VERSION}.tar.gz"

echo
echo "Latest openssl: ${LATEST_OPENSSL_TAR_GZ} ${LATEST_OPENSSL_VERSION}"
echo "Latest pcre: ${LATEST_PCRE_TAR_GZ} ${LATEST_PCRE_VERSION}"
echo "Latest zlib: ${LATEST_ZLIB12_TAR_GZ} ${LATEST_ZLIB12_VERSION}"
echo "Latest nginx: ${LATEST_NGINX_TAR_GZ} ${LATEST_NGINX_VERSION}"
echo

[ -f ${LATEST_OPENSSL_TAR_GZ} ] && rm -f ${LATEST_OPENSSL_TAR_GZ}
[ -f ${LATEST_PCRE_TAR_GZ} ] && rm -f ${LATEST_PCRE_TAR_GZ}
[ -f ${LATEST_ZLIB12_TAR_GZ} ] && rm -f ${LATEST_ZLIB12_TAR_GZ}
[ -f ${LATEST_NGINX_TAR_GZ} ] && rm -f ${LATEST_NGINX_TAR_GZ}

echo "Fetching ${LATEST_OPENSSL_TAR_GZ}..."
wget -q ftp://ftp.openssl.org/source/${LATEST_OPENSSL_TAR_GZ}
tar xzf ${LATEST_OPENSSL_TAR_GZ} || (echo error ; exit)

echo "Fetching ${LATEST_PCRE_TAR_GZ}..."
wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${LATEST_PCRE_TAR_GZ}
tar xzf ${LATEST_PCRE_TAR_GZ} || (echo error ; exit)

echo "Fetching ${LATEST_ZLIB12_TAR_GZ}..."
wget -q http://zlib.net/${LATEST_ZLIB12_TAR_GZ}
tar xzf ${LATEST_ZLIB12_TAR_GZ} || (echo error ; exit)

echo "Fetching ${LATEST_NGINX_TAR_GZ}..."
wget -q http://nginx.org/download/${LATEST_NGINX_TAR_GZ}
tar xzf ${LATEST_NGINX_TAR_GZ} || (echo error ; exit)

echo

echo "Replace server string..."
LINE_1=$(grep -n 'static char ngx_http_server_string' ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_header_filter_module.c | \
  awk -F ':' '{print $1}')
LINE_2=$(grep -n 'static char ngx_http_server_full_string' ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_header_filter_module.c | \
  awk -F ':' '{print $1}')
sed -i "${LINE_1}s/Server: nginx/Server: wwwd/" ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_header_filter_module.c
sed -i "${LINE_2}s/Server: \" NGINX_VER/Server: wwwd\"/" ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_header_filter_module.c
sed -i 's/nginx\//wwwd\//' ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/core/nginx.h
echo

echo "Remove server string from special response..."
LN=$(cat ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_special_response.c | \
  grep -n '<hr><center>' | \
  awk -F ':' '{print $1}' | \
  head -1)
while [ "$LN" != "" ]
do
  echo $LN
  sed -i -e ${LN}d ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_special_response.c
  LN=$(cat ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_special_response.c | \
    grep -n '<hr><center>' | \
    awk -F ':' '{print $1}' | \
    head -1)
done
echo

echo "Change body color..."
perl -pe 's/"<body bgcolor=\\"white\\">" CRLF/"<body bgcolor=\\"#f0f0f0\\">" CRLF/g' -i ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_special_response.c
echo

echo "Add DOCTYPE to html..."
perl -pe 's/"<html>" CRLF/"<!DOCTYPE HTML>" CRLF\n"<html>" CRLF/g' -i ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}/src/http/ngx_http_special_response.c
echo

echo "Building nginx..."

cd ${SRC_DIRECTORY}/nginx-${LATEST_NGINX_VERSION}

[ -f ${HOME}/nginx_bin ] && rm ${HOME}/nginx_bin

make clean
./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-openssl=${SRC_DIRECTORY}/openssl-${LATEST_OPENSSL_VERSION} \
--with-pcre=${SRC_DIRECTORY}/pcre-${LATEST_PCRE_VERSION} \
--with-zlib=${SRC_DIRECTORY}/zlib-${LATEST_ZLIB12_VERSION} \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
&& make && \
  sudo service nginx stop && \
  sudo make install && \
  sudo service nginx start && \
  echo 'NGINX INSTALLED!'
