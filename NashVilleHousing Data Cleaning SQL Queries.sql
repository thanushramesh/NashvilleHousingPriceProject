/*
Cleaning Data in SQL Queries
*/

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format ( To convert the date format from Date & Time to only Date Format)
SELECT SalesDateConverted
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SalesDateConverted Date;


Update  NashvilleHousing
SET SalesDateConverted = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
Select *
From PortfolioProject.dbo.NashvilleHousing
order by ParcelID
-- First we identify the rows that have the NULL value present in the PropertyAddress Column
Select *
From PortfolioProject.dbo.NashvilleHousing
where propertyaddress is Null
order by ParcelID

--We use Self Join Statement to populate the matching parcelID of the Null value to the Non Null Value
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) As PopulatedAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Updating the table  
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Property Address into Individual Columns (Address, City)

Select 
SUBSTRING ( PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1) as Address , --The SUBSTRING() function extracts some characters from a string.
SUBSTRING ( PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress) ) as AddressCity -- The CHARINDEX() function searches for a substring in a string, and returns the position.
From PortfolioProject.dbo.NashvilleHousing


 --Adding new column to populate the Properties Address
ALTER TABLE NashvilleHousing
ADD PropertyAddress_Split nvarchar(300);

Update  NashvilleHousing
SET PropertyAddress_Split = SUBSTRING ( PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)

--Adding new column to populate the Properties City 
ALTER TABLE NashvilleHousing 
ADD PropertyCity_Split nvarchar(50);

Update  NashvilleHousing
SET PropertyCity_Split = SUBSTRING ( PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress) )

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Splitting the Owner Address into Individual Columns (Address, City, State)
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),   
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),   
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)    
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(50);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(30);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



SELECT distinct SoldAsVacant ,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant =
  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing

)
SELECT *
From RowNumCTE
Where row_num > 1

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


