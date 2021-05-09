# -*- mode: ruby -*-
# vi: set ft=ruby :
# Author: blackyarn | Date: May 2021

# Disable parallel provisioning just avoid issue with joining to not existing master!
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

# !!! Modules required !!!
require 'ipaddr'


# Generate random token for k3s spinup
def generate_token
  if ARGV.include?("up") || ARGV.include?("destroy") || ARGV.include?("provision")
    command = %x[openssl rand -hex 32]
  end
end

# Variables
os_image                    = 'bento/ubuntu-18.04'
channel                     = 'stable'
version                     = 'v1.20.6+k3s1'
token			                  = generate_token
kube_config                 = '/root/.kube/config-k3s'

domain                      = 'lab.org'
quantity_control_plane      = 3	# Default value predefine
quantity_worker_node        = 3 # Default value predefine
first_control_plane_ip      = '192.168.100.2'
first_worker_node_ip        = '192.168.100.10'

control_plane_ip_address    = IPAddr.new first_control_plane_ip
worker_node_ip_address      = IPAddr.new first_worker_node_ip

# Size Memory & CPU
cPlane_mem='1024'
wNode_mem='512'
cPlane_cpu='2'
wNode_cpu='2'


# Run only if vagrant command argument is equal up
if ARGV[0] == "up"
  #print "How many control planes need to be run? "
  #quantity_control_plane = Integer(STDIN.gets)

  #print "How many worker nodes need for workload? "
  #quantity_worker_node = Integer(STDIN.gets)

  print "K3s token for spinup cluster: "+token
end

Vagrant.configure(2) do |config|
  config.vm.box = os_image
  
  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.linked_clone = true
  end

  (1..quantity_control_plane).each do |n|
    name = "k3s-cp#{n}"
    fqdn = "#{name}.#{domain}"
    ip_address = control_plane_ip_address.to_s; control_plane_ip_address = control_plane_ip_address.succ
    config.vm.define name do |config|
      config.vm.provider 'virtualbox' do |vb|
        vb.memory = cPlane_mem
        vb.cpus = cPlane_cpu
      end
      config.vm.hostname = fqdn
      config.vm.network :private_network, ip: ip_address, libvirt__forward_mode: 'none', libvirt__dhcp_enabled: false
      config.vm.provision 'hosts', :sync_hosts => true, :add_localhost_hostnames => false
      config.vm.provision 'shell', path: 'provision/requisite.sh'
    
      if (name == 'k3s-cp1') then
        config.vm.provision "shell", inline: "echo 'first control plane' > /root/INFO.txt", privileged: true
        config.vm.provision 'shell', path: 'provision/1st-controlplane.sh', args: [
          channel,
          version,
          token,
          ip_address,
          kube_config
        ]
        
      else
        config.vm.provision "shell", inline: "echo 'rest of control planes' > /root/INFO.txt", privileged: true
        config.vm.provision 'shell', path: 'provision/redundant-controlplane.sh', args: [
          channel,
          version,
          token,
          ip_address,
          kube_config,
          first_control_plane_ip
        ]
      end 
    end
  end

  (1..quantity_worker_node).each do |n|
    name = "k3s-wn#{n}"
    fqdn = "#{name}.#{domain}"
    ip_address = worker_node_ip_address.to_s; worker_node_ip_address = worker_node_ip_address.succ
  
    config.vm.define name do |config|
      config.vm.provider 'virtualbox' do |vb|
        vb.memory = wNode_mem
        vb.cpus = wNode_cpu
      end
      config.vm.hostname = fqdn
      config.vm.network :private_network, ip: ip_address, libvirt__forward_mode: 'none', libvirt__dhcp_enabled: false
      config.vm.provision 'hosts', :sync_hosts => true, :add_localhost_hostnames => false
      config.vm.provision 'shell', path: 'provision/requisite.sh'
      config.vm.provision 'shell', path: 'provision/worker.sh', args: [
        channel,
        version,
        token,
        ip_address,
        first_control_plane_ip
      ]
    end
  end

  #config.trigger.before :up do |trigger|
  #  trigger.only_on = 's1'
  #  trigger.run = {
  #    inline: '''bash -euc \'
#mkdir -p tmp
#artifacts=(
#  ../gitlab-vagrant/tmp/gitlab.example.com-crt.pem
#  ../gitlab-vagrant/tmp/gitlab.example.com-crt.der
#  ../gitlab-vagrant/tmp/gitlab-runners-registration-token.txt
#)
#for artifact in "${artifacts[@]}"; do
#  if [ -f $artifact ]; then
#    cp $artifact tmp
#  fi
#done
#\'
#'''
#    }
#  end
end
