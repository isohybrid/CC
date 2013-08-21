#!/bin/bash

sudo su

#reliable packages
yes | apt-get install libssl-dev libpcre3 libpcre3-dev

myPath="/usr/development"
if [ ! -d "${myPath}" ];then
  mkdir -p "${myPath}"
fi
cd $myPath
chmod a+rwx "$myPath"

wget -c http://nginx.org/download/nginx-1.4.1.tar.gz && \
if [ -f nginx-1.4.1.tar.gz ]; then
  tar zxvf nginx-1.4.1.tar.gz && sleep 5
  if [ -d nginx-1.4.1 ]; then
    mv nginx-.1.4.1 nginx_source
  else
    echo "nginx tar failed!!!"
    exit 1
  fi
fi

cd "${myPath}/nginx_source" || echo "no nginx_source dir exist"

./configure --prefix=/usr/development/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module
make && make install

cat >> /etc/profile << EOF
export PATH=$PATH:/usr/development/nginx/sbin
EOF
source /etc/profile

#http://wiki.nginx.org/HttpSslModule
#http://nginx.org/en/docs/http/configuring_https_servers.html#certificate_with_several_names
cd /usr/development/nginx/conf

#Now create the server private key, you'll be asked for a passphrase:
openssl genrsa -des3 -out server.key 1024 && \
#Create the Certificate Signing Request (CSR):
openssl req -new -key server.key -out server.csr && \
#Remove the necessity of entering a passphrase for starting up nginx with SSL using the above private key:
cp server.key server.key.org && \
openssl rsa -in server.key.org -out server.key && \
#Finally sign the certificate using the above private key and CSR:
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt || \
  echo "certificate failed"

cat > nginx.conf << EOF

#user  nobody;
worker_processes  4;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443;
    #    server_name  localhost;

    #    ssl                  on;
    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_timeout  5m;

    #    ssl_protocols  SSLv2 SSLv3 TLSv1;
    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers   on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

    server {
        listen       443;
        server_name  localserverhost;

        ssl                  on;
        ssl_certificate      server.crt;  #cert.pem
        ssl_certificate_key  server.key;  #cert.key

        ssl_session_timeout  5m;

        ssl_protocols  SSLv2 SSLv3 TLSv1;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers   on;

        location / {
            root   html;
            index  index.html index.htm;
        }
        #keepalive_timeout 70;
    }
}
EOF

nginx && echo "nginx start success"
