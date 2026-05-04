FROM nginx:alpine

# Generate a self-signed TLS certificate at build time.
# Replace with a real certificate for production use.
RUN apk add --no-cache openssl \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
         -keyout /etc/nginx/ssl/server.key \
         -out    /etc/nginx/ssl/server.crt \
         -subj   "/C=SE/ST=Stockholm/L=Stockholm/O=Local/CN=localhost" \
    # Restrict private key permissions
    && chmod 600 /etc/nginx/ssl/server.key \
    # Remove the openssl binary after use to reduce attack surface
    && apk del openssl \
    # Remove the default nginx vhost config
    && rm /etc/nginx/conf.d/default.conf

# Copy hardened nginx vhost configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443
