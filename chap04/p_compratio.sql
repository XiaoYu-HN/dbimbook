-- execute this SQL like below:
-- sqlplus sys@orclpdb1 as sysdba @p_compratio.sql

drop table ssb.compresult;
create table ssb.compresult(complevel varchar(32), poptime number, compratio number, querytime number);

grant select on v_$im_segments to ssb;
grant execute on DBMS_INMEMORY_ADMIN to ssb;

create or replace PROCEDURE ssb.p_compratio (
    tabname    IN  VARCHAR2,
    complevel  IN  VARCHAR2,
    num_run    IN  NUMBER
) AS
    ptime    NUMBER;
    qtime    NUMBER;
    popresult  NUMBER;
    compratio  NUMBER;
	tmpsum	NUMBER;
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
	select min(lo_quantity) + max(lo_ordtotalprice) + avg(lo_ordtotalprice) + avg(lo_quantity)  into tmpsum from lineorder;
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
