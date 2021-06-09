#!/usr/local/python26/bin/python

import os
import sys
import MySQLdb

# SQL statements
SQL = {
  'ALL': "SELECT family,id,path FROM image_data_mv WHERE path IS NOT NULL AND name like '%lsm%' AND family='split_screen_review' order by 1,3",
  'MISSING': "SELECT family,id,path FROM image_data_mv WHERE path IS NOT NULL AND file_size IS NULL order by 1,3",
  'GETFS': "SELECT id,value FROM image_property_vw WHERE image_id=%s AND cv='light_imagery' AND type='file_size'",
  'ADDFS': "INSERT INTO image_property (image_id,type_id,value) VALUES(%s,getCvTermId('light_imagery','file_size',''),%s)",
}
count = {'found': 0, 'updated': 0, 'added': 0,'not found': 0}

# -----------------------------------------------------------------------------

def sqlError (e):
    try:
      print "MySQL error [%d]: %s" % (e.args[0],e.args[1])
    except IndexError:
      print "MySQL error: %s" % e
    sys.exit(-1)

# -----------------------------------------------------------------------------

def updateImage (id,path,filesize):
    c.execute(SQL['GETFS'],[int(id)])
    r = c.fetchone()
    if r:
        if int(r[1]) != filesize:
            logWrite(path," has size ",r[1],' ',filesize)
            count['updated']+=1
        else:
            count['found']+=1
    else:
        try:
            c.execute(SQL['ADDFS'],[int(id),filesize])
        except MySQLdb.Error,e:
            sqlError(e)
        if c.rowcount == 1:
            logWrite("Added file_size %d for image ID %s" % (filesize,id))
            count['added']+=1
        conn.commit();

def logWrite (*args):
    msg = ''
    for i in args:
        msg += str(i)
    print(msg)
    logfile.write(msg+"\n")



try:
    conn = MySQLdb.connect(host='mysql3',user='sageApp',passwd='h3ll0K1tty',db='sage')
except MySQLdb.Error,e:
    sqlError(e)
try:
    c = conn.cursor()
except MySQLdb.Error,e:
    sqlError(e)

errorfile = open('update_file_size.err','w')
logfile = open('update_file_size.log','w')
logWrite("Fixing images with null file sizes")
try:
    c.execute(SQL['ALL'])
    logWrite("Images found: ",c.rowcount)
    for (family,id,path) in c:
        try:
            filesize = os.path.getsize(path)
            logfile.write(path+"\n")
            updateImage(id,path,filesize)
        except OSError:
            errorfile.write('Could not read '+path+"\n")
            count['not found']+=1
except MySQLdb.Error,e:
    sqlError(e)
logWrite(count)
