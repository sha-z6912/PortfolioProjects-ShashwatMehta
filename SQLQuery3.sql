Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [PostCovidReport ]..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [PostCovidReport ]..CovidDeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc




Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PostCovidReport ]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc





Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [PostCovidReport ]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



/*alter table [PostCovidReport ]..CovidVaccinations$ 
add total numeric;

update [PostCovidReport ]..CovidVaccinations$
set total = new_vaccinations where new_vaccinations is not null

update [PostCovidReport ]..CovidVaccinations$
set total = 0 where new_vaccinations is null

select total 
from [PostCovidReport ]..CovidVaccinations$
*/

--5
Select location, SUM(total) as TotalVaccinated
From [PostCovidReport ]..CovidVaccinations$
Where continent is null 
and new_vaccinations is not null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalVaccinated desc

--6
Select SUM(total) as total_vaccinated, Max(population) as World_population, (Sum(total)/Sum(population))*100 as Percent_vaccinated
From [PostCovidReport ]..CovidVaccinations$ a
join [PostCovidReport ]..CovidDeaths$ b
	on a.location=b.location
	and a.date = b.date 
where a.location is not null 
order by 1,2

/*
Select a.Location, Population, sum(total) as TotalVaccinated,  Max((total/population))*100 as PercentVaccinated 
From [PostCovidReport ]..CovidVaccinations$ a
join [PostCovidReport ]..CovidDeaths$ b
	on a.location=b.location
	and a.date=b.date
where a.location not in ('World', 'European Union', 'International')
Group by a.Location, Population
order by PercentVaccinated desc*/

--7
select a.location, max(convert(int,people_fully_vaccinated)) as totalvaccinated, population, (max(convert(int, people_fully_vaccinated))/(population))*100 as PercentFullyVaccinated 
From [PostCovidReport ]..CovidVaccinations$ a
join [PostCovidReport ]..CovidDeaths$ b
	on a.location=b.location
	and a.date=b.date
where a.location not in ('World', 'European Union', 'International', 'Asia', 'Europe', 'North America', 'South America', 'Oceania', 'Africa')
group by a.location, population
order by percentfullyvaccinated desc


/*select max(convert(int,people_fully_vaccinated))
from [PostCovidReport ]..CovidVaccinations$
where location like '%gibraltar%'

select max(population)
from [PostCovidReport ]..CovidDeaths$
where location like '%gibraltar%'
*/
--8
select a.location, a.date, max(convert(int,people_fully_vaccinated)) as totalvaccinated, population, (max(convert(int, people_fully_vaccinated))/(population))*100 as PercentFullyVaccinated 
From [PostCovidReport ]..CovidVaccinations$ a
join [PostCovidReport ]..CovidDeaths$ b
	on a.location=b.location
	and a.date=b.date
where a.location not in ('World', 'European Union', 'International', 'Asia', 'Europe', 'North America', 'South America', 'Oceania', 'Africa')
group by a.location, population, a.date
order by percentfullyvaccinated desc