SET SERVEROUTPUT ON

DECLARE
    l_blkcnt_cmp    PLS_INTEGER;
    l_blkcnt_uncmp  PLS_INTEGER;
    l_row_cmp       PLS_INTEGER;
    l_row_uncmp     PLS_INTEGER;
    l_cmp_ratio     NUMBER;
    l_comptype_str  VARCHAR2(256);
    t1              PLS_INTEGER;
    TYPE array_t IS
        VARRAY(11) OF NUMBER;
    array           array_t := array_t(
	dbms_compression.comp_advanced,
	dbms_compression.COMP_QUERY_HIGH,
	dbms_compression.COMP_QUERY_LOW,
	dbms_compression.COMP_ARCHIVE_HIGH,
	dbms_compression.COMP_ARCHIVE_LOW,
	dbms_compression.COMP_INMEMORY_NOCOMPRESS,
	dbms_compression.comp_inmemory_dml,
	dbms_compression.comp_inmemory_query_low,
    	dbms_compression.comp_inmemory_query_high,
    	dbms_compression.COMP_INMEMORY_CAPACITY_LOW,
    	dbms_compression.COMP_INMEMORY_CAPACITY_HIGH
	);
BEGIN
    FOR i IN 1..array.count LOOP
        t1 := dbms_utility.get_time;
        dbms_compression.get_compression_ratio(scratchtbsname => 'USERS', ownname => 'SSB',
                                              objname => 'LINEORDER',
                                              subobjname => NULL,
                                              comptype => array(i),
                                              blkcnt_cmp => l_blkcnt_cmp,
                                              blkcnt_uncmp => l_blkcnt_uncmp,
                                              row_cmp => l_row_cmp,
                                              row_uncmp => l_row_uncmp,
                                              cmp_ratio => l_cmp_ratio,
                                              comptype_str => l_comptype_str,
                                              subset_numrows => dbms_compression.comp_ratio_allrows,
                                              objtype => dbms_compression.objtype_table);

        dbms_output.put_line((dbms_utility.get_time - t1) / 100
                             || ' seconds');
        dbms_output.put_line('Number of blocks used (compressed)       : ' || l_blkcnt_cmp);
        dbms_output.put_line('Number of blocks used (uncompressed)     : ' || l_blkcnt_uncmp);
        dbms_output.put_line('Number of rows in a block (compressed)   : ' || l_row_cmp);
        dbms_output.put_line('Number of rows in a block (uncompressed) : ' || l_row_uncmp);
        dbms_output.put_line('Compression ratio                        : ' || l_cmp_ratio);
        dbms_output.put_line('Compression type                         : ' || l_comptype_str);
    END LOOP;
END;
/
