--Checking for Duplicate RecordsFor each table, you'd want to check if there are any duplicate entries, which could be done by counting the occurrences of unique identifiers.
-- For Users
SELECT _id, COUNT(*) as count
FROM Users
GROUP BY _id
HAVING COUNT(*) > 1;

-- For Receipts
SELECT _id, COUNT(*) as count
FROM Receipts
GROUP BY _id
HAVING COUNT(*) > 1;

-- For Brands
SELECT _id, COUNT(*) as count
FROM Brands
GROUP BY _id
HAVING COUNT(*) > 1;
Identifying Missing Values

--Determine if there are any crucial missing values in the data. For instance, a receipt without a userId or a brand without a barcode could be problematic.

-- Check for missing userIds in Receipts
SELECT COUNT(*)
FROM Receipts
WHERE userId IS NULL;

-- Check for missing barcodes in Brands
SELECT COUNT(*)
FROM Brands
WHERE barcode IS NULL;
Data Consistency Checks

--Ensure that the data types are consistent across the dataset. For example, check that all date fields are in the correct format.
-- Assuming we have loaded the data and want to check date formats (this will depend on the DBMS and its date format checking capabilities)
SELECT _id, createdDate
FROM Users
WHERE NOT (createdDate IS valid date format);
Referential Integrity

--Validate that all foreign keys have a corresponding primary key in their respective referenced tables.
-- Check if all userIds in Receipts exist in Users
SELECT DISTINCT r.userId
FROM Receipts r
LEFT JOIN Users u ON r.userId = u._id
WHERE u._id IS NULL;

-- Check if all barcodes in ReceiptItems exist in Brands
SELECT DISTINCT ri.barcode
FROM ReceiptItems ri
LEFT JOIN Brands b ON ri.barcode = b.barcode
WHERE b.barcode IS NULL;
