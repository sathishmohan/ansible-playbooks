FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y ssh sudo supervisor software-properties-common

RUN add-apt-repository -y ppa:openjdk-r/ppa; \
        apt-get -qq -y update; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk; \
        update-java-alternatives -s java-1.8.0-openjdk-amd64; \
        java -version

# SSH configuration
RUN mkdir /var/run/sshd
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

# Default container command
CMD ["/usr/bin/supervisord"]
#
#start container
#docker run -d -p 6001:22 -t sat:1.0
#
