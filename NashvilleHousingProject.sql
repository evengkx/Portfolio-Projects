SELECT * FROM nashvillehousing

-- CHANGING DATE FORMAT

SELECT SaleDate, CONVERT(Date,SaleDate) FROM nashvillehousing

UPDATE nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

SELECT SaleDate FROM nashvillehousing

-- POPULATING PROPERTY ADDRESS DATA

SELECT * 
FROM nashvillehousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM nashvillehousing AS a
JOIN nashvillehousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM nashvillehousing AS a
JOIN nashvillehousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM nashvillehousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

UPDATE nashvillehousing
SET PropertyAddress = REPLACE(PropertyAddress, '"', '')
UPDATE nashvillehousing
SET PropertyAddress = RTRIM(PropertyAddress)
UPDATE nashvillehousing
SET PropertyAddress = LTRIM(PropertyAddress)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM nashvillehousing

ALTER TABLE nashvillehousing
Add PropertySplitAddress nvarchar(255);

UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress))

ALTER TABLE nashvillehousing
Add PropertySplitCity nvarchar(255);

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM nashvillehousing

SELECT OwnerAddress
FROM nashvillehousing

UPDATE nashvillehousing
SET OwnerAddress = REPLACE(OwnerAddress, '"', '')

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM nashvillehousing

ALTER TABLE nashvillehousing
Add OwnerSplitAddress nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE nashvillehousing
Add OwnerSplitCity nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE nashvillehousing
Add OwnerSplitState nvarchar(255);

UPDATE nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT * 
FROM nashvillehousing

-- CHANGING Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant

ALTER TABLE nashvillehousing
ALTER COLUMN SoldAsVacant nvarchar(500)

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = '1' THEN 'Yes'
	WHEN SoldAsVacant = '0' THEN 'No'
	ELSE SoldAsVacant
	END
FROM nashvillehousing

UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = '1' THEN 'Yes'
	WHEN SoldAsVacant = '0' THEN 'No'
	ELSE SoldAsVacant
	END

-- REMOVING DUPLICATES

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) AS row_num
FROM nashvillehousing
)

--DELETE
--FROM RowNumCTE
--WHERE row_num > 1

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- DELETING UNUSED COLUMNS

SELECT *
FROM nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress