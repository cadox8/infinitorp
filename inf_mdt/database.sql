--
-- Cambios a realizar a la base de datos del servidor
--

-- Añadimos un identificador al usuario (Estilo DNI)
ALTER TABLE `users` ADD COLUMN `identificador` varchar(5) NULL;


-- Creamos la tabla de ciudadanos (para la policia)


-- Creamos la tabla de registros


-- Creamos la tabla de multas


-- Creamos una tabla intermedia para unir las multas con los registros

