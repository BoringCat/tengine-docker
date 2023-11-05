# Tengine-docker
个人编译并docker化的tengine

## 0.官方简介
> **[简介 - The Tengine Web Server][1]**
> * Tengine是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。
> * 从2011年12月开始，Tengine成为一个开源项目，Tengine团队在积极地开发和维护着它。Tengine团队的核心成员来自于淘宝、搜狗等互联网企业。Tengine是社区合作的成果，我们欢迎大家参与其中，贡献自己的力量。
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
### Tengine 启用的模块
- 2.2.2 2.2.3
  - `ngx_http_geoip2_module`
  - 除了 modules 内的所有
- 2.3.0 2.3.1 2.3.2
  - `ngx_http_geoip2_module`
  - 除了
    - `ngx_google_perftools_module`
    - `ngx_http_lua_module`
    - `debug logging`
    - `modules/mod_config`
    - `modules/mod_dubbo`
    - `modules/ngx_backtrace_module`
    - `modules/ngx_debug_pool`
    - `modules/ngx_debug_timer`
    - `modules/ngx_http_lua_module`
    - `modules/ngx_http_upstream_keepalive_module`
    - `modules/ngx_http_tfs_module`
- 3.0.0
  - [`ngx_brotli`][2]
  - 除了
    - `google_perftools_module`
    - `compat`
    - `http_lua_module`
    - `http_perl_module`
    - `pcre`
    - `pcre-opt`
    - `pcre-jit`
    - `libatomic`
    - `jemalloc`
    - `debug`
    - `http_upstream_keepalive_module`
    - `modules/mod_config`
    - `modules/mod_dubbo`
    - `modules/ngx_backtrace_module`
    - `modules/ngx_debug_pool`
    - `modules/ngx_debug_timer`
    - `modules/ngx_http_lua_module`
    - `modules/ngx_http_tfs_module`
    - `modules/ngx_ingress`
    - `modules/ngx_http_xquic_module`
    - `modules/ngx_tongsuo_ntls`

### Volumes
|路径|用途|
|:-|:-|
| `/etc/tengine/conf/conf.d` |你的配置文件
| `/var/log/tengine` |默认日志目录|

#### 其他路径
|说明|路径|
|:-|:-|
| path prefix | `/usr/local/nginx` |
| binary file | `/usr/local/sbin/nginx` |
| modules path | `/etc/tengine/modules` |
| configuration prefix | `/etc/tengine/conf` |
| configuration file | `/etc/tengine/conf/nginx.conf` |
| pid file | `/var/log/tengine/nginx.pid` |
| error log file | `/var/log/tengine/error.log` |
| http access log file | `/usr/local/nginx/logs/access.log` |
| http client request body temporary files | `/var/cache/tengine/client_body_temp` |
| http proxy temporary files | `/var/cache/tengine/proxy_temp` |
| http fastcgi temporary files | `/var/cache/tengine/fastcgi_temp` |
| http uwsgi temporary files | `/var/cache/tengine/uwsgi_temp` |
| http scgi temporary files | `/var/cache/tengine/scgi_temp` |

### Ports
这........... 80(http)，443(https)

### 版本号（tag）
|`tag`|意义|
|:-:|:-|
|`alpine`|用alpine构建的最新版|
|`alpine-dynamic`|用alpine构建的最新版，但能加dynamic的都加了（其实很少）|
|`alpine-x.x.x`|用alpine构建的tengine的x.x.x版|
|`alpine-x.x.x-dynamic`|用alpine构建的tengine的x.x.x版，但能加dynamic的都加了（其实很少）|

latest? 我不想和Nginx的Tag混淆

## 2. 使用方法示例
### docker-cli
``` sh
docker run --name=tengine --restart=unless-stopped\
    -v /path/to/configs:/etc/tengine/conf/conf.d:ro \
    -v /path/to/save/logs:/var/log/tengine \
    -p 80:80 \
    -p 443:443 \
    -d boringcat/tengine:alpine
```

### docker-compose
``` yaml
version: '3'
services:
  tengine:
    image: boringcat/tengine:alpine
    restart: unless-stopped
    volumes:
      - /path/to/configs:/etc/tengine/conf/conf.d:ro
      - /path/to/save/logs:/var/log/tengine
    ports:
      - 80:80
      - 443:443

```

## 3. Build 方法示例
| build-arg | 用途 |
| :- | :- |
| `APK_MIRROR` | 更换 alpine 源 |
| `APK_MIRROR_HTTPS` | 使用 https 源<br/>其实可以弃用，现在默认都是https了 |
| `BUILD_THREADS` | 用多少个线程编译（默认：1） |
| `TENGINE_VERSION` | tengine的版本 |
| `BROTLI_VERISON` | brotli的版本（默认1.0.0rc） |
| `TONGSUO_VERISON` | [铜锁][3]的版本<br/>（如果不是用.xquic打包的话可以忽略，反正我没能让它跑起来） |
| `XQUIC_VERISON` | [xquic][4]的版本<br/>（如果不是用.xquic打包的话可以忽略，反正我没能让它跑起来） |

### 前提条件
``` sh
export TENGINE_VERSION=x.x.x BROTLI_VERISON=x.x.x TONGSUO_VERISON=x.x.x XQUIC_VERISON=x.x.x
mkdir sources/
wget https://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz -O sources/tengine-${TENGINE_VERSION}.tar.gz
wget https://github.com/google/ngx_brotli/archive/refs/tags/v${BROTLI_VERISON}.tar.gz -O sources/ngx_brotli-${BROTLI_VERISON}.tar.gz
wget https://github.com/Tongsuo-Project/Tongsuo/archive/refs/tags/${TONGSUO_VERISON}.tar.gz -O sources/Tongsuo-${TONGSUO_VERISON}.tar.gz
wget https://github.com/alibaba/xquic/archive/refs/tags/v${XQUIC_VERISON}.tar.gz -O sources/xquic-${XQUIC_VERISON}.tar.gz
```
PS: 为什么不在Dockerfile里面下载  
因为慢，每次改一个配置就要重新下载，特别是在改xquic的时候


### docker-cli
``` sh
docker build\
  --build-arg TENGINE_VERSION=$TENGINE_VERSION \
  --build-arg BUILD_THREADS=`nproc` \
  -t tengine:alpine -f Dockerfile.3.0 .
```
#### 对于国内用户
``` sh
docker build\
  --build-arg TENGINE_VERSION=$TENGINE_VERSION \
  --build-arg BUILD_THREADS=`nproc` \
  --build-arg APK_MIRROR=mirrors.sjtug.sjtu.edu.cn \
  --build-arg APK_MIRROR_HTTPS=1 \
  -t tengine:alpine -f Dockerfile.3.0 .
```

### docker-compose
``` yaml
version: '3'
services:
  tengine:
    build:
      context: tengine/docker
      args:
        - TENGINE_VERSION=3.0.0
        - BROTLI_VERISON=1.0.0rc

```
#### 对于国内用户
``` yaml
version: '3'
services:
  tengine:
    build:
      context: tengine/docker
      args:
        - APK_MIRROR=mirror.sjtu.edu.cn
        - TENGINE_VERSION=3.0.0
```

[1]: http://tengine.taobao.org/index_cn.html
[2]: https://github.com/google/ngx_brotli/tree/v1.0.0rc
[3]: https://github.com/Tongsuo-Project/Tongsuo
[4]: https://github.com/alibaba/xquic
