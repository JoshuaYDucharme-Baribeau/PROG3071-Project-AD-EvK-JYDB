
Use FogLightManufacturing;
Go
Create or Alter Procedure dbo.Restock
    @ResultMessage VARCHAR(255) = NULL OUTPUT
As
	Set NOCOUNT On;
	
    -- Get each of the ComponentID's for the 6 parts of a foglight
    DECLARE @HarnessID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Harness');
    DECLARE @ReflectorID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Reflector');
    DECLARE @HousingID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Housing');
    DECLARE @LensID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Lens');
    DECLARE @BulbID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Bulb');
    DECLARE @BezelID INT = (SELECT ComponentID FROM dbo.Component WHERE ComponentName = 'Bezel');

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Add +1 to the existing quantity in each component bin
        UPDATE dbo.InventoryBin
        SET CurrentQuantity = CurrentQuantity + 1,
            LastUpdated = GETDATE()
        WHERE ComponentID IN (@HarnessID, @ReflectorID, @HousingID, @LensID, @BulbID, @BezelID);

        -- Record the +1 added to each bin in RestockHistory
        INSERT INTO dbo.RestockHistory (BinID, QuantityAdded)
        SELECT BinID, 1
        FROM dbo.InventoryBin
        WHERE ComponentID IN (@HarnessID, @ReflectorID, @HousingID, @LensID, @BulbID, @BezelID);

        -- Log replenishment
        SET @ResultMessage = 'Successfully restocked +1 unit to each component bin.';

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        VALUES ('Inventory Replenishment', @ResultMessage);

        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @ResultMessage = 'Error: ' + ERROR_MESSAGE();

        INSERT INTO dbo.OperationLogs (EventType, LogDescription)
        VALUES ('Restock Failure', @ResultMessage);

        RETURN -2;
    END CATCH
Go