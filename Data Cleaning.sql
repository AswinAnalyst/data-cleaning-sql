SELECT * FROM world_layoffs.layoffs_staging;

USE world_layoffs;

SELECT * FROM layoffs_staging;


-- DATA CLEANING


SELECT * FROM layoffs;


-- 1. Remove the duplicates
-- 2. Standardize the data(this means if there are issues with the data with spelling standardize it)
-- 3. look at the null value or blank values
-- 4. remove any column or rows (you have column completely irrelavant and completely blank you can rid of it and save your time)


 
CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;

-- We have only the column name here lets insert the data in to the table

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,date) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
 SELECT *
 FROM duplicate_cte
 WHERE row_num>1;
 
 SELECT *
 FROM layoffs_staging
 WHERE company = 'Casper';
 
 
 WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
 DELETE
 FROM duplicate_cte
 WHERE row_num>1;
 -- you can't delete or update a CTE 
 
 CREATE TABLE `layoffs_staging2` (
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
FROM layoffs_staging2;

INSERT layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT*
FROM layoffs_staging2
WHERE row_num>1;

SELECT*
FROM layoffs_staging2;


-- Standardizing Data(finding issue in your data and then fixing it)

SELECT *
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

 UPDATE layoffs_staging2
 SET company=TRIM(company);
 
 SELECT distinct(industry)
 FROM layoffs_staging2
 ORDER BY industry;
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%';
 
 UPDATE layoffs_staging2
 SET industry='Crypto'
 WHERE industry LIKE 'Crypto%';
 
 SELECT DISTINCT(country)
 FROM layoffs_staging2
 ORDER BY 1;
 
 SELECT *
 FROM layoffs_staging2
 WHERE country LIKE 'United States';
 
 UPDATE layoffs_staging2
 SET country='United States'
 WHERE country LIKE 'United States%';
 
 -- More advanced method for doing this
 
 SELECT DISTINCT(country),TRIM(TRAILING '.' FROM country)
 FROM layoffs_staging2
 ORDER BY 1;
 
 UPDATE layoffs_staging2
 SET country=TRIM(TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';
 
 -- if we want to do a time series exploratory data analysis series visualization later on this need to be change right now
 -- the date column is text column thats not good if we're trying to do time sereis we want to change this to a date column.
 
 SELECT `date`,
 STR_TO_DATE(`date`,'%m/%d/%Y')    
 FROM layoffs_staging2;
 
 -- this is taking the format at the date column and coverting it to the date format.so this is the standard date format in sql.

 UPDATE layoffs_staging2
 SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');
 
 SELECT *
 FROM layoffs_staging2;
 
 ALTER TABLE
 layoffs_staging2
 MODIFY COLUMN `date` DATE;

-- 3. work with null and blank value

SELECT *
FROM layoffs_staging2; 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='NULL';

-- These are fairly useless and it will look at the step 4

SELECT DISTINCT industry
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry ='';

SELECT *
FROM layoffs_staging2
WHERE company='Carvana';


SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company=t2.company
WHERE(t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL 
AND t2.industry is NOT NULL;    

 -- this is not working here the industry column is blank.It's only work with null and we want to convert it to nulls.

-- 4. Remove any column or rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;

-- here the total_laid_off and per_laid_off we cant populate data in this column because we dont have a total emp or total column.