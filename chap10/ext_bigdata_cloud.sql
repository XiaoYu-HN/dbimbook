drop table customer_ext_bd_cloud;

create table customer_ext_bd_cloud(
    c_custkey     NUMBER,
    c_name        VARCHAR(25),
    c_address     VARCHAR(25),
    c_city        CHAR(10),
    c_nation      CHAR(15),
    c_region      CHAR(12),
    c_phone       CHAR(15),
    c_mktsegment  CHAR(10)
)
ORGANIZATION EXTERNAL
  (TYPE ORACLE_BIGDATA
   DEFAULT DIRECTORY DEFAULT_DIR
   ACCESS PARAMETERS
   (
    com.oracle.bigdata.fileformat = textfile 
    com.oracle.bigdata.csv.skip.header=0
    com.oracle.bigdata.csv.rowformat.quotecharacter='"'
   )
   location ('https://objectstorage.us-ashburn-1.oraclecloud.com/n/ocichina001/b/b01/o/customer.csv')
  )  REJECT LIMIT UNLIMITED;

select count(*) from customer_ext_bd_cloud;
