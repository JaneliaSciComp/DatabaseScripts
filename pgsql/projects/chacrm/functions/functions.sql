CREATE TYPE soi_type AS (
    type_id INT,
    subject_id INT,
    object_id INT
);

CREATE TYPE feature_by_fx_type AS (
    feature_id INTEGER,
    depth INT
);


CREATE OR REPLACE FUNCTION _fill_cvtermpath4node(integer, integer, integer, integer, integer)
  RETURNS integer AS
$BODY$
DECLARE
    origin alias for $1;
    child_id alias for $2;
    cvid alias for $3;
    typeid alias for $4;
    depth alias for $5;
    cterm cvterm_relationship%ROWTYPE;
    exist_c int;

BEGIN

    --- RAISE NOTICE 'depth=% root=%', depth,child_id;
    --- not check type_id as it may be null and not very meaningful in cvtermpath when pathdistance > 1
    SELECT INTO exist_c count(*) FROM cvtermpath WHERE cv_id = cvid AND object_id = origin AND subject_id = child_id AND pathdistance = depth;

    IF (exist_c = 0) THEN
        INSERT INTO cvtermpath (object_id, subject_id, cv_id, type_id, pathdistance) VALUES(origin, child_id, cvid, typeid, depth);
    END IF;
    FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = child_id LOOP
        PERFORM _fill_cvtermpath4node(origin, cterm.subject_id, cvid, cterm.type_id, depth+1);
    END LOOP;
    RETURN 1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  


CREATE OR REPLACE FUNCTION _fill_cvtermpath4node2detect_cycle(integer, integer, integer, integer, integer)
  RETURNS integer AS
$BODY$
DECLARE
    origin alias for $1;
    child_id alias for $2;
    cvid alias for $3;
    typeid alias for $4;
    depth alias for $5;
    cterm cvterm_relationship%ROWTYPE;
    exist_c int;
    ccount  int;
    ecount  int;
    rtn     int;
