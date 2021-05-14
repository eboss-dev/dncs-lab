export DEBIAN_FRONTEND=noninteractive
# Startup commands go here

sudo su

#DOWNLOAD AND INSTALL DOCKER
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

#RUN DOCKER IMAGE dustnic82/nginx-test
docker system prune -a # clean up any docker resources
docker run --name DNCSWebserver -p 80:80 -d dustnic82/nginx-test


#INTERFACE CONFIGURATION
#set up IP address to the interface
ip add add 192.168.6.254/23 dev enp0s8
#brings the interface up
ip link set enp0s8 up

#STATIC ROUTING
#creates a static route to reach subnet A via router-2
ip route add 192.168.3.0/24 via 192.168.6.1
#creates a static route to reach subnet B via router-2
ip route add 192.168.4.0/23 via 192.168.6.1