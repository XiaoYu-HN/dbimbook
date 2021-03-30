CREATE OR REPLACE PROCEDURE popwait (
    schema_name IN VARCHAR2 DEFAULT 'SSB',
    table_name IN VARCHAR2 DEFAULT 'LINEORDER',
    timeout IN NUMBER DEFAULT 10
) AS
    ok  NUMBER := 0;
    ts  NUMBER := 0;
    t1  NUMBER := dbms_utility.get_time;
BEGIN
    DBMS_INMEMORY.POPULATE(schema_name, table_name);
    
    LOOP
        dbms_session.sleep(1);
        ts := ts + 1;

        SELECT
           	count(*)  
        INTO ok
        FROM
            v$im_segments
        WHERE
            segment_name = table_name and populate_status = 'COMPLETED';
        
        EXIT WHEN ok = 1 OR ts > timeout;
    END LOOP;

    dbms_output.put_line('Pop time for table (' || upper(table_name) || '): '
                         ||(dbms_utility.get_time - t1) / 100
                         || ' seconds');

END popwait;
/

/*
-- test code
set serveroutput on
alter table lineorder no inmemory;
alter table lineorder inmemory;
exec popwait('ssb', 'lineorder');
*/

