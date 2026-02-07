-- ====================================================================================
-- ====================================================================================
--                         INICIO DE CARGA DE DATOS (POBLADO)
-- ====================================================================================
-- ====================================================================================

-- PASO 1: INFRAESTRUCTURA
INSERT INTO DEPARTAMENTO (Nombre) VALUES 
('Santa Cruz'), ('Cochabamba'), ('Oruro'), ('Chuquisaca'), ('Potosí'), ('Tarija');

INSERT INTO CIUDAD (ID_Departamento, Nombre) VALUES 
(1, 'Santa Cruz de la Sierra'), (2, 'Cochabamba'), (3, 'Oruro'), (4, 'Sucre'), (5, 'Potosí'), 
(1, 'San José de Chiquitos'), (1, 'Roboré'), (1, 'Puerto Quijarro'), (1, 'Charagua'), 
(6, 'Villa Montes'), (6, 'Yacuiba');

INSERT INTO ESTACION (ID_Ciudad, Nombre, Direccion) VALUES 
(1, 'Estación Bimodal SCZ', 'Av. Intermodal'), (2, 'Estación del Valle', 'Av. Heroínas'), 
(3, 'Estación Central Oruro', 'Calle Velasco'), (4, 'Estación El Tejar', 'Av. Ostria Gutierrez'), 
(5, 'Estación Villa Imperial', 'Av. Universitaria'), (6, 'Estación San José', 'Zona Chiquitana'), 
(7, 'Estación Perla del Oriente', 'Av. Ferroviaria'), (8, 'Estación Frontera Quijarro', 'Puerto Suárez'), 
(9, 'Estación Charagua', 'Pueblo Viejo'), (10,'Estación Beneméritos', 'Centro Villa Montes'), 
(11,'Estación Pocitos', 'Frontera Argentina');

INSERT INTO RUTA (Nombre_Ruta) VALUES 
('Expreso Oriental-Andino (SCZ-ORU)'), ('Expreso Imperial (SCZ-PTS)'), 
('Tren Oriental (SCZ-Quijarro)'), ('Tren del Sur (SCZ-Yacuiba)');

-- TRAMOS
INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES (NULL, 'Corredor Norte Completo', 800, '14:00', 0); 
INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES 
(1, 'Santa Cruz - Cochabamba', 480, '09:00', 80.00), (1, 'Cochabamba - Oruro', 320, '05:00', 40.00);      

INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES (NULL, 'Corredor Imperial Completo', 900, '16:00', 0); 
INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES 
(4, 'Santa Cruz - Sucre', 750, '12:00', 100.00), (4, 'Sucre - Potosí', 150, '04:00', 30.00);          

INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES (NULL, 'Corredor Chiquitano Completo', 650, '16:00', 0); 
INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES 
(7, 'Santa Cruz - San José', 270, '06:00', 45.00), (7, 'San José - Roboré', 140, '03:30', 30.00), (7, 'Roboré - Puerto Quijarro', 240, '06:00', 55.00); 

INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES (NULL, 'Corredor Chaco Completo', 550, '15:00', 0); 
INSERT INTO TRAMO (ID_Tramo_Padre, Nombre, Distancia_Km, Tiempo_Estimado, Precio) VALUES 
(11, 'Santa Cruz - Charagua', 260, '07:00', 40.00), (11, 'Charagua - Villa Montes', 180, '05:00', 35.00), (11, 'Villa Montes - Yacuiba', 110, '03:00', 20.00);    

-- RUTA_TRAMO
INSERT INTO RUTA_TRAMO (ID_Ruta, ID_Tramo, ID_Estacion_Origen, ID_Estacion_Destino, Orden_Secuencia) VALUES
(1, 2, 1, 2, 1), (1, 3, 2, 3, 2),
(2, 5, 1, 4, 1), (2, 6, 4, 5, 2),
(3, 8, 1, 6, 1), (3, 9, 6, 7, 2), (3, 10, 7, 8, 3),
(4, 12, 1, 9, 1), (4, 13, 9, 10, 2), (4, 14, 10, 11, 3);

-- ====================================================================================
-- PASO 2: FLOTA Y PERSONAL (CON TIPO DE PERSONA 'EMPLEADO')
-- ====================================================================================

