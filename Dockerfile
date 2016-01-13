FROM openshift/base-centos7

MAINTAINER Tobias Florek <tob@butter.sh>

ENV NGINX_VERSION 1.8

LABEL io.k8s.description="Platform for serving nginx-based applications (static files)" \
      io.k8s.display-name="nginx builder ${NGINX_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nginx,webserver"


RUN yum install --setopt=tsflags=nodocs -y centos-release-scl-rh \
 && yum install --setopt=tsflags=nodocs -y rh-nginx${NGINX_VERSION/\./} \
 && yum clean all -y \
 && mkdir -p /opt/app-root/etc/nginx.conf.d /opt/app-root/run \
 && chmod -R a+rx  /var/opt/rh/rh-nginx${NGINX_VERSION/./}/lib/nginx \
 && chmod -R a+rwX /var/opt/rh/rh-nginx${NGINX_VERSION/./}/lib/nginx/tmp \
                   /var/opt/rh/rh-nginx${NGINX_VERSION/./}/log \
                   /var/opt/rh/rh-nginx${NGINX_VERSION/./}/run \
                   /opt/app-root/run

COPY ./etc/ /opt/app-root/etc
COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

RUN cp /opt/app-root/etc/nginx.sample.conf /opt/app-root/etc/nginx.conf.d/default.conf \
 && chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
