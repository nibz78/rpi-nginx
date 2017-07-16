FROM resin/rpi-raspbian

RUN apt-get update && apt-get install -y nginx-full

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./etc/letsencrypt/live/nibz.fr/fullchain.pem /etc/letsencrypt/live/nibz.fr/fullchain.pem 
COPY ./etc/letsencrypt/live/nibz.fr/privkey.pem  /etc/letsencrypt/live/nibz.fr/privkey.pem

COPY ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/nginx/proxy.conf /etc/nginx/proxy.conf
COPY ./etc/nginx/sites-available/main /etc/nginx/sites-available/main

RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -sf /etc/nginx/sites-available/main /etc/nginx/sites-enabled/main

#VOLUME ["/usr/share/nginx/www"]
#VOLUME ["/etc/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

