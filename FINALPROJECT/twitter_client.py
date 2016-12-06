import json
import time
import tweepy
from db_connect import *

API_KEY = 'x7iuHuz2LiHCzTRrbWdo0rFNM'
API_SECRET ='MdyRD9OwbSYEcDoMlyoudYW97u1uYvuW4E8v3lpCfpQHHJPrFH'
TOKEN_KEY = '342530522-Yc7cpoAmsGidErDhrPWnCBNH3np5m22HRqrhiMej'
TOKEN_SECRET = 'cVNCme8YlWG1VDGwfxyOXh6nVY8lFkmcxM1z7gmzQcpkM'

def get_api_instance():
  auth = tweepy.OAuthHandler(API_KEY, API_SECRET)
  auth.set_access_token(TOKEN_KEY, TOKEN_SECRET)
  api_inst = tweepy.API(auth)
  return api_inst

def do_data_pull(api_inst):

  sql_query = "select team_name from Team order by team_name"

  try: 
    conn = create_connection()
    db_cursor = conn.cursor()
    query_status = run_stmt(db_cursor, sql_query)
    resultset = db_cursor.fetchall()

    for record in resultset:
      team = record[0]
      team_n = team.replace(" ","")
      nfl_query = "(#" + team_n + ")"
      twitter_query = nfl_query + "'"
      print "twitter_query: " + twitter_query
      twitter_cursor = tweepy.Cursor(api_inst.search, q=twitter_query, lang="en").items(5)

      for tweet in twitter_cursor:
		  json_str = json.dumps(tweet._json)
		  print "found a " + team + " tweet"
		  insert_stmt = "insert into Tweet(tweet_doc, team_name) values(%s, %s)"
		  run_prepared_stmt(db_cursor, insert_stmt, (json_str, team))
		  do_commit(conn)

  except pymysql.Error as e:
    print "pymysql error: " + e.strerror
  
  except tweepy.TweepError as twe:
    print "got a TweepError: " + twe.message
    if twe.message.endswith("429"):
      print "got rate limit error, sleeping for 15 minutes"
      time.sleep(60*15)
      print "finished sleeping. re-trying do_data_pull"
      do_data_pull(api_inst)

api_inst = get_api_instance()
do_data_pull(api_inst)