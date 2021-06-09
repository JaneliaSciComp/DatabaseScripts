CREATE OR REPLACE VIEW `single_neuron_summary_vw` AS
SELECT neuron_name
,GROUP_CONCAT(DISTINCT neuron_type ORDER BY neuron_type ASC SEPARATOR ', ') AS neuron_type
,GROUP_CONCAT(DISTINCT axon_projection ORDER BY axon_projection ASC SEPARATOR ', ') AS axon_projection
,GROUP_CONCAT(DISTINCT longitudinal_tract ORDER BY longitudinal_tract ASC SEPARATOR ', ') AS longitudinal_tract
,GROUP_CONCAT(DISTINCT dendritic_arbor ORDER BY dendritic_arbor ASC SEPARATOR ', ') AS dendritic_arbor
,GROUP_CONCAT(DISTINCT soma_position ORDER BY soma_position ASC SEPARATOR ', ') AS soma_position
,GROUP_CONCAT(DISTINCT commissure ORDER BY commissure ASC SEPARATOR ', ') AS commissure
FROM single_neuron_vw
GROUP BY neuron_name;
