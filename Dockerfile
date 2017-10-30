FROM ruby:2.4-alpine3.6
RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.6/main/" > /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/community/" >> /etc/apk/repositories
WORKDIR /usr/src/app
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
COPY Gemfile* /usr/src/app/
RUN apk add --no-cache libpq
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    apk add --no-cache --virtual .build_deps autoconf automake build-base postgresql-dev && \
    bundle install && \
    apk --no-cache del .build_deps && \
    find / -type f -iname \*.apk-new -delete && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/lib/ruby/gems/*/cache/* && \
    rm -rf ~/.gem
COPY . /usr/src/app/
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]
