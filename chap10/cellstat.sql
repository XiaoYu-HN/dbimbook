set pages 9999
SELECT
    name,
    value
FROM
    v$sesstat   a,
    v$statname  b
WHERE
    ( a.statistic# = b.statistic# )
    AND ( a.sid ) = userenv('sid')
    AND ( name LIKE '%cell%' )
    AND value != 0
ORDER BY
name;

