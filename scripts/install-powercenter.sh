#!/bin/bash
# Name: install-powercenter.sh
# Author: Chuck Gilbert <chuck.gilbert@oracle.com>
# Description: This shell script takes input variables about
#   the powercenter installation, and deploys either a single
#   powercenter node domain, or multiple node domain.

# Output of provided configuration variables
echo "Running powercenter.sh"

echo "Got the parameters:"
echo public_url $public_url
echo admin_console_password $admin_console_password
echo master_db_password $master_db_password
echo infra_passphrase $infra_passphrase
echo create_domain $create_domain
echo join_domain $join_domain
echo serves_as_gateway $serves_as_gateway
echo single_node $single_node
echo domain_user_name $domain_user_name
echo db_type $db_type
echo repository_service_name $repository_service_name
echo integration_service_name $integration_service_name
echo db_host_name $db_host_name
echo db_port $db_port
echo db_uname $db_uname
echo db_servicename $db_servicename
echo domain_name $domain_name
echo node_name $node_name
echo grid_name $grid_name
echo repo_user $repo_user
echo informatica_services $informatica_services
echo join_node_name $join_node_name
echo domain_host_name $domain_host_name

echo ""
echo ""

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
export CREATE_DOMAIN=$create_domain
export JOIN_DOMAIN=$join_domain
export SERVES_AS_GATEWAY=$serves_as_gateway
export SINGLE_NODE=$single_node
export DOMAIN_USER_NAME=$domain_user_name
export DB_TYPE=$db_type
export REPOSITORY_SERVICE_NAME=$repository_service_name
export INTEGRATION_SERVICE_NAME=$integration_service_name
export DB_ADDRESS=$db_host_name
export DB_PORT=$db_port
export DB_UNAME=$db_uname
export DB_SERVICENAME=$db_servicename
export DOMAIN_NAME=$domain_name
export NODE_NAME=$node_name
export GRID_NAME=$grid_name
export REPO_USER=$repo_user
export INFORMATICA_SERVICES=$informatica_services
export JOIN_NODE_NAME=$join_node_name
export DOMAIN_HOST_NAME=$domain_host_name
DB_CUSTOM_STRING='jdbc:informatica:oracle:\/\/'$DB_ADDRESS':1521;ServiceName='$DB_SERVICENAME';EncryptionLevel=required;EncryptionTypes=(AES256,AES192,AES128);DataIntegrityLevel=required;DataIntegrityTypes=(SHA1)'
sed -i s/^DB_CUSTOM_STRING_SELECTION=.*/DB_CUSTOM_STRING_SELECTION=1/ /home/opc/infainstaller/SilentInput.properties
sed -i s/^DB_CUSTOM_STRING=.*/DB_CUSTOM_STRING=$DB_CUSTOM_STRING/ /home/opc/infainstaller/SilentInput.properties
echo "Starting Installation..." >> /home/opc/user_data.log
ln -s /usr/lib/oracle/18.3/client64/lib/libclntsh.so.18.1 /usr/lib/oracle/18.3/client64/lib/libclntsh.so.11.1
sh /home/opc/linInfaInstallerEc2.sh $admin_console_password $master_db_password PCTest $infra_passphrase
echo "Installation Complete. Please see installation log for more details." >> /home/opc/user_data.log

# end of script