--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
--
-- Name: a_spliced_intron; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW a_spliced_intron AS
    SELECT feature.feature_id AS a_spliced_intron_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60253);


--
-- Name: af_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW af_type AS
    SELECT f.feature_id, f.name, f.uniquename, f.dbxref_id, c.name AS "type", f.residues, f.seqlen, f.md5checksum, f.type_id, f.organism_id, af.analysis_id, f.timeaccessioned, f.timelastmodified FROM feature f, analysisfeature af, cvterm c WHERE ((f.type_id = c.cvterm_id) AND (f.feature_id = af.feature_id));


--
-- Name: tfeature; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tfeature AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, cvterm.name AS "type" FROM (feature JOIN cvterm ON ((feature.type_id = cvterm.cvterm_id)));


--
-- Name: fragf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragf AS
    SELECT tfeature.feature_id, tfeature.dbxref_id, tfeature.organism_id, tfeature.name, tfeature.uniquename, tfeature.residues, tfeature.seqlen, tfeature.md5checksum, tfeature.type_id, tfeature.is_analysis, tfeature.timeaccessioned, tfeature.timelastmodified, tfeature."type" FROM tfeature WHERE ((tfeature."type")::text = 'tiling_path_fragment'::text);


--
-- Name: afragf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW afragf AS
    SELECT fragf.feature_id, fragf.dbxref_id, fragf.organism_id, fragf.name, fragf.uniquename, fragf.residues, fragf.seqlen, fragf.md5checksum, fragf.type_id, fragf.is_analysis, fragf.timeaccessioned, fragf.timelastmodified, fragf."type" FROM fragf WHERE (fragf.is_analysis = false);


--
-- Name: afragf_mirror; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW afragf_mirror AS
    SELECT f1.feature_id AS feature_id1, f2.feature_id AS feature_id2, f1.uniquename AS n1, f2.uniquename AS n2, l1.strand AS strand1, l2.strand AS strand2, l1.fmin, l1.fmax FROM (((afragf f1 JOIN featureloc l1 ON ((f1.feature_id = l1.feature_id))) JOIN featureloc l2 ON ((((l1.fmin = l2.fmin) AND (l1.fmax = l2.fmax)) AND (l1.srcfeature_id = l2.srcfeature_id)))) JOIN afragf f2 ON ((l2.feature_id = f2.feature_id))) WHERE (f1.feature_id <> f2.feature_id);


--
-- Name: rfragf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rfragf AS
    SELECT fragf.feature_id, fragf.dbxref_id, fragf.organism_id, fragf.name, fragf.uniquename, fragf.residues, fragf.seqlen, fragf.md5checksum, fragf.type_id, fragf.is_analysis, fragf.timeaccessioned, fragf.timelastmodified, fragf."type" FROM fragf WHERE (fragf.is_analysis = true);


--
-- Name: afragf_rfragf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW afragf_rfragf AS
    SELECT afragf.uniquename, aloc.fmin AS afmin, aloc.fmax AS afmax, rloc.fmin AS rfmin, rloc.fmax AS rfmax FROM (((afragf JOIN rfragf USING (uniquename)) JOIN featureloc aloc ON ((afragf.feature_id = aloc.feature_id))) JOIN featureloc rloc ON ((rfragf.feature_id = rloc.feature_id)));


--
-- Name: afragf_wm; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW afragf_wm AS
    SELECT afragf.feature_id, afragf.uniquename, aloc.fmin AS afmin, aloc.fmax AS afmax, rfragf.uniquename AS rfragf_uniquename FROM (((afragf JOIN featureloc aloc ON ((afragf.feature_id = aloc.feature_id))) JOIN featureloc rloc ON ((((aloc.fmin = rloc.fmin) AND (aloc.fmax = rloc.fmax)) AND (aloc.srcfeature_id = rloc.srcfeature_id)))) JOIN rfragf ON ((rloc.feature_id = rfragf.feature_id)));


--
-- Name: alignment_evidence; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW alignment_evidence AS
    SELECT (((((anchor.feature_id)::text || ':'::text) || (fr.object_id)::text) || ':'::text) || (af.analysis_id)::text) AS alignment_evidence_id, anchor.feature_id, fr.object_id AS evidence_id, af.analysis_id FROM featureloc anchor, analysisfeature af, feature_relationship fr, featureloc hsploc WHERE (((((anchor.srcfeature_id = hsploc.srcfeature_id) AND (anchor.strand = hsploc.strand)) AND (hsploc.feature_id = af.feature_id)) AND (hsploc.feature_id = fr.subject_id)) AND ((hsploc.fmin <= anchor.fmax) AND (hsploc.fmax >= anchor.fmin))) GROUP BY anchor.feature_id, fr.object_id, af.analysis_id;

--
-- Name: antisense_primary_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW antisense_primary_transcript AS
    SELECT feature.feature_id AS antisense_primary_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60310);


--
-- Name: antisense_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW antisense_rna AS
    SELECT feature.feature_id AS antisense_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60309);


--
-- Name: ars; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW ars AS
    SELECT feature.feature_id AS ars_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60101);


--
-- Name: assembly; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW assembly AS
    SELECT feature.feature_id AS assembly_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60018);

--
-- Name: assembly_component; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW assembly_component AS
    SELECT feature.feature_id AS assembly_component_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59808);


--
-- Name: attenuator; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW attenuator AS
    SELECT feature.feature_id AS attenuator_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59805);

--
-- Name: binding_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW binding_site AS
    SELECT feature.feature_id AS binding_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60074);


--
-- Name: branch_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW branch_site AS
    SELECT feature.feature_id AS branch_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60276);


--
-- Name: cap; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cap AS
    SELECT feature.feature_id AS cap_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60246);


--
-- Name: cdna_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cdna_match AS
    SELECT feature.feature_id AS cdna_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60354);


--
-- Name: cds; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cds AS
    SELECT feature.feature_id AS cds_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59981);


--
-- Name: centromere; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW centromere AS
    SELECT feature.feature_id AS centromere_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60242);


--
-- Name: chromosomal_structural_element; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW chromosomal_structural_element AS
    SELECT feature.feature_id AS chromosomal_structural_element_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60293);


--
-- Name: chromosome; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW chromosome AS
    SELECT feature.feature_id AS chromosome_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60005);


--
-- Name: clip; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW clip AS
    SELECT feature.feature_id AS clip_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59968);


--
-- Name: clone; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW clone AS
    SELECT feature.feature_id AS clone_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59816);


--
-- Name: clone_end; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW clone_end AS
    SELECT feature.feature_id AS clone_end_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59768);


--
-- Name: clone_start; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW clone_start AS
    SELECT feature.feature_id AS clone_start_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59844);


--
-- Name: codon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW codon AS
    SELECT feature.feature_id AS codon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60025);


--
-- Name: complex_substitution; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW complex_substitution AS
    SELECT feature.feature_id AS complex_substitution_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60438);


--
-- Name: contig; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW contig AS
    SELECT feature.feature_id AS contig_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59814);


--
-- Name: cpg_island; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cpg_island AS
    SELECT feature.feature_id AS cpg_island_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59972);


--
-- Name: cross_genome_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cross_genome_match AS
    SELECT feature.feature_id AS cross_genome_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59842);


--
-- Name: cvterm_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW cvterm_type AS
    SELECT cvt.cvterm_id, cvt.name, cv.name AS termtype FROM cvterm cvt, cv WHERE (cvt.cv_id = cv.cv_id);

--
-- Name: databank_entry; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW databank_entry AS
    SELECT feature.feature_id AS databank_entry_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60645);

