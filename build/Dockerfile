# digest 認証可能な nginx をビルドする

# ビルドステージ
FROM ubuntu:20.04 as builder

# 環境変数（適宜設定変更してください。2021/10/17現在の 各ページの stable or latest を選択した）
## nginx: https://nginx.org/en/download.html
ARG NGINX_VER=1.20.1
## openssl: https://www.openssl.org/source/ (3.0 は nginx のソースコードで非対応)
ARG OPENSSL_VER=1.1.1l
## zlib: https://zlib.net/
ARG ZLIB_VER=1.2.11

WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y gcc libpcre3-dev make perl apache2-utils gzip wget unzip git

# nginx をビルドに必要な項目をダウンロード
## nginx
RUN wget -O - https://nginx.org/download/nginx-${NGINX_VER}.tar.gz | tar zxvf -
## nginx-http-auth-digest
RUN git clone https://github.com/samizdatco/nginx-http-auth-digest.git
## openssl
RUN wget -O - https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz | tar zxvf -
## zlib
RUN wget -O - https://zlib.net/zlib-${ZLIB_VER}.tar.gz | tar zxvf -

# nginx をビルド
WORKDIR /root/nginx-${NGINX_VER}
RUN ./configure \
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
    --with-openssl=../openssl-${OPENSSL_VER} \
    --with-zlib=../zlib-${ZLIB_VER} \
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
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \
    --add-module=../nginx-http-auth-digest/
RUN make && make install

# 軽い image にコピーする
FROM debian:stable-slim
LABEL maintainer "kamuiroeru<19339328+kamuiroeru@users.noreply.github.com>"

WORKDIR /
COPY --from=builder /etc/nginx /etc
COPY --from=builder /usr/sbin/nginx /usr/sbin

# nginx ユーザを作成
RUN useradd nginx
RUN usermod -s /bin/false nginx

# その他 nginx に必要なディレクトリを生成
RUN mkdir -p /var/cache/nginx
RUN mkdir -p /var/log/nginx
# ログ出力を stdout と stderr にする
RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log

EXPOSE 80
STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]