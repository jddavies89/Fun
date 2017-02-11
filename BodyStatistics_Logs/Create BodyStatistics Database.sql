/* 
Description
	Creates the database for the BodyStatistics program.
	You can edit the tablename to suit you.
.Notes   
	Author: Joe Richards   
	Date:   11/Feb/2017
.LINK  
  	https://github.com/joer89/Fun/BodyStatistics_Logs/

*/

use master
go

/*Drop the database if it exists and has no data.*/
if DB_ID('BodyStatistics') IS NOT NULL drop database BodyStatistics;

/*Create the database*/

create database BodyStatistics on primary
	(name='BodyStatistics',
	filename='C:\BodyStatistics_Logs\BodyStatistics.mdf',
	size=10MB,
	maxsize=Unlimited,
	filegrowth=10%)
log on
	(name='BodyStatistics_logs',
	filename='C:\BodyStatistics_Logs\BodyStatistics.ldf',
	size=3MB,
	maxsize=unlimited,
	filegrowth=10%);
go

/*Create the table */
use BodyStatistics;
go

/*Table name should be your name.*/
create table tblJoeRichards(
	 MyWeight varchar(100),
	 FatPercentage varchar(100),
	 Hight varchar(100),
	 Shoulder varchar(100),	 
	 Chest varchar(100),
	 Arms varchar(100),
	 Waist varchar(100),
	 Upper_leg varchar(100),
	 Lower_Leg varchar(100),
	 Date_Time varchar(100)
)
go

/*

Testing
Insert INTO tblJoeRichards (MyWeight,FatPercentage,Hight,Shoulder,Chest,Arms,Waist,Upper_leg,Lower_Leg,Date_Time) values (170.4,14.4,170.2,85.3,90.2,20,73.2,23,10,210220171235)
Insert INTO tblJoeRichards (MyWeight,FatPercentage,Hight,Shoulder,Chest,Arms,Waist,Upper_leg,Lower_Leg,Date_Time) values (160.4,14.4,150.2,89.3,96.2,23,75.2,230,20,210220171235)
select * from tblJoeRichards

*/
