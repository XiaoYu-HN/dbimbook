#!/bin/bash
# this script will create user SSB and 5 SSB schema tables under it
# you should input password for new created SSB user 

read -sp "Please input password for user SSB you will create:" SSBPassword

echo 

sqlplus / as sysdba <<-EOF

ALTER SESSION SET CONTAINER = orclpdb1;

DROP USER ssb CASCADE;

CREATE USER ssb IDENTIFIED BY "$SSBPassword";

GRANT dba, unlimited tablespace TO ssb;

ALTER SESSION SET CURRENT_SCHEMA = ssb;

CREATE TABLE lineorder (
    lo_orderkey       NUMBER,
    lo_linenumber     NUMBER,
    lo_custkey        NUMBER,
    lo_partkey        NUMBER,
    lo_suppkey        NUMBER,
    lo_orderdate      NUMBER,
    lo_orderpriority  CHAR(15),
    lo_shippriority   CHAR(1),
    lo_quantity       NUMBER,
    lo_extendedprice  NUMBER,
    lo_ordtotalprice  NUMBER,
    lo_discount       NUMBER,
    lo_revenue        NUMBER,
    lo_supplycost     NUMBER,
    lo_tax            NUMBER,
    lo_commitdate     NUMBER,
    lo_shipmode       CHAR(10)
);

CREATE TABLE supplier (
    s_suppkey  NUMBER,
    s_name     CHAR(25),
    s_address  VARCHAR(25),
    s_city     CHAR(10),
    s_nation   CHAR(15),
    s_region   CHAR(12),
    s_phone    CHAR(15)
);

CREATE TABLE part (
    p_partkey    NUMBER,
    p_name       VARCHAR(22),
    p_mfgr       CHAR(6),
    p_category   CHAR(7),
    p_brand1     CHAR(9),
    p_color      VARCHAR(11),
    p_type       VARCHAR(25),
    p_size       NUMBER,
    p_container  CHAR(10)
);

CREATE TABLE customer (
    c_custkey     NUMBER,
    c_name        VARCHAR(25),
    c_address     VARCHAR(25),
    c_city        CHAR(10),
    c_nation      CHAR(15),
    c_region      CHAR(12),
    c_phone       CHAR(15),
    c_mktsegment  CHAR(10)
);

CREATE TABLE date_dim (
    d_datekey           NUMBER,
    d_date              CHAR(18),
    d_dayofweek         CHAR(10),
    d_month             CHAR(9),
    d_year              NUMBER,
    d_yearmonthnum      NUMBER,
    d_yearmonth         CHAR(7),
    d_daynuminweek      NUMBER,
    d_daynuminmonth     NUMBER,
    d_daynuminyear      NUMBER,
    d_monthnuminyear    NUMBER,
    d_weeknuminyear     NUMBER,
    d_sellingseason     CHAR(12),
    d_lastdayinweekfl   CHAR(1),
    d_lastdayinmonthfl  CHAR(1),
    d_holidayfl         CHAR(1),
    d_weekdayfl         CHAR(1)
);

EOF


sqlplus / as sysdba <<'EOF'

ALTER SESSION SET CONTAINER = orclpdb1;

GRANT SELECT ON v_$im_segments TO ssb;

@../chap04/popwait.sql

EOF

