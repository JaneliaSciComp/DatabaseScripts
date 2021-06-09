#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "compiling cross_event_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cross_event_vw.sql
echo "compiling cv_relationship_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cv_relationship_vw.sql
echo "compiling cv_term_relationship_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cv_term_relationship_vw.sql
echo "compiling cv_term_to_table_mapping_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cv_term_to_table_mapping_vw.sql
echo "compiling cv_term_validation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cv_term_validation_vw.sql
echo "compiling cv_term_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < cv_term_vw.sql
echo "compiling data_set_family_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < data_set_family_vw.sql
echo "compiling data_set_field_value_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < data_set_field_value_vw.sql
echo "compiling data_set_field_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < data_set_field_vw.sql
echo "compiling data_set_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < data_set_vw.sql
echo "compiling disk_usage_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < disk_usage_vw.sql
echo "compiling event_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < event_property_vw.sql
echo "compiling event_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < event_vw.sql
echo "compiling experiment_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < experiment_property_vw.sql
echo "compiling experiment_relationship_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < experiment_relationship_vw.sql
echo "compiling experiment_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < experiment_vw.sql
echo "compiling gene_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < gene_data_mv.sql
echo "compiling grooming_observation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < grooming_observation_vw.sql
echo "compiling grooming_score_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < grooming_score_vw.sql
echo "compiling image_gene_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < image_gene_vw.sql
echo "compiling image_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < image_property_vw.sql
echo "compiling image_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < image_vw.sql
echo "compiling lab_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < lab_vw.sql
echo "compiling larval_sage_stats_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < larval_sage_stats_mv.sql
echo "compiling line_event_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_event_property_vw.sql
echo "compiling line_experiment_type_unique_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_experiment_type_unique_vw.sql
echo "compiling line_experiment_type_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_experiment_type_vw.sql
echo "compiling line_experiment_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_experiment_vw.sql
echo "compiling line_gene_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_gene_vw.sql
echo "compiling line_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_property_vw.sql
echo "compiling line_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_vw.sql
echo "compiling line_session_type_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_session_type_vw.sql
echo "compiling line_summary_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < line_summary_vw.sql
echo "compiling observation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < observation_vw.sql
echo "compiling olympiad_aggression_analysis_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_analysis_session_vw.sql
echo "compiling olympiad_aggression_arena_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_arena_vw.sql
echo "compiling olympiad_aggression_chamber_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_chamber_vw.sql
echo "compiling olympiad_aggression_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_experiment_data_mv.sql
echo "compiling olympiad_bowl_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_bowl_experiment_data_mv.sql
echo "compiling olympiad_box_analysis_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_analysis_session_property_vw.sql
echo "compiling olympiad_box_analysis_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_analysis_session_vw.sql
echo "compiling olympiad_box_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_experiment_data_mv.sql
echo "compiling olympiad_box_sbfmf_stat_score_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_sbfmf_stat_score_vw.sql
echo "compiling olympiad_box_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_session_property_vw.sql
echo "compiling olympiad_climbing_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_climbing_experiment_data_mv.sql
echo "compiling olympiad_experiment_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_experiment_property_vw.sql
echo "compiling olympiad_box_experiment_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_experiment_property_vw.sql
echo "compiling olympiad_experiment_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_experiment_vw.sql
echo "compiling olympiad_gap_analysis_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_analysis_vw.sql
echo "compiling olympiad_gap_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_experiment_data_mv.sql
echo "compiling olympiad_gap_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_session_vw.sql
echo "compiling olympiad_gap_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_session_property_vw.sql
echo "compiling olympiad_gap_analysis_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_analysis_session_property_vw.sql
echo "compiling olympiad_lethality_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_lethality_session_vw.sql
echo "compiling olympiad_gap_analysis_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_gap_analysis_session_vw.sql
echo "compiling olympiad_line_level_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_line_level_vw.sql
echo "compiling olympiad_observation_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_observation_experiment_data_mv.sql
echo "compiling olympiad_observation_observation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_observation_observation_vw.sql
echo "compiling olympiad_region_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_region_property_vw.sql
echo "compiling olympiad_region_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_region_vw.sql
echo "compiling olympiad_runs_unique_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_runs_unique_mv.sql
echo "compiling olympiad_score_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_score_vw.sql
echo "compiling olympiad_sequence_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_sequence_property_vw.sql
echo "compiling olympiad_sequence_vw.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_sequence_vw.sql
echo "compiling olympiad_sterility_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_sterility_experiment_data_mv.sql
echo "compiling olympiad_sterility_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_sterility_session_property_vw.sql
echo "compiling olympiad_sterility_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_sterility_session_vw.sql
echo "compiling olympiad_trikinetics_experiment_data_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_trikinetics_experiment_data_mv.sql
echo "compiling olympiad_trikinetics_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_trikinetics_session_vw.sql
echo "compiling olympiad_trikinetics_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_trikinetics_session_property_vw.sql
echo "compiling olympiad_trikinetics_analysis_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_trikinetics_analysis_session_property_vw.sql
echo "compiling olympiad_trikinetics_analysis_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_trikinetics_analysis_session_vw.sql
echo "compiling phase_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < phase_property_vw.sql
echo "compiling phase_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < phase_vw.sql
echo "compiling prelim_annotation_observation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < prelim_annotation_observation_vw.sql
echo "compiling prelim_annotation_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < prelim_annotation_session_vw.sql
echo "compiling prelim_annotation_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < prelim_annotation_vw.sql
echo "compiling rubin_lab_external_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < rubin_lab_external_property_vw.sql
echo "compiling rubin_lab_external_vw "
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < rubin_lab_external_vw.sql
echo "compiling sage_stats_mv"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < sage_stats_mv.sql
echo "compiling sageapi_test_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < sageapi_test_vw.sql
echo "compiling score_array_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < score_array_vw.sql
echo "compiling score_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < score_vw.sql
echo "compiling secondary_image_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < secondary_image_vw.sql
echo "compiling session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < session_property_vw.sql
echo "compiling session_relationship_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < session_relationship_vw.sql
echo "compiling session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < session_vw.sql
echo "compiling olympiad_box_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_box_session_vw.sql
echo "compiling olympiad_aggression_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_session_vw.sql
echo "compiling olympiad_aggression_analysis_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_analysis_session_property_vw.sql
echo "compiling olympiad_aggression_session_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < olympiad_aggression_session_property_vw.sql
echo "compiling simpson_gal4_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_gal4_vw.sql
echo "compiling simpson_image_class_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_image_class_vw.sql
echo "compiling simpson_image_property_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_image_property_vw.sql
echo "compiling simpson_image_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_image_vw.sql
echo "compiling simpson_pe_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_pe_vw.sql
echo "simpson_rep_image_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < simpson_rep_image_vw.sql
echo "compiling ipcr_session_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ipcr_session_vw.sql
echo "compiling ipcr_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ipcr_vw.sql
echo "compiling image_data_vw"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < image_data_vw.sql
