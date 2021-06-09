/* 
    name: project_crosses_expanded

    mv:   

    app:  
    
    note: 
*/

-- =================================================== 
-- create temp table
-- =================================================== 
DROP TABLE IF EXISTS project_crosses_expanded_temp;

CREATE TABLE project_crosses_expanded_temp
SELECT
    `PC`.`__kp_ProjectCrosses_Serial_Number` AS `__kp_ProjectCrosses_Serial_Number`,
    `PC`.`StockNumberLabel`                  AS `StockNumberLabel`,
    `PC`.`Dissection_Notes`                  AS `Dissection_Notes`,
    `PC`.`TimeStarted`                       AS `TimeStarted`,
    `PC`.`TimeCompleted`                     AS `TimeCompleted`,
    `PC`.`Dissector`                         AS `Dissector`,
    `PC`.`Brain`                             AS `Brain`,
    `PC`.`VNC`                               AS `VNC`,
    `PC`.`CNS`                               AS `CNS`,
    `PC`.`Count_`                            AS `Count_`,
    `PC`.`TotalCount`                        AS `TotalCount`,
    `PC`.`RobotID`                           AS `RobotID`,
    `PC`.`Wish_List`                         AS `Wish_List`,
    `PC`.`Date_Crossed`                      AS `Date_Crossed`,
    `PC`.`IP`                                AS `IP`,
    `PC`.`IP_Date`                           AS `IP_Date`,
    `PC`.`Reporter`                          AS `Reporter`,
    `PC`.`Crossed_Notes`                     AS `Crossed_Notes`,
    `PC`.`Max_Redo`                          AS `Max_Redo`,
    `PC`.`Lab_Project`                       AS `Lab_Project`,
    `PC`.`NumberTemp`                        AS `NumberTemp`,
    `PC`.`TRUMAN_Dissection_Number`          AS `TRUMAN_Dissection_Number`,
    `PC`.`Balancer`                          AS `Balancer`,
    `PC`.`gTempDissector`                    AS `gTempDissector`,
    `PC`.`gTempLab`                          AS `gTempLab`,
    `PC`.`fk_Session`                        AS `fk_Session`,
    `PC`.`_kf_Parent_UID`                    AS `_kf_Parent_UID`,
    `PC`.`Project`                           AS `Project`,
    `PC`.`temp_Parent_UID`                   AS `temp_Parent_UID`,
    `PC`.`Rearing_Condition`                 AS `Rearing_Condition`,
    `PC`.`gTempProject`                      AS `gTempProject`,
    `PC`.`Cross_Type`                        AS `Cross_Type`,
    `PC`.`Barcode_CrossSerialNumber`         AS `Barcode_CrossSerialNumber`,
    `PC`.`TRUMAN_COMMENTS`                   AS `TRUMAN_COMMENTS`,
    `PC`.`TRUMAN_SARA_COMMENTS`              AS `TRUMAN_SARA_COMMENTS`,
    `PC`.`TRUMAN_PROBLEM`                    AS `TRUMAN_PROBLEM`,
    `PC`.`TRUMAN_SAMPLES`                    AS `TRUMAN_SAMPLES`,
    `PC`.`TRUMAN_SLIDEID`                    AS `TRUMAN_SLIDEID`,
    `PC`.`TRUMAN_STOCKNUMBER`                AS `TRUMAN_STOCKNUMBER`,
    `PC`.`TRUMAN_TM3`                        AS `TRUMAN_TM3`,
    `PC`.`TRUMAN_GENEINFO`                   AS `TRUMAN_GENEINFO`,
    `PC`.`QualityControl`                    AS `QualityControl`,
    `PC`.`RedoReason`                        AS `RedoReason`,
    `PC`.`RedoCheckbox`                      AS `RedoCheckbox`,
    `PC`.`Cross_Type2`                       AS `Cross_Type2`,
    `PC`.`FC_Member`                         AS `FC_Member`,
    `SF`.`__kp_UniqueID`                     AS `__kp_UniqueID`,
    `SF`.`RobotIDBarcode`                    AS `RobotIDBarcode`,
    `SF`.`Genotype_GSI_Name_PlateWell`       AS `Genotype_GSI_Name_PlateWell`,
    `SF`.`OtherNameOrIdentifier_GSIName`     AS `OtherNameOrIdentifier_GSIName`,
    `SF`.`Chromosome`                        AS `Chromosome`,
    `SF`.`Made_By_Or_Origin`                 AS `Made_By_Or_Origin`,
    `SF`.`FlyF_Comments`                     AS `FlyF_Comments`,
    `SF`.`Stock_Name`                        AS `Stock_Name`,
    `SF`.`OtherNameOrIdentifier2_StockName`  AS `OtherNameOrIdentifier2_StockName`,
    `SF`.`BL_NUM`                            AS `BL_NUM`,
    `SF`.`CopyA`                             AS `CopyA`,
    `SF`.`CopyB`                             AS `CopyB`,
    `SF`.`Rehab_A`                           AS `Rehab_A`,
    `SF`.`Rehab_B`                           AS `Rehab_B`,
    `SF`.`Balancer`                          AS `stock_balancer`,
    `SF`.`Lab_ID`                            AS `Lab_ID`,
    `SF`.`User_Comments`                     AS `User_Comments`,
    `SF`.`RT`                                AS `RT`,
    `SF`.`CG`                                AS `CG`,
    `SF`.`Gene_Synonym`                      AS `Gene_Synonym`,
    `SF`.`Hide`                              AS `Hide`,
    `SF`.`Project`                           AS `stock_project`,
    `SF`.`Old_RobotID`                       AS `Old_RobotID`,
    `SF`.`Date_Added`                        AS `Date_Added`,
    `SF`.`VIEW`                              AS `VIEW`,
    `SF`.`StocknumPrint`                     AS `StocknumPrint`,
    `SF`.`Search_Field`                      AS `Search_Field`,
    `SF`.`Search_Term`                       AS `Search_Term`,
    `SF`.`Production_Info`                   AS `Production_Info`,
    `SF`.`temp_genotype`                     AS `temp_genotype`,
    `SF`.`NEW`                               AS `NEW`,
    `SF`.`temp_robot`                        AS `temp_robot`,
    `SF`.`Member_OR_Requester`               AS `Member_OR_Requester`,
    `SF`.`Exit_Quarantine`                   AS `Exit_Quarantine`,
    `SF`.`VDRC`                              AS `VDRC`,
    `SF`.`Updating`                          AS `Updating`,
    `SF`.`StockConstruction`                 AS `StockConstruction`,
    `SF`.`Quarantine`                        AS `Quarantine`,
    `SF`.`Bottles`                           AS `Bottles`,
    `SF`.`On_Robot`                          AS `On_Robot`,
    `SF`.`Generic_Find`                      AS `Generic_Find`,
    `SF`.`Doe`                               AS `Doe`,
    `SF`.`__OR__Finder`                      AS `__OR__Finder`,
    `SF`.`Quality_Control`                   AS `Quality_Control`,
    `SF`.`SelectField`                       AS `SelectField`,
    `SF`.`Exit_JFRC`                         AS `Exit_JFRC`,
    `SF`.`Exit_Notes`                        AS `Exit_Notes`,
    `SF`.`Active`                            AS `Active`,
    `SF`.`SignIn`                            AS `SignIn`,
    `SF`.`CleanUP_PreferredNameChange`       AS `CleanUP_PreferredNameChange`,
    `SF`.`KeepDiscard`                       AS `KeepDiscard`,
    `SF`.`KeepDiscardNotes`                  AS `KeepDiscardNotes`,
    `SF`.`Total_Stock_COunt`                 AS `Total_Stock_COunt`,
    `PCS`.`handler_sorting_FB`               AS `handler_sorting_FB`,
    `PCS`.`handler_sorting_BOX`              AS `handler_sorting_BOX`,
    `PCS`.`handler_sorting_DAM`              AS `handler_sorting_DAM`,
    `PCS`.`handler_sorting_GC`               AS `handler_sorting_GC`,
    `PCS`.`handler_sorting_AGGR`             AS `handler_sorting_AGGR`,
    `PCS`.`handler_sorting_GRAV`             AS `handler_sorting_GRAV`,
    `PCS`.`handler_sorting_OBS`              AS `handler_sorting_OBS`,
    `PCS`.`handler_sorting_STER`             AS `handler_sorting_STER`,
    `PCS`.`handler_starvation_FB`            AS `handler_starvation_FB`,
    `PCS`.`handler_cross`                    AS `handler_cross`,
    `PCS`.`handler_sorting_FB_DateTime`      AS `handler_sorting_FB_DateTime`,
    `PCS`.`handler_sorting_BOX_DateTime`     AS `handler_sorting_BOX_DateTime`,
    `PCS`.`handler_sorting_DAM_DateTime`     AS `handler_sorting_DAM_DateTime`,
    `PCS`.`handler_sorting_GC_DateTime`      AS `handler_sorting_GC_DateTime`,
    `PCS`.`handler_sorting_AGGR_DateTime`    AS `handler_sorting_AGGR_DateTime`,
    `PCS`.`handler_sorting_GRAV_DateTime`    AS `handler_sorting_GRAV_DateTime`,
    `PCS`.`handler_sorting_OBS_DateTime`     AS `handler_sorting_OBS_DateTime`,
    `PCS`.`handler_sorting_STER_DateTime`    AS `handler_sorting_STER_DateTime`,
    `PCS`.`handler_starvation_FB_DateTime`   AS `handler_starvation_FB_DateTime`,
    -- Find the correct bottle for the date_crossed (the most recent one added on or before the date crossed)
    (
        SELECT
            `lc`.`Bottle_Number` AS `Bottle_Number`
        FROM
            `Labels_Common_FO` `lc`
        WHERE
            (
                (
                    `R`.`Barcode` = `lc`.`robot_id`
                )
            AND
                (
                    `lc`.`label_id` = _latin1'Bottles'
                )
            AND
                (
                    `lc`.`Date_Added` =
                    (
                        SELECT
                            MAX(`lc2`.`Date_Added`) AS `max(``lc2``.``Date_Added``)`
                        FROM
                            `Labels_Common_FO` `lc2`
                        WHERE
                            (
                                (
                                    `R`.`Barcode` = `lc2`.`robot_id`
                                )
                            AND
                                (
                                    `lc2`.`label_id` = _latin1'Bottles'
                                )
                            AND
                                (
                                    `lc2`.`Date_Added` <= `PC`.`Date_Crossed`
                                )
                            )
                    )
                )
            )
            limit 1
    ) AS `bottle_number`
