-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON chargeback.* TO chargebackAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON chargeback.* TO chargebackApp@'%';
GRANT FILE ON *.* TO chargebackApp@'%';

GRANT SELECT ON chargeback.* TO chargebackRead@'%';

GRANT SELECT ON chargeback.compute_chargeback_vw TO workorderFM@'%';
GRANT SELECT ON chargeback.compute_chargeback TO workorderFM@'%';
GRANT SELECT ON chargeback.department TO workorderFM@'%';
