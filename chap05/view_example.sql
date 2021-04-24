-- run this script if you only poputated only lineorder table

set pages 9999

select * from v$sga;
select inmemory, inmemory_priority as IM_PRIO, inmemory_compression as IM_COMP, inmemory_distribute as IM_DIST, inmemory_duplicate as IM_DUP, cellmemory from user_segments where segment_name = 'LINEORDER';
col pool for a12
select pool, alloc_bytes/1024/1024 as ALLOC_MB, used_bytes/1024/1024 as USED_MB, populate_status from v$inmemory_area;

col segment_name for a12
col tablespace_name for a16
select segment_name, segment_type, tablespace_name, bytes/1024/1024 as DISK_MB, blocks, extents from user_segments where segment_name = 'LINEORDER';

select segment_name, inmemory_size/1024/1024 as IM_MB, bytes/1024/1024 as DISK_MB, bytes_not_populated, populate_status, inmemory_compression as IM_COMP from v$im_segments;

select head_piece_address, sum(allocated_len)/1024/1024 as IM_ALLOC_MB, round(sum(used_len)/1024/1024,2) as IM_USED_MB, sum(num_rows), sum(num_disk_extents) from v$im_header group by head_piece_address;

select sum(allocated_len)/1024/1024 as TOTAL_ALLOC_MB, sum(used_len)/1024/1024 as TOTAL_USED_MB, sum(num_rows), sum(num_blocks), sum(time_to_populate)/1000 as "POP_TIME(S)" from v$im_header;

select drammembytes/1024/1024 as IM_MB, extents, blocks, blocksinmem, imcusinmem, bytes/1024/1024 as DISK_MB, TO_CHAR(createtime, 'DD-MON-YYYY HH24:MI') as createtime from v$im_segments_detail;

col table_name for a12
col column_name for a20
select table_name, column_name, inmemory_compression from v$im_column_level where table_name = 'LINEORDER';

select utl_raw.cast_to_number(minimum_value) as min, utl_raw.cast_to_number(maximum_value) as max, dictionary_entries from v$im_col_cu where column_number = 1;







