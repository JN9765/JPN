use nfl_players;
drop table if exists Offense;
drop table if exists Player;
create table Player
(
jersey_number integer,
team_name varchar(40) unique,
primary key (jersey_number,team_name),
player_name varchar(40) not null,
height integer not null,
weight integer not null,
age integer not null,
years_playerd integer not null,
college varchar(40) not null
);

desc Player;
show tables;

create table Offense(
offensive_position varchar(2) not null,
jersey_number integer,
team_name varchar(40),
player_name varchar(40), 
primary key(jersey_number,team_name),
foreign key (jersey_number,team_name) references Player(jersey_number,team_name)
);

create table Special_Teams(
special_teams_position varchar(2) not null,
jersey_number integer,
team_name varchar(40),
player_name varchar(40), 
primary key(jersey_number,team_name),
foreign key (jersey_number,team_name) references Player(jersey_number,team_name)
);

create table Defense(
Defensive_position varchar(2) not null,
jersey_number integer,
team_name varchar(40),
player_name varchar(40), 
primary key(jersey_number,team_name),
foreign key (jersey_number,team_name) references Player(jersey_number,team_name)
);


create table Team(
team_name varchar(40),
coach varchar(20),
players_signed integer,
average_age float,
offensive_sal_cap integer,
defensive_sal_cap integer,
dead_cap integer,
total_cap integer,
cap_space integer,
city varchar(40),
state char(2),
primary key (team_name),
foreign key (team_name) references Player(team_name)
);

create table Division(
division_name varchar(15),
team_name varchar(40),
primary key (division_name),
foreign key (team_name) references Player(team_name)
);

create table conference(
division_name varchar(15),
conference_name char(3),
PRIMARY KEY (conference_name,division_name),
foreign key (division_name) references Division(division_name)
);

show tables;
