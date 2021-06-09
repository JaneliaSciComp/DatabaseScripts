-- drop temporary image data table
-- INSERT INTO image_data_mv_log SELECT * FROM tmp_image_incremental_data_mv;
-- INSERT INTO image_data_mv_update_log SELECT * FROM tmp_image_incremental_update_data_mv;
DROP TABLE IF EXISTS tmp_image_incremental_data_mv;
DROP TABLE IF EXISTS tmp_image_incremental_update_data_mv;
