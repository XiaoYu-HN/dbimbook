import cx_Oracle

conn = cx_Oracle.connect("ssb", "Welcome1", "localhost/orclpdb1")

sqlstmt = 'insert into iot_ingest values (:id, :value)';

cursor = conn.cursor()

cursor.prepare(sqlstmt)

data_array = []

for i in range(1, 1000000 + 1):
	data_array.append( (i, 'ABCDEFGH') )
	if i%5000 == 0:
		cursor.executemany(sqlstmt, data_array)
		conn.commit()
		data_array = []

cursor.executemany(sqlstmt, data_array)
conn.commit()

cursor.close()
conn.close()
