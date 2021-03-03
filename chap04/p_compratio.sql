create or replace PROCEDURE p_compratio (
    tabname    IN  VARCHAR2,
    complevel  IN  VARCHAR2,
    num_run    IN  NUMBER
) AS
    poptime    NUMBER;
    dmlstr     VARCHAR2(100);
    popresult  NUMBER;
    compratio  NUMBER;
BEGIN
    FOR i IN 1..num_run LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE lineorder NO INMEMORY';
        EXECUTE IMMEDIATE 'ALTER TABLE lineorder INMEMORY ' || complevel;
        poptime := dbms_utility.get_time;
        SELECT
            dbms_inmemory_admin.populate_wait(priority => 'NONE')
        INTO popresult
        FROM
            dual;

        poptime := ( dbms_utility.get_time - poptime ) / 100;
        
        SELECT
            round(bytes / inmemory_size, 2)
        INTO compratio
        FROM
            v$im_segments;

        INSERT INTO compresult VALUES (
            complevel,
            poptime,
            compratio
        );

        COMMIT;
    END LOOP;
END p_compratio;
