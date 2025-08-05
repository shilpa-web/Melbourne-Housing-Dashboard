SELECT * FROM housing
LIMIT 10;

# Normalizing Date format
update housing
set  Date_Sold =
  CASE
    -- For format like 'DD/MM/YYYY'
   WHEN LENGTH(Date_Sold) = 10 AND SUBSTRING(Date_Sold, 3, 1) = '/' THEN STR_TO_DATE(Date_Sold, '%d/%m/%Y')
    
    -- For format like 'YYYY-MM-DD'
    WHEN LENGTH(Date_Sold) = 10 AND SUBSTRING(Date_Sold, 5, 1) = '-' THEN STR_TO_DATE(Date_Sold, '%Y-%m-%d')
    

    ELSE NULL
  END;


# Asigning uppercase to fisrt letter of the word+

update housing 
set suburb =
    CONCAT(
        UPPER(SUBSTRING(suburb, 1, 1)),
        LOWER(SUBSTRING(suburb, 2))
    );  
Select Type from housing
;    
Alter table housing 
modify Rooms VARCHAR(255);

# Normalizing Rooms column to numeric value
UPDATE housing
SET Rooms = CASE
    WHEN LOWER(TRIM(Rooms)) = 'One' THEN '1'
    WHEN LOWER(TRIM(Rooms)) = 'Three' THEN '3'
    WHEN LOWER(TRIM(Rooms)) = 'Two' THEN '2'
    WHEN LOWER(TRIM(Rooms)) = 'Four' THEN '4'
    WHEN LOWER(TRIM(Rooms)) = 'Five' THEN '5'
    WHEN LOWER(TRIM(Rooms)) = 'Six' THEN '6'
    WHEN LOWER(TRIM(Rooms)) = 'Seven' THEN '7'
    WHEN LOWER(TRIM(Rooms)) = '' THEN 'null'
    ELSE Rooms
END;

 
# Changing Types of house to full word
Update housing
Set Type = CASE
    WHEN Type = 'h' THEN 'House'
    WHEN Type = 'u' THEN 'Unit'
    WHEN Type = 't' THEN 'Town house'
    ELSE CAST(Type AS UNSIGNED)
  END;

# normalizing price column
Update housing
set Price= 
  CASE
    WHEN Price LIKE '$%k' THEN 
      CAST(REPLACE(REPLACE(price, '$', ''), 'k', '') AS DECIMAL (10,2)) * 1000
    ELSE
      CAST(price AS DECIMAL(10,2))
  END;

select Price from housing;

SHOW COLUMNS FROM housing; 
# DROP unnecessary columns
ALTER TABLE housing 
DROP COLUMN SellerG,
DROP COLUMN Propertycount;

# Normalize Car column
Update housing
set Car =
  CASE
    WHEN Car = 99 THEN 'NA'
    WHEN Car= '' THEN 'NA'
    ELSE 
    CAST(Car AS unsigned)
    END;
    
#  normalizing BuildingArea
update housing set BuildingArea =
  CASE
    WHEN BuildingArea = '' THEN 'NA'
        ELSE 
    CAST(BuildingArea AS signed )
    END;
    
   #Normalize Distance column 
 SELECT 
  CASE
    -- Case 1: Distance contains 'km'
    WHEN Distance LIKE '%km%' THEN 
      CAST(REPLACE(REPLACE(Distance, 'km', ''), ' ', '') AS DECIMAL(10,2))

    -- Case 2: Distance is a number (no letters)
    WHEN Distance REGEXP '^[0-9.]+$' THEN 
      CAST(Distance AS DECIMAL(10,2))

    -- Case 3: Distance is empty or NULL
    WHEN Distance IS NULL OR TRIM(Distance) = '' THEN 'NA'

    -- Default fallback (if any other unexpected format)
    ELSE NULL
  END AS Distance_Cleaned
FROM housing;

select * from housing;
    
    