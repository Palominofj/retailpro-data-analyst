-- =============================================
-- M5 — Consultas SQL con JOINs
-- RetailPro — Ventas_Tech_DB
-- =============================================

-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha_venta,
    c.nombre                AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria    AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c     ON v.id_cliente   = c.id_cliente
INNER JOIN productos p    ON v.id_producto  = p.id_producto
INNER JOIN territorios t  ON c.id_territorio = t.id_territorio
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
SELECT
    p.nombre_producto,
    cat.nombre_categoria    AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v         ON p.id_producto  = v.id_producto
LEFT JOIN categorias cat   ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- CONSULTA 4: Consolidado por canal (UNION ALL)
SELECT
    canal,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM (
    SELECT canal, cantidad, precio_unitario
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT canal, cantidad, precio_unitario
    FROM ventas
    WHERE canal = 'Presencial'
) AS consolidado
GROUP BY canal
ORDER BY canal;

-- =============================================
-- HALLAZGOS
-- 1. La vista base cruza las 5 tablas del modelo en una sola consulta,
--    generando la fuente de datos lista para conectar a Power BI.
-- 2. No existen clientes sin ventas ni productos sin movimiento,
--    lo que indica que todos los registros tienen actividad comercial.
-- 3. El canal Online generó mayor facturación que el Presencial,
--    concentrando las ventas de mayor valor unitario como laptops y monitores.
-- =============================================