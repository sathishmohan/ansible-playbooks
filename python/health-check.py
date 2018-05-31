###
#Script to check the health status of the pulsar machine
#Usage : pyhton health-check.py
#Author - sathishm
#####


import os
import datetime
import subprocess
from subprocess import Popen, PIPE
import json


#checking the process of the pulsar machine

list=['tomcat7','/usr/sbin/nginx','kafka-stream','redis-server','workflow.cloud','workflow.patch','workflow.joval','dockerImage','pythonRunner','pythonDockerImageRunner','pythonDockerRunner','bin/postgres']

dict1 ={}
for name in list:
  p = Popen('ps -ef | grep %s | grep -v grep'%name, shell=True, stdout=PIPE, stderr=PIPE)
  out, err = p.communicate()
  for line in out.splitlines():
      fields = line.split()
      if len(fields) >= 1:
        #dict1["Service"] = str(name)
        a=fields[1]
        for value in a:
           t= Popen('top -p %s -n 1 | grep %s'%(a,a), shell=True, stdout=PIPE, stderr=PIPE)
           output, err = t.communicate()
           for line in output.splitlines():
             fields = line.split()
             dict1["Service"] = str(name)
             dict1["PID"] = str(fields[1])
             dict1["Memory"] = str(fields[10])
             dict1["CPU"] = str(fields[9])
             if len(a) >=1:
                dict1["Status"] = str("Running")
      json_output = json.dumps(dict1, sort_keys=True, indent=4 )
      print json_output

 
#checking the disk usage of the pulsar machine
  
dict2= {}
p = Popen('df -h | tail -n +2 | grep "/dev"', shell=True, stdout=PIPE, stderr=PIPE)
disk, err = p.communicate()
for line in disk.splitlines():
    fields = line.split()
    dict2["Filesystem"] = str(fields[0])
    dict2["Size"] = str(fields[1])
    dict2["Used"] = str(fields[2])
    dict2["Avail"] = str(fields[3])
    dict2["Used %"] = str(fields[4])
    dict2["MountPoint"] = str(fields[5])
    json_disk = json.dumps(dict2, sort_keys=True, indent=4)
    print json_disk


#checking the Ram memory of pulsar machine

dict3 ={}
m = Popen('free -g | tail -n +2 | head -1', shell=True, stdout=PIPE, stderr=PIPE)
memory, err = m.communicate()
for line in memory.splitlines():
    fields = line.split()
    dict3["Total Memory in GB"] = str(fields[1])
    dict3["Used"] = str(fields[2])
    dict3["Free"] = str(fields[3])
    dict3["Shared"] = str(fields[4])
    dict3["Buffer"] = str(fields[5])
    dict3["cached"]= str(fields[6])
    json_memory = json.dumps(dict3, sort_keys=True, indent=4)
    print json_memory


#checking the swap memory of pulsar machine

dict4 = {}
s= Popen('free -g | tail -n +4', shell=True, stdout=PIPE, stderr=PIPE)
swap, err = s.communicate()
for line in swap.splitlines():
    fields = line.split()
    dict4["Total Memory in GB"] = str(fields[1])
    dict4["Used"] = str(fields[2])
    dict4["Free"] = str(fields[3])
    json_swap = json.dumps(dict4, sort_keys=True, indent=4)
    print json_swap


#checking load average of the pulsar machine

dict5 = {}
l=Popen('uptime', shell=True, stdout=PIPE, stderr=PIPE)
load, err = l.communicate()
for line in load.splitlines():
    fields = line.split()
    dict5["Load Average"] = fields[9:12]
    json_load = json.dumps(dict5, indent=4)
    print json_load

