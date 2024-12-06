FROM ubuntu:latest

RUN apt-get update && apt-get install -y nginx

# Copy the static website to the Nginx HTML directory
COPY index.html /var/www/html/

# Expose port 9090
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
