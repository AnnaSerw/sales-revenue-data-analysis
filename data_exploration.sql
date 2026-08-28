USE Chinook;
GO

-- data base structure
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES

-- data types
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME

-- count customer
SELECT COUNT(*) AS CustomerCount
FROM Customer;
-- select distinct country
SELECT 
DISTINCT Country
FROM Customer;
-- count distinc countries
SELECT COUNT(DISTINCT Country) AS CountriesCount
FROM Customer
-- count artists
SELECT COUNT(*) AS ArtistCount
FROM Artist;
-- count titles
SELECT COUNT(*) AS TrackCount
FROM Track
-- check top 10 Invoice data
SELECT TOP 10 *
FROM Invoice
-- check last 10 InvoiceLine
SELECT TOP 10 *
FROM InvoiceLine
ORDER BY InvoiceLineId DESC

