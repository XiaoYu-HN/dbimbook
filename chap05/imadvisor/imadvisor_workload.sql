SELECT
    d.d_year,
    p.p_brand1,
    SUM(lo_revenue)          tot_rev,
    COUNT(p.p_partkey)       tot_parts
FROM
    lineorder  l,
    date_dim   d,
    part       p,
    supplier   s
WHERE
        l.lo_orderdate = d.d_datekey
    AND l.lo_partkey = p.p_partkey
    AND l.lo_suppkey = s.s_suppkey
    AND p.p_category = 'MFGR#12'
    AND s.s_region = 'AMERICA'
    AND d.d_year = 1997
GROUP BY
    d.d_year,
    p.p_brand1;
