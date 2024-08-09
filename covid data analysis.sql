select *
from coviddata
order by 1,2

select *
from covidvaccination
order by 1,2

select location,date,total_cases,total_deaths,population,(total_deaths/total_cases)
from coviddata
order by 1,2

SELECT location,date,total_cases,total_deaths,population,total_deaths / NULLIF(total_cases, 0)*100 as deathpercent
from coviddata
order by 1,2


SELECT location,date,total_cases,total_deaths,population,total_cases / NULLIF(population, 0)*100 as populationpercent
from coviddata
--where location like 'india'
order by 1,2


SELECT location,max(total_cases)as max_total_case,population,max(total_cases / NULLIF(population, 0))*100 as populationpercent
from coviddata
--where location like 'india'
group by location,population
order by 1,2 desc


SELECT location,max(cast(total_deaths as int))as max_deathcount
from coviddata
--where location like 'india'
group by location
order by max_deathcount desc

SELECT continent,max(cast(total_deaths as int))as max_deathcount
from coviddata
--where location like 'india'
where continent is not null
group by continent
order by max_deathcount desc
--death percent globally
SELECT sum(new_cases)as totla_cases,sum(cast(new_deaths as int))as total_deaths,
sum(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as deathpercent
from coviddata
where continent is not null
--group by date
order by 1,2 desc

select cd.continent,cd.date,cd.location,cd.population,cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over(partition by cd.location order by cd.date,cd.location) as peoplevaccinated
from coviddata cd
inner join covidvaccination cv
on cd.date=cv.date
and cd.location=cv.location
where cd.continent is not null
order by 1,2