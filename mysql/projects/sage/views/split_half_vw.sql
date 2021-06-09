CREATE OR REPLACE VIEW split_half_vw AS
SELECT l.name                           AS line
      ,lr1.object                       AS ad
      ,lp3.value                        AS ad_robot_id
      ,lp5.value                        AS ad_info
      ,lr2.object                       AS dbd
      ,lp4.value                        AS dbd_robot_id
      ,lp6.value                        AS dbd_info
FROM line_vw l
JOIN line_relationship_vw lr1 ON (l.id=lr1.subject_id AND lr1.relationship='child_of')
JOIN line_property_vw lp1 ON (lr1.object_id=lp1.line_id AND lp1.type='flycore_project' AND lp1.value='Split_GAL4-AD')
JOIN line_relationship_vw lr2 ON (l.id=lr2.subject_id AND lr2.relationship='child_of')
JOIN line_property_vw lp2 ON (lr2.object_id=lp2.line_id AND lp2.type='flycore_project' AND lp2.value='Split_GAL4-DBD')
JOIN line_property_vw lp3 ON (lr1.object_id=lp3.line_id AND lp3.type='robot_id')
JOIN line_property_vw lp4 ON (lr2.object_id=lp4.line_id AND lp4.type='robot_id')
LEFT OUTER JOIN line_property_vw lp5 ON (lr1.object_id=lp5.line_id AND lp5.type='flycore_production_info')
LEFT OUTER JOIN line_property_vw lp6 ON (lr2.object_id=lp6.line_id AND lp6.type='flycore_production_info')
;
