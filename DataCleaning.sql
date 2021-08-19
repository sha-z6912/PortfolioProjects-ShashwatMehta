--1. Converting date and time to short date format

--a
Alter table HouseSales 
add shortdate date;

--b
Update PortfolioProjects..HouseSales
set shortdate=CONVERT(date,SaleDate)

--c
select shortdate
from PortfolioProjects..HouseSales


--2 Populating Property Address

update a
set PropertyAddress = isnull(a.propertyAddress, b.propertyAddress)
from  PortfolioProjects..HouseSales a 
join PortfolioProjects..HouseSales b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.propertyAddress) 
from PortfolioProjects..HouseSales a 
join PortfolioProjects..HouseSales b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]

--3 Spliting PropertyAddress into various columns (Address, City, State)

--a Adding new column to store split addresses
Alter table PortfolioProjects..HouseSales
add PropertySplitAdrress nvarchar(255);

Alter table PortfolioProjects..HouseSales
add PropertySplitCity nvarchar(255);

Alter table PortfolioProjects..HouseSales
add PropertySplitState nvarchar(255);

--b Popupalting the new columns using substring of PropertyAddress
update PortfolioProjects..HouseSales
set PropertySplitAdrress = SUBSTRING(PropertyAddress, 1, (CHARINDEX(',',PropertyAddress)-1))

update PortfolioProjects..HouseSales
set PropertySplitCity = SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1, Len(PropertyAddress))

--Using parsename on OwnerAddress to get the state name

update PortfolioProjects..HouseSales
set PropertySplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select PropertySplitAdrress,PropertySplitCity, PropertySplitState
from PortfolioProjects..HouseSales

--4 Changing Y and N to yes and no in Sold as Vacant

Update PortfolioProjects..HouseSales
set SoldAsVacant = CASE when SoldAsVacant='Y' then 'Yes'
						when SoldAsVacant='N' then 'No'
						else SoldAsVacant
						end

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as Total
from PortfolioProjects..HouseSales
group by SoldAsVacant
order by 2


--5 Removing Duplicates using a CTE

WITH RowNumCTE AS
(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProjects..HouseSales
)
DELETE
from RowNumCTE
where row_num>1


--6 Removing Unused Columns

Alter table PortfolioProjects..HouseSales
drop column PropertyAddress, SaleDate, TaxDistrict, OwnerAddress


