-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-04-2023 a las 18:58:30
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_compucenter`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarCliente` (IN `codigo` INT)   BEGIN
SELECT c.cod_cliente, p.nombre, p.correo, p.dni, p.telefono, p.direccion, p.estado, c.password
FROM persona p
INNER JOIN cliente c
ON c.cod_persona = p.cod_persona
WHERE c.cod_cliente = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPermiso` (IN `codigo` INT)   BEGIN
SELECT cod_permiso FROM detalle_permiso WHERE cod_usuario = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarProducto` (IN `codigo` INT)   BEGIN
SELECT p.cod_producto, p.nombre, p.descripcion, c.cod_categoria, c.nom_categoria, p.precio, p.stock, p.estado
FROM producto p
INNER JOIN categoria c
ON p.cod_categoria = c.cod_categoria
WHERE p.cod_producto = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarUsuario` (IN `codigo` INT)   BEGIN
SELECT u.cod_usuario, p.nombre, p.correo, p.dni, p.telefono, p.direccion, p.estado, u.password
FROM persona p
INNER JOIN usuario u
ON u.cod_persona = p.cod_persona
WHERE u.cod_usuario = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarCliente` (IN `codigo` INT)   BEGIN
SET @cod_per = (SELECT cod_persona FROM cliente WHERE cod_cliente = codigo);
DELETE FROM cliente WHERE cod_cliente = codigo;
DELETE FROM persona WHERE cod_persona = @cod_per;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarPermiso` (IN `cod_permisos` INT, IN `cod_usuarios` INT)   BEGIN
DELETE FROM detalle_permiso WHERE cod_permiso = cod_permisos AND cod_usuario = cod_usuarios;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarProducto` (IN `codigo` INT)   BEGIN
DELETE FROM producto WHERE cod_producto = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarUsuario` (IN `codigo` INT)   BEGIN
SET @cod_per = (SELECT cod_persona FROM usuario WHERE cod_usuario = codigo);
DELETE FROM detalle_permiso WHERE cod_usuario = codigo;
DELETE FROM usuario WHERE cod_usuario = codigo;
DELETE FROM persona WHERE cod_persona = @cod_per;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarPermiso` (IN `cod_permiso` INT, IN `cod_usuario` INT)   BEGIN
INSERT INTO detalle_permiso VALUES(null, cod_permiso, cod_usuario);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarProducto` (IN `codigo` INT, IN `nombre` VARCHAR(50), IN `descripcion` VARCHAR(200), IN `precio` FLOAT, IN `stock` INT)   BEGIN
INSERT INTO producto VALUES(null, codigo, nombre, descripcion, precio, stock, 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarUsuario` (IN `nombre` VARCHAR(200), IN `correo` VARCHAR(200), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `direccion` VARCHAR(300), IN `usuario` VARCHAR(20), IN `contrasena` VARCHAR(30))   BEGIN
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1);
INSERT INTO persona VALUES(null, nombre, correo, dni, telefono, direccion, 1);
INSERT INTO usuario VALUES(null, @cod_per, usuario, SHA(contrasena));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarCategorias` ()   BEGIN
SELECT * FROM categoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarProductos` ()   BEGIN
SELECT p.cod_producto, p.nombre, p.precio, p.stock, p.estado, c.nom_categoria
FROM producto p
INNER JOIN categoria c
ON p.cod_categoria = c.cod_categoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarUsuarios` ()   BEGIN
SELECT u.cod_usuario, p.nombre, p.correo, p.dni, p.telefono, p.direccion, p.estado
FROM persona p
INNER JOIN usuario u
ON u.cod_persona = p.cod_persona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModificarCliente` (IN `codigo` INT, IN `nombres` VARCHAR(200), IN `correos` VARCHAR(200), IN `dnis` VARCHAR(8), IN `telefonos` VARCHAR(9), IN `direccions` VARCHAR(300), IN `estados` BOOLEAN)   BEGIN
SET @cod_per = (SELECT cod_persona FROM cliente WHERE cod_cliente = codigo);
UPDATE persona SET nombre = nombres, correo = correos, dni = dnis, telefono = telefonos, direccion = direccions, estado = estados
WHERE cod_persona = @cod_per;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModificarPasswordUsuario` (IN `codigo` INT, IN `contrasena` VARCHAR(50))   BEGIN
UPDATE usuario SET password = SHA(contrasena) WHERE cod_usuario = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModificarProducto` (IN `codigo` INT, IN `cod_categorias` INT, IN `producto` VARCHAR(50), IN `descripcions` VARCHAR(200), IN `precios` FLOAT, IN `stocks` INT, IN `estados` BOOLEAN)   BEGIN
UPDATE producto SET cod_categoria = cod_categorias, nombre = producto, descripcion = descripcions, precio = precios, stock = stocks, estado = estados
WHERE cod_producto = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModificarUsuario` (IN `codigo` INT, IN `nombres` VARCHAR(200), IN `correos` VARCHAR(200), IN `dnis` VARCHAR(8), IN `telefonos` VARCHAR(9), IN `direccions` VARCHAR(300))   BEGIN
SET @cod_per = (SELECT cod_persona FROM usuario WHERE cod_usuario = codigo);
UPDATE persona SET nombre = nombres, correo = correos, dni = dnis, telefono = telefonos, direccion = direccions
WHERE cod_persona = @cod_per;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarLogin` (IN `usuarios` VARCHAR(20), IN `contrasena` VARCHAR(50))   BEGIN
SELECT u.cod_usuario, p.nombre, p.estado
FROM usuario u
INNER JOIN persona p
ON u.cod_persona = p.cod_persona
WHERE u.usuario = usuarios AND u.password = SHA(contrasena);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `cod_categoria` int(11) NOT NULL,
  `nom_categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`cod_categoria`, `nom_categoria`) VALUES
(1, 'Procesadores'),
(2, 'Tarjetas Gráficas'),
(3, 'Memorias'),
(4, 'Discos'),
(5, 'Periféricos'),
(6, 'Placas Madre'),
(7, 'Sistema de Refrigeración'),
(8, 'Case');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `cod_cliente` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`cod_cliente`, `cod_persona`, `password`) VALUES
(10000, 1, 'user');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `cod_deta_pedido` int(11) NOT NULL,
  `cod_pedido` int(11) NOT NULL,
  `cod_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `monto` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_permiso`
--

CREATE TABLE `detalle_permiso` (
  `cod_deta_permiso` int(11) NOT NULL,
  `cod_permiso` int(11) NOT NULL,
  `cod_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_permiso`
--

INSERT INTO `detalle_permiso` (`cod_deta_permiso`, `cod_permiso`, `cod_usuario`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 1, 2),
(5, 2, 2),
(6, 3, 2),

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `cod_pedido` int(11) NOT NULL,
  `cod_cliente` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `total` float NOT NULL,
  `fecha` date NOT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
  `cod_permiso` int(11) NOT NULL,
  `nom_permiso` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`cod_permiso`, `nom_permiso`) VALUES
(1, 'Usuarios'),
(2, 'Clientes'),
(3, 'Productos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `cod_persona` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `correo` varchar(200) NOT NULL,
  `dni` varchar(8) NOT NULL,
  `telefono` varchar(9) NOT NULL,
  `direccion` varchar(300) NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`cod_persona`, `nombre`, `correo`, `dni`, `telefono`, `direccion`, `estado`) VALUES
(1, 'Jesus Piscoya Bances', 'jesus@piscoya.com', '74644014', '921104614', 'Av. direccion 123', 0),
(2, 'Juan Espinoza Lopez', 'juan@gmail.com', '08965412', '985412365', 'Av. direccion 423', 1),
(3, 'Luis Carranza', 'luis@gmail.com', '08545115', '978895612', 'av. los olivos 296', 1),
(4, 'Carlos Mendoza', 'carlos@gmail.com', '09708495', '998745213', 'Av. Lima 156', 1),
(5, 'Luz', 'luz@gmail.com', '09408566', '989988888', 'av lima 64', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `cod_producto` int(11) NOT NULL,
  `cod_categoria` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `precio` float NOT NULL,
  `stock` int(11) NOT NULL,
  `estado` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`cod_producto`, `cod_categoria`, `nombre`, `descripcion`, `precio`, `stock`, `estado`) VALUES
(10000, 1, 'INTEL CORE I5- 11400', 'INTEL CORE I5- 11400', 185, 10, b'1'),
(10001, 7, 'prueba', 'prueba descripcion', 234, 20, b'1'),
(10002, 5, 'prueba 2', 'prueba 2', 15.5, 10, b'0'),
(10003, 3, 'Prueba 3', 'decripcion prueba 3', 15, 32, b'0'),
(10004, 6, 'Prueba 4', 'descripcion prueba 4', 150, 32, b'0'),
(10005, 6, 'Prueba 4', 'prueba 4', 23.2, 51, b'0'),
(10006, 6, 'Prueba 4', 'prueba 4', 23.2, 51, b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `cod_usuario` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`cod_usuario`, `cod_persona`, `usuario`, `password`) VALUES
(10000, 1, 'admin', 'd033e22ae348aeb5660fc2140aec35850c4da997'),
(10001, 2, 'juan', 'juan'),
(10002, 3, 'luis', 'faea5242a00c52da62a0f00df168c199b7ab748d'),
(10003, 5, 'carlos', 'ab5e2bca84933118bbc9d48ffaccce3bac4eeb64'),
(10004, 7, 'luz', 'c307b63565c069c7f841b112a6280a8de6fc9ef6');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`cod_categoria`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`cod_cliente`),
  ADD KEY `cod_persona` (`cod_persona`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`cod_deta_pedido`),
  ADD KEY `cod_producto` (`cod_producto`),
  ADD KEY `cod_pedido` (`cod_pedido`);

--
-- Indices de la tabla `detalle_permiso`
--
ALTER TABLE `detalle_permiso`
  ADD PRIMARY KEY (`cod_deta_permiso`),
  ADD KEY `cod_permiso` (`cod_permiso`),
  ADD KEY `cod_usuario` (`cod_usuario`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`cod_pedido`),
  ADD KEY `cod_cliente` (`cod_cliente`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`cod_permiso`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`cod_persona`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`cod_producto`),
  ADD KEY `cod_categoria` (`cod_categoria`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`cod_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD KEY `cod_persona` (`cod_persona`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `cod_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `cod_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10001;

--
-- AUTO_INCREMENT de la tabla `detalle_permiso`
--
ALTER TABLE `detalle_permiso`
  MODIFY `cod_deta_permiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `cod_pedido` int(11) NOT NULL AUTO_INCREMENT=10000;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
  MODIFY `cod_permiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `cod_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `cod_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10007;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `cod_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10005;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`);

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`cod_producto`) REFERENCES `producto` (`cod_producto`),
  ADD CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`cod_pedido`) REFERENCES `pedido` (`cod_pedido`);

--
-- Filtros para la tabla `detalle_permiso`
--
ALTER TABLE `detalle_permiso`
  ADD CONSTRAINT `detalle_permiso_ibfk_1` FOREIGN KEY (`cod_permiso`) REFERENCES `permiso` (`cod_permiso`),
  ADD CONSTRAINT `detalle_permiso_ibfk_2` FOREIGN KEY (`cod_usuario`) REFERENCES `usuario` (`cod_usuario`);

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`cod_cliente`) REFERENCES `cliente` (`cod_cliente`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`cod_categoria`) REFERENCES `categoria` (`cod_categoria`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