--
-- Name: dbxrefd; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW dbxrefd AS
    SELECT dbxref.dbxref_id, dbxref.db_id, dbxref.accession, dbxref.version, dbxref.description, db.name AS dbname, (((db.name)::text || ':'::text) || (dbxref.accession)::text) AS dbxrefstr FROM (dbxref JOIN db USING (db_id));

--
-- Name: decayed_exon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW decayed_exon AS
    SELECT feature.feature_id AS decayed_exon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60129);


--
-- Name: deletion; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW deletion AS
    SELECT feature.feature_id AS deletion_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59824);


--
-- Name: deletion_junction; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW deletion_junction AS
    SELECT feature.feature_id AS deletion_junction_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60352);

--
-- Name: direct_repeat; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW direct_repeat AS
    SELECT feature.feature_id AS direct_repeat_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59979);


--
-- Name: dispersed_repeat; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW dispersed_repeat AS
    SELECT feature.feature_id AS dispersed_repeat_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60323);


--
-- Name: duplicate_feature_dbxref; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW duplicate_feature_dbxref AS
    SELECT x1.feature_dbxref_id, x1.feature_id, x1.dbxref_id, x1.is_current, x2.feature_dbxref_id AS x2_id FROM (feature_dbxref x1 JOIN feature_dbxref x2 USING (feature_id, dbxref_id)) WHERE (x1.feature_dbxref_id <> x2.feature_dbxref_id);


--
-- Name: duplicate_feature_dbxref_lo; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW duplicate_feature_dbxref_lo AS
    SELECT x1.feature_dbxref_id, x1.feature_id, x1.dbxref_id, x1.is_current, x2.feature_dbxref_id AS x2_id FROM (feature_dbxref x1 JOIN feature_dbxref x2 USING (feature_id, dbxref_id)) WHERE (x1.feature_dbxref_id < x2.feature_dbxref_id);


--
-- Name: enhancer; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW enhancer AS
    SELECT feature.feature_id AS enhancer_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59830);

--
-- Name: enzymatic_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW enzymatic_rna AS
    SELECT feature.feature_id AS enzymatic_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60037);


--
-- Name: est; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW est AS
    SELECT feature.feature_id AS est_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60010);


--
-- Name: est_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW est_match AS
    SELECT feature.feature_id AS est_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60333);


--
-- Name: exon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW exon AS
    SELECT feature.feature_id AS exon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59812);


--
-- Name: exon_junction; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW exon_junction AS
    SELECT feature.feature_id AS exon_junction_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59998);


--
-- Name: experimental_result_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW experimental_result_region AS
    SELECT feature.feature_id AS experimental_result_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60368);


--
-- Name: expressed_sequence_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW expressed_sequence_match AS
    SELECT feature.feature_id AS expressed_sequence_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59767);


--
-- Name: f_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW f_type AS
    SELECT f.feature_id, f.name, f.uniquename, f.dbxref_id, c.name AS "type", f.residues, f.seqlen, f.md5checksum, f.type_id, f.organism_id, f.is_analysis, f.timeaccessioned, f.timelastmodified FROM feature f, cvterm c WHERE (f.type_id = c.cvterm_id);


--
-- Name: f_loc; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW f_loc AS
    SELECT f.feature_id, f.name, f.dbxref_id, fl.fmin, fl.fmax, fl.strand FROM featureloc fl, f_type f WHERE (f.feature_id = fl.feature_id);


--
-- Name: feature2x; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature2x AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, feature.is_obsolete, feature_dbxref.is_current, dbxrefd.dbname, dbxrefd.accession, dbxrefd.version FROM ((feature JOIN feature_dbxref USING (feature_id)) JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id)));

--
-- Name: featurepropt; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featurepropt AS
    SELECT featureprop.featureprop_id, featureprop.feature_id, featureprop.type_id, featureprop.value, featureprop.rank, cvterm.name AS "type" FROM (featureprop JOIN cvterm ON ((featureprop.type_id = cvterm.cvterm_id)));


--
-- Name: feature_annotation_symbol; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_annotation_symbol AS
    SELECT featurepropt.feature_id, featurepropt.value AS annotation_symbol FROM featurepropt WHERE ((featurepropt."type")::text = 'annotation_symbol'::text);


--
-- Name: feature_barcode; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_barcode AS
    SELECT featurepropt.feature_id, featurepropt.value AS barcode, featurepropt.rank FROM featurepropt WHERE ((featurepropt."type")::text = 'biomicrolab'::text);


--
-- Name: feature_cell_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_cell_type AS
    SELECT featurepropt.feature_id, featurepropt.value AS cell_type FROM featurepropt WHERE ((featurepropt."type")::text = 'cell_type'::text);


--
-- Name: feature_contains; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_contains AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((y.fmin >= x.fmin) AND (y.fmin <= x.fmax)));


--
-- Name: VIEW feature_contains; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_contains IS 'subject intervals contains (or is
same as) object interval. transitive,reflexive';

--
-- Name: feature_difference; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_difference AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id, x.strand AS srcfeature_id, x.srcfeature_id AS fmin, x.fmin AS fmax, y.fmin AS strand FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmin < y.fmin) AND (x.fmax >= y.fmax))) UNION SELECT x.feature_id AS subject_id, y.feature_id AS object_id, x.strand AS srcfeature_id, x.srcfeature_id AS fmin, y.fmax, x.fmax AS strand FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax > y.fmax) AND (x.fmin <= y.fmin)));


--
-- Name: VIEW feature_difference; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_difference IS 'size of gap between two features. must be abutting or disjoint';


--
-- Name: feature_disjoint; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_disjoint AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax < y.fmin) AND (x.fmin > y.fmax)));


--
-- Name: VIEW feature_disjoint; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_disjoint IS 'featurelocs do not meet. symmetric';


--
-- Name: feature_distance; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_distance AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id, x.srcfeature_id, x.strand AS subject_strand, y.strand AS object_strand, CASE WHEN (x.fmax <= y.fmin) THEN (x.fmax - y.fmin) ELSE (y.fmax - x.fmin) END AS distance FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax <= y.fmin) OR (x.fmin >= y.fmax)));


--
-- Name: feature_gateway_clone; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_gateway_clone AS
    SELECT featurepropt.feature_id, featurepropt.value AS gateway_clone FROM featurepropt WHERE ((featurepropt."type")::text = 'gateway_clone'::text);


--
-- Name: feature_intersection; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_intersection AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id, x.srcfeature_id, x.strand AS subject_strand, y.strand AS object_strand, CASE WHEN (x.fmin < y.fmin) THEN y.fmin ELSE x.fmin END AS fmin, CASE WHEN (x.fmax > y.fmax) THEN y.fmax ELSE x.fmax END AS fmax FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax >= y.fmin) AND (x.fmin <= y.fmax)));


--
-- Name: VIEW feature_intersection; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_intersection IS 'set-intersection on interval defined by featureloc. featurelocs must meet';


--
-- Name: feature_labtrack_dbxref; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_labtrack_dbxref AS
    SELECT feature_dbxref.feature_id, dbxrefd.dbxref_id, dbxrefd.db_id, dbxrefd.accession, dbxrefd.version, dbxrefd.description, dbxrefd.dbname, dbxrefd.dbxrefstr FROM (feature_dbxref JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id))) WHERE ((dbxrefd.dbname)::text = 'LabTrack'::text);


--
-- Name: feature_left_seq; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_left_seq AS
    SELECT featurepropt.feature_id, featurepropt.value AS left_seq FROM featurepropt WHERE ((featurepropt."type")::text = 'left_seq'::text);


--
-- Name: feature_meets; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_meets AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax >= y.fmin) AND (x.fmin <= y.fmax)));


--
-- Name: VIEW feature_meets; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_meets IS 'intervals have at least one
interbase point in common (ie overlap OR abut). symmetric,reflexive';


