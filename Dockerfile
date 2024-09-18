# Use an official Ubuntu base image
FROM ubuntu:focal

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common gnupg && \
    wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add - && \
    add-apt-repository "deb http://download.webmin.com/download/repository sarge contrib" && \
    apt-get update && \
    apt-get install -y webmin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the Webmin port
EXPOSE 10000

# Command to run Webmin
CMD ["/usr/share/webmin/miniserv.pl", "/etc/webmin/miniserv.conf"]
