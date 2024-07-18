SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3, 4


--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3, 4


-- selecting the data that we are going to use


SELECT location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1, 2


--Looking at Total Cases vs Total Deaths
--GOAL: Shows how fatal is the COVID-19


Select location, date, total_cases, total_deaths, (CAST(total_deaths as FLOAT) /total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'Philippines'
order by 1, 2


--Looking at Total Cases vs Population
--Shows the percentage of population who contracted COVID-19


Select location, date, total_cases, population, (CAST(total_cases as FLOAT) /population)*100 as PopulationPercentage
from PortfolioProject..CovidDeaths
where location like 'Philippines'
order by 1, 2


-- which country has the highest infection rate compared to its population


Select location, MAX(total_cases) as HighestInfectionRate, population, MAX((CAST(total_cases as FLOAT) /population))*100 as PopulationPercentage
from PortfolioProject..CovidDeaths
group by location, Population
order by PopulationPercentage desc


-- which country has the highest death count per population


Select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
group by location
order by TotalDeathCount desc


-- BREAKING DOWN BY CONTINENT
-- Showing the continents with the highest death rates per population
--If you want to look at queries in a global view, you can simply add the query 'where continent is not null' on the queries above
--Make sure to replace the group by function and select statement with continent instead of the location.


Select continent, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
group by continent
order by TotalDeathCount desc


---example of showing the deathpercentage IN GLOBAL NUMBERS

--(this query was used above):
--Looking at Total Cases vs Total Deaths
--GOAL: Shows how fatal is the COVID-19

-- PREVIOUSLY: select location, date, total_cases, total_deaths, (CAST(total_deaths as FLOAT) /total_cases)*100 as DeathPercentage
Select continent, SUM(cast(total_cases as bigint)) as TotalCases, 
SUM(cast(total_deaths as bigint)) as TotalDeaths, 
(SUM(CAST(total_deaths AS FLOAT)) / SUM(cast(total_cases AS FLOAT))) * 100 as DeathPercentage
-- I have to use bigint datatype so SQL can show the output properly without any error
from PortfolioProject..CovidDeaths
where continent is not null
-- PREVIOUSLY: where location like 'Philippines'
group by continent
order by DeathPercentage desc


--ANOTHER GLOBAL NUMBERS on new deaths and new cases


Select SUM(new_cases) as total_cases, sum(new_deaths) as total_deaths,
	sum(cast(new_deaths as float)) / sum(new_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by continent
order by 1, 2


--JOINING TABLES FOR CovidDeaths and CovidVaccinations


SELECT *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date


-- Total Population vs Total Vaccinations
--roll counting of people taking vaccinations  per location and date


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as roll_count_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2, 3


--USE CTE
--GOAL is: to check the roll count percentage of the population taking vaccines per date and location
-- so for you to use the roll_count_vaccinations column, use CTEs.


With PopsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as

(

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as roll_count_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3

)

SELECT *, (cast(RollingPeopleVaccinated as float)/Population) * 100 as RollPeopleVacPercentage
FROM PopsVac


--TEMP TABLES


drop table if exists #PercentPopulationVaccinated --very important when creating and re-creating temp tables for edits on the table
Create table #PercentPopulationVaccinated

(

Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated bigint

)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as roll_count_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3

SELECT *, (cast(RollingPeopleVaccinated as float)/Population)*100 as RollingPercentage
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations
-- How does the people on different regions gets vaccinated over time?


Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as roll_count_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3


---View # 2
-- How does the infection rate changed over time in different regions?


Create view InfectionRate as
SELECT dea.continent, dea.location, dea.date, dea.population, dea.new_cases,
	SUM(dea.new_cases) over (partition by dea.location order by dea.location, dea.date) as roll_count_cases
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2, 3