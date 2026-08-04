-- =============================================
-- M4 — Consultas SQL de negocio
-- RetailPro — Ventas_Tech_DB
-- =============================================

-- CONSULTA 1: Resumen ejecutivo mensual
SELECT
    EXTRACT(MONTH FROM fecha_venta)        AS mes,
    SUM(cantidad * precio_unitario)        AS total_facturado,
    COUNT(*)                               AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)        AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- CONSULTA 2: Ranking de productos Top 5
SELECT
    id_producto,
    SUM(cantidad)                          AS unidades_vendidas,
    SUM(cantidad * precio_unitario)        AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- CONSULTA 3: Clientes recurrentes
SELECT
    id_cliente,
    COUNT(*)                               AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)        AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- CONSULTA 4: Meses por encima/por debajo del promedio
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS performance
FROM (
    SELECT
        EXTRACT(MONTH FROM fecha_venta)    AS mes,
        SUM(cantidad * precio_unitario)    AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
) AS resumen_mensual
ORDER BY mes;

-- =============================================
-- HALLAZGOS
-- 1. El producto 1 (Laptop Pro 15) concentra el 56% de la facturación
--    total con $3600 de $6444, siendo el producto más rentable.
-- 2. Los 5 clientes registrados son recurrentes, todos con 2 compras,
--    lo que indica una base de clientes con alto potencial de fidelización.
-- 3. Con datos de un solo mes no es posible detectar estacionalidad,
--    pero el ticket promedio de $644 sugiere un perfil de compra de alto valor.
-- =============================================