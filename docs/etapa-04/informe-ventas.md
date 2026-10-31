SELECT   
    cat.nombre AS [Categoria],  
    COUNT(p.id_pedido) AS [Cantidad Pedidos],  
    SUM(dp.cantidad) AS [Unidades Vendidas],  
    SUM(p.total) AS [Monto Total Vendido]  
FROM Pedido p  
JOIN detalle_Pedido dp ON p.id_detalle = dp.id_detalle  
JOIN Producto prod ON prod.id_detalle = dp.id_detalle  
JOIN Categoria cat ON prod.id_categoria = cat.id_categoria  
WHERE p.fecha BETWEEN '2026-09-01' AND '2026-09-30'  
GROUP BY cat.id_categoria, cat.nombre  
ORDER BY [Monto Total Vendido] DESC;

