sqlplus -S /nolog <<'EOF'

@../userlogin.sql

SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM lineorder p;
SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM customer p;
SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM date_dim p;
SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM part p;
SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM supplier p;

EOF
