# NashvilleHousingPriceProject
In this Data Cleaning Project I learnt about the following :   

1) Using the 'CONVERT' function to correct the value of the data type.

2) We populate the Property Address Data, by first identifying the rows that have NULL Values present in the PropertyAddress Column.
   Then by using the SELF JOIN to populate the matching parcelID of the Null value to the Non Null Value. 
  
3) Splitting the Values of Property Address column into individual columns -> (Address, City) using the SUBSTRING and CHARINDEX function.

4) Removing duplicate values by Using the ROW_NUMBER(), OVER AND PARTITION BY CLAUSE  and deleting unwanted data  
 
