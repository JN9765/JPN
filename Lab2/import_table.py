import pymysql
import csv
from db_connect import *

def import_Division():

	is_success = True
	insert_stmt = "insert into Division (division_name, conference_name,sb_wins,conference_championships) values (%s, %s,%s,%s)"

	try:

		connection = create_connection()
		cursor = connection.cursor()

		csvfile = open("nfl_teams.csv", "rb")
		reader = csv.reader(csvfile)
		
		for i, row in enumerate(reader):
			if i == 0: 
				continue
			
			elif i % 4 == 0:
				for j, val in enumerate(row):
					if j == 1:
						Division = val
					elif j == 2:
						Conference = val
					elif j == 13:
						SB_division_wins = int(val)
					elif j == 14:
						conference_championships_division = int(val)
				insert_status = run_prepared_stmt(cursor, insert_stmt, (Division, Conference,SB_division_wins,conference_championships_division))
				if insert_status is False:
					is_success = False
					return is_success

		commit_status = do_commit(connection)
		if commit_status is False:
			is_success = False

	except Error as e:
		print "import_Divsion error: " + e.strerror
		
	return is_success

is_success = import_Division()
print "is_success: ", is_success