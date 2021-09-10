SET PAGES 9999
SET LINES 250

SELECT
    t1.name,
    t2.value
FROM
    v$sysstat  t1,
    v$mystat   t2
WHERE
    ( t1.name IN ( 'CPU used by this session', 
                   'physical reads',
                   'physical reads direct',
                   'physical reads cache',
                   'session logical reads',
                   'session logical reads - IM',
                   'session pga memory',
                   'table scans (long tables)',
                   'table scans (IM)',
                   'table scan disk IMC fallback' )
      OR ( t1.name LIKE 'IM scan%' ) 
      OR ( t1.name LIKE 'IM simd%' ) )
    AND t1.statistic# = t2.statistic#
    AND t2.value != 0
ORDER BY
    t1.name;
