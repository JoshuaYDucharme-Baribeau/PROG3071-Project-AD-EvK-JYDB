-- Create Database
CREATE DATABASE FogLightManufacturing;
GO
USE FogLightManufacturing;
GO

--FogLight Table
--Serial no is different on every part, FogLightID is the same for every fog light
CREATE TABLE FogLight (
    FogLightSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FogLightID INT NOT NULL UNIQUE,
    FogLightTimestamp DATETIME NOT NULL,
    Price DECIMAL NOT NULL
    --May need to add an assembly log or reference of some kind here to track all the parts used in any given foglight--
);


-- Component Table
/*
This table exists to track each component that we create as well as give it 
definiing aspects such as a name, ID, and quality. INT Identity is used to make sure that the
ID is always increasing by a metric of 1.
Master table
*/
GO
CREATE TABLE Component (
--https://www.w3schools.com/sql/sql_autoincrement.asp
    ComponentID INT IDENTITY(1,1) PRIMARY KEY,
    ComponentName VARCHAR(50) NOT NULL UNIQUE,
);
GO

-- InventoryBins Table
/*
This table tracks our inventory bin! We want a way to track how much of a component
is in each of its storage bins. We use this so that we can keep track of when we can
use items, and when we need to restock. Its Linked FK to Components.
*/
CREATE TABLE InventoryBin (
    BinID INT IDENTITY(1,1) PRIMARY KEY,
    BinName VARCHAR(50) NOT NULL UNIQUE,
    BinLocation VARCHAR(50) NOT NULL UNIQUE,
    CurrentQuantity INT NOT NULL CHECK (CurrentQuantity >= 0),
-- Default makes it so we just use system date
    LastUpdated DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Bin_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);
GO




--the 6 tables for each part used in assembly BEGINS

CREATE TABLE Harness (
    HarnessSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Harness_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);


CREATE TABLE Reflector (
    ReflectorSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Reflector_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);

CREATE TABLE Housing (
    HousingSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Housing_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);

CREATE TABLE Lens (
    LensSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Lens_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);

CREATE TABLE Bulb (
    BulbSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Bulb_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);

CREATE TABLE Bezel (
    BezelSerialNo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ComponentID INT NOT NULL,
    Price DECIMAL NOT NULL,
    CONSTRAINT FK_Bezel_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);

--the 6 tables for each part used in assembly ENDS



/* --BinParts relationship table
--Added based on feedback, but this does not seem totally required since it is a one to many relationship 
-- (1 bin has many of one specific type of part, but all of those parts go in that one bin)
--left commented out because I think the existing structure without this relationship table is simpler
CREATE TABLE BinHasParts (
    BinID INT NOT NULL,
    ComponentID INT NOT NULL UNIQUE,
    CONSTRAINT FK_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
    CONSTRAINT FK_Bin FOREIGN KEY (BinID) REFERENCES InventoryBin(BinID)
);
*/


-- RestockHistory Table
/*
This exists to help us restock the components, we ensure that we are tracking the restock date so that 
people looking back can see the frequency. We need to have this so that the company this is
for can calculate their restock times and most profitable ammount of inventory to keep.
*/
CREATE TABLE RestockHistory (
    RestockID INT IDENTITY(1,1) PRIMARY KEY,
    BinID INT NOT NULL,
    QuantityAdded INT NOT NULL CHECK (QuantityAdded > 0),
    RestockTimestamp DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Restock_Bin FOREIGN KEY (BinID) REFERENCES InventoryBin(BinID)
);
GO

-- ManufacturingInstances Table
/*
This table tracks each instance of manufacturing,
we want to know how many were made,
when they were made, and if they were successful or not.
We need this specifically to interact with the C# program specifically.
*/
CREATE TABLE ManufacturingInstances (
    InstanceID INT IDENTITY(1,1) PRIMARY KEY,
    QuantityManufactured INT NOT NULL CHECK (QuantityManufactured > 0),
    RunTimestamp DATETIME DEFAULT GETDATE(),
    Status VARCHAR(10) NOT NULL CHECK (Status IN ('Success', 'Failed'))
);
GO

-- ComponentUsage Table
    --- This way we can use all the other IDS to delcare when a part is utilized
/*
This table is a junction table that links the ManufacturingInstances and Components tables.
It tracks which components were used in each manufacturing instance and 
how many of each component were used.
*/
CREATE TABLE ComponentUsage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    InstanceID INT NOT NULL,
    ComponentID INT NOT NULL,
    QuantityUsed INT NOT NULL CHECK (QuantityUsed > 0),
    CONSTRAINT FK_Usage_Run FOREIGN KEY (InstanceID) REFERENCES ManufacturingInstances(InstanceID),
    CONSTRAINT FK_Usage_Component FOREIGN KEY (ComponentID) REFERENCES Component(ComponentID)
);
GO

-- OperationLogs Table
/*
This table is used to log various operations and events that occur within the system.
*/
CREATE TABLE OperationLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EventType VARCHAR(50) NOT NULL, -- This stuff could be, Bin Emptied, Manufacturing Failure, Restock, or Update. That way we keep clean records
    LogDescription VARCHAR(MAX) NOT NULL,
    LogTimestamp DATETIME DEFAULT GETDATE()
);
GO