--
-- Name: feature_meets_on_same_strand; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_meets_on_same_strand AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id FROM featureloc x, featureloc y WHERE (((x.srcfeature_id = y.srcfeature_id) AND (x.strand = y.strand)) AND ((x.fmax >= y.fmin) AND (x.fmin <= y.fmax)));


--
-- Name: VIEW feature_meets_on_same_strand; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_meets_on_same_strand IS 'as feature_meets, but
featurelocs must be on the same strand. symmetric,reflexive';


--
-- Name: feature_owner; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_owner AS
    SELECT featurepropt.feature_id, featurepropt.value AS "owner" FROM featurepropt WHERE ((featurepropt."type")::text = 'owner'::text);


--
-- Name: feature_pcr_clone_id; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_pcr_clone_id AS
    SELECT feature_dbxref.feature_id, dbxrefd.accession AS pcr_clone_id FROM (feature_dbxref JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id))) WHERE ((dbxrefd.dbname)::text = 'LabTrack'::text);


--
-- Name: feature_priority; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_priority AS
    SELECT featurepropt.feature_id, featurepropt.value AS priority FROM featurepropt WHERE ((featurepropt."type")::text = 'priority'::text);


--
-- Name: feature_rearray_plate; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_rearray_plate AS
    SELECT featurepropt.feature_id, featurepropt.value AS plate FROM featurepropt WHERE ((featurepropt."type")::text = 'rearray_plate'::text);


--
-- Name: feature_rearray_well; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_rearray_well AS
    SELECT featurepropt.feature_id, featurepropt.value AS well FROM featurepropt WHERE ((featurepropt."type")::text = 'rearray_well'::text);

--
-- Name: feature_right_seq; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_right_seq AS
    SELECT featurepropt.feature_id, featurepropt.value AS right_seq FROM featurepropt WHERE ((featurepropt."type")::text = 'right_seq'::text);


--
-- Name: feature_seq_oriented; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_seq_oriented AS
    SELECT featurepropt.feature_id, featurepropt.value AS seq_oriented FROM featurepropt WHERE ((featurepropt."type")::text = 'seq_oriented'::text);

--
-- Name: feature_transformant; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_transformant AS
    SELECT t.feature_id, t.transformant, t.fragment_id, t.status, t."type", f.plate, f.well, f.annotation_symbol, f.priority FROM (SELECT fp.feature_id, f.name AS transformant, max(CASE WHEN ((c2.name)::text = 'tiling_path_fragment_id'::text) THEN fp.value ELSE NULL::text END) AS fragment_id, max(CASE WHEN ((c2.name)::text = 'owner'::text) THEN fp.value ELSE NULL::text END) AS status, max(CASE WHEN ((c2.name)::text = 'transformant_type'::text) THEN fp.value ELSE NULL::text END) AS "type" FROM feature f, cvterm c, featureprop fp, cvterm c2 WHERE ((((f.type_id = c.cvterm_id) AND ((c.name)::text = 'transformant'::text)) AND (f.feature_id = fp.feature_id)) AND (fp.type_id = c2.cvterm_id)) GROUP BY fp.feature_id, f.name) t, (SELECT f.feature_id, max(CASE WHEN ((c2.name)::text = 'rearray_plate'::text) THEN fp.value ELSE NULL::text END) AS plate, max(CASE WHEN ((c2.name)::text = 'rearray_well'::text) THEN fp.value ELSE NULL::text END) AS well, max(CASE WHEN ((c2.name)::text = 'annotation_symbol'::text) THEN fp.value ELSE NULL::text END) AS annotation_symbol, max(CASE WHEN ((c2.name)::text = 'priority'::text) THEN fp.value ELSE NULL::text END) AS priority FROM feature f, cvterm c, featureprop fp, cvterm c2 WHERE ((((f.type_id = c.cvterm_id) AND ((c.name)::text = 'tiling_path_fragment'::text)) AND (f.feature_id = fp.feature_id)) AND (fp.type_id = c2.cvterm_id)) GROUP BY f.feature_id) f WHERE (t.fragment_id = (f.feature_id)::text);


--
-- Name: feature_transformant_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_transformant_type AS
    SELECT featurepropt.feature_id, featurepropt.value AS transformant_type FROM featurepropt WHERE ((featurepropt."type")::text = 'transformant_type'::text);


--
-- Name: feature_union; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW feature_union AS
    SELECT x.feature_id AS subject_id, y.feature_id AS object_id, x.srcfeature_id, x.strand AS subject_strand, y.strand AS object_strand, CASE WHEN (x.fmin < y.fmin) THEN x.fmin ELSE y.fmin END AS fmin, CASE WHEN (x.fmax > y.fmax) THEN x.fmax ELSE y.fmax END AS fmax FROM featureloc x, featureloc y WHERE ((x.srcfeature_id = y.srcfeature_id) AND ((x.fmax >= y.fmin) AND (x.fmin <= y.fmax)));


--
-- Name: VIEW feature_union; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW feature_union IS 'set-union on interval defined by featureloc. featurelocs must meet';


--
-- Name: featurefl; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featurefl AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, featureloc.featureloc_id, featureloc.srcfeature_id, featureloc.fmin, featureloc.fmax, featureloc.strand, featureloc.is_fmin_partial, featureloc.is_fmax_partial, featureloc.phase, featureloc.residue_info, featureloc.locgroup, featureloc.rank FROM (feature JOIN featureloc USING (feature_id)) WHERE ((featureloc.rank = 0) AND (featureloc.locgroup = 0));


--
-- Name: featureflf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featureflf AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, featureloc.featureloc_id, featureloc.srcfeature_id, featureloc.fmin, featureloc.fmax, featureloc.is_fmin_partial, featureloc.is_fmax_partial, featureloc.strand, featureloc.phase, featureloc.residue_info, featureloc.locgroup, featureloc.rank, srcfeature.feature_id AS srcf_feature_id, srcfeature.name AS srcf_name, srcfeature.uniquename AS srcf_uniquename, srcfeature.organism_id AS srcf_organism_id, srcfeature.type_id AS srcf_type_id FROM ((feature JOIN featureloc ON ((feature.feature_id = featureloc.feature_id))) JOIN feature srcfeature ON ((featureloc.srcfeature_id = srcfeature.feature_id))) WHERE ((featureloc.rank = 0) AND (featureloc.locgroup = 0));


--
-- Name: featureloc_allcoords; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featureloc_allcoords AS
    SELECT featureloc.featureloc_id, featureloc.feature_id, featureloc.srcfeature_id, featureloc.fmin, featureloc.is_fmin_partial, featureloc.fmax, featureloc.is_fmax_partial, featureloc.strand, featureloc.phase, featureloc.residue_info, featureloc.locgroup, featureloc.rank, (featureloc.fmin + 1) AS gbeg, featureloc.fmax AS gend, CASE WHEN (featureloc.strand = -1) THEN (- featureloc.fmax) ELSE featureloc.fmin END AS nbeg, CASE WHEN (featureloc.strand = -1) THEN (- featureloc.fmin) ELSE featureloc.fmax END AS nend FROM featureloc;


--
-- Name: featurelocf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featurelocf AS
    SELECT featureloc.featureloc_id, featureloc.feature_id, featureloc.srcfeature_id, featureloc.fmin, featureloc.is_fmin_partial, featureloc.fmax, featureloc.is_fmax_partial, featureloc.strand, featureloc.phase, featureloc.residue_info, featureloc.locgroup, featureloc.rank, feature.name AS srcname, feature.uniquename AS srcuniquename FROM (featureloc JOIN feature ON ((featureloc.srcfeature_id = feature.feature_id)));


