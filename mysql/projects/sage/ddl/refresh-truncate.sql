/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

truncate table attenuator;
truncate table cv;
truncate table cv_relationship;
truncate table cv_term;
truncate table cv_term_constraint;
truncate table cv_term_relationship;
truncate table data_set;
truncate table data_set_family;
truncate table data_set_field;
truncate table data_set_field_value;
truncate table data_set_view;
truncate table detector;
truncate table event;
truncate table event_property;
truncate table experiment;
truncate table experiment_property;
truncate table experiment_relationship;
truncate table gene;
truncate table gene_synonym;
truncate table image;
truncate table image_property;
truncate table image_session;
truncate table laser;
truncate table line;
truncate table line_event;
truncate table line_event_property;
truncate table line_property;
truncate table namespace_sequence_number;
truncate table observation;
truncate table organism;
truncate table phase;
truncate table phase_property;
truncate table score;
-- alter table score truncate partition p0;
-- alter table score truncate partition p1;
-- alter table score truncate partition p2;
-- alter table score truncate partition p3;
-- alter table score truncate partition p4;
-- alter table score truncate partition p5;
-- alter table score truncate partition p6;
-- alter table score truncate partition p7;
alter table score_array truncate partition p0;
alter table score_array truncate partition p1;
alter table score_array truncate partition p2;
alter table score_array truncate partition p3;
alter table score_array truncate partition p4;
alter table score_array truncate partition p5;
truncate table score_statistic;
-- alter table score_statistic truncate partition p0;
truncate table secondary_image;
truncate table session;
truncate table session_property;
truncate table session_relationship;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
