-- TEST 1
alter table t2 no inmemory;
alter table t2 inmemory;
exec dbms_inmemory.populate('SSB', 'T2');

-- Wait for Population Completed
select populate_status from v$im_segments where segment_name = 'T2';

-- change compression level will evict the table from IMCS
alter table t2 inmemory memcompress for capacity low;

-- the table is evicted, you can manually populate it by full table scan or PL/SQL function/procudure
select populate_status from v$im_segments where segment_name = 'T2';


-- TEST 1
alter table t2 no inmemory;
alter table t2 inmemory priority low;

-- Since priority is set, table will populated automatically, then wait for the population Completed
select populate_status from v$im_segments where segment_name = 'T2';


-- change compression level will evict the table from IMCS
alter table t2 inmemory memcompress for capacity low;

-- but since priority is set, the background process will auto populate the table after a while
select populate_status from v$im_segments where segment_name = 'T2';
