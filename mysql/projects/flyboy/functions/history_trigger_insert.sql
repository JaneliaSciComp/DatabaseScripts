DELIMITER $$

DROP TRIGGER IF EXISTS history_trigger_insert
$$

CREATE TRIGGER history_trigger_insert
BEFORE INSERT ON __flipper_flystocks_stock
    FOR EACH ROW
    BEGIN
        REPLACE
        INTO
            flystocks_stock_history
            (
                stock_id,
                genotype,
                rack,
                cell,
                previous_flip,
                second_previous_flip,
                rack_location,
                last_flipped,
                core_flag,
                oldform_id,
                rack_b,
                cell_b,
                previous_flip_b,
                rack_location_b,
                last_flipped_b,
                change_datetime,
                change_type
            )
            VALUES
            (
                NEW.stock_id,
                NEW.genotype,
                NEW.rack,
                NEW.cell,
                NEW.previous_flip,
                NEW.second_previous_flip,
                NEW.rack_location,
                NEW.last_flipped,
                NEW.core_flag,
                NEW.oldform_id,
                NEW.rack_b,
                NEW.cell_b,
                NEW.previous_flip_b,
                NEW.rack_location_b,
                NEW.last_flipped_b,
                NOW(),
                'insert'
            );
    END;
$$
DELIMITER ;
