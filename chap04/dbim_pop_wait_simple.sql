SET TIMING ON

VARIABLE pop_status NUMBER

BEGIN
    SELECT
        dbms_inmemory_admin.populate_wait(priority => 'NONE', percentage => 100)
    INTO :pop_status
    FROM
        dual;

END;
/

PRINT pop_status

SET TIMING OFF
