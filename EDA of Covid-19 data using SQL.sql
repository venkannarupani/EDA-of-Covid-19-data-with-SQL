-- Project: Exploratory Data Analysis (EDA) of Coronavirus (COVID-19) Deaths world-wide for data as on 13/06/2021

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

-- Viewing total case & deaths on a daily basis from each country
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at Total cases, Total Deaths and Death Rate for each country
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Finding out the deathrate (likelyhood of deaths) in USA
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at Total cases, Total Population and Infection Rate
--Shows what percent of population got Covid-19 on a daily basis countr-wise
SELECT location,date,population, total_cases,(total_cases/population)*100 AS InfectionRate
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Look at countries with highest Infection Rates
SELECT location,population, MAX(total_cases) AS HighestInfected, MAX((total_cases/population))*100 AS PopulationInfectionRate
FROM PortfolioProject..CovidDeaths
GROUP BY location,population
ORDER BY PopulationInfectionRate DESC

--Showing countries with highest deaths country-wise
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeath DESC

--Showing continents with highest deaths and world-wide deaths
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeath DESC


--Overall Global cases, deaths and death rate
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Overall_Death_Rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL

----Overall Global cases, deaths and death rate
--SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Overall_Death_Rate
--FROM PortfolioProject..CovidDeaths
----WHERE location like '%states%'
--WHERE continent IS NOT NULL
----GROUP BY location --,population
----ORDER BY HighestDeath DESC

-- Joing two tables  :CovidDeaths & CovidVaccinations
SELECT *
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date

	-- Looking total vaccinated vs total population
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

-- Rolling count of vaccinations
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVacCount
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

-- Common Table Expression (CTE) : A Common Table Expression, also called as CTE in short form, is a temporary named result set 
-- that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement. The CTE can also be used in a View.

WITH PopVsVac (continent, location, date, population, new_vaccinations,RollingVacCount)
AS
(
	SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVacCount
	FROM PortfolioProject..CovidDeaths cd
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL
)
SELECT *, (RollingVacCount/population)*100 AS VacPercent
FROM PopVsVac

-- Creating a Temporary Table
DROP TABLE IF EXISTS #PeopleVaccinatedPercent
CREATE TABLE #PeopleVaccinatedPercent
(continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingVacCount numeric
)

-- Inserting data into the Temporary Table
INSERT INTO #PeopleVaccinatedPercent
	SELECT cd.continent, cd.location, cd.date, cd.population, CONVERT(INT, cv.new_vaccinations),
	SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVacCount
	FROM PortfolioProject..CovidDeaths cd
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL

-- Viewing the data from Temporary Table
SELECT * , (RollingVacCount/population)*100 AS VacPercent
FROM #PeopleVaccinatedPercent


--Create a View for later use
DROP VIEW IF EXISTS PeopleVaccinatedPercent

CREATE VIEW PeopleVaccinatedPercent AS
	SELECT cd.continent, cd.location, cd.date, cd.population, CONVERT(INT, cv.new_vaccinations) AS new_vaccinations,
	SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVacCount
	FROM PortfolioProject..CovidDeaths cd
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location = cv.location
	AND cd.date = cv.date
	WHERE cd.continent IS NOT NULL

-- Viewing data from the View
SELECT * 
FROM PeopleVaccinatedPercent

-- End of EDA