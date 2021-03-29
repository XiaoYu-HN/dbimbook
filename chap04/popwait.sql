CREATE OR REPLACE PROCEDURE popwait (
    schema_name IN VARCHAR2 DEFAULT 'SSB',
    table_name IN VARCHAR2 DEFAULT 'LINEORDER',
    timeout IN NUMBER DEFAULT 120
) AS
    ps  VARCHAR2(16);
    ts  NUMBER := 0;
    t1  NUMBER := dbms_utility.get_time;
BEGIN
    DBMS_INMEMORY.POPULATE(schema_name, table_name);
    
    LOOP
        BEGIN
        SELECT
            populate_status
        INTO ps
        FROM
            v$im_segments
        WHERE
            segment_name = table_name;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        
        dbms_session.sleep(1);
        ts := ts + 1;
        EXIT WHEN ps = 'COMPLETED' OR ts > timeout;
    END LOOP;

    dbms_output.put_line('Pop time:'
                         ||(dbms_utility.get_time - t1) / 100
                         || ' seconds');

END popwait;
/
-- alter table lineorder inmemory
-- alter table lineorder no inmemory
-- exec popwait();

