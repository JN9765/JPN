drop database if exists nfl_players;
create database nfl_players;
use nfl_players;


create table Division(
conference_name Char(3),
division_name varchar(15),
sb_wins integer,
conference_championships integer,
unique(division_name,conference_name),
primary key (division_name,conference_name)
);

create table Position_played
(
position_name varchar(2),
position_type varchar(2),
unique(position_name),
primary key (position_name)
);


create table Team(
team_name varchar(40),
division_name Varchar(15),
conference_name char(3),
coach varchar(20),
city varchar(40),
state char(2),
players_signed integer,
average_age float,
offensive_sal_cap integer,
defensive_sal_cap integer,
dead_cap integer,
total_cap integer,
cap_space integer,
super_bowl_wins integer,
conference_titles integer,
primary key (team_name),
foreign key (division_name,conference_name) references Division(division_name,conference_name)
);


create table Player(
player_id integer auto_increment,
jersey_number varchar(3),
player_name varchar(80),
position_name Varchar(2),
height integer,
weight integer,
age integer,
years_played integer,	
college varchar(40),
team_name varchar(40),
primary key (player_id),
foreign key (position_name) references Position_played(position_name),
foreign key (team_name) references Team(team_name)

);
select * from Player;
select * from Position_played;
select * from Division;
select * from Team;

#Queries for python
select distinct division_name, conference_name, avg(total_cap) as avg_total from Team where division_name = 'West' and conference_name = 'AFC' group by division_name, conference_name order by avg_total;

select * from Player where team_name = 'Arizona Cardinals' order by  position_name;

select position_name, avg(height) as avg_height, avg(weight) as avg_weight from Player group by position_name having avg_height > 72 order by avg_height ;

select position_name, count(position_name) from Player group by position_name;

select college, count(player_name) as number_of_players from Player group by college;


select t.team_name, t.super_bowl_wins, (t.super_bowl_wins/d.sb_wins * 100) as super_bowl_percent from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name order by super_bowl_percent;

select t.team_name, d.conference_name from Team as t inner join Division as d on t.division_name = d.division_name and t.conference_name = d.conference_name where d.conference_name = 'AFC';

select distinct t.division_name, t.conference_name, count(p.position_name = 'DB') from Team as t left outer join Player as p on t.team_name = p.team_name group by t.conference_name, t.division_name;

select p.player_name, p.team_name from Player as p inner join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'D' order by p.player_name;


select p. team_name, p.college, count(p.college) from Player as p left outer join Position_played as pp on p.position_name = pp.position_name where pp.position_type = 'O' and p.team_name = 'Dallas Cowboys' group by p.college order by count(p.college) desc limit 1;





select college, position_name from Player where team_name = 'Arizona Cardinals' order by college, position_name;



use nfl_players;

create view colts_players(
jersey,
player,
position_name,
ht,
wt,
age,
years_played)

as 
select jersey_number,
player_name,position_name,height,weight,age,years_played from Player where team_name = "Indianapolis Colts";

select player,position_name from colts_players;

select sum(ht)/count(player) from colts_players;


create view QB(
jersey_number,
player_name,
years_played,
college)
as
select jersey_number, player_name, years_played, college from Player where position_name = 'QB';


select * from QB;

select college, count(player_name) from QB group by college;

select avg(years_played) from QB;



select jersey_number, count(player_name) from QB group by jersey_number order by count(player_name) desc limit 1;





