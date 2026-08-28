USE Chinook;
GO

/*********************************************
How many customers are there in each country?
*********************************************/

SELECT
    Country,
    COUNT(*) AS customer_count
FROM Customer
GROUP BY Country
ORDER BY customer_count DESC;

/*****************************************************
Top 10 Customers with revenue and % of total revenue
*****************************************************/

WITH CustomerRevenue AS (
    SELECT
        c.CustomerId,
        c.FirstName + ' ' + c.LastName + ' - ' + c.Country AS customer_name,
        c.Country,
        SUM(i.Total) AS total_revenue
    FROM Customer c
    INNER JOIN Invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY
        c.CustomerId,
        c.FirstName,
        c.LastName,
        c.Country
),
TotalRevenue AS (
    SELECT SUM(total_revenue) AS overall_revenue
    FROM CustomerRevenue
),
RankedCustomers AS (
    SELECT
        cr.*,
        ROUND(cr.total_revenue / tr.overall_revenue * 100, 2 ) AS revenue_percentage
    FROM CustomerRevenue cr
    CROSS JOIN TotalRevenue tr
)
SELECT TOP 10
    customer_name,
    Country,
    total_revenue,
    revenue_percentage
FROM RankedCustomers
ORDER BY total_revenue DESC;