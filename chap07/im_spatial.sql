drop table t2;
DELETE FROM USER_SDO_GEOM_METADATA;
create table t2( id number, geometry SDO_GEOMETRY);

begin
for i in 1..1000000
loop
	    INSERT INTO t2 VALUES (
        i,
        sdo_geometry(2001,                  
         4326,                              
         sdo_point_type(dbms_random.value(1,360) - 180, dbms_random.value(1,360) -90, null),
                     NULL,               
                     NULL               
                     )
    );

    if mod(i, 5000) = 0 then
        commit;
    end if;
end loop;
commit;
end;
/

    
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
   'T2',
   'GEOMETRY',
   SDO_DIM_ARRAY(
       SDO_DIM_ELEMENT(
           'x', -180, 180, 0.05
       ), SDO_DIM_ELEMENT(
           'y', -90, 90, 0.05
       )
   ),
   4326
   );
commit;

CREATE INDEX t2_sidx ON
    t2 (
        geometry
    )
        INDEXTYPE IS mdsys.spatial_index PARAMETERS (' SDO_INDX_DIMS=2');

