use company;
show tables;
select * from year_wise_goals;
alter table year_wise_goals rename column season to years;
select * from home_club;
select * from away_club;
create view team_goals as select h.club_name,h.home_goals,a.away_goals,(h.home_goals+a.away_goals) as 'total_goals' 
 from home_club h inner join away_club a on h.club_name=a.club_name;
 select * from team_goals;
 drop table stadium_attendance;