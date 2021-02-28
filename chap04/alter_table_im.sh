sqlplus /nolog <<-EOF

@../userlogin.sql

SET ECHO ON

ALTER TABLE lineorder INMEMORY;

ALTER TABLE part INMEMORY;

ALTER TABLE customer INMEMORY;

ALTER TABLE supplier INMEMORY;

ALTER TABLE date_dim INMEMORY;

SET ECHO OFF

EOF
