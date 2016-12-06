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
state varchar(11),
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

select * from Team;
select * from Player;
select * from Division;
select * from Position_played;
