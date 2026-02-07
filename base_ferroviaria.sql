--hola rosa

-- 1. CREACIÓN DE LA BASE DE DATOS
--drop database FerroviariaDB;
CREATE DATABASE FerroviariaDB;
GO
USE FerroviariaDB;
GO

---=============================================
-- MÓDULO 1: INFRAESTRUCTURA GEOGRÁFICA Y RUTAS
-- =============================================

CREATE TABLE DEPARTAMENTO (
    ID_Departamento INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE CIUDAD (
    ID_Ciudad INT PRIMARY KEY IDENTITY(1,1),
    ID_Departamento INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Departamento) REFERENCES DEPARTAMENTO(ID_Departamento)
);

CREATE TABLE ESTACION (
    ID_Estacion INT PRIMARY KEY IDENTITY(1,1),
    ID_Ciudad INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Capacidad_Vias INT DEFAULT 2,
    FOREIGN KEY (ID_Ciudad) REFERENCES CIUDAD(ID_Ciudad)
);

CREATE TABLE RUTA (
    ID_Ruta INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Ruta VARCHAR(100) NOT NULL -- Ej: "Expreso Oriental"
);

CREATE TABLE TRAMO (
    ID_Tramo INT PRIMARY KEY IDENTITY(1,1),
    
    -- Relación Recursiva (Padre - Hijo)
    ID_Tramo_Padre INT NULL, -- Puede ser NULL si es un tramo principal (El Padre)
    
    Nombre VARCHAR(100), -- Ej: "Oruro - Uyuni"
    Distancia_Km DECIMAL(10,2),
    Tiempo_Estimado TIME,
    Precio DECIMAL(10,2) NOT NULL,
    
    -- Definición de la auto-referencia
    FOREIGN KEY (ID_Tramo_Padre) REFERENCES TRAMO(ID_Tramo)
);

-- Tabla intermedia para definir qué tramos componen una ruta
CREATE TABLE RUTA_TRAMO (
    ID_Ruta_Tramo INT PRIMARY KEY IDENTITY(1,1),
    ID_Ruta INT NOT NULL,
    ID_Tramo INT NOT NULL,
    ID_Estacion_Origen INT NOT NULL,
    ID_Estacion_Destino INT NOT NULL,
    Orden_Secuencia INT NOT NULL, -- 1, 2, 3...

    FOREIGN KEY (ID_Ruta) REFERENCES RUTA(ID_Ruta),
    FOREIGN KEY (ID_Tramo) REFERENCES TRAMO(ID_Tramo),
    FOREIGN KEY (ID_Estacion_Origen) REFERENCES ESTACION(ID_Estacion),
    FOREIGN KEY (ID_Estacion_Destino) REFERENCES ESTACION(ID_Estacion)
);

-- =============================================
-- MÓDULO 2: TRENES Y VAGONES
-- =============================================

CREATE TABLE TREN (
    ID_Tren INT PRIMARY KEY IDENTITY(1,1),
    Codigo_Identificador VARCHAR(50) UNIQUE NOT NULL,
    Modelo VARCHAR(50),
    Fecha_Fabricacion DATE,
    Velocidad_Max DECIMAL(5,2),
    Estado VARCHAR(20) DEFAULT 'OPERATIVO' -- 'MANTENIMIENTO', 'BAJA'
);

CREATE TABLE TIPO_VAGON (
    ID_Tipo_Vagon INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50), -- 'Cama', 'Semicama', 'Comedor'
    Precio_Base_Factor DECIMAL(10,2) -- Factor multiplicador de precio
);

CREATE TABLE VAGON (
    ID_Vagon INT PRIMARY KEY IDENTITY(1,1),
    ID_Tren INT, -- Un vagón pertenece a un tren (o puede ser null si está en patio)
    ID_Tipo_Vagon INT NOT NULL,
    Capacidad_Asientos INT NOT NULL,
    FOREIGN KEY (ID_Tren) REFERENCES TREN(ID_Tren),
    FOREIGN KEY (ID_Tipo_Vagon) REFERENCES TIPO_VAGON(ID_Tipo_Vagon)
);

CREATE TABLE ASIENTO (
    ID_Asiento INT PRIMARY KEY IDENTITY(1,1),
    ID_Vagon INT NOT NULL,
    Numero_Asiento VARCHAR(10) NOT NULL, -- "4A", "4B"
    Ubicacion VARCHAR(20), -- 'VENTANA', 'PASILLO'
    FOREIGN KEY (ID_Vagon) REFERENCES VAGON(ID_Vagon)
);

