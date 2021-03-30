drop table t1;
drop table t2;

create table t1(a varchar(16));
create table t2(a varchar(16));

begin for i in 1..&&rowcnt
	loop
		insert into t1 values(
			decode(
				floor(dbms_random.value(1,6)),
				1, '1111111111111111',
				2, '2222222222222222',
				3, '3333333333333333',
				4, '4444444444444444',
				5, '5555555555555555'
			)
		);
	end loop;
	commit;
end;
/

begin for i in 1..&&rowcnt
	loop
		insert into t2 values(
			dbms_random.string('p', 16)
		);
	end loop;
	commit;
end;
/

prompt cardinality for table t1
select count(distinct(a)) from t1;

prompt cardinality for table t2
select count(distinct(a)) from t2;

prompt compression ratio for query low 
alter table t1 inmemory;
alter table t2 inmemory;

set serveroutput on
exec popwait('SSB', 'T1');
exec popwait('SSB', 'T2');

col segment_name for a10
SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );


prompt compression ratio for query high 
alter table t1 inmemory memcompress for query high;
alter table t2 inmemory memcompress for query high;
exec popwait('SSB', 'T1');
exec popwait('SSB', 'T2');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );

prompt compression ratio for capacity low 
alter table t1 inmemory memcompress for capacity low;
alter table t2 inmemory memcompress for capacity low;
exec popwait('SSB', 'T1');
exec popwait('SSB', 'T2');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );


prompt compression ratio for capacity high 
alter table t1 inmemory memcompress for capacity high;
alter table t2 inmemory memcompress for capacity high;
exec popwait('SSB', 'T1');
exec popwait('SSB', 'T2');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );
