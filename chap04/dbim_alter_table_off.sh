sqlplus -S /nolog <<-EOF

@../userlogin.sql

ALTER TABLE lineorder NO INMEMORY;

ALTER TABLE part NO INMEMORY;

ALTER TABLE customer NO INMEMORY;

ALTER TABLE supplier NO INMEMORY;

ALTER TABLE date_dim NO INMEMORY;

EOF