-- =============================================
-- MÓDULO 3: PERSONAS Y ROLES (HERENCIA)
-- =============================================

-- Tabla Padre
CREATE TABLE PERSONA (
    ID_Persona INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    CI_Documento VARCHAR(20) UNIQUE NOT NULL,
    Celular VARCHAR(20),
    Email VARCHAR(100), 
    Tipo_Persona VARCHAR(20) NOT NULL CHECK (Tipo_Persona IN ('CLIENTE', 'PASAJERO', 'EMPLEADO'))
);

-- Subtipos (Herencia 1:1)
CREATE TABLE CLIENTE (
    ID_Cliente INT PRIMARY KEY, -- Es PK y FK a la vez
    Nit VARCHAR(20),
    Razon_Social VARCHAR(100),
    FOREIGN KEY (ID_Cliente) REFERENCES PERSONA(ID_Persona)
);

CREATE TABLE PASAJERO (
    ID_Pasajero INT PRIMARY KEY,
    Nacionalidad VARCHAR(50),
    Edad INT, -- Para calcular edad
    FOREIGN KEY (ID_Pasajero) REFERENCES PERSONA(ID_Persona)
);

CREATE TABLE ROL (
    ID_Rol INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL, -- 'Taquillero', 'Conductor'
    Descripcion VARCHAR(200),
    Sueldo_Base DECIMAL(10,2) NOT NULL
);

CREATE TABLE EMPLEADO (
    ID_Empleado INT PRIMARY KEY,
    ID_Rol INT NOT NULL,
    Fecha_Contratacion DATE DEFAULT GETDATE(),
    FOREIGN KEY (ID_Empleado) REFERENCES PERSONA(ID_Persona),
    FOREIGN KEY (ID_Rol) REFERENCES ROL(ID_Rol)
);

-- =============================================
-- MÓDULO 4: OPERACIONES Y PROGRAMACIÓN
-- =============================================

CREATE TABLE ITINERARIO (
    ID_Itinerario INT PRIMARY KEY IDENTITY(1,1),
    Fecha_Salida DATE NOT NULL,
    Hora_Salida TIME NOT NULL,
    Fecha_Llegada_Estimada DATE NOT NULL,
    Hora_Llegada_Estimada TIME NOT NULL,
    Estado VARCHAR(20) DEFAULT 'PROGRAMADO' -- 'EN CURSO', 'FINALIZADO', 'CANCELADO'
);

CREATE TABLE TREN_ITINERARIO (
    ID_Tren_Itinerario INT PRIMARY KEY IDENTITY(1,1),
    ID_Tren INT NOT NULL,
    ID_Itinerario INT NOT NULL,
    ID_Ruta INT NOT NULL, -- Vincula el tren a una ruta específica en una fecha
    --Precio_Base_Ruta DECIMAL(10,2),
    FOREIGN KEY (ID_Tren) REFERENCES TREN(ID_Tren),
    FOREIGN KEY (ID_Itinerario) REFERENCES ITINERARIO(ID_Itinerario),
    FOREIGN KEY (ID_Ruta) REFERENCES RUTA(ID_Ruta)
);

-- =============================================
-- MÓDULO 5: FINANZAS Y COMERCIAL (El Tridente)
-- =============================================

CREATE TABLE METODO_PAGO (
    ID_Metodo INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) -- 'Efectivo', 'QR', 'Tarjeta'
);

-- Tabla para controlar Salarios (Egresos Mensuales)
CREATE TABLE SALARIO (
    ID_Salario INT PRIMARY KEY IDENTITY(1,1),
    ID_Empleado INT NOT NULL,
    Fecha_Pago DATE DEFAULT GETDATE(),
    Mes_Pagado VARCHAR(20), -- 'Enero 2026'
    Monto_Total DECIMAL(10,2) NOT NULL,
    Descuentos DECIMAL(10,2) DEFAULT 0,
    Bonos DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
);

