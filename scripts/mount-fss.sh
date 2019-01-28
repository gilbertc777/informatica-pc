#!/bin/bash
# Name: mount-fss.sh
# Author: Chuck Gilbert <chuck.gilbert@oracle.com>
# Description: Take input of the FSS mount target ip, export
#   name, and mount point for an instance, and mount initial
#   access and add to /etc/fstab

# Output of provided configuration variables
echo "Running mount-fss.sh"

echo "Got the parameters:"
echo mount_target_ip $mount_target_ip
echo export_name $export_name
echo mount_point $mount_point

# Check required variables suppilied
if [ -z "${mount_target_ip}" ]
then
  echo "Variable: mount_target_ip not set!  Exiting."
  exit 1
fi

if [ -z "${export_name}" ]
then
  echo "Variable: export_name not set!  Exiting."
  exit 1
fi

if [ -z "${mount_point}" ]
then
    echo "Variable mount_point not set!  Exiting."
    exit 1
fi

# With all variables set, mount filesystem
# Install nfs-utils
sudo yum -y install nfs-utils > nfs-utils-install.log
    
# create mount point
sudo mkdir -p ${mount_point}
    
# Perform one time mount of filesystem
sudo mount ${mount_target_ip}:${export_name} ${mount_point}

# Setup permanent mount params in /etc/fstab
echo "${mount_target_ip}:${export_name} ${mount_point}  nfs defaults,relatime 0 0" >> /etc/fstab

# end of script