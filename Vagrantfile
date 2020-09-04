# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

MACHINES = {
  :otus => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.111',
  },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|
        config.vbguest.no_install = true
        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s

            #box.vm.network "forwarded_port", guest: 8080, host: 8080

            box.vm.network "private_network", ip: boxconfig[:ip_addr]

            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "1024"]
            #        vb.gui = true
            end

        box.vm.provision "shell", privileged: false, inline: <<-SHELL, privileged: false
        echo -e "\n\nВывод скрипта: \n"
        /vagrant/script.sh
        
        echo "Задание выполнено!"
          SHELL

        end
    end
  end