INSERT INTO ROL (Nombre, Sueldo_Base) VALUES ('Taquillero', 2800.00), ('Conductor', 3500.00);

-- Empleados Taquilleros (Se agrega 'EMPLEADO')
INSERT INTO PERSONA (Nombre, Apellidos, CI_Documento, Celular, Tipo_Persona) VALUES 
('Juan', 'Perez', '1001', '7001001', 'EMPLEADO'), 
('Ana', 'Lopez', '1002', '7001002', 'EMPLEADO');
INSERT INTO EMPLEADO (ID_Empleado, ID_Rol) VALUES (1, 1), (2, 1);

-- Conductores (Se agrega 'EMPLEADO')
DECLARE @c INT = 1;
WHILE @c <= 10
BEGIN
    INSERT INTO PERSONA (Nombre, Apellidos, CI_Documento, Tipo_Persona) VALUES 
    (CONCAT('Conductor', @c), 'Ferroviario', CONCAT('C-', @c), 'EMPLEADO');
    
    INSERT INTO EMPLEADO (ID_Empleado, ID_Rol) VALUES (SCOPE_IDENTITY(), 2);
    SET @c = @c + 1;
END

-- Trenes y Vagones
INSERT INTO TIPO_VAGON (Nombre, Precio_Base_Factor) VALUES ('Turista', 1.00), ('Ejecutivo', 1.50), ('Cama', 2.00);

DECLARE @t INT = 1;
WHILE @t <= 10
BEGIN
    INSERT INTO TREN (Codigo_Identificador, Modelo, Velocidad_Max) VALUES (CONCAT('T-', 100+@t), 'Diesel', 100.00);
    DECLARE @IdTren INT = SCOPE_IDENTITY();
    
    DECLARE @NumVagones INT = 3 + (ABS(CHECKSUM(NEWID()) % 3)); 
    DECLARE @v INT = 1;
    WHILE @v <= @NumVagones
    BEGIN
        DECLARE @Tipo INT = (ABS(CHECKSUM(NEWID()) % 3) + 1);
        DECLARE @Cap INT = CASE @Tipo WHEN 1 THEN 60 WHEN 2 THEN 40 ELSE 20 END;
        INSERT INTO VAGON (ID_Tren, ID_Tipo_Vagon, Capacidad_Asientos) VALUES (@IdTren, @Tipo, @Cap);
        DECLARE @IdVagon INT = SCOPE_IDENTITY();
        
        DECLARE @a INT = 1;
        WHILE @a <= @Cap
        BEGIN
            INSERT INTO ASIENTO (ID_Vagon, Numero_Asiento, Ubicacion) 
            VALUES (@IdVagon, CONCAT(@a, CASE WHEN @a%2=0 THEN 'V' ELSE 'P' END), 'General');
            SET @a = @a + 1;
        END
        SET @v = @v + 1;
    END
    SET @t = @t + 1;
END

-- ====================================================================================
-- PASO 3: CATÁLOGOS Y PASAJEROS (CON TIPO DE PERSONA 'CLIENTE' y 'PASAJERO')
-- ====================================================================================

INSERT INTO METODO_PAGO (Nombre) VALUES ('Efectivo'), ('QR'), ('Tarjeta Debito'), ('Transferencia Bancaria');
INSERT INTO TIPO_MOTIVO (Nombre, Descripcion) VALUES 
('Salud', 'Problema médico repentino'), 
('Personal', 'Cambio de planes del viajero'), 
('Cancelación Servicio', 'Falla técnica o derrumbe');

-- 2. Crear Clientes (Se agrega 'CLIENTE')
INSERT INTO PERSONA (Nombre, Apellidos, CI_Documento, Celular, Tipo_Persona) VALUES 
('Cliente', 'Ventanilla', '0000000', '0', 'CLIENTE'),
('Agencia', 'Turismo Bol', 'NIT-1001', '7000001', 'CLIENTE'),
('Empresa', 'Minera San Cristobal', 'NIT-2002', '7000002', 'CLIENTE'),
('Colegio', 'La Salle', 'NIT-3003', '7000003', 'CLIENTE'),
('Hotel', 'Los Tajibos', 'NIT-4004', '7000004', 'CLIENTE');

