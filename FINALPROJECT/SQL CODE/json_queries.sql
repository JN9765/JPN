select team_name,JSON_EXTRACT(tweet_doc, '$.text') from Tweet where team_name in ('Arizona Cardinals','Dallas Cowboys','Indianapolis Colts') order by team_name;

select tweet.team_name, JSON_EXTRACT(tweet_doc, '$.text'), t.super_bowl_wins from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.super_bowl_wins > 1 order by t.super_bowl_wins desc;

select tweet.team_name, JSON_EXTRACT(tweet_doc, '$.text') from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.division_name = 'South' and t.conference_name = 'AFC' order by t.team_name;


select distinct screen_name, count(tweet_doc) as number_of_tweets from Tweet group by screen_name order by number_of_tweets desc ;

select tweet.team_name, t.cap_space, JSON_EXTRACT(tweet_doc, '$.text') as tweets from Tweet as tweet inner join Team as t on tweet.team_name = t.team_name where t.cap_space > 10000000 order by t.cap_space desc;

