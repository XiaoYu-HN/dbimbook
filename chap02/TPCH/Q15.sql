CREATE VIEW revenue960101 (
    supplier_no,
    total_revenue
) AS
    SELECT
        l_suppkey,
        SUM(l_extendedprice *(1 - l_discount))
    FROM
        lineitem
    WHERE
            l_shipdate >= DATE '1996-01-01'
        AND l_shipdate < DATE '1996-01-01' + INTERVAL '3' MONTH
    GROUP BY
        l_suppkey;

SELECT
    s_suppkey,
    s_name,
    s_address,
    s_phone,
    total_revenue
FROM
    supplier,
    revenue960101
WHERE
        s_suppkey = supplier_no
    AND total_revenue = (
        SELECT
            MAX(total_revenue)
        FROM
            revenue960101
    )
ORDER BY
    s_suppkey;

DROP VIEW revenue960101;
