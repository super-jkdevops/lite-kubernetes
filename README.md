## K3s lab
```
.---------------------------------------------------------------------------.
| This is 6 node cluster contains 3 control plane and 3 compute nodes by    |
| default. Lab using light weight solution based on thin Rancher kubernetes |
| Cluster. This is alternative for users wants to run it on hardware with   |
| oldest equipment. In general k3s is based on lightweight container engine |
| then name is ContainerD. Despite on docker requirements we can say this   |
| is perfect for older hardware :)                                          |
'---------------------------------------------------------------------------'
```

## Terminology
K3s - is light weight kubernetes platform provided by Rancher

Explanation:
```
  ube
k  3  s=kubes 
```

ContainerD - is container engin used by k3s cluster

Token - token is generatd once there used for whole spin up k3s process.


## Kubernetes version formely k3s
Currently I'm using 1.20.6 k3s1 but you can change appropartiate variables (channel and version).

Feel free to change it if you have different requirements.

## Requirements
Here will be short list about all requirements needed to run this environment.

+ Hardware:
  * 2 CPU
  * 4,5GB RAM at least
  * 30GB HDD

+ Operating system:
  * Widnows 10 installed WSL 1 preferable Ubuntu 18.04 LTS or 20.04 LTS (available in Microsoft Store)
  * Ubuntu 18.04 LTS or 20.04 LTS
  * CentOS/RHEL 7/8 64 bit 

