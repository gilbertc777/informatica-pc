#!/bin/bash

echo "Running powercenter.sh"

echo "Got the parameters:"
echo public_url $public_url
echo db_host_name $db_host_name
echo pdb_name $pdb_name
echo host_domain_name $host_domain_name
echo admin_console_password $admin_console_password
echo infra_passphrase $infra_passphrase

####

LICENSE_KEY_LOC="\/home\/opc\/Informatica\/Server\/License.key"
LICENSE_FILE=/home/opc/Informatica/Server/License.key
License_url=https://$public_url/License.key
echo "Downloading License key" > /home/opc/user_data.log
wget -O $LICENSE_FILE $License_url
echo "Checking License Key download" >> /home/opc/user_data.log
if [[ -f $LICENSE_FILE && -s $LICENSE_FILE ]]
then
    echo "License key downloaded successfully." >> /home/opc/user_data.log
    sed -i s/^LICENSE_KEY_LOC=.*/LICENSE_KEY_LOC=$LICENSE_KEY_LOC/ /home/opc/infainstaller/SilentInput.properties
    chmod 777 $LICENSE_FILE
    export ADD_LICENSE_CONDITION=1
else
    echo "License key download might have encountered an error." >> /home/opc/user_data.log
    echo "License key will not be added to the domain." >> /home/opc/user_data.log
    export ADD_LICENSE_CONDITION=0
fi
echo "Initializing variables.." >> /home/opc/user_data.log
export CREATE_DOMAIN=1
export JOIN_DOMAIN=0
export SERVES_AS_GATEWAY=0
export SINGLE_NODE=1
export DOMAIN_USER_NAME=Administrator
export DB_TYPE=Oracle
export REPOSITORY_SERVICE_NAME=PCRS
export INTEGRATION_SERVICE_NAME=PCIS
export DB_ADDRESS=$db_host_name
export DB_PORT=1521
export DB_UNAME=usr7
export DB_SERVICENAME=$pdb_name.$host_domain_name
export DOMAIN_NAME=Domain
export NODE_NAME=Node01
export GRID_NAME=PCGRID
export REPO_USER=usr8
export INFORMATICA_SERVICES=2
export JOIN_NODE_NAME=Node02
export DOMAIN_HOST_NAME=pc-test-vm
DB_CUSTOM_STRING='jdbc:informatica:oracle:\/\/'$DB_ADDRESS':1521;ServiceName='$DB_SERVICENAME';EncryptionLevel=required;EncryptionTypes=(AES256,AES192,AES128);DataIntegrityLevel=required;DataIntegrityTypes=(SHA1)'
sed -i s/^DB_CUSTOM_STRING_SELECTION=.*/DB_CUSTOM_STRING_SELECTION=1/ /home/opc/infainstaller/SilentInput.properties
sed -i s/^DB_CUSTOM_STRING=.*/DB_CUSTOM_STRING=$DB_CUSTOM_STRING/ /home/opc/infainstaller/SilentInput.properties
echo "Starting Installation..." >> /home/opc/user_data.log
ln -s /usr/lib/oracle/18.3/client64/lib/libclntsh.so.18.1 /usr/lib/oracle/18.3/client64/lib/libclntsh.so.11.1
sh /home/opc/InfaEc2Scripts/linInfaInstallerEc2.sh $admin_console_password $master_db_password PCTest $infra_passphrase
echo "Installation Complete. Please see installation log for more details." >> /home/opc/user_data.log
