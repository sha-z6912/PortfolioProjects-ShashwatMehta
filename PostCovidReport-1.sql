-- Selecting data that we're going to work on

Select  Location, date, total_cases, new_cases, total_deaths, population
From [PostCovidReport ]..CovidDeaths$
Order by 1,2

--Total Cases vs Total Deaths

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage 
From [PostCovidReport ]..CovidDeaths$
where location like '%india%'
Order by 1,2

--Total Cases vs Population

Select location, date, total_cases,population, (total_cases/population)*100 as infection_rate 
From [PostCovidReport ]..CovidDeaths$
where location like '%india%'
Order by 1,2


--Countries with highest infection rate

Select location, population, MAX(total_cases) as MaxCases,MAX((total_deaths/total_cases))*100 as MaxInfectionPercentage 
From [PostCovidReport ]..CovidDeaths$
Group by location, population
Order by MaxInfectionPercentage desc

--Countries wiht highest death count

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PostCovidReport ]..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--Continents with highest death count 

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PostCovidReport ]..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Death Percentage
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage 
from [PostCovidReport ]..CovidDeaths$
where continent is not null
group by date
order by 1,2


--Total Vaccinations accross all countries

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from [PostCovidReport ]..CovidDeaths$ dea
join [PostCovidReport ]..CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

-- Percecnt of population vaccinated using CTE

with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, TotalVaccinations)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from [PostCovidReport ]..CovidDeaths$ dea
join [PostCovidReport ]..CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--AND dea.location like '%india%'
)
Select *,(TotalVaccinations/Population)*100 as PercentVaccinated
from PopVsVac


--TEMP TABLE 

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continet nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalVaccinations numeric
)

Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from [PostCovidReport ]..CovidDeaths$ dea
join [PostCovidReport ]..CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--AND dea.location like '%india%'
Select *,(TotalVaccinations/Population)*100 as PercentVaccinated
from #PercentPopulationVaccinated


--Views for data visualizations 

Create View PercentVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from [PostCovidReport ]..CovidDeaths$ dea
join [PostCovidReport ]..CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

