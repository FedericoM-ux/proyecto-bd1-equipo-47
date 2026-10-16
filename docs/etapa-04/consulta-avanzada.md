SELECT 
    cat.nombre AS [Categoria],
    COUNT(DISTINCT p.id_pedido) AS [Cantidad Pedidos],
    SUM(dp.cantidad) AS [Unidades Vendidas],
    SUM(p.total) AS [Monto Total Vendido]
FROM 
    Pedido p
JOIN 
    detalle_Pedido dp ON p.id_detalle = dp.id_detalle
JOIN 
    Producto prod ON prod.id_detalle = dp.id_detalle
JOIN 
    Categoria cat ON prod.id_categoria = cat.id_categoria
WHERE 
    p.fecha BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY 
    cat.id_categoria, 
    cat.nombre
HAVING 
    SUM(p.total) > (
        SELECT AVG(sub_total) 
        FROM (
            SELECT SUM(p2.total) AS sub_total
            FROM Pedido p2
            JOIN detalle_Pedido dp2 ON p2.id_detalle = dp2.id_detalle
            JOIN Producto prod2 ON prod2.id_detalle = dp2.id_detalle
            JOIN Categoria cat2 ON prod2.id_categoria = cat2.id_categoria
            WHERE p2.fecha BETWEEN '2026-09-01' AND '2026-09-30'
            GROUP BY cat2.id_categoria
        ) AS promedios
    )
ORDER BY 
    [Monto Total Vendido] DESC;
