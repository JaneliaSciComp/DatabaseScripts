select primers.*,primerannos.annotype,primerannos.information 
from primers
left join primerannos on primers.id=primerannos.primerid 
where ((primers.id RLIKE '.*GATCAGTACG.*') 
   or (primers.primername RLIKE '.*GATCAGTACG.*') 
   or (primers.primertype RLIKE '.*GATCAGTACG.*') 
   or (primers.sequence RLIKE '.*GATCAGTACG.*') 
   or (primers.comments RLIKE '.*GATCAGTACG.*') 
   or (primers.submitter RLIKE '.*GATCAGTACG.*') 
   or (primers.categorynumber RLIKE '.*GATCAGTACG.*') 
   or (primers.primernumber RLIKE '.*GATCAGTACG.*') 
   or (primers.location RLIKE '.*GATCAGTACG.*') 
   or (primerannos.annotype RLIKE '.*GATCAGTACG.*') 
   or (primerannos.information RLIKE '.*GATCAGTACG.*') 
   or (primers.sequence RLIKE '.*CGTACTGATC.*'));