--
-- Name: featurepair; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featurepair AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, fl1.srcfeature_id, fl1.fmin, fl1.fmax, fl1.strand, fl1.phase, fl2.srcfeature_id AS tsrcfeature_id, fl2.fmin AS tfmin, fl2.fmax AS tfmax, fl2.strand AS tstrand, fl2.phase AS tphase FROM ((feature JOIN featureloc fl1 USING (feature_id)) JOIN featureloc fl2 USING (feature_id)) WHERE ((((fl1.rank = 0) AND (fl2.rank = 0)) AND (fl1.locgroup = 0)) AND (fl2.locgroup = 0));


--
-- Name: featurepropd; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featurepropd AS
    SELECT featureprop.featureprop_id, featureprop.feature_id, featureprop.type_id, featureprop.value, featureprop.rank, cvterm.name AS "type" FROM (featureprop JOIN cvterm ON ((featureprop.type_id = cvterm.cvterm_id)));


--
-- Name: featuresyn; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW featuresyn AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, feature.is_obsolete, feature_synonym.pub_id, feature_synonym.is_current, feature_synonym.is_internal, synonym.synonym_id, synonym.type_id AS synonym_type_id, synonym.name AS synonym_name, synonym.synonym_sgml FROM ((feature JOIN feature_synonym USING (feature_id)) JOIN synonym USING (synonym_id));


--
-- Name: five_prime_utr; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW five_prime_utr AS
    SELECT feature.feature_id AS five_prime_utr_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59869);


--
-- Name: flanking_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW flanking_region AS
    SELECT feature.feature_id AS flanking_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59904);


--
-- Name: fnr_type; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fnr_type AS
    SELECT f.feature_id, f.name, f.uniquename, f.dbxref_id, c.name AS "type", f.residues, f.seqlen, f.md5checksum, f.type_id, f.organism_id, f.timeaccessioned, f.timelastmodified FROM (feature f LEFT JOIN analysisfeature af ON ((f.feature_id = af.feature_id))), cvterm c WHERE ((f.type_id = c.cvterm_id) AND (af.feature_id IS NULL));


--
-- Name: fp_key; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fp_key AS
    SELECT fp.featureprop_id, fp.feature_id, c.name AS "type", fp.value FROM featureprop fp, cvterm c WHERE (fp.type_id = c.cvterm_id);


--
-- Name: fragment_accession_cg; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_accession_cg AS
    SELECT feature_dbxref.feature_id, dbxrefd.accession FROM (feature_dbxref JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id))) WHERE ((dbxrefd.dbname)::text = 'Gadfly'::text);


--
-- Name: fragment_barcode; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_barcode AS
    SELECT tfeature.feature_id, tfeature.dbxref_id, tfeature.organism_id, tfeature.name, tfeature.uniquename, tfeature.residues, tfeature.seqlen, tfeature.md5checksum, tfeature.type_id, tfeature.is_analysis, tfeature.timeaccessioned, tfeature.timelastmodified, tfeature."type", dbxrefd.accession AS barcode FROM ((tfeature JOIN feature_dbxref USING (feature_id)) JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id))) WHERE (((tfeature."type")::text = 'tiling_path_fragment'::text) AND ((dbxrefd.dbname)::text = 'BioMicroLab'::text));


--
-- Name: fragment_clone; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_clone AS
    SELECT tfeature.feature_id, tfeature.dbxref_id, tfeature.organism_id, tfeature.name, tfeature.uniquename, tfeature.residues, tfeature.seqlen, tfeature.md5checksum, tfeature.type_id, tfeature.is_analysis, tfeature.timeaccessioned, tfeature.timelastmodified, tfeature."type", dbxrefd.accession AS clone_id FROM ((tfeature JOIN feature_dbxref USING (feature_id)) JOIN dbxrefd ON ((feature_dbxref.dbxref_id = dbxrefd.dbxref_id))) WHERE (((tfeature."type")::text = 'tiling_path_fragment'::text) AND ((dbxrefd.dbname)::text = 'LabTrack'::text));


--
-- Name: fragment_clone_en; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_clone_en AS
    SELECT fragment_clone.feature_id, fragment_clone.dbxref_id, fragment_clone.organism_id, fragment_clone.name, fragment_clone.uniquename, fragment_clone.residues, fragment_clone.seqlen, fragment_clone.md5checksum, fragment_clone.type_id, fragment_clone.is_analysis, fragment_clone.timeaccessioned, fragment_clone.timelastmodified, fragment_clone."type", fragment_clone.clone_id FROM fragment_clone WHERE ((fragment_clone.name)::text ~~ '%\\_EN\\_%'::text);


--
-- Name: fragment_clone_pf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_clone_pf AS
    SELECT fragment_clone.feature_id, fragment_clone.dbxref_id, fragment_clone.organism_id, fragment_clone.name, fragment_clone.uniquename, fragment_clone.residues, fragment_clone.seqlen, fragment_clone.md5checksum, fragment_clone.type_id, fragment_clone.is_analysis, fragment_clone.timeaccessioned, fragment_clone.timelastmodified, fragment_clone."type", fragment_clone.clone_id FROM fragment_clone WHERE ((fragment_clone.name)::text ~~ '%\\_PF\\_%'::text);

--
-- Name: fragment_status; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_status AS
    SELECT f.feature_id, f.dbxref_id, f.organism_id, f.name, f.uniquename, f.residues, f.seqlen, f.md5checksum, f.type_id, f.is_analysis, f.timeaccessioned, f.timelastmodified, f."type", fp.value AS "owner" FROM (tfeature f JOIN featurepropt fp USING (feature_id)) WHERE (((fp."type")::text = 'owner'::text) AND ((f."type")::text = 'tiling_path_fragment'::text));


--
-- Name: fragment_status_report; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_status_report AS
    SELECT fragment_status."owner", count(*) AS count FROM fragment_status GROUP BY fragment_status."owner";

--
-- Name: fragment_view; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_view AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, featureloc.fmin, featureloc.fmax, featureloc.strand, featureloc.srcfeature_id, subsequence(featureloc.srcfeature_id, featureloc.fmin, featureloc.fmax, (featureloc.strand)::integer) AS subsequence, (feature.uniquename || '_primer5'::text) AS primer5_name, (feature.uniquename || '_primer3'::text) AS primer3_name, CASE WHEN (featureloc.strand < 0) THEN subsequence(featureloc.srcfeature_id, (featureloc.fmax - 25), featureloc.fmax, (featureloc.strand)::integer) ELSE subsequence(featureloc.srcfeature_id, featureloc.fmin, (featureloc.fmin + 25), (featureloc.strand)::integer) END AS primer5_seq, CASE WHEN (featureloc.strand < 0) THEN subsequence(featureloc.srcfeature_id, featureloc.fmin, (featureloc.fmin + 25), ((- featureloc.strand))::integer) ELSE subsequence(featureloc.srcfeature_id, (featureloc.fmax - 25), featureloc.fmax, ((- featureloc.strand))::integer) END AS primer3_seq FROM (feature JOIN featureloc USING (feature_id));


--
-- Name: fragment_view27; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_view27 AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, featureloc.fmin, featureloc.fmax, featureloc.strand, featureloc.srcfeature_id, subsequence(featureloc.srcfeature_id, featureloc.fmin, featureloc.fmax, (featureloc.strand)::integer) AS subsequence, (feature.uniquename || '_primer5'::text) AS primer5_name, (feature.uniquename || '_primer3'::text) AS primer3_name, CASE WHEN (featureloc.strand < 0) THEN subsequence(featureloc.srcfeature_id, (featureloc.fmax - 27), featureloc.fmax, (featureloc.strand)::integer) ELSE subsequence(featureloc.srcfeature_id, featureloc.fmin, (featureloc.fmin + 27), (featureloc.strand)::integer) END AS primer5_seq, CASE WHEN (featureloc.strand < 0) THEN subsequence(featureloc.srcfeature_id, featureloc.fmin, (featureloc.fmin + 27), ((- featureloc.strand))::integer) ELSE subsequence(featureloc.srcfeature_id, (featureloc.fmax - 27), featureloc.fmax, ((- featureloc.strand))::integer) END AS primer3_seq FROM (feature JOIN featureloc USING (feature_id));


