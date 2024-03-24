--Cleaning Data


--Standardizing Date

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject2..NashvilleHousingData

UPDATE NashvilleHousingData
SET SaleDate=CONVERT(Date,SaleDate)

--Property Address
SELECT *
FROM PortfolioProject2..NashvilleHousingData
--where PropertyAddress is null
order by ParcelID

SELECT NASH1.ParcelID, NASH1.PropertyAddress,NASH2.ParcelID, NASH2.PropertyAddress, ISNULL(NASH1.PropertyAddress,NASH2.PropertyAddress) 
FROM PortfolioProject2..NashvilleHousingData AS NASH1
JOIN PortfolioProject2..NashvilleHousingData AS NASH2
    ON  NASH1.ParcelID = NASH2.ParcelID
	AND NASH1.[UniqueID ]<>NASH2.[UniqueID ]
WHERE NASH1.PropertyAddress IS NULL

UPDATE NASH1 
SET PropertyAddress = ISNULL(NASH1.PropertyAddress,NASH2.PropertyAddress)  
FROM PortfolioProject2..NashvilleHousingData AS NASH1
JOIN PortfolioProject2..NashvilleHousingData AS NASH2
    ON  NASH1.ParcelID = NASH2.ParcelID
	AND NASH1.[UniqueID ]<>NASH2.[UniqueID ]
WHERE NASH1.PropertyAddress IS NULL

--Breaking out Address into Individual columns(Address, city, state)

SELECT PropertyAddress
FROM PortfolioProject2..NashvilleHousingData
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as address 
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))as Address
FROM PortfolioProject2..NashvilleHousingData

ALTER TABLE NashvilleHousingData
Add PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousingData
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousingData
Add PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousingData
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) 

SELECT*
from PortfolioProject2..NashvilleHousingData


SELECT OwnerAddress
from PortfolioProject2..NashvilleHousingData

Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject2..NashvilleHousingData

ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousingData
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousingData
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousingData
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

select*
from PortfolioProject2..NashvilleHousingData

--Change Y and N to YES and NO in 'sold as vacant' field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject2..NashvilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject2..NashvilleHousingData

UPDATE NashvilleHousingData
SET SoldAsVacant=CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

	  --REMOVING DUPLICATE
WITH RowNumCTE as (
SELECT*,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY UniqueID
			   )row_num
from PortfolioProject2..NashvilleHousingData
--order by ParcelID
)


DELETE
from RowNumCTE
where row_num>1
--order by PropertyAddress

--DELETE UNUSED COLUMN

select*
from PortfolioProject2..NashvilleHousingData
ALTER TABLE PortfolioProject2..NashvilleHousingData
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress