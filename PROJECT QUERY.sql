
CREATE DATABASE JaPaulOilCompany
GO
USE JaPaulOilCompany
GO


 

-- Rules for Database

CREATE RULE PhoneNumber 
as @PhoneNumber LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'

sp_bindrule 'PhoneNumber', 'HumanResources.EmployeeContact.NextOfKinPhoneNumber'
sp_bindrule 'PhoneNumber', 'HumanResources.EmployeeContactAddress.PhoneNumber1'
sp_bindrule 'PhoneNumber','ClientManagement.ClientInfo.PhoneNumber1'
sp_bindrule 'PhoneNumber', 'VendorManagement.VendorContactDetails.PhoneNumber1'

CREATE RULE EmailAddress
as @EmailAddress LIKE '%__@__%.COM'

sp_bindrule 'EmailAddress', 'HumanResources.EmployeeContactAddress.EmailAddress' 
sp_bindrule 'EmailAddress', 'ClientManagement.ClientInfo.EmailAddress'
sp_bindrule 'EmailAddress', 'VendorManagement.VendorContactDetails.EmailAddress'


--Equipment Availabilty Procedure

CREATE PROC prcEquipmentAvailable @EquipmentId int
AS
BEGIN
		Print 'Availability Status'
		select InventoryNo, EquipmentId, [Status]
		FROM CompanyOperations.Inventory
		WHERE EquipmentId = @EquipmentId

END


--Acquisition Invoice Status Procedure

CREATE PROC prcAcquisitionInvoiceStatus @InvoiceNo int
AS
BEGIN	
		IF EXISTS (SELECT InvoiceNo from Accounting.AcquisitionInvoice where InvoiceNo = @InvoiceNo)
			BEGIN
			Print 'Invoice Status'
			SELECT InvoiceNo, TransactionId, InvoiceStatus
			FROM Accounting.AcquisitionInvoice
			WHERE InvoiceNo = @InvoiceNo
			END
		ELSE 
			PRINT 'NO RECORD FOUND'
END


--Service Invoice Status Procedure

CREATE PROC prcServiceInvoiceStatus @InvoiceNo int
AS
BEGIN	
		IF EXISTS (SELECT InvoiceNo from Accounting.ServiceInvoice where InvoiceNo = @InvoiceNo)
			BEGIN
			Print 'Invoice Status'
			SELECT InvoiceNo, TransactionId, InvoiceStatus
			FROM Accounting.AcquisitionInvoice
			WHERE InvoiceNo = @InvoiceNo
			END
		ELSE 
			PRINT 'NO RECORD FOUND'
END

-- View for full Employee Info

CREATE VIEW vEmployeeDetails
AS
select e.EmployeeId, ec.FirstName, ec.MiddleName, ec.LastName, e.Gender, e.JobTitle, e.ManagerId, e.MaritalStatus
FROM HumanResources.Employee e INNER JOIN HumanResources.EmployeeContact ec 
ON e.EmployeeId = ec.EmployeeId


-- Database Creation

CREATE SCHEMA HumanResources
CREATE TABLE HumanResources.Employee
select * from HumanResources.Employee
(
		EmployeeId int identity(1,1) NOT NULL CONSTRAINT pkEmployeeID PRIMARY KEY,
		ManagerId int NULL CONSTRAINT fkManagerId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		DateOfBirth date NOT NULL,
		Gender char(1) NOT NULL CONSTRAINT chkGender CHECK(Gender IN ('M','F')), 
		MaritalStatus char(1) NOT NULL CONSTRAINT chkMaritalStatus CHECK(MaritalStatus IN ('M', 'S')),
		DateOfEmployement date NOT NULL,
		StateOfOrigin varchar(10) NOT NULL,
		JobTitle varchar(25) NOT NULL
)

		Insert INTO HumanResources.Employee Values (NULL, '08/12/1973', 'M', 'M', '03/01/2000', 'Rivers', 'Chief Exec. Officer')
		Insert INTO HumanResources.Employee Values (1, '08/01/1975', 'M', 'M', '03/01/2000', 'Rivers', 'Board Member')
		Insert INTO HumanResources.Employee Values (1, '04/23/1983', 'M', 'M', '03/01/2000', 'Amambra', 'Board Member')
		Insert INTO HumanResources.Employee Values (1, '09/06/1978', 'F', 'M', '03/01/2000', 'Rivers', 'Board Member')
		Insert INTO HumanResources.Employee Values (1, '10/20/1981', 'M', 'M', '03/01/2015', 'Awka Ibom', 'Board Member')
		Insert INTO HumanResources.Employee Values (1, '06/01/1988', 'F', 'M', '03/01/2015', 'Bayelsa', 'Board Member')
		Insert INTO HumanResources.Employee Values (1, '04/04/1983', 'M', 'M', '03/01/2000', 'Rivers', 'Chief Oper. Officer')
		Insert INTO HumanResources.Employee Values (1, '05/20/1982', 'M', 'M', '03/01/2010', 'Rivers', 'Managing Director')
		Insert INTO HumanResources.Employee Values (1, '11/20/1984', 'F', 'M', '03/01/2010', 'Rivers', 'Managing Director')
		Insert INTO HumanResources.Employee Values (1, '10/23/1980', 'M', 'M', '03/01/2010', 'Rivers', 'Managing Director')
		Insert INTO HumanResources.Employee Values (1, '11/20/1984', 'M', 'M', '05/01/2012', 'Anambra', 'Exploration Head')
		Insert INTO HumanResources.Employee Values (1, '09/03/1982', 'M', 'S', '05/01/2012', 'Abia', 'Marketing Head')
		Insert INTO HumanResources.Employee Values (1, '10/02/1984', 'M', 'S', '05/01/2012', 'Rivers', 'Admin. Head')
		Insert INTO HumanResources.Employee Values (1, '10/02/1984', 'M', 'S', '05/01/2012', 'Rivers', 'Procurement Head')
		Insert INTO HumanResources.Employee Values (11, '08/20/1980', 'M', 'M', '05/01/2011', 'Awka Ibom', 'Geological Manager')
		Insert INTO HumanResources.Employee Values (11, '08/20/1980', 'M', 'S', '05/01/2011', 'Rivers', 'Geology Scientist')
		Insert INTO HumanResources.Employee Values (11, '02/11/1985', 'F', 'S', '05/01/2011', 'Bayelsa', 'Geology Scientist')
		Insert INTO HumanResources.Employee Values (11, '02/05/1978', 'M', 'M', '05/01/2011', 'Enugu', 'Geology Scientist')
		Insert INTO HumanResources.Employee Values (11, '02/24/1986', 'F', 'M', '05/01/2011', 'Awka Ibom', 'Lands Manager')
		Insert INTO HumanResources.Employee Values (11, '08/20/1980', 'M', 'M', '05/01/2013', 'Rivers', 'Lands Employee')
		Insert INTO HumanResources.Employee Values (11, '08/20/1986', 'M', 'S', '03/08/2012', 'Bayelsa', 'Lands Employee')
		Insert INTO HumanResources.Employee Values (11, '08/20/1980', 'M', 'M', '05/01/2013', 'Anambra', 'Lands Employee')
		Insert INTO HumanResources.Employee Values (12, '08/20/1980', 'M', 'M', '02/12/2012', 'Rivers', 'Marketing Strategist')
		Insert INTO HumanResources.Employee Values (12, '07/21/1985', 'F', 'S', '02/12/2012', 'Rivers', 'Marketing Strategist')
		Insert INTO HumanResources.Employee Values (12, '05/03/1980', 'M', 'M', '02/12/2014', 'Rivers', 'Marketing Strategist')
		Insert INTO HumanResources.Employee Values (13, '10/12/1980', 'M', 'M', '03/01/2010', 'Rivers', 'HR Personnel')
		Insert INTO HumanResources.Employee Values (13, '11/13/1984', 'M', 'M', '05/01/2012', 'Anambra', 'HR Personnel')
		Insert INTO HumanResources.Employee Values (13, '04/04/1982', 'M', 'S', '05/01/2012', 'Abia', 'HR Personnel')
		Insert INTO HumanResources.Employee Values (13, '11/02/1984', 'M', 'S', '05/01/2012', 'Rivers', 'HR Personnel')
		Insert INTO HumanResources.Employee Values (13, '08/23/1983', 'M', 'M', '05/01/2011', 'Awka Ibom', 'Accounts Manager')
		Insert INTO HumanResources.Employee Values (13, '05/21/1985', 'M', 'S', '05/01/2011', 'Rivers', 'Accounts Manager')
		Insert INTO HumanResources.Employee Values (13, '02/11/1987', 'F', 'S', '05/01/2011', 'Bayelsa', 'Accounts Manager')
		Insert INTO HumanResources.Employee Values (13, '03/09/1978', 'M', 'M', '05/01/2011', 'Enugu', 'Accounts Manager')
		Insert INTO HumanResources.Employee Values (13, '02/23/1983', 'F', 'M', '05/01/2011', 'Awka Ibom', 'Finance Manager')
		Insert INTO HumanResources.Employee Values (13, '04/21/1985', 'M', 'M', '05/01/2013', 'Rivers', 'Finance Employee')
		Insert INTO HumanResources.Employee Values (13, '03/12/1986', 'M', 'S', '03/08/2012', 'Bayelsa', 'Finance Employee')
		Insert INTO HumanResources.Employee Values (13, '10/12/1980', 'M', 'M', '05/01/2013', 'Anambra', 'Finance Employee')
		Insert INTO HumanResources.Employee Values (13, '12/02/1982', 'M', 'M', '02/12/2012', 'Rivers', 'PR Manager')
		Insert INTO HumanResources.Employee Values (13, '06/25/1985', 'F', 'S', '02/12/2012', 'Rivers', 'PR Employee')
		Insert INTO HumanResources.Employee Values (13, '04/21/1980', 'M', 'M', '02/12/2014', 'Rivers', 'PR Employee')
		Insert INTO HumanResources.Employee Values (14, '03/12/1982', 'M', 'M', '05/01/2011', 'Awka Ibom', 'Procurement Manager')
		Insert INTO HumanResources.Employee Values (14, '02/11/1986', 'M', 'S', '05/01/2011', 'Rivers', 'Procurement Emp')
		Insert INTO HumanResources.Employee Values (14, '01/17/1987', 'F', 'S', '05/01/2011', 'Bayelsa', 'Procurement Emp')
		Insert INTO HumanResources.Employee Values (14, '01/05/1979', 'M', 'M', '05/01/2011', 'Enugu', 'Procurement Emp')

		
