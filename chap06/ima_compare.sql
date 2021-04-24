alter table lineorder inmemory;
alter table date_dim inmemory;
alter table supplier inmemory;

prompt Populate table lineorder...
exec popwait('SSB', 'LINEORDER');
prompt Populate table date_dim...
exec popwait('SSB', 'DATE_DIM');
prompt Populate table supplier...
exec popwait('SSB', 'SUPPLIER');

prompt TEST 1, IMCS enabled, Vector transformation enabled(auto, default)
prompt _________________________________________________________________
set timing on
@ima
set timing off
@../xplan

prompt TEST 2, IMCS enabled, Vector transformation DISABLED
prompt ____________________________________________________
alter session set "_optimizer_vector_transformation" = false;
set timing on
@ima
set timing off
@../xplan
alter session set "_optimizer_vector_transformation" = true;


prompt TEST 3, IMCS disabled, Vector transformation enabled(auto, default)
prompt ___________________________________________________________________
alter table lineorder no inmemory;
alter table supplier no inmemory;
alter table date_dim no inmemory;
--exec dbms_session.sleep(5);

set timing on
@ima
set timing off
@../xplan

prompt TEST 4, IMCS disable, Vector transformation DISABLED
prompt ____________________________________________________
alter session set "_optimizer_vector_transformation" = false;
set timing on
@ima
set timing off
@../xplan
alter session set "_optimizer_vector_transformation" = true;