--
-- Name: fragment_with_synonym; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW fragment_with_synonym AS
    SELECT fragf.feature_id, fragf.dbxref_id, fragf.organism_id, fragf.name, fragf.uniquename, fragf.residues, fragf.seqlen, fragf.md5checksum, fragf.type_id, fragf.is_analysis, fragf.timeaccessioned, fragf.timelastmodified, fragf."type", synonym.name AS synonym_name FROM ((fragf JOIN feature_synonym USING (feature_id)) JOIN synonym USING (synonym_id));


--
-- Name: gap; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gap AS
    SELECT feature.feature_id AS gap_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60395);


--
-- Name: gc_clone_dump; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gc_clone_dump AS
    SELECT feature.name AS experiment_id, gw.gateway_clone AS clone_id, pcr.pcr_clone_id AS pcr_fragment_id, o.seq_oriented, ls.left_seq, rs.right_seq FROM (((((feature JOIN feature_pcr_clone_id pcr USING (feature_id)) JOIN feature_gateway_clone gw USING (feature_id)) JOIN feature_seq_oriented o USING (feature_id)) JOIN feature_left_seq ls USING (feature_id)) JOIN feature_right_seq rs USING (feature_id));


--
-- Name: gene; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gene AS
    SELECT feature.feature_id AS gene_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60369);


--
-- Name: gene_group; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gene_group AS
    SELECT feature.feature_id AS gene_group_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60432);


--
-- Name: gene_group_regulatory_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gene_group_regulatory_region AS
    SELECT feature.feature_id AS gene_group_regulatory_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM (feature JOIN cvterm ON ((feature.type_id = cvterm.cvterm_id))) WHERE ((cvterm.name)::text = 'gene_group_regulatory_region'::text);


--
-- Name: gene_representative_image; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gene_representative_image AS
    SELECT fas.annotation_symbol, dbx.accession AS pcr_clone_id, f.name AS transformant, max(CASE WHEN ((c2.name)::text = 'representative_brain'::text) THEN fp.value ELSE NULL::text END) AS representative_brain, max(CASE WHEN ((c2.name)::text = 'representative_vnc'::text) THEN fp.value ELSE NULL::text END) AS representative_vnc, max(CASE WHEN ((c2.name)::text = 'representative_larva'::text) THEN fp.value ELSE NULL::text END) AS representative_larva FROM feature f, cvterm c, featureprop fp, cvterm c2, feature_annotation_symbol fas, feature f2, featureprop fp2, feature_dbxref fdb, dbxref dbx, db WHERE ((((((((((((f.type_id = c.cvterm_id) AND ((c.name)::text = 'transformant'::text)) AND (f.feature_id = fp.feature_id)) AND (fp.type_id = c2.cvterm_id)) AND (fas.feature_id = f2.feature_id)) AND ((f2.feature_id)::text = fp2.value)) AND (fp2.type_id = 60709)) AND (fp2.feature_id = f.feature_id)) AND (f2.feature_id = fdb.feature_id)) AND (fdb.dbxref_id = dbx.dbxref_id)) AND (dbx.db_id = db.db_id)) AND ((db.name)::text = 'LabTrack'::text)) GROUP BY fas.annotation_symbol, fp.feature_id, f.name, dbx.accession;


--
-- Name: gene_synonym; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gene_synonym AS
    SELECT s2.name AS "key", s.name, s.synonym_sgml FROM synonym s, feature_synonym fs, feature_synonym fs2, synonym s2 WHERE ((((fs.feature_id = fs2.feature_id) AND (fs2.synonym_id = s2.synonym_id)) AND (s.synonym_id = fs.synonym_id)) AND (fs.is_current = true)) ORDER BY s2.name;


--
-- Name: gffatts_slpar; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gffatts_slpar AS
    (SELECT fs.feature_id, 'dbxref' AS "type", (((d.name)::text || (':'::character varying)::text) || (s.accession)::text) AS attribute FROM dbxref s, feature_dbxref fs, db d WHERE ((fs.dbxref_id = s.dbxref_id) AND (s.db_id = d.db_id)) UNION ALL SELECT fp.feature_id, cv.name AS "type", fp.value AS attribute FROM featureprop fp, cvterm cv WHERE ((fp.type_id = cv.cvterm_id) AND (((cv.name)::text = ('cyto_range'::character varying)::text) OR ((cv.name)::text = ('gbunit'::character varying)::text)))) UNION ALL SELECT pk.subject_id AS feature_id, 'parent_oid' AS "type", CASE WHEN (pk.rank IS NULL) THEN text(pk.object_id) ELSE (((pk.object_id)::text || ':'::text) || (pk.rank)::text) END AS attribute FROM feature_relationship pk;


--
-- Name: golden_path; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW golden_path AS
    SELECT feature.feature_id AS golden_path_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60353);


--
-- Name: golden_path_fragment; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW golden_path_fragment AS
    SELECT feature.feature_id AS golden_path_fragment_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM (feature JOIN cvterm ON ((feature.type_id = cvterm.cvterm_id))) WHERE ((cvterm.name)::text = 'golden_path_fragment'::text);


--
-- Name: gr_plate_dump; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW gr_plate_dump AS
    SELECT p.feature_id, p.plate, gw.gateway_clone, bc.dbxref_id, bc.organism_id, bc.name, bc.uniquename, bc.residues, bc.seqlen, bc.md5checksum, bc.type_id, bc.is_analysis, bc.timeaccessioned, bc.timelastmodified, bc."type", bc.barcode FROM ((feature_rearray_plate p JOIN feature_gateway_clone gw USING (feature_id)) JOIN fragment_barcode bc USING (feature_id));


--
-- Name: group_i_intron; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW group_i_intron AS
    SELECT feature.feature_id AS group_i_intron_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60252);


--
-- Name: group_ii_intron; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW group_ii_intron AS
    SELECT feature.feature_id AS group_ii_intron_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60268);


--
-- Name: guide_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW guide_rna AS
    SELECT feature.feature_id AS guide_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60267);


--
-- Name: hammerhead_ribozyme; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW hammerhead_ribozyme AS
    SELECT feature.feature_id AS hammerhead_ribozyme_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60045);


--
-- Name: image; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW image AS
    SELECT x.transformant_id, x.image_location, x.is_representative, x.fragment_id, p3.value AS annotation_symbol FROM (SELECT p.feature_id AS transformant_id, p.value AS image_location, max(CASE WHEN ((c2.name)::text = 'representative_brain'::text) THEN CASE WHEN (p2.value = p.value) THEN (1)::text ELSE (0)::text END WHEN ((c2.name)::text = 'representative_vnc'::text) THEN CASE WHEN (p2.value = p.value) THEN (1)::text ELSE (0)::text END WHEN ((c2.name)::text = 'representative_larva'::text) THEN CASE WHEN (p2.value = p.value) THEN (1)::text ELSE (0)::text END ELSE (0)::text END) AS is_representative, max(CASE WHEN ((c2.name)::text = 'tiling_path_fragment_id'::text) THEN p2.value ELSE NULL::text END) AS fragment_id FROM featureprop p, cvterm c, featureprop p2, cvterm c2 WHERE (((((p.type_id = c.cvterm_id) AND ((c.name)::text = 'image_location'::text)) AND (p.feature_id = p2.feature_id)) AND (p2.type_id = c2.cvterm_id)) AND (((((c2.name)::text = 'representative_brain'::text) OR ((c2.name)::text = 'representative_vnc'::text)) OR ((c2.name)::text = 'representative_larva'::text)) OR ((c2.name)::text = 'tiling_path_fragment_id'::text))) GROUP BY p.feature_id, p.value) x, featureprop p3, cvterm c3 WHERE (((x.fragment_id = (p3.feature_id)::text) AND (p3.type_id = c3.cvterm_id)) AND ((c3.name)::text = 'annotation_symbol'::text));


