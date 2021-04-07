SELECT /* 1.2 SSB_SAMPLE_SQL */
    SUM(lo_extendedprice * lo_discount) AS revenue
FROM
    lineorder,
    date_dim
WHERE
        lo_orderdate = d_datekey
    AND d_yearmonthnum = 199401
    AND lo_discount BETWEEN 4 AND 6
    AND lo_quantity BETWEEN 26 AND 35;
