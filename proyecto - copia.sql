-- Crear base de datos y usarla
IF DB_ID('HostalDB') IS NULL
BEGIN
    CREATE DATABASE HostalDB;
END
GO
USE HostalDB;
GO

-- 1) Roles para RBAC
CREATE TABLE Roles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255) NULL
);
GO

-- Roles por defecto
IF NOT EXISTS (SELECT 1 FROM Roles WHERE Nombre = 'admin')
BEGIN
    INSERT INTO Roles (Nombre, Descripcion) VALUES ('admin','Administrador del sistema');
END
IF NOT EXISTS (SELECT 1 FROM Roles WHERE Nombre = 'usuario')
BEGIN
    INSERT INTO Roles (Nombre, Descripcion) VALUES ('usuario','Usuario de negocio');
END
GO

-- 2) Empleados
CREATE TABLE Empleados (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    DUI NVARCHAR(12) UNIQUE NULL,
    Telefono NVARCHAR(20) NULL,
    Email NVARCHAR(100) NULL,
    Puesto NVARCHAR(50) NULL,
    FechaContratacion DATE NULL,
    Estado BIT DEFAULT 1
);
GO

-- 3) Usuarios (con enlace a Empleados y Rol)
CREATE TABLE Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Usuario NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL, -- HASH de contraseña (ej., BCrypt)
    RolId INT NOT NULL FOREIGN KEY REFERENCES Roles(Id),
    EmpleadoId INT NULL FOREIGN KEY REFERENCES Empleados(Id),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Estado BIT DEFAULT 1
);
GO

-- 4) Habitaciones
CREATE TABLE Habitaciones (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Numero NVARCHAR(10) UNIQUE NOT NULL,
    Tipo NVARCHAR(20) NOT NULL CHECK (Tipo IN ('individual','doble','familiar','suite')),
    Capacidad INT NOT NULL,
    PrecioDia DECIMAL(10,2) NOT NULL,
    PrecioNoche DECIMAL(10,2) NOT NULL,
    PrecioFinSemana DECIMAL(10,2) NOT NULL,
    Estado NVARCHAR(20) NOT NULL CHECK (Estado IN ('disponible','ocupada','limpieza','mantenimiento')),
    Servicios NVARCHAR(500) NULL,
    Imagen NVARCHAR(255) NULL
);
GO

-- 5) Huéspedes
CREATE TABLE Huéspedes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE NULL,
    Direccion NVARCHAR(500) NULL,
    Sexo CHAR(1) NULL CHECK (Sexo IN ('M','F','O')),
    Telefono NVARCHAR(20) NULL,
    DUI NVARCHAR(12) UNIQUE NULL,
    Email NVARCHAR(100) NULL,
    VisitasPrevias INT DEFAULT 0
);
GO

-- 6) Proveedores
CREATE TABLE Proveedores (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Contacto NVARCHAR(100) NULL,
    Telefono NVARCHAR(20) NULL,
    Email NVARCHAR(100) NULL,
    Direccion NVARCHAR(200) NULL
);
GO

-- 7) Reservas
CREATE TABLE Reservas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    HuespedId INT NULL FOREIGN KEY REFERENCES Huéspedes(Id),
    HabitacionId INT NULL FOREIGN KEY REFERENCES Habitaciones(Id),
    FechaEntrada DATE NOT NULL,
    FechaSalida DATE NOT NULL,
    Estado NVARCHAR(20) NOT NULL CHECK (Estado IN ('pendiente','confirmada','cancelada','completada')),
    NumeroHuespedes INT NOT NULL,
    Observaciones NVARCHAR(2000) NULL
);
GO

-- 8) Pagos
CREATE TABLE Pagos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ReservaId INT NOT NULL FOREIGN KEY REFERENCES Reservas(Id),
    Monto DECIMAL(12,2) NOT NULL,
    FormaPago NVARCHAR(50) NOT NULL,
    TipoPago NVARCHAR(50) NOT NULL,
    FechaPago DATETIME DEFAULT GETDATE()
);
GO

