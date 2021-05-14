# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 248 and 436 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 315 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
The network is arranged as following

        +----------------------------------------------------------------------+
        |                                                                      |
        |                                                                      |enp0s3
        +--+--+                  +------------+                          +------------+
        |     |                  |            |                          |            |
        |     |            enp0s3|            |enp0s9              enp0s9|            |
        |     +------------------+  router-1  +--------------------------+  router-2  |
        |     |                  |            |.65                    .66|            |
        |     |                  |            |      192.168.128.64/30   |            |
        |  M  |                  +------------+                          +------------+
        |  A  |          192.168.3.1/24 |enp0s8.10                      enp0s8 |.1
        |  N  |          192.168.4.1/23 |enp0s8.20                             |
        |  A  |                         |                                      |     
        |  G  |                         |                                      |
        |  E  |                         |                      192.168.6.0/23  |
        |  M  |                         |                                      |
        |  E  |                         |enp0s8                         enp0s8 |.254
        |  N  |            +--------------------------+                  +-----+----+
        |  T  |     enp0s3 |          TRUNK           |                  |          |
        |     +------------+         SWITCH           |                  |          |
        |     |            |  10                   20 |                  |  host-c  |
        |     |            +--------------------------+                  |          |
        |  V  |               |enp0s9              |enp0s10              |          |
        |  A  |               |                    |                     +----------+
        |  G  |               |                    |                           |enp0s3
        |  R  |               | 192.168.3.2/24     | 192.168.4.2/23            |
        |  A  |               | enp0s8             |enp0s8                     |
        |  N  |         +----------+           +----------+                    |
        |  T  |         |          |           |          |                    |
        |     |  enp0s3 |          |           |          |                    |
        |     +---------+  host-a  |           |  host-b  |                    |
        |     |         |          |           |          |                    |
        |     |         |          |           |          |                    |
        ++-+--+         +----------+           +----------+                    |
        | |                                        |enp0s3                     |
        | |                                        |                           |
        | +----------------------------------------+                           |
        |                                                                      |
        |                                                                      |
        +----------------------------------------------------------------------+

# Subnets
The network is divided in 4 different subnets:

- A including host-1-a and router-1. The subnet is a /24 so you can get IP addresses for 254 different hosts (248 minimum required)

 - B including host-1-b and router-1. The subnet is a /23 so you can get IP addresses for 512 different hosts (436 minimum required)

- C including router-1 and router-2. The subnet is a /30 so you can get IP addresses for 2 different hosts

- D including router-2 and host-2-c. The subnet is a /23 so you can get IP addresses for 315 different hosts

<br>
host-a and a host-b need to be in different subnets. The approach to solve this problem is implementing tagged VLAN in order to redirect the traffic as intended.

| Subnet | Interface |   Host   | Vlan tag |     IP      |
|:------:|:---------:|:--------:|:--------:|:-----------:|
|    A   | enp0s8.10 | router-1 |    10    | 192.168.3.1 |
|    B   | enp0s8.20 | router-1 |    20    | 192.168.4.1 |

<br><br><br>



# Network Mapping
<br>

|   Device | Interface | IP |  Subnet 
|:--------:|:---------:|:--------:|:-----------:|
| router-1 | enp0s8.10 |    192.168.3.1     | A |   
|          | enp0s8.20 |    192.168.4.1     | B |    
|          |   enp0s9  |   192.168.128.65   | D |        
|  host-a  |   enp0s8  |   192.168.3.2      | A | 
|  host-b  |   enp0s8  |   192.168.4.2      | B |  
| router-2 |   enp0s9  |   192.168.128.66   | D |           
|          |   enp0s8  |   192.168.6.1      | C |         
|  host-c  |   enp0s8  |   192.168.6.254    | C |   
<br><br><br>     


# Vagrant file and Provisioning 
<br>
In order to have a ready-to-go work environment provisioning is used. Each device has its own shell file that is casted when the <code>vagrant up</code> command occurs. Let's break down some of the most important ones.
<br><br>

## Host
The configuration between hosts interface configurations is similar one to another, host-c differs from other since we needed to run a docker image.

<p>host-c.sh</p>

```
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -add-apt-repository 
"deb arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
```

Then we run the docker image to enable requests from clients

```
docker system prune -a # clean up any docker resources
docker run --name DNCSWebserver -p 80:80 -d dustnic82/nginx-test
```

Finally we create a static routing to other hosts
```
#creates a static route to reach subnet A via router-2
ip route add 192.168.3.0/24 via 192.168.6.1
#creates a static route to reach subnet B via router-2
ip route add 192.168.4.0/23 via 192.168.6.1
```

## Router

Routers scripts are a bit more complicated. Initially ip forwarding is enabled and the interfaces are configurated. In router-1 the subinterfaces are created:
```
#creates the subinterface for VLAN 10
ip link add link enp0s8 name enp0s8.10 type vlan id 10
#adds IP address to the subinterface
ip add add 192.168.3.1/24 dev enp0s8.10

#creates the subinterfaces for VLAN 20
ip link add link enp0s8 name enp0s8.20 type vlan id 20
#adds IP address to the subinterface
ip add add 192.168.4.1/23 dev enp0s8.20
```

Static routing is then defined in this way:
<p>router-1.sh</p>

```
ip route add 192.168.6.0/23 via 192.168.128.66 dev enp0s9
```
<p>router-2.sh</p>


```
#creates a static route to reach subnet A via router-1
ip route add 192.168.3.0/24 via 192.168.128.65 dev enp0s9
#creates a static route to reach subnet B via router-1
ip route add 192.168.4.0/23 via 192.168.128.65 dev enp0s9
```

## Switch

Last but not least we set up the switch script creating the trunk ports in order to deliver packages accordingly to the topology

```
#creates an access port on VLAN 10
ovs-vsctl add-port brd enp0s9 tag=10
#brings the interface up
ip link set enp0s9 up

#creates an access port on VLAN 20
ovs-vsctl add-port brd enp0s10 tag=20
#brings the interface up
ip link set enp0s10 up
```
(interfaces and ip settings are omitted in the highlight of the scripts. It was made like this to mantain the assignment readable. If you want to know more you can check the entire script for each device in the repository)