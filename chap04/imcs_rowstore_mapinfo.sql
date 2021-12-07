set pages 999
set echo on

drop table t2;

/*
create table t2( id number, v1 number, v2 char(2), v3 char(8));
begin
for i in 1..2000000
loop
    insert into t2 values(i, round(dbms_random.value(1,1000)), dbms_random.string('L', 2), 'ABCDEFGH');
    if mod(i, 5000) = 0 then
        commit;
    end if;
end loop;
commit;
end;
*/

create table t2 as 
select level as id, round(dbms_random.value(1,1000)) as v1, dbms_random.string('L', 2) as v2, 'ABCDEFGH' as v3 from dual connect by level <= 2000000;

/*
select count(*) from t2;

select min(v1), max(v2) from t2;

select distinct v2 from t2
*/

-- set inmemory and populate
alter table t2 inmemory;

select dbms_inmemory_admin.populate_wait(priority => 'NONE') from dual;

-- memory size and compression ratio
select bytes, inmemory_size, round(bytes/inmemory_size, 2) as compress_ratio from v$im_segments where segment_name = 'T2';

-- IMCU overall
select sum(num_rows), sum(num_blocks), sum(num_disk_extents) from v$im_header where table_objn in (select object_id from user_objects where object_name = 'T2');
select membytes, drammembytes, extents, blocks, datablocks, imcusinmem, bytes from v$im_segments_detail;

-- IMCU detail
-- tsn is Table Space Number, dba is data block address: file numner and block id
select imcu_addr, allocated_len, used_len, num_disk_extents, num_rows, num_blocks, time_to_populate from v$im_header 
    where table_objn in (select object_id from user_objects where object_name = 'T2') and num_rows != 0;
select tsn, startdba, extent_cnt, block_cnt, total_rows from v$im_smu_head;

-- Original table overall
select count(*) as num_extents, sum(bytes), sum(blocks) from user_extents where segment_name = 'T2';

-- Original table detail
select count(*),bytes/1024 as "SIZE(KB)", bytes/1024/8 as blocks from user_extents where segment_name = 'T2' group by bytes order by bytes;
select extent_id, bytes, blocks from user_extents where segment_name = 'T2';
