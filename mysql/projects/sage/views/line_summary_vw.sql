CREATE OR REPLACE VIEW line_summary_vw AS
SELECT line_vw.name               AS line
      ,gene                       AS gene
      ,synonyms                   AS synonyms
      ,genotype                   AS genotype
      ,lab_display_name           AS lab
      ,getLineSummaryString(name) AS sessions
      ,getLineExperimentSummaryString(name) AS experiments
FROM line_vw;
