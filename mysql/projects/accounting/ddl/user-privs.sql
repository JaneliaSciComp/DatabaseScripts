-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON chargeback.* TO chargebackAdmin@'localhost';
GRANT ALL PRIVILEGES ON chargeback.* TO chargebackAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE ON chargeback.* TO chargebackApp@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON chargeback.* TO chargebackApp@'%';

GRANT FILE ON *.* TO chargebackApp@'%';

GRANT SELECT ON chargeback.* TO chargebackRead@'localhost';
GRANT SELECT ON chargeback.* TO chargebackRead@'%';
