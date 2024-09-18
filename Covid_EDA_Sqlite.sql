-- Table of covid cases and deaths by countrie and date
SELECT location, date, total_cases, total_deaths, 
round((CAST(total_deaths AS REAL)*100/CAST(total_cases AS REAL)),6) AS death_rate FROM covid_data
ORDER BY location, date


-- Total cases vs Total deaths by countrie (01/20 - 08/24)
SELECT location, max(total_cases) as entire_cases, max(total_deaths) as entire_deaths, 
round((CAST(max(total_deaths) AS REAL)*100/CAST(max(total_cases) AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY location, date

-- Total cases vs Total deaths by countrie (01/20 - 12/20)
SELECT location, max(total_cases) as entire_cases, max(total_deaths) as entire_deaths, 
round((CAST(max(total_deaths) AS REAL)*100/CAST(max(total_cases) AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL AND date LIKE "2020%"
GROUP BY location
ORDER BY location

-- Total cases vs Total deaths by countrie and month (01/20 - 12/20)
SELECT location, MAX(date) AS last_day_of_month, total_cases, total_deaths, 
round((CAST(total_deaths AS REAL)*100/CAST(total_cases AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL AND strftime("%Y-%m", date) BETWEEN "2020-01" AND "2020-12"
GROUP BY location, strftime("%Y-%m", date)
ORDER BY location, last_day_of_month

-- Countries with the highes infection rate compared to population (01/20 - 12/20)
SELECT location, max(total_cases) as entire_cases, population, 
round((CAST(max(total_cases) AS REAL)*100/CAST(max(population) AS REAL)),6) AS infection_rate FROM covid_data
WHERE continent IS NOT NULL AND date LIKE "2020%"
GROUP BY location
ORDER BY infection_rate DESC

-- Countries with the highest death rate compared to population (01/20 - 12/20)
SELECT location, max(total_deaths) as entire_deaths, population, 
round((CAST(max(total_deaths) AS REAL)*100/CAST(max(population) AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL AND date LIKE "2020%"
GROUP BY location
ORDER BY death_rate DESC

-- Total cases vs Total deaths by countrie (01/21 - 12/21)
SELECT location, max(total_cases) as entire_cases, max(total_deaths) as entire_deaths, 
round((CAST(max(total_deaths) AS REAL)*100/CAST(max(total_cases) AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL AND date LIKE "2021%"
GROUP BY location
ORDER BY location

-- Total cases vs Total deaths by countrie (01/22 - 12/22)
SELECT location, max(total_cases) as entire_cases, max(total_deaths) as entire_deaths, 
round((CAST(max(total_deaths) AS REAL)*100/CAST(max(total_cases) AS REAL)),6) AS death_rate FROM covid_data
WHERE continent IS NOT NULL AND date LIKE "2022%"
GROUP BY location
ORDER BY location


-- Global numbers by date
SELECT date, sum(total_cases) as entire_cases, sum(total_deaths) as entire_deaths FROM covid_data
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date


-- Creating a CTE
WITH PopvsVac AS (
SELECT continent, location, date, population, total_vaccinations, new_vaccinations,
SUM(new_vaccinations) OVER(PARTITION BY location ORDER BY location, date) as new_vaccinations_aggregate FROM covid_data
WHERE continent IS NOT NULL
ORDER BY location, date
)
SELECT *, 
CAST(total_vaccinations AS REAL)*100/CAST(population AS REAL) vaccination_rate FROM PopvsVac

-- Creating a VIEW
CREATE VIEW PopvsVacView AS
SELECT continent, location, date, population, total_vaccinations, new_vaccinations,
SUM(new_vaccinations) OVER(PARTITION BY location ORDER BY location, date) as new_vaccinations_aggregate FROM covid_data
WHERE continent IS NOT NULL
ORDER BY location, date

SELECT *, 
CAST(total_vaccinations AS REAL)*100/CAST(population AS REAL) vaccination_rate FROM PopvsVacView