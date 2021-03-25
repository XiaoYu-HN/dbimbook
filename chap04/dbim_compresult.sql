declare
	rnd pls_integer := 2;
begin
 p_compratio('lineorder', 'NO MEMCOMPRESS', rnd);

 p_compratio('lineorder', 'MEMCOMPRESS FOR DML', rnd);

 p_compratio('lineorder', 'MEMCOMPRESS FOR QUERY LOW', rnd);

 p_compratio('lineorder', 'MEMCOMPRESS FOR QUERY HIGH', rnd);

 p_compratio('lineorder', 'MEMCOMPRESS FOR CAPACITY LOW', rnd);

 p_compratio('lineorder', 'MEMCOMPRESS FOR CAPACITY HIGH', rnd);
end;
/

SELECT
    complevel,
    compratio,
    AVG(poptime),
    AVG(querytime)
FROM
    compresult
GROUP BY
    complevel,
    compratio
ORDER BY
    compratio;