--
-- Name: insertion; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW insertion AS
    SELECT feature.feature_id AS insertion_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60332);


--
-- Name: insertion_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW insertion_site AS
    SELECT feature.feature_id AS insertion_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60031);


--
-- Name: insulator; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW insulator AS
    SELECT feature.feature_id AS insulator_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60292);


--
-- Name: integrated_virus; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW integrated_virus AS
    SELECT feature.feature_id AS integrated_virus_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59778);

--
-- Name: intergenic_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW intergenic_region AS
    SELECT feature.feature_id AS intergenic_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60270);


--
-- Name: intron; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW intron AS
    SELECT feature.feature_id AS intron_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59853);


--
-- Name: intron_combined_view; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW intron_combined_view AS
    SELECT x1.feature_id AS exon1_id, x2.feature_id AS exon2_id, CASE WHEN (l1.strand = -1) THEN l2.fmax ELSE l1.fmax END AS fmin, CASE WHEN (l1.strand = -1) THEN l1.fmin ELSE l2.fmin END AS fmax, l1.strand, l1.srcfeature_id, r1.rank AS intron_rank, r1.object_id AS transcript_id FROM ((((((cvterm JOIN feature x1 ON ((x1.type_id = cvterm.cvterm_id))) JOIN feature_relationship r1 ON ((x1.feature_id = r1.subject_id))) JOIN featureloc l1 ON ((x1.feature_id = l1.feature_id))) JOIN feature x2 ON ((x2.type_id = cvterm.cvterm_id))) JOIN feature_relationship r2 ON ((x2.feature_id = r2.subject_id))) JOIN featureloc l2 ON ((x2.feature_id = l2.feature_id))) WHERE ((((((((cvterm.name)::text = 'exon'::text) AND ((r2.rank - r1.rank) = 1)) AND (r1.object_id = r2.object_id)) AND (l1.strand = l2.strand)) AND (l1.srcfeature_id = l2.srcfeature_id)) AND (l1.locgroup = 0)) AND (l2.locgroup = 0));


--
-- Name: intronloc_view; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW intronloc_view AS
    SELECT DISTINCT intron_combined_view.exon1_id, intron_combined_view.exon2_id, intron_combined_view.fmin, intron_combined_view.fmax, intron_combined_view.strand, intron_combined_view.srcfeature_id FROM intron_combined_view ORDER BY intron_combined_view.exon1_id, intron_combined_view.exon2_id, intron_combined_view.fmin, intron_combined_view.fmax, intron_combined_view.strand, intron_combined_view.srcfeature_id;


--
-- Name: inversion; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW inversion AS
    SELECT feature.feature_id AS inversion_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60468);


--
-- Name: inverted_repeat; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW inverted_repeat AS
    SELECT feature.feature_id AS inverted_repeat_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59959);



--
-- Name: junction; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW junction AS
    SELECT feature.feature_id AS junction_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60364);

--
-- Name: located_sequence_feature; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW located_sequence_feature AS
    SELECT feature.feature_id AS located_sequence_feature_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59775);


--
-- Name: match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW "match" AS
    SELECT feature.feature_id AS match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60008);


--
-- Name: match_part; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW match_part AS
    SELECT feature.feature_id AS match_part_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59704);


--
-- Name: match_set; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW match_set AS
    SELECT feature.feature_id AS match_set_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59703);


--
-- Name: mature_peptide; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW mature_peptide AS
    SELECT feature.feature_id AS mature_peptide_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60084);


--
-- Name: methylated_a; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW methylated_a AS
    SELECT feature.feature_id AS methylated_a_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59826);


--
-- Name: methylated_base_feature; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW methylated_base_feature AS
    SELECT feature.feature_id AS methylated_base_feature_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59971);


--
-- Name: methylated_c; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW methylated_c AS
    SELECT feature.feature_id AS methylated_c_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59779);

--
-- Name: microsatellite; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW microsatellite AS
    SELECT feature.feature_id AS microsatellite_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59954);


--
-- Name: minisatellite; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW minisatellite AS
    SELECT feature.feature_id AS minisatellite_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60308);


--
-- Name: mirna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW mirna AS
    SELECT feature.feature_id AS mirna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59941);


--
-- Name: modified_base_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW modified_base_site AS
    SELECT feature.feature_id AS modified_base_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59970);


--
-- Name: mrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW mrna AS
    SELECT feature.feature_id AS mrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59899);


--
-- Name: nc_primary_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW nc_primary_transcript AS
    SELECT feature.feature_id AS nc_primary_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60148);


--
-- Name: ncrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW ncrna AS
    SELECT feature.feature_id AS ncrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60320);


--
-- Name: non_transcribed_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW non_transcribed_region AS
    SELECT feature.feature_id AS non_transcribed_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59848);


--
-- Name: nuclease_sensitive_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW nuclease_sensitive_site AS
    SELECT feature.feature_id AS nuclease_sensitive_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60349);


--
-- Name: nucleotide_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW nucleotide_match AS
    SELECT feature.feature_id AS nucleotide_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60012);


--
-- Name: nucleotide_motif; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW nucleotide_motif AS
    SELECT feature.feature_id AS nucleotide_motif_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60379);


--
-- Name: oligo; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW oligo AS
    SELECT feature.feature_id AS oligo_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60361);


--
-- Name: operator; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW "operator" AS
    SELECT feature.feature_id AS operator_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59722);


--
-- Name: operon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW operon AS
    SELECT feature.feature_id AS operon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59843);


--
-- Name: orf; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW orf AS
    SELECT feature.feature_id AS orf_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59901);


--
-- Name: origin_of_replication; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW origin_of_replication AS
    SELECT feature.feature_id AS origin_of_replication_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59961);


--
-- Name: origin_of_transfer; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW origin_of_transfer AS
    SELECT feature.feature_id AS origin_of_transfer_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60389);

--
-- Name: p_coding_primary_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW p_coding_primary_transcript AS
    SELECT feature.feature_id AS p_coding_primary_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59785);


--
-- Name: p_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW p_match AS
    SELECT feature.feature_id AS p_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60014);


--
-- Name: pcr_product; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pcr_product AS
    SELECT feature.feature_id AS pcr_product_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59671);


--
-- Name: plate_fragment_report; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW plate_fragment_report AS
    SELECT feature_rearray_plate.plate, count(*) AS count FROM ((feature_rearray_plate JOIN fragment_regulatory_type en USING (feature_id)) JOIN fragment_regulatory_type pf USING (feature_id)) WHERE ((en.regtype = 'EN'::text) AND (pf.regtype = 'PF'::text)) GROUP BY feature_rearray_plate.plate;


--
-- Name: point_mutation; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW point_mutation AS
    SELECT feature.feature_id AS point_mutation_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60440);


--
-- Name: polya_sequence; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW polya_sequence AS
    SELECT feature.feature_id AS polya_sequence_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60275);


--
-- Name: polya_signal_sequence; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW polya_signal_sequence AS
    SELECT feature.feature_id AS polya_signal_sequence_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60216);


--
-- Name: polya_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW polya_site AS
    SELECT feature.feature_id AS polya_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60218);


