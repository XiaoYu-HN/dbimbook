SELECT
    SUM(lo_revenue),
    d_year,
    s_region
FROM
    lineorder,
    date_dim,
    supplier
WHERE
        lo_orderdate = d_datekey
    AND lo_suppkey = s_suppkey
    AND d_year > 1995
    AND s_region IN ( 'AMERICA', 'ASIA' )
GROUP BY
    d_year,
    s_region
ORDER BY
    d_year,
    s_region;
