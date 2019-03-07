DOMAIN_PORT=6005
JOIN_DOMAIN_PORT=6005
DOMAIN_USER=$DOMAIN_USER_NAME
JOIN_HOST_NAME=$HOSTNAME
TNS_ADMIN=/home/opc/tns_admin

domainpass=$1
dbpass=$2
repopass=$3
passkey=$4

CLOUD_SUPPORT_ENABLE=1
ENV_SET_FLAG=0

USER_INSTALL_DIR="\/home\/opc\/Informatica\/Server"
KEY_DEST_LOCATION="\/home\/opc\/Informatica\/Server\/isp\/config\/keys"

function setENV {
if [ $DB_TYPE = 'Oracle' ]
then
 echo "Setting env for Oracle" &>> /home/opc/InfaServiceLog.log
 ORACLE_HOME=/usr/lib/oracle/18.3/client64
 LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/oracle/18.3/client64/lib
 TNS_ADMIN=/home/opc/tns_admin
 PATH=${PATH}:${ORACLE_HOME}/bin
 export ORACLE_HOME LD_LIBRARY_PATH TNS_ADMIN PATH

 if [ $ENV_SET_FLAG -eq 0 ]
 then
  echo "ORACLE_HOME=/usr/lib/oracle/18.3/client64" &>> /home/opc/.bash_profile
  echo "LD_LIBRARY_PATH="'${LD_LIBRARY_PATH}:/usr/lib/oracle/18.3/client64/lib' &>> /home/opc/.bash_profile
  echo "TNS_ADMIN=/home/opc/tns_admin" &>> /home/opc/.bash_profile
  echo "PATH="'${PATH}:${ORACLE_HOME}/bin' &>> /home/opc/.bash_profile
  echo "export ORACLE_HOME LD_LIBRARY_PATH TNS_ADMIN PATH" &>> /home/opc/.bash_profile
 fi
else
 echo "Setting env for MSSQL" &>> /home/opc/InfaServiceLog.log
 ODBCHOME=/home/opc/Informatica/Server/ODBC7.1
 ODBCINI=${ODBCHOME}/odbc.ini
 ODBCINST=${ODBCHOME}/odbcinst.ini
 LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ODBCHOME}/lib
 export ODBCHOME ODBCINI ODBCINST LD_LIBRARY_PATH

 if [ $ENV_SET_FLAG -eq 0 ]
 then
  echo "ODBCHOME=/home/opc/Informatica/Server/ODBC7.1" &>> /home/opc/.bash_profile
  echo "ODBCINI="'${ODBCHOME}/odbc.ini' &>> /home/opc/.bash_profile
  echo "ODBCINST="'${ODBCHOME}/odbcinst.ini' &>> /home/opc/.bash_profile
  echo "LD_LIBRARY_PATH="'${LD_LIBRARY_PATH}:${ODBCHOME}/lib' &>> /home/opc/.bash_profile
  echo "export ODBCHOME ODBCINI ODBCINST LD_LIBRARY_PATH" &>> /home/opc/.bash_profile
 fi
fi
ENV_SET_FLAG=`expr $ENV_SET_FLAG + 1`
}

function setUlimit {
 echo "*      soft      nofile     50000" &>> /etc/security/limits.conf
 echo "*      hard      nofile     50000" &>> /etc/security/limits.conf
 echo "*      soft      nproc      50000" &>> /etc/security/limits.conf
 echo "*      hard      nproc      50000" &>> /etc/security/limits.conf
 echo "*      soft      stack      10240" &>> /etc/security/limits.conf
 echo "*      hard      stack      10240" &>> /etc/security/limits.conf
 echo "*        -       core       unlimited" &>> /etc/security/limits.conf
}

setENV
setUlimit

if [ $DB_TYPE = 'Oracle' ]
then
 sh /home/opc/InfaEc2Scripts/generateTnsOra.sh $DB_SERVICENAME $DB_ADDRESS $DB_PORT &> /home/opc/InfaServiceLog.log

  echo "Creating DB user $DB_UNAME on DB - $DB_TYPE"
  echo "create user c##$DB_UNAME identified by $dbpass;" | sqlplus SYS/$2@$DB_SERVICENAME AS SYSDBA &>> /home/opc/InfaServiceLog.log
  echo "grant create session, create table, create procedure, create sequence, create view, create trigger, create synonym, create materialized view, query rewrite, resource, create type,dba,aq_administrator_role to $DB_UNAME;" | sqlplus SYS/$2@$DB_SERVICENAME AS SYSDBA &>> /home/opc/InfaServiceLog.log

  echo "Creating DB user $REPO_USER on DB - $DB_TYPE"
  echo "create user c##$REPO_USER identified by $dbpass;" | sqlplus SYS/$2@$DB_SERVICENAME AS SYSDBA &>> /home/opc/InfaServiceLog.log
  echo "grant create session, create table, create procedure, create sequence, create view, create trigger, create synonym, create materialized view, query rewrite, resource, create type,dba,aq_administrator_role to $REPO_USER;" | sqlplus SYS/$2@$DB_SERVICENAME AS SYSDBA &>> /home/opc/InfaServiceLog.log

fi

DB_END_POINT=$DB_ADDRESS
DB_ADDRESS=$DB_ADDRESS":"$DB_PORT

sed -i s/^USER_INSTALL_DIR=.*/USER_INSTALL_DIR=$USER_INSTALL_DIR/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^KEY_DEST_LOCATION=.*/KEY_DEST_LOCATION=$KEY_DEST_LOCATION/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^CLOUD_SUPPORT_ENABLE=.*/CLOUD_SUPPORT_ENABLE=$CLOUD_SUPPORT_ENABLE/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^ENABLE_USAGE_COLLECTION=.*/ENABLE_USAGE_COLLECTION=1/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^CREATE_DOMAIN=.*/CREATE_DOMAIN=$CREATE_DOMAIN/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^PASS_PHRASE_PASSWD=.*/PASS_PHRASE_PASSWD=$4/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_USER=.*/DOMAIN_USER=$DOMAIN_USER/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^JOIN_DOMAIN=.*/JOIN_DOMAIN=$JOIN_DOMAIN/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^SERVES_AS_GATEWAY=.*/SERVES_AS_GATEWAY=$SERVES_AS_GATEWAY/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DB_TYPE=.*/DB_TYPE=$DB_TYPE/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DB_UNAME=.*/DB_UNAME=$DB_UNAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DB_PASSWD=.*/DB_PASSWD=$2/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_PSSWD=.*/DOMAIN_PSSWD=$1/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_CNFRM_PSSWD=.*/DOMAIN_CNFRM_PSSWD=$1/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DB_SERVICENAME=.*/DB_SERVICENAME=$DB_SERVICENAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DB_ADDRESS=.*/DB_ADDRESS=$DB_ADDRESS/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_NAME=.*/DOMAIN_NAME=$DOMAIN_NAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^NODE_NAME=.*/NODE_NAME=$NODE_NAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_PORT=.*/DOMAIN_PORT=$DOMAIN_PORT/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^JOIN_NODE_NAME=.*/JOIN_NODE_NAME=$JOIN_NODE_NAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^JOIN_HOST_NAME=.*/JOIN_HOST_NAME=$JOIN_HOST_NAME/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^JOIN_DOMAIN_PORT=.*/JOIN_DOMAIN_PORT=$JOIN_DOMAIN_PORT/ /home/opc/infainstaller/SilentInput.properties

sed -i s/^DOMAIN_HOST_NAME=.*/DOMAIN_HOST_NAME=$DOMAIN_HOST_NAME/ /home/opc/infainstaller/SilentInput.properties

mv /home/opc/infainstaller/source /home/opc/infainstaller/Tmp_source
mkdir /home/opc/infainstaller/source

cd /home/opc/infainstaller
echo Y Y | sh silentinstall.sh

rmdir /home/opc/infainstaller/source
mv /home/opc/infainstaller/Tmp_source /home/opc/infainstaller/source

USER_INSTALL_DIR="/home/opc/Informatica/Server"
chown -R opc.opc $USER_INSTALL_DIR

function setODBC {
 if [ $DB_TYPE = 'MSSQLServer' ]
 then
  echo "Updating DSN info on /home/opc/Informatica/Server/ODBC7.1/odbc.ini file." &>> /home/opc/InfaServiceLog.log
  echo " " &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "[$DB_SERVICENAME]" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "Driver=/home/opc/Informatica/Server/ODBC7.1/lib/DWsqls27.so" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "Server=$DB_END_POINT" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "Port=$DB_PORT" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "Database=$DB_SERVICENAME" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "User=$DB_UNAME" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
  echo "Password=$dbpass" &>> /home/opc/Informatica/Server/ODBC7.1/odbc.ini
 fi
}

