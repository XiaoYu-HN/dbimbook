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
--   location ('https://raw.githubusercontent.com/XiaoYu-HN/dbimbook/main/chap10/customer.csv')
  )  REJECT LIMIT UNLIMITED;

select count(*) from customer_ext_bd_cloud;

-- below is equivalent DDL
drop table customer_ext_bd_cloud;

BEGIN
dbms_cloud.create_external_table(
table_name => 'customer_ext_bd_cloud', 
file_uri_list => 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/ocichina001/b/b01/o/customer.csv',
format => JSON_OBJECT('type' VALUE 'csv', 'skipheaders' VALUE '0'),
column_list => 'c_custkey     NUMBER,
    c_name        VARCHAR(25),
    c_address     VARCHAR(25),
    c_city        CHAR(10),
    c_nation      CHAR(15),
    c_region      CHAR(12),
    c_phone       CHAR(15),
    c_mktsegment  CHAR(10)');
END;
/

select count(*) from customer_ext_bd_cloud;
