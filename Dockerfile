FROM ubuntu:14.04

RUN apt-get update -y && \
  apt-get install -y apt-transport-https curl git build-essential autoconf automake1.1 autotools-dev groff-base make libedit-dev libncurses-dev libpcre3-dev libtool pkg-config python-docutils libmhash-dev && \
  curl https://repo.varnish-cache.org/ubuntu/GPG-key.txt | apt-key add - && \
  echo "deb https://repo.varnish-cache.org/ubuntu/ precise varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list && \
  apt-get update -y && apt-get install -y varnish libvarnishapi-dev

RUN cd /tmp && \
  git clone https://github.com/varnish/libvmod-vsthrottle.git && \
  cd libvmod-vsthrottle && \
  git checkout 4.0 && \
  ./autogen.sh && \
  ./configure VARNISHSRC=/usr/include/varnish && \
  make && \
  make install

RUN cd /tmp && \
  git clone https://github.com/varnish/libvmod-digest.git && \
  cd libvmod-digest && \
  git checkout master && \
  ./autogen.sh && \
  ./configure VARNISHSRC=/usr/include/varnish && \
  make && \
  make install

RUN cd /tmp && \
  git clone https://github.com/varnish/libvmod-header.git && \
  cd libvmod-header && \
  git checkout master && \
  ./autogen.sh && \
  ./configure VARNISHSRC=/usr/include/varnish && \
  make && \
  make install

RUN cd /tmp && \
  apt-get install -y libhiredis-dev && \
  git clone https://github.com/carlosabalde/libvmod-redis.git && \
  cd libvmod-redis && \
  git checkout 4.0 && \
  ./autogen.sh && \
  ./configure VARNISHSRC=/usr/include/varnish && \
  make && \
  make install

ENV VARNISH_VCL    /etc/varnish/default.vcl
ENV VARNISH_CACHE  200m

ADD start.sh /start.sh

EXPOSE 80

CMD ["sh", "/start.sh"]
