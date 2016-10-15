import csv

def test():
		csvfile = open("nfl_players.csv", "rb")
		reader = csv.reader(csvfile)
		
		for i, row in enumerate(reader):
			if i == 0: 
				continue
			
			
			for j, val in enumerate(row):
				
				
				
				if j == 10:
					team_name = (val)
				
			print(team_name)
					



test()