function createPCServices {
 echo "creating PC services" >> /home/opc/InfaServiceLog.log

 sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  createrepositoryservice -dn $DOMAIN_NAME -nn $NODE_NAME -sn $REPOSITORY_SERVICE_NAME -so DBUser=$REPO_USER DatabaseType=$DB_TYPE DBPassword=$dbpass ConnectString=$DB_SERVICENAME CodePage="UTF-8 encoding of Unicode"  OperatingMode=NORMAL -un $DOMAIN_USER -pd $domainpass -sd &>> /home/opc/InfaServiceLog.log

 EXITCODE=$?

 setODBC

 if [ $DB_TYPE = 'MSSQLServer' ]
 then
  echo "Updating DSN details on repository" &>> /home/opc/InfaServiceLog.log
  sh /home/opc/Informatica/Server/isp/bin/infacmd.sh mrs updateServiceOptions -dn $DOMAIN_NAME -un $DOMAIN_USER -pd $domainpass -sn $REPOSITORY_SERVICE_NAME -o "RepositoryServiceOptions.useDSN=No  RepositoryServiceOptions.DataSourceName=$DB_SERVICENAME RepositoryServiceOptions.ConnectString=${DB_END_POINT}@${DB_SERVICENAME}" &>> /home/opc/InfaServiceLog.log
 fi

 if [ $SINGLE_NODE -eq 1 ]
  then
  sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  createintegrationservice -dn $DOMAIN_NAME -nn $NODE_NAME -un $DOMAIN_USER -pd $domainpass -sn $INTEGRATION_SERVICE_NAME  -rs $REPOSITORY_SERVICE_NAME  -ru $DOMAIN_USER -rp $domainpass -po codepage_id=106 -sd -ev INFA_CODEPAGENAME=UTF-8 &>> /home/opc/InfaServiceLog.log

  EXITCODE=$(($? | EXITCODE))
  else
  sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  creategrid -dn $DOMAIN_NAME -un $DOMAIN_USER -pd $domainpass -gn $GRID_NAME -nl $NODE_NAME &>> /home/opc/InfaServiceLog.log

  EXITCODE=$(($? | EXITCODE))

  sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  createintegrationservice -dn $DOMAIN_NAME -gn $GRID_NAME -un $DOMAIN_USER -pd $domainpass -sn $INTEGRATION_SERVICE_NAME -rs  $REPOSITORY_SERVICE_NAME -ru $DOMAIN_USER -rp $domainpass  -po codepage_id=106 -sd -ev INFA_CODEPAGENAME=UTF-8 &>> /home/opc/InfaServiceLog.log

  EXITCODE=$(($? | EXITCODE))

 fi

 if [ $ADD_LICENSE_CONDITION -eq 1 ]
 then
  echo "Adding license" >>  /home/opc/InfaServiceLog.log

  sh /home/opc/Informatica/Server/isp/bin/infacmd.sh addlicense -dn $DOMAIN_NAME -un $DOMAIN_USER -pd $domainpass -ln license -lf /home/opc/Informatica/Server/License.key &>> /home/opc/InfaServiceLog.log

  EXITCODE=$(($? | EXITCODE))

  shred --remove /home/opc/Informatica/Server/License.key
  fi
  exit $EXITCODE

}
if [ $JOIN_DOMAIN -eq 0 ]
then
 createPCServices
else
 setODBC

 sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  updategrid -dn $DOMAIN_NAME -un $DOMAIN_USER -pd $domainpass -gn $GRID_NAME -nl  $JOIN_NODE_NAME -ul &>> /home/opc/InfaServiceLog.log

 EXITCODE=$?

 sh sleep 30

 sh /home/opc/Informatica/Server/isp/bin/infacmd.sh  updateServiceProcess -dn $DOMAIN_NAME -un $DOMAIN_USER -pd $domainpass -sn $INTEGRATION_SERVICE_NAME -nn $JOIN_NODE_NAME -po CodePage_Id=106 -ev INFA_CODEPAGENAME=UTF-8 &>> /home/opc/InfaServiceLog.log

 EXITCODE=$(($? | EXITCODE))

 exit $EXITCODE

fi