-- 9) Módulo de inventario (productos) y proveedores (ejemplo general)
CREATE TABLE Productos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProveedorId INT NULL FOREIGN KEY REFERENCES Proveedores(Id),
    Codigo NVARCHAR(50) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Categoria NVARCHAR(50) NULL,
    UnidadMedida NVARCHAR(20) NULL,
    Descripcion NVARCHAR(500) NULL,
    Stock INT DEFAULT 0,
    PrecioCosto DECIMAL(12,2) NULL,
    PrecioVenta DECIMAL(12,2) NULL,
    Estado BIT DEFAULT 1
);
GO

-- Índices para rendimiento
CREATE INDEX IX_Reservas_Habitacion_Fecha ON Reservas (HabitacionId, FechaEntrada, FechaSalida);
CREATE INDEX IX_Huéspedes_DUI ON Huéspedes (DUI);
CREATE INDEX IX_Productos_Proveedor ON Productos (ProveedorId);
GO

-- Vista útil para auditoría/consulta rápida de usuarios activos
CREATE VIEW VistaActivosUsuarios AS
SELECT U.Id AS UsuarioId, U.Usuario, R.Nombre AS RolNombre, E.Nombre AS EmpleadoNombre
FROM Usuarios U
LEFT JOIN Roles R ON U.RolId = R.Id
LEFT JOIN Empleados E ON U.EmpleadoId = E.Id
WHERE U.Estado = 1;
GO


select * from roles


INSERT INTO Empleados (Nombre, DUI, Telefono, Email, Puesto, FechaContratacion, Estado)
VALUES
('Administrador General', '01234567-8', '7000-0001', 'admin@hostal.com', 'Administrador', GETDATE(), 1),

('Recepcionista Principal', '12345678-9', '7000-0002', 'recepcion@hostal.com', 'Recepcionista', GETDATE(), 1);

DECLARE @rolAdmin INT = (SELECT Id FROM Roles WHERE Nombre='admin');
DECLARE @rolUser INT  = (SELECT Id FROM Roles WHERE Nombre='usuario');

DECLARE @empAdmin INT = (SELECT Id FROM Empleados WHERE Nombre='Administrador General');
DECLARE @empRec INT   = (SELECT Id FROM Empleados WHERE Nombre='Recepcionista Principal');

INSERT INTO Usuarios (Usuario, PasswordHash, RolId, EmpleadoId, Estado)
VALUES (
    'admin',
    'Admin123',
    @rolAdmin,
    @empAdmin,
    1
);
DECLARE @rolAdmin INT = (SELECT Id FROM Roles WHERE Nombre='admin');
DECLARE @rolUser INT  = (SELECT Id FROM Roles WHERE Nombre='usuario');

DECLARE @empAdmin INT = (SELECT Id FROM Empleados WHERE Nombre='Administrador General');
DECLARE @empRec INT   = (SELECT Id FROM Empleados WHERE Nombre='Recepcionista Principal');

INSERT INTO Usuarios (Usuario, PasswordHash, RolId, EmpleadoId, Estado)
VALUES (
    'recepcion',
    'Recepcion123',
    @rolUser,
    @empRec,
    1
);

delete Usuarios from Usuarios


select * from Usuarios, Empleados

SELECT Usuario, PasswordHash, Estado
FROM Usuarios;

select * from Roles


UPDATE Usuarios
SET PasswordHash = '$2a$10$ksHomSb8mjMf.EmMV76DlOwhd7IA.sTcHwMC57D6yiw9pNpguNQBy'
WHERE Usuario = 'admin';

USE HostalDB;
GO

UPDATE Usuarios
SET PasswordHash = 'Admin123', Estado = 1
WHERE Usuario = 'admin';



select * from Habitaciones


select * from Proveedores

