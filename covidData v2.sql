select location,date,total_cases,new_cases,total_deaths,population
from [COVID DATA]..CovidDeaths
order by 1,2

--total cases vs total deaths

--select location,date,total_cases,total_deaths,
--(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage

--from [COVID DATA]..CovidDeaths

--order by 5 desc

--total cases vs population
--shows what % of the population got covid
select location,date,total_cases,population,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Deathpercentage

from [COVID DATA]..CovidDeaths
where location like '%kenya%'
order by 5 desc


--looking at countries with high infection rates compared to population

select location,population,
MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
from [COVID DATA]..CovidDeaths
group by location,population
order by PercentPopulationInfected desc


--showing countries with highest Death count per population

select location,
MAX(cast(total_deaths as int)) as TotalDeathCount
from [COVID DATA]..CovidDeaths
where continent is not null
group by location,population
order by TotalDeathCount desc

--Lets break down things by continent
select continent,
MAX(cast(total_deaths as int)) as TotalDeathCount
from [COVID DATA]..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
--select location,date,total_cases,total_deaths,
--(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
--FROM [COVID DATA]..CovidDeaths
----WHERE location LIKE '%STATES%'
--WHERE continent IS NOT NULL
--ORDER BY 1,2

SELECT  SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as totalDeaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [COVID DATA]..CovidDeaths
where continent is not null
--GROUP BY date
order by 1,2

--JOIN BOTH TABLES
--LOOKING AT TOTAL PPULATION VS VACCINATIONS
SELECT DEA.continent, DEA.location,DEA.date,DEA.population,VAC.new_vaccinations
FROM [COVID DATA]..CovidDeaths AS DEA
JOIN [COVID DATA]..CovidVaccinations AS VAC
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE DEA.continent IS NOT NULL
AND DEA.location LIKE '%AFGHANISTAN%'
ORDER BY 2,3



SELECT DEA.continent, DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
SUM(Convert (int, VAC.new_vaccinations )) OVER (PARTITION BY DEA.location) AS NewVacByLocation
FROM [COVID DATA]..CovidDeaths AS DEA
JOIN [COVID DATA]..CovidVaccinations AS VAC
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE DEA.continent IS NOT NULL
--AND DEA.location LIKE '%AFGHANISTAN%'
ORDER BY 2,3


----SELECT DEA.continent, DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
--SUM(Convert (int, VAC.new_vaccinations )) OVER (PARTITION BY DEA.location order by dea.date, dea.location) AS NewVacByLocation
--FROM [COVID DATA]..CovidDeaths AS DEA
--JOIN [COVID DATA]..CovidVaccinations AS VAC
--ON DEA.location=VAC.location
--AND DEA.date=VAC.date
--WHERE DEA.continent IS NOT NULL
----AND DEA.location LIKE '%AFGHANISTAN%'
--ORDER BY 2,3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null



