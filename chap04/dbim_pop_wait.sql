/*
STARTUP RESTRICT

ALTER PLUGGABLE DATABASE ORCLPDB1 OPEN RESTRICTED;

ALTER SESSION SET CONTAINER=orclpdb1;
*/

SET SERVEROUTPUT ON

DECLARE
    pop_status NUMBER;
BEGIN
    LOOP
        SELECT
            dbms_inmemory_admin.populate_wait(priority => 'NONE', percentage => 100, timeout => 30)
            -- dbms_inmemory_admin.populate_wait(priority => 'NONE', percentage => 20 )
        INTO pop_status
        FROM
            dual;

        dbms_output.put_line('POP STATUS IS ('
                             || TO_CHAR(pop_status)
                             || ')');

        IF pop_status = -1 THEN
            dbms_output.put_line('Not ready, Please Wait...');
            CONTINUE;
        END IF;

        IF pop_status = 0 THEN
            dbms_output.put_line('Populate completed, You can start application now!');
        END IF;

        EXIT;
    END LOOP;
END;
/

/*
ALTER SYSTEM DISABLE RESTRICTED SESSION;

ALTER SESSION SET CONTAINER=CDB$ROOT;

ALTER SYSTEM DISABLE RESTRICTED SESSION;
*/
