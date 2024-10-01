CREATE DATABASE IF NOT EXISTS world_layoffs;
USE world_layoffs;
-- import raw dataset layoffs in the table data import wizard

SELECT *
FROM layoffs;
-- Data cleaning processs is crutial to extract useful data in the future
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blank Values
-- 4. Remove Any Columns

-- Create table same as layoff so it does not affect raw data

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

INSERT layoff_staging
SELECT *
FROM layoffs;

-- Try to find duplicate by using windows function partion by columns to identify unique values
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY 
company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions
) AS row_num
FROM layoff_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;


-- Create another table same as layoff_staging1 and do change on this table

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoff_staging2;
INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY 
company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions
) AS row_num
FROM layoff_staging;

-- Delete everything from Layoff_staging2 Where row number is not 1 so only unique value remains

DELETE FROM
layoff_staging2
WHERE row_num >1;

SELECT * FROM
layoff_staging2;

-- Standardizing Data 
-- remvoe any white space before and after company name using TRIM() Function

SELECT company FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);

-- take look at the industries see if they are the same, Using LIKE operator to find the indutires that are similar so
-- we can put those industries under the same name

SELECT DISTINCT industry FROM
layoff_staging2
ORDER BY 1;

SELECT * FROM
layoff_staging2
WHERE industry LIKE 'Crypto%';

-- update industry name to make them to same

UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Scan through Location, location seems good

SELECT DISTINCT location FROM
layoff_staging2
ORDER BY 1;

-- Scan through country, there is a period after United State, make the value not unique
-- Trim the period using TRIM function

SELECT DISTINCT country FROM
layoff_staging2
ORDER BY 1;
-- Trim the period after United State
UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Change date type from text to date type formate using STR_TO_DATE operation

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- Change data type of date column to date

ALTER TABLE layoff_staging2
MODIFY COLUMN `date`DATE;

-- Try to update the industry for null value industry

UPDATE layoff_staging2
SET industry = NULL
WHERE industry =  '';

-- Here I'm trying to look at companies that are missing their industry field. The same company might have the industry field in our record
-- I'm updating the industry field by using self-join and update the industry name on pre-existing record

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
		ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;        

-- DELETE THE rows where total_laid_off is null and percentage_laid_off is null, we can always retrive our data from our other tables if we need them. 

DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Drop the column containing row number
ALTER TABLE layoff_staging2
DROP COLUMN row_num
