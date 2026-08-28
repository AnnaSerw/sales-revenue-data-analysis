USE Chinook;
GO

/************************************************
Track Sales Overwiew
************************************************/

SELECT
    UnitsSold,
    COUNT(*) AS NumberOfTracks
FROM (
    SELECT
        t.TrackId,
        COALESCE(SUM(il.Quantity), 0) AS UnitsSold
    FROM Track t
    LEFT JOIN InvoiceLine il
        ON t.TrackId = il.TrackId
    GROUP BY t.TrackId
) AS TrackSales
GROUP BY UnitsSold
ORDER BY UnitsSold;

/***************************************************
TOP 15 Artists by number of track sold
***************************************************/

SELECT TOP 15
    ar.Name AS Artist,
    COUNT(il.InvoiceLineId) AS TracksSold
FROM Artist ar
INNER JOIN Album al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track t
    ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
ORDER BY
    TracksSold DESC;


/*************************************************************************
How many artists have no sales, and what share do they represent overall?
*************************************************************************/

SELECT
    COUNT(*) AS ArtistsWithNoSales,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Artist) AS DECIMAL(5,2)) AS PercentageOfAllArtists
FROM (
    SELECT ar.ArtistId
    FROM Artist ar
    LEFT JOIN Album al
        ON ar.ArtistId = al.ArtistId
    LEFT JOIN Track t
        ON al.AlbumId = t.AlbumId
    LEFT JOIN InvoiceLine il
        ON t.TrackId = il.TrackId
    GROUP BY ar.ArtistId
    HAVING COUNT(il.InvoiceLineId) = 0
) AS UnsoldArtists;

/************************************************************************
List of Artists with No Sales
************************************************************************/

SELECT
    ar.ArtistId,
    ar.Name AS Artist
FROM Artist ar
LEFT JOIN Album al
    ON ar.ArtistId = al.ArtistId
LEFT JOIN Track t
    ON al.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
HAVING COUNT(il.InvoiceLineId) = 0
ORDER BY
    ar.Name;



