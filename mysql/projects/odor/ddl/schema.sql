/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `odor`;
CREATE TABLE odor (
  id INTEGER unsigned NOT NULL auto_increment,
  compound VARCHAR(50) NOT NULL,
  synonym  VARCHAR(100) NULL,
  lab_number INTEGER unsigned NULL,
  cas_registry VARCHAR(25) NULL,
  formula VARCHAR(50) NULL,
  molecular_weight FLOAT UNSIGNED NULL,
  calc_vapor_press FLOAT UNSIGNED NULL,
  chem_group VARCHAR(25) NULL,
  chem_class VARCHAR(25) NULL,
  ventral DOUBLE UNSIGNED NULL,
  descriptors VARCHAR(100) NULL,
  monell_number INTEGER NULL,
  firestein_number INTEGER NULL,
  albianu_number INTEGER NULL,
  m72_response FLOAT SIGNED NULL,
  bottle_number INTEGER unsigned NULL,
  volume VARCHAR(25) NULL,
  purity VARCHAR(25) NULL,
  vendor VARCHAR(25) NULL,
  price VARCHAR(25) NULL,
  catalog_number VARCHAR(25) NULL,
  recieved_date DATE NULL,
  link VARCHAR(255) NULL, 
  PRIMARY KEY(id)
)
ENGINE InnoDB;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

