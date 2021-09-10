WITH c_orders AS (
    SELECT
        c_custkey AS c_count,
        COUNT(o_orderkey)
    FROM
        customer
        LEFT OUTER JOIN orders ON c_custkey = o_custkey
                                  AND o_comment NOT LIKE '%special%requests%'
    GROUP BY
        c_custkey
)
SELECT
    c_count,
    COUNT(*) AS custdist
FROM
    c_orders
GROUP BY
    c_count
ORDER BY
    custdist DESC,
    c_count DESC;
