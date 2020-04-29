HA-PHP-DOCKER
=

This is a PHP friendly docker. You can create and configure any PHP stack project and as much as you want with only one build.

Ubuntu  
Nginx  
Php-fpm7.4  
MySQL 8.0  
PostgreSQL 12  
Elasticsearch 7.6.2  
Kibana 7.6.2  
Logstash 7.6.2  
Phpmyadmin  
Phppgadmin  
Adminer  
Xdebug  
GIT  
nano  
Composer  
Symfony installer

How to run project:
=
1- Create you `data/project_folder`.  
2- Add `domain.conf` file under `docker/nginx/` folder.   
3- Don't forget to add `server_name www.your-domain.xyz;` into your `domain.conf` file.     
4- Add the `domain.conf` file path into docker-compose.yml under `webserver -> volumes`  
5- Add your `www.your-domain.xyz` into you host file `127.0.0.1 www.your-domain.xyz`  
6- Rebuild your docker: under main folder `ha-php-docker` run `make docker-start`  
7- Under your web browser go to `www.your-domain.xyz` and enjoy! :)  
8- To view container into web browser user `www.your-domain.xyz:[container_port]`  

This docker is comming with Symfony 3 / 4 / 5 projects folder examples.  
To work with this examples add into your host file  
`127.0.0.1 dev.sf3.local dev.sf4.local dev.sf5.local` 

Good job !

Some usefull commands
================
Command:

To have make help
```console
make
```

Make possible commands:
```console
docker-start                  #docker-compose up --build without -d mode
docker-start-d                #docker-compose up -d --build with -d mode
docker-back-user              #Access the web container as www-data
docker-back-root              #Access the web container as root
docker-composer-install       #Composer install
elasticsearch-cluster-fix     #Add memory to Elasticsearch cluster and reset the read-only index
```

To fix cluster_block_exception [FORBIDDEN/12/index read-only / allow delete (api)]
```console
make elasticsearch-cluster-fix
```

Configure XDEBUG
=
1- Get your local IP address with ifconfig or ipconfig command.  
2- Add `[local IP] ha.docker-ip.for.xdebug.internal` into you host file.  
3- PHPSTORM -> preferences -> Languages & Frameworks -> PHP -> Debug set Debug port 9001.  
4- PHPSTORM -> preferences -> Languages & Frameworks -> PHP -> Server:
   - Name: `HA-SERVER`
   - Host: `www.your-domain.xyz`
   - Port: `80`
   - Debugger: `Xdebug`
   - Check `Use path mappings`
       * Set `/var/www` path in front of `data` folder.  
       * Set `/var/www/you_project_name` path in front of every `data` subfolder.  
 
 
 ENJOY !!!
 =