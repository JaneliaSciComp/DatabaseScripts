ALTER TABLE primerannos ADD CONSTRAINT primerannos_primerid_fk FOREIGN KEY primerannos_primerid_fk_ind (primerid) REFERENCES primers(id)
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE primers ADD COLUMN dateordered DATETIME;
