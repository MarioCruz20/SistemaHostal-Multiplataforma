# Sistema de Gestión de Hostal

## Descripción

Aplicación multiplataforma desarrollada en Java para la gestión de un hostal.
Permite administrar habitaciones, clientes, reservas y pagos mediante una conexión a una base de datos SQL Server.

## Funcionalidades del Sistema

El sistema permite gestionar las operaciones principales de un hostal mediante diferentes módulos:

###  Habitaciones
- Registro de nuevas habitaciones
- Configuración de:
  - Número
  - Tipo
  - Capacidad
  - Precio
  - Estado
  - Servicios adicionales
- Búsqueda y filtrado por número, tipo o estado

### Huéspedes
- Registro de clientes
- Filtrar por nombre, DUI, teléfono o email

###  Reservas
- Creación de reservas
- Asociación de clientes y habitaciones
- Control de fechas de entrada y salida

###  Pagos
- Registro de pagos asociados a reservas
- Control de estados de pago

### Usuarios / Roles
- Creación de acceso a usuarios

### Proveedores
- Creación para registro de proveedores

### Reportes
- Generación de reportes de reservas por fechas

### Gráficos
-Resumen con gráficos que muestran:
   - Ocupación por mes
   - Ingresos por habitaciones
   - Servicios adicionales más vendidos

---

## Requisitos

* Java JDK 17 o superior
* Apache Tomcat 9
* SQL Server
* SQL Server Management Studio (SSMS)
* Conexión a la misma red local que el servidor de base de datos

## Instalación de la Base de Datos

Puedes configurar la base de datos utilizando cualquiera de las siguientes opciones:

### Opción 1: Usando archivo `.sql`

1. Abrir **SQL Server Management Studio**.
2. Crear o seleccionar una instancia de SQL Server.
3. Importar el archivo de base de datos proporcionado (`proyecto-copia.sql`).

###  Opción 2: Restaurar desde archivo `.bak`

1. Abrir **SQL Server Management Studio (SSMS)**.
2. Conectarse a tu servidor de SQL Server.
3. Dar clic derecho en **Databases** → **Restore Database...**
4. Seleccionar la opción **Device** y luego clic en `...`
5. Agregar el archivo `HostalDB.bak`
6. Presionar **OK** y luego **Restore**

---
##  Configuración de Usuario de Base de Datos

El sistema requiere un usuario de SQL Server con permisos sobre la base de datos `HostalDB`.

### Recomendado: Usar un usuario existente

Puedes utilizar un usuario ya creado en tu servidor SQL Server.  
Solo asegúrate de colocar sus credenciales en el archivo:

DAMPproyecto/src/main/java/misClases/ConexionDB.java

---

## Configuración en Modo Local (Misma PC)

Si deseas ejecutar el sistema en una sola computadora (sin red local), puedes usar `localhost` en lugar de una dirección IP.

1. Ir al archivo:
   ```
   DAMPproyecto/src/main/java/misClases/ConexionDB.java
   ```

2. Configurar la conexión de la siguiente manera:
```
private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=HostalDB;encrypt=false";
private static final String USER = "TU_USUARIO";
private static final String PASSWORD = "TU_CONTRASEÑA";
```


> Asegúrate de que SQL Server esté en ejecución en tu máquina local.


## Configuración de Conexión Multiplataforma

El proyecto requiere conectarse a la base de datos mediante la **dirección IP del servidor**  donde esté el servidor SQL Server con la base de datos HostalDB dentro de la misma red.

1. Ir al archivo:

```
DAMPproyecto/src/main/java/misClases/ConexionDB.java
```

2. Modificar los siguientes valores:

* **Línea 11**: colocar la dirección IP de la PC donde se encuentre el servidor SQL Server.

```
jdbc:sqlserver://IP_DEL_SERVIDOR:1433;databaseName=HostalDB;encrypt=false
```

* **Línea 13**: colocar el nombre de usuario de SQL Server.
* **Línea 14**: colocar la contraseña del usuario.

Ejemplo:

```
private static final String URL = "jdbc:sqlserver://192.168.58.100:1433;databaseName=HostalDB;encrypt=false";
private static final String USER = "TU_USUARIO";
private static final String PASSWORD = "TU_CONTRASEÑA";
```

## Ejecución

1. Abrir el proyecto en el IDE Apache NetBeans.
2. Compilar el proyecto.
3. Ejecutar la clase principal.

## Acceso al Sistema

El sistema cuenta con dos tipos de usuario con diferentes niveles de acceso:

###  Administrador
- **Usuario:** `admin`
- **Contraseña:** `Admin123`

**Permisos:**
- Dashboard
- Habitaciones
- Huéspedes
- Reservas
- Pagos
- Empleados
- Usuarios / Roles
- Reportes
- Gráficos
---

### 🧾 Recepcionista
- **Usuario:** `recepcion`
- **Contraseña:** `Recepcion123`

**Permisos:**
- Dashboard
- Habitaciones
- Huéspedes
- Reservas
- Pagos

---


## Notas

* El servidor SQL Server debe permitir conexiones remotas.
* Las computadoras deben estar conectadas a la misma red local.
