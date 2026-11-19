/*
    Stored Procedure: dbo.ManufactureFogLights
    Purpose: Manufactures @Quantity of fog lights if our inventory bins have enough parts.

    How we do:
    - Checks that every bin in dbo.InventoryBin has at least @Quantity parts.
    - If inv is short it makes no changes and logs Manufacturing Failure in 
    dbo.OperationLogs, sets @ResultMessage, and returns -1.

    - If inv is enough it runs a transaction to create a dbo.ManufacturingInstances record.
        Generate each dbo.FogLight, its 6 part records (Harness, Reflector,
        Housing, Lens, Bulb, Bezel), and link them in dbo.AssemblyManifest.
        Deduct @Quantity from each bin and record usage in dbo.ComponentUsage.
        Log 'Inventory Update' (and 'Bin Emptied' for any bin hitting 0) in
           dbo.OperationLogs, set @ResultMessage, and return 0.
    - Rolls back on unexpected errors, logs Manufacturing Failure, and returns -2.
*/
--https://learn.microsoft.com/en-us/sql/t-sql/functions/scope-identity-transact-sql?view=sql-server-ver17
USE FogLightManufacturing;
GO

CREATE OR ALTER PROCEDURE dbo.ManufactureFogLights
    @Quantity INT,
    @ResultMessage VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    --Checking if any bin has fewer parts than @Quantity otherwise the manufacturing process will fail
    IF EXISTS (SELECT 1 FROM dbo.InventoryBin WHERE CurrentQuantity < @Quantity)
    BEGIN
        SET @ResultMessage = 'Not enough parts in the inventory to manufacture ' + CAST(@Quantity AS VARCHAR(10)) + ' requested foglight or foglights.';

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        VALUES ('Manufacturing Failure', @ResultMessage);

        RETURN -1;
    END

    --Get each of the ComponentID's for the 6 parts of a foglight
    DECLARE @HarnessID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Harness');
    DECLARE @ReflectorID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Reflector');
    DECLARE @HousingID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Housing');
    DECLARE @LensID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Lens');
    DECLARE @BulbID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Bulb');
    DECLARE @BezelID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Bezel');

    BEGIN TRY
        BEGIN TRANSACTION;

        --This is where we are making the making the run records (instances)
        INSERT INTO dbo.ManufacturingInstances (QuantityManufactured, Status)
        VALUES (@Quantity, 'Success');

        DECLARE @InstanceID INT = SCOPE_IDENTITY();

        --We are making the individual foglight records and their components
        DECLARE @i INT = 1;
        DECLARE @FogLightNo INT;
        DECLARE @HarnessNo INT, @ReflectorNo INT, @HousingNo INT;
        DECLARE @LensNo INT, @BulbNo INT, @BezelNo INT;

        WHILE @i <= @Quantity
        BEGIN
            INSERT INTO dbo.FogLight (InstanceID, FogLightTimestamp, Price)
            VALUES (@InstanceID, GETDATE(), 60.000);
            SET @FogLightNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Harness (ComponentID, Price) VALUES (@HarnessID, 10.000);
            SET @HarnessNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Reflector (ComponentID, Price) VALUES (@ReflectorID, 10.000);
            SET @ReflectorNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Housing (ComponentID, Price) VALUES (@HousingID, 10.000);
            SET @HousingNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Lens (ComponentID, Price) VALUES (@LensID, 10.000);
            SET @LensNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Bulb (ComponentID, Price) VALUES (@BulbID, 10.000);
            SET @BulbNo = SCOPE_IDENTITY();

            INSERT INTO dbo.Bezel (ComponentID, Price) VALUES (@BezelID, 10.000);
            SET @BezelNo = SCOPE_IDENTITY();

            INSERT INTO dbo.AssemblyManifest (
                FogLightSerialNo, HarnessSerialNo, ReflectorSerialNo,
                HousingSerialNo, LensSerialNo, BulbSerialNo, BezelSerialNo
            )
            VALUES (
                @FogLightNo, @HarnessNo, @ReflectorNo,
                @HousingNo, @LensNo, @BulbNo, @BezelNo
            );

            SET @i = @i + 1;
        END

        -- Update to subtract the used parts from each bin so we can keep track of how many parts are left in the inventory
        UPDATE dbo.InventoryBin
        SET CurrentQuantity = CurrentQuantity - @Quantity,
            LastUpdated = GETDATE();

        --Record how many of each component were used for our logs
        INSERT INTO dbo.ComponentUsage (InstanceID, ComponentID, QuantityUsed)
        SELECT @InstanceID, ComponentID, @Quantity
        FROM dbo.Component;

        -- Log that baby!
        SET @ResultMessage = 'Successfully manufactured ' + CAST(@Quantity AS VARCHAR(10)) + ' fog light(s).';

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        VALUES ('Inventory Update', @ResultMessage);

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        SELECT 'Bin Emptied', BinName + ' has been emptied!'
        FROM dbo.InventoryBin
        WHERE CurrentQuantity = 0;

        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        VALUES ('Manufacturing Failure', @ResultMessage);

        RETURN -2;
    END CATCH
END;
GO