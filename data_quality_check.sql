USE Chinook;
GO
/**************************************************
data quality check: completness column by column
**************************************************/
SELECT
    'Customer.CustomerId' AS column_name,
    COUNT(*) AS null_counted
FROM Customer
WHERE CustomerId IS NULL

UNION ALL

SELECT
    'Customer.Country',
    COUNT(*)
FROM Customer
WHERE CustomerId IS NULL

UNION ALL

SELECT
    'Invoice.InvoiceId',
    COUNT(*)
FROM Invoice
WHERE InvoiceId IS NULL

UNION ALL

SELECT
    'Invoice.CustomerId',
    COUNT(*)
FROM Invoice
WHERE CustomerId IS NULL

Union ALL

SELECT
    'Invoice.BillingCountry',
    COUNT(*)
FROM Invoice
WHERE InvoiceId IS NULL

UNION ALL

SELECT
    'Invoice.Total',
    COUNT(*)
FROM Invoice
WHERE InvoiceId IS NULL

UNION ALL


SELECT
    'InvoiceLine.InvoiceLineId',
    COUNT(*)
FROM InvoiceLine
WHERE InvoiceLineId IS NULL

UNION ALL

SELECT
    'InvoiceLine.InvoiceId',
    COUNT(*)
FROM InvoiceLine
WHERE InvoiceId IS NULL

UNION ALL

SELECT
    'InvoiceLine.TrackId',
    COUNT(*)
FROM InvoiceLine
WHERE TrackId IS NULL

UNION ALL

SELECT
    'InvoiceLine.UnitPrice',
    COUNT(*)
FROM InvoiceLine
WHERE UnitPrice IS NULL

UNION ALL

SELECT
    'InvoiceLine.Quantity',
    COUNT(*)
FROM InvoiceLine
WHERE Quantity IS NULL

UNION ALL

SELECT
    'Track.TrackId',
    COUNT(*)
FROM Track
WHERE UnitPrice IS NULL

UNION ALL

SELECT
    'Track.Name',
    COUNT(*)
FROM Track
WHERE UnitPrice IS NULL

/**********************************************************
data quality check if there are null in selected tables
**********************************************************/

-- CUSTOMER
SELECT
    'Customer' AS table_name,
    COUNT(*) - COUNT(CustomerId) AS CustomerId_NULL,
    COUNT(*) - COUNT(FirstName) AS FirstName_NULL,
    COUNT(*) - COUNT(LastName) AS LastName_NULL,
    COUNT(*) - COUNT(Company) AS Company_NULL,
    COUNT(*) - COUNT(Address) AS Address_NULL,
    COUNT(*) - COUNT(City) AS City_NULL,
    COUNT(*) - COUNT(State) AS State_NULL,
    COUNT(*) - COUNT(Country) AS Country_NULL,
    COUNT(*) - COUNT(PostalCode) AS PostalCode_NULL,
    COUNT(*) - COUNT(Phone) AS Phone_NULL,
    COUNT(*) - COUNT(Fax) AS Fax_NULL,
    COUNT(*) - COUNT(Email) AS Email_NULL,
    COUNT(*) - COUNT(SupportRepId) AS SupportRepId_NULL
FROM Customer;

-- INVOICE
SELECT
    'Invoice' AS table_name,
    COUNT(*) - COUNT(InvoiceId) AS InvoiceId_NULL,
    COUNT(*) - COUNT(CustomerId) AS CustomerId_NULL,
    COUNT(*) - COUNT(InvoiceDate) AS InvoiceDate_NULL,
    COUNT(*) - COUNT(BillingAddress) AS BillingAddress_NULL,
    COUNT(*) - COUNT(BillingCity) AS BillingCity_NULL,
    COUNT(*) - COUNT(BillingState) AS BillingState_NULL,
    COUNT(*) - COUNT(BillingCountry) AS BillingCountry_NULL,
    COUNT(*) - COUNT(BillingPostalCode) AS BillingPostalCode_NULL,
    COUNT(*) - COUNT(Total) AS Total_NULL
