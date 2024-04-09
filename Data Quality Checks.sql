-- For the brands.json file:
-- Inconsistent brandCode Values: Some entries have a brandCode value, while others do not. Consistency in this field is crucial for reliable brand identification and analysis.
-- Missing Category Codes: Not all entries have a categoryCode. This omission could affect any categorization or segmentation analysis based on brand data.
-- Use of Placeholder Names: There are entries with names like "test brand @1604946245498", indicating they might be test data or incorrectly entered. This could skew brand-related insights.
-- Duplicate Entries: While not explicitly shown in the snippets, if there are identical barcodes or brand names with different IDs, it would indicate duplicate data entries.

-- For the receipts.json file:
-- Varied rewardsReceiptItemList Structures: The structure of rewardsReceiptItemList varies significantly, with some items missing crucial details like description or itemPrice. This inconsistency can lead to challenges in item-level analysis.
-- Inconsistent userFlagged Fields: Fields like userFlaggedBarcode and userFlaggedNewItem suggest manual intervention or corrections, which might indicate underlying issues with the receipt scanning or processing logic.
-- Receipt Status Consistency: The rewardsReceiptStatus field has various statuses like "FINISHED" or "FLAGGED". It's important to understand the implications of each status and whether they are appropriately applied.
-- Points Earned and Bonus Points Logic: There should be a clear and consistent logic behind fields like bonusPointsEarned and pointsEarned. Any inconsistency here could impact user loyalty and engagement metrics.

-- For the users.json file:
-- Duplicate Entries: There are repeated entries for the same user ID, which suggests duplication in user records. For instance, the user with the ID 5ff1e194b6a9d73a3a9f1052 appears multiple times. This redundancy can lead to inaccurate user counts and skewed data analysis.
-- Consistency in Last Login: While most records have a lastLogin date, not all do. This inconsistency could impact analyses that rely on user engagement or activity metrics.
-- Field Completeness: Not every user record has a lastLogin field, which could be crucial for tracking user activity. The absence of this data could limit the ability to perform user engagement analysis accurately.
-- Active Field: The active field is boolean, which is good for consistency. However, it's essential to verify that this field accurately reflects the user's current status and isn't left stale.
-- SignUpSource: The signUpSource field varies (e.g., "Email," "Google"). It's important to ensure that all possible sources are captured correctly and consistently.



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
