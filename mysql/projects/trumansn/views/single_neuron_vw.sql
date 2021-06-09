CREATE OR REPLACE VIEW `single_neuron_vw` AS
select `o`.`neuron_name` AS `neuron_name`
,`p`.`value` AS `neuron_type`
,`p2`.`value` AS `axon_projection`
,`p3`.`value` AS `longitudinal_tract`
,p4.value AS dendritic_arbor
,p5.value AS soma_position
,p6.value AS 'commissure'
from `orig_single_neuron` `o`
left join `single_neuron_property` `p` on (`o`.`id` = `p`.`sn_id` and `p`.`type` = 'type_of_neuron')
left join `single_neuron_property` `p2` on (`o`.`id` = `p2`.`sn_id` and `p2`.`type` = 'axon_projection')
left join `single_neuron_property` `p3` on (`o`.`id` = `p3`.`sn_id` and `p3`.`type` = 'longitudinal_tract')
left join `single_neuron_property` `p4` on (`o`.`id` = `p4`.`sn_id` and `p4`.`type` = 'dendritic_arbor')
left join `single_neuron_property` `p5` on (`o`.`id` = `p5`.`sn_id` and `p5`.`type` = 'soma_position')
left join `single_neuron_property` `p6` on (`o`.`id` = `p6`.`sn_id` and `p6`.`type` = 'commissure')
;
