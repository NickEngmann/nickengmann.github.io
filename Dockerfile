# .dockerignore
# *.md
# *.yml
# *.yaml
# .git
# .gitignore
# Dockerfile
# docker-compose.yml
# .dockerignore
# _site
# .jekyll-cache
# .bundle
# vendor/bundle

FROM ruby:3.3-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local path 'vendor/bundle' && \
    bundle install && \
    bundle clean

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]