# Exploratory Data Analysis with SQL

In this project, we're going to do Exploratory Data Analysis (EDA) of world's Coivd-19 data (as on 13/06/2021) using MS SQL.


## Authors

- [@venkannarupani](https://github.com/venkannarupani)

  
## Acknowledgements

 - [Coronavirus (COVID-19) Deaths](https://ourworldindata.org/covid-deaths)
  
## Installation 

Install MS SQL server.
    
## Usage/Examples

```javascript
-- Viewing the all the daily infection data of CovidDeaths table for all countries.
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

-- Viewing the all the daily vaccination data of CovidVaccinations table for all countries.
SELECT *
FROM PortfolioProject..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4

```

  
## FAQ

#### What are the steps invovled?

    1. The covid-19 data has been downloaded in .csv file and has been split into two different datasets as below:

        1. CovidDeath
        2. CovidVaccination
        
    2. After splitting the data, the files have been saved as separate excel files.
    3. These two excel files have been uploaded into MS SQL database using SQL Server Import & Export tool.

#### What's the database name?
PortfolioProject

#### How many tables created?

Following two different tables have been created:

    1. CovidDeath
    2. CovidVaccination

  
