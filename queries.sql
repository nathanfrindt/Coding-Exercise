--1. What are the top 5 brands by receipts scanned for the most recent month?
SELECT Brands.name, COUNT(DISTINCT Receipts._id) AS receipt_count
FROM Brands
JOIN ReceiptItems ON Brands.barcode = ReceiptItems.barcode
JOIN Receipts ON ReceiptItems.receiptId = Receipts._id
WHERE DATE_TRUNC('month', Receipts.dateScanned) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY Brands.name
ORDER BY receipt_count DESC
LIMIT 5;


--2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
WITH CurrentMonthRank AS (
    SELECT Brands.name, COUNT(DISTINCT Receipts._id) AS receipt_count, RANK() OVER (ORDER BY COUNT(DISTINCT Receipts._id) DESC) AS rank
    FROM Brands
    JOIN ReceiptItems ON Brands.barcode = ReceiptItems.barcode
    JOIN Receipts ON ReceiptItems.receiptId = Receipts._id
    WHERE DATE_TRUNC('month', Receipts.dateScanned) = DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY Brands.name
),
PreviousMonthRank AS (
    SELECT Brands.name, COUNT(DISTINCT Receipts._id) AS receipt_count, RANK() OVER (ORDER BY COUNT(DISTINCT Receipts._id) DESC) AS rank
    FROM Brands
    JOIN ReceiptItems ON Brands.barcode = ReceiptItems.barcode
    JOIN Receipts ON ReceiptItems.receiptId = Receipts._id
    WHERE DATE_TRUNC('month', Receipts.dateScanned) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
    GROUP BY Brands.name
)
SELECT cm.name AS current_month_brand, cm.rank AS current_month_rank, pm.rank AS previous_month_rank
FROM CurrentMonthRank cm
LEFT JOIN PreviousMonthRank pm ON cm.name = pm.name
WHERE cm.rank <= 5 OR pm.rank <= 5;


--3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, AVG(totalSpent) AS average_spend
FROM Receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rewardsReceiptStatus;


--4. When considering the total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, SUM(purchasedItemCount) AS total_items
FROM Receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rewardsReceiptStatus;


--5. Which brand has the most spend among users who were created within the past 6 months?
SELECT Brands.name, SUM(ReceiptItems.price * ReceiptItems.quantity) AS total_spend
FROM Brands
JOIN ReceiptItems ON Brands.barcode = ReceiptItems.barcode
JOIN Receipts ON ReceiptItems.receiptId = Receipts._id
JOIN Users ON Receipts.userId = Users._id
WHERE Users.createdDate >= NOW() - INTERVAL '6 months'
GROUP BY Brands.name
ORDER BY total_spend DESC
LIMIT 1;


--6. Which brand has the most transactions among users who were created within the past 6 months?
SELECT Brands.name, COUNT(DISTINCT Receipts._id) AS transaction_count
FROM Brands
JOIN ReceiptItems ON Brands.barcode = ReceiptItems.barcode
JOIN Receipts ON ReceiptItems.receiptId = Receipts._id
JOIN Users ON Receipts.userId = Users._id
WHERE Users.createdDate >= NOW() - INTERVAL '6 months'
GROUP BY Brands.name
ORDER BY transaction_count DESC
LIMIT 1;


