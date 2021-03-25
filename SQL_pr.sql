/abolish
/multiline on
create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into programadores values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','J�piter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plut�n 3',NULL);

create table distribuci�n(c�digoPr string, dniEmp string, horas int, primary key (c�digoPr, dniEmp));
insert into distribuci�n values('P1','1',10);
insert into distribuci�n values('P1','2',40);
insert into distribuci�n values('P1','4',5);
insert into distribuci�n values('P2','4',10);
insert into distribuci�n values('P3','1',10);
insert into distribuci�n values('P3','3',40);
insert into distribuci�n values('P3','4',5);
insert into distribuci�n values('P3','5',30);
insert into distribuci�n values('P4','4',20);
insert into distribuci�n values('P4','5',10);

create table proyectos(c�digo string primary key, descripci�n string, dniDir string);
insert into proyectos values('P1','N�mina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producci�n','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');







create view vista1 as select dni from programadores union select dni from analistas;

create view vista2 as select dni from programadores intersect select dni from analistas;

create view vista3 as select dni,nombre from (select * from programadores union select * from analistas) where programadores.tel�fono is null;

create view vista4 as select dni 
from vista1
minus 
select dni
from vista1 as emp inner join (select dniEmp from distribuci�n as d union select dniDir from proyectos) on emp.dni = d.dniEmp;

create view vista5 as select c�digo
from proyectos 	
minus
select c�digoPr 
from distribuci�n as d 
inner join analistas as a 
on d.dniEmp = a.dni;

create view vista6 as select dniDir 
from proyectos 
intersect
select dni 
from analistas 
minus
select dni
from programadores;

create view vista7 as select p.descripci�n, programadores.nombre, d.horas
from ((distribuci�n as d
inner join proyectos as p on d.c�digoPr = p.c�digo)
inner join programadores on d.dniEmp = programadores.dni);

create view vista8 as select emp1.tel�fono
from (select * from analistas union select * from programadores) as emp1
inner join (select * from analistas union select * from programadores) as emp2
on emp1.dni != emp2.dni and emp1.tel�fono = emp2.tel�fono;

create view vista9 as select distinct nombre ,sum(h) from (select nombre,nvl(horas,0) as h from (select * from programadores union select * from analistas) left join distribuci�n on distribuci�n.dniEmp = dni) group by nombre;

create view vista10 as select emp.dni, emp.nombre, d.c�digoPr
from (select * from programadores union select * from analistas) as emp
left join distribuci�n as d
on emp.dni = d.dniEmp;

create view vista11 as 
create view vista11 as 
select d2.dniEmp
from proyectos as p
inner join distribuci�n as d1
on p.dniDir = d1.dniEmp
right join distribuci�n as d2
on p.c�digo = d2.c�digoPr
where d1.horas < d2.horas and d2.dniEmp <> p.dniDir;

create view vista12 as select dni,nombre
from (select * from programadores union select * from analistas)
left join distribuci�n
on dni = distribuci�n.dniEmp
where distribuci�n.c�digoPr is null;

create view vista13 as select emp.dni, emp.nombre
from (select * from programadores union select * from analistas) as emp
where emp.dni not in (select dniEmp from distribuci�n);

create view vista14 as select emp.dni,emp.nombre
from (select * from programadores union select * from analistas) as emp
where not exists
(select dniEmp from distribuci�n
    where emp.dni = distribuci�n.dniEmp
);

create view vista15 as select p.descripci�n as Descripci�n, count(emp.dni) as trabajadores, sum(d.horas) as horas
from (proyectos as p 
left join distribuci�n as d
on p.c�digo = d.c�digoPr
inner join (select * from programadores union select * from analistas) as emp
on d.dniEmp = emp.dni
)
group by p.descripci�n;

create view vista16 as 
select p.descripci�n as Descripci�n, count(emp.dni) as trabajadores, sum(d.horas) as horas
from (proyectos as p 
left join distribuci�n as d
on p.c�digo = d.c�digoPr
inner join (select * from programadores union select * from analistas) as emp
on d.dniEmp = emp.dni
)
group by p.descripci�n
having count(emp.dni) > 1;      

create view vista17 as select emp.nombre
from (select * from programadores union select * from analistas) as emp
inner join proyectos as p
on emp.dni = p.dniDir;

create view vista18 as
select emp.nombre as Director
from ((select * from programadores union select * from analistas) as emp
left join proyectos as p
on emp.dni = p.dniDir
inner join distribuci�n as d  
on p.c�digo = d.c�digoPr
)
group by emp.nombre
having count(d.dniEmp) > 2;   

create view vista19 as 
select top 1 d.c�digoPr
from 
(proyectos as p 
left join distribuci�n as d
on p.c�digo = d.c�digoPr
inner join (select * from programadores union select * from analistas) as emp
on d.dniEmp = emp.dni
)
group by d.c�digoPr
order by sum(d.horas) desc;

create view vista20 as 
select top 1 emp.dni
from (select * from programadores union select * from analistas) as emp
inner join distribuci�n as d
on emp.dni = d.dniEmp
group by emp.dni
order by sum(d.horas) desc
union
select top 1 emp.dni
from (select * from programadores union select * from analistas) as emp
inner join distribuci�n as d
on emp.dni = d.dniEmp
group by emp.dni
order by count(d.c�digoPr) desc;

create view vista21 as
select emp.nombre 
from (select * from programadores union select * from analistas) as emp
inner join distribuci�n as d
on emp.dni = d.dniEmp
group by emp.nombre
having count(d.c�digoPr) > 1;

select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;
select * from vista17;
select * from vista18;
select * from vista19;
select * from vista20;
select * from vista21;


