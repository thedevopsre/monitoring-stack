#!/usr/bin/env bash

echo "What Linux do you use ? Type [centos7/ubuntu]"
read linuxdistro
echo "=========================================================="

echo "Installing Grafana and InfluxDB on ${linuxdistro}"
echo
if [[ ${linuxdistro} = "centos7" ]]; then
      sudo touch /etc/yum.repos.d/influxdb.repo
cat > /etc/yum.repos.d/influxdb.repo <<EOM
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOM
      echo
      echo "Installing InfluxDB"
      echo
      yum check-update
      sudo yum -y install influxdb vim curl nano
      sudo systemctl start influxdb
      sudo systemctl enable influxdb
 elif [[ ${linuxdistro} = "ubuntu" ]]; then
      echo "Adding repository"
      sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
      sudo echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
      sudo apt update
      echo "Installing InfluxDB"
      echo
      sudo apt install influxdb
      sudo systemctl stop influxdb
      sudo systemctl start influxdb
      sudo systemctl enable --now influxdb
      sudo systemctl is-enabled influxdb
      sudo systemctl status influxdb
fi
if [[ ${linuxdistro} = "centos7" ]]; then
     sudo touch /etc/yum.repos.d/grafana.repo
cat > /etc/yum.repos.d/grafana.repo <<EOM
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOM
     yum check-update
     sudo yum -y install grafana
     sudo systemctl start grafana-server
     sudo systemctl enable grafana-server
 elif [[ ${linuxdistro} = "ubuntu" ]]; then
    sudo apt-get install -y gnupg2 curl software-properties-common
    curl https://packages.grafana.com/gpg.key | sudo apt-key add -
    sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    sudo apt-get update
    sudo apt-get -y install grafana
    sudo systemctl enable --now grafana-server
    sudo apt -y install ufw
    sudo ufw enable
    sudo ufw allow ssh
    sudo ufw allow 3000/tcp
    echo "Your username is < admin > | Your password is < admin >"
fi
echo
echo
echo "Grafana and InfluxDB are installed successfully!"