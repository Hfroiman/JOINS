-- Por cada producto listar la descripción del producto, el precio y el nombre de la categoría a la que pertenece.
SELECT
    p.Descripcion,
    p.Precio,
    c.Nombre
from Productos p
INNER join Categorias c on p.IDCategoria=c.ID

-- Listar las categorías de producto de las cuales no se registren productos.
SELECT
    c.Nombre as Categorias,
    p.IDCategoria
from Categorias c
left JOIN Productos p on c.ID=p.IDCategoria
where p.ID is NULL 

SELECT
    c.Nombre as Categorias,
    p.IDCategoria
from Productos p
RIGHT JOIN Categorias c on c.ID=p.IDCategoria
where p.ID is NULL 


-- Listar el nombre de la categoría de producto de aquel o aquellos productos que más tiempo lleven en construir.
SELECT top 3
    c.Nombre as Categorias,
    p.DiasConstruccion
from Categorias c
INNER JOIN Productos p on c.ID=p.IDCategoria
ORDER by p.DiasConstruccion desc

-- Listar apellidos y nombres y dirección de mail de aquellos clientes que no hayan registrado pedidos.

    select
        c.Apellidos,
        c.Nombres,
        c.Mail,
        p.ID
    from Clientes c
    LEFT join Pedidos p on c.ID=p.IDCliente
    where p.ID is null

-- Listar apellidos y nombres, mail, teléfono y celular de aquellos clientes que hayan realizado algún pedido cuyo costo supere $1000000
    SELECT 
        c.Apellidos,
        c.Nombres,
        c.Mail,
        c.Telefono, 
        c.Celular,
        p.Costo
    from Clientes  c
    INNER JOIN Pedidos p on c.ID=p.IDCliente
    WHERE p.Costo>1000000

-- Listar IDPedido, Costo, Fecha de solicitud y fecha de finalización, descripción del producto, costo y apellido y nombre del cliente.
--Sólo listar aquellos registros de pedidos que hayan sido pagados.
    SELECT
        p.ID,
        p.Costo,
        p.FechaSolicitud,
        p.FechaFinalizacion,
        pr.Descripcion,
        pr.Costo as CostoProducto,
        c.Apellidos,
        c.Nombres,
        p.Pagado
    from Pedidos p
    inner JOIN Productos pr on p.IDProducto=pr.ID
    INNER join Clientes c on p.IDCliente=c.ID
    where p.Pagado=1

-- Listar IDPedido, Fecha de solicitud, fecha de finalización, días de construcción del producto, días de construcción del pedido 
--(fecha de finalización - fecha de solicitud) y una columna llamada Tiempo de construcción con la siguiente información:
-- 'Con anterioridad' → Cuando la cantidad de días de construcción del pedido sea menor a los días de construcción del producto.
-- 'Exacto'' → Si la cantidad de días de construcción del pedido y el producto son iguales
-- 'Con demora' → Cuando la cantidad de días de construcción del pedido sea mayor a los días de construcción del producto.

SELECT 
    pe.ID,
    pe.FechaSolicitud,
    pe.FechaFinalizacion,
    pr.DiasConstruccion,
    DATEDIFF(DAY, pe.FechaSolicitud, pe.FechaFinalizacion) DiasContruccionPedido,
    case 
    when DiasConstruccion>pr.DiasConstruccion then 'Con anterioridad'
    when DiasConstruccion=pr.DiasConstruccion then 'Exacto'
    when DiasConstruccion<pr.DiasConstruccion then 'Con demora'
    end as TiempoConstruccion
FROM Pedidos pe
inner join Productos pr on pe.IDProducto=pr.ID


-- Listar por cada cliente el apellido y nombres y los nombres de las categorías de aquellos productos de los cuales hayan realizado pedidos.
--No deben figurar registros duplicados.

select distinct
C.Apellidos,
C.Nombres,
ca.Nombre
from Clientes c
inner join Pedidos ped on c.ID=ped.IDCliente
inner join Productos pe on ped.IDProducto=pe.ID
INNER JOIN Categorias ca on ca.ID=pe.IDCategoria


-- Listar apellidos y nombres de aquellos clientes que hayan realizado algún pedido cuya cantidad sea exactamente igual a la cantidad considerada
--mayorista del producto.
SELECT
    c.Apellidos,
    c.Nombres
    --pe.Cantidad,
    --pr.CantidadMayorista
from clientes c
inner join Pedidos pe on c.ID=pe.IDCliente
inner join Productos pr on pe.IDProducto=pr.ID
where pe.Cantidad=pr.CantidadMayorista
-- Listar por cada producto el nombre del producto, el nombre de la categoría, el precio de venta minorista, el precio de venta mayorista y
--el porcentaje de ahorro que se obtiene por la compra mayorista a valor mayorista en relación al valor minorista.

SELECT 
    pr.Descripcion,
    c.Nombre,
    pr.Precio,
    pr.PrecioVentaMayorista,
    pr.CantidadMayorista,
    100-((pr.PrecioVentaMayorista*100)/pr.Precio) as PorcentajeAhorro
from Productos pr
inner join Categorias c on pr.IDCategoria=c.ID