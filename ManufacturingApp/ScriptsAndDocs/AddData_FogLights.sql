--This script must be used to configure the database correctly, otherwise the data will not be seeded properly, 
-- especially with the component and bin names, which must be defined here

USE FogLightManufacturing;

-- Stops the script from running if the Components table already has data
IF NOT EXISTS (SELECT * FROM Component)
BEGIN
	INSERT INTO Component (ComponentName) VALUES
	('Harness'),
	('Reflector'),
	('Lens'),
	('Housing'),
	('Bulb'),
	('Bezel');

END

IF NOT EXISTS (SELECT * FROM InventoryBin)
BEGIN

	-- Now we gotta populate each InventoryBin table with the initial quantities provided in assignment instructions
	
	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Harness Bin', 'WarehouseA', 5
		FROM Component
		WHERE ComponentName = 'Harness';


	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Reflector Bin', 'WarehouseB', 7
		FROM Component
		WHERE ComponentName = 'Reflector';


	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Housing Bin', 'WarehouseC', 6
		FROM Component
		WHERE ComponentName = 'Housing';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Lens Bin', 'WarehouseD', 4
		FROM Component
		WHERE ComponentName = 'Lens';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Bulb Bin', 'WarehouseE', 8
		FROM Component
		WHERE ComponentName = 'Bulb';

	INSERT INTO InventoryBin (ComponentID, BinName, BinLocation, CurrentQuantity)
		SELECT ComponentID, 'Bezel Bin', 'WarehouseF', 9
		FROM Component
		WHERE ComponentName = 'Bezel';

	--Since we are stocking our bins for the first time their needs to be a restock history for them as well
	INSERT INTO RestockHistory (BinID, QuantityAdded)
		SELECT BinID, CurrentQuantity
		FROM InventoryBin;

END