SELECT /* 2.2 SSB_SAMPLE_SQL */ /*+ MONITOR */
    SUM(lo_revenue),
    d_year,
    p_brand1
FROM
    lineorder,
    date_dim,
    part,
    supplier
WHERE
        lo_orderdate = d_datekey
    AND lo_partkey = p_partkey
    AND lo_suppkey = s_suppkey
    AND p_brand1 BETWEEN 'MFGR#2221' AND 'MFGR#2228'
    AND s_region = 'ASIA'
GROUP BY
    d_year,
    p_brand1
ORDER BY
    d_year,
    p_brand1;