-- Tabla de Reservas (Control de Tiempo)
CREATE TABLE RESERVA (
    ID_Reserva INT PRIMARY KEY IDENTITY(1,1),
    ID_Cliente INT NOT NULL,
    Fecha_Reserva DATETIME DEFAULT GETDATE(),
    Fecha_Vencimiento DATETIME NOT NULL,
    Estado VARCHAR(20) DEFAULT 'PENDIENTE', -- 'PENDIENTE', 'COMPLETADA', 'VENCIDA', 'CANCELADA'
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

-- Tabla de Ventas (Control de Dinero/Facturación)
CREATE TABLE VENTA (
    ID_Venta INT PRIMARY KEY IDENTITY(1,1),
    ID_Cliente INT NOT NULL,
    ID_Empleado INT NOT NULL, -- Taquillero
    Fecha_Emision DATETIME DEFAULT GETDATE(),
    Monto_Total DECIMAL(10,2) NOT NULL CHECK (Monto_Total >= 0),
    Tipo_Documento VARCHAR(30), -- 'Recibo Anticipo', 'Factura Final'
    Nit_Factura VARCHAR(20),
    Razon_Social VARCHAR(100),
    Es_Reserva BIT DEFAULT 0, -- 1 si es el pago parcial, 0 si es total
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente),
    FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADO(ID_Empleado)
);

CREATE TABLE TRANSACCION (
    ID_Transaccion INT PRIMARY KEY IDENTITY(1,1),
    ID_Venta INT NOT NULL,
    ID_Metodo_Pago INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    Fecha_Pago DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ID_Venta) REFERENCES VENTA(ID_Venta),
    FOREIGN KEY (ID_Metodo_Pago) REFERENCES METODO_PAGO(ID_Metodo)
);

-- =============================================
-- MÓDULO 6: EL BOLETO (Tabla Maestra)
-- =============================================

CREATE TABLE BOLETO (
    ID_Boleto INT PRIMARY KEY IDENTITY(1,1),
    
    -- Relaciones Comerciales
    ID_Venta INT NOT NULL,
    ID_Reserva INT NULL, -- Puede ser NULL si compra directo sin reservar
    
    -- Relaciones Operativas
    ID_Pasajero INT NOT NULL,
    ID_Tren_Itinerario INT NOT NULL, -- Define el viaje
    ID_Asiento INT NOT NULL,
    
    -- Gestión de Escalas (Origen y Destino específicos del pasajero)
    ID_Estacion_Origen INT NOT NULL,
    ID_Estacion_Destino INT NOT NULL,
    
    -- Datos del Boleto
    Numero_Boleto VARCHAR(50),
    Precio_Final DECIMAL(10,2) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'EMITIDO', -- 'RESERVADO', 'EMITIDO', 'USADO', 'CANCELADO'
    
    -- Llaves Foráneas
    FOREIGN KEY (ID_Venta) REFERENCES VENTA(ID_Venta),
    FOREIGN KEY (ID_Reserva) REFERENCES RESERVA(ID_Reserva),
    FOREIGN KEY (ID_Pasajero) REFERENCES PASAJERO(ID_Pasajero),
    FOREIGN KEY (ID_Tren_Itinerario) REFERENCES TREN_ITINERARIO(ID_Tren_Itinerario),
    FOREIGN KEY (ID_Asiento) REFERENCES ASIENTO(ID_Asiento),
    FOREIGN KEY (ID_Estacion_Origen) REFERENCES ESTACION(ID_Estacion), -- FK a Estación de subida
    FOREIGN KEY (ID_Estacion_Destino) REFERENCES ESTACION(ID_Estacion) -- FK a Estación de bajada
);

-- =============================================
-- MÓDULO 7: DEVOLUCIONES (Egresos Variables)
-- =============================================

-- tabla para catalogar los motivos (Ej: 'Salud', 'Cancelación Tren', 'Error Venta

CREATE TABLE TIPO_MOTIVO (
    ID_Tipo_Motivo INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL, 
    Descripcion VARCHAR(200) -- Opcional para explicar en qué casos aplica
);

---Tabla de Devoluciones actualizada
CREATE TABLE DEVOLUCION (
    ID_Devolucion INT PRIMARY KEY IDENTITY(1,1),
    ID_Boleto INT NOT NULL UNIQUE, -- Relación 1 a 1: Un boleto solo se devuelve una vez
    ID_Tipo_Motivo INT NOT NULL,   -- FK: Clasificación del motivo
    Fecha_Solicitud DATETIME DEFAULT GETDATE(),
    Monto_Reembolsado DECIMAL(10,2) NOT NULL,
    Observacion VARCHAR(200),      -- Detalle específico (Ej: "Cliente presentó certificado médico")
    Estado VARCHAR(20) DEFAULT 'APROBADO',
    
    FOREIGN KEY (ID_Boleto) REFERENCES BOLETO(ID_Boleto),
    FOREIGN KEY (ID_Tipo_Motivo) REFERENCES TIPO_MOTIVO(ID_Tipo_Motivo)
);


GO