+ Packages:
  * vagrant 2.2.10 or higher (https://www.vagrantup.com/intro/getting-started/install.html)
  * git 1.8 or higher for Linux / 2.29.2 or higher for Windows  (https://pl.atlassian.com/git/tutorials/install-git)
  * VirtualBox 6.1 or higher (https://www.virtualbox.org/wiki/Downloads)

## Before you start
There are some prerequisite task which need to be completed before you start for example:
installing virtualbox, vagrant or if you are on Windows WSL1/2 or CygWin. I assume that you have
already installed and prepared everything to run. You don't need to install ansible cause I am
using embaded ansible provisioner.

I highly encurage you to use Ubuntu.

## Items

+ Host entries:

```
192.168.100.2  k3s-cp1
192.168.100.3  k3s-cp2
192.168.100.4  k3s-cp3
192.168.100.10 k3s-wn1
192.168.100.11 k3s-wn2
192.168.100.12 k3s-wn3
```

`If you have no plan to use it externally you can leave hosts as it was before.`

+ Pods networking
```
Calico
```

+ K3s version
```
k3s Rancher 1.20.6
```

+ Container engine
```
containerd://1.4.4-k3s1
```

+ Operating system version
```
Ubuntu 18.04 LTS - k3s servers and agents
```


## Clone repo
In your home directory type:

```
git clone https://github.com/super-jkdevops/mk8s-ContainerD-lab.git kubernetes-vagrant-containerd
```

Move to "" directory:

```
cd 
```

## Start vagrant machines
When repo will be on your station then you need to run only 1 command.
You should be in kubernetes-vagrant-containerd directory. If not please 
enter this directory and run:

```
vagrant up
```

`
Please be patient this process can take a while usually depends on your hardware: disk speed, memory type,
cpu type and generation. 
`

You should see similar output:
```
K3s token for spinup cluster: 6cfcfdbcdc29ca7e4a68535ccdf0c951f80d3c3ac5c0aa84bc6d799840298f8f
Bringing machine 'k3s-cp1' up with 'virtualbox' provider...
Bringing machine 'k3s-cp2' up with 'virtualbox' provider...
Bringing machine 'k3s-cp3' up with 'virtualbox' provider...
Bringing machine 'k3s-wn1' up with 'virtualbox' provider...
Bringing machine 'k3s-wn2' up with 'virtualbox' provider...K3s token for spinup cluster: 6cfcfdbcdc29ca7e4a68535ccdf0c951f80d3c3ac5c0aa84bc6d799840298f8f
Bringing machine 'k3s-cp1' up with 'virtualbox' provider...
Bringing machine 'k3s-cp2' up with 'virtualbox' provider...
Bringing machine 'k3s-cp3' up with 'virtualbox' provider...
Bringing machine 'k3s-wn1' up with 'virtualbox' provider...
Bringing machine 'k3s-wn2' up with 'virtualbox' provider...
Bringing machine 'k3s-wn3' up with 'virtualbox' provider...
==> k3s-cp1: Cloning VM...
==> k3s-cp1: Matching MAC address for NAT networking...
==> k3s-cp1: Checking if box 'bento/ubuntu-18.04' version '202012.21.0' is up to date...
==> k3s-cp1: Setting the name of the VM: light-kubernetes_k3s-cp1_1620591076020_47321
==> k3s-cp1: Clearing any previously set network interfaces...
==> k3s-cp1: Preparing network interfaces based on configuration...

Bringing machine 'k3s-wn3' up with 'virtualbox' provider...
==> k3s-cp1: Cloning VM...
==> k3s-cp1: Matching MAC address for NAT networking...
==> k3s-cp1: Checking if box 'bento/ubuntu-18.04' version '202012.21.0' is up to date...
==> k3s-cp1: Setting the name of the VM: light-kubernetes_k3s-cp1_1620591076020_47321
==> k3s-cp1: Clearing any previously set network interfaces...
==> k3s-cp1: Preparing network interfaces based on configuration...
.
..
...
    k3s-wn3: TasksMax=infinity
    k3s-wn3: TimeoutStartSec=0
    k3s-wn3: Restart=always
    k3s-wn3: RestartSec=5s
    k3s-wn3: ExecStartPre=-/sbin/modprobe br_netfilter
    k3s-wn3: ExecStartPre=-/sbin/modprobe overlay
    k3s-wn3: ExecStart=/usr/local/bin/k3s \
    k3s-wn3:     agent \
    k3s-wn3: 	'--node-ip' \
    k3s-wn3: 	'192.168.100.12' \
    k3s-wn3: 	'--flannel-iface' \
    k3s-wn3: 	'eth1' \
```

It can take a while, up to 15 mins. Please be patient. Token is generated once and used for
each cluster components namely joining rest control planes and agents.


### List Kubernetes nodes
Kubectl binary has been installed only on master node. If you would like to use kubectl on your station you should install
it and copy configuration from .kubectl directory. Without kubectl you will be not able to check kubernetes status and
other cluster things.

On the master node: "mk8s-master" and vagrant user type:

```
kubectl get nodes -o wide
```

Then following output should be displayed:
```
NAME      STATUS   ROLES                       AGE   VERSION        INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
k3s-cp1   Ready    control-plane,etcd,master   36m   v1.20.6+k3s1   192.168.100.2    <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1
k3s-cp2   Ready    control-plane,etcd,master   33m   v1.20.6+k3s1   192.168.100.3    <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1
k3s-cp3   Ready    control-plane,etcd,master   30m   v1.20.6+k3s1   192.168.100.4    <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1
k3s-wn1   Ready    <none>                      26m   v1.20.6+k3s1   192.168.100.10   <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1
k3s-wn2   Ready    <none>                      23m   v1.20.6+k3s1   192.168.100.11   <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1
k3s-wn3   Ready    <none>                      21m   v1.20.6+k3s1   192.168.100.12   <none>        Ubuntu 18.04.5 LTS   4.15.0-128-generic   containerd://1.4.4-k3s1

```

Please remember that you should see all nodes and masters as ready. If for some reason
nodes are unavailable please check k3s logs.

On control planes do following
```
systemctl status k3s
```

On workers:
```
systemctl status k3s-agent
```

### List k3s cluster objects:
In this section we will check Kubernetes cluster in details. Thanks to this we will know if
all parts of cluster are ready for future operation/deployments etc.

#### Check kubes cluster:"

Namespaces:
```
kubectl get namespaces
```

should return output:

```
NAME              STATUS   AGE
default           Active   36m
kube-node-lease   Active   36m
kube-public       Active   36m
kube-system       Active   36m
```


Pods in kube-system namespace:
```
kubectl -n kube-system get pods
```

You should see following output:

```
NAME                                  READY   STATUS    RESTARTS   AGE
calico-kube-controllers-6d7b4db76c-vbmmj   1/1     Running   0          22m     172.16.206.1     k3s-cp1   <none>           <none>
calico-node-459h8                          1/1     Running   0          6m24s   192.168.100.12   k3s-wn3   <none>           <none>
calico-node-gkbk7                          1/1     Running   0          18m     192.168.100.3    k3s-cp2   <none>           <none>
calico-node-h5w8w                          1/1     Running   0          22m     192.168.100.2    k3s-cp1   <none>           <none>
calico-node-prhc2                          1/1     Running   0          9m2s    192.168.100.11   k3s-wn2   <none>           <none>
calico-node-r2p88                          1/1     Running   0          15m     192.168.100.4    k3s-cp3   <none>           <none>
calico-node-smc6h                          1/1     Running   0          11m     192.168.100.10   k3s-wn1   <none>           <none>
coredns-854c77959c-f67xh                   1/1     Running   0          22m     172.16.206.2     k3s-cp1   <none>           <none>
local-path-provisioner-5ff76fc89d-spjvb    1/1     Running   0          22m     172.16.206.3     k3s-cp1   <none>           <none>
metrics-server-86cbb8457f-97p5t            1/1     Running   0          22m     172.16.206.4     k3s-cp1   <none>           <none>
```

Deployments in kube-system namespace:
```
kubectl -n kube-system get deployments
```

Desired output:

```
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
coredns   2/2     2            2           14
```

## Used technology:
- Bash
- K3s/Rancher
- Vagrant
- Git
- Github

## Post installation steps
There is always good ida to have lab hosts in /etc/hosts file. It can be usefull in many cases 
(reach loadbalancer, check if ingress or application is running on the nodes and scheduled
properly).

If you are intrested please go as follow:

```
cat <<EOT >> /etc/hosts
192.168.100.2  k3s-cp1
192.168.100.3  k3s-cp2
192.168.100.4  k3s-cp3
192.168.100.10 k3s-wn1
192.168.100.11 k3s-wn2
192.168.100.12 k3s-wn3
EOT
```
