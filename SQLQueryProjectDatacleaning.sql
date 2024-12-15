SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[Sheet1$]

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.Sheet1$

-- Standardize Date format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.Sheet1$
 
 Update Sheet1$
 SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE Sheet1$
Add SaleDateConverted Date;

 Update Sheet1$
 SET SaleDateConverted = CONVERT(Date, SaleDate)

 --Properties 
 SELECT*
FROM PortfolioProject.dbo.Sheet1$
--Where PropertyAddress is null
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Sheet1$ a
JOIN PortfolioProject.dbo.Sheet1$ b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Sheet1$ a
JOIN PortfolioProject.dbo.Sheet1$ b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > b.[UniqueID ]
Where a.PropertyAddress is null

SELECT PropertyAddress
From PortfolioProject.dbo.Sheet1$

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

From PortfolioProject.dbo.Sheet1$

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.Sheet1$



ALTER TABLE Sheet1$
Add PropertySplitAddress Nvarchar(255);

 Update Sheet1$
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

 

ALTER TABLE Sheet1$
Add PropertySplitCity Nvarchar(255);

 Update Sheet1$
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


 SELECT* 
FROM PortfolioProject.dbo.Sheet1$



SELECT OwnerAddress
FROM PortfolioProject.dbo.Sheet1$

-- Separate OwnersAdrress

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM  PortfolioProject.dbo.Sheet1$

SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.Sheet1$;
 

 
ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

 Update Sheet1$
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

 

ALTER TABLE Sheet1$
Add OwnerSplitCity Nvarchar(255);

 Update Sheet1$
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

 
ALTER TABLE Sheet1$
Add OwnerSplitSate Nvarchar(255);

 Update Sheet1$
 SET OwnerSplitSate = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

  SELECT* 
FROM PortfolioProject.dbo.Sheet1$


--Change Y to N Yes to No at Sold as Vacant field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM Sheet1$
Group by SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.Sheet1$


UPDATE Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
       END


	   --Remove duplicates
SELECT *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
					ParcelID
					) AS Row_num

FROM PortfolioProject.dbo.Sheet1$


-- Remove Duplicates



WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
            PropertyAddress,
            SalePrice,
            SaleDate,
            LegalReference
            ORDER BY
                UniqueID
        ) AS row_num
    FROM PortfolioProject.dbo.Sheet1$
)
SELECT * 
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress

--DELETE UNSED COLUMNS

SELECT*
FROM PortfolioProject.dbo.Sheet1$
ALTER TABLE PortfolioProject.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
ALTER TABLE PortfolioProject.dbo.Sheet1$
DROP COLUMN SaleDate