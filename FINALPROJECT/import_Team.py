import pymysql
import csv
from db_connect import *

def import_Team():

	is_success = True
	insert_stmt = "insert into Team (team_name,division_name, conference_name,coach,city,state,players_signed,average_age,offensive_sal_cap,defensive_sal_cap,dead_cap,total_cap,cap_space,super_bowl_wins,conference_titles) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"

	try:

		connection = create_connection()
		cursor = connection.cursor()

		csvfile = open("nfl_teams.csv", "rb")
		reader = csv.reader(csvfile)
		
		for i, row in enumerate(reader):
			if i == 0: 
				continue
			
			
			for j, val in enumerate(row):
				if j == 0:
					Team = val
				elif j == 1:
					Division = val
						
				elif j == 2:
					Conference = val
				
				elif j == 3:
					Coach = val
				
				elif j == 4:
					City = val
					
				elif j == 5:
					State = val
					
				elif j == 6:
					SIGNED = int(val)
						
				elif j == 7:
					AVG_AGE = float(val)
				elif j == 8:
					OFFENSE = val
					OFFENSE = OFFENSE.replace('$','')
					OFFENSE = OFFENSE.replace(',','')
					OFFENSE = int(OFFENSE)
				elif j == 9:
					DEFENSE = val
					DEFENSE = DEFENSE.replace('$','')
					DEFENSE = DEFENSE.replace(',','')
					DEFENSE = int(DEFENSE)
				elif j == 10:
					DEAD = val
					DEAD = DEAD.replace('$','')
					DEAD = DEAD.replace(',','')
					DEAD = int(DEAD)
				elif j == 11:
					TOTAL_CAP = val
					TOTAL_CAP = TOTAL_CAP.replace('$','')
					TOTAL_CAP = TOTAL_CAP.replace(',','')
					TOTAL_CAP = int(TOTAL_CAP)
				elif j == 12:
					CAP_SPACE = val
					CAP_SPACE = CAP_SPACE.replace('$','')
					CAP_SPACE = CAP_SPACE.replace(',','')
					CAP_SPACE = int(CAP_SPACE)
					
					
				elif j == 15:
					Team_Super_Bowl_Wins = int(val)
						
				elif j == 16:
					Conference_Champions_based_on_Team = int(val)
					
					
			insert_status = run_prepared_stmt(cursor, insert_stmt, (Team,Division, Conference,Coach,City,State,SIGNED,AVG_AGE,OFFENSE,DEFENSE,DEAD,TOTAL_CAP,CAP_SPACE,Team_Super_Bowl_Wins,Conference_Champions_based_on_Team))
			if insert_status is False:
				is_success = False
				return is_success

		commit_status = do_commit(connection)
		if commit_status is False:
			is_success = False

	except pymysql.Error as e:
		print "import_Team error: " + e.strerror
		
	return is_success

is_success = import_Team()
print "is_success: ", is_success





