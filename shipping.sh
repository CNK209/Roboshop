source common.sh
if [ -z "${root_mysql_pqssword}" ]; then
  echo "variable root_mysql_pqssword is needed"
  exit
  fi
component=shipping
schema_load=true
schema_type=mysql
MAVEN