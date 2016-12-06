import pymysql
from db_connect_update import *
teams = ['Arizona Cardinals','Los Angeles Rams','Seattle Seahawks',
'San Fransisco 49s',
'New Orleans Saints',
'Atlanta Falcons',
'Carolina Panthers',
'Tampa Bay Buccanners',
'Dallas Cowboys',
'New York Giants',
'Philadelphia Eagles',
'Washington Redskins',
'Green Bay Packers',
'Minnesota Vikings',
'Detroit Lions',
'Chicago Bears',
'Denver Broncos',
'Oakland Raiders',
'San Diego Chargers',
'Kansas City Chiefs',
'Houston Texans',
'Tennesse Titans',
'Indianapolis Colts',
'Jacksonville Jaguars',
'New England Patriots',
'New York Jets',
'Miami Dolphins',
'Buffalo Bills',
'Baltimore Ravens',
'Cincinnati Bengals',
'Pittsburgh Steelers',
'Cleveland Browns']

positions = ['QB','RB','WR','TE','OL','K','P','DB','DL','LB','LS']

def print_menu():
	

	print "Queries with and without user input"
	
	print ""
	print "0. Exit Program"
	print "1. Show the Average Total Cap per Division in the NFL. (User input required)"
	print "2. Show NFL positions average height and weight for positions having an average height > 72 inches"
	print "3. Show the number of players playing certain position in our NFL Player data. (User input required)"
	print "4. Show specified team info. (User input required)"
	print "5. Show list of players based on user input for position. (User input required)"
	print "6. Show the number of players that went to each college"
	print "7. Show all teams in the AFC"
	print "8. Show Super Bowl information for user inputted team. (User input required)"
	print "9. Show number of defensive backs in each division"
	print "10. Show college with most offensive players on user inputted team. (User input required)"
	print ""
	
	print "Queries for our Views"
	
	print "11. Show player info for players on the Indianapolis Colts"
	print "12. Show the average team height,age, and weight for the Indianapolis Colts"
	print "13. Show number of Quarter Backs each college currently has in playing in the league"
	print "14. Show Quarter Backs who played college football in the Big 12"
	print "15. Show the jersey number most worn by current Quarter Backs in the NFL"
	print "16. Show tweets about the Arizona Cardinals, Dallas Cowboys and Indianapolis Colts"
	print "17. Show tweets from teams that have more than one super bowl win"
	print "18. Show tweets from a user inputted division and conference"
	print "19. Display the screen name and the number of tweets associated with that screen name"
	print "20. Show tweets from teams that have a cap space > 10 million"


	
def tweet_team():
	is_success = True
	query = "select team_name,JSON_EXTRACT(tweet_doc, '$.text') from Tweet where team_name in ('Arizona Cardinals','Dallas Cowboys','Indianapolis Colts') order by team_name"
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		
		for row in results:
			print row[0], row[1]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "tweet_team failed: " + e.strerror
	return is_success
	
	
def tweet_superbowl():
	is_success = True
	query = "select tweet.team_name, JSON_EXTRACT(tweet_doc, '$.text'), t.super_bowl_wins from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.super_bowl_wins > 1 order by t.super_bowl_wins desc"
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		
		for row in results:
			print row[0], row[1], row[2]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "tweet_team failed: " + e.strerror
	return is_success

def tweet_cap():
	is_success = True
	query = "select tweet.team_name, t.cap_space, JSON_EXTRACT(tweet_doc, '$.text') as tweets from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.cap_space > 10000000 order by t.cap_space desc"
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		
		for row in results:
			print row[0], row[1], row[2]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "tweet_team failed: " + e.strerror
	return is_success



def tweet_division(d, c):
	is_success = True
	query = "select tweet.team_name, JSON_EXTRACT(tweet_doc, '$.text') from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.division_name = '" + d + "' and t.conference_name = '" + c + "' order by t.team_name"
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		
		for row in results:
			print row[0], row[1]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "tweet_team failed: " + e.strerror
	return is_success	
	
