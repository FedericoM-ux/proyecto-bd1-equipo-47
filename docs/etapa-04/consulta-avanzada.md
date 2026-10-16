SELECT
    cat.nombre AS [Categoria],
    COUNT(DISTINCT p.id_pedido) AS [Cantidad Pedidos],
    SUM(dp.cantidad) AS [Unidades Vendidas],
    SUM(dp.subtotal) AS [Monto Total Vendido]
FROM Pedido AS p
JOIN detalle_Pedido AS dp
    ON p.id_detalle = dp.id_detalle
JOIN Producto AS prod
    ON prod.id_detalle = dp.id_detalle
JOIN Categoria AS cat
    ON prod.id_categoria = cat.id_categoria
WHERE
    p.fecha >= '2026-09-01'
    AND p.fecha < '2026-10-01'
GROUP BY
    cat.id_categoria,
    cat.nombre
HAVING
    SUM(dp.subtotal) > (
        SELECT AVG(promedios.total_categoria)
        FROM (
            SELECT
                cat2.id_categoria,
                SUM(dp2.subtotal) AS total_categoria
            FROM Pedido AS p2
            JOIN detalle_Pedido AS dp2
                ON p2.id_detalle = dp2.id_detalle
            JOIN Producto AS prod2
                ON prod2.id_detalle = dp2.id_detalle
            JOIN Categoria AS cat2
                ON prod2.id_categoria = cat2.id_categoria
            WHERE
                p2.fecha >= '2026-09-01'
                AND p2.fecha < '2026-10-01'
            GROUP BY
                cat2.id_categoria
        ) AS promedios
    )
ORDER BY
    [Monto Total Vendido] DESC;
