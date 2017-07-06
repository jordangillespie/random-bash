#!/bin/bash
server=$1
#set up some variables
NL=$'\n'
depServer="lab-spkdep01" #hostname of the deployment server
package="splunkforwarder-6.5.0-59c8927def0f-linux-2.6-amd64.deb"
#make sure sysstat is installed and up to date
ssh $server 'sudo apt-get install -y sysstat' < /dev/null
#get the splunk client first
ssh $server "echo \"Downloading ${package}...\"; wget --quiet \"https://us-artifactory.netdocuments.com/artifactory/nd-splunk-generic/${package}\"" < /dev/null
#install the splunk uf
ssh $server "sudo dpkg -i ${package}" < /dev/null
#set uf to start automatically and start splunk service
ssh $server 'sudo /opt/splunkforwarder/bin/splunk enable boot-start --accept-license; sudo service splunk start'  < /dev/null
#configure deployment-client
ssh $server "echo \"[target-broker:deploymentServer]${NL}targetUri = ${depServer}:8089\" | sudo tee /opt/splunkforwarder/etc/system/local/deploymentclient.conf" < /dev/null
#restart splunk and cleanup installation package
ssh $server "sudo /opt/splunkforwarder/bin/splunk restart; rm ${package}" < /dev/null
