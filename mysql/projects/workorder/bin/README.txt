These are used to generate the people.csv and projects.csv files that are 
imported into JobManager.

Search for "JobManager" in the wiki to learn more about this process.

You need to manually save the "Visitor Program Depts and Proj Codes....xls" from
an email, open it up in Open Office and save it as vs.csv in csv format.  Make sure you
leave the text delimiter option empty during the save prompt.

run_and_send_to_FM.bsh will run each script and copy the output files to the 
JobManager import folder.  This is scheduled on pinero-ws with cron to run at
2:55AM every morning.

