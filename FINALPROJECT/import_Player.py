import pymysql
import csv
from db_connect import *

def import_Player():

	is_success = True
	insert_stmt = "insert into Player (player_id,jersey_number,player_name,position_name,height,weight,age,years_played,college,team_name) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"

	try:

		connection = create_connection()
		cursor = connection.cursor()

		csvfile = open("nfl_players.csv", "rb")
		reader = csv.reader(csvfile)
		
		for i, row in enumerate(reader):
			if i == 0: 
				continue
			
			
			for j, val in enumerate(row):
				if j == 0:
					player_id = int(val)
					
				elif j == 1:
					jersey_number = val
					
				elif j == 2:
					player_name = val
					
				elif j == 3:
					position_name = val
					
				elif j == 5:
					height = int(val)
					
				elif j == 6:
					weight = int(val)
					
				elif j == 7:
					age = int(val)
					
				elif j == 8:
					years_played = int(val)
					
				elif j == 9:
					college = val
				
				
				elif j == 10:
					team_name = val
				
					
			insert_status = run_prepared_stmt(cursor, insert_stmt, (player_id,jersey_number,player_name,position_name,height,weight,age,years_played,college,team_name))
			if insert_status is False:
				is_success = False
				return is_success

		commit_status = do_commit(connection)
		if commit_status is False:
			is_success = False

	except pymysql.Error	 as e:
		print "import_Player error: " + e.strerror
		
	return is_success

is_success = import_Player()
print "is_success: ", is_success





