FROM ruby:2.7.0-alpine

RUN apk add --no-cache --update build-base \
    postgresql-dev \
    nodejs \
    yarn

RUN mkdir /rosstore
WORKDIR /rosstore
COPY Gemfile /rosstore/Gemfile
COPY Gemfile.lock /rosstore/Gemfile.lock

RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java
RUN bundle install

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
