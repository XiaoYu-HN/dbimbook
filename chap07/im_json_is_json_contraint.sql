DROP TABLE j_purchaseorder;

DROP TABLE json_dump_file_contents;

-- create database directory
CREATE OR REPLACE DIRECTORY order_entry_dir AS '/home/oracle/db-sample-schemas/order_entry';

-- create external table
CREATE TABLE json_dump_file_contents (json_document BLOB)
  ORGANIZATION EXTERNAL (TYPE ORACLE_LOADER DEFAULT DIRECTORY order_entry_dir
  ACCESS PARAMETERS (RECORDS DELIMITED BY 0x'0A'
                     DISABLE_DIRECTORY_LINK_CHECK
                     FIELDS (json_document CHAR(5000)))
  LOCATION (order_entry_dir:'PurchaseOrders.dmp'))
  PARALLEL  REJECT LIMIT UNLIMITED;

-- load data from external table
CREATE TABLE j_purchaseorder (
    id           VARCHAR2(32) NOT NULL PRIMARY KEY,
    date_loaded  TIMESTAMP(6) WITH TIME ZONE,
    po_document  BLOB CONSTRAINT ensure_json CHECK ( po_document IS JSON )
)
    LOB ( po_document ) STORE AS ( CACHE );

INSERT INTO j_purchaseorder (id, date_loaded, po_document)
  SELECT SYS_GUID(), SYSTIMESTAMP, json_document FROM json_dump_file_contents
    WHERE json_document IS JSON;

COMMIT;

-- Check virtual OSON columns before population
SET PAGES 9999
SET LINES 120
COL column_name FOR a24
COL data_type FOR a28
SELECT column_id, column_name, data_type, data_length,  hidden_column, virtual_column FROM user_tab_cols WHERE table_name = 'J_PURCHASEORDER';

-- Check JSON columns
COL table_name FOR a16
SELECT * FROM user_json_columns;

-- populate table
ALTER TABLE j_purchaseorder INMEMORY;
EXEC dbms_inmemory.populate('SSB', 'J_PURCHASEORDER');
EXEC dbms_session.sleep(2);

!../chap04/dbim_get_popstatus.sh

-- Check IMEU
SELECT
    allocated_len,
    used_len,
    num_vircols,
    num_rows,
    time_to_populate
FROM
    v$imeu_header
WHERE
    num_rows != 0;

SELECT
    column_number,
    length,
    row_len
FROM
    v$im_col_cu;

@../userlogin

-- Test SQL
SELECT
    po.po_document
FROM
    j_purchaseorder po
WHERE
    JSON_EXISTS ( po.po_document, '$.LineItems[*]?(@.Part.UPCCode == 85391628927 && @.Quantity > 3)' );

@../showplan

@../imstats

