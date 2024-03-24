Select *
from PortfolioProject1..CovidDeath



-- looking at Total Cases vs Total Deaths in India

ALTER TABLE dbo.CovidDeath
ALTER COLUMN total_cases float


Select Location, date, total_cases, total_deaths, (total_deaths/nullif(total_cases,0))*100 as DeathPercentage
from PortfolioProject1..CovidDeath
where location like  '%ndia%'
order by 1,2

--Looking at the total Cases vs total population in India


--Percentage of Poplulation got covid


Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage_of_people_infected
from PortfolioProject1..CovidDeath
where location like  '%ndia%'
order by 5 desc

--Looking at Highest Infection Rate Globally


Select Location, population, MAX(total_cases)as Highest_Infection_Count, MAX((total_cases/population)*100) as Highest_Percentage_of_people_infected
from PortfolioProject1..CovidDeath
where continent <>''
Group by Location, Population 
Order by Highest_Percentage_of_people_infected desc



 
--Countries with Highest Death Rates


Select location, MAX(cast(total_deaths as int))as Total_Death_Count
from PortfolioProject1..CovidDeath
where continent <>''
Group by location
Order by Total_Death_Count desc




--Showing continents with highest death count


Select continent, MAX(cast(total_deaths as bigint))as Total_Death_Count
from PortfolioProject1..CovidDeath
where continent <>''
Group by continent
Order by Total_Death_Count desc

--Breaking Global numbers

Select SUM(cast(new_cases as float)) as totalcases, SUM(cast(new_deaths as float)) as totaldeaths, (SUM(cast(new_deaths as float))/SUM(cast(new_cases as float)))*100 
from PortfolioProject1..CovidDeath
where continent<>''
order by 1,2 


--POPULATION VS VACCINATION


select death.continent,death.location,death.date,death.population, vaccine.new_vaccinations
, SUM(cast (vaccine.new_vaccinations as bigint)) OVER (Partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
 --RollingPeopleVaccinated/population
from PortfolioProject1..CovidDeath as death
join PortfolioProject1..CovidVaccinations as vaccine
   on death.location=vaccine.location
   and death.date=vaccine.date
where death.continent<>''
order by 2,3


--Using CTE
with PopvsVac (Continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
select death.continent,death.location,death.date,death.population, vaccine.new_vaccinations
, SUM(cast (vaccine.new_vaccinations as float)) OVER (Partition by death.location order by death.location, death.date) as RollingPeopleVaccinated

from PortfolioProject1..CovidDeath as death
join PortfolioProject1..CovidVaccinations as vaccine
   on death.location=vaccine.location
   and death.date=vaccine.date
where death.continent<>''
--order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100 as percentof
from PopvsVac







