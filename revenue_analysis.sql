USE Chinook;
GO

/*******************************************************
How did total revenue change month by month?
*******************************************************/

SELECT
    FORMAT(InvoiceDate, 'yyyy-MM') AS sales_month,
    YEAR(InvoiceDate) * 100 + MONTH(InvoiceDate) AS month_sort,
    SUM(Total) AS total_revenue
FROM Invoice
GROUP BY
    FORMAT(InvoiceDate, 'yyyy-MM'),
    YEAR(InvoiceDate) * 100 + MONTH(InvoiceDate)
ORDER BY month_sort;

/*******************************************************
How did the average invoice value change across years?
*******************************************************/

SELECT
    YEAR(InvoiceDate) AS sales_year,
    AVG(Total) AS average_invoice_value
FROM Invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY sales_year;

/*******************************************************
Which 10 country generates the highest revenue?
*******************************************************/
WITH TopCountries AS (
    SELECT TOP 10
        c.Country
    FROM Customer c
    JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY c.Country
    ORDER BY SUM(i.Total) DESC
)
SELECT
    c.Country,
    YEAR(i.InvoiceDate) AS sales_year,
    SUM(i.Total) AS total_revenue
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
JOIN TopCountries tc
    ON c.Country = tc.Country
GROUP BY
    c.Country,
    YEAR(i.InvoiceDate)
ORDER BY
    sales_year,
    total_revenue DESC;
