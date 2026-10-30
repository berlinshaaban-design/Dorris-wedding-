CREATE TABLE dresses (
DressID     Varchar (50)     not null,
dressName		Varchar (50)		not null,
DressCategory       Varchar (50)	       not null,
Color			Varchar (10)		not null,
Price		       Decimal (10,2)	null,

 
) 


CREATE TABLE Customers (
	Email 		       Varchar (30)		not null,
	Password	      	Varchar (30)	       null,
	CustomerName		Varchar (30)		not null,
	
	Address_Country	Varchar (50)		null,
	Address_City 		Varchar (50)		null,
       [Address_Street]      Varchar (05)		null,
       [Address_Number]      Integer 	null,
       [Address_ZipCode]    varchar (50) 		null,
	[Size_Code] 	varchar (50)          null, 

	
)
--drop table Customers


CREATE TABLE Reviewsnew (
	DressID            Varchar(50)         not null,
	Name	                varchar(50)        not null,
		Rank			Integer		not null,
	Description		Varchar(10)		      not null,

	Email                varchar(30)         not null,
       
	   ) 

	   

	   CREATE TABLE Searches (
	IPAddress 		Varchar (50)		not null,
	DTSearch		               smalldatetime		not null,
	SearchContent	Varchar (50)		not null,
	Email       Varchar (50)		not null, 
	) 
	
	CREATE TABLE Ordersnew1 (
	OrderNumber 		             varchar(50)        	not null,
	OrderDate		                             DateTime		null,
	OrderType		             varchar(100)         null,
	Quantity                          Integer                not null,
	dressid                   varchar(50)         not null,
) 

 
 --drop table Orders

 SELECT 	TOP  3 	DressCategory, 	dresses = count (*) -------
FROM 				dresses
GROUP BY 			DressCategory
ORDER BY			dresses 	DESC-------

select top 3 D.dressname , c.Email   , AVG(r.Rank) as avgraiting
from dresses as  d join reviews as r on d.dressid=r.dressid join CustomersNew as c on r.name=c.Email  
group by  d.dressname , c.Email
order by 1 desc


SELECT top 3 d.*, s.IPAddress as a , s.DTSearch as dt, c.Email
FROM dresses d JOIN searches s ON d.DressID = s.Email JOIN Customers c ON s.Email = c.Email
ORDER BY 2 DESC

---

select  d.dressname , d.dressId, c.email, r.rank 
from dresses as d join Reviews as r on d.DressID=r.DressID join  CustomersNew as c on r.Email=c.Email 
where r.Rank>1
group by d.dressname , d.dressId, c.email ,r.Rank
order by 2  


select *
from Reviews as r 
where r.Rank>4 and DressID>600

select  d.DressID, d.dressname
from dresses as d 
where d.dressname not in ( select distinct d.dressname from dresses as d join orders as o on d.dressid=o.OrderDate
where year(o.OrderDate)=2019)
order by dressname


 SELECT
    D.DressName,
    C.CustomerName ,
    R.Rank
FROM
    Customers AS C
    JOIN Reviewsnew AS R ON C.Email = R.Email
    JOIN DRESSES AS D ON R.DressID = D.DressID
WHERE
    R.Rank > 3
ORDER BY
    R.Rank DESC; 

--------------------------------------------------

SELECT
    C.CustomerName ,
    R.Description,
    S.IPAddress,
    S.DTSearch
FROM
    Customers AS C
    JOIN Reviewsnew AS R ON C.Email = R.Email
    JOIN SEARCHES AS S ON C.Email = S.Email
WHERE
    R.Description =  'very good'
    AND S.DTSearch >= '2021-01-01'
ORDER BY S.DTSearch DESC; 
---------------------------------------------
select *
From dresses as d join Reviewsnew as r on d.DressID= r.DressID join Customers as cu on cu.Email = r.Email
where d.Price>1500 and r.Rank>4

