SET LINES 120
COL owner FOR a10
COL table_name FOR a24
COL type_name FOR a15
COL default_directory_name FOR a24
COL reject_limit FOR a12
SELECT owner, table_name, type_name, default_directory_name, reject_limit, inmemory FROM all_external_tables;
