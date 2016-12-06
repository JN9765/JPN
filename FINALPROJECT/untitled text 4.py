twitter_cursor = tweepy.Cursor(api_inst.search, q=twitter_query, lang="en").items(50)

      for page in twitter_cursor.pages():
        for item in page:
          json_str = json.dumps(item._json)
          print "found a " + team + " tweet"
          insert_stmt = "insert into Tweet(tweet_doc, team_name) values(%s, %s)"
          run_prepared_stmt(db_cursor, insert_stmt, (json_str, team))
          do_commit(conn)