BEGIN

    EXECUTE 'SELECT * FROM tmpcvtermpath p1, tmpcvtermpath p2 WHERE p1.subject_id=p2.object_id AND p1.object_id=p2.subject_id AND p1.object_id = '|| origin || ' AND p2.subject_id = ' || child_id || 'AND ' || depth || '> 0';
    GET DIAGNOSTICS ccount = ROW_COUNT;
    IF (ccount > 0) THEN
        --RAISE EXCEPTION 'FOUND CYCLE: node % on cycle path',origin;
        RETURN origin;
    END IF;

    EXECUTE 'SELECT * FROM tmpcvtermpath WHERE cv_id = ' || cvid || ' AND object_id = ' || origin || ' AND subject_id = ' || child_id || ' AND ' || origin || '<>' || child_id;
    GET DIAGNOSTICS ecount = ROW_COUNT;
    IF (ecount > 0) THEN
        --RAISE NOTICE 'FOUND TWICE (node), will check root obj % subj %',origin, child_id;
        SELECT INTO rtn _fill_cvtermpath4root2detect_cycle(child_id, cvid);
        IF (rtn > 0) THEN
            RETURN rtn;
        END IF;
    END IF;

    EXECUTE 'SELECT * FROM tmpcvtermpath WHERE cv_id = ' || cvid || ' AND object_id = ' || origin || ' AND subject_id = ' || child_id || ' AND pathdistance = ' || depth;
    GET DIAGNOSTICS exist_c = ROW_COUNT;
    IF (exist_c = 0) THEN
        EXECUTE 'INSERT INTO tmpcvtermpath (object_id, subject_id, cv_id, type_id, pathdistance) VALUES(' || origin || ', ' || child_id || ', ' || cvid || ', ' || typeid || ', ' || depth || ')';
    END IF;

    FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = child_id LOOP
        --RAISE NOTICE 'DOING for node, % %', origin, cterm.subject_id;
        SELECT INTO rtn _fill_cvtermpath4node2detect_cycle(origin, cterm.subject_id, cvid, cterm.type_id, depth+1);
        IF (rtn > 0) THEN
            RETURN rtn;
        END IF;
    END LOOP;
    RETURN 0;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;  
  
  
  CREATE OR REPLACE FUNCTION _fill_cvtermpath4root(integer, integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      rootid alias for $1;
      cvid alias for $2;
      ttype int;
      cterm cvterm_relationship%ROWTYPE;
      child cvterm_relationship%ROWTYPE;
  
  BEGIN
  
      SELECT INTO ttype cvterm_id FROM cvterm WHERE (name = 'isa' OR name = 'is_a');
      PERFORM _fill_cvtermpath4node(rootid, rootid, cvid, ttype, 0);
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = rootid LOOP
          PERFORM _fill_cvtermpath4root(cterm.subject_id, cvid);
          -- RAISE NOTICE 'DONE for term, %', cterm.subject_id;
      END LOOP;
      RETURN 1;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION _fill_cvtermpath4root2detect_cycle(integer, integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      rootid alias for $1;
      cvid alias for $2;
      ttype int;
      ccount int;
      cterm cvterm_relationship%ROWTYPE;
      child cvterm_relationship%ROWTYPE;
      rtn     int;
  BEGIN
  
      SELECT INTO ttype cvterm_id FROM cvterm WHERE (name = 'isa' OR name = 'is_a');
      SELECT INTO rtn _fill_cvtermpath4node2detect_cycle(rootid, rootid, cvid, ttype, 0);
      IF (rtn > 0) THEN
          RETURN rtn;
      END IF;
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = rootid LOOP
          EXECUTE 'SELECT * FROM tmpcvtermpath p1, tmpcvtermpath p2 WHERE p1.subject_id=p2.object_id AND p1.object_id=p2.subject_id AND p1.object_id=' || rootid || ' AND p1.subject_id=' || cterm.subject_id;
          GET DIAGNOSTICS ccount = ROW_COUNT;
          IF (ccount > 0) THEN
              --RAISE NOTICE 'FOUND TWICE (root), will check root obj % subj %',rootid,cterm.subject_id;
              SELECT INTO rtn _fill_cvtermpath4node2detect_cycle(rootid, cterm.subject_id, cvid, ttype, 0);
              IF (rtn > 0) THEN
                  RETURN rtn;
              END IF;
          ELSE
              SELECT INTO rtn _fill_cvtermpath4root2detect_cycle(cterm.subject_id, cvid);
              IF (rtn > 0) THEN
                  RETURN rtn;
              END IF;
          END IF;
      END LOOP;
      RETURN 0;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
 
  CREATE OR REPLACE FUNCTION _fill_cvtermpath4soi(integer, integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      rootid alias for $1;
      cvid alias for $2;
      ttype int;
      cterm soi_type%ROWTYPE;
  
  BEGIN
      
      SELECT INTO ttype get_cvterm_id_for_is_a();
      --RAISE NOTICE 'got ttype %',ttype;
      PERFORM _fill_cvtermpath4soinode(rootid, rootid, cvid, ttype, 0);
      FOR cterm IN SELECT tmp_type AS type_id, subject_id FROM tmpcvtr WHERE object_id = rootid LOOP
          PERFORM _fill_cvtermpath4soi(cterm.subject_id, cvid);
      END LOOP;
      RETURN 1;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION _fill_cvtermpath4soinode(integer, integer, integer, integer, integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      origin alias for $1;
      child_id alias for $2;
      cvid alias for $3;
      typeid alias for $4;
      depth alias for $5;
      cterm soi_type%ROWTYPE;
      exist_c int;
  
  BEGIN
  
      --RAISE NOTICE 'depth=% o=%, root=%, cv=%, t=%', depth,origin,child_id,cvid,typeid;
      SELECT INTO exist_c count(*) FROM cvtermpath WHERE cv_id = cvid AND object_id = origin AND subject_id = child_id AND pathdistance = depth;
      --- longest path
      IF (exist_c > 0) THEN
          UPDATE cvtermpath SET pathdistance = depth WHERE cv_id = cvid AND object_id = origin AND subject_id = child_id;
      ELSE
          INSERT INTO cvtermpath (object_id, subject_id, cv_id, type_id, pathdistance) VALUES(origin, child_id, cvid, typeid, depth);
      END IF;
  
      FOR cterm IN SELECT tmp_type AS type_id, subject_id FROM tmpcvtr WHERE object_id = child_id LOOP
          PERFORM _fill_cvtermpath4soinode(origin, cterm.subject_id, cvid, cterm.type_id, depth+1);
      END LOOP;
      RETURN 1;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION _get_all_object_ids(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      leaf alias for $1;
      cterm cvtermpath%ROWTYPE;
      cterm2 cvtermpath%ROWTYPE;
  BEGIN
  
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE subject_id = leaf LOOP
          RETURN NEXT cterm;
          FOR cterm2 IN SELECT * FROM _get_all_object_ids(cterm.object_id) LOOP
              RETURN NEXT cterm2;
          END LOOP;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION _get_all_subject_ids(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      root alias for $1;
      cterm cvtermpath%ROWTYPE;
      cterm2 cvtermpath%ROWTYPE;
  BEGIN
  
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = root LOOP
          RETURN NEXT cterm;
          FOR cterm2 IN SELECT * FROM _get_all_subject_ids(cterm.subject_id) LOOP
              RETURN NEXT cterm2;
          END LOOP;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
    
  CREATE OR REPLACE FUNCTION create_point(integer, integer)
    RETURNS point AS
  'SELECT point ($1, $2)'
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION boxquery(integer, integer)
    RETURNS box AS
  'SELECT box (create_point($1, $2), create_point($1, $2))'
  LANGUAGE 'sql' IMMUTABLE;
  
  CREATE OR REPLACE FUNCTION boxrange(integer, integer)
    RETURNS box AS
  'SELECT box (create_point(0, $1), create_point($2,500000000))'
  LANGUAGE 'sql' IMMUTABLE;
  
  CREATE OR REPLACE FUNCTION cache_all_fragment_residues()
    RETURNS integer AS
  $BODY$
  DECLARE
    r RECORD;
    v_residues            TEXT;
  BEGIN
      FOR r IN SELECT feature_id FROM tfeature WHERE type='tiling_path_fragment' AND is_analysis=false LOOP
      
      	v_residues = subsequence_by_feature(r.feature_id);
      	
          RAISE NOTICE 'updating residues for fragment %', r.feature_id;
          
          UPDATE feature 
          SET residues=v_residues 
             ,seqlen = length(v_residues)
             ,md5checksum = md5(v_residues)
          WHERE feature_id=r.feature_id;
      END LOOP;
      RETURN 1;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION cache_all_fragment_residues(integer)
    RETURNS integer AS
  $BODY$
  DECLARE
    v_feature_id          ALIAS FOR $1;
    v_residues            TEXT;
  
  BEGIN
      v_residues = subsequence_by_feature(v_feature_id);
      RAISE NOTICE 'updating residues for fragment %', v_feature_id;
          UPDATE feature 
          SET residues=v_residues 
             ,seqlen = length(v_residues)
             ,md5checksum = md5(v_residues)
          WHERE feature_id=v_feature_id;
      RETURN 1;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION chado_args_init()
    RETURNS integer AS
  $BODY$
  DECLARE
  	cvid	INTEGER;
  	pubtypeid	INTEGER;
  BEGIN
    --insert CVs
    INSERT INTO cv(name) VALUES('sequence topology');
    INSERT INTO cv(name) VALUES('GenBank feature qualifier');
    --INSERT INTO cv(name) VALUES('pub relationship type');
    --INSERT INTO cv(name) VALUES('pubprop type');
    INSERT INTO cv(name) VALUES('GenBank division');
  
    --insert cvterm's
    --SO terms
    SELECT cv_id INTO cvid FROM cv WHERE name = 'sequence';
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'mature_peptide');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'signal_peptide');
  
    --pub type
    SELECT cv_id INTO cvid FROM cv WHERE name = 'pub type';
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'null pub');
    --INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'unpublished');
    --INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'paper');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'submitted');
    --INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'other');
    --INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'journal');
  
    --sequence topology
    SELECT cv_id INTO cvid FROM cv WHERE name = 'sequence topology';
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'linear');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'circular');
    
    --GenBank division
    SELECT cv_id INTO cvid FROM cv WHERE name = 'GenBank division';
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'PRI', 'primate sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'ROD', 'rodent sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'MAM', 'other mammalian sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'VRT', 'other vertebrate sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'INV', 'invertebrate sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'PLN', 'plant, fungal, and algal sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'BCT', 'bacterial sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'VRL', 'viral sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'PHG', 'bacteriophage sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'SYN', 'synthetic sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'UNA', 'unannotated sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'EST', 'EST sequences (expressed sequence tags)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'PAT', 'patent sequences');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'STS', 'STS sequences (sequence tagged sites)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'GSS', 'GSS sequences (genome survey sequences)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'HTG', 'HTGS sequences (high throughput genomic sequences)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'HTC', 'HTC sequences (high throughput cDNA sequences)');
  
    --property type
    SELECT cv_id INTO cvid FROM cv WHERE name = 'property type';
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'keywords');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'organism');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'mol_type');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'dev_stage');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'chromosome');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'map');
  
    --GenBank feature qualifier
    SELECT cv_id INTO cvid FROM cv WHERE name = 'GenBank feature qualifier';
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'anticodon', 'Location of the anticodon of tRNA and the amino acid for which it codes');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'bound_moiety', 'Moiety bound');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'citation', 'Reference to a citation providing the claim of or evidence for a feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'codon', 'Specifies a codon that is different from any found in the reference genetic code');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'codon_start', 'Indicates the first base of the first complete codon in a CDS (as 1 or 2 or 3)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'cons_splice', 'Identifies intron splice sites that do not conform to the 5''-GT... AG-3'' splice site consensus');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'db_xref', 'A database cross-reference; pointer to related information in another database. A description of all cross-references can be found at: http://www.ncbi.nlm.nih.gov/collab/db_xref.html');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'direction', 'Direction of DNA replication');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'EC_number', 'Enzyme Commission number for the enzyme product of the sequence');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'evidence', 'Value indicating the nature of supporting evidence');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'frequency', 'Frequency of the occurrence of a feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'function', 'Function attributed to a sequence');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'gene', 'Symbol of the gene corresponding to a sequence region (usable with all features)');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'label', 'A label used to permanently identify a feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'map', 'Map position of the feature in free-format text');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'mod_base', 'Abbreviation for a modified nucleotide base');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'note', 'Any comment or additional information');
  INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'number', 'A number indicating the order of genetic elements (e.g., exons or introns) in the 5 to 3 direction');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'organism', 'Name of the organism that is the source of the sequence data in the record. ');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'partial', 'Differentiates between complete regions and partial ones');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'phenotype', 'Phenotype conferred by the feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'product', 'Name of a product encoded by a coding region (CDS) feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'pseudo', 'Indicates that this feature is a non-functional version of the element named by the feature key');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'rpt_family', 'Type of repeated sequence; Alu or Kpn, for example');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'rpt_type', 'Organization of repeated sequence');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'rpt_unit', 'Identity of repeat unit that constitutes a repeat_region');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'standard_name', 'Accepted standard name for this feature');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'transl_except', 'Translational exception: single codon, the translation of which does not conform to the reference genetic code');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'translation', 'Amino acid translation of a coding region');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'type', 'Name of a strain if different from that in the SOURCE field');
    INSERT INTO cvterm(cv_id, name, definition) VALUES(cvid, 'usedin', 'Indicatesthat feature is used in a compound feature in another entry');
    --feature qualifiers unique to FB
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'comment');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'linked_to');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'na_change');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'pr_change');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'reported_na_change');
    INSERT INTO cvterm(cv_id, name) VALUES(cvid, 'reported_pr_change');
  
    --insert a null pub of type 'null pub'
    SELECT t.cvterm_id into pubtypeid FROM cvterm t, cv  WHERE t.name = 'null pub' and t.cv_id = cv.cv_id and cv.name = 'pub type';
    INSERT INTO pub(uniquename, type_id) VALUES('nullpub', pubtypeid);
  
    --insert dbs
    --INSERT INTO db(name, contact_id) VALUES('MEDLINE', 1);
    INSERT INTO db(name, contact_id) VALUES('PUBMED', 1);
    RETURN 1;
  END;
  
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION complement_residues(text)
    RETURNS text AS
  $BODY$SELECT (translate($1, 
                     'acgtrymkswhbvdnxACGTRYMKSWHBVDNX',
                     'tgcayrkmswdvbhnxTGCAYRKMSWDVBHNX'))$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION concat_pair(text, text)
    RETURNS text AS
  'SELECT $1 || $2'
  LANGUAGE 'sql' VOLATILE;
  

  CREATE OR REPLACE FUNCTION create_soi()
    RETURNS integer AS
  $BODY$
  DECLARE
      parent soi_type%ROWTYPE;
      isa_id cvterm.cvterm_id%TYPE;
      soi_term VARCHAR := 'soi';
      soi_def TEXT := 'ontology of SO feature instantiated in database';
      soi_cvid INTEGER;
      soiterm_id INTEGER;
      pcount INTEGER;
      count INTEGER := 0;
      cquery TEXT;
  BEGIN
  
      SELECT INTO isa_id get_cvterm_id_for_is_a();
  
      SELECT INTO soi_cvid cv_id FROM cv WHERE name = soi_term;
      IF (soi_cvid > 0) THEN
          DELETE FROM cvtermpath WHERE cv_id = soi_cvid;
          DELETE FROM cvterm WHERE cv_id = soi_cvid;
      ELSE
          INSERT INTO cv (name, definition) VALUES(soi_term, soi_def);
      END IF;
      SELECT INTO soi_cvid cv_id FROM cv WHERE name = soi_term;
      -- create a SOI term in cvterm, and add a pseudo-dbxref
      INSERT INTO cvterm (name, cv_id,dbxref_id)
        VALUES (soi_term, soi_cvid,store_dbxref('SOI',soi_term));
      SELECT INTO soiterm_id cvterm_id FROM cvterm WHERE name = soi_term;
  
      CREATE TEMP TABLE tmpcvtr (tmp_type INT, type_id INT, subject_id INT, object_id INT);
      CREATE UNIQUE INDEX u_tmpcvtr ON tmpcvtr(subject_id, object_id);
  
      INSERT INTO tmpcvtr (tmp_type, type_id, subject_id, object_id)
          SELECT DISTINCT isa_id, soiterm_id, f.type_id, soiterm_id FROM feature f, cvterm t
          WHERE f.type_id = t.cvterm_id AND f.type_id > 0;
      EXECUTE 'select * from tmpcvtr where type_id = ' || soiterm_id || ';';
      get diagnostics pcount = row_count;
      raise notice 'all types in feature %',pcount;
  --- do it hard way, delete any child feature type from above (NOT IN clause did not work)
      FOR parent IN SELECT DISTINCT 0, t.cvterm_id, 0 FROM feature c, feature_relationship fr, cvterm t
              WHERE t.cvterm_id = c.type_id AND c.feature_id = fr.subject_id LOOP
          DELETE FROM tmpcvtr WHERE type_id = soiterm_id and object_id = soiterm_id
              AND subject_id = parent.subject_id;
      END LOOP;
      EXECUTE 'select * from tmpcvtr where type_id = ' || soiterm_id || ';';
      get diagnostics pcount = row_count;
      raise notice 'all types in feature after delete child %',pcount;
  
      --- create feature type relationship (store in tmpcvtr)
      CREATE TEMP TABLE tmproot (cv_id INTEGER not null, cvterm_id INTEGER not null, status INTEGER DEFAULT 0);
      cquery := 'SELECT * FROM tmproot tmp WHERE tmp.status = 0;';
      ---temp use tmpcvtr to hold instantiated SO relationship for speed
      ---use soterm_id as type_id, will delete from tmpcvtr
      ---us tmproot for this as well
      INSERT INTO tmproot (cv_id, cvterm_id, status) SELECT DISTINCT soi_cvid, c.subject_id, 0 FROM tmpcvtr c
          WHERE c.object_id = soiterm_id;
      EXECUTE cquery;
      GET DIAGNOSTICS pcount = ROW_COUNT;
      WHILE (pcount > 0) LOOP
          RAISE NOTICE 'num child temp (to be inserted) in tmpcvtr: %',pcount;
          INSERT INTO tmpcvtr (tmp_type, type_id, subject_id, object_id)
              SELECT DISTINCT fr.type_id, soiterm_id, c.type_id, p.cvterm_id FROM feature c, feature_relationship fr,
              tmproot p, feature pf, cvterm t WHERE c.feature_id = fr.subject_id AND fr.object_id = pf.feature_id
              AND p.cvterm_id = pf.type_id AND t.cvterm_id = c.type_id AND p.status = 0;
          UPDATE tmproot SET status = 1 WHERE status = 0;
          INSERT INTO tmproot (cv_id, cvterm_id, status)
              SELECT DISTINCT soi_cvid, c.type_id, 0 FROM feature c, feature_relationship fr,
              tmproot tmp, feature p, cvterm t WHERE c.feature_id = fr.subject_id AND fr.object_id = p.feature_id
              AND tmp.cvterm_id = p.type_id AND t.cvterm_id = c.type_id AND tmp.status = 1;
          UPDATE tmproot SET status = 2 WHERE status = 1;
          EXECUTE cquery;
          GET DIAGNOSTICS pcount = ROW_COUNT; 
      END LOOP;
      DELETE FROM tmproot;
  
      ---get transitive closure for soi
      PERFORM _fill_cvtermpath4soi(soiterm_id, soi_cvid);
  
      DROP TABLE tmpcvtr;
      DROP TABLE tmproot;
  
      RETURN 1;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION delete_analysis_features(integer, integer)
    RETURNS integer AS
  $BODY$DECLARE
     v_analysis_id        ALIAS FOR $1;
     v_limit              ALIAS FOR $2;
     tmpval               INTEGER;
     v_feature            RECORD;
     n_deleted            INTEGER;
   BEGIN
      n_deleted = 0;
      FOR v_feature IN 
          SELECT feature_id
          FROM analysisfeature 
          WHERE analysis_id = v_analysis_id
          LIMIT v_limit
      LOOP  
          RAISE NOTICE 'deleting %',v_feature.feature_id;
          EXECUTE 
           'DELETE FROM feature WHERE feature_id= ' ||v_feature.feature_id;
          n_deleted = n_deleted+1;
      END LOOP;
      RETURN n_deleted;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION feature_disjoint_from(integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.*
    FROM feature
     INNER JOIN featureloc AS x ON (x.feature_id=feature.feature_id)
     INNER JOIN featureloc AS y ON (y.feature_id=$1)
    WHERE
     x.srcfeature_id = y.srcfeature_id            AND
     ( x.fmax < y.fmin OR x.fmin > y.fmax ) $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION feature_intersecting(integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.*
    FROM feature
     INNER JOIN featureloc AS x ON (x.feature_id=feature.feature_id)
     INNER JOIN featureloc AS y ON (y.feature_id=$1)
    WHERE
     x.srcfeature_id = y.srcfeature_id            AND
     (( x.fmax >= y.fmin AND x.fmin <= y.fmax )
           OR
      ( y.fmin >= x.fmin AND y.fmin <= x.fmax )) $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION feature_overlaps(integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.*
    FROM feature
     INNER JOIN featureloc AS x ON (x.feature_id=feature.feature_id)
     INNER JOIN featureloc AS y ON (y.feature_id=$1)
    WHERE
     x.srcfeature_id = y.srcfeature_id            AND
     ( x.fmax >= y.fmin AND x.fmin <= y.fmax ) $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION feature_slice(integer, integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.* 
     FROM feature INNER JOIN featureloc USING (feature_id)
     WHERE boxquery($1, $2) @ boxrange(fmin,fmax)$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION feature_slice(character varying, integer, integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.* 
     FROM feature INNER JOIN featureloc USING (feature_id)
     INNER JOIN feature AS srcf ON (srcf.feature_id = featureloc.srcfeature_id)
     WHERE boxquery($2, $3) @ boxrange(fmin,fmax)
     AND srcf.name = $1 $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION feature_slice(integer, integer, integer)
    RETURNS SETOF feature AS
  $BODY$SELECT feature.* 
     FROM feature INNER JOIN featureloc USING (feature_id)
     WHERE boxquery($2, $3) @ boxrange(fmin,fmax)
     AND srcfeature_id = $1 $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION feature_subalignments(integer)
    RETURNS SETOF featureloc AS
  $BODY$
  DECLARE
    return_data featureloc%ROWTYPE;
    f_id ALIAS FOR $1;
    feature_data feature%rowtype;
    featureloc_data featureloc%rowtype;
  
    s text;
  
    fmin integer;
    slen integer;
  BEGIN
    --RAISE NOTICE 'feature_id is %', featureloc_data.feature_id;
    SELECT INTO feature_data * FROM feature WHERE feature_id = f_id;
  
    FOR featureloc_data IN SELECT * FROM featureloc WHERE feature_id = f_id LOOP
  
      --RAISE NOTICE 'fmin is %', featureloc_data.fmin;
  
      return_data.feature_id      = f_id;
      return_data.srcfeature_id   = featureloc_data.srcfeature_id;
      return_data.is_fmin_partial = featureloc_data.is_fmin_partial;
      return_data.is_fmax_partial = featureloc_data.is_fmax_partial;
      return_data.strand          = featureloc_data.strand;
      return_data.phase           = featureloc_data.phase;
      return_data.residue_info    = featureloc_data.residue_info;
      return_data.locgroup        = featureloc_data.locgroup;
      return_data.rank            = featureloc_data.rank;
  
      s = feature_data.residues;
      fmin = featureloc_data.fmin;
      slen = char_length(s);
  
      WHILE char_length(s) LOOP
        --RAISE NOTICE 'residues is %', s;
  
        --trim off leading match
        s = trim(leading '|ATCGNatcgn' from s);
        --if leading match detected
        IF slen > char_length(s) THEN
          return_data.fmin = fmin;
          return_data.fmax = featureloc_data.fmin + (slen - char_length(s));
  
          --if the string started with a match, return it,
          --otherwise, trim the gaps first (ie do not return this iteration)
          RETURN NEXT return_data;
        END IF;
  
        --trim off leading gap
        s = trim(leading '-' from s);
  
        fmin = featureloc_data.fmin + (slen - char_length(s));
      END LOOP;
    END LOOP;
  
    RETURN;
  
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  
  CREATE OR REPLACE FUNCTION featureloc_slice(character varying, integer, integer)
    RETURNS SETOF featureloc AS
  $BODY$SELECT featureloc.* 
     FROM featureloc 
     INNER JOIN feature AS srcf ON (srcf.feature_id = featureloc.srcfeature_id)
     WHERE boxquery($2, $3) @ boxrange(fmin,fmax)
     AND srcf.name = $1 $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  
  CREATE OR REPLACE FUNCTION featureloc_slice(integer, integer, integer)
    RETURNS SETOF featureloc AS
  $BODY$SELECT * 
     FROM featureloc 
     WHERE boxquery($2, $3) @ boxrange(fmin,fmax)
     AND srcfeature_id = $1 $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION featureloc_slice(integer, integer)
    RETURNS SETOF featureloc AS
  'SELECT * from featureloc where boxquery($1, $2) @ boxrange(fmin,fmax)'
  LANGUAGE 'sql' VOLATILE;
  
  
  
  CREATE OR REPLACE FUNCTION featureslice(integer, integer)
    RETURNS SETOF featureloc AS
  'SELECT * from featureloc where boxquery($1, $2) @ boxrange(fmin,fmax)'
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION fill_cvtermpath(integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      cvid alias for $1;
      root cvterm%ROWTYPE;
  
  BEGIN
  
      DELETE FROM cvtermpath WHERE cv_id = cvid;
  
      FOR root IN SELECT DISTINCT t.* from cvterm t LEFT JOIN cvterm_relationship r ON (t.cvterm_id = r.subject_id) INNER JOIN cvterm_relationship r2 ON (t.cvterm_id = r2.object_id) WHERE t.cv_id = cvid AND r.subject_id is null LOOP
          PERFORM _fill_cvtermpath4root(root.cvterm_id, root.cv_id);
      END LOOP;
      RETURN 1;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION fill_cvtermpath(character varying)
    RETURNS integer AS
  $BODY$
  DECLARE
      cvname alias for $1;
      cv_id   int;
      rtn     int;
  BEGIN
  
      SELECT INTO cv_id cv.cv_id from cv WHERE cv.name = cvname;
      SELECT INTO rtn fill_cvtermpath(cv_id);
      RETURN rtn;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION foo(integer)
    RETURNS character varying AS
  'SELECT name from cv'
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_all_object_ids(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      leaf alias for $1;
      cterm cvtermpath%ROWTYPE;
      exist_c int;
  BEGIN
  
  
      SELECT INTO exist_c count(*) FROM cvtermpath WHERE object_id = leaf and pathdistance <= 0;
      IF (exist_c > 0) THEN
          FOR cterm IN SELECT * FROM cvtermpath WHERE subject_id = leaf AND pathdistance > 0 LOOP
              RETURN NEXT cterm;
          END LOOP;
      ELSE
          FOR cterm IN SELECT * FROM _get_all_object_ids(leaf) LOOP
              RETURN NEXT cterm;
          END LOOP;
      END IF;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION get_all_subject_ids(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      root alias for $1;
      cterm cvtermpath%ROWTYPE;
      exist_c int;
  BEGIN
  
      SELECT INTO exist_c count(*) FROM cvtermpath WHERE object_id = root and pathdistance <= 0;
      IF (exist_c > 0) THEN
          FOR cterm IN SELECT * FROM cvtermpath WHERE object_id = root and pathdistance > 0 LOOP
              RETURN NEXT cterm;
          END LOOP;
      ELSE
          FOR cterm IN SELECT * FROM _get_all_subject_ids(root) LOOP
              RETURN NEXT cterm;
          END LOOP;
      END IF;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  -- TD
  CREATE OR REPLACE FUNCTION get_cv_id_for_feature()
    RETURNS integer AS
  $BODY$SELECT cv_id FROM cv WHERE name='sequence'$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cv_id_for_feature_relationsgip()
    RETURNS integer AS
  $BODY$SELECT cv_id FROM cv WHERE name='relationship'$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION get_cv_id_for_feature_relationship()
    RETURNS integer AS
  $BODY$SELECT cv_id FROM cv WHERE name='relationship'$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cv_id_for_featureprop()
    RETURNS integer AS
  $BODY$SELECT cv_id FROM cv WHERE name='feature_property'$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cv_id_for_relation()
    RETURNS integer AS
  $BODY$SELECT cv_id FROM cv WHERE name='relationship'$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cvterm_id_for_is_a()
    RETURNS integer AS
  $BODY$SELECT cvterm_id FROM cvterm WHERE name='is_a' AND cv_id=get_cv_id_for_relation()$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cycle_cvterm_id(integer, integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      cvid alias for $1;
      rootid alias for $2;
      rtn     int;
  BEGIN
  
      CREATE TEMP TABLE tmpcvtermpath(object_id int, subject_id int, cv_id int, type_id int, pathdistance int);
      CREATE INDEX tmp_cvtpath1 ON tmpcvtermpath(object_id, subject_id);
  
      SELECT INTO rtn _fill_cvtermpath4root2detect_cycle(rootid, cvid);
      IF (rtn > 0) THEN
          DROP TABLE tmpcvtermpath;
          RETURN rtn;
      END IF;
      DROP TABLE tmpcvtermpath;
      RETURN 0;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION get_cycle_cvterm_id(integer)
    RETURNS integer AS
  $BODY$
  DECLARE
      cvid alias for $1;
      root cvterm%ROWTYPE;
      rtn     int;
  BEGIN
  
      CREATE TEMP TABLE tmpcvtermpath(object_id int, subject_id int, cv_id int, type_id int, pathdistance int);
      CREATE INDEX tmp_cvtpath1 ON tmpcvtermpath(object_id, subject_id);
  
      FOR root IN SELECT DISTINCT t.* from cvterm t LEFT JOIN cvterm_relationship r ON (t.cvterm_id = r.subject_id) INNER JOIN cvterm_relationship r2 ON (t.cvterm_id = r2.object_id) WHERE t.cv_id = cvid AND r.subject_id is null LOOP
          SELECT INTO rtn _fill_cvtermpath4root2detect_cycle(root.cvterm_id, root.cv_id);
          IF (rtn > 0) THEN
              DROP TABLE tmpcvtermpath;
              RETURN rtn;
          END IF;
      END LOOP;
      DROP TABLE tmpcvtermpath;
      RETURN 0;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_cycle_cvterm_id(character varying)
    RETURNS integer AS
  $BODY$
  DECLARE
      cvname alias for $1;
      cv_id int;
      rtn int;
  BEGIN
  
      SELECT INTO cv_id cv.cv_id from cv WHERE cv.name = cvname;
      SELECT INTO rtn  get_cycle_cvterm_id(cv_id);
  
      RETURN rtn;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION get_cycle_cvterm_ids(integer)
    RETURNS SETOF integer AS
  $BODY$
  DECLARE
      cvid alias for $1;
      root cvterm%ROWTYPE;
      rtn     int;
  BEGIN
  
  
      FOR root IN SELECT DISTINCT t.* from cvterm t WHERE cv_id = cvid LOOP
          SELECT INTO rtn get_cycle_cvterm_id(cvid,root.cvterm_id);
          IF (rtn > 0) THEN
              RETURN NEXT rtn;
          END IF;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION get_organism_id(character varying)
    RETURNS integer AS
  $BODY$
  SELECT organism_id
    FROM organism
    WHERE genus=substring($1,1,position(' ' IN $1)-1)
      AND species=substring($1,position(' ' IN $1)+1)
   $BODY$
  LANGUAGE 'sql' VOLATILE;  
  
    -- TD
    CREATE OR REPLACE FUNCTION get_feature_type_id(character varying)
      RETURNS integer AS
    $BODY$
      SELECT cvterm_id 
      FROM cv INNER JOIN cvterm USING (cv_id)
      WHERE cvterm.name=$1 AND cv.name='sequence'
     $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_feature_id(character varying, character varying, character varying)
    RETURNS integer AS
  $BODY$
    SELECT feature_id 
    FROM feature
    WHERE uniquename=$1
      AND type_id=get_feature_type_id($2)
      AND organism_id=get_organism_id($3)
   $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids(text)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      sql alias for $1;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
      myrc3 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      FOR myrc IN EXECUTE sql LOOP
          RETURN NEXT myrc;
          FOR myrc2 IN SELECT * FROM get_up_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc2;
          END LOOP;
          FOR myrc3 IN SELECT * FROM get_sub_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc3;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
 
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_child_count(character varying, character varying, integer, character varying, bpchar)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      ptype alias for $1;
      ctype alias for $2;
      ccount alias for $3;
      operator alias for $4;
      is_an alias for $5;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type %ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT f.feature_id
          FROM feature f INNER join (select count(*) as c, p.feature_id FROM feature p
          INNER join cvterm pt ON (p.type_id = pt.cvterm_id) INNER join feature_relationship fr
          ON (p.feature_id = fr.object_id) INNER join feature c ON (c.feature_id = fr.subject_id)
          INNER join cvterm ct ON (c.type_id = ct.cvterm_id)
          WHERE pt.name = ' || quote_literal(ptype) || ' AND ct.name = ' || quote_literal(ctype)
          || ' AND p.is_analysis = ' || quote_literal(is_an) || ' group by p.feature_id) as cq
          ON (cq.feature_id = f.feature_id) WHERE cq.c ' || operator || ccount || ';';
      ---RAISE NOTICE '%', query; 
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_ont(character varying, character varying)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      aspect alias for $1;
      term alias for $2;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT fcvt.feature_id 
          FROM feature_cvterm fcvt, cv, cvterm t WHERE cv.cv_id = t.cv_id AND
          t.cvterm_id = fcvt.cvterm_id AND cv.name = ' || quote_literal(aspect) ||
          ' AND t.name = ' || quote_literal(term) || ';';
      IF (STRPOS(term, '%') > 0) THEN
          query := 'SELECT DISTINCT fcvt.feature_id 
              FROM feature_cvterm fcvt, cv, cvterm t WHERE cv.cv_id = t.cv_id AND
              t.cvterm_id = fcvt.cvterm_id AND cv.name = ' || quote_literal(aspect) ||
              ' AND t.name like ' || quote_literal(term) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_ont_root(character varying, character varying)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      aspect alias for $1;
      term alias for $2;
      query TEXT;
      subquery TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      subquery := 'SELECT t.cvterm_id FROM cv, cvterm t WHERE cv.cv_id = t.cv_id 
          AND cv.name = ' || quote_literal(aspect) || ' AND t.name = ' || quote_literal(term) || ';';
      IF (STRPOS(term, '%') > 0) THEN
          subquery := 'SELECT t.cvterm_id FROM cv, cvterm t WHERE cv.cv_id = t.cv_id 
              AND cv.name = ' || quote_literal(aspect) || ' AND t.name like ' || quote_literal(term) || ';';
      END IF;
      query := 'SELECT DISTINCT fcvt.feature_id 
          FROM feature_cvterm fcvt INNER JOIN (SELECT cvterm_id FROM get_it_sub_cvterm_ids(' || quote_literal(subquery) || ')) AS ont ON (fcvt.cvterm_id = ont.cvterm_id);';
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_property(character varying, character varying)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      p_type alias for $1;
      p_val alias for $2;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT fprop.feature_id 
          FROM featureprop fprop, cvterm t WHERE t.cvterm_id = fprop.type_id AND t.name = ' ||
          quote_literal(p_type) || ' AND fprop.value = ' || quote_literal(p_val) || ';';
      IF (STRPOS(p_val, '%') > 0) THEN
          query := 'SELECT DISTINCT fprop.feature_id 
              FROM featureprop fprop, cvterm t WHERE t.cvterm_id = fprop.type_id AND t.name = ' ||
              quote_literal(p_type) || ' AND fprop.value like ' || quote_literal(p_val) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_propval(character varying)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      p_val alias for $1;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT fprop.feature_id 
          FROM featureprop fprop WHERE fprop.value = ' || quote_literal(p_val) || ';';
      IF (STRPOS(p_val, '%') > 0) THEN
          query := 'SELECT DISTINCT fprop.feature_id 
              FROM featureprop fprop WHERE fprop.value like ' || quote_literal(p_val) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_type(character varying, bpchar)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      gtype alias for $1;
      is_an alias for $2;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT f.feature_id 
          FROM feature f, cvterm t WHERE t.cvterm_id = f.type_id AND t.name = ' || quote_literal(gtype) ||
          ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
      IF (STRPOS(gtype, '%') > 0) THEN
          query := 'SELECT DISTINCT f.feature_id 
              FROM feature f, cvterm t WHERE t.cvterm_id = f.type_id AND t.name like '
              || quote_literal(gtype) || ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_type_name(character varying, text, bpchar)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      gtype alias for $1;
      name alias for $2;
      is_an alias for $3;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT f.feature_id 
          FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id)
          WHERE t.name = ' || quote_literal(gtype) || ' AND (f.uniquename = ' || quote_literal(name)
          || ' OR f.name = ' || quote_literal(name) || ') AND f.is_analysis = ' || quote_literal(is_an) || ';';
   
      IF (STRPOS(name, '%') > 0) THEN
          query := 'SELECT DISTINCT f.feature_id 
              FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id)
              WHERE t.name = ' || quote_literal(gtype) || ' AND (f.uniquename like ' || quote_literal(name)
              || ' OR f.name like ' || quote_literal(name) || ') AND f.is_analysis = ' || quote_literal(is_an) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  -- TD RETUTN NULL => RETURN;
  CREATE OR REPLACE FUNCTION get_feature_ids_by_type_src(character varying, text, bpchar)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      gtype alias for $1;
      src alias for $2;
      is_an alias for $3;
      query TEXT;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT f.feature_id 
          FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id) INNER join featureloc fl
          ON (f.feature_id = fl.feature_id) INNER join feature src ON (src.feature_id = fl.srcfeature_id)
          WHERE t.name = ' || quote_literal(gtype) || ' AND src.uniquename = ' || quote_literal(src)
          || ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
   
      IF (STRPOS(gtype, '%') > 0) THEN
          query := 'SELECT DISTINCT f.feature_id 
              FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id) INNER join featureloc fl
              ON (f.feature_id = fl.feature_id) INNER join feature src ON (src.feature_id = fl.srcfeature_id)
              WHERE t.name like ' || quote_literal(gtype) || ' AND src.uniquename = ' || quote_literal(src)
              || ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
      END IF;
  
      FOR myrc IN SELECT * FROM get_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  
  CREATE OR REPLACE FUNCTION get_feature_relationship_type_id(character varying)
    RETURNS integer AS
  $BODY$
    SELECT cvterm_id 
    FROM cv INNER JOIN cvterm USING (cv_id)
    WHERE cvterm.name=$1 AND cv.name='relationship'
   $BODY$
  LANGUAGE 'sql' VOLATILE;
  

  
  
  CREATE OR REPLACE FUNCTION get_featureprop_type_id(character varying)
    RETURNS integer AS
  $BODY$
    SELECT cvterm_id 
    FROM cv INNER JOIN cvterm USING (cv_id)
    WHERE cvterm.name=$1 AND cv.name='feature_property'
   $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_gene_synonyms(text)
    RETURNS text AS
  $BODY$
  DECLARE
      v_identifier alias for $1;
      v_gene_synonyms text := '';
      v_synonyms RECORD;
  
  BEGIN
      FOR v_synonyms IN SELECT name FROM gene_synonym WHERE key = v_identifier and name != v_identifier LOOP
      
          -- RAISE NOTICE '%',v_synonyms.name;
          
          IF v_gene_synonyms = '' THEN
  		v_gene_synonyms := v_synonyms.name;
          ELSE 
  		v_gene_synonyms := v_gene_synonyms || ', ' || v_synonyms.name;
          END IF;
          
      END LOOP;
  
      RETURN v_gene_synonyms;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_graph_above(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      leaf alias for $1;
      cterm cvtermpath%ROWTYPE;
      cterm2 cvtermpath%ROWTYPE;
  
  BEGIN
  
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE subject_id = leaf LOOP
          RETURN NEXT cterm;
          FOR cterm2 IN SELECT * FROM get_all_object_ids(cterm.object_id) LOOP
              RETURN NEXT cterm2;
          END LOOP;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_graph_below(integer)
    RETURNS SETOF cvtermpath AS
  $BODY$
  DECLARE
      root alias for $1;
      cterm cvtermpath%ROWTYPE;
      cterm2 cvtermpath%ROWTYPE;
  
  BEGIN
  
      FOR cterm IN SELECT * FROM cvterm_relationship WHERE object_id = root LOOP
          RETURN NEXT cterm;
          FOR cterm2 IN SELECT * FROM get_all_subject_ids(cterm.subject_id) LOOP
              RETURN NEXT cterm2;
          END LOOP;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_it_sub_cvterm_ids(text)
    RETURNS SETOF cvterm AS
  $BODY$
  DECLARE
      query alias for $1;
      cterm cvterm%ROWTYPE;
      cterm2 cvterm%ROWTYPE;
  BEGIN
      FOR cterm IN EXECUTE query LOOP
          RETURN NEXT cterm;
          FOR cterm2 IN SELECT subject_id as cvterm_id FROM get_all_subject_ids(cterm.cvterm_id) LOOP
              RETURN NEXT cterm2;
          END LOOP;
      END LOOP;
      RETURN;
  END;   
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_organism_id(character varying, character varying)
    RETURNS integer AS
  $BODY$
    SELECT organism_id 
    FROM organism
    WHERE genus=$1
      AND species=$2
   $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION get_organism_id_abbrev(character varying)
    RETURNS integer AS
  $BODY$
  SELECT organism_id
    FROM organism
    WHERE substr(genus,1,1)=substring($1,1,1)
      AND species=substring($1,position(' ' IN $1)+1)
   $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  -- TD
  CREATE OR REPLACE FUNCTION get_sub_feature_ids(text)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      sql alias for $1;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
      FOR myrc IN EXECUTE sql LOOP
          FOR myrc2 IN SELECT * FROM get_sub_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  
 -- TD
  CREATE OR REPLACE FUNCTION get_sub_feature_ids(integer)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      root alias for $1;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
      FOR myrc IN SELECT DISTINCT subject_id AS feature_id FROM feature_relationship WHERE object_id = root LOOP
          RETURN NEXT myrc;
          FOR myrc2 IN SELECT * FROM get_sub_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
 
  -- TD
  CREATE OR REPLACE FUNCTION get_sub_feature_ids(integer, integer)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      root alias for $1;
      depth alias for $2;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
      FOR myrc IN SELECT DISTINCT subject_id AS feature_id, depth FROM feature_relationship WHERE object_id = root LOOP
          RETURN NEXT myrc;
          FOR myrc2 IN SELECT * FROM get_sub_feature_ids(myrc.feature_id,depth+1) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  -- TD
  CREATE OR REPLACE FUNCTION get_sub_feature_ids_by_type_src(character varying, text, bpchar)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      gtype alias for $1;
      src alias for $2;
      is_an alias for $3;
      query text;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
  
      query := 'SELECT DISTINCT f.feature_id FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id)
          INNER join featureloc fl
          ON (f.feature_id = fl.feature_id) INNER join feature src ON (src.feature_id = fl.srcfeature_id)
          WHERE t.name = ' || quote_literal(gtype) || ' AND src.uniquename = ' || quote_literal(src)
          || ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
   
      IF (STRPOS(gtype, '%') > 0) THEN
          query := 'SELECT DISTINCT f.feature_id FROM feature f INNER join cvterm t ON (f.type_id = t.cvterm_id)
               INNER join featureloc fl
              ON (f.feature_id = fl.feature_id) INNER join feature src ON (src.feature_id = fl.srcfeature_id)
              WHERE t.name like ' || quote_literal(gtype) || ' AND src.uniquename = ' || quote_literal(src)
              || ' AND f.is_analysis = ' || quote_literal(is_an) || ';';
      END IF;
      FOR myrc IN SELECT * FROM get_sub_feature_ids(query) LOOP
          RETURN NEXT myrc;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  -- TD
  CREATE OR REPLACE FUNCTION get_up_feature_ids(integer)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      leaf alias for $1;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  BEGIN
      FOR myrc IN SELECT DISTINCT object_id AS feature_id FROM feature_relationship WHERE subject_id = leaf LOOP
          RETURN NEXT myrc;
          FOR myrc2 IN SELECT * FROM get_up_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

 -- TD
  CREATE OR REPLACE FUNCTION get_up_feature_ids(text)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      sql alias for $1;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  
  BEGIN
      FOR myrc IN EXECUTE sql LOOP
          FOR myrc2 IN SELECT * FROM get_up_feature_ids(myrc.feature_id) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

-- TD
  CREATE OR REPLACE FUNCTION get_up_feature_ids(integer, integer)
    RETURNS SETOF feature_by_fx_type AS
  $BODY$
  DECLARE
      leaf alias for $1;
      depth alias for $2;
      myrc feature_by_fx_type%ROWTYPE;
      myrc2 feature_by_fx_type%ROWTYPE;
  BEGIN
      FOR myrc IN SELECT DISTINCT object_id AS feature_id, depth FROM feature_relationship WHERE subject_id = leaf LOOP
          RETURN NEXT myrc;
          FOR myrc2 IN SELECT * FROM get_up_feature_ids(myrc.feature_id,depth+1) LOOP
              RETURN NEXT myrc2;
          END LOOP;
      END LOOP;
      RETURN ;
  END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;  
 
  
  CREATE OR REPLACE FUNCTION p(integer, integer)
    RETURNS point AS
  'SELECT point ($1, $2)'
  LANGUAGE 'sql' VOLATILE;
  
  /*
  CREATE OR REPLACE FUNCTION phylonode_depth(integer)
    RETURNS double precision AS
  $BODY$DECLARE  id    ALIAS FOR $1;
    DECLARE  depth FLOAT := 0;
    DECLARE  curr_node phylonode%ROWTYPE;
    BEGIN
     SELECT INTO curr_node *
      FROM phylonode 
      WHERE phylonode_id=id;
     depth = depth + curr_node.distance;
     IF curr_node.parent_phylonode_id IS NULL
      THEN RETURN depth;
      ELSE RETURN depth + phylonode_depth(curr_node.parent_phylonode_id);
     END IF;
   END
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  */
  
  CREATE OR REPLACE FUNCTION plpgsql_call_handler()
    RETURNS language_handler AS
  '$libdir/plpgsql', 'plpgsql_call_handler'
  LANGUAGE 'c' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION project_featureloc_up(integer, integer)
    RETURNS featureloc AS
  $BODY$DECLARE
      in_featureloc_id alias for $1;
      up_srcfeature_id alias for $2;
      in_featureloc featureloc%ROWTYPE;
      up_featureloc featureloc%ROWTYPE;
      nu_featureloc featureloc%ROWTYPE;
      nu_fmin INT;
      nu_fmax INT;
      nu_strand INT;
  BEGIN
   SELECT INTO in_featureloc
     featureloc.*
    FROM featureloc
    WHERE featureloc_id = in_featureloc_id;
  
   SELECT INTO up_featureloc
     up_fl.*
    FROM featureloc AS in_fl
    INNER JOIN featureloc AS up_fl
      ON (in_fl.srcfeature_id = up_fl.feature_id)
    WHERE
     in_fl.featureloc_id = in_featureloc_id AND
     up_fl.srcfeature_id = up_srcfeature_id;
  
    IF up_featureloc.strand IS NULL
     THEN RETURN NULL;
    END IF;
    
    IF up_featureloc.strand < 0
    THEN
     nu_fmin = project_point_up(in_featureloc.fmax,
                                up_featureloc.fmin,up_featureloc.fmax,-1);
     nu_fmax = project_point_up(in_featureloc.fmin,
                                up_featureloc.fmin,up_featureloc.fmax,-1);
     nu_strand = -in_featureloc.strand;
    ELSE
     nu_fmin = project_point_up(in_featureloc.fmin,
                                up_featureloc.fmin,up_featureloc.fmax,1);
     nu_fmax = project_point_up(in_featureloc.fmax,
                                up_featureloc.fmin,up_featureloc.fmax,1);
     nu_strand = in_featureloc.strand;
    END IF;
    in_featureloc.fmin = nu_fmin;
    in_featureloc.fmax = nu_fmax;
    in_featureloc.strand = nu_strand;
    in_featureloc.srcfeature_id = up_featureloc.srcfeature_id;
    RETURN in_featureloc;
  END$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION project_point_down(integer, integer, integer, integer)
    RETURNS integer AS
  $BODY$SELECT
    CASE WHEN $4<0
     THEN $3-$1
     ELSE $1+$2
    END AS p$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION project_point_up(integer, integer, integer, integer)
    RETURNS integer AS
  $BODY$SELECT
    CASE WHEN $4<0
     THEN $3-$1             -- rev strand
     ELSE $1-$2             -- fwd strand
    END AS p$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION remove_transformant_image_location(character varying, character varying)
    RETURNS integer AS
  $BODY$
    DECLARE
    v_image_location      ALIAS FOR $1;
    v_user                ALIAS FOR $2;
    v_transformant_id     INT;
    v_fragment_id         INT;
    v_transformat_type    character varying;
    v_image_loc_type_id   INT;
    v_row_count           INT;
    v_image_count		INT;
    v_imaged_transformant_count INT;
    v_owner_type_id       INT;
  
    v_status              character varying = 'crossed';
  
    BEGIN
  
  	-- =======================================
  	-- Find feature id
  	-- =======================================
          SELECT INTO v_transformant_id feature_id 
          FROM featureprop
          WHERE value = v_image_location;
  
          IF NOT FOUND THEN
  		RAISE EXCEPTION 'image location % not found', v_image_location;
  	END IF;
  
  	-- =======================================
  	-- First determine that the feature id is 
          -- a transformant
  	-- =======================================
  	SELECT INTO v_transformat_type cvterm.name
  	FROM feature, cvterm
  	WHERE type_id = cvterm_id
  	  AND feature_id = v_transformant_id;
  	
  	IF v_transformat_type != 'transformant' THEN 
  		RAISE EXCEPTION 'feature_id is not a transformant';
  	END IF;
  
  	SELECT INTO v_image_loc_type_id cvterm_id
  	FROM cvterm
  	WHERE name = 'image_location'
  	AND is_obsolete = 0;      
  
  	SELECT INTO v_owner_type_id cvterm_id
  	FROM cvterm
  	WHERE name = 'owner'
  	AND is_obsolete = 0;    
  
  	-- =======================================
  	-- Remove the image from featureprop
  	-- =======================================
  	DELETE FROM featureprop
  	WHERE feature_id = v_transformant_id
  	  AND value = v_image_location
  	  AND type_id = v_image_loc_type_id;
  
  	GET DIAGNOSTICS v_row_count = ROW_COUNT;
  
  	-- =======================================
  	-- Continue only if one row was deleted
  	-- =======================================
  	IF v_row_count = 1 THEN
  
  		-- =======================================
  		-- Determine number of images associated to
  		-- the transformant
  		-- =======================================
  		SELECT INTO v_image_count count(1)
  		FROM featureprop
  		WHERE feature_id = v_transformant_id
  		  AND type_id = v_image_loc_type_id;
  
  		-- =======================================
  		-- Update the transformant owner status from 
  		-- "imaged" to "crossed" only if no 
  		-- image is associated to the transformant
  		-- =======================================
  		IF v_image_count = 0 THEN
  
  			UPDATE featureprop 
  			SET value = v_status 
  			WHERE feature_id = v_transformant_id
  			  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'owner' AND is_obsolete = 0)
                            AND value ='imaged';
  			
  			v_row_count = null;
  			GET DIAGNOSTICS v_row_count = ROW_COUNT;
  
  			INSERT INTO feature_status_history
  			VALUES (v_transformant_id, v_status, v_user, now());
  
  			-- =======================================
  			-- Continue only if one row was updated
  			-- =======================================
  			IF v_row_count = 1 THEN
  
  				-- =======================================
  				-- Determine number of transformants associated 
  				-- to the tiling path fragment which have 
  				-- an associated image
  				-- =======================================
  				SELECT INTO v_imaged_transformant_count count(1)
  				FROM featureprop
  				WHERE feature_id in (SELECT feature_id FROM featureprop WHERE value = (SELECT value FROM featureprop 
  												       WHERE feature_id = v_transformant_id AND type_id = (SELECT cvterm_id FROM cvterm WHERE name='tiling_path_fragment_id' AND is_obsolete=0)
  												      )
  											  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name='tiling_path_fragment_id' AND is_obsolete=0)
  						    )
  				  AND type_id = v_owner_type_id
                                    AND value = 'imaged';
  
  				-- =======================================
  				-- Update the fragment owner status from 
  				-- "imaged" to "transformant" only if all 
  				-- associated transformants have no association
  				-- to an image
  				-- =======================================
  				IF v_imaged_transformant_count = 0 THEN
  
                                          SELECT INTO v_fragment_id value 
  					FROM featureprop 
  					WHERE feature_id = v_transformant_id 
  					  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name='tiling_path_fragment_id' AND is_obsolete=0);
  
  					UPDATE featureprop 
  					SET value = v_status
  					WHERE feature_id = v_fragment_id 
  					  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'owner' AND is_obsolete = 0)
                                            AND value = 'imaged';
  
  					v_row_count = null;
  					GET DIAGNOSTICS v_row_count = ROW_COUNT;
  
  					INSERT INTO feature_status_history
  					VALUES (v_fragment_id, v_status, v_user, now());
  
  					-- =======================================
  					-- Continue only if one row was updated
  					-- =======================================
  					IF v_row_count != 1 THEN
  						RAISE EXCEPTION 'unable to update fragment status from imaged to transformant <transformantFeatureId:%>',v_transformant_id;
  					END IF;
  
  				END IF;
  			ELSE 
  				RAISE EXCEPTION 'unable to update transformant status from imaged to transformant <transformantFeatureId:%>', v_transformant_id ;
  			END IF;
  			
  		END IF;
  
  	ELSE 
  		RAISE EXCEPTION 'unable to delete image location';
  	END IF;
  	
  	RETURN v_row_count;
  
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
 
  CREATE OR REPLACE FUNCTION reverse_string(text)
    RETURNS text AS
  $BODY$
   DECLARE 
    reversed_string TEXT;
    incoming ALIAS FOR $1;
   BEGIN
     reversed_string = '';
     FOR i IN REVERSE char_length(incoming)..1 loop
       reversed_string = reversed_string || substring(incoming FROM i FOR 1);
     END loop;
   RETURN reversed_string;
  END$BODY$
  LANGUAGE 'plpgsql' VOLATILE; 
  
  
  CREATE OR REPLACE FUNCTION reverse_complement(text)
    RETURNS text AS
  'SELECT reverse_string(complement_residues($1))'
  LANGUAGE 'sql' VOLATILE;
  
  

  
  CREATE OR REPLACE FUNCTION store_analysis(character varying, character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
     v_program            ALIAS FOR $1;
     v_programversion     ALIAS FOR $2;
     v_sourcename         ALIAS FOR $3;
     pkval                INTEGER;
   BEGIN
      SELECT INTO pkval analysis_id
        FROM analysis
        WHERE program=v_program AND
              programversion=v_programversion AND
              sourcename=v_sourcename;
      IF NOT FOUND THEN
        INSERT INTO analysis 
         (program,programversion,sourcename)
           VALUES
         (v_program,v_programversion,v_sourcename);
        RETURN currval('analysis_analysis_id_seq');
      END IF;
      RETURN pkval;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION store_analysisfeature(integer, integer, integer, integer, integer, integer, character varying, character varying, integer, boolean, integer, double precision, double precision, double precision, double precision)
    RETURNS integer AS
  $BODY$DECLARE
    v_srcfeature_id       ALIAS FOR $1;
    v_fmin                ALIAS FOR $2;
    v_fmax                ALIAS FOR $3;
    v_strand              ALIAS FOR $4;
    v_dbxref_id           ALIAS FOR $5;
    v_organism_id         ALIAS FOR $6;
    v_name                ALIAS FOR $7;
    v_uniquename          ALIAS FOR $8;
    v_type_id             ALIAS FOR $9;
    v_is_analysis         ALIAS FOR $10;
    v_analysis_id         ALIAS FOR $11;
    v_rawscore            ALIAS FOR $12;
    v_normscore           ALIAS FOR $13;
    v_significance        ALIAS FOR $14;
    v_identity            ALIAS FOR $15;
    
    v_feature_id               INT;
    v_analysisfeature_id       INT;
   BEGIN
     IF v_is_analysis != 't' THEN
       RAISE EXCEPTION 'is_analysis must be true';
     END IF;
     SELECT INTO v_feature_id
      store_feature(
          v_srcfeature_id,
          v_fmin,
          v_fmax,
          v_strand,
          v_dbxref_id,
          v_organism_id,
          v_name,
          v_uniquename,
          v_type_id,
          v_is_analysis);
      SELECT INTO v_analysisfeature_id analysisfeature_id
        FROM analysisfeature
        WHERE feature_id=v_feature_id     AND
              analysis_id=v_analysis_id;
      IF NOT FOUND THEN
        INSERT INTO analysisfeature
         (analysis_id,feature_id,
          rawscore,
          normscore,
          significance,
          identity)
           VALUES
          ( v_analysis_id,
            v_feature_id,
            v_rawscore,
            v_normscore,
            v_significance,
            v_identity   );
         RETURN v_feature_id;
      ELSE
          UPDATE analysisfeature
           SET 
             rawscore= v_rawscore,
             normscore= v_normscore,
             significance= v_significance,
             identity = v_identity
          WHERE analysisfeature_id=v_analysisfeature_id;
      END IF;
    RETURN v_feature_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_db(character varying)
    RETURNS integer AS
  $BODY$DECLARE
     v_name             ALIAS FOR $1;
  
     v_db_id            INTEGER;
   BEGIN
      SELECT INTO v_db_id db_id
        FROM db
        WHERE name=v_name;
      IF NOT FOUND THEN
        INSERT INTO db
         (name)
           VALUES
         (v_name);
         RETURN currval('db_db_id_seq');
      END IF;
      RETURN v_db_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_dbxref(character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
     v_dbname                ALIAS FOR $1;
     v_accession             ALIAS FOR $2;
  
     v_db_id                 INTEGER;
     v_dbxref_id             INTEGER;
   BEGIN
      SELECT INTO v_db_id
        store_db(v_dbname);
      SELECT INTO v_dbxref_id dbxref_id
        FROM dbxref
        WHERE db_id=v_db_id       AND
              accession=v_accession;
      IF NOT FOUND THEN
        INSERT INTO dbxref
         (db_id,accession)
           VALUES
         (v_db_id,v_accession);
         RETURN currval('dbxref_dbxref_id_seq');
      END IF;
      RETURN v_dbxref_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION store_feature(integer, integer, integer, integer, integer, integer, character varying, character varying, integer, boolean)
    RETURNS integer AS
  $BODY$DECLARE
    v_srcfeature_id       ALIAS FOR $1;
    v_fmin                ALIAS FOR $2;
    v_fmax                ALIAS FOR $3;
    v_strand              ALIAS FOR $4;
    v_dbxref_id           ALIAS FOR $5;
    v_organism_id         ALIAS FOR $6;
    v_name                ALIAS FOR $7;
    v_uniquename          ALIAS FOR $8;
    v_type_id             ALIAS FOR $9;
    v_is_analysis         ALIAS FOR $10;
    v_feature_id          INT;
    v_featureloc_id       INT;
   BEGIN
      IF v_dbxref_id IS NULL THEN
        SELECT INTO v_feature_id feature_id
        FROM feature
        WHERE uniquename=v_uniquename     AND
              organism_id=v_organism_id   AND
              type_id=v_type_id;
      ELSE
        SELECT INTO v_feature_id feature_id
        FROM feature
        WHERE dbxref_id=v_dbxref_id;
      END IF;
      IF NOT FOUND THEN
        INSERT INTO feature
         ( dbxref_id           ,
           organism_id         ,
           name                ,
           uniquename          ,
           type_id             ,
           is_analysis         )
          VALUES
          ( v_dbxref_id           ,
            v_organism_id         ,
            v_name                ,
            v_uniquename          ,
            v_type_id             ,
            v_is_analysis         );
        v_feature_id = currval('feature_feature_id_seq');
      ELSE
        UPDATE feature SET
          dbxref_id   =  v_dbxref_id           ,
          organism_id =  v_organism_id         ,
          name        =  v_name                ,
          uniquename  =  v_uniquename          ,
          type_id     =  v_type_id             ,
          is_analysis =  v_is_analysis
        WHERE
          feature_id=v_feature_id;
      END IF;
    PERFORM store_featureloc(v_feature_id,
                             v_srcfeature_id,
                             v_fmin,
                             v_fmax,
                             v_strand,
                             0,
                             0);
    RETURN v_feature_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION store_feature_dbxref(integer, character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_dbname              ALIAS FOR $2;
    v_accession           ALIAS FOR $3;
    v_dbxref_id           INT;
    v_feature_dbxref_id   INT;
   BEGIN
      IF v_feature_id IS NULL THEN RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
      SELECT INTO v_dbxref_id store_dbxref(v_dbname,v_accession);
      SELECT INTO v_feature_dbxref_id feature_dbxref_id
        FROM feature_dbxref
        WHERE feature_id=v_feature_id     AND
              dbxref_id=v_dbxref_id;
      IF NOT FOUND THEN
        INSERT INTO feature_dbxref
          ( feature_id,
            dbxref_id)
          VALUES
          (  v_feature_id,
             v_dbxref_id);
      END IF;
    RETURN v_dbxref_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_feature_synonym(integer, character varying, integer, boolean, boolean, integer)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_syn                 ALIAS FOR $2;
    v_type_id             ALIAS FOR $3;
    v_is_current          ALIAS FOR $4;
    v_is_internal         ALIAS FOR $5;
    v_pub_id              ALIAS FOR $6;
    v_synonym_id          INT;
    v_feature_synonym_id  INT;
   BEGIN
      IF v_feature_id IS NULL THEN RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
      SELECT INTO v_synonym_id synonym_id
        FROM synonym
        WHERE name=v_syn                  AND
              type_id=v_type_id;
      IF NOT FOUND THEN
        INSERT INTO synonym
          ( name,
            synonym_sgml,
            type_id)
          VALUES
          ( v_syn,
            v_syn,
            v_type_id);
        v_synonym_id = currval('synonym_synonym_id_seq');
      END IF;
      SELECT INTO v_feature_synonym_id feature_synonym_id
          FROM feature_synonym
          WHERE feature_id=v_feature_id   AND
                synonym_id=v_synonym_id   AND
                pub_id=v_pub_id;
      IF NOT FOUND THEN
        INSERT INTO feature_synonym
          ( feature_id,
            synonym_id,
            pub_id,
            is_current,
            is_internal)
          VALUES
          ( v_feature_id,
            v_synonym_id,
            v_pub_id,
            v_is_current,
            v_is_internal);
        v_feature_synonym_id = currval('feature_synonym_feature_synonym_id_seq');
      ELSE
        UPDATE feature_synonym
          SET is_current=v_is_current, is_internal=v_is_internal
          WHERE feature_synonym_id=v_feature_synonym_id;
      END IF;
    RETURN v_feature_synonym_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_featureloc(integer, integer, integer, integer, integer, integer, integer)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_srcfeature_id       ALIAS FOR $2;
    v_fmin                ALIAS FOR $3;
    v_fmax                ALIAS FOR $4;
    v_strand              ALIAS FOR $5;
    v_rank                ALIAS FOR $6;
    v_locgroup            ALIAS FOR $7;
    v_featureloc_id       INT;
   BEGIN
      IF v_feature_id IS NULL THEN RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
      SELECT INTO v_featureloc_id featureloc_id
        FROM featureloc
        WHERE feature_id=v_feature_id     AND
              rank=v_rank                 AND
              locgroup=v_locgroup;
      IF NOT FOUND THEN
        INSERT INTO featureloc
          ( feature_id,
            srcfeature_id,
            fmin,
            fmax,
            strand,
            rank,
            locgroup)
          VALUES
          (  v_feature_id,
             v_srcfeature_id,
             v_fmin,
             v_fmax,
             v_strand,
             v_rank,
             v_locgroup);
        v_featureloc_id = currval('featureloc_featureloc_id_seq');
      ELSE
        UPDATE featureloc SET
          feature_id    =  v_feature_id,
          srcfeature_id =  v_srcfeature_id,
          fmin          =  v_fmin,
          fmax          =  v_fmax,
          strand        =  v_strand,
          rank          =  v_rank,
          locgroup      =  v_locgroup
        WHERE
          featureloc_id=v_featureloc_id;
      END IF;
    RETURN v_featureloc_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_featureprop(integer, character varying, character varying, integer)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_propname            ALIAS FOR $2;
    v_value               ALIAS FOR $3;
    v_rank                ALIAS FOR $4;
    v_featureprop_id      INT;
    v_type_id             INT;
  
   BEGIN
      IF v_feature_id IS NULL THEN RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
      SELECT INTO v_type_id cvterm_id
        FROM cvterm INNER JOIN cv USING (cv_id)
        WHERE cv.name='feature_property'
         AND  cvterm.name=v_propname;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'no such featureprop in cvterm as %', v_propname;
       END IF;
      DELETE FROM featureprop WHERE feature_id=v_feature_id AND
       type_id=v_type_id AND rank=v_rank;
      INSERT INTO featureprop
          ( feature_id,
            type_id,
            rank,
            value)
          VALUES
          (  v_feature_id,
             v_type_id,
             v_rank,
             v_value);
      v_featureprop_id = currval('featureprop_featureprop_id_seq');
    RETURN v_featureprop_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

  CREATE OR REPLACE FUNCTION store_featureprop(integer, character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_propname            ALIAS FOR $2;
    v_value               ALIAS FOR $3;
    -- TD v_rank_id             ALIAS FOR $4;
    v_featureprop_id      INT;
    v_type_id             INT;
  
   BEGIN
      IF v_feature_id IS NULL THEN RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
      
      SELECT INTO v_type_id cvterm_id
        FROM cvterm INNER JOIN cv USING (cv_id)
        WHERE cv.name='feature_property'
         AND  cvterm.name=v_propname;
         
      IF NOT FOUND THEN
        RAISE EXCEPTION 'no such featureprop in cvterm as %', v_propname;
       END IF;
       
      DELETE FROM featureprop WHERE feature_id=v_feature_id AND
       type_id=v_type_id AND rank=v_rank;
      INSERT INTO featureprop
          ( feature_id,
            type_id,
            rank,
            value)
          VALUES
          (  v_feature_id,
             v_type_id,
             v_rank,
             v_value);
    RETURN v_dbxref_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_featureprop(character varying, character varying, integer)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $3;
    v_propname            ALIAS FOR $1;
    v_value               ALIAS FOR $2;
    v_rank_id             INT;
    v_featureprop_id      INT;
    v_type_id             INT;
  
   BEGIN
      
      -- check that feature id is not null
      IF v_feature_id IS NULL THEN 
        RAISE EXCEPTION 'feature_id cannot be null';
      END IF;
  
      -- get cvterm type id for feature property name
      SELECT INTO v_type_id cvterm_id
        FROM cvterm INNER JOIN cv USING (cv_id)
        WHERE cv.name='feature_property'
         AND  cvterm.name=v_propname;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'no such featureprop in cvterm as %', v_propname;
       END IF;
      
      -- check if property is in featureprop; otherwise insert it.
      SELECT INTO v_rank_id rank
        FROM featureprop 
        WHERE feature_id=v_feature_id		
          AND type_id=v_type_id
          AND value=v_value;
      IF NOT FOUND THEN
  
        SELECT INTO v_rank_id (case when max(rank) is null then 0 else max(rank) + 1 end) 
        FROM featureprop
        WHERE feature_id = v_feature_id
          AND type_id = v_type_id;
  
        INSERT INTO featureprop ( feature_id,
                                  type_id,
                                  rank,
                                  value)
             VALUES ( v_feature_id,
                      v_type_id,
                      v_rank_id,
                      v_value);
      END IF;
  
    RETURN v_rank_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_organism(character varying, character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
     v_genus            ALIAS FOR $1;
     v_species          ALIAS FOR $2;
     v_common_name      ALIAS FOR $3;
  
     v_organism_id      INTEGER;
   BEGIN
      SELECT INTO v_organism_id organism_id
        FROM organism
        WHERE genus=v_genus               AND
              species=v_species;
      IF NOT FOUND THEN
        INSERT INTO organism
         (genus,species,common_name)
           VALUES
         (v_genus,v_species,v_common_name);
         RETURN currval('organism_organism_id_seq');
      ELSE
        UPDATE organism
         SET common_name=v_common_name
        WHERE organism_id = v_organism_id;
      END IF;
      RETURN v_organism_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION store_organism(character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
     v_genus            ALIAS FOR $1;
     v_species          ALIAS FOR $2;
  
     v_organism_id      INTEGER;
   BEGIN
      SELECT INTO v_organism_id organism_id
        FROM organism
        WHERE genus=v_genus               AND
              species=v_species;
      IF NOT FOUND THEN
        INSERT INTO organism
         (genus,species_name)
           VALUES
         (v_genus,v_species_common_name);
         RETURN currval('organism_organism_id_seq');
      END IF;
      RETURN v_organism_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_regtype(integer, character varying)
    RETURNS integer AS
  $BODY$DECLARE
    v_feature_id          ALIAS FOR $1;
    v_regtype             ALIAS FOR $2;
    v_f_id                INT;
    v_row_count           INT;
   BEGIN
  
        SELECT INTO v_f_id feature_id
        FROM fragment_regulatory_type
        WHERE feature_id = v_feature_id;
  
        IF NOT FOUND THEN
          INSERT INTO fragment_regulatory_type
           ( feature_id,
             regtype   )
          VALUES
           ( v_feature_id,
             v_regtype   );
        ELSE
          UPDATE fragment_regulatory_type
            SET regtype = v_regtype
            WHERE feature_id = v_feature_id;
        END IF;
  
    
    GET DIAGNOSTICS v_row_count = ROW_COUNT;
    RETURN v_row_count;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_transformant(integer, character varying, character varying)
    RETURNS integer AS
  $BODY$DECLARE
    v_fragment_id         ALIAS FOR $1;
    v_uniquename          ALIAS FOR $2;
    v_status              ALIAS FOR $3;
    v_type_id             INT;
    v_feature_id          INT;
    v_featureloc_id       INT;
    v_new_status          CHAR;
   BEGIN
  
        v_feature_id = nextval('feature_feature_id_seq');
  
        SELECT INTO v_type_id cvterm_id
        FROM cvterm
        WHERE name = 'transformant'
          AND is_obsolete = 0;
  
        INSERT INTO feature
         ( feature_id         ,
           organism_id        ,  
           name               ,       
           uniquename         ,
           residues           ,
           seqlen             ,
           md5checksum        ,         
           type_id            )
        SELECT
           v_feature_id       ,
  	 organism_id        ,
           v_uniquename       ,
           v_uniquename       ,
           residues           ,
           seqlen             ,
           md5checksum        ,
           v_type_id          
        FROM feature
        WHERE feature_id = v_fragment_id;
  
        v_featureloc_id = nextval('featureloc_featureloc_id_seq');
  
        INSERT INTO featureloc
         ( featureloc_id      ,
           feature_id         ,
           srcfeature_id      ,
           fmin               ,
           is_fmin_partial    ,
           fmax               ,
           is_fmax_partial    ,
           strand             ,
           phase              ,
           residue_info       ,
           locgroup           ,
           rank               )
        SELECT 
           v_featureloc_id    ,
           v_feature_id       ,
           srcfeature_id      ,
           fmin               ,
           is_fmin_partial    ,
           fmax               ,
           is_fmax_partial    ,
           strand             ,
           phase              ,
           residue_info       ,
           locgroup           ,
           rank               
        FROM featureloc
        WHERE feature_id = v_fragment_id;
  
        SELECT INTO v_type_id cvterm_id
        FROM cvterm
        WHERE name = 'owner'
          AND is_obsolete = 0;
  
  
        IF (v_status is null)
        THEN 
  	
  	v_new_status = 'gsi_ready';
  
  	      INSERT INTO featureprop
  	       ( feature_id         ,
  		 type_id            ,
  		 value              )
  	      VALUES 
  	       ( v_feature_id       ,
  		 v_type_id          ,
  		 v_new_status       );
  
        ELSE
  
  	      INSERT INTO featureprop
  	       ( feature_id         ,
  		 type_id            ,
  		 value              )
  	      VALUES 
  	       ( v_feature_id       ,
  		 v_type_id          ,
  		 v_status           );
  
        END IF; 
  
        SELECT INTO v_type_id cvterm_id
        FROM cvterm
        WHERE name = 'tiling_path_fragment_id'
          AND is_obsolete = 0;
  
        INSERT INTO featureprop
         ( feature_id         ,
  	 type_id            ,
  	 value              )
        VALUES 
         ( v_feature_id       ,
  	 v_type_id          ,
  	 v_fragment_id      );
                         
    RETURN v_feature_id;
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION store_transformant_image_location(integer, character varying, integer, character varying)
    RETURNS integer AS
  $BODY$
    DECLARE
    v_transformant_id     ALIAS FOR $1;
    v_image_location      ALIAS FOR $2;
    v_rank                ALIAS FOR $3;
    v_user                ALIAS FOR $4;
    v_fragment_id     INT;
    v_transformat_type    character varying;
    v_type_id             INT;
    v_row_count           INT;
  
    v_status              character varying = 'imaged';
  
    BEGIN
  
  	SELECT INTO v_transformat_type cvterm.name
  	FROM feature, cvterm
  	WHERE type_id = cvterm_id
  	  AND feature_id = v_transformant_id;
  	
  	IF v_transformat_type != 'transformant' THEN RAISE EXCEPTION 'feature_id is not a transformant';
  	END IF;
  
  	SELECT INTO v_type_id cvterm_id
  	FROM cvterm
  	WHERE name = 'image_location'
  	  AND is_obsolete = 0;      
  
  	UPDATE featureprop
  	SET value = v_image_location
          WHERE feature_id = v_transformant_id
            AND rank = v_rank
            AND type_id = v_type_id;
  
  	GET DIAGNOSTICS v_row_count = ROW_COUNT;
  
  	IF v_row_count = 1 THEN
  
  		UPDATE featureprop 
  		SET value = v_status 
  		WHERE feature_id = v_transformant_id
  		  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'owner' AND is_obsolete = 0);
  
                  SELECT INTO v_fragment_id value 
                  FROM featureprop 
                  WHERE feature_id = v_transformant_id 
                    AND type_id = (SELECT cvterm_id FROM cvterm WHERE name='tiling_path_fragment_id' AND is_obsolete=0);
  
  		UPDATE featureprop 
  		SET value = v_status
  		WHERE feature_id = v_fragment_id
  		  AND type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'owner' AND is_obsolete = 0);
  
  		INSERT INTO feature_status_history
  		VALUES (v_transformant_id, v_status, v_user, now());
  
  		INSERT INTO feature_status_history
  		VALUES (v_fragment_id, v_status, v_user, now());
  
  
  
  	ELSE 
  		RAISE EXCEPTION 'unable to update image location';
  	END IF;
  	
  	RETURN v_row_count;
  
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION store_transformant_image_location(integer)
    RETURNS integer AS
  $BODY$
    DECLARE
    v_transformant_id     ALIAS FOR $1;
    v_image_location      character varying = ' ';
    v_type_id             INT;
    v_rank                INT;
    v_transformat_type    character varying;
  
    BEGIN
  
  	SELECT INTO v_transformat_type cvterm.name
  	FROM feature, cvterm
  	WHERE type_id = cvterm_id
  	  AND feature_id = v_transformant_id;
  	
  	IF v_transformat_type != 'transformant' THEN RAISE EXCEPTION 'feature_id is not a transformant';
  	END IF;
  
  	SELECT INTO v_type_id cvterm_id
  	FROM cvterm
  	WHERE name = 'image_location'
  	  AND is_obsolete = 0;      
  
          SELECT INTO v_rank (case when max(rank) is null then 0 else max(rank) + 1 end) 
          FROM featureprop
          WHERE feature_id = v_transformant_id
            AND type_id = v_type_id;
  
  
  	INSERT INTO featureprop(feature_id, type_id, value, rank) 
  	VALUES (v_transformant_id, v_type_id, v_image_location,v_rank);
  
  	RETURN v_rank;
  
   END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  
  CREATE OR REPLACE FUNCTION subsequence(integer, integer, integer, integer)
    RETURNS text AS
  $BODY$SELECT 
    CASE WHEN $4<0 
     THEN reverse_complement(substring(srcf.residues,$2+1,($3-$2)))
     ELSE substring(residues,$2+1,($3-$2))
    END AS residues
    FROM feature AS srcf
    WHERE
     srcf.feature_id=$1$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION subsequence_by_feature(integer, integer, integer)
    RETURNS text AS
  $BODY$SELECT 
    CASE WHEN strand<0 
     THEN reverse_complement(substring(srcf.residues,fmin+1,(fmax-fmin)))
     ELSE substring(srcf.residues,fmin+1,(fmax-fmin))
    END AS residues
    FROM feature AS srcf
     INNER JOIN featureloc ON (srcf.feature_id=featureloc.srcfeature_id)
    WHERE
     featureloc.feature_id=$1 AND
     featureloc.rank=$2 AND
     featureloc.locgroup=$3$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION subsequence_by_feature(integer)
    RETURNS text AS
  'SELECT subsequence_by_feature($1,0,0)'
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION subsequence_by_featureloc(integer)
    RETURNS text AS
  $BODY$SELECT 
    CASE WHEN strand<0 
     THEN reverse_complement(substring(srcf.residues,fmin+1,(fmax-fmin)))
     ELSE substring(srcf.residues,fmin+1,(fmax-fmin))
    END AS residues
    FROM feature AS srcf
     INNER JOIN featureloc ON (srcf.feature_id=featureloc.srcfeature_id)
    WHERE
     featureloc_id=$1$BODY$
  LANGUAGE 'sql' VOLATILE;
  
CREATE OR REPLACE FUNCTION subsequence_by_subfeatures(integer, integer, integer, integer)
    RETURNS text AS
  $BODY$
  DECLARE v_feature_id ALIAS FOR $1;
  DECLARE v_rtype_id   ALIAS FOR $2;
  DECLARE v_rank       ALIAS FOR $3;
  DECLARE v_locgroup   ALIAS FOR $4;
  DECLARE subseq       TEXT;
  DECLARE seqrow       RECORD;
  BEGIN 
    subseq = '';
   FOR seqrow IN
     SELECT
      CASE WHEN strand<0 
       THEN reverse_complement(substring(srcf.residues,fmin+1,(fmax-fmin)))
       ELSE substring(srcf.residues,fmin+1,(fmax-fmin))
      END AS residues
      FROM feature AS srcf
       INNER JOIN featureloc ON (srcf.feature_id=featureloc.srcfeature_id)
       INNER JOIN feature_relationship AS fr
         ON (fr.subject_id=featureloc.feature_id)
      WHERE
       fr.object_id=v_feature_id AND
       fr.type_id=v_rtype_id AND
       featureloc.rank=v_rank AND
       featureloc.locgroup=v_locgroup
      ORDER BY fr.rank
    LOOP
     subseq = subseq  || seqrow.residues;
    END LOOP;
   RETURN subseq;
  END
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION subsequence_by_typed_subfeatures(integer, integer, integer, integer)
    RETURNS text AS
  $BODY$
  DECLARE v_feature_id ALIAS FOR $1;
  DECLARE v_ftype_id   ALIAS FOR $2;
  DECLARE v_rank       ALIAS FOR $3;
  DECLARE v_locgroup   ALIAS FOR $4;
  DECLARE subseq       TEXT;
  DECLARE seqrow       RECORD;
  BEGIN 
    subseq = '';
   FOR seqrow IN
     SELECT
      CASE WHEN strand<0 
       THEN reverse_complement(substring(srcf.residues,fmin+1,(fmax-fmin)))
       ELSE substring(srcf.residues,fmin+1,(fmax-fmin))
      END AS residues
    FROM feature AS srcf
     INNER JOIN featureloc ON (srcf.feature_id=featureloc.srcfeature_id)
     INNER JOIN feature AS subf ON (subf.feature_id=featureloc.feature_id)
     INNER JOIN feature_relationship AS fr ON (fr.subject_id=subf.feature_id)
    WHERE
       fr.object_id=v_feature_id AND
       subf.type_id=v_ftype_id AND
       featureloc.rank=v_rank AND
       featureloc.locgroup=v_locgroup
    ORDER BY fr.rank
     LOOP
     subseq = subseq  || seqrow.residues;
    END LOOP;
   RETURN subseq;
  END
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;  
  
  CREATE OR REPLACE FUNCTION subsequence_by_subfeatures(integer, integer)
    RETURNS text AS
  'SELECT subsequence_by_subfeatures($1,$2,0,0)'
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION subsequence_by_subfeatures(integer)
    RETURNS text AS
  $BODY$
  SELECT subsequence_by_subfeatures($1,get_feature_relationship_type_id('part_of'),0,0)
  $BODY$
  LANGUAGE 'sql' VOLATILE;
  
  
  
  
  CREATE OR REPLACE FUNCTION subsequence_by_typed_subfeatures(integer, integer)
    RETURNS text AS
  'SELECT subsequence_by_typed_subfeatures($1,$2,0,0)'
  LANGUAGE 'sql' VOLATILE;
  
  /*
  CREATE OR REPLACE FUNCTION translate_codon(text, integer)
    RETURNS character AS
  'SELECT aa FROM genetic_code.gencode_codon_aa WHERE codon=$1 AND gencode_id=$2'
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION translate_dna(text)
    RETURNS text AS
  'SELECT translate_dna($1,1)'
  LANGUAGE 'sql' VOLATILE;
  */
  
  CREATE OR REPLACE FUNCTION translate_dna(text, integer)
    RETURNS text AS
  $BODY$
   DECLARE 
    dnaseq ALIAS FOR $1;
    gcode ALIAS FOR $2;
    translation TEXT;
    dnaseqlen INT;
    codon CHAR(3);
    aa CHAR(1);
    i INT;
   BEGIN
     translation = '';
     dnaseqlen = char_length(dnaseq);
     i=1;
     WHILE i+1 < dnaseqlen loop
       codon = substring(dnaseq,i,3);
       aa = translate_codon(codon,gcode);
       translation = translation || aa;
       i = i+3;
     END loop;
   RETURN translation;
  END$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  
  CREATE OR REPLACE FUNCTION order_exons(integer)
    RETURNS void AS
  $BODY$
    DECLARE
      parent_type      ALIAS FOR $1;
      exon_id          int;
      part_of          int;
      exon_type        int;
      strand           int;
      arow             RECORD;
      order_by         varchar;
      rowcount         int;
      exon_count       int;
      ordered_exons    int;    
      transcript_id    int;
    BEGIN
      SELECT INTO part_of cvterm_id FROM cvterm WHERE name='part_of'
        AND cv_id IN (SELECT cv_id FROM cv WHERE name='relationship');
      --SELECT INTO exon_type cvterm_id FROM cvterm WHERE name='exon'
      --  AND cv_id IN (SELECT cv_id FROM cv WHERE name='sequence');
  
      --RAISE NOTICE 'part_of %, exon %',part_of,exon_type;
  
      FOR transcript_id IN
        SELECT feature_id FROM feature WHERE type_id = parent_type
      LOOP
        SELECT INTO rowcount count(*) FROM feature_relationship
          WHERE object_id = transcript_id
            AND rank = 0;
  
        --Dont modify this transcript if there are already numbered exons or
        --if there is only one exon
        IF rowcount = 1 THEN
          --RAISE NOTICE 'skipping transcript %, row count %',transcript_id,rowcount;
          CONTINUE;
        END IF;
  
        --need to reverse the order if the strand is negative
        SELECT INTO strand strand FROM featureloc WHERE feature_id=transcript_id;
        IF strand > 0 THEN
            order_by = 'fl.fmin';      
        ELSE
            order_by = 'fl.fmax desc';
        END IF;
  
        exon_count = 0;
        FOR arow IN EXECUTE 
          'SELECT fr.*, fl.fmin, fl.fmax
            FROM feature_relationship fr, featureloc fl
            WHERE fr.object_id  = '||transcript_id||'
              AND fr.subject_id = fl.feature_id
              AND fr.type_id    = '||part_of||'
              ORDER BY '||order_by
        LOOP
          --number the exons for a given transcript
          UPDATE feature_relationship
            SET rank = exon_count 
            WHERE feature_relationship_id = arow.feature_relationship_id;
          exon_count = exon_count + 1;
        END LOOP; 
  
      END LOOP;
  
    END;
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION r4_map(character varying, integer)
    RETURNS integer AS
  $BODY$
  select r5_start+($2-r4_start) from r4_to_r5_mapping where
  scaffold = $1 and
  r4_start <= $2 and
  r4_start+length > $2$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  CREATE OR REPLACE FUNCTION r5_map(character varying, integer)
    RETURNS integer AS
  $BODY$
  select r4_start+($2-r5_start) from r4_to_r5_mapping where
  scaffold = $1 and
  r5_start <= $2 and
  r5_start+length > $2$BODY$
  LANGUAGE 'sql' VOLATILE;
  
  -- TD
  CREATE OR REPLACE FUNCTION share_exons()
    RETURNS void AS
  $BODY$    
    DECLARE    
    BEGIN
      /* Generate a table of shared exons */
      CREATE temporary TABLE shared_exons AS
        SELECT gene.feature_id as gene_feature_id
             , gene.uniquename as gene_uniquename
             , transcript1.uniquename as transcript1
             , exon1.feature_id as exon1_feature_id
             , exon1.uniquename as exon1_uniquename
             , transcript2.uniquename as transcript2
             , exon2.feature_id as exon2_feature_id
             , exon2.uniquename as exon2_uniquename
             , exon1_loc.fmin /* = exon2_loc.fmin */
             , exon1_loc.fmax /* = exon2_loc.fmax */
        FROM feature gene
          JOIN cvterm gene_type ON gene.type_id = gene_type.cvterm_id
          JOIN cv gene_type_cv USING (cv_id)
          JOIN feature_relationship gene_transcript1 ON gene.feature_id = gene_transcript1.object_id
          JOIN feature transcript1 ON gene_transcript1.subject_id = transcript1.feature_id
          JOIN cvterm transcript1_type ON transcript1.type_id = transcript1_type.cvterm_id
          JOIN cv transcript1_type_cv ON transcript1_type.cv_id = transcript1_type_cv.cv_id
          JOIN feature_relationship transcript1_exon1 ON transcript1_exon1.object_id = transcript1.feature_id
          JOIN feature exon1 ON transcript1_exon1.subject_id = exon1.feature_id
          JOIN cvterm exon1_type ON exon1.type_id = exon1_type.cvterm_id
          JOIN cv exon1_type_cv ON exon1_type.cv_id = exon1_type_cv.cv_id
          JOIN featureloc exon1_loc ON exon1_loc.feature_id = exon1.feature_id
          JOIN feature_relationship gene_transcript2 ON gene.feature_id = gene_transcript2.object_id
          JOIN feature transcript2 ON gene_transcript2.subject_id = transcript2.feature_id
          JOIN cvterm transcript2_type ON transcript2.type_id = transcript2_type.cvterm_id
          JOIN cv transcript2_type_cv ON transcript2_type.cv_id = transcript2_type_cv.cv_id
          JOIN feature_relationship transcript2_exon2 ON transcript2_exon2.object_id = transcript2.feature_id
          JOIN feature exon2 ON transcript2_exon2.subject_id = exon2.feature_id
          JOIN cvterm exon2_type ON exon2.type_id = exon2_type.cvterm_id
          JOIN cv exon2_type_cv ON exon2_type.cv_id = exon2_type_cv.cv_id
          JOIN featureloc exon2_loc ON exon2_loc.feature_id = exon2.feature_id
        WHERE gene_type_cv.name = 'sequence'
          AND gene_type.name = 'gene'
          AND transcript1_type_cv.name = 'sequence'
          AND transcript1_type.name = 'mRNA'
          AND transcript2_type_cv.name = 'sequence'
          AND transcript2_type.name = 'mRNA'
          AND exon1_type_cv.name = 'sequence'
          AND exon1_type.name = 'exon'
          AND exon2_type_cv.name = 'sequence'
          AND exon2_type.name = 'exon'
          AND exon1.feature_id < exon2.feature_id
          AND exon1_loc.rank = 0
          AND exon2_loc.rank = 0
          AND exon1_loc.fmin = exon2_loc.fmin
          AND exon1_loc.fmax = exon2_loc.fmax
      ;
      
      /* Choose one of the shared exons to be the canonical representative.
         We pick the one with the smallest feature_id.
       */
      CREATE temporary TABLE canonical_exon_representatives AS
        SELECT gene_feature_id, min(exon1_feature_id) AS canonical_feature_id, fmin
        FROM shared_exons
        GROUP BY gene_feature_id,fmin
      ;
      
      CREATE temporary TABLE exon_replacements AS
        SELECT DISTINCT shared_exons.exon2_feature_id AS actual_feature_id
                      , canonical_exon_representatives.canonical_feature_id
                      , canonical_exon_representatives.fmin
        FROM shared_exons
          JOIN canonical_exon_representatives USING (gene_feature_id)
        WHERE shared_exons.exon2_feature_id <> canonical_exon_representatives.canonical_feature_id
          AND shared_exons.fmin = canonical_exon_representatives.fmin
      ;
      
      UPDATE feature_relationship 
        SET subject_id = (
              SELECT canonical_feature_id
              FROM exon_replacements
              WHERE feature_relationship.subject_id = exon_replacements.actual_feature_id)
        WHERE subject_id IN (
          SELECT actual_feature_id FROM exon_replacements
      );
      
      UPDATE feature_relationship
        SET object_id = (
              SELECT canonical_feature_id
              FROM exon_replacements
              WHERE feature_relationship.subject_id = exon_replacements.actual_feature_id)
        WHERE object_id IN (
          SELECT actual_feature_id FROM exon_replacements
      );
      
      UPDATE feature
        SET is_obsolete = true
        WHERE feature_id IN (
          SELECT actual_feature_id FROM exon_replacements
      );
    END;    
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;