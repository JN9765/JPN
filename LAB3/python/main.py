import pymysql


from rollback_Player import *
from rollback_Position_played import *
from rollback_Team import *
from rollback_Division import *

from import_division import *
from import_Team import *
from import_Position import *
from import_Player import *
 
print '----------------------------------------------------------'


def main():


	is_success = rollback_Player()

	if is_success is True:
		print "rollback_Player: successful"
	else:
		print "rollback_Player: failed"



	is_success = rollback_Position_played()
	if is_success is True:
		print "rollback_Position_played: successful"
	else:
		print "rollback_Position_played: failed"




	is_success = rollback_Team()
	if is_success is True:
		print "rollback_Team: successful"
	else:
		print "rollback_Team: failed"

	
	is_success = rollback_Division()
	if is_success is True:
		print "rollback_Division: successful"
	else:
		print "rollback_Division: failed"

	
	
	is_success = import_Division()	
	if is_success is True:
		print "import_Division: successful"
	else:
		print "import_Division: failed"

	
	is_success = import_Team()
	if is_success is True:
		print "import_Team: successful"
	else:
		print "import_Team: failed"

	is_success = import_Position_played()
	if is_success is True:
		print "import_Position: successful"
	else:
		print "import_Position: failed"

	
	is_success = import_Player()
	if is_success is True:
		print "import_Player: successful"
	else:
		print "import_Player: failed"
		
	
main()