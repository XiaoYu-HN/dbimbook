EXECUTE p_compratio('lineorder', 'NO MEMCOMPRESS', 10);

EXECUTE p_compratio('lineorder', 'MEMCOMPRESS FOR DML', 10);

EXECUTE p_compratio('lineorder', 'MEMCOMPRESS FOR QUERY LOW', 10);

EXECUTE p_compratio('lineorder', 'MEMCOMPRESS FOR QUERY HIGH', 10);

EXECUTE p_compratio('lineorder', 'MEMCOMPRESS FOR CAPACITY LOW', 10);

EXECUTE p_compratio('lineorder', 'MEMCOMPRESS FOR CAPACITY HIGH', 10);

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
    complevel;
