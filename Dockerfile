#------------------------------------------------#
# Builder stage
#------------------------------------------------#
FROM jekyll/jekyll:latest as builder
WORKDIR /app

# Copy in the Gemfile so we can install bundles separately from generating the site
COPY Gemfile .

# Correct permissions and install the ruby gems we need
RUN chmod 777 /app && \
    bundle install

# Copy in the rest of the project so we can do a jekyll build
COPY . .

# Copy mermaid into the js assets location
RUN jekyll build

#------------------------------------------------#
# Production stage
#------------------------------------------------#
FROM nginx:latest

# Remove any nginx default content so only our stuff is there
RUN rm -rf /usr/share/nginx/html/*

# Copy in the static content from the jekyll build
COPY --from=builder /app/_site /usr/share/nginx/html
