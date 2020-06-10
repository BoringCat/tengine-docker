# Tengine-docker
个人编译并docker化的tengine

## 0.官方简介
**[简介 - The Tengine Web Server][1]**
* Tengine是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。
* 从2011年12月开始，Tengine成为一个开源项目，Tengine团队在积极地开发和维护着它。Tengine团队的核心成员来自于淘宝、搜狗等互联网企业。Tengine是社区合作的成果，我们欢迎大家参与其中，贡献自己的力量。
### 示例配置文件
<details>
 <summary>example.conf</summary>
 <pre>
 server {
    listen       80;
    server_name  localhost;
    #charset koi8-r;
    #access_log  logs/host.access.log  main;
    #access_log  "pipe:rollback logs/host.access_log interval=1d baknum=7 maxsize=2G"  main;
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
    # pass the Dubbo rpc to Dubbo provider server listening on 127.0.0.1:20880
    #
    #location /dubbo {
    #    dubbo_pass_all_headers on;
    #    dubbo_pass_set args $args;
    #    dubbo_pass_set uri $uri;
    #    dubbo_pass_set method $request_method;
    #
    #    dubbo_pass org.apache.dubbo.samples.tengine.DemoService 0.0.0 tengineDubbo dubbo_backend;
    #}
    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
# upstream for Dubbo rpc to Dubbo provider server listening on 127.0.0.1:20880
#
#upstream dubbo_backend {
#    multi 1;
#    server 127.0.0.1:20880;
#}
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
#    listen       443 ssl;
#    server_name  localhost;
#    ssl_certificate      cert.pem;
#    ssl_certificate_key  cert.key;
#    ssl_session_cache    shared:SSL:1m;
#    ssl_session_timeout  5m;
#    ssl_ciphers  HIGH:!aNULL:!MD5;
#    ssl_prefer_server_ciphers  on;
#    location / {
#        root   html;
#        index  index.html index.htm;
#    }
#}</pre>
</details>

## 1. 各种说明
### Volumes
|路径|用途|
|:-:|:-:|
|/tengine/conf.d|你的配置文件
|/tengine/logs|默认日志目录|

### Ports
这........... 80(http)，443(https)

### 版本号（tag）
|tag|意义|
|:-:|:-|
|alpine|用alpine构建的最新版|
|alpine-x.x.x|用alpine构建的tengine的x.x.x版|

latest? 我不想和Nginx的Tag混淆

## 2. 使用方法示例
### docker-cli
``` sh
docker run --name=tengine --restart=unless-stopped\
    -v /path/to/configs:/tengine/conf.d:ro \
    -v /path/to/save/logs:/tengine/logs \
    -p 80:80 \
    -p 443:443 \
    -d boringcat/tengine:alpine
```

### docker-compose
``` yaml
version: '2'
services:
  tengine:
    image: boringcat/tengine:alpine
    restart: unless-stopped
    volumes:
      - /path/to/configs:/tengine/conf.d:ro
      - /path/to/save/logs:/tengine/logs
    ports:
      - 80:80
      - 443:443

```


[1]: http://tengine.taobao.org/index_cn.html