def tweet_screen():
	is_success = True
	query = "select distinct screen_name, count(tweet_doc) as number_of_tweets from Tweet group by screen_name order by number_of_tweets desc "
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		
		for row in results:
			print(format(row[0],'>20s') + format(str(row[1]),'>5s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "tweet_team failed: " + e.strerror
	return is_success	
	
	
	
	

def QB_jersey():
	is_success = True
	query = "select jersey_number, count(player_name) as number_ofQBs from QB where jersey_number != 'NA' group by jersey_number order by count(player_name) desc"
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('Jersey Number' + "   " + 'Number of Players', '>20s'))
		print ""
		for row in results:
			print(format(str(row[0]),'>7s') + " " + format(str(row[1]), '>18s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "QB jersey failed: " + e.strerror
	return is_success



def QB_Big12():
	is_success = True
	query = "select * from QB where college in ('Baylor', 'Texas','Oklahoma','Oklahoma St','Kansas St','Kansas', 'Iowa St','West Virginia','Texas Christian','Texas Tech') order by player_name"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print('Jersey Number' + "       "  + 'Player Name' + "       " + 'Years Played in the NFL' + "        " + "University attended")
		print ""
		for row in results:
			print(format(str(row[0]),'>2s') + " " + format(str(row[1]), '>30s') + " " + format(str(row[2]),'>20s') + " " + format(str(row[3]),">30s"))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "QB Big 12 failed: " + e.strerror
	return is_success


def QB_collegeRep():
	is_success = True
	query = "select college, count(player_name) as num_of_QBs from QB group by college order by num_of_QBs desc"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('University Name','>20s') + "         " + 'Number of QBs')
		print ""
		for row in results:
			print(format(row[0],'>20s') +format(str(row[1]), '>10s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "QB college rep failed: " + e.strerror
	return is_success

def QB():
	is_success = True
	query = "select * from QB"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		for row in results:
			print row[0],row[1],row[2],row[3]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "QB failed: " + e.strerror
	return is_success


def colts_average_stats():

	is_success = True
	query = "select sum(ht)/count(player) as avg_team_height, sum(wt)/count(player) as avg_team_weight, sum(age)/count(player) as avg_team_age from colts_players"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('Team AVG Height','>10s') + format('Team AVG Weight','>20s') + format('Team AVG Age','>18s'))
		print ""
		for row in results:
			print(format(str(row[0]), '>10s') + format(str(row[1]),'>20s') + format(str(row[2]), '>20s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Colts average stats failed: " + e.strerror
	return is_success








def colts_players():

	is_success = True
	query = "select player,position_name,age,college from colts_players order by age desc"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('Player Name','>19s') + format('Position','>15s') + format('AGE','>9s') + format('University Attended','>26s'))
		print ""
		for row in results:
			print(format(str(row[0]),'>19s') + format(str(row[1]),'>12s') + format(str(row[2]),'>12s') + format(str(row[3]),'>26s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Colts Players failed: " + e.strerror
	return is_success




def avg_total_cap(division, conference):

	is_success = True
	query = "select distinct conference_name, division_name, avg(total_cap) as avg_total from Team where division_name = '" + division + "' and conference_name = '" + conference + "' group by division_name, conference_name order by avg_total"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		for row in results:
			print row[0],row[1],row[2]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Avg Total Cap per Division failed: " + e.strerror
	return is_success
	



def count_offense():

	is_success = True
	query = "select p.team_name, count(pp.position_type) from Player as p left outer join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'O' group by p.team_name"

	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		for row in results:
			print row
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Avg Total Cap per Division failed: " + e.strerror
	return is_success
	




def offensive_college(team):

	is_success = True
	query = "select p.team_name, p.college, count(p.college) from Player as p left outer join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'O' and p.team_name = '" +team+ "' group by p.college order by count(p.college) desc"

	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('University Name','>18s') + format('Number of Players','>25s'))
		print ""
		max = 0
		for row in results:
			current = row
			if current[2] < max:
				break
			else:
				print(format(str(current[1]),'>18s') + format(str(current[2]),'>18s'))
			max = current[2]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Offensive College failed: " + e.strerror
	return is_success
	
	



def defensive_back():

	is_success = True
	query = "select distinct t.conference_name, t.division_name, count(p.position_name = 'DB') from Team as t left outer join Player as p on t.team_name = p.team_name group by t.conference_name, t.division_name"

	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		for row in results:
			print(format(str(row[0]),'>3s') + format(str(row[1]),'>6s') +  format(str(row[2]),'>4s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Defensive backs per divison failed: " + e.strerror
	return is_success

	



def superbowl_win(team):

	is_success = True
	query = "select t.team_name, t.super_bowl_wins, (t.super_bowl_wins/d.sb_wins * 100) as percent_of_division_SBs,  (t.super_bowl_wins/50 * 100) as percent_of_league_SBs from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name where t.team_name = '" +team+ "' order by percent_of_league_SBs"

	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		print(format('Team Name','>21s') + format('Super Bowl Wins','>25s') + format('Percentage of Division SB wins','>40s') + format('Percentage of League SB wins','>40s'))
		print ""
		for row in results:
			print(format(str(row[0]),'>21s') + format(str(row[1]),'>18s') + format(str(row[2]),'>36s') + format(str(row[3]),'>40s'))
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "Super Bowl Wins failed: " + e.strerror
	return is_success



	
def show_AFC():
	is_success = True
	query = "select t.team_name, d.conference_name from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name where d.conference_name = 'AFC' order by t.team_name"
	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		
		print ""
		for row in results:
			print row[0]
			
		print""
	except pymysql.Error as e:
		is_success = False
		print "AFC teams failed: " + e.strerror
		
	return is_success
	



def college():

	is_success = True
	query = "select college, count(player_name) as number_of_players from Player group by college order by number_of_players desc"

	
	try:
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor,query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		print(format('University Name','>28s') + format('# Players','>15s'))
		print ""
		i = 0
		for row in results:
			print(format(row[0],'>28s') + format(str(row[1]),'>10s'))
			i+=1
		print""
	except pymysql.Error as e:
		is_success = False
		print "College query failed: " + e.strerror
		
	return is_success	
	


def position_height():

    is_success = True
    query = "select position_name, avg(height) as avg_height, avg(weight) as avg_weight from Player group by position_name having avg_height > '72' order by avg_height"
 
    try: 
        connection = create_connection()
        cursor = connection.cursor()

        query_status = run_stmt(cursor, query)
        if query_status is False:
            is_success = False

        results = cursor.fetchall()
        print ""    
        for row in results:
            print(format(row[0],'>2s')+ "" + format(row[1],'>13.5f') + format(row[2], '>15.5f'))
        print "" 

    except pymysql.Error as e:
        is_success = False
        print "position height failed: " + e.strerror

    return is_success
    
    


def position_query(position):

    is_success = True
    query = "select position_name, count(position_name) from Player where position_name = '" + position + "'"
 
    try: 
        connection = create_connection()
        cursor = connection.cursor()

        query_status = run_stmt(cursor, query)
        if query_status is False:
            is_success = False

        results = cursor.fetchall()
        print ""    
        for row in results:
            print row[0],row[1]
        print "" 

    except pymysql.Error as e:
        is_success = False
        print "position query failed: " + e.strerror

    return is_success
    



def team_info(team):

	is_success = True
	query = "select * from Team where team_name = '" + team +"'"
	
	try: 
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor, query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		print ""   
		i = 0 
		print('Team Name' + '     Division Name' + '     Conference Name' +'     Coach' + '     City' + '     State' +'     Number of Players' +'     Avg Age' +'     Offensive Cap' + '     Defensive Cap' + '     Dead Cap' +'     Total Cap' +'     Cap Space' + '     SB Wins' +'     Conference Titles')
		for row in results:
			print(str(row[0])+ "       " +str(row[1])+ "       " +str(row[2])+ "       " +str(row[3])+ "       " +str(row[4])+ "       " +str(row[5])+ "       " +str(row[6])+ "               " +str(row[7])+ "         " +str(row[8])+ "         " +str(row[9])+ "         " +str(row[10])+ "         " +str(row[11]) + "         " + str(row[12]) + "         " + str(row[13]) + "         " + str(row[14]))
			i+=1
		print "" 
		
	except pymysql.Error as e:
		is_success = False
		print "team query failed: " + e.strerror
		
	return is_success




def position_players(pos):

	is_success = True
	query = "select p.player_name, p.team_name from Player as p inner join Position_played as pp on p.position_name = pp.position_name where pp.position_type = '" + pos + "' order by p.player_name"
	
	try: 
		connection = create_connection()
		cursor = connection.cursor()
		
		query_status = run_stmt(cursor, query)
		if query_status is False:
			is_success = False
			
		results = cursor.fetchall()
		print ""   
		
		
		for row in results:
			print(format(row[0], '>20s') + format(row[1],'>30s'))
			
		print "" 
		
	except pymysql.Error as e:
		is_success = False
		print "team query failed: " + e.strerror
		
	return is_success






    
while True: 

    print_menu()   
    choice = input("Enter your choice [0-20]: ")
     
    if choice==1:
    	division = raw_input("Select the Division from the following list: North, South, East, West: ")
    	conference = raw_input("Select conference from the following list: AFC, NFC: ")
    	conference = str(conference.lower())
    	division = division.lower()
    	while(conference != 'afc' and conference != 'nfc'):
    		conference = raw_input("Incorrect input. Select conference from the following list: AFC, NFC: ")
    		conference = conference.lower()
    	while(division != 'north' and division != 'south' and division != 'east' and division != 'west'):
    		division = raw_input("Incorrect input. Select the Division from the following list: North, South, East, West: ")
    		division = division.lower()
        print "You have chosen to show the Average Total Cap for the " + conference + " " + division + ". Here are the results:"
        avg_total_cap(division, conference)
        
  
  
  
    elif choice==2:
        print "You have chosen to show the average height and weight of NFL positions where average height is greater than 72 inches. Here are the results: "
        position_height()
        
  
  
  
    elif choice==3:
    	position = raw_input('Choose a position from the following choices: QB,RB,WR,TE,OL,K,P,DB,DL,LB,LS: ')
    	while(position not in positions):
    	    position = raw_input('Choose a position from the following choices: QB,RB,WR,TE,OL,K,P,DB,DL,LB,LS: ')
        print "You have chosen to show the number of players who play the " + position + " position in the NFL. Here are the results: "
       	position_query(position)
      
    
    
    
    
    elif choice == 4:
    	for i in range(len(teams)):
    		print(teams[i])
    		
    	team = raw_input('Choose a team from the following: ')
    	while (team not in teams):
    		team = raw_input(' Incorrect input. Choose a team from the following: ')
    	print('You have chosen to show the information for the ' + team + '')
    	team_info(team)   
    	
   
   
   
    elif choice == 5:
    	pos = raw_input('Choose a position type from the following: O,D,ST: ')
    	pos = pos.lower()
    	while(pos != 'o' and pos!= 'd' and pos != 'st'):
    		 pos = raw_input('Incorrect input. Choose a position type from the following: O,D,ST: ')
    		 pos = pos.lower()
    	print('You have chosen to show all players playing a position type ' + pos.upper() + '')
    	position_players(pos)	
    	
   
   
    elif choice == 6:
    	print"You have chosen to see the number of players per college. Here are the results"
    	college()
    	
   
   
    elif choice == 7:
    	print"Show all teams within the AFC"
    	show_AFC()
    	
   
   
    elif choice == 8:
    	for i in range(len(teams)):
    		print(teams[i])
    	team = raw_input('Choose a team from the following: ')
    	while team not in teams:
			team = raw_input(' Incorrect input. Choose a team from the following: ')
    	print('You have chosen to see the Super Bowl information of the ' + team + '. Here are the results')
    	superbowl_win(team) 
    	
   
   
   
    elif choice == 9:
    	print "You have chosen to see the number of defensive backs in each division. Here are the results"
    	defensive_back()
    	
   
   
    elif choice == 10:
    	for i in range(len(teams)):
    		print(teams[i])	
        team = raw_input('Choose a team from the following: ')
        while team not in teams:
			team = raw_input(' Incorrect input. Choose a team from the following: ')
    	print('You have chosen to show the college with the most offensive players playing for the ' + team + '. Here are the results:')
    	offensive_college(team) 
    
   
   
   
    elif choice == 11:
    	print('You have chosen to display player information for the Indianapolis Colts. Here are the results')
    	colts_players() 
    
   
    elif choice == 12:
    	print('You have chosen to display the average team height,weight, and age for the Indianapolis Colts')
    	colts_average_stats()
    	
   
    elif choice == 13:
    	print('You have chosen to display colleges and the number of QBs who currently play in the league. Here are the results')
    	QB_collegeRep()
    	
   
    elif choice == 14:
    	print('You have chosen to display Quarter Backs who played college football in the Big 12. Here are the results')
    	QB_Big12()
   
    elif choice == 15:
    	print('You have chosen to display the jersey numbers and the number of Quarter Backs who wear that number in the NFL. Here are the results')
    	QB_jersey()
    	
    elif choice == 16:
    	print('You have chosen to display the tweets from the Arizona Cardinals, Dallas Cowboys and Indianapolis Colts. Here are the results')
    	tweet_team()
    	
    elif choice == 17:
    	print('You have chosen to display the tweets from Super Bowl winning teams. Here are the results')
    	tweet_superbowl()
    	
    elif choice == 18:
    	division = raw_input("Select the Division from the following list: North, South, East, West: ")
    	conference = raw_input("Select conference from the following list: AFC, NFC: ")
    	conference = str(conference.lower())
    	division = division.lower()
    	while(conference != 'afc' and conference != 'nfc'):
    		conference = raw_input("Incorrect input. Select conference from the following list: AFC, NFC: ")
    		conference = conference.lower()
    	while(division != 'north' and division != 'south' and division != 'east' and division != 'west'):
    		division = raw_input("Incorrect input. Select the Division from the following list: North, South, East, West: ")
    		division = division.lower()
    	print('You have chosen to display the tweets from a ' + conference + ' ' +division+ '. Here are the results: ')
    	tweet_division(division, conference)
    	
    elif choice == 19:
    	print('You have chosen to display the number of tweets posted per screen name. Here are the results')
    	tweet_screen()
    	
    elif choice == 20:
    	print('You have chosen to display the tweets from the teams with cap space greater than 10 million. Here are the results')
    	tweet_cap() 
    	   	
    elif choice==0:
        print "Goodbye!"
        break
    
    else:
        raw_input("Wrong choice! Try again: ")