SELECT top 5
    D.DressName,
    C.CustomerName,
    R.Rank
FROM
    CUSTOMERS AS C
    JOIN Reviewsnew AS R ON C.Email = R.Email
    JOIN DRESSES AS D ON R.DressID = D.DressID
WHERE
    R.Rank > 3
ORDER BY
    R.Rank DESC;

select top 10
    C.CustomerName,
    R.Rank,
    S.IPAddress
	
 from CUSTOMERS AS C join Searches as s on s.Email=c.Email
    JOIN Reviewsnew AS R ON C.Email = R.Email
    
WHERE
    R.Rank >= 4 
	order by 3 desc 

	SELECT
  D.DressCategory,
  D.DressName,
  D.Price,
  ROW_NUMBER() OVER (PARTITION BY D.dresscategory ORDER BY D.Price DESC) AS PriceRange,
  NTILE(2) OVER (ORDER BY O.OrderDate) AS Half
FROM
  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
WHERE
  YEAR(O.OrderDate) BETWEEN 2020 AND 2021;

  Select   top 3d.DressID, o.OrderDate, r.rank, d.DressCategory, o.OrderNumber 
from Ordersnew1 as o join dresses as d on d.DressID=o.dressid  join Reviewsnew as r on r.Name=d.DressID
where d.DressCategory = 'evening dresses' and  R.Rank >= 4 and o.OrderNumber > 2
order by d.DressID

SELECT

  D.DressCategory,
  D.DressName,
  D.DressID,
  D.Price,
  COUNT(D.DressID) OVER (PARTITION BY  D.DressID) AS DressesSold,
  MIN(D.Price) OVER (PARTITION BY  D.DressID) AS MinPrice,
  MAX(D.Price) OVER (PARTITION BY  D.DressID) AS MaxPrice
FROM
  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email
WHERE
  D.DressCategory = 'evening dresses'
ORDER BY
  C.CustomerName , D.DressID;


  select c.email , c.CustomerName 
from  ( Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email)
group by c.email,c.CustomerName
having count(o.OrderNumber)>=( select count(OrderNumber)/ count(distinct c.Email) from dresses)
except
select c.email , c.CustomerName 
from   (Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email)
 where DATEDIFF(DAY, O.OrderDate, GETDATE()) >= 2
group by o.OrderNumber, c.email, c.CustomerName

select top 3 d.dressid, d.dressname
from dresses as d
where d.dressname not in ( select distinct d.dressname from dresses as d join Ordersnew1 as o on d.dressid=o.dressid where year(o.OrderDate)=2019)
order by dressname

SELECT 
    C.Email, 
    C.CustomerName, 
    C.Email, 
	d.price,
    SUM(D.Price) AS TotalSpentOnDresses,
    CASE 
        WHEN D.Price > (SELECT AVG(D.Price) FROM DRESSES D WHERE D.DressID = D.DressID)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS PriceComparison
FROM CUSTOMERS as C
JOIN Reviewsnew as R ON C.Email = R.Email
JOIN DRESSES as D ON R.DressID = D.DressID
GROUP BY C.Email, C.CustomerName, C.Email, d.Price
 
 



SELECT d.DressID ,d.Price
FROM Reviewsnew AS r
JOIN dresses AS d ON r.DressID = d.DressID
WHERE r.rank < (SELECT AVG(RANK) FROM Reviewsnew)

update dresses
set price =(price-20)
where dressid in( select d.DressID from Reviewsnew as r JOIN dresses as d on r.DressID= d.DressID where rank < (select AVG(RANK) FROM Reviewsnew)
)

select top 10 d.dressname, d.DressCategory,o.OrderNumber, r.rank
from dresses as d join Ordersnew1 as o on o.dressid=d.DressID join Reviewsnew as r on r.DressID=o.dressid
where r.rank >3 and OrderNumber>5
group by d.dressName, d.DressCategory, o.OrderNumber, r.Rank
ORDER BY 3 desc

