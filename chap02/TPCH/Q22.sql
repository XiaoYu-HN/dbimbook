WITH custsale AS (
    SELECT
        substr(c_phone, 1, 2) AS cntrycode,
        c_acctbal
    FROM
        customer
    WHERE
        substr(c_phone, 1, 2) IN ( '13', '31', '23', '29', '30', '18', '17' )
        AND c_acctbal > (
            SELECT
                AVG(c_acctbal)
            FROM
                customer
            WHERE
                    c_acctbal > 0.00
                AND substr(c_phone, 1, 2) IN ( '13', '31', '23', '29', '30', '18', '17' )
        )
        AND NOT EXISTS (
            SELECT
                *
            FROM
                orders
            WHERE
                o_custkey = c_custkey
        )
)
SELECT
    cntrycode,
    COUNT(*)           AS numcust,
    SUM(c_acctbal)     AS totacctbal
FROM
    custsale
GROUP BY
    cntrycode
ORDER BY
    cntrycode;
