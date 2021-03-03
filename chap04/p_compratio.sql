-- execute this SQL like below:
-- sqlplus sys@orclpdb1 as sysdba @p_compratio.sql

DROP TABLE ssb.compresult;

CREATE TABLE ssb.compresult (
    complevel  VARCHAR(32),
    poptime    NUMBER,
    compratio  NUMBER,
    querytime  NUMBER
);

GRANT SELECT ON v_$im_segments TO ssb;

GRANT EXECUTE ON dbms_inmemory_admin TO ssb;

CREATE OR REPLACE PROCEDURE p_compratio (
    tabname    IN  VARCHAR2,
    complevel  IN  VARCHAR2,
    num_run    IN  NUMBER
) AS
    ptime      NUMBER;
    qtime      NUMBER;
    popresult  NUMBER;
    compratio  NUMBER;
    tmpsum     NUMBER;
BEGIN
    FOR i IN 1..num_run LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE lineorder NO INMEMORY';
        EXECUTE IMMEDIATE 'ALTER TABLE lineorder INMEMORY ' || complevel;
        ptime := dbms_utility.get_time;
        SELECT
            dbms_inmemory_admin.populate_wait(priority => 'NONE')
        INTO popresult
        FROM
            dual;

        ptime := ( dbms_utility.get_time - ptime ) / 100;
        SELECT
            round(bytes / inmemory_size, 2)
        INTO compratio
        FROM
            v$im_segments;

        qtime := dbms_utility.get_time;
        SELECT
            MIN(lo_quantity) + MAX(lo_ordtotalprice) + AVG(lo_ordtotalprice) + AVG(lo_quantity)
        INTO tmpsum
        FROM
            lineorder;

        qtime := ( dbms_utility.get_time - qtime );
        INSERT INTO compresult VALUES (
            complevel,
            ptime,
            compratio,
            qtime
        );

        COMMIT;
    END LOOP;
END p_compratio;
/

show errors;

exit
