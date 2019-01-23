#set -o vi
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home
#export SPARK_HOME=/Users/danielon/spark-clients/spark-2.3.1-bin-without-hadoop

export KEYCHAIN_LABEL=wealthfront-ldap
 
export REDSHIFT_USER=`security find-generic-password -s $KEYCHAIN_LABEL | grep acct | cut -d= -f2 | sed -e 's/"//g'`
export PGPASSWORD=`security find-generic-password -ws $KEYCHAIN_LABEL`
export PGSSLMODE=require
alias redshift="PGSSLMODE=require psql -p 5439 -h redshift-proxy.wlth.fr -d readonly -U danielon"
alias redshift_admin="PGSSLMODE=require psql -p 5439 -h redshift-proxy.wlth.fr -d admin -U danielon"
