CREATE OR REPLACE VIEW olympiad_gap_analysis_session_property_vw AS
SELECT  gap_sv.session_id AS session_id
       ,temperature.value AS temperature
       ,instrument.value  AS instrument
FROM olympiad_gap_session_vw gap_sv 
JOIN session_property temperature ON (gap_sv.session_id = temperature.session_id)
JOIN cv_term temperature_type ON (temperature.type_id = temperature_type.id AND temperature_type.name = 'temperature')
JOIN session_property instrument ON (gap_sv.session_id = instrument.session_id)
JOIN cv_term instrument_type ON (instrument.type_id = instrument_type.id AND instrument_type.name = 'instrument')
WHERE gap_sv.session_type = 'gap_crossing'
;
