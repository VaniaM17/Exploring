--Exploring the dataset

Select *
From CovidDataset..coviddeaths
Where continent is not null
order by 3,4

Select Location, date, population, new_cases, total_cases, total_deaths
From CovidDataset..coviddeaths
Where continent is not null
order by 1,2

--Number of deaths vs. cases
--Likelyhood of dying from covid in Norway

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDataset..coviddeaths
Where Location='Norway'
and continent is not null
order by 1,2

--Number of cases vs. population
--Percentage of infected population of Norway

Select Location, date, Population, total_cases, (total_cases/population)*100 as Percentofpopulationinfected
From CovidDataset..coviddeaths
Where Location='Norway'
order by 1,2

--Infection rate in different countries compared to the population

Select Location, Population, MAX(total_cases) as HighestInfectionNumber, MAX((total_cases/population))*100 as Percentpopulationinfected
From CovidDataset..coviddeaths
Group by Location, Population
Order by Percentpopulationinfected desc

--Death counts per population in different countries

Select Location, MAX(cast(Total_deaths as int)) as Totaldeaths
From CovidDataset..coviddeaths
Where continent is not null
Group by Location
order by Totaldeaths desc

--Continents with highest number of deaths

Select continent, MAX(cast(Total_deaths as int)) as Totaldeathcount
From CovidDataset..coviddeaths
Where continent is not null
Group by continent
order by Totaldeathcount desc

--Global death percentage and total deaths

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidDataset..coviddeaths
Where continent is not null
order by 1, 2

--Percentage of population vaccinated with atleast 1 dose in different countries
--Calculating using CTE on 'Partition By'

Select *
From CovidDataset..coviddeaths dth
Join CovidDataset..covidvaccination vac
	On dth.location = vac.location
	and dth.date = vac.date;
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, AggragateVaccinations)
as
(
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dth.location ORDER BY dth.location, dth.date) as AggragateVaccinations
From CovidDataset..coviddeaths dth
Join CovidDataset..covidvaccination vac
	On dth.location = vac.location
	and dth.date = vac.date
Where dth.continent is not null
)
Select*, (AggragateVaccinations/Population)*100
From PopvsVac

--Next step: creating views for visualizing maps in Tableau

--Create View PopvsVacc as
--Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, 
--SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dth.location ORDER BY dth.location, dth.date) as AggragateVaccinations
--From CovidDataset..coviddeaths dth
--Join CovidDataset..covidvaccination vac
--	On dth.location = vac.location
--	and dth.date = vac.date
--Where dth.continent is not null

