FROM ruby:2.7.0-alpine

RUN apk add --no-cache --update build-base bash \
    postgresql-dev \
    nodejs \
    yarn \
    tzdata \
    imagemagick

RUN mkdir /rosstore
WORKDIR /rosstore

COPY Gemfile /rosstore/Gemfile
COPY Gemfile.lock /rosstore/Gemfile.lock

RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java
RUN bundle install

COPY package.json /rosstore/package.json
COPY yarn.lock /rosstore/yarn.lock

RUN yarn install --check-files

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["sh", "/usr/bin/entrypoint.sh"]
