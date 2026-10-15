SELECT   
    cat.nombre AS \[Categoria\],  
    COUNT(p.id\_pedido) AS \[Cantidad Pedidos\],  
    SUM(dp.cantidad) AS \[Unidades Vendidas\],  
    SUM(p.total) AS \[Monto Total Vendido\]  
FROM Pedido p  
JOIN detalle\_Pedido dp ON p.id\_detalle \= dp.id\_detalle  
JOIN Producto prod ON prod.id\_detalle \= dp.id\_detalle  
JOIN Categoria cat ON prod.id\_categoria \= cat.id\_categoria  
WHERE p.fecha BETWEEN '2026-09-01' AND '2026-09-30'  
GROUP BY cat.id\_categoria, cat.nombre  
ORDER BY \[Monto Total Vendido\] DESC;