CREATE TABLE HumanResources.EmployeeContact 
(
		EmployeeContactId int identity(1,1) NOT NULL CONSTRAINT pkEmployeeContactID PRIMARY KEY,
		EmployeeId int NOT NULL CONSTRAINT fkEmployeeId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		Title varchar(4) NOT NULL CONSTRAINT chkTitle CHECK(Title in ('Mr','Mrs','Miss')),
		FirstName varchar(20) NOT NULL,
		MiddleName varchar(20) SPARSE NULL,
		LastName varchar(20) NOT NULL,
		NextOfKinFirstName varchar(20) NOT NULL,
		NextOfKinLastName varchar(20) NOT NULL,
		NextOfKinPhoneNumber char(11) NOT NULL,
		NextOfKinRelationship varchar(10) NOT NULL
)

		Insert INTO HumanResources.EmployeeContact Values (1, 'Mr', 'Kelvin', 'Nyesom', 'Wike', 'Sandra', 'Nwike', '07059769876', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (2, 'Mr', 'Adams', 'Ebele', 'Jonathan', 'Peace', 'Jonathan', '07096754322', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (3, 'Mr', 'John', 'Price', 'Omelu', 'Amanda', 'Omelu', '07087654321', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (4, 'Mrs', 'Joyce', 'Agatha', 'Okoli', 'Chike', 'Okoli', '07065678764', 'Husband')
		Insert INTO HumanResources.EmployeeContact Values (5, 'Mr', 'Ladi', 'Bright', 'Chike', 'Damilola', 'Chike', '07034567392', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (6, 'Mrs', 'Chinyere', 'Alice', 'Okonji', 'Charles', 'Okonji', '07043357853', 'Husband')
		Insert INTO HumanResources.EmployeeContact Values (7, 'Mr', 'Jones', 'Ben', 'Okoro', 'Jill', 'Okoro', '0804837453', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (8, 'Mr', 'Febe', 'Johnson', 'Adams', 'Denice', 'Adams', '07012345678', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (9, 'Mrs', 'Jill', 'Antonia', 'Okenna', 'Harry', 'Okenna', '0806554321', 'Husband')
		Insert INTO HumanResources.EmployeeContact Values (10, 'Mr', 'Akachi', 'Bosowe', 'Alaja', 'Chinyere', 'Alaja', '08077635321', 'Mother')
		Insert INTO HumanResources.EmployeeContact Values (11, 'Mr', 'Joseph', 'Domonic', 'Lanre', 'Abiba', 'Lanre', '09074453452', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (12, 'Mr', 'Lozo', 'Juan', 'Ball', 'Amara', 'Ball', '08077452532', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (13, 'Mr', 'Kawhi', 'Justin', 'Leonard', 'Bob', 'Leonard', '07091154506', 'Cousin')
		Insert INTO HumanResources.EmployeeContact Values (14, 'Mr', 'Kyle', 'Richard', 'Lowry', 'Angel', 'Lowry', '08071154532', 'Cousin')
		Insert INTO HumanResources.EmployeeContact Values (15, 'Mr', 'Adadewa', 'Locous', 'Risha', 'Jenny', 'Risha', '09086754433', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (16, 'Mr', 'Paul', 'Richard', 'George', 'Ashley', 'George', '08071150082', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (17, 'Mrs', 'Alisse', 'Doris', 'Ikenwa', 'Chike', 'Ikenwa', '07062238764', 'Brother')
		Insert INTO HumanResources.EmployeeContact Values (18, 'Mr', 'Aubrey', 'Drake', 'Graham', 'Meghan', 'Graham', '09087654435', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (19, 'Mrs', 'Chikere', 'Lisa', 'Okike', 'Ike', 'Okike', '07065679944', 'Brother')
		Insert INTO HumanResources.EmployeeContact Values (20, 'Mr', 'Ladi', 'Bright', 'Chike', 'Damilola', 'Chike', '07034567392', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (21, 'Mr', 'Russel', 'Brown', 'Westbrook', 'Rachel', 'Westbrook', '08071221532', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (22, 'Mr', 'Yomi', 'Bill', 'Meee', 'Adewa', 'Meee', '09087764432', 'Mother')
		Insert INTO HumanResources.EmployeeContact Values (23, 'Mr', 'James', 'Okwi', 'Onyechi', 'Ifunanya', 'Onyechi', '09087765543', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (24, 'Mrs', 'Antoinette', 'Nissi', 'Garson', 'Charles', 'Garson', '08165678764', 'Brother')
		Insert INTO HumanResources.EmployeeContact Values (25, 'Mr', 'Femi', 'Xavier', 'Anozie', 'Edward', 'Anozie', '08076654532', 'Brother')
		Insert INTO HumanResources.EmployeeContact Values (26, 'Mr', 'Chukumaobi', 'Kalu', 'Onuoha', 'Chineze', 'Onuoha', '09077654334', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (27, 'Mr', 'Kene', 'Moses', 'Okoli', 'Afoma', 'Okoli', '07054876654', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (28, 'Mr', 'James', 'Ade', 'Harden', 'Khloe', 'Harden', '07101154532', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (29, 'Mr', 'Idowu', 'Ibrahim', 'Lori', 'Alewera', 'Lori', '08071154775', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (30, 'Mr', 'Nnnana', 'Benjamin', 'Enyi', 'Nazee', 'Enyi', '07097765432', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (31, 'Mr', 'Chika', 'Jordie', 'Uba', 'Alex', 'Uba', '08171154223', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (32, 'Mrs', 'Jessie', 'Ada', 'Okoro', 'Chineye', 'Okoro', '07065678764', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (33, 'Mr', 'Ben', 'Okafor', 'Iloabachie', 'Obi', 'Iloabachie', '07088543556', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (34, 'Mrs', 'Jade', 'Angie', 'Okolie', 'Sammy', 'Okolie', '07064478764', 'Husband')
		Insert INTO HumanResources.EmployeeContact Values (35, 'Mr', 'David', 'Geoffery', 'Beckham', 'Victoria', 'Beckham', '08067785432', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (36, 'Mr', 'Chimezie', 'Justin', 'Nwagbo', 'Amara', 'Nwagbo', '08071154532', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (37, 'Mr', 'Micheal', 'Stephen', 'Jordan', 'Anita', 'Jordan', '07057764563', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (38, 'Mr', 'Kevin', 'Joseph', 'Durant', 'Keisha', 'Durant', '00897765432', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (39, 'Mrs', 'Alex', 'Ada', 'Kachi', 'Leslie', 'Kachi', '07065699364', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (40, 'Mr', 'Stephen', 'Francis', 'Curry', 'Aesha', 'Curry', '07097756432', 'Wife')
		Insert INTO HumanResources.EmployeeContact Values (41, 'Mr', 'Draymond', 'Jordan', 'Green', 'Samantha', 'Green', '08054435673', 'Mother')
		Insert INTO HumanResources.EmployeeContact Values (42, 'Mr', 'Diogo', 'Xavi', 'Dalot', 'Edward', 'Dalot', '08078154539', 'Brother')
		Insert INTO HumanResources.EmployeeContact Values (43, 'Mrs', 'Amy', 'Bisola', 'Alaye', 'Jamie', 'Alaye', '09165678799', 'Sister')
		Insert INTO HumanResources.EmployeeContact Values (44, 'Mr', 'Sean', 'Bright', 'Carter', 'Beyonce', 'Carter', '07054435674', 'Wife')


CREATE TABLE HumanResources.EmployeeContactAddress

(
		EmployeeContactAddressId int identity(1,1) CONSTRAINT pkEmployeeContactAddressId PRIMARY KEY NOT NULL,
		EmployeeId int NOT NULL CONSTRAINT fkEmployeeContactAddressId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		StreetLine1 varchar(20) NOT NULL,
		StreetLine2 varchar(20) NULL,
		City char(3) NOT NULL,
		PhoneNumber1 char(11) NOT NULL,
		PhoneNumber2 varchar(11) NULL,
		EmailAddress varchar(40) NOT NULL
)
		Insert INTO HumanResources.EmployeeContactAddress Values (1, '3 Will Street', 'N/A' , 'PHC', '07099345432', 'N/A', 'KWike1@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (2, '3 Talee Close', 'N/A' , 'PHC', '08077665432', 'N/A', 'AJonathan2@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (3, '3 Nkpogu Road', 'N/A' , 'PHC', '07022745432', 'N/A', 'JOmelu3@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (4, '3 Elekahia Street', 'N/A' , 'PHC', '08193452331', 'N/A', 'JOkoli4@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (5, '333 Amadi Close', 'Old GRA' , 'PHC', '07099345432', 'N/A', 'KWike@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (6, '12 Ama Street', 'Abuloma' , 'PHC', '07099342112', 'N/A', 'KWike@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (7, '45 Emelu Close', 'Ada-George' , 'PHC', '07085563459', '09099876547', 'KWike@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (8, '3 Alagoa Estate', 'Trans-Amadi' , 'PHC', '07099340987', 'N/A', 'KWike@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (9, '22 Wiells Street', 'N/A' , 'PHC', '07090635322', 'N/A', 'KWike@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (10, '22 Kaduna Street', 'D/Line' , 'PHC', '07090745322', 'N/A', 'AAlaja10@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (11, '22 Amaechi Close', 'GRA' , 'PHC', '07090634322', '09077665432', 'JLanre11@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (12, '22 Nwosu Close', 'Rumuomasi' , 'PHC',  '07090635000', '09011165432', 'LBall12@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (13, '12 Amaechi Close', 'GRA' , 'PHC', '07090635432', '08107665432', 'KLeonard13@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (14, '2 Whees Street', 'GRA' , 'PHC', '08120635422', '09177665498', 'KLowry14@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (15, '1 Williams Str', 'GRA' , 'PHC',  '07090635431', 'N/A', 'ARisha15@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (16, '22 Axe Drive', 'Rmuola' , 'PHC', '07010635430', 'N/A', 'PGeorge15@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (17, '26 Adams Road', 'GRA' , 'PHC', '07100635432', '07177665432', 'AIkenwa16@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (18, '12 Alissa Close', 'D/Line' , 'PHC', '07087735432', 'N/A', 'AGraham17@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (19, '3 Allen Drive', 'Woji' , 'PHC', '07055635437', 'N/A', 'COkike19@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (20, '67 Allen Drive', 'Woji' , 'PHC', '07015654322', 'N/A', 'LChike20@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (21, '12 Alagoa Estate', 'Trans-Amadi' , 'PHC', '07193409888', 'N/A', 'RWestbrook21@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (22, '39 Allen Drive', 'Woji' , 'PHC', '07054535437', 'N/A', 'YMeee22@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (23, '3 Axe Drive', 'Rumola' , 'PHC', '07055635432', 'N/A', 'JOnyechi23@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (24, '3 Emelu Close', 'Ada-George' , 'PHC', '07085563459', '09011276547', 'AGarson24@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (25, '57 Talee Close', 'N/A' , 'PHC', '08013465432', 'N/A', 'FAnozie25@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (26, '3 Amadi Close', 'Old GRA' , 'PHC', '08077665432', 'N/A', 'COnuoha26@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (27, '31 Legion Close', 'N/A' , 'PHC', '08055565432', 'N/A', 'KOkoli27@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (28, '3 Aiza Road', 'Mile 3' , 'PHC', '08101065432', 'N/A', 'JHarden28@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (29, '3 Liver Close', 'N/A' , 'PHC', '07107665437', 'N/A', 'ILori29@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (30, '3 Toki Close', 'Olu Obassanjo' , 'PHC', '08077000032', 'N/A', 'NEnyi30@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (31, '43 Emelu Close', 'Ada-George' , 'PHC', '07011563119', '09011277747', 'CUba31@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (32, '4 Fortnite Close', 'N/A' , 'PHC', '07017563452', '08131276543', 'JChineye32@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (33, '3 Toime Close', 'Olu Obassanjo' , 'PHC', '08077001132', 'N/A', 'BIloabachie33@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (34, '5 Aba Road', 'N/A' , 'PHC', '08077000001', 'N/A', 'JOkolie34@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (35, '3 Sinme Drive', 'Olu Obassanjo' , 'PHC', '08057000031', 'N/A', 'DBeckham35@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (36, '19 Tily Close', 'N/A' , 'PHC', '08077000053', 'N/A', 'CNwagbo36@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (37, '9 Drizzy Close', 'Cocaine Village' , 'PHC', '07086543322', 'N/A', 'MJordan37@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (38, '3 Lindley House', 'Rupoku' , 'PHC', '08167754239', 'N/A', 'KDurant38@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (39, '7 Chafford Close', 'GRA' , 'PHC',  '08087340032', 'N/A', 'AKachi39@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (40, '5 Bridge Way', 'Ogbibo' , 'PHC', '08077876564', 'N/A', 'SCurry40@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (41, '14 Miles Close', 'Olu Obassanjo' , 'PHC', '08234400032', 'N/A', 'DGreen41@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (42, '67 Bide Close', 'Ikoku' , 'PHC', '08073290032', 'N/A', 'DDalot42@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (43, '31 Toki Close', 'Olu Obassanjo' , 'PHC', '08077000099', 'N/A', 'AAlaye43@japaul.com')
		Insert INTO HumanResources.EmployeeContactAddress Values (44, '76 Miles Close', 'Olu Obassanjo' , 'PHC', '07124000032', 'N/A', 'SCarter44@japaul.com')

		
CREATE TABLE HumanResources.EmployeeBankDetails
 
(
		EmployeeBankDetails int identity(1000,1) CONSTRAINT pkEmployeeBankDetails PRIMARY KEY NOT NULL,
		EmployeeId int NOT NULL CONSTRAINT fkEmployeeBankDetailsId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeiD) ON DELETE NO ACTION ON UPDATE NO ACTION,
		BankId int NOT NULL CONSTRAINT fkBankId FOREIGN KEY REFERENCES Accounting.Bank(BankId) ON DELETE CASCADE ON UPDATE CASCADE,
		AccountNumber varchar(10) NOT NULL CONSTRAINT chkAccountNumber CHECK(AccountNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		AccountType char(7) NOT NULL CONSTRAINT chkAccountType CHECK(AccountType IN ('Current','Savings')),
		ModifiedDate datetime NOT NULL
)

		Insert INTO HumanResources.EmployeeBankDetails values (1, 2, '0987654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (2, 5, '1087654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (3, 6, '1085954861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (4, 5, '1085980861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (5, 2, '1234567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (6, 14, '2134567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (7, 8, '1456789239', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (8, 9, '8769540321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (9, 1, '0987654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (10, 9, '1087654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (11, 18, '1085954861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (12, 13, '1085980861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (13, 1, '1234567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (14, 19, '2134567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (15, 7, '1456789239', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (16, 10, '8769540321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (17, 8, '1097654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (18, 15, '1086754321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (19, 6, '0185954861', 'Savings', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (20, 9, '1085999861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (21, 2, '1234777890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (22, 13, '2134177891', 'Savings', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (23, 8, '1456654939', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (24, 3, '9989540321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (25, 1, '0988854387', 'Savings', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (26, 7, '1984654321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (27, 18, '1081529861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (28, 15, '1077980861', 'Savings', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (29, 7, '4572567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (30, 11, '2130007890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (31, 3, '1456788139', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (32, 2, '0876959991', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (33, 9, '0923354321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (34, 5, '1073491321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (35, 6, '1085959961', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (36, 5, '1925980861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (37, 8, '0987667890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (38, 14, '1114567890', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (39, 8, '9321789239', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (40, 9, '8769533321', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (41, 1, '1187654111', 'Savings', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (42, 1, '1087654991', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (43, 18, '1087754861', 'Current', getdate())
		Insert INTO HumanResources.EmployeeBankDetails values (44, 13, '0000044447', 'Savings', getdate())

CREATE TABLE HumanResources.Department
(
		DepartmentId int identity(1,1) CONSTRAINT pkDepartmentId PRIMARY KEY NOT NULL,
		DepartmentName varchar(25) NOT NULL,
		ModifiedDate datetime NOT NULL
)

		Insert INTO HumanResources.Department values ('Exploration', getdate())
		Insert INTO HumanResources.Department values ('Marketing', getdate())
		Insert INTO HumanResources.Department values ('Administrative', getdate())
		Insert INTO HumanResources.Department values ('Procurement', getdate())

CREATE TABLE HumanResources.EmployeeDepartment

(
		Id int identity(1,1) CONSTRAINT pkEmployeeDepartment PRIMARY KEY NOT NULL,
		EmployeeId int CONSTRAINT fkEmployeeDepartmentEmployeeId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		DepartmentId int CONSTRAINT fkEmployeeDepartmentDeptId FOREIGN KEY REFERENCES HumanResources.Department(DepartmentId) ON DELETE NO ACTION ON UPDATE NO ACTION, 
		ModifiedDate date

)

		Insert INTO HumanResources.EmployeeDepartment Values (11, 1 , getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (12, 2 ,  getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (13, 3 , getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (14, 4 , getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (15, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (16, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (17, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (18, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (19, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (20, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (21, 1, GETDATE())
		Insert INTO HumanResources.EmployeeDepartment Values (22, 1, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (23, 2, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (24, 2, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (25, 2, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (26, 3 , getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (27, 3 ,  getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (28, 3 , getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (29, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (30, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (31, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (32, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (33, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (34, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (35, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (36, 3, GETDATE())
		Insert INTO HumanResources.EmployeeDepartment Values (37, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (38, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (39, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (40, 3, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (41, 4, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (42, 4, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (43, 4, getdate())
		Insert INTO HumanResources.EmployeeDepartment Values (44, 4, getdate())



CREATE SCHEMA ClientManagement

--ClientId Trigger

Create TRIGGER alphanumericColumn
	ON  ClientManagement.ClientDirectory
	AFTER  INSERT
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;


		UPDATE a
		SET    ClientId = 'CLIENT' + LEFT('-' + CAST(inserted.DirectoryNo AS VARCHAR(10)), 10)
		FROM   ClientManagement.ClientDirectory a
		   INNER JOIN inserted
			 ON a.DirectoryNo = inserted.DirectoryNo

END

CREATE TABLE ClientManagement.ClientDirectory


(
		DirectoryNo int identity(1,1) NOT NULL,
		ClientId varchar(10) NOT NULL CONSTRAINT pkClientDirectoryId PRIMARY KEY,
		ClientName varchar(20) NOT NULL,
		ModifiedDate date NOT NULL
)

		Insert INTO ClientManagement.ClientDirectory values (' ', 'CATEC Nig Ltd', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Cregital', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Red Ground Africa', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'AfroSeas Nig Ltd', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'New Grounds Inc', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Sterling Oil', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Sun Trust Oil ', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Geoplex Limited', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Ascon Oil', getdate())
		Insert INTO ClientManagement.ClientDirectory values (' ', 'Delta Lift Resources', getdate())
		


CREATE TABLE ClientManagement.ClientInfo

(
		Id int identity(1,1) CONSTRAINT pkId PRIMARY KEY NOT NULL,
		ClientId varchar(10) NOT NULL CONSTRAINT fkClientInfoId FOREIGN KEY REFERENCES ClientManagement.ClientDirectory(ClientId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		StreetLine1 varchar(20) NOT NULL,
		StreetLine2 varchar(20) NULL,
		City char(3) NOT NULL,
		PhoneNumber1 char(11) NOT NULL,
		PhoneNumber2 varchar(11) NULL,
		EmailAddress varchar(40) NOT NULL
)
		

		Insert INTO ClientManagement.ClientInfo values ('CLIENT-1', '2 Nkpogu Road', 'N/A', 'PHC', '07065486654', 'N/A' , 'CatecNigeria@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-2', '5 East-West Road', 'N/A', 'PHC', '07123436654', 'N/A' , 'Cregitala@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-3', '12 Trans-Amadi Road', 'N/A', 'PHC', '07065480983', 'N/A' , 'RGAfrica@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-4', '13 Siwes Road', 'GRA', 'PHC', '07011112233', 'N/A' , 'AfroSeas@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-5', '14 Peter Odili Road', 'N/A', 'PHC', '07065480987', 'N/A' , 'NewGroundsInc@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-6', '2 Damura Street', 'D/Line', 'PHC', '07014326654', 'N/A' , 'sterlingoil@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-7', '5 Bridgers Street', 'Old GRA', 'PHC', '07066646654', 'N/A' , 'suntrustoil@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-8', '13 Samers Close', 'GRA', 'PHC', '07065409874', 'N/A' , 'Geoplex@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-9', '5 Ogbunabali Street', 'N/A', 'PHC', '07065456654', 'N/A' , 'asconoil@gmail.com')
		Insert INTO ClientManagement.ClientInfo values ('CLIENT-10', '60 Crescent Close', 'GRA', 'PHC', '07011226654', 'N/A' , 'deltalift@gmail.com')

CREATE SCHEMA CompanyOperations


CREATE TABLE CompanyOperations.[Services]
(
		ServiceId int identity(1,1) CONSTRAINT pkServiceId PRIMARY KEY NOT NULL,
		ServiceName varchar(30) NOT NULL,
		ServiceDescription varchar(50) CONSTRAINT unServiceDescription UNIQUE NOT NULL,
		ModifiedDate date NOT NULL
)

		Insert INTO CompanyOperations.[Services] values ('Oil Exploration', 'Search for hydrocarbon deposits', getdate())
		Insert INTO CompanyOperations.[Services] values ('Maritime Vessel Lease', 'The leasing of maritime vessels', getdate())
		Insert INTO CompanyOperations.[Services] values ('Vessel Acquisition', 'The acquisition of maritime vessels', getdate())

		 

CREATE TABLE CompanyOperations.Project

(
		ProjectNo int identity(1,1) CONSTRAINT pkProjectNo PRIMARY KEY NOT NULL,
		InvoiceNo int NOT NULL CONSTRAINT fkInvoiceNo FOREIGN KEY REFERENCES Accounting.ServiceInvoice(InvoiceNo) ON DELETE NO ACTION ON UPDATE NO ACTION CONSTRAINT ukProject UNIQUE,
		ProjectDuration varchar(10) NOT NULL,
		StartDate date NOT NULL
)

		Insert INTO CompanyOperations.Project values (1001, '2 weeks', '2011-04-20')
		Insert INTO CompanyOperations.Project values (1002, '2 weeks', '2011-09-25')
		Insert INTO CompanyOperations.Project values (1003, '2 weeks', '2012-07-22')
		Insert INTO CompanyOperations.Project values (1004, '1 week', '2013-09-21')
		Insert INTO CompanyOperations.Project values (1005, '1 week', '2013-05-20')
		Insert INTO CompanyOperations.Project values (1006, '1 week', '2013-09-19')
		Insert INTO CompanyOperations.Project values (1007, '4 weeks', '2013-10-20')
		Insert INTO CompanyOperations.Project values (1008, '2 weeks', '2013-10-23')
		Insert INTO CompanyOperations.Project values (1009, '4 weeks', '2013-11-30')
		Insert INTO CompanyOperations.Project values (1010, '4 weeks', '2013-12-14')
		Insert INTO CompanyOperations.Project values (1011, '2 weeks', '2014-02-20')
		Insert INTO CompanyOperations.Project values (1012, '1 week', '2014-06-09')
		Insert INTO CompanyOperations.Project values (1013, '2 weeks', '2014-07-20')
		Insert INTO CompanyOperations.Project values (1014, '4 weeks', '2015-05-20')
		Insert INTO CompanyOperations.Project values (1015, '2 weeks', '2015-08-20')
		Insert INTO CompanyOperations.Project values (1016, '2 weeks', '2016-05-11')
		Insert INTO CompanyOperations.Project values (1017, '1 week', '2016-09-16')
		Insert INTO CompanyOperations.Project values (1018, '1 week', '2016-10-10')
		Insert INTO CompanyOperations.Project values (1019, '2 weeks', '2017-11-18')
		Insert INTO CompanyOperations.Project values (1020, '4 weeks', '2018-02-14')
		Insert INTO CompanyOperations.Project values (1021, '1 week', '2018-02-20')
		Insert INTO CompanyOperations.Project values (1022, '1 week', '2018-06-12')
		Insert INTO CompanyOperations.Project values (1023, '4 weeks', '2018-07-15')
		Insert INTO CompanyOperations.Project values (1024, '2 weeks', '2018-05-18')
		Insert INTO CompanyOperations.Project values (1025, '1 week', '2018-08-19')
		Insert INTO CompanyOperations.Project values (1026, '4 weeks',  '2018-09-12')
		Insert INTO CompanyOperations.Project values (1027, '1 week', '2018-10-23')
		Insert INTO CompanyOperations.Project values (1028, '2 weeks', '2018-11-28')
		Insert INTO CompanyOperations.Project values (1029, '2 weeks', '2019-01-19')



CREATE TABLE CompanyOperations.ProjectTeam
(
		ProjectTeamId int identity(1000, 1) CONSTRAINT pkProjectTeamId PRIMARY KEY NOT NULL,
		ProjectNo int NOT NULL CONSTRAINT fkProjectTeamProjectNo FOREIGN KEY REFERENCES CompanyOperations.Project(ProjectNo) ON DELETE NO ACTION ON UPDATE NO ACTION,
		DepartmentId int NOT NULL CONSTRAINT fkProjectTeamDepartmentId FOREIGN KEY REFERENCES HumanResources.Department(DepartmentId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		[Date] datetime NOT NULL				
)

		Insert INTO CompanyOperations.ProjectTeam values (1, 4, '2011-04-20')
		Insert INTO CompanyOperations.ProjectTeam values (2, 4, '2011-09-25')
		Insert INTO CompanyOperations.ProjectTeam values (3, 4, '2012-07-22')
		Insert INTO CompanyOperations.ProjectTeam values (4, 1, '2013-09-21')
		Insert INTO CompanyOperations.ProjectTeam values (5, 1, '2013-05-20')
		Insert INTO CompanyOperations.ProjectTeam values (6, 1, '2013-09-19')
		Insert INTO CompanyOperations.ProjectTeam values (7, 1, '2013-10-20')
		Insert INTO CompanyOperations.ProjectTeam values (8, 4, '2013-10-23')
		Insert INTO CompanyOperations.ProjectTeam values (9, 1, '2013-11-30')
		Insert INTO CompanyOperations.ProjectTeam values (10, 1, '2013-12-14')
		Insert INTO CompanyOperations.ProjectTeam values (11, 4, '2014-02-20')
		Insert INTO CompanyOperations.ProjectTeam values (12, 1, '2014-06-09')
		Insert INTO CompanyOperations.ProjectTeam values (13, 4, '2014-07-20')
		Insert INTO CompanyOperations.ProjectTeam values (14, 1, '2015-05-20')
		Insert INTO CompanyOperations.ProjectTeam values (15, 4, '2015-08-20')
		Insert INTO CompanyOperations.ProjectTeam values (16, 4, '2016-05-11')
		Insert INTO CompanyOperations.ProjectTeam values (17, 1, '2016-09-16')
		Insert INTO CompanyOperations.ProjectTeam values (18, 1, '2016-10-10')
		Insert INTO CompanyOperations.ProjectTeam values (19, 4, '2017-11-18')
		Insert INTO CompanyOperations.ProjectTeam values (20, 1, '2018-02-14')
		Insert INTO CompanyOperations.ProjectTeam values (21, 1, '2018-02-20')
		Insert INTO CompanyOperations.ProjectTeam values (22, 1, '2018-06-12')
		Insert INTO CompanyOperations.ProjectTeam values (23, 1, '2018-07-15')
		Insert INTO CompanyOperations.ProjectTeam values (24, 4, '2018-05-18')
		Insert INTO CompanyOperations.ProjectTeam values (25, 1, '2018-08-19')
		Insert INTO CompanyOperations.ProjectTeam values (26, 1,  '2018-09-12')
		Insert INTO CompanyOperations.ProjectTeam values (27, 1, '2018-10-23')
		Insert INTO CompanyOperations.ProjectTeam values (28, 4, '2018-11-28')
		Insert INTO CompanyOperations.ProjectTeam values (29, 4, '2019-01-19')

		
CREATE TABLE CompanyOperations.Operations
(
		OperationId int identity(1,1) CONSTRAINT pkOperationId PRIMARY KEY NOT NULL,
		OperationName varchar(20) NOT NULL,
		OperationDescription varchar(50) NOT NULL,
		ServiceId int NOT NULL CONSTRAINT fkServiceId FOREIGN KEY REFERENCES CompanyOperations.[Services](ServiceId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		Price int NULL
)

		Insert INTO CompanyOperations.Operations values ('Land Surveying', 'Discovering fertile land for Oil Exploration', 1 , 400000)
		Insert INTO CompanyOperations.Operations values ('Identifying Deposits' , 'Analysis of the residue from Land Surveying' , 1 , 500000)
		Insert INTO CompanyOperations.Operations values ('Drilling Wells' , 'Driilling of Oil Wells to extract oil', 1 , 1500000)
		Insert INTO CompanyOperations.Operations values ('Feasibility Studies' , 'Using data to analysis the practability of project', 1 , 250000)
		Insert INTO CompanyOperations.Operations values ('Vessel Maintenance' , 'Regular up keep of vessels', 2 , 300000)
		Insert INTO CompanyOperations.Operations values ('Vessel Lease' , 'Loaning out vessel to client', 2 , 3000000)
		Insert INTO CompanyOperations.Operations values ('Vessel Test Run', 'Automation of vessel', 3 , 150000)
		Insert INTO CompanyOperations.Operations values ('Vessel Acquisition', 'Purchase of maritime vessels', 3 , 5000000)
		Insert INTO CompanyOperations.Operations values ('Equipment Lease' , 'Contractual lease of heavy machinery to client', 2 , 1500000)


--trigger for Service Transaction ID
Create TRIGGER ServiceTransactionId
	ON  CompanyOperations.ServiceTransactions
	AFTER  INSERT
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;


		UPDATE a
		SET    TransactionId = 'ST' + LEFT('-' + CAST(inserted.[No] AS VARCHAR(10)), 10)
		FROM   CompanyOperations.ServiceTransactions a
		   INNER JOIN inserted
			 ON a.[No] = inserted.[No]

END

CREATE TABLE CompanyOperations.ServiceTransactions


(
		
		[No] int identity(1,1) NOT NULL,
		TransactionId varchar(10) CONSTRAINT pkTransactionId PRIMARY KEY NOT NULL,
		OperationId int NOT NULL CONSTRAINT fkServiceTransactionsOperationId FOREIGN KEY REFERENCES CompanyOperations.Operations(OperationId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		ClientId varchar(10) NULL CONSTRAINT fkServiceTransactionsClientId FOREIGN KEY REFERENCES ClientManagement.ClientDirectory(ClientId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		TransactionDate date NOT NULL
)
 

		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-2', '2011-04-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-4', '2011-09-20')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-5', '2012-07-17')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-2', '2013-09-16')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-7', '2013-05-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-8', '2013-09-19')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-10','2013-10-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-3', '2013-10-18')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-9', '2013-11-25')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-2', '2013-12-09')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-7', '2014-02-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-10','2014-06-09')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-9', '2014-07-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-3', '2015-05-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-9', '2015-08-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-2', '2016-05-06')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-7', '2016-09-11')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-2', '2016-10-05')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-10','2017-11-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-5', '2018-02-09')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-9', '2018-02-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-4', '2018-06-09')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-9', '2018-07-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-3', '2018-05-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-9', '2018-08-15')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 3 , 'CLIENT-2', '2018-09-06')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 2 , 'CLIENT-7', '2018-10-18')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-2', '2018-11-25')
		Insert INTO CompanyOperations.ServiceTransactions values (' ', 1 , 'CLIENT-9', '2019-01-15')

--trigger for Leasing Transaction ID
 
Create TRIGGER NewLeasingTransactionId
	ON  CompanyOperations.LeasingTransactions
	AFTER  INSERT
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;


		UPDATE a
		SET    TransactionId = 'LE' + LEFT('-' + CAST(inserted.[No] AS VARCHAR(10)), 10)
		FROM   CompanyOperations.LeasingTransactions a
		   INNER JOIN inserted
			 ON a.[No] = inserted.[No]

END

CREATE TABLE CompanyOperations.LeasingTransactions


(
		[No] int identity(1,1) NOT NULL,
		TransactionId varchar(10) CONSTRAINT pkLeasingTransactionId PRIMARY KEY NOT NULL,
		OperationId int NOT NULL CONSTRAINT fkLeasingTransactionsOperationId FOREIGN KEY REFERENCES CompanyOperations.Operations(OperationId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		ClientId varchar(10) NULL CONSTRAINT fkLeasingTransactionsClientId FOREIGN KEY REFERENCES ClientManagement.ClientDirectory(ClientId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		EquipmentId int NULL CONSTRAINT fkLeasingTransactionsEquipmentId FOREIGN KEY REFERENCES CompanyOperations.Equipment(EquipmentId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		TransactionDate date NOT NULL
)

		Insert INTO CompanyOperations.LeasingTransactions values (' ', 6 , 'CLIENT-8', '26', '2011-11-13')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 6 , 'CLIENT-10 ', '29', '2013-04-17')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 9 , 'CLIENT-1', '1', '2015-08-17')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 6 , 'CLIENT-9', '27', '2016-09-18')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 6 , 'CLIENT-5', '29', '2016-11-09')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 9 , 'CLIENT-1 ', '20', '2016-12-17')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 9 , 'CLIENT-3', '17', '2017-09-20')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 9 , 'CLIENT-7', '15', '2017-11-18')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 9 , 'CLIENT-2', '20',  '2018-09-20')
		Insert INTO CompanyOperations.LeasingTransactions values (' ', 6 , 'CLIENT-3', '27', '2018-11-18')


--trigger for Acquisition Transaction ID
Create TRIGGER AcquisitionTransactionId
	ON  CompanyOperations.AcquisitionTransactions
	AFTER  INSERT
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;


		UPDATE a
		SET    TransactionId = 'AT' + LEFT('-' + CAST(inserted.[No] AS VARCHAR(10)), 10)
		FROM   CompanyOperations.AcquisitionTransactions a
		   INNER JOIN inserted
			 ON a.[No] = inserted.[No]

END

CREATE TABLE CompanyOperations.AcquisitionTransactions

(
		[No] int identity (1,1) NOT NULL,
		TransactionId varchar(10) CONSTRAINT pkAcquisitionTransactionId PRIMARY KEY NOT NULL,
		OperationId int NOT NULL CONSTRAINT fkAcquisitionTransactionsOperationId FOREIGN KEY REFERENCES CompanyOperations.Operations(OperationId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		VendorId int NULL CONSTRAINT fkAcquisitionTransactionsVendorId FOREIGN KEY REFERENCES VendorManagement.Vendor(VendorId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		EquipmentId int NULL CONSTRAINT fkAcquisitionTransactionsEquipmentId FOREIGN KEY REFERENCES CompanyOperations.Equipment(EquipmentId) ON DELETE NO ACTION ON UPDATE NO ACTION CONSTRAINT uqTransEquiq UNIQUE,
		TransactionDate DATE NOT NULL
)

		Insert INTO CompanyOperations.AcquisitionTransactions values (' ', '8', '13', '26', '2006-02-11')
		Insert INTO CompanyOperations.AcquisitionTransactions values (' ', '8', '4', '27', '2007-09-11')
		Insert INTO CompanyOperations.AcquisitionTransactions values (' ', '8', '8', '28', '2008-02-17')
		Insert INTO CompanyOperations.AcquisitionTransactions values (' ', '8', '6', '29', '2009-01-19')
		Insert INTO CompanyOperations.AcquisitionTransactions values (' ', '8', '4', '30', '2009-11-24')

CREATE TABLE CompanyOperations.Equipment
	
(
		EquipmentId int identity(1,1) CONSTRAINT pkEquipmentId PRIMARY KEY NOT NULL,
		EquipmentName varchar(20) NOT NULL,
		EqupimentType varchar(20) NOT NULL,
		ModelNo varchar(10) NOT NULL,
		Color varchar(8) NOT NULL,
		[Weight] varchar(10) NOT NULL,
		VendorId int NOT NULL CONSTRAINT fkVendorId FOREIGN KEY REFERENCES VendorManagement.Vendor(VendorId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		OperationId int NOT NULL CONSTRAINT fkOperationId FOREIGN KEY REFERENCES CompanyOperations.Operations(OperationId) ON DELETE NO ACTION ON UPDATE NO ACTION
)


		Insert INTO CompanyOperations.Equipment values ('Mirage WQL DLP 5000', '3D Projector', 'SWR-0998', 'Black', '150kg', 3, 2)
		Insert INTO CompanyOperations.Equipment values ('Emsco-1500', 'Drilling Rig', 'TDC-9998', 'Yellow', '500kg', 4, 3)
		Insert INTO CompanyOperations.Equipment values ('Emsco-5000', 'Drilling Rig', 'TDC-4456', 'Black', '500kg', 9, 3)
		Insert INTO CompanyOperations.Equipment values ('Cangzhou High', 'Oilfield Casting', 'SWR-1111', 'Grey', '200kg', 12, 3)
		Insert INTO CompanyOperations.Equipment values ('Wuxi Eastsun', 'Oilfield Casting', 'SWL-0990', 'Grey', '200kg', 15, 3) 
		Insert INTO CompanyOperations.Equipment values ('Hebei Chengyuan Pipe', 'Oilfield Casting', 'SWR-0991', 'Black', '150kg', 13, 3)
		Insert INTO CompanyOperations.Equipment values ('Bazhou Deli', 'Derrick Crane', 'TDC-9991', 'Black', '200kg', 12, 1)
		Insert INTO CompanyOperations.Equipment values ('Henan Yuantai', 'Derrick Crane', 'SSG-4456', 'Black', '500kg', 17, 3)
		Insert INTO CompanyOperations.Equipment values ('Cangzhou High', 'Oilfield Casting', 'SWR-1111', 'Grey', '200kg', 7, 3)
		Insert INTO CompanyOperations.Equipment values ('Trans Eastsun', 'Oilfield Casting', 'SSG-0914', 'Black', '200kg', 1, 3)
		Insert INTO CompanyOperations.Equipment values ('Mestal WQL DLP 3000', '3D Projector', 'SWR-1123', 'Black', '150kg', 8, 2)
		Insert INTO CompanyOperations.Equipment values ('Cangzhou JSBIT', 'Roller Bit', 'TDC-9998', 'Yellow', '500kg', 10, 3)
		Insert INTO CompanyOperations.Equipment values ('Cangzhou Lockheed', 'Diamond Bit', 'TDC-4677', 'Blue', '120kg', 2, 3)
		Insert INTO CompanyOperations.Equipment values ('Hebei Solidkey', 'Roller Bit', 'SWL-1910', 'Brown', '200kg', 6, 3)
		Insert INTO CompanyOperations.Equipment values ('Qingzhou Rongwei', 'Payloader', 'SSD-0990', 'Yellow', '800kg', 8, 3) 
		Insert INTO CompanyOperations.Equipment values ('Shandong Mountain', 'Payloader', 'SWD-0991', 'Black', '800kg', 5, 3)
		Insert INTO CompanyOperations.Equipment values ('Taian Hysoon', 'Payloader', 'SWD-9991', 'Red', '800kg', 6, 3)
		Insert INTO CompanyOperations.Equipment values ('Evangel Industrial', 'Bulldozer', 'SWL-4426', 'Black', '500kg', 9, 3)
		Insert INTO CompanyOperations.Equipment values ('Jining Infront', 'Bulldozer', 'SWR-2311', 'Grey', '700kg', 11, 3)
		Insert INTO CompanyOperations.Equipment values ('Newindu Construction', 'Bulldozer', 'SSG-0657', 'Black', '750kg', 13, 3)
		Insert INTO CompanyOperations.Equipment values ('Cangzhou JSBITX', '3D Projector', 'TDC-0118', 'Yellow', '500kg', 14, 2)
		Insert INTO CompanyOperations.Equipment values ('KAT 4435XS', 'Diamond Bit', 'SWR-4677', 'Blue', '120kg', 20, 3)
		Insert INTO CompanyOperations.Equipment values ('KAT 5567XZ', 'Roller Bit', 'SWL-1080', 'Brown', '200kg', 19, 3)
		Insert INTO CompanyOperations.Equipment values ('Xuzhou Heavy', 'Payloader', 'SSD-0955', 'Yellow', '800kg', 18, 3) 
		Insert INTO CompanyOperations.Equipment values ('Luoyang Chunqiu', 'Payloader', 'SLL-0915', 'Black', '800kg', 15, 3)
		Insert INTO CompanyOperations.Equipment values ('Qingdao Gospel', 'Maritime Vessel', 'TDC-1195', 'Yellow', '10 TONS', 13, 6)
		Insert INTO CompanyOperations.Equipment values ('Dongguan Miyabi FRP', 'Maritime Vessel', 'SWR-4887', 'Blue', '10 TONS', 4, 6)
		Insert INTO CompanyOperations.Equipment values ('Qingdao Evergreen', 'Maritime Vessel', 'SWL-0080', 'Brown', '10 TONS', 8, 6)
		Insert INTO CompanyOperations.Equipment values ('Shenzhen Sowze', 'Maritime Vessel', 'SSD-0675', 'Yellow', '10 TONS', 6, 6) 
		Insert INTO CompanyOperations.Equipment values ('Wuhan Greenbay', 'Maritime Vessel', 'SLL-0776', 'Black', '10 TONS', 9, 6)


CREATE TABLE CompanyOperations.Inventory

(
		InventoryNo int identity(1,1) CONSTRAINT pkInventoryNo PRIMARY KEY NOT NULL,
		EquipmentId int NOT NULL CONSTRAINT fkInventoryEquipmentId FOREIGN KEY REFERENCES CompanyOperations.Equipment(EquipmentId) ON DELETE NO ACTION ON UPDATE NO ACTION CONSTRAINT uqInventory UNIQUE,
		Quantity int NOT NULL,
		[Status] varchar(9) NOT NULL CONSTRAINT chkStatus CHECK(Status IN('Available', 'N/A')),
		ModifiedDate datetime NOT NULL 
)
		

		Insert INTO CompanyOperations.Inventory values (1, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (2, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (3, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (4, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (5, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (6, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (7, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (8, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (9, 1, 'N/A', getdate())
		Insert INTO CompanyOperations.Inventory values (10, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (11, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (12, 1, 'N/A', getdate())
		Insert INTO CompanyOperations.Inventory values (13, 3, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (14, 3, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (15, 3, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (16, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (17, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (18, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (19, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (20, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (21, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (22, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (23, 2, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (24, 2, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (25, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (26, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (27, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (28, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (29, 1, 'Available', getdate())
		Insert INTO CompanyOperations.Inventory values (30, 1, 'Available', getdate())


CREATE SCHEMA VendorManagement

select * from VendorManagement.Vendor
CREATE TABLE VendorManagement.Vendor

(
		VendorId int identity(1,1) CONSTRAINT pkVendorId PRIMARY KEY NOT NULL,
		VendorName varchar(20) NOT NULL,
		ModifiedDate date NOT NULL
)
	

		Insert INTO VendorManagement.Vendor values ('C Woermann Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Bertola Machine', getdate())
		Insert INTO VendorManagement.Vendor values ('Atlas Copco Nid Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('C Woermann Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('SCOA Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Finlab Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Mann Track Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Eauxwell Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Epoxy Oil Serve', getdate())
		Insert INTO VendorManagement.Vendor values ('M Daas Nigeria', getdate())
		Insert INTO VendorManagement.Vendor values ('Johak Nig Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Solar Wizard Nig', getdate())
		Insert INTO VendorManagement.Vendor values ('Okee Nig Supply', getdate())
		Insert INTO VendorManagement.Vendor values ('Onwura & Sons', getdate())
		Insert INTO VendorManagement.Vendor values ('Vier Investment', getdate())
		Insert INTO VendorManagement.Vendor values ('Heights Access Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('Lidel Supplies', getdate())
		Insert INTO VendorManagement.Vendor values ('Seccle Gold Ltd', getdate())
		Insert INTO VendorManagement.Vendor values ('PartzShop', getdate())
		Insert INTO VendorManagement.Vendor values ('Zuru Part Nig Ltd', getdate())

CREATE TABLE VendorManagement.VendorFinancials
(
		Id int identity(1,1) CONSTRAINT pkVFId PRIMARY KEY NOT NULL,
		VendorId int NOT NULL CONSTRAINT fkFinancialsVendorId FOREIGN KEY REFERENCES VendorManagement.Vendor(VendorId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		BankId int NOT NULL CONSTRAINT fkVendorFinancialsBankId FOREIGN KEY REFERENCES Accounting.Bank(BankId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		AccountNumber varchar(10) NOT NULL CONSTRAINT chkVendorAccountNumber CHECK(AccountNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')	 
)
		

		Insert INTO VendorManagement.VendorFinancials values (1, 3, '0908767898')
		Insert INTO VendorManagement.VendorFinancials values (2, 7, '7765890984')
		Insert INTO VendorManagement.VendorFinancials values (3, 3, '0111237898')
		Insert INTO VendorManagement.VendorFinancials values (4, 13, '0776699897')
		Insert INTO VendorManagement.VendorFinancials values (5, 9, '0998877665')
		Insert INTO VendorManagement.VendorFinancials values (6, 5, '0123456789')
		Insert INTO VendorManagement.VendorFinancials values (7, 11, '0223344556')
		Insert INTO VendorManagement.VendorFinancials values (8, 17, '0887766001')
		Insert INTO VendorManagement.VendorFinancials values (9, 14, '0776655448')
		Insert INTO VendorManagement.VendorFinancials values (10, 2, '0990099882')
		Insert INTO VendorManagement.VendorFinancials values (11, 3, '0765767898')
		Insert INTO VendorManagement.VendorFinancials values (12, 1, '7765890984')
		Insert INTO VendorManagement.VendorFinancials values (13, 7, '0778857898')
		Insert INTO VendorManagement.VendorFinancials values (14, 10, '0776699665')
		Insert INTO VendorManagement.VendorFinancials values (15, 4, '0009877665')
		Insert INTO VendorManagement.VendorFinancials values (16, 5, '0123459876')
		Insert INTO VendorManagement.VendorFinancials values (17, 11, '0667744556')
		Insert INTO VendorManagement.VendorFinancials values (18, 10, '0887767101')
		Insert INTO VendorManagement.VendorFinancials values (19, 4, '0776688765')
		Insert INTO VendorManagement.VendorFinancials values (20, 2, '0011099882')

CREATE TABLE VendorManagement.VendorContactDetails
		
(
		Id int identity(1,1) CONSTRAINT pkVendorContactDetailsId PRIMARY KEY NOT NULL,
		VendorId int NOT NULL CONSTRAINT fkVendorContactDetailsVendorId FOREIGN KEY REFERENCES VendorManagement.Vendor(VendorId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		StreetLine1 varchar(20) NOT NULL,
		StreetLine2 varchar(20) NOT NULL, 
		PhoneNumber1 char(11) NOT NULL,
		PhoneNumber2 varchar(11) NULL,
		EmailAddress varchar(40) NOT NULL
)
		
		
		Insert INTO VendorManagement.VendorContactDetails values (1, '23 IliHausa Road', 'GRA', '08135567876', 'N/A' , 'WoermanNig@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (2, '23 Asamadi Road', 'GRA', '08130097876', 'N/A' , 'Bertolamachine@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (3, '30 Apex Complex', 'Sani Abacha Road', '08135567987', 'N/A' , 'atlascopcog@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (4, '35 Dillan Street', 'GRA', '08135565576', 'N/A' , 'acewoe@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (5, '401	Ubeki Road', 'GRA', '08009565576', 'N/A' , 'ttyd56@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (6, '01 Linesman Road', 'Nkpogu', '08009511576', 'N/A' , 'tkjhd56@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (7, '41 Lightbay Road', 'Elekahia', '08009561122', 'N/A' , 'fgtyd56@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (8, '11 Fruit Drive', 'GRA', '08119565576', 'N/A' , 'iiuj56@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (9, '45 Fruit Drive', 'GRA', '08119777576', 'N/A' , 'obi776@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (10, '11	Ubeki Road', 'GRA', '08009777576', 'N/A' , 'yuh77oo6@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (11, '11 UBA Lane', 'Trans-Amadi', '08001777576', 'N/A' , 'uhyd776@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (12, '103 IliHausa Road', 'Elekahia', '08137707876', 'N/A' , 'hydtg55g@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (13, '2 Asamadi Road', 'GRA', '08144397876', 'N/A' , 'Berojud55chine@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (14, '30 Autograph Complex', 'Sani Abacha Road', '08135560000', 'N/A' , 'athui99opcog@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (15, '35 Evo Road', 'GRA', '08137765576', 'N/A' , 'acjidyt77e@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (16, 'Genesis Complex', 'GRA', '08778665576', 'N/A' , 'ttyd56@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (17, 'Atrium Hall', 'Stadium Road', '08009511999', 'N/A' , 'tk88766@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (18, '4 Lightbay Road', 'Elekahia', '08009509122', 'N/A' , 'aa97756@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (19, '11 Samantha Drive', 'Ikoku', '08119569976', 'N/A' , 'ii99056@gmail.com')
		Insert INTO VendorManagement.VendorContactDetails values (20, '45 Cocaine Drive', 'GRA', '08078657576', 'N/A' , 'obithf376@gmail.com')
		
CREATE SCHEMA Accounting

CREATE TABLE Accounting.Bank 
(
		BankId int identity(1,1) CONSTRAINT pkBankId PRIMARY KEY NOT NULL,
		BankName varchar(20) NOT NULL,
		ModifiedDate datetime NOT NULL
)

		Insert INTO Accounting.Bank values ('Access Bank', getdate())
		Insert INTO Accounting.Bank values ('Fidelity', getdate())
		Insert INTO Accounting.Bank values ('FCMB', getdate())
		Insert INTO Accounting.Bank values ('First Bank', getdate())
		Insert INTO Accounting.Bank values ('GT Bank', getdate())
		Insert INTO Accounting.Bank values ('Union Bank', getdate())
		Insert INTO Accounting.Bank values ('UBA Bank', getdate())
		Insert INTO Accounting.Bank values ('Zenith Bank', getdate())
		Insert INTO Accounting.Bank values ('Citi Bank', getdate())
		Insert INTO Accounting.Bank values ('Diamond Bank', getdate())
		Insert INTO Accounting.Bank values ('Eco Bank', getdate())
		Insert INTO Accounting.Bank values ('Heritage Bank', getdate())
		Insert INTO Accounting.Bank values ('Keystone Bank', getdate())
		Insert INTO Accounting.Bank values ('Polaris Bank', getdate())
		Insert INTO Accounting.Bank values ('Stanbic IBTC Bank', getdate())
		Insert INTO Accounting.Bank values ('Standard Chat. Bank', getdate())
		Insert INTO Accounting.Bank values ('Unity Bank', getdate())
		Insert INTO Accounting.Bank values ('Wema Bank', getdate())
		Insert INTO Accounting.Bank values ('Sterling Bank', getdate())
		
-- Salary Column Encryption

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password123';
GO

CREATE CERTIFICATE Certificate1
WITH SUBJECT = 'Protect Data';
GO

CREATE SYMMETRIC KEY SymmetricKey1 
 WITH ALGORITHM = AES_128 
 ENCRYPTION BY CERTIFICATE Certificate1;
GO

ALTER TABLE Accounting.Salary 
ADD SalaryColumnEncryption varbinary(MAX) NULL
GO

-- Opens the symmetric key for use
OPEN SYMMETRIC KEY SymmetricKey1
DECRYPTION BY CERTIFICATE Certificate1;
GO
UPDATE Accounting.Salary
SET SalaryColumnEncryption = EncryptByKey (Key_GUID('SymmetricKey1'), MonthlyAmount)
FROM JaPaulOilCompany.Accounting.Salary;
GO
-- Closes the symmetric key
CLOSE SYMMETRIC KEY SymmetricKey1;
GO

--Drop MonthlyAmount Column
ALTER TABLE Accounting.Salary
DROP COLUMN MonthlyAmount

--Grant access to user 

GRANT VIEW DEFINITION ON SYMMETRIC KEY::SymmetricKey1 TO test; 
GO
GRANT VIEW DEFINITION ON Certificate::Certificate1 TO test;
GO

-- View encrypted details 
Execute as user='test'
GO
SELECT Id, EmployeeId,
CONVERT(varchar, DecryptByKey(SalaryColumnEncryption)) AS 'Decrypted Employee Salary'
FROM Accounting.Salary;



CREATE TABLE Accounting.Salary

(
		Id int identity(1,1) CONSTRAINT pkId PRIMARY KEY NOT NULL,
		EmployeeId int NOT NULL CONSTRAINT fkSalaryEmployeeId FOREIGN KEY REFERENCES HumanResources.Employee(EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION CONSTRAINT uqSalary UNIQUE,
		MonthlyAmount int NOT NULL
)

		--alter Monthly amt column from int to varchar for encryption by key
		alter table Accounting.Salary
		alter column MonthlyAmount varchar(25) NOT NULL
		select * from accounting.salary
		Insert into Accounting.Salary values (1, 1500000)
		Insert into Accounting.Salary values (2, 750000)
		Insert into Accounting.Salary values (3, 750000)
		Insert into Accounting.Salary values (4, 750000)
		Insert into Accounting.Salary values (5, 750000)
		Insert into Accounting.Salary values (6, 750000)
		Insert into Accounting.Salary values (7, 750000)
		Insert into Accounting.Salary values (8, 750000)
		Insert into Accounting.Salary values (9, 750000)
		Insert into Accounting.Salary values (10, 750000)
		Insert into Accounting.Salary values (11, 500000)
		Insert into Accounting.Salary values (12, 500000)
		Insert into Accounting.Salary values (13, 500000)
		Insert into Accounting.Salary values (14, 500000)
		Insert into Accounting.Salary values (15, 400000)
		Insert into Accounting.Salary values (16, 250000)
		Insert into Accounting.Salary values (17, 250000)
		Insert into Accounting.Salary values (18, 250000)
		Insert into Accounting.Salary values (19, 400000)
		Insert into Accounting.Salary values (20, 250000)
		Insert into Accounting.Salary values (21, 250000)
		Insert into Accounting.Salary values (22, 250000)
		Insert into Accounting.Salary values (23, 250000)
		Insert into Accounting.Salary values (24, 250000)
		Insert into Accounting.Salary values (25, 250000)
		Insert into Accounting.Salary values (26, 250000)
		Insert into Accounting.Salary values (27, 250000)
		Insert into Accounting.Salary values (28, 250000)
		Insert into Accounting.Salary values (29, 250000)
		Insert into Accounting.Salary values (30, 350000)
		Insert into Accounting.Salary values (31, 350000)
		Insert into Accounting.Salary values (32, 350000)
		Insert into Accounting.Salary values (33, 350000)
		Insert into Accounting.Salary values (34, 400000)
		Insert into Accounting.Salary values (35, 250000)
		Insert into Accounting.Salary values (36, 250000)
		Insert into Accounting.Salary values (37, 250000)
		Insert into Accounting.Salary values (38, 400000)
		Insert into Accounting.Salary values (39, 250000)
		Insert into Accounting.Salary values (40, 250000)
		Insert into Accounting.Salary values (41, 400000)
		Insert into Accounting.Salary values (42, 250000)
		Insert into Accounting.Salary values (43, 250000)
		Insert into Accounting.Salary values (44, 250000)


CREATE TABLE Accounting.ServiceInvoice

(
		InvoiceNo int identity(1001,1) NOT NULL CONSTRAINT pkInvoiceNo PRIMARY KEY,
		TransactionId varchar(10) CONSTRAINT fkServiceInvoiceTransactionId FOREIGN KEY REFERENCES CompanyOperations.ServiceTransactions(TransactionId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		IssueDate date NOT NULL,
		PaymentDate date NULL,
		InvoiceStatus varchar(8) NOT NULL CONSTRAINT chkServiceInvoice CHECK(InvoiceStatus IN('Paid', 'Not Paid'))
)

		Insert INTO Accounting.ServiceInvoice values ('ST-1', '2011-04-15','2011-04-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-2', '2011-09-20','2011-09-30', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-3', '2012-07-17','2012-07-27', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-4', '2013-09-16', '2013-09-26', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-5', '2013-05-15',  '2013-05-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-6', '2013-09-19', '2013-09-29', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-7', '2013-10-15', '2013-10-15', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-8', '2013-10-18', '2013-10-18', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-9', '2013-11-25', '2013-12-04', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-10', '2013-12-09', '2013-12-19', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-11', '2014-02-15',  '2014-02-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-12', '2014-06-09', '2014-06-19', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-13', '2014-07-15', '2014-07-15', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-14', '2015-05-15', '2014-07-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-15', '2015-08-15', '2015-08-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-16', '2016-05-06', '2016-05-16', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-17', '2016-09-11', '2016-09-21', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-18', '2016-10-05', '2016-10-15', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-19', '2017-11-15', '2017-11-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-20', '2018-02-09', '2018-02-19', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-21', '2018-02-15', '2018-02-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-22', '2018-06-09', '2018-06-19', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-23', '2018-07-15', '2018-07-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-24', '2018-05-15', '2018-05-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-25 ', '2018-08-15', '2018-08-25', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-26', '2018-09-06', '2018-09-16', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-27', '2018-10-18', '2018-10-28', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-28', '2018-11-25', '2018-12-04', 'Paid')
		Insert INTO Accounting.ServiceInvoice values ('ST-29 ', '2019-01-15', '2019-01-25', 'Paid')
		

CREATE TABLE Accounting.LeasingInvoice

(
		InvoiceNo int identity(11001,1) NOT NULL CONSTRAINT pkLeasingInvoiceNo PRIMARY KEY,
		TransactionId varchar(10) CONSTRAINT fkInvoiceTransactionId FOREIGN KEY REFERENCES CompanyOperations.LeasingTransactions(TransactionId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		IssueDate date NOT NULL,
		PaymentDate date NOT NULL,
		InvoiceStatus varchar(8) NOT NULL CONSTRAINT chkLeasingInvoice CHECK(InvoiceStatus IN('Paid', 'Not Paid'))
)

		Insert INTO Accounting.LeasingInvoice values ('LE-1', '2011-11-15', '2011-11-20', 'Paid' )
		Insert INTO Accounting.LeasingInvoice values ('LE-2', '2013-04-17', '2013-04-22', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-3', '2015-08-17', '2015-08-22', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-4', '2016-09-18', '2016-09-23', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-5', '2016-11-09', '2016-11-14', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-6', '2016-12-17', '2016-12-22', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-7', '2017-09-22', '2017-09-27', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-8 ', '2017-11-19', '2017-11-24', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-9 ', '2018-09-21', '2018-09-26', 'Paid')
		Insert INTO Accounting.LeasingInvoice values ('LE-10 ', '2018-11-24', '2018-11-29', 'Paid')

CREATE TABLE Accounting.AcquisitionInvoice

(
		InvoiceNo int identity(22001,1) NOT NULL CONSTRAINT pkAcquisitionInvoiceNo PRIMARY KEY,
		TransactionId varchar(10) CONSTRAINT fkAcquisitionInvoiceTransactionId FOREIGN KEY REFERENCES CompanyOperations.AcquisitionTransactions(TransactionId) ON DELETE NO ACTION ON UPDATE NO ACTION,
		IssueDate date NOT NULL,
		PaymentDate date NOT NULL,
		InvoiceStatus varchar(8) NOT NULL CONSTRAINT chkAcquisitionInvoice CHECK(InvoiceStatus IN('Paid', 'Not Paid'))

)

		Insert INTO Accounting.AcquisitionInvoice values ('AT-1 ','2006-02-11', '2006-03-11','Paid')
		Insert INTO Accounting.AcquisitionInvoice values ('AT-2 ', '2007-09-11','2007-10-11', 'Paid')
		Insert INTO Accounting.AcquisitionInvoice values ('AT-3 ', '2008-02-17', '2008-03-20', 'Paid')
		Insert INTO Accounting.AcquisitionInvoice values ('AT-4 ',  '2009-01-24', '2009-04-19', 'Paid')
		Insert INTO Accounting.AcquisitionInvoice values ('AT-5 ',  '2009-11-24', '2010-01-05','Paid')