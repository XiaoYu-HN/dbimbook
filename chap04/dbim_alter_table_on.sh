sqlplus -S /nolog <<-EOF

@../userlogin.sql

ALTER TABLE lineorder INMEMORY;

ALTER TABLE part INMEMORY;

ALTER TABLE customer INMEMORY;

ALTER TABLE supplier INMEMORY;

ALTER TABLE date_dim INMEMORY;

EOF
