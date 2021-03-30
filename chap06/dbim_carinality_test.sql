drop table t1;
drop table t2;

create table t1(a varchar(16));
create table t2(a varchar(16));

begin for i in 1..&&rowcnt
	loop
		insert into t1 values(
			decode(
				floor(dbms_random.value(1,6)),
				1, '1234567890123456',
				2, '2234567890123456',
				3, '3234567890123456',
				4, '4234567890123456',
				5, '5234567890123456'
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


alter table t1 inmemory memcompress for query high;
exec popwait('SSB', 'T1');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );

alter table t1 inmemory memcompress for capacity low;
exec popwait('SSB', 'T1');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );


alter table t1 inmemory memcompress for capacity high;
exec popwait('SSB', 'T1');

SELECT
    segment_name,
    bytes,
    inmemory_size,
    round(bytes / inmemory_size, 2) AS compress_ratio
FROM
    v$im_segments
WHERE
    segment_name IN ( 'T1', 'T2' );
