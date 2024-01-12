col name for a40
select name, sum(value) value from (
      select extractvalue(value(t),'/stat/@name') name,
            extractvalue(value(t),'/stat') value
      from v$cell_state cs,
           table(xmlsequence(extract(xmltype(cs.statistics_value),
                                     '//stats[@type="columnarcache"]/stat'))) t
     where statistics_type='CELL')
     where name in ('outstanding_imcpop_requests')
     group by name;
