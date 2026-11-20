
Use FogLightManufacturing;
Go;
Create or Alter Procedure dbo.Restock
As
BEGIN

	-- Now we gotta populate each InventoryBin table with the initial quantities provided in assignment instructions
	
	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Harness Bin', 'WarehouseA', 1
		FROM Component
		WHERE ComponentName = 'Harness';


	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Reflector Bin', 'WarehouseB', 1
		FROM Component
		WHERE ComponentName = 'Reflector';


	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Housing Bin', 'WarehouseC', 1
		FROM Component
		WHERE ComponentName = 'Housing';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Lens Bin', 'WarehouseD', 1
		FROM Component
		WHERE ComponentName = 'Lens';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Bulb Bin', 'WarehouseE', 1
		FROM Component
		WHERE ComponentName = 'Bulb';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Bezel Bin', 'WarehouseF', 1
		FROM Component
		WHERE ComponentName = 'Bezel';
		
		INSERT INTO RestockHistory (BinID, QuantityAdded)
		SELECT BinID, CurrentQuantity
		FROM InventoryBin;
END