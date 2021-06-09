ALTER table odor ADD COLUMN completed_date DATE after recieved_date;

ALTER table odor CHANGE  COLUMN recieved_date received_date DATE;

