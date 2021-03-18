desc v$im_col_cu

select * from v$im_col_cu

col min_value for a20
col max_value for a20
select head_piece_address, column_number, UTL_RAW.CAST_TO_VARCHAR2 (minimum_value) min_value,
  UTL_RAW.CAST_TO_VARCHAR2 (maximum_value) max_value from v$im_col_cu order by head_piece_address, column_number;

select head_piece_address, column_number, UTL_RAW.CAST_TO_NUMBER (minimum_value) min_value,
  UTL_RAW.CAST_TO_NUMBER (maximum_value) max_value from v$im_col_cu  where column_number in (1,2)
  order by head_piece_address, column_number;

select head_piece_address, column_number, minimum_value min_value,
  maximum_value max_value from v$im_col_cu order by head_piece_address, column_number;
