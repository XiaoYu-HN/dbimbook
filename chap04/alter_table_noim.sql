@../userlogin.sql

SET ECHO ON

ALTER TABLE lineorder NO INMEMORY;

ALTER TABLE part NO INMEMORY;

ALTER TABLE customer NO INMEMORY;

ALTER TABLE supplier NO INMEMORY;

ALTER TABLE date_dim NO INMEMORY;

SET ECHO OFF
