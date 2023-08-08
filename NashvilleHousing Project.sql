SELECT*
FROM PortfolioProject..NashvilleHousing;

--STANDARDIZING THE DATE FORMAT:

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing;

SELECT SaleDate, CONVERT(Date, SaleDate) 
FROM PortfolioProject..NashvilleHousing;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDate =  CONVERT(Date, SaleDate);

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

--POPULATE PROPERTY ADDRESS DATA:
--ALSO FINISHED THE DUPLICATION OF PROPERTADDRESS:
--ALSO FINISHING THE NULL VALUES IN PROPERTYADDRESS:

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing;

SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE propertyAddress is  null;


SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID;

SELECT *
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ];

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.propertyaddress is null;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.propertyaddress is null;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.propertyaddress is null;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.propertyaddress is null;

SELECT * FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is null;

--BREAKING OUT ADDRESS INTO DIFFERENT COLOUMS (address, city, state):

SELECT PropertyAddress 
FROM PortfolioProject..NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1);

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress));

SELECT *
FROM PortfolioProject..NashvilleHousing;


SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing;

SELECT
PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 3) 
,PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 2) 
,PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 1) 
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress VARCHAR(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 3);

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity VARCHAR(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 2);

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState VARCHAR(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE (OwnerAddress, ',' , '.'), 1);

SELECT *
FROM PortfolioProject..NashvilleHousing;

--CHANGING Y and N INTO YES and NO IN "SoldAsVacant" COLOUM:

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing;

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
 ELSE SoldAsVacant
 END
FROM PortfolioProject..NashvilleHousing;

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
 ELSE SoldAsVacant
 END;

  --REMOVING DUPLICATES:

 SELECT *
, ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID
					 ) Row_num
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID;

WITH RowNumCTE AS(
 SELECT *
, ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID
					 ) Row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE Row_num>1
ORDER BY PropertyAddress;

--DELETING UNUSED COLOUMS:

SELECT *
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate;
