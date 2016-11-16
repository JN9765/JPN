


import pymysql

db = pymysql.connect(host="localhost",    # hostname
                     user="root",         # MySQL user, default is root
                     passwd="WildcatF*n32",   # MySSQL password
                     db="nfl_players")       # MySQL db name, e.g. lab1

# you must create a Cursor object. It will let
#  you execute all the queries you need
cur = db.cursor()

# dual is a special table in MySQL that always exists, it will return 1
cur.execute("select count(*) from dual")

# print output to the console
for row in cur.fetchall():
    print row

db.close()