import cx_Oracle

conn = cx_Oracle.connect("ssb", "Welcome1", "localhost/orclpdb1")

sqlstmt = 'insert /*+ MEMOPTIMIZE_WRITE */ into iot_ingest values (:id, :value)';

cursor = conn.cursor()

cursor.prepare(sqlstmt)

for i in range(1, 1000000 + 1):
	cursor.execute(sqlstmt, (i, "ABCDEFGH"))

cursor.close()
conn.close()
