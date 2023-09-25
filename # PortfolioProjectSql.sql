# PortfolioProjectSql

/* Importing the master sheet using SSIS and creating a new database on SSMS along with a new table */

CREATE TABLE [dbo].[MasterTable](
	[Constituency_Number] [varchar](50) NULL,
	[Constituency_Name] [varchar](50) NULL,
	[Candidate_Name] [varchar](50) NULL,
	[SEX ] [varchar](50) NULL,
	[AGE ] [varchar](50) NULL,
	[CATEGORY ] [varchar](50) NULL,
	[PARTY] [varchar](50) NULL,
	[SYMBOL] [varchar](50) NULL,
	[GENERAL_Votes] [real] NULL,
	[POSTAL_Votes] [real] NULL,
	[TOTAL_Votes] [real] NULL,
	[TOTAL_ELECTORS] [real] NULL
) 
GO


/* Getting the distinct list of ConstituencyName and Constituency_number and saving the result into a new table using ORDER BY and Group BY clause */

select  Constituency_Number, Constituency_Name
INTO Constituency_Deatails
from MasterTable 
GROUP BY Constituency_Number,Constituency_Name
Order by Constituency_Number,Constituency_Name


select *from Constituency_Deatails  -- displays the record of the new table created

--LIST of parties in the election and their symbol
Select *from MasterTable
select DISTINCT Party,SYMBOL
from MasterTable
Where Party<>'IND'  --IND is independant candidates

--List of constituncies and total voters and Saving the query result in a new table Total_Voters
Select *from MasterTable
Select DISTINCT Constituency_Name, TOTAL_ELECTORS
into Total_voters
from MasterTable
select *from Total_voters
--Sum of total_Voters in the State
Select sum(TOTAL_ELECTORS) as Total_Voters_Bihar
from Total_voters
-------Total votes casted
Select Sum(Total_votes) as TotalVotesCasted
from MasterTable  --42142828
-- Sum of total votes gained party wise
Select *from MasterTable
select *from Total_voters
Select  Party,sum(TOTAL_Votes) AS Votes_Gained
fROM MasterTable
Group by Party
Order by Votes_Gained desc


-- Total Voters
select *from Total_voters

Select Sum(Total_electors) AS Total_Electors from Total_voters --73647660



--Party wise Votes % with respect to total votes catsed and Total Number of electors

Select Sum(Total_electors) AS Total_Electors from Total_voters 
Select Sum(Total_votes) as TotalVotesCasted from MasterTable 


Select  Party,sum(TOTAL_Votes) AS Votes_Gained,
(((sum(TOTAL_Votes)/42142828)*100)) AS Percentage_of_Total_Voters ,
((sum(TOTAL_Votes)/73647660)*100) AS Percentage_of_Total_Electors
fROM MasterTable
Group by Party
Order by Votes_Gained desc

--Party wise Votes % with respect to total votes catsed and Total Number of electors returning two places after decimal

Select  Party,sum(TOTAL_Votes) AS Votes_Gained,
LEFT((((sum(TOTAL_Votes)/42142828)*100)) ,5) AS Percentage_of_Total_Voters ,
LEFT((((sum(TOTAL_Votes)/73647660)*100)),5) AS Percentage_of_Total_Electors
fROM MasterTable
Group by Party
Order by Votes_Gained desc
-- List of female candidates and their parties , save result into a new table Female_Candidates

Select Constituency_Name,Candidate_Name,party,Total_Votes
into Female_Candidates    -- result saved in new table Female_Candidates 
from MasterTable
where sex='FEMALE'
order by TOTAL_Votes desc

-- Number of constitunecies in the election
Select COUNT(DISTINCT(Constituency_Name))

from MasterTable

-- 

select *from Female_Candidates
Select *from MasterTable
where Constituency_Name='Baisi'
-- Select Max votes constituency wise and saving the results into Winners table
Select DISTINCT(Constituency_Name),MAX(Total_Votes) AS MaxVote
Into Winners
from MasterTable
Group by Constituency_Name 
order by Constituency_Name

select *from Winners

--Names of winners using inner join (Joining MasterTable and Winners)
Select *from MasterTable
Select *from Winners

Select A.Constituency_Number,A.Constituency_Name,A.Candidate_Name,A.PARTY,TOTAL_Votes

from MasterTable A
Inner join 
Winners B on A.TOTAL_Votes=B.MaxVote

--Names of Female winners using inner join (Joining MasterTable and Winners)
Select A.Constituency_Number,A.Constituency_Name,A.Candidate_Name,A.PARTY,TOTAL_Votes

from MasterTable A
Inner join 
Winners B on A.TOTAL_Votes=B.MaxVote
where sex='Female'

-- Top 3 Candidates in constitunecy (Rank)
Select top 3 
Constituency_Name,Candidate_Name,PARTY,TOTAL_Votes,RANK() OVER (ORDER BY TOTAL_VOTES DESC) AS [RANK]

FROM MasterTable

WHERE Constituency_Number='57'
order by TOTAL_Votes desc

-- Creating a stored prpcedure to get top 3 candidates in any contituencies

ALTER PROCEDURE  spTop3CandidatesbyConstituencyNumber
@ConstituencyNumber int

AS
BEGIN
SELECT top 3
Constituency_Name,Candidate_Name,PARTY,TOTAL_Votes,RANK() OVER (ORDER BY TOTAL_VOTES DESC) AS [RANK]

FROM MasterTable

WHERE Constituency_Number=@ConstituencyNumber


order by TOTAL_Votes desc
END

spTop3CandidatesbyConstituencyNumber 57  -- SP execution 

-- Creating a stored prpcedure to get top 3 candidates in any contituencies by Constituency_Name

CREATE PROCEDURE  spTop3CandidatesbyConstituencyName
@ConstituencyName nvarchar(50)

AS
BEGIN
SELECT top 3
Constituency_Name,Candidate_Name,PARTY,TOTAL_Votes,RANK() OVER (ORDER BY TOTAL_VOTES DESC) AS [RANK]

FROM MasterTable

WHERE Constituency_Name=@ConstituencyName


order by TOTAL_Votes desc
END

spTop3CandidatesbyConstituencyName 'Baisi'  -- SP execution 






