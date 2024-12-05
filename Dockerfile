FROM ubuntu:latest

RUN apt-get update && apt-get install -y nginx

# Copy the static website files to the Nginx HTML directory
COPY index.html /var/www/html/

# Expose port 9090
EXPOSE 9090

CMD ["nginx", "-g", "daemon off;"]
