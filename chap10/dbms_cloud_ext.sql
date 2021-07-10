drop table customer_ext;

create table customer_ext(
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
    com.oracle.bigdata.csv.rowformat.fields.terminator = ','
   )
   location ('https://raw.githubusercontent.com/XiaoYu-HN/dbimbook/main/chap10/*.csv')
  )  REJECT LIMIT UNLIMITED;
