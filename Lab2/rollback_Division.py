import pymysql
import csv
from db_connect import *

def run_prepared_stmt_remove(cursor, stmt):
	is_success = True
	try:
		cursor.execute(stmt)
	except pymysql.Error as error:
		print "Error: ", error
		is_success = False
	return is_success

def rollback_Division():

	is_success = True
	insert_stmt = "SET FOREIGN_KEY_CHECKS = 0; TRUNCATE Division; SET FOREIGN_KEY_CHECKS = 1"

	try:

		connection = create_connection()
		cursor = connection.cursor()

		insert_status = run_prepared_stmt_remove(cursor, insert_stmt)
		if insert_status is False:
			is_success = False
			return is_success

		commit_status = do_commit(connection)
		if commit_status is False:
			is_success = False

	except pymysql.Error as e:
		print "reset_tables error: " + e.strerror
		
	return is_success

is_success = rollback_Division()