# rsyslog
版本：rsyslog:8.26  
部署方式：docker  
docker版本：Docker version 18.03.1-ce, build 9ee9f40   
docker-compose版本： docker-compose version 1.14.0, build c7bdf9e    
docker及docker-compose安装：[点我](https://github.com/jy1779/docker)    
## rsyslog 安装步骤   
1.  获取rsyslog.git       
```
$ git clone https://github.com/jy1779/rsyslog.git
```
2.  启动rsyslog       
```
$ cd ./rsyslog
$ docker-compose up -d rsyslog
```
3.  查看容器启动状态，并且检查端口是否启动.  
```
$ docker-compose ps  
Name       Command     State   Ports  
-------------------------------------  
rsyslog   rsyslogd -n   Up
$ netstat -nutlp|grep 514
udp        0      0 192.168.1.204:514       0.0.0.0:*                           1188/rsyslogd
```
* 注意：
    -  修改配置文件的监听IP地址:(address=xxxx)
    -  检查端口是否被占用
```
$ grep address rsyslog.conf 
input(type="imudp" address="192.168.1.204" port="514" ruleset="rs1")
```
## 小实验
### 将容器日传输至rsyslog  
1.  启动nginx容器
```
$ cat docker-compose.yml 
version: '2.0'
services:
  nginx.55:
    image: registry.cn-hangzhou.aliyuncs.com/jonny/nginx:1.9.14
    container_name: nginx.55
    logging:
      driver: syslog
      options:
        syslog-address: "udp://192.168.1.204:514"
        tag: "{{.Name}}"
$ docker-compose up -d nginx.55
Pulling nginx.55 (registry.cn-hangzhou.aliyuncs.com/jonny/nginx:1.9.14)...
1.9.14: Pulling from jonny/nginx
117f30b7ae3d: Pull complete
c75052209d7f: Pull complete
f10e0c8b732e: Pull complete
aa917ca9ba35: Pull complete
64891bc814b8: Pull complete
3a3c6152f546: Pull complete
a2146c97ae64: Pull complete
b5c5e91984cb: Pull complete
1fe31cbab3f7: Pull complete
a68d67278982: Pull complete
676c6bc07a10: Pull complete
69fd6da259db: Pull complete
Digest: sha256:f37a6cac13c25f8bd9abf283f6249aaa56b8e0d0a991bc3b8ba8ea960471dc93
Status: Downloaded newer image for registry.cn-hangzhou.aliyuncs.com/jonny/nginx:1.9.14
Creating nginx.55 ... 
Creating nginx.55 ... done

$ docker-compose ps
  Name           Command          State   Ports 
-----------------------------------------------
nginx.55   /usr/bin/supervisord   Up         
```
2.  查看rsyslog
```
$ ls logs/192.168.1.55/nginx.55.log 
logs/192.168.1.55/nginx.55.log
```
### 将docker日志传输至rsyslog
1. 配置docker文件,重启docker
```
$ cat /etc/docker/daemon.json
{
  "log-driver": "syslog"
  "log-opts": {
     "syslog-address": "udp://192.168.1.204:514",
     "tag": "{{.Name}}"
  }
}
$ service docker restart
```
2.  查看rsyslog  
```
$ ls logs/192.168.1.57/
k8s_ppw-nginx_ppw-nginx-74d88f94d7-z226c_kube-system_5e1298e3-90b2-11e8-a981-000c2962f342_0.log
```
