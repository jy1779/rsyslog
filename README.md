# rsyslog
版本：rsyslog:8.26  
部署方式：docker  
docker版本：Docker version 18.03.1-ce, build 9ee9f40
docker-compose版本： docker-compose version 1.14.0, build c7bdf9e  
docker 安装：预留  
rsyslog 安装步骤：  
1.  获取rsyslog.git       
```
$ git clone https://github.com/jy1779/rsyslog.git
```
2.  启动rsyslog       
```
$ docker-compose up -d rsyslog
```
3.  查看容器启动状态，并且检查端口是否启动.  
```
$ docker-compose ps  
Name       Command     State   Ports  
-------------------------------------  
rsyslog   rsyslogd -n   Up
```
