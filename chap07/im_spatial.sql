drop table t2;
delete from user_sdo_geom_metadata where table_name = 'T2';
create table t2( id number, geometry SDO_GEOMETRY);

begin
for i in 1..1000000
loop
	INSERT INTO t2 VALUES (
    i,
    sdo_geometry(2001, 4326, sdo_point_type(dbms_random.value(1, 360) - 180, dbms_random.value(1, 360) - 90, NULL),
                 NULL,
                 NULL)
	);

    if mod(i, 5000) = 0 then
        commit;
    end if;
end loop;
commit;
end;
/

INSERT INTO user_sdo_geom_metadata VALUES (
    'T2',
    'GEOMETRY',
    sdo_dim_array(sdo_dim_element('x', - 180, 180, 0.05), sdo_dim_element('y', - 90, 90, 0.05)),
    4326
);    
commit;

CREATE INDEX t2_sidx ON
    t2 (
        geometry
    )
        INDEXTYPE IS mdsys.spatial_index;

SELECT
    id
FROM
    t2
WHERE
    sdo_filter(geometry, sdo_geometry(2001, 4326, sdo_point_type(- 72.432246, 156.378981, NULL), NULL, NULL)) = 'TRUE';

/*
SELECT
    a.id,
    b.id
FROM
    t3  a,
    t3  b
WHERE
        a.id != b.id
    AND sdo_within_distance(a.geometry, b.geometry, 'distance=50 unit=km') = 'TRUE';
*/