FROM Invoice;

-- INVOICE LINE
SELECT
    'InvoiceLine' AS table_name,
    COUNT(*) - COUNT(InvoiceLineId) AS InvoiceLineId_NULL,
    COUNT(*) - COUNT(InvoiceId) AS InvoiceId_NULL,
    COUNT(*) - COUNT(TrackId) AS TrackId_NULL,
    COUNT(*) - COUNT(UnitPrice) AS UnitPrice_NULL,
    COUNT(*) - COUNT(Quantity) AS Quantity_NULL
FROM InvoiceLine;

-- TRACK
SELECT
    'Track' AS table_name,
    COUNT(*) - COUNT(TrackId) AS TrackId_NULL,
    COUNT(*) - COUNT(Name) AS Name_NULL,
    COUNT(*) - COUNT(AlbumId) AS AlbumId_NULL,
    COUNT(*) - COUNT(MediaTypeId) AS MediaTypeId_NULL,
    COUNT(*) - COUNT(GenreId) AS GenreId_NULL,
    COUNT(*) - COUNT(Composer) AS Composer_NULL,
    COUNT(*) - COUNT(Milliseconds) AS Milliseconds_NULL,
    COUNT(*) - COUNT(Bytes) AS Bytes_NULL,
    COUNT(*) - COUNT(UnitPrice) AS UnitPrice_NULL
FROM Track;

-- ALBUM
SELECT
    'Album' AS table_name,
    COUNT(*) - COUNT(AlbumId) AS AlbumId_NULL,
    COUNT(*) - COUNT(Title) AS Title_NULL,
    COUNT(*) - COUNT(ArtistId) AS ArtistId_NULL
FROM Album;

-- ARTIST
SELECT
    'Artist' AS table_name,
    COUNT(*) - COUNT(ArtistId) AS ArtistId_NULL,
    COUNT(*) - COUNT(Name) AS Name_NULL
FROM Artist;

/****************************************************
Check date range
****************************************************/
SELECT
    MIN(InvoiceDate) AS first_invoice,
    MAX(InvoiceDate) AS last_invoice
FROM Invoice;

/******************************************************
Uniqueness -- the empty result means no duplicates
******************************************************/

--Customer
SELECT
CustomerId,
COUNT(*) AS count_rows
FROM Customer
GROUP BY CustomerId
HAVING COUNT(*) > 1

--Invoice
SELECT
InvoiceID,
COUNT(*) AS count_rows
FROM Invoice
GROUP BY InvoiceId
HAVING COUNT(*) > 1

--InvoiceLine
SELECT
InvoiceLineID,
COUNT(*) AS count_rows
FROM InvoiceLine
GROUP BY InvoiceLineId
HAVING COUNT(*) > 1

--Track
SELECT
TrackID,
COUNT(*) AS count_rows
FROM Track
GROUP BY TrackId
HAVING COUNT(*) > 1

--Album
SELECT
AlbumID,
COUNT(*) AS count_rows
FROM Album
GROUP BY AlbumId
HAVING COUNT(*) > 1

--Artist
SELECT
ArtistID,
COUNT(*) AS count_rows
FROM Artist
GROUP BY ArtistId
HAVING COUNT(*) > 1

/*******************************************
Validity
*******************************************/

-- Total can't be nagative
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS data_quality_check
FROM Invoice
WHERE Total < 0;

/******************************************
Revenue reconcillation
******************************************/
SELECT
    i.InvoiceId,
    i.Total AS invoice_total,
    SUM(il.UnitPrice * il.Quantity) AS calculated_total,
    i.Total - SUM(il.UnitPrice * il.Quantity) AS difference
FROM Invoice i
INNER JOIN InvoiceLine il
    ON i.InvoiceId = il.InvoiceId
GROUP BY
    i.InvoiceId,
    i.Total
HAVING ABS(
    i.Total - SUM(il.UnitPrice * il.Quantity)
) > 0.01;
