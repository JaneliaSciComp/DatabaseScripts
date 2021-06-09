
# internal wiki
mysql -u wikiApp -pwikiApp -h mysql1  wiki < call-update-username-function.sql

# external wiki
ssh conference-db
mysql -u root -p wiki < call-update-username-function.sql
mysql -u root -p openwiki < call-update-username-function.sql