INSERT INTO CLIENTE (ID_Cliente, Nit, Razon_Social)
SELECT ID_Persona, CI_Documento, CONCAT(Nombre, ' ', Apellidos)
FROM PERSONA 
WHERE Tipo_Persona = 'CLIENTE'; -- Usamos el tipo para filtrar

-- 3. GENERACIÓN MASIVA DE PASAJEROS (Se agrega 'PASAJERO')
DECLARE @Nombres TABLE (Nombre VARCHAR(50));
INSERT INTO @Nombres VALUES ('Juan'), ('Ana'), ('Carlos'), ('Maria'), ('Luis'), ('Sofia'), ('Jorge'), ('Lucia'), ('Pedro'), ('Paula'), ('Diego'), ('Valeria'); -- (Lista reducida por brevedad, funciona igual)

DECLARE @Apellidos TABLE (Apellido VARCHAR(50));
INSERT INTO @Apellidos VALUES ('Perez'), ('Mamani'), ('Gomez'), ('Quispe'), ('Rodriguez'), ('Flores'), ('Fernandez');

DECLARE @Nacionalidades TABLE (Pais VARCHAR(50));
INSERT INTO @Nacionalidades VALUES ('Boliviana'), ('Argentina'), ('Brasileña'), ('Chilena'), ('Peruana');

DECLARE @p INT = 1;
WHILE @p <= 500
BEGIN
    DECLARE @Nom VARCHAR(50) = (SELECT TOP 1 Nombre FROM @Nombres ORDER BY NEWID());
    DECLARE @Ape VARCHAR(50) = (SELECT TOP 1 Apellido FROM @Apellidos ORDER BY NEWID());
    DECLARE @Nac VARCHAR(50) = (SELECT TOP 1 Pais FROM @Nacionalidades ORDER BY NEWID());
    DECLARE @CI VARCHAR(20) = CONCAT(10000 + @p, '-', CASE WHEN @p%2=0 THEN 'SC' ELSE 'LP' END);
    DECLARE @EdadRandom INT = 18 + (ABS(CHECKSUM(NEWID()) % 63)); 
    
    -- INSERT CON TIPO 'PASAJERO'
    INSERT INTO PERSONA (Nombre, Apellidos, CI_Documento, Celular, Tipo_Persona) 
    VALUES (@Nom, @Ape, @CI, CONCAT('7', 0000000 + @p), 'PASAJERO');
    
    DECLARE @ID_Pers INT = SCOPE_IDENTITY();

    INSERT INTO PASAJERO (ID_Pasajero, Nacionalidad, Edad) 
    VALUES (@ID_Pers, @Nac, @EdadRandom);
    
    SET @p = @p + 1;
END

-- ====================================================================================
-- PASO 4: GENERADOR DE ITINERARIOS Y VENTAS
-- ====================================================================================

DECLARE @FechaActual DATE = '2024-01-01';
DECLARE @FechaFin DATE = '2025-12-31';