SELECT C.email, C.CustomerName
FROM Customers AS C
JOIN Reviewsnew AS R ON C.Email = R.Email
JOIN Ordersnew1 AS O ON R.DressID = O.DressID
JOIN Dresses AS D ON O.DressID = D.DressID
WHERE D.DressCategory = 'wedding'
GROUP BY C.email, C.CustomerName

UNION

SELECT C.email, C.CustomerName
FROM Customers AS C
JOIN Reviewsnew AS R ON C.Email = R.Email
WHERE C.Email NOT IN (
    SELECT C1.Email
    FROM Customers AS C1
    JOIN Reviewsnew AS R1 ON C1.Email = R1.Email
    JOIN Ordersnew1 AS O1 ON R1.DressID = O1.DressID
    JOIN Dresses AS D1 ON O1.DressID = D1.DressID
    WHERE D1.DressCategory = 'evening dresses'
);



SELECT c.email, c.CustomerName 
FROM  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email

WHERE DATEDIFF(DAY, O.OrderDate, GETDATE()) < 2
GROUP BY c.email, c.CustomerName

EXCEPT

SELECT c.email, c.CustomerName 
FROM  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email
GROUP BY o.OrderNumber, c.email, c.CustomerName
HAVING COUNT(o.OrderNumber) < (SELECT COUNT(OrderNumber) / COUNT(DISTINCT c.Email) FROM Dresses);

SELECT c.email, c.CustomerName 
FROM Dresses AS D
JOIN Ordersnew1 AS O ON D.DressID = O.DressID
JOIN Reviewsnew AS R ON R.DressID = O.DressID
JOIN Customers AS C ON R.Email = C.Email
WHERE DATEDIFF(DAY, O.OrderDate, GETDATE()) < 2
GROUP BY c.email, c.CustomerName

EXCEPT

SELECT c.email, c.CustomerName 
FROM Dresses AS D
JOIN Ordersnew1 AS O ON D.DressID = O.DressID
JOIN Reviewsnew AS R ON R.DressID = O.DressID
JOIN Customers AS C ON R.Email = C.Email
WHERE NOT EXISTS (
    SELECT 1
    FROM Dresses AS D2
    JOIN Ordersnew1 AS O2 ON D2.DressID = O2.DressID
    JOIN Reviewsnew AS R2 ON R2.DressID = O2.DressID
    WHERE C.Email = R2.Email
)
GROUP BY c.email, c.CustomerName;


select * 
from dresses 

create table newName2(
DressID      varchar(50)  not null,
DressName	 varchar (50) not null

)

UPDATE Dresses
SET DressName = nc.DressName
FROM Dresses dc
INNER JOIN newName2 nc ON dc.dressID = nc.DressID;

SELECT top 5    D.DressName,  C.CustomerName, R.Rank
FROM
    CUSTOMERS AS C
    JOIN Reviewsnew AS R ON C.Email = R.Email
    JOIN DRESSES AS D ON R.DressID = D.DressID
WHERE R.Rank > 3  
ORDER BY R.Rank DESC ;

SELECT TOP 10 d.dressname, d.DressCategory,o.OrderNumber, r.rank
FROM dresses as d join Ordersnew1 as o on o.dressid=d.DressID join Reviewsnew as r on r.DressID=o.dressid
WHERE r.rank >3 and OrderNumber>5
GROUP BY d.dressName, d.DressCategory, o.OrderNumber, r.Rank
ORDER BY 3 desc;


--SELECT TOP 3 d.dressid, d.dressname
FROM dresses as d
WHERE d.dressname NOT IN 
( SELECT distinct d.dressname FROM dresses as d join Ordersnew1 as o on d.dressid=o.dressid WHERE year(o.OrderDate)=2019)
ORDER BY dressname ;

