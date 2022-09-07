# digest 認証可能な nginx をビルドする

# ビルドステージ
FROM ubuntu:22.04 as builder

# 環境変数（適宜設定変更してください。2021/10/17現在の 各ページの stable or latest を選択した）
## nginx: https://nginx.org/en/download.html
ARG NGINX_VER=1.23.1
## openssl: https://www.openssl.org/source/ (3.0 は nginx のソースコードで非対応)
ARG OPENSSL_VER=1.1.1q
## zlib: https://zlib.net/
ARG ZLIB_VER=1.2.12

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
RUN wget -O - https://zlib.net/fossils/zlib-${ZLIB_VER}.tar.gz | tar zxvf -

# nginx をビルド
WORKDIR /root/nginx-${NGINX_VER}
COPY ./nginx_configure.sh .
## アーキテクチャを分けて条件分岐
RUN ./nginx_configure.sh
RUN make -j 4 && make install

# ビルド物
FROM ubuntu:22.04
LABEL maintainer "kamuiroeru<19339328+kamuiroeru@users.noreply.github.com>"

WORKDIR /
COPY --from=builder /etc/nginx /etc/nginx
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