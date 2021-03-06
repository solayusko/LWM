﻿CREATE TABLE Tasks
(
    Id INT IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
	Private BIT NOT NULL CONSTRAINT DF_Tasks_Private DEFAULT 1,
	Create_Id INT NOT NULL,
	Mod_Id INT,
	Create_Date DATETIME,
	Mod_Date DATETIME,
    
CONSTRAINT PK_Tasks_Id PRIMARY KEY (Id),
CONSTRAINT FK_Tasks_To_UsersC FOREIGN KEY (Create_Id)  REFERENCES Users (Id),
CONSTRAINT FK_Tasks_To_UsersM FOREIGN KEY (Mod_Id)  REFERENCES Users (Id)
)
GO
CREATE TRIGGER T_Insert_Tasks
ON Tasks AFTER INSERT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM INSERTED) OR (TRIGGER_NESTLEVEL() > 1)
		RETURN
	UPDATE Tasks
	SET Create_Date = GETDATE()
	WHERE Id IN (SELECT Id FROM INSERTED)
END;
GO
CREATE TRIGGER T_Update_Tasks
ON Tasks AFTER UPDATE
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM INSERTED) OR (TRIGGER_NESTLEVEL() > 1)
		RETURN
	UPDATE Tasks
	SET Mod_Date = GETDATE()
	WHERE Id IN (SELECT Id FROM INSERTED)
END;