--
-- Name: polypeptide; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW polypeptide AS
    SELECT feature.feature_id AS polypeptide_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59769);


--
-- Name: polypyrimidine_tract; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW polypyrimidine_tract AS
    SELECT feature.feature_id AS polypyrimidine_tract_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60277);


--
-- Name: possible_assembly_error; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW possible_assembly_error AS
    SELECT feature.feature_id AS possible_assembly_error_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60367);


--
-- Name: possible_base_call_error; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW possible_base_call_error AS
    SELECT feature.feature_id AS possible_base_call_error_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60366);


--
-- Name: pp_seq_view; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pp_seq_view AS
    SELECT ((((((pp.uniquename || ' symbol:'::text) || (pp.name)::text) || ' gene:'::text) || gene.uniquename) || ' gene_symbol:'::text) || (gene.name)::text) AS hdr, pp.residues FROM (((gene JOIN feature_relationship g2t ON ((gene.feature_id = g2t.object_id))) JOIN feature_relationship t2p ON ((g2t.subject_id = t2p.object_id))) JOIN polypeptide pp ON ((t2p.subject_id = pp.feature_id)));


--
-- Name: prediction_evidence; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW prediction_evidence AS
    SELECT (((((anchor.feature_id)::text || ':'::text) || (evloc.feature_id)::text) || ':'::text) || (af.analysis_id)::text) AS prediction_evidence_id, anchor.feature_id, evloc.feature_id AS evidence_id, af.analysis_id FROM featureloc anchor, featureloc evloc, analysisfeature af WHERE ((((anchor.srcfeature_id = evloc.srcfeature_id) AND (anchor.strand = evloc.strand)) AND (evloc.feature_id = af.feature_id)) AND ((evloc.fmin <= anchor.fmax) AND (evloc.fmax >= anchor.fmin)));


--
-- Name: primary_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW primary_transcript AS
    SELECT feature.feature_id AS primary_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59850);


--
-- Name: processed_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW processed_transcript AS
    SELECT feature.feature_id AS processed_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59898);


--
-- Name: promoter; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW promoter AS
    SELECT feature.feature_id AS promoter_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59832);


--
-- Name: protein_coding_gene; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW protein_coding_gene AS
    SELECT DISTINCT gene.feature_id, gene.dbxref_id, gene.organism_id, gene.name, gene.uniquename, gene.residues, gene.seqlen, gene.md5checksum, gene.type_id, gene.is_analysis, gene.timeaccessioned, gene.timelastmodified, gene.is_obsolete FROM ((feature gene JOIN feature_relationship fr ON ((gene.feature_id = fr.object_id))) JOIN mrna ON ((mrna.feature_id = fr.subject_id))) ORDER BY gene.feature_id, gene.dbxref_id, gene.organism_id, gene.name, gene.uniquename, gene.residues, gene.seqlen, gene.md5checksum, gene.type_id, gene.is_analysis, gene.timeaccessioned, gene.timelastmodified, gene.is_obsolete;


--
-- Name: pseudogene; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pseudogene AS
    SELECT feature.feature_id AS pseudogene_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60001);


--
-- Name: pseudogenic_exon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pseudogenic_exon AS
    SELECT feature.feature_id AS pseudogenic_exon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60172);


--
-- Name: pseudogenic_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pseudogenic_region AS
    SELECT feature.feature_id AS pseudogenic_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60127);


--
-- Name: pseudogenic_transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW pseudogenic_transcript AS
    SELECT feature.feature_id AS pseudogenic_transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60181);


--
-- Name: rasirna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rasirna AS
    SELECT feature.feature_id AS rasirna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60119);


--
-- Name: read; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW "read" AS
    SELECT feature.feature_id AS read_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59815);


--
-- Name: read_pair; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW read_pair AS
    SELECT feature.feature_id AS read_pair_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59672);


--
-- Name: reading_frame; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW reading_frame AS
    SELECT feature.feature_id AS reading_frame_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60382);


--
-- Name: reagent; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW reagent AS
    SELECT feature.feature_id AS reagent_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60360);


--
-- Name: region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW region AS
    SELECT feature.feature_id AS region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59665);


--
-- Name: regulatory_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW regulatory_region AS
    SELECT feature.feature_id AS regulatory_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60418);


--
-- Name: regulon; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW regulon AS
    SELECT feature.feature_id AS regulon_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60640);


--
-- Name: remark; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW remark AS
    SELECT feature.feature_id AS remark_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60365);


--
-- Name: repeat_family; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW repeat_family AS
    SELECT feature.feature_id AS repeat_family_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59852);


--
-- Name: repeat_region; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW repeat_region AS
    SELECT feature.feature_id AS repeat_region_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60322);

--
-- Name: restriction_fragment; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW restriction_fragment AS
    SELECT feature.feature_id AS restriction_fragment_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60077);


--
-- Name: rflp_fragment; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rflp_fragment AS
    SELECT feature.feature_id AS rflp_fragment_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59858);


--
-- Name: ribosome_entry_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW ribosome_entry_site AS
    SELECT feature.feature_id AS ribosome_entry_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59804);


--
-- Name: ribozyme; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW ribozyme AS
    SELECT feature.feature_id AS ribozyme_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60039);


--
-- Name: rnai_reagent; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rnai_reagent AS
    SELECT feature.feature_id AS rnai_reagent_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60002);


--
-- Name: rnase_mrp_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rnase_mrp_rna AS
    SELECT feature.feature_id AS rnase_mrp_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60050);


--
-- Name: rnase_p_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rnase_p_rna AS
    SELECT feature.feature_id AS rnase_p_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60051);


--
-- Name: rrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rrna AS
    SELECT feature.feature_id AS rrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59917);

--
-- Name: rrna_18s; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rrna_18s AS
    SELECT feature.feature_id AS rrna_18s_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60072);


--
-- Name: rrna_28s; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rrna_28s AS
    SELECT feature.feature_id AS rrna_28s_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60318);


--
-- Name: rrna_5_8s; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rrna_5_8s AS
    SELECT feature.feature_id AS rrna_5_8s_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60040);


--
-- Name: rrna_5s; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW rrna_5s AS
    SELECT feature.feature_id AS rrna_5s_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60317);


--
-- Name: sage_tag; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sage_tag AS
    SELECT feature.feature_id AS sage_tag_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59991);


--
-- Name: scrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW scrna AS
    SELECT feature.feature_id AS scrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59678);


--
-- Name: sequence_difference; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sequence_difference AS
    SELECT feature.feature_id AS sequence_difference_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60078);


--
-- Name: sequence_ontology; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sequence_ontology AS
    SELECT feature.feature_id AS sequence_ontology_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59664);


--
-- Name: sequence_variant; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sequence_variant AS
    SELECT feature.feature_id AS sequence_variant_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59774);


--
-- Name: signal_peptide; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW signal_peptide AS
    SELECT feature.feature_id AS signal_peptide_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60083);


--
-- Name: silencer; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW silencer AS
    SELECT feature.feature_id AS silencer_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60290);


--
-- Name: sirna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sirna AS
    SELECT feature.feature_id AS sirna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60311);


--
-- Name: small_regulatory_ncrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW small_regulatory_ncrna AS
    SELECT feature.feature_id AS small_regulatory_ncrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60035);


--
-- Name: snorna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW snorna AS
    SELECT feature.feature_id AS snorna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59940);


--
-- Name: snp; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW snp AS
    SELECT feature.feature_id AS snp_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60359);


--
-- Name: snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW snrna AS
    SELECT feature.feature_id AS snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59939);


--
-- Name: splice_acceptor_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW splice_acceptor_site AS
    SELECT feature.feature_id AS splice_acceptor_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59829);


--
-- Name: splice_donor_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW splice_donor_site AS
    SELECT feature.feature_id AS splice_donor_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59828);


