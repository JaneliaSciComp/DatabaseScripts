#!/opt/python/bin/python2.7

import sys
import MySQLdb

# SQL statements
SQL = {
  'LINES': "SELECT l.name,robot_id FROM line_vw l JOIN line_property_vw lp ON (l.id=lp.line_id AND lp.type='flycore_project') WHERE lp.value LIKE 'Split_GAL4-%' ORDER BY 1",
}

# -----------------------------------------------------------------------------
def sqlError (e):
    try:
      print 'MySQL error [%d]: %s' % (e.args[0],e.args[1])
    except IndexError:
      print 'MySQL error: %s' % e
    sys.exit(-1)

def dbConnect ():
    try:
        conn = MySQLdb.connect(host='mysql3',user='sageRead',passwd='sageRead',db='sage')
    except MySQLdb.Error as e:
        sqlError(e)
    try:
        cursor = conn.cursor()
        return(cursor)
    except MySQLdb.Error as e:
        sqlError(e)

def findLines (cursor):
    try:
        cursor.execute(SQL['LINES'])
    except MySQLdb.Error as e:
        sqlError(e)
    for (line,robot_id) in cursor:
        print "%s\t%s" % (line,robot_id)

# -----------------------------------------------------------------------------

if __name__ == '__main__':
    (cursor) = dbConnect()
    findLines(cursor)