FROM
    (((`Project_Crosses_FO` `PC`
JOIN `StockFinder_FO` `SF`
ON
    (
        (
            `SF`.`__kp_UniqueID` = `PC`.`_kf_Parent_UID`
        )
    )
    )
JOIN `Reporter_FO` `R`
ON
    (
        (
            `PC`.`Reporter` = `R`.`Label_Name`
        )
    )
    )
LEFT JOIN `project_crosses_suppl_FO` `PCS`
ON
    (
        (
            `PCS`.`fk_project_crosses_id` = `PC`.`__kp_ProjectCrosses_Serial_Number`
        )
    )
    )
WHERE
    (
        (
            `PC`.`Project` in (_latin1'Fly Olympiad', _latin1'Other')
        )
    )
ORDER BY
    CAST(`PC`.`Wish_List` AS DECIMAL(10,0)),
    `PC`.`Reporter`;


ALTER TABLE
    project_crosses_expanded_temp ADD PRIMARY KEY (__kp_ProjectCrosses_Serial_Number);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix1 (RobotID);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix2 (Wish_List);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix3 (Date_Crossed);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix4 (Reporter);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix5 (Project);
ALTER TABLE
    project_crosses_expanded_temp ADD INDEX ix6 (Barcode_CrossSerialNumber);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS project_crosses_expanded_mv;
RENAME TABLE project_crosses_expanded_temp TO project_crosses_expanded_mv;

-- =================================================== 
-- create API view
-- =================================================== 
CREATE OR REPLACE VIEW project_crosses_expanded_vw AS
SELECT *
FROM project_crosses_expanded_mv;

