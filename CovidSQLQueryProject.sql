Select *
from SQLPortfolioProject..CovidDeaths
where continent is not null
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from SQLPortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths(Indonesia)
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage
from SQLPortfolioProject..CovidDeaths
Where location like '%indonesia%'
order by 1,2

--Total Cases vs Population(Indonesia)
Select location, date, total_cases, population,(total_cases/population)*100 as death_percentage
from SQLPortfolioProject..CovidDeaths
Where location like '%indonesia%'
order by 1,2

--Highest Infection Rate
Select location, MAX(total_cases) as highest_infection, population,MAX((total_cases/population))*100 as infected_population_percentage
from SQLPortfolioProject..CovidDeaths
group by location, population
order by infected_population_percentage desc

--Highest Death Count Population
Select location, MAX(cast(total_deaths as int)) as total_death_count
from SQLPortfolioProject..CovidDeaths
where continent is not null
group by location
order by total_death_count desc

--Continent
--Select continent, MAX(cast(total_deaths as int)) as total_death_count
--from SQLPortfolioProject..CovidDeaths
--where continent is not null
--group by continent
--order by total_death_count desc


--Continent with The Highest Death Count

Select continent, MAX(cast(total_deaths as int)) as total_death_count
from SQLPortfolioProject..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

--Global Numbers
Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from SQLPortfolioProject..CovidDeaths
--Where location like '%indonesia%'
where continent is not null
--group by date
order by 1,2

--Total Cases
Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from SQLPortfolioProject..CovidDeaths
--Where location like '%indonesia%'
where continent is not null
--group by date
order by 1,2


with PopvsVacc (continent,location,date,population, new_vaccinations, rolling_people_vaccinated)
as
(
--Population vs Vaccinations
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
,SUM(convert(int, vaccination.new_vaccinations)) over (Partition by death.location, death.date)
as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
from SQLPortfolioProject..CovidDeaths death
Join SQLPortfolioProject..CovidVaccinations vaccination
	On death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
--order by 2,3
)
select *, (rolling_people_vaccinated/population)*100 
from PopvsVacc

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
,SUM(convert(int, vaccination.new_vaccinations)) over (Partition by death.location, death.date)
as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
from SQLPortfolioProject..CovidDeaths death
Join SQLPortfolioProject..CovidVaccinations vaccination
	On death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
--order by 2,3

select *, (rolling_people_vaccinated/population)*100 
from #PercentPopulationVaccinated



Create View PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations
,SUM(convert(int, vaccination.new_vaccinations)) over (Partition by death.location, death.date)
as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
from SQLPortfolioProject..CovidDeaths death
Join SQLPortfolioProject..CovidVaccinations vaccination
	On death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null
--order by 2,3

Select * from PercentPopulationVaccinated