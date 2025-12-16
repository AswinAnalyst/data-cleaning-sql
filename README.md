#  SQL Data Cleaning Project

This repository demonstrates a real-world **SQL data cleaning workflow** on a raw dataset of layoffs. The goal is to transform messy, inconsistent raw data into a **clean and analysis-ready dataset** using SQL techniques.

---

## 📂 Repository Contents

| File | Description |
|------|-------------|
| `Data Cleaning.sql` | SQL script showing step-by-step data cleaning operations on the `layoffs` dataset |
| `README.md` | Project documentation |

---

## 🚀 Project Overview

Data rarely comes in a perfect form for analysis. This project shows how to clean and standardize messy raw data inside a database using SQL statements. The SQL script walks through a series of common data-cleaning tasks including:

- Creating staging tables  
- Removing duplicate records  
- Standardizing text fields  
- Converting date formats  
- Handling null and blank values  
- Removing irrelevant rows and columns  

---

## 🧠 Why This Project?

Data cleaning is a **critical first step** in data analytics. Poor-quality data can lead to incorrect insights and bad business decisions. This project focuses on solving common real-world data quality problems using **pure SQL**, making it ideal for data analysts and SQL learners.

---

## 🛠️ Tools & Technologies

- **SQL (MySQL syntax)**
- Window functions (`ROW_NUMBER`)
- String functions (`TRIM`)
- Date functions (`STR_TO_DATE`)
- Data manipulation statements (`UPDATE`, `DELETE`, `ALTER TABLE`)

---

## 🧩 Dataset Description

The project uses a dataset named **`layoffs`**, which contains information about company layoffs.

To ensure data safety:
- A **staging table** (`layoffs_staging`) is created from the original dataset.
- A second cleaned table (`layoffs_staging2`) is generated after removing duplicates and fixing inconsistencies.

---

## 📜 Data Cleaning Steps

### 1️⃣ Create Staging Tables


CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging
SELECT * FROM layoffs;
Creates a working copy of the raw data to avoid modifying the original table.

2️⃣ Identify & Remove Duplicates
Duplicates are detected using a window function:

```sql

ROW_NUMBER() OVER (
  PARTITION BY company, location, industry, total_laid_off,
  percentage_laid_off, date, stage, country, funds_raised_millions
)
Only one unique record is retained for each duplicate group.

3️⃣ Standardize Text Data
Examples:

Remove extra spaces from company names

Normalize industry values (e.g., Crypto% → Crypto)

Standardize country names

sql
UPDATE layoffs_staging2
SET company = TRIM(company);
4️⃣ Convert Date Formats
Dates stored as text are converted to SQL DATE format:

sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
This enables time-based analysis.

5️⃣ Handle Null & Blank Values
Replace invalid text values with NULL

Remove rows where critical fields are missing

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
6️⃣ Final Cleanup
Temporary or helper columns (like row numbers) are dropped to finalize the cleaned dataset.

▶️ How to Run the Project
Clone the repository:

git clone https://github.com/AswinAnalyst/data-cleaning-sql.git
Open your SQL client (MySQL / Workbench / DBeaver)

Load and execute Data Cleaning.sql step by step

Review the cleaned table: layoffs_staging2

📈 Future Enhancements
Perform Exploratory Data Analysis (EDA)
Create visualizations using Power BI or Tableau
Load cleaned data into Python for deeper analysis
Build dashboards and reports

📝 Key Takeaways
Data cleaning is essential before analysis
SQL alone is powerful enough to clean complex datasets
Using staging tables ensures data safety and reproducibility
Using staging tables ensures data safety and reproducibility

