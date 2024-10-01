-- This analysis uses the same data set from the data cleaning project the name is "layoffs" you can find it in the folder. This is the analysis
-- part after the data cleaning
-- Below are three analysis that I did

-- Part 1 I want to look at the rolling total of peole get laid off by month. 

-- I first create an CTE calcuate number of people gets laid off by month, I used windows function to add up the rolling total

-- some insight about this
-- if we order the total_off column ascending we can tell things are getting worse starting 2022, more people getting laid off in 2022-2023 winter time. 
-- there is a big increase of number of people getting laid-off from 2022-12 to 2023-01

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS Total_off
FROM layoff_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC  -- Extract Month from date column and calculate sum  by month
)
SELECT `Month`,
Total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total
FROM Rolling_total; -- Calculate rolling total for layoffs by month

-- Part 2 I would like look at the number of people get laid off by company

-- I first calculate sum of people got laid off in each company by years, this is done by performing the sum total_laid_off 
-- group by company and year
-- I rank the previous part using the windows functionand picked out top five companies who laid off the most people by year. 

-- some insight about this
-- some of the big tech companys laid off a lots of people

WITH company_year AS
(
SELECT 
Company,
YEAR(`date`) AS Years,
SUM(total_laid_off) AS Total_Laid_Off
FROM layoff_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC   -- total layoffs by each company by year
),
Company_Year_Rank AS (
SELECT *,
DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY Ranking ASC)
SELECT * FROM Company_Year_Rank 
WHERE ranking <= 5;  -- rank the layoffs total by year and company and pick the top 5 companies

-- Part 3 I would like to take a look at which industry have the most laid off by years.
-- I first calculate sum of people got laid off in each industry by years, this is done by doing a group by  and sum opeartion by
--  industry and year
-- I rank the previous part and picked out top three industries who laid off the most people by year. This is done by windows dense_rank function

-- some insight about this
-- Looks like Transportation, Consumer and Retail laid off the most people since it appeared in multiple places. 
-- Looks like some the the big tec companies like Google, Amazon and Microsoft laid off the Most people during those time. 

WITH Industry_year AS(
SELECT 
industry AS Industry,
YEAR(`date`) AS Years,
SUM(total_laid_off) AS Total_Laid_Off
FROM layoff_staging2
WHERE industry IS NOT NULL AND total_laid_off IS NOT NULL
GROUP BY industry,YEAR(`date`)   -- Calculate total Laid off for each industry group by year
),
Industry_rank AS(
SELECT *,
DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_year
WHERE years IS NOT NULL
ORDER BY Ranking ASC)
SELECT * FROM Industry_rank WHERE Ranking <=3  -- Rank total number of laid off for each industry by year and pick top 3


