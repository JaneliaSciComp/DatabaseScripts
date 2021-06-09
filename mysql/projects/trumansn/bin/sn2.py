#!/usr/bin/python
import MySQLdb

cnx = MySQLdb.connect(user='trumansnAdmin', passwd='trum@nsnAdm1n',host='dev-db',db='trumansn')
cursor = cnx.cursor()
query = ("SELECT id, commissure FROM orig_single_neuron WHERE commissure REGEXP '\n'")
cursor.execute(query)

for (id, commissure) in cursor:
    split_type = commissure.split('\n')
    for i in range(len(split_type)):
        type_value = split_type[i]
        insert_new_row = ("INSERT INTO single_neuron_property (sn_id, type,value) VALUES (" + str(id) + ",'commissure','" + type_value + "');")
        print(insert_new_row)
        
cursor.close()

cnx.close()
