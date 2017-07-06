#!/bin/bash
#set up some variables
NL=$'\n'
depServer="lab-spkdep01" #hostname of the deployment server
#make sure sysstat is installed and up to date
sudo apt-get install -y sysstat
#get the splunk client first
wget "https://us-artifactory.netdocuments.com/artifactory/nd-splunk-generic/splunkforwarder-6.5.0-59c8927def0f-linux-2.6-amd64.deb" --no-check-certificate
#install the splunk uf
sudo dpkg -i splunkforwarder-6.5.0-59c8927def0f-linux-2.6-amd64.deb
#set uf to start automatically
sudo /opt/splunkforwarder/bin/splunk enable boot-start --accept-license
#start splunk service
sudo service splunk start
#configure deployment-client
echo "[target-broker:deploymentServer]${NL}targetUri = ${depServer}:8089" | sudo tee /opt/splunkforwarder/etc/system/local/deploymentclient.conf
#restart splunk
sudo /opt/splunkforwarder/bin/splunk restart
#get rid of the deb file
rm splunkforwarder-6.5.0-59c8927def0f-linux-2.6-amd64.deb