SELECT  
  D.DressCategory, 
  D.DressName,
  D.Price,
  ROW_NUMBER() OVER( PARTITION BY D.dresscategory ORDER BY D.Price DESC) AS PriceRange,
  NTILE(2) OVER ( ORDER BY O.OrderDate) AS Half
FROM
  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
WHERE
YEAR(O.OrderDate) BETWEEN 2020 AND 2021;

SELECT
  D.DressCategory,
  D.DressName,
  D.Price,
  ROW_NUMBER() OVER (PARTITION BY D.dresscategory ORDER BY D.Price DESC) AS PriceRange,
  NTILE(2) OVER (ORDER BY O.OrderDate) AS Half
FROM
  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
WHERE
  YEAR(O.OrderDate) BETWEEN 2020 AND 2021;


  SELECT D.DressName, D.DressCategory, D.dressID, D.Price,
 COUNT(D.DressID) OVER (PARTITION BY  D.DressID) AS DressesSold,
 MIN(D.Price) OVER (PARTITION BY  D.DressID) AS MinPrice,
 MAX(D.Price) OVER (PARTITION BY  D.DressID) AS MaxPrice
FROM
  Dresses AS D
  JOIN Ordersnew1 AS O ON D.DressID = O.DressID
  join Reviewsnew as r on r.DressID= o.dressid
  JOIN Customers AS C ON r.Email = C.Email
WHERE
  D.DressCategory = 'evening dresses'
ORDER BY
  C.CustomerName , D.DressID


select top 3  d.dressName, d.DressID
from dresses as d
where d.dressname not in ( select distinct d.dressname 
from dresses as d join Ordersnew1 as o on d.dressid=o.dressid 
where year(o.OrderDate)=2019)
order by dressname DESC;


WITH 
Search_classification AS (
    SELECT
        D.DressName AS name,
        'dress' AS type,
        S.IPAddress,
        CASE WHEN O.ordernumber IS NULL THEN 'no' ELSE 'yes' END AS [leads to order],
        D.Price
    FROM DRESSES AS D
    JOIN Reviewsnew AS R ON R.DressID = D.DressID
    JOIN Ordersnew1 AS O ON O.DressID = D.DressID
    JOIN Customers AS C ON C.Email = R.Email
    JOIN SEARCHES AS S ON S.CustomerEmail = C.Email
),
Search_popularity AS (
    SELECT
        DISTINCT SC.name,
        COUNT(*) OVER (PARTITION BY SC.name) AS [numbers of searches],
        ROUND(CAST(COUNT(*) OVER (PARTITION BY SC.name) AS FLOAT) / (SELECT COUNT(*) FROM SEARCHES), 3) AS [percentage of searches from total searches]
    FROM Search_classification AS SC
),
revenue_By_name AS (
    SELECT DISTINCT SC.name, SUM(SC.Price) OVER (PARTITION BY SC.name) AS [revenue]
    FROM Search_classification AS SC
    WHERE SC.[leads to order] = 'yes'
),
Evaluation AS (
    SELECT
        DISTINCT SC.name,
        SC.type,
        SC.Price,
        SP.[numbers of searches],
        SP.[percentage of searches from total searches],
        RBN.[revenue],
        CASE
            WHEN RBN.[revenue] > 1500 THEN 'A'
            WHEN RBN.[revenue] < 1500 AND RBN.[revenue] > 200 THEN 'C'
            ELSE 'B'
        END AS [rank by revenue]
    FROM Search_classification AS SC
    JOIN Search_popularity AS SP ON SC.name = SP.name
    JOIN revenue_By_name AS RBN ON SP.name = RBN.name
)
SELECT *
FROM Evaluation;


SELECT top 5    D.DressName,  C.CustomerName, R.Rank
FROM
    CUSTOMERS AS C
    JOIN Reviewsnew AS R ON C.Email = R.Email
    JOIN DRESSES AS D ON R.DressID = D.DressID
WHERE R.Rank > 3  
ORDER BY R.Rank DESC ;
