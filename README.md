# COVID-19 Data Analysis with SQL

## Overview

This project involves analyzing COVID-19 data using SQL. The datasets used are `CovidDeaths` and `CovidVaccinations` from the `PortfolioProject` database. The goal is to derive meaningful insights about COVID-19 cases, deaths, and vaccination rates across different countries and continents.

## Datasets

### CovidDeaths
- **Columns**: `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths`, `population`, `continent`

### CovidVaccinations
- **Columns**: `location`, `date`, `new_vaccinations`

## Questions Addressed

1. **What are the COVID-19 death rates across different locations?**
   - Query: Calculate the percentage of deaths compared to total cases for each location.

2. **What percentage of the population contracted COVID-19 in different locations?**
   - Query: Calculate the percentage of total cases compared to the population for each location.

3. **Which country has the highest infection rate relative to its population?**
   - Query: Identify the country with the highest percentage of total cases compared to its population.

4. **Which country has the highest death count per population?**
   - Query: Identify the country with the highest death count per population.

5. **Which continent has the highest death rates per population?**
   - Query: Calculate the total deaths and death percentage for each continent.

6. **What is the global death percentage by continent?**
   - Query: Calculate the death percentage for each continent by summing up cases and deaths.

7. **What are the global new cases and deaths rates?**
   - Query: Calculate the new cases and new deaths globally and their respective percentages.

8. **How do vaccination rates compare across different locations and dates?**
   - Query: Join CovidDeaths and CovidVaccinations tables to analyze vaccination data over time.

9. **How does the rolling vaccination percentage change over time by location?**
   - Query: Use a Common Table Expression (CTE) to calculate the rolling count of vaccinations.

10. **How has the infection rate changed over time in different regions?**
    - Query: Create a view to track the rolling count of new cases over time by region.

## Key SQL Queries

### View All Data from CovidDeaths

SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3, 4

### Selecting that data used for this project

SELECT location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1, 2

### Calculate Death Percentage by Location

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Philippines'
ORDER BY 1, 2;

### Calculate Population Infection Percentage

SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT) / population) * 100 AS PopulationPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Philippines'
ORDER BY 1, 2;

### Identify Country with Highest Infection Rate

SELECT location, MAX(total_cases) AS HighestInfectionRate, population, MAX((CAST(total_cases AS FLOAT) / population)) * 100 AS PopulationPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PopulationPercentage DESC;

### Global Death Percentage by Continent

SELECT continent, SUM(CAST(total_cases AS BIGINT)) AS TotalCases, 
SUM(CAST(total_deaths AS BIGINT)) AS TotalDeaths, 
(SUM(CAST(total_deaths AS FLOAT)) / SUM(CAST(total_cases AS FLOAT))) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathPercentage DESC;

## How to use

1. Clone the repository to your local machine.
2. Open your SQL Server Management Studio (SSMS) or any SQL query tool.
3. Execute the SQL scripts provided in this repository.
4. Review the comments within each script for detailed explanations of each query.

## Contribution

Feel free to fork this repository and submit pull requests for any improvements or additional analyses you can think of.
