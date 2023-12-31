--vistas
use MovieDB


create function f_actors_genre(@genero varchar(50))
returns table
return
select name from actors
where name not in(
select name
from actors as a
    join movie_cast as mc on a.id=mc.actor_id
    join movies as m on mc.movie_id=m.id
    join genres as g on m.genre_id = g.id
where description=@genero)
go;
select * from dbo.f_actors_genre('horror')
go;


--crear un procedimiento almacenado que retorne la cantidad de actores que participaron en un determinado
--genero de pelicula para un determinado año

alter view actors_by_year_genre
as
select year,description, count(m.title) cantidad
from movie_cast mc
    right join movies m on mc.movie_id = m.id
    join genres g on m.genre_id = g.id
group by year,description;
go;

select * from actors_by_year_genre

alter function function_cantidad_actors_year_genre1(
@year int,
@genero varchar(50)
) returns int
    as
begin
    declare @si int
    select  @si=(
select cantidad from actors_by_year_genre
where year=@year and description=@genero)
    return @si
end
go;



print dbo.function_cantidad_actors_year_genre1 (2003,'Drama')
--crear un procedimiento almacenado que retorne el nombre del actor que participan
--más veces en peliculas de determinado genero para un determinado año
create view actors_by_year_genre2
as
select year,description, count(distinct actor_id) cantidad
from movie_cast mc
     join movies m on mc.movie_id = m.id
    join genres g on m.genre_id = g.id
group by year,description;
go;


--mayor estrellas
create view averge_stars_movie
as
select title,avg(stars) av
from movies m
join ratings r on m.id = r.movie_id
group by title
go;

--procedure
create procedure usp_movie_max_stars
as
    begin
    select title,av from averge_stars_movie
where av= (select max(av) from averge_stars_movie)
    end

exec usp_movie_max_stars

--crear un procedure que permita imprimir la cantidad de peliculas por
--genero para para un determinado año

declare @year int
declare  @genero varchar(50)
declare @cantidad int
declare cursor_movies cursor for
--declarar cursor
select year,description, count(m.id) cantidad
from movies m
join genres g on m.genre_id = g.id
group by year,description
--abir
open cursor_movies
--saltar al siguiente registro
    fetch cursor_movies into @year, @genero,@cantidad
while (@@fetch_status=0)
begin
    print(@cantidad)
    fetch cursor_movies into @year, @genero,@cantidad
end
close cursor_movies
deallocate cursor_movies



---cursor modifcao

create procedure usp_prueba
    as
    begin
declare @year int
declare  @genero varchar(50)
declare @cantidad int

declare cursor_movies cursor for
--declarar cursor

--query
select year,description, count( m.id) cantidad
from movies m
join genres g on m.genre_id = g.id
group by year,description


--abir cursor
open cursor_movies

--saltar a la siguiente celda (fetch)
fetch cursor_movies into @year, @genero,@cantidad
while (@@fetch_status=0) --MientrasHallaFilasEnLaConsulta
begin
    print(@cantidad)
    fetch cursor_movies into @year, @genero,@cantidad
end
close cursor_movies
deallocate cursor_movies
        end

exec usp_prueba




