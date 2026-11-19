-- Stops the script from running if the Components table already has data
IF NOT EXISTS (SELECT * FROM Components)
INSERT INTO Components (ComponentName, InitialQuantity) VALUES
('Harness', 5),
('Reflecter', 7),
('Lens', 4),
('Housing', 6),
('Bulb', 8),
('Bezel', 9);
-- Now we gotta populate the InventoryBins table with the initial quantities from the Components table
INSERT INTO InventoryBins (ComponentID, CurrentQuantity)
SELECT ComponentID, InitialQuantity FROM Components;