SET SERVEROUTPUT ON

DECLARE
    p_blks_cmp    PLS_INTEGER;
    p_blks_uncmp  PLS_INTEGER;
    p_rows_cmp       PLS_INTEGER;
    p_rows_uncmp     PLS_INTEGER;
    p_cmp_ratio     NUMBER;
    l_comptype_str  VARCHAR2(256);
    t1              PLS_INTEGER;
    TYPE array_t IS VARRAY(11) OF NUMBER;
    comptypes array_t := array_t(
	dbms_compression.COMP_ADVANCED,
	dbms_compression.COMP_QUERY_HIGH,
	dbms_compression.COMP_QUERY_LOW,
	dbms_compression.COMP_ARCHIVE_HIGH,
	dbms_compression.COMP_ARCHIVE_LOW,
	dbms_compression.COMP_INMEMORY_NOCOMPRESS,
	dbms_compression.COMP_INMEMORY_DML,
	dbms_compression.COMP_INMEMORY_QUERY_LOW,
    	dbms_compression.COMP_INMEMORY_QUERY_HIGH,
    	dbms_compression.COMP_INMEMORY_CAPACITY_LOW,
    	dbms_compression.COMP_INMEMORY_CAPACITY_HIGH
	);
BEGIN
    FOR i IN 1..comptypes.count LOOP
        t1 := dbms_utility.get_time;
        dbms_compression.get_compression_ratio(scratchtbsname => 'USERS', ownname => 'SSB',
                                              objname => 'LINEORDER',
                                              subobjname => NULL,
                                              comptype => comptypes(i),
                                              blkcnt_cmp => p_blks_cmp,
                                              blkcnt_uncmp => p_blks_uncmp,
                                              row_cmp => p_rows_cmp,
                                              row_uncmp => p_rows_uncmp,
                                              cmp_ratio => p_cmp_ratio,
                                              comptype_str => l_comptype_str,
                                              subset_numrows => dbms_compression.comp_ratio_allrows,
                                              objtype => dbms_compression.objtype_table);

        dbms_output.put_line('-----------------------------------------------------------------');
        dbms_output.put_line('Compression type                         : ' || l_comptype_str);
        dbms_output.put_line('Evaluation time: ' || (dbms_utility.get_time - t1) / 100 || ' seconds');
        dbms_output.put_line('Compression ratio                        : ' || p_cmp_ratio);
        dbms_output.put_line('Number of blocks used (compressed)       : ' || p_blks_cmp);
        dbms_output.put_line('Number of blocks used (uncompressed)     : ' || p_blks_uncmp);
        dbms_output.put_line('Number of rows in a block (compressed)   : ' || p_rows_cmp);
        dbms_output.put_line('Number of rows in a block (uncompressed) : ' || p_rows_uncmp);
	dbms_output.put_line('');
    END LOOP;
END;
/

exit;
