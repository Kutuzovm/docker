#!/bin/bash
docker run --rm -v `pwd`:/var/www/srv -p 1080:1080 -p 80:80 -p 3306:3306 -i -t rhamdeew/ubuntu_lamp:7 /bin/bash
