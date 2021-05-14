export DEBIAN_FRONTEND=noninteractive
sudo su

#IP FORWARDING
sysctl net.ipv4.ip_forward=1 #enables IP forwarding

#INTERFACE CONFIGURATION
#adds IP address to the interface
ip add add 192.168.6.1/23 dev enp0s8
#brings the interface up
ip link set enp0s8 up

#adds IP address to the interface
ip add add 192.168.128.66/30 dev enp0s9
#brings the interface up
ip link set enp0s9 up

#STATIC ROUTING
#deletes the dafault gateway
ip route del default
#creates a static route to reach subnet A via router-1
ip route add 192.168.3.0/24 via 192.168.128.65 dev enp0s9
#creates a static route to reach subnet B via router-1
ip route add 192.168.4.0/23 via 192.168.128.65 dev enp0s9