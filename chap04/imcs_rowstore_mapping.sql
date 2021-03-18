-- get the mapping between IMCU and row store, please input tablename
set pages 999
set serveroutput on
col imcu_addr heading "IMCU_ADDR" for 9999999999999999 
compute number label "#EXTENTS IN IMCU" of extent_id on imcu_addr
break on imcu_addr skip 1 duplicates
declare 
    v_rc sys_refcursor;
    v_objd number;
    v_objname varchar2(32) := upper('&tabname');
begin
    select object_id into v_objd from user_objects where object_name = v_objname;

    open v_rc for 
    select a.imcu_addr, b.extent_id, b.blocks, a.start_dba, b.ext_start_dba, b.ext_end_dba  from (
    ( select imcu_addr, start_dba, v_objd dataobj, count(1) from v$im_tbs_ext_map where dataobj = v_objd group by imcu_addr, start_dba ) a join
    ( select extent_id+1 as extent_id,blocks
     ,dbms_utility.make_data_block_address(relative_fno,block_id) ext_start_dba
     ,dbms_utility.make_data_block_address(relative_fno,block_id+blocks-1) ext_end_dba
     ,v_objd dataobj
        from dba_extents where owner = user and segment_name = v_objname ) b
    on (a.dataobj = b.dataobj and ( a.start_dba between b.ext_start_dba and b.ext_end_dba)))
    order by 4;
    
    dbms_sql.return_result(v_rc);
    
end;
/
