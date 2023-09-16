

--Death Percentage in Argentina
Select location , date, total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
WHERE location like '%Argentina%'  
order by 1,2




--Total cases  vs Population
--THIS QUERY SHOW HOW MANY PEOPLE HAVE COVID 
Select location , date,population, total_cases,(total_cases/population)*100 as PopulationPercentage
from CovidProject..CovidDeaths
WHERE location like '%Argentina%'  
and continent is not null	
order by 1,2


--Highest Country with highest total_cases

Select location,population, Max(total_cases) as HighestInfectionCountry,MAX((total_cases/population))*100 as PopulationPercentage
from CovidProject..CovidDeaths
Where  continent is not null	
Group by population,location
order by PopulationPercentage desc


--Country with Highest Death Count per Population
Select location,Max(total_deaths) as DeathCount,MAX((total_deaths/population))*100 as DeathPercentage
from CovidProject..CovidDeaths
Where  continent is not null	
Group by location
order by DeathCount desc


--Deaths by continent
Select continent,Max(total_deaths) as DeathCount,MAX((total_deaths/population))*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
Group by continent
order by DeathCount desc

--Total population vs Total population Vaccinated
--Temp Table
Create Table #TotalVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
Total_vaccinations bigint
)



Insert into #TotalVaccinations
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location , dea.date ROWS UNBOUNDED PRECEDING) as total_vaccinations
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



--View 
Create View TotalVaccinations as
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location , dea.date ROWS UNBOUNDED PRECEDING) as total_vaccinations
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3