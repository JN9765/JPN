import pymysql
import csv
from db_connect import *

def import_Position_played():

	is_success = True
	insert_stmt = "insert into Position_played (position_name,position_type) values (%s,%s)"

	try:

		connection = create_connection()
		cursor = connection.cursor()

		csvfile = open("nfl_players.csv", "rb")
		reader = csv.reader(csvfile)
		
		positions = []
		for i, row in enumerate(reader):
			new_position = []
			if i == 0: 
				continue
			
			
			for j, val in enumerate(row):
				
				if j == 3:
					position_name = val
					new_position.append(position_name)
				elif j == 4:
					position_type = val
					new_position.append(position_type)
				
				
			if new_position not in positions:
				positions.append(new_position)		
			
					
		for i in range(len(positions)):
			for j in range(len(positions[0])-1):
				position_name = positions[i][j]
				position_type = positions[i][j+1]
				insert_status = run_prepared_stmt(cursor, insert_stmt, (position_name,position_type))
			if insert_status is False:
				is_success = False
				return is_success

		commit_status = do_commit(connection)
		if commit_status is False:
			is_success = False

	except pymysql.Error as e:
		print "import_Position_played error: " + e.strerror
		
	return is_success

is_success = import_Position_played()
print "is_success: ", is_success





