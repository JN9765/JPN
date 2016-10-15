import pymysql
import db_connect


def single_insert():
	is_success = True

	try:
		connection = db_connect.create_connection()
		cursor = connection.cursor()
		insert_status = db_connect.run_insert(cursor, "insert into Player (team_name) values ('Chicago Bears')")
		
		if insert_status == True:
			db_connect.do_commit(connection)
		else:
			is_success = False
		
		db_connect.destroy_connection(connection)
	    
	except pymysql.Error as error:
		is_success = False
		print "single_insert: ", error
	return is_success

is_success = single_insert()
print "is_success : ", is_success