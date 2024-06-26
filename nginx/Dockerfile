FROM nginx

RUN apt-get update -qq && apt-get -y install apache2-utils

ENV APP_ROOT /app

WORKDIR $APP_ROOT

RUN mkdir log

COPY ./default.conf /tmp/docker.nginx
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN envsubst '$APP_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
