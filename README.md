# docker-nextcloud

`sudo docker rm -f nextcloud ; sudo docker run -d  -p 8800:80 --network my-bridge -v nextcloud_config:/var/www/localhost/htdocs/nextcloud/config/ -v nextcloud_data:/var/www/localhost/htdocs/nextcloud/data/ --name nextcloud mynextcloud`
