select *
from housing

-- Standardize Date Format
select SaleDate ,convert(date,SaleDate)
from housing

--update housing
--set Saledate =convert(date,SaleDate)
select SaleDate 
from housing






ALTER TABLE housing
Add SaleDateConverted Date

Update housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select saleDateConverted, CONVERT(Date,SaleDate)
From housing

-- Populate Property Address data
select *
from housing
where PropertyAddress is null
order by ParcelID

select *
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =isnull(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


select PropertyAddress
from housing
--where PropertyAddress is null
--order by ParcelID

--seperating the address,city,state

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',propertyAddress)-1 )as address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(propertyAddress)) as address

from housing

ALTER TABLE housing
Add propAddress nvarchar(250)

Update housing
SET propAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',propertyAddress)-1 )

ALTER TABLE housing
Add propcity nvarchar(250)

Update housing
SET propcity =  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(propertyAddress))
--Seperating owneraddress
select OwnerAddress
from housing

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from housing



ALTER TABLE housing
Add Oaddress nvarchar(250)

Update housing
SET Oaddress = PARSENAME(replace(OwnerAddress,',','.'),3)

ALTER TABLE housing
Add Ocity nvarchar(250)

Update housing
SET Ocity = PARSENAME(replace(OwnerAddress,',','.'),2)

ALTER TABLE housing
Add Ostate  nvarchar(250)

Update housing
SET Ostate = PARSENAME(replace(OwnerAddress,',','.'),1)

--change Y,N to YES,NO on SoldAsVacant
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From housing
Group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant='Y' then 'yes'
       when SoldAsVacant='N' then 'NO'
	   else SoldAsVacant
	   end

from housing

update housing
set SoldAsVacant=case when SoldAsVacant='Y' then 'yes'
       when SoldAsVacant='N' then 'NO'
	   else SoldAsVacant
	   end

-- remove duplicates


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

From housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress




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

From housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--delete unused column

select *
from housing

alter table  housing
drop column Saledate,PropertyAddress,OwnerAddress,TaxDistrict
