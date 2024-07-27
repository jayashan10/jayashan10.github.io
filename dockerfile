FROM jekyll/jekyll

# Install entr using apk
RUN apk add --no-cache entr

WORKDIR /srv/jekyll

COPY . .

RUN gem install webrick && bundle install

CMD find . -type f | entr -r -n bundle exec jekyll serve --host 0.0.0.0 --incremental --force_polling
