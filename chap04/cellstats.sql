col value for 999,999,999,999,999,999
col name for a60
set pages 9999
set lines 120
select name, value from v$sesstat a, v$statname b where
(a.STATISTIC# = b.STATISTIC#) and 
(a.sid) = userenv( 'sid') and 
(name in ( 
'cellmemory IM scan CUs processed for query', 
'cellmemory IM scan CUs processed for capacity',
'cellmemory IM scan CUs processed no memcompress',
'cellmemory IM load CUs for query',
'cellmemory IM load CUs for capacity',
'cellmemory IM load CUs no memcompress',
'cell physical IO bytes eligible for predicate offload',
'cell physical IO interconnect bytes returned by smart scan',
'cell physical IO bytes saved by columnar cache', 
'cell physical IO bytes saved by storage index',
'HCC scan cell bytes compressed',
'HCC scan cell bytes decompressed'
)) order by name; 
