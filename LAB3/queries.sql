use nfl_players;

select distinct division_name, conference_name, avg(total_cap) as avg_total from Team where division_name = 'West' and conference_name = 'AFC' group by division_name, conference_name order by avg_total;

select * from Player where team_name = 'Arizona Cardinals' order by  position_name;

select position_name, avg(height) as avg_height, avg(weight) as avg_weight from Player group by position_name having avg_height > 72 order by avg_height ;

select position_name, count(position_name) from Player group by position_name;

select college, count(player_name) as number_of_players from Player group by college;


select t.team_name, t.super_bowl_wins, (t.super_bowl_wins/d.sb_wins * 100) as percent_of_division_SBs, (t.super_bowl_wins)/50 as percent_of_league_SBs from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name group by t.team_name order by percent_of_division_SBs desc;

select t.team_name, d.conference_name from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name where d.conference_name = 'AFC';

select distinct t.division_name, t.conference_name, count(p.position_name = 'DB') from Team as t left outer join Player as p on t.team_name = p.team_name group by t.conference_name, t.division_name;

select p.player_name, p.team_name from Player as p inner join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'D' order by p.player_name;


select p. team_name, p.college, count(p.college) from Player as p left outer join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'O' and p.team_name = 'Dallas Cowboys' group by p.college order by count(p.college) desc;





select college, position_name from Player where team_name = 'Dallas Cowboys' order by college;




create view colts_players(
jersey,
player,
position_name,
ht,
wt,
age,
years_played,college)

as 
select jersey_number,
player_name,position_name,height,weight,age,years_played, college from Player where team_name = "Indianapolis Colts";

select player,position_name,age,college from colts_players order by age desc;

select sum(ht)/count(player) as avg_team_height, sum(wt)/count(player) as avg_team_weight, sum(age)/count(player) as avg_team_age from colts_players;


create view QB(
jersey_number,
player_name,
years_played,
college)
as
select jersey_number, player_name, years_played, college from Player where position_name = 'QB';


select * from QB;

select college, count(player_name) as num_of_QBs from QB group by college order by num_of_QBs desc;


select * from QB where college in ('Baylor', 'Texas','Oklahoma','Oklahoma St','Kansas St','Kansas', 'Iowa St','West Virginia','Texas Christian','Texas Tech') order by player_name;


select jersey_number, count(player_name) as number_ofQBs from QB where jersey_number != 'NA' group by jersey_number order by count(player_name) desc;





