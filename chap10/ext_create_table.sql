drop table t1;
create table t1(id int, t date);

BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO t1
            SELECT
                i,
                to_date(trunc(dbms_random.value(to_char(DATE '2020-01-01', 'J'), to_char(DATE '2020-12-31', 'J'))), 'J')
            FROM
                dual;

    END LOOP;

    FOR i IN 101..20 LOOP
        INSERT INTO t1
            SELECT
                i,
                to_date(trunc(dbms_random.value(to_char(DATE '2021-01-01', 'J'), to_char(DATE '2021-12-31', 'J'))), 'J')
            FROM
                dual;

    END LOOP;
    
    COMMIT;
END;
/

select * from t1;
