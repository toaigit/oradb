#  oradb
Create an EC2 instance with the following characteristics:  
  - EC2 with auto scale & 2 ebs volume creation  
  - Using image OEL7 with Oracle Codetree installed.  
  - NOTE - Need to update the runcmd with a correct ORACLE_SID   
  - NOTE - Two ebs volume attached as /dev/xvdh (db) and /dev/xvdi (/backup)   
  - NOTE - /etc/oratab defines if the db will be started automatically or not.  
  - User data will perform the following:  
    - Attach & mount the two ebs volumes /db and /backup  
    - Restore spfileSID.ora to ORACLE_HOME/dbs  
    - Setup the oradb service.  
    - Startup the database if already installed  

Basic flows:  
  - if this is the first time,   
    - initialize the ebs /db and /backup filesystems  
    - mount the /db and /backup   
    - Manually run db creation (run.dbca SID)  
    - Backup the spfileSID.ora  
    - Setup oradb service  
    - Restart the database using oradb service.  
  - If this is not a first time,   
    - Just mount the /db and /backup  
    - Restore the spfileSID.ora to ORACLE_HOME/dbs  
    - Restore /etc/oratab, listener.ora and sqlnet.ora  
    - Setup oradb service  
    - Startup the database using the oradb service  