--
-- Name: splice_enhancer; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW splice_enhancer AS
    SELECT feature.feature_id AS splice_enhancer_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60009);


--
-- Name: splice_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW splice_site AS
    SELECT feature.feature_id AS splice_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59827);


--
-- Name: spliceosomal_intron; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW spliceosomal_intron AS
    SELECT feature.feature_id AS spliceosomal_intron_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60327);


--
-- Name: srp_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW srp_rna AS
    SELECT feature.feature_id AS srp_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60255);


--
-- Name: strna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW strna AS
    SELECT feature.feature_id AS strna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60314);


--
-- Name: sts; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW sts AS
    SELECT feature.feature_id AS sts_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59996);


--
-- Name: substitution; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW substitution AS
    SELECT feature.feature_id AS substitution_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60436);


--
-- Name: supercontig; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW supercontig AS
    SELECT feature.feature_id AS supercontig_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59813);


--
-- Name: t_element; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW t_element AS
    SELECT feature.feature_id AS t_element_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59766);


--
-- Name: t_element_insertion_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW t_element_insertion_site AS
    SELECT feature.feature_id AS t_element_insertion_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60033);

--
-- Name: tag; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tag AS
    SELECT feature.feature_id AS tag_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59989);


--
-- Name: tandem_repeat; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tandem_repeat AS
    SELECT feature.feature_id AS tandem_repeat_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60370);


--
-- Name: telomerase_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW telomerase_rna AS
    SELECT feature.feature_id AS telomerase_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60055);


--
-- Name: telomere; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW telomere AS
    SELECT feature.feature_id AS telomere_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60289);


--
-- Name: terminator; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW terminator AS
    SELECT feature.feature_id AS terminator_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59806);


--
-- Name: tf_binding_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tf_binding_site AS
    SELECT feature.feature_id AS tf_binding_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59900);


--
-- Name: tfeaturefl; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tfeaturefl AS
    SELECT featurefl.feature_id, featurefl.dbxref_id, featurefl.organism_id, featurefl.name, featurefl.uniquename, featurefl.residues, featurefl.seqlen, featurefl.md5checksum, featurefl.type_id, featurefl.is_analysis, featurefl.timeaccessioned, featurefl.timelastmodified, featurefl.featureloc_id, featurefl.srcfeature_id, featurefl.fmin, featurefl.fmax, featurefl.strand, featurefl.is_fmin_partial, featurefl.is_fmax_partial, featurefl.phase, featurefl.residue_info, featurefl.locgroup, featurefl.rank, cvterm.name AS "type" FROM (featurefl JOIN cvterm ON ((featurefl.type_id = cvterm.cvterm_id)));


--
-- Name: three_prime_utr; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW three_prime_utr AS
    SELECT feature.feature_id AS three_prime_utr_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59870);


--
-- Name: tiling_path; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tiling_path AS
    SELECT feature.feature_id AS tiling_path_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60137);


--
-- Name: tiling_path_fragment; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW tiling_path_fragment AS
    SELECT feature.feature_id AS tiling_path_fragment_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60139);


--
-- Name: trans_splice_acceptor_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW trans_splice_acceptor_site AS
    SELECT feature.feature_id AS trans_splice_acceptor_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60371);


--
-- Name: transcript; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW transcript AS
    SELECT feature.feature_id AS transcript_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60338);


--
-- Name: transcription_end_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW transcription_end_site AS
    SELECT feature.feature_id AS transcription_end_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60281);


--
-- Name: transcription_start_site; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW transcription_start_site AS
    SELECT feature.feature_id AS transcription_start_site_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59980);


--
-- Name: transit_peptide; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW transit_peptide AS
    SELECT feature.feature_id AS transit_peptide_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60390);


--
-- Name: translated_nucleotide_match; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW translated_nucleotide_match AS
    SELECT feature.feature_id AS translated_nucleotide_match_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59846);

--
-- Name: trna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW trna AS
    SELECT feature.feature_id AS trna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59918);


--
-- Name: xfeature; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW xfeature AS
    SELECT feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified, dbxrefd.dbname, dbxrefd.accession, dbxrefd.version FROM (feature JOIN dbxrefd USING (dbxref_id));


--
-- Name: txfeature; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW txfeature AS
    SELECT xfeature.feature_id, xfeature.dbxref_id, xfeature.organism_id, xfeature.name, xfeature.uniquename, xfeature.residues, xfeature.seqlen, xfeature.md5checksum, xfeature.type_id, xfeature.is_analysis, xfeature.timeaccessioned, xfeature.timelastmodified, xfeature.dbname, xfeature.accession, xfeature.version, cvterm.name AS "type" FROM (xfeature JOIN cvterm ON ((xfeature.type_id = cvterm.cvterm_id)));


--
-- Name: type_feature_count; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW type_feature_count AS
    SELECT t.name AS "type", count(*) AS num_features FROM (cvterm t JOIN feature ON ((feature.type_id = t.cvterm_id))) GROUP BY t.name;


--
-- Name: VIEW type_feature_count; Type: COMMENT; Schema: public; Owner: cjm
--

COMMENT ON VIEW type_feature_count IS 'per-feature-type feature counts';


--
-- Name: u11_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u11_snrna AS
    SELECT feature.feature_id AS u11_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60063);


--
-- Name: u12_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u12_snrna AS
    SELECT feature.feature_id AS u12_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60064);


--
-- Name: u14_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u14_snrna AS
    SELECT feature.feature_id AS u14_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60068);


--
-- Name: u1_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u1_snrna AS
    SELECT feature.feature_id AS u1_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60056);


--
-- Name: u2_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u2_snrna AS
    SELECT feature.feature_id AS u2_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60057);


--
-- Name: u4_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u4_snrna AS
    SELECT feature.feature_id AS u4_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60058);


--
-- Name: u4atac_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u4atac_snrna AS
    SELECT feature.feature_id AS u4atac_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60059);


--
-- Name: u5_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u5_snrna AS
    SELECT feature.feature_id AS u5_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60060);


--
-- Name: u6_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u6_snrna AS
    SELECT feature.feature_id AS u6_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60061);


--
-- Name: u6atac_snrna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW u6atac_snrna AS
    SELECT feature.feature_id AS u6atac_snrna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60062);


--
-- Name: ultracontig; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW ultracontig AS
    SELECT feature.feature_id AS ultracontig_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60384);


--
-- Name: utr; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW utr AS
    SELECT feature.feature_id AS utr_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 59868);


--
-- Name: vault_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW vault_rna AS
    SELECT feature.feature_id AS vault_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60069);


--
-- Name: virtual_sequence; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW virtual_sequence AS
    SELECT feature.feature_id AS virtual_sequence_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60164);


--
-- Name: xcvterm; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW xcvterm AS
    SELECT cvterm.cvterm_id, cvterm.cv_id, cvterm.definition, cvterm.dbxref_id, cvterm.is_obsolete, cvterm.is_relationshiptype, cvterm.name, dbxrefd.dbname, dbxrefd.accession, dbxrefd.version, cv.name AS cvname FROM ((cvterm JOIN dbxrefd USING (dbxref_id)) JOIN cv USING (cv_id));


--
-- Name: y_rna; Type: VIEW; Schema: public; Owner: cjm
--

CREATE VIEW y_rna AS
    SELECT feature.feature_id AS y_rna_id, feature.feature_id, feature.dbxref_id, feature.organism_id, feature.name, feature.uniquename, feature.residues, feature.seqlen, feature.md5checksum, feature.type_id, feature.is_analysis, feature.timeaccessioned, feature.timelastmodified FROM feature WHERE (feature.type_id = 60070);

--
-- PostgreSQL database dump complete
--