WHILE @FechaActual <= @FechaFin
BEGIN
    -- Itinerarios
    INSERT INTO ITINERARIO (Fecha_Salida, Hora_Salida, Fecha_Llegada_Estimada, Hora_Llegada_Estimada, Estado)
    VALUES (@FechaActual, '08:00', @FechaActual, '22:00', 'FINALIZADO');
    DECLARE @Itin1 INT = SCOPE_IDENTITY();
    INSERT INTO TREN_ITINERARIO (ID_Tren, ID_Itinerario, ID_Ruta) VALUES ((ABS(CHECKSUM(NEWID()) % 10)+1), @Itin1, 1);
    
    INSERT INTO ITINERARIO (Fecha_Salida, Hora_Salida, Fecha_Llegada_Estimada, Hora_Llegada_Estimada, Estado)
    VALUES (@FechaActual, '18:00', DATEADD(DAY, 1, @FechaActual), '08:00', 'FINALIZADO');
    DECLARE @Itin2 INT = SCOPE_IDENTITY();
    INSERT INTO TREN_ITINERARIO (ID_Tren, ID_Itinerario, ID_Ruta) VALUES ((ABS(CHECKSUM(NEWID()) % 10)+1), @Itin2, 3);

    -- Ventas
    DECLARE @ClientesHoy INT = 20; 
    DECLARE @ContadorVentas INT = 1; 
    DECLARE @MinPasajero INT = (SELECT MIN(ID_Pasajero) FROM PASAJERO);
    DECLARE @MaxPasajero INT = (SELECT MAX(ID_Pasajero) FROM PASAJERO);

    WHILE @ContadorVentas <= @ClientesHoy
    BEGIN
        DECLARE @RutaElegida INT = CASE WHEN (ABS(CHECKSUM(NEWID()) % 2)) = 0 THEN 1 ELSE 3 END;
        DECLARE @ID_Tren_Uso INT = CASE WHEN @RutaElegida = 1 THEN (SELECT TOP 1 ID_Tren_Itinerario FROM TREN_ITINERARIO WHERE ID_Itinerario=@Itin1) ELSE (SELECT TOP 1 ID_Tren_Itinerario FROM TREN_ITINERARIO WHERE ID_Itinerario=@Itin2) END;
        
        DECLARE @CantBoletos INT = (ABS(CHECKSUM(NEWID()) % 4) + 1);
        DECLARE @Variacion DECIMAL(10,2) = (ABS(CHECKSUM(NEWID()) % 25));
        DECLARE @PrecioBase DECIMAL(10,2) = CASE WHEN @RutaElegida = 1 THEN 120 + @Variacion ELSE 130 + @Variacion END;
        DECLARE @Total DECIMAL(10,2) = @PrecioBase * @CantBoletos;

        INSERT INTO VENTA (ID_Cliente, ID_Empleado, Fecha_Emision, Monto_Total, Tipo_Documento, Es_Reserva)
        VALUES (
            (SELECT TOP 1 ID_Cliente FROM CLIENTE ORDER BY NEWID()), 
            (ABS(CHECKSUM(NEWID()) % 2) + 1), 
            CAST(@FechaActual AS DATETIME), 
            @Total, 
            'Factura', 
            0
        );
        DECLARE @ID_Venta INT = SCOPE_IDENTITY();

        INSERT INTO TRANSACCION (ID_Venta, ID_Metodo_Pago, Monto, Fecha_Pago) VALUES (@ID_Venta, 1, @Total, CAST(@FechaActual AS DATETIME));

        DECLARE @b INT = 1;
        WHILE @b <= @CantBoletos
        BEGIN
            DECLARE @PasajeroRandom INT = @MinPasajero + (ABS(CHECKSUM(NEWID()) % (@MaxPasajero - @MinPasajero)));
            DECLARE @AsientoRandom INT;
            
            SELECT TOP 1 @AsientoRandom = A.ID_Asiento
            FROM ASIENTO A, VAGON V, TREN T, TREN_ITINERARIO TI
            WHERE A.ID_Vagon = V.ID_Vagon
              AND V.ID_Tren = T.ID_Tren
              AND T.ID_Tren = TI.ID_Tren
              AND TI.ID_Tren_Itinerario = @ID_Tren_Uso
            ORDER BY NEWID();

            DECLARE @Destino INT = CASE WHEN @RutaElegida = 1 THEN 3 ELSE 8 END;

            INSERT INTO BOLETO (ID_Venta, ID_Pasajero, ID_Tren_Itinerario, ID_Asiento, ID_Estacion_Origen, ID_Estacion_Destino, Precio_Final, Estado)
            VALUES (@ID_Venta, @PasajeroRandom, @ID_Tren_Uso, @AsientoRandom, 1, @Destino, @PrecioBase, 'EMITIDO');

            IF (ABS(CHECKSUM(NEWID()) % 100) < 5)
            BEGIN
                DECLARE @ID_Bol INT = SCOPE_IDENTITY();
                INSERT INTO DEVOLUCION (ID_Boleto, ID_Tipo_Motivo, Monto_Reembolsado, Observacion)
                VALUES (@ID_Bol, 2, @PrecioBase, 'Cancelacion Random');
                UPDATE BOLETO SET Estado = 'CANCELADO' WHERE ID_Boleto = @ID_Bol;
            END
            SET @b = @b + 1;
        END
        SET @ContadorVentas = @ContadorVentas + 1;
    END
    SET @FechaActual = DATEADD(DAY, 1, @FechaActual);
END
GO