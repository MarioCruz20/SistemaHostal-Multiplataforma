Sistema de Gestión de Hostal

## Descripción

Sistema web para la gestión de un hostal desarrollado en Java (JSP + Servlets) con SQL Server, que permite administrar habitaciones, clientes, reservas y pagos.

## Características principales

- Autenticación de usuarios con control de acceso por roles (Administrador y Recepcionista)
- Manejo de sesiones
- CRUD de habitaciones, clientes, reservas y pagos
- Generación de reportes y gráficos
- Arquitectura MVC

## Capturas del sistema
### Vista de login (Login como admin)
<img width="1210" height="890" alt="Screenshot 2026-04-22 084152" src="https://github.com/user-attachments/assets/a01b9825-504d-4228-b10d-dd4333e38fc0" />

### Vista de dashboard
<img width="1220" height="888" alt="Screenshot 2026-04-22 084224" src="https://github.com/user-attachments/assets/85c41da5-eb39-4f43-88e9-5ae1459c3d10" />
### Control de acceso para roles (admin)
<img width="1220" height="888" alt="Screenshot 2026-04-22 084224" src="https://github.com/user-attachments/assets/28fb8ede-b2d5-400b-980f-48272b86d3fd" />

### Control de acceso para roles (recepcionista)
<img width="1220" height="891" alt="Screenshot 2026-04-22 084414" src="https://github.com/user-attachments/assets/f17910fe-f5fe-4325-af7b-f9237dd0170a" />

### Vista de habitaciones
<img width="1215" height="894" alt="Screenshot 2026-04-22 084236" src="https://github.com/user-attachments/assets/87ae3ee8-bbc0-456b-8f65-bddb439a085f" />

### Vista de gráficos
<img width="1205" height="892" alt="Screenshot 2026-04-22 084356" src="https://github.com/user-attachments/assets/c344125e-67a2-499c-b34d-4380a4fa8cff" />

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


## Instalación de JDK

1. Descargar JDK (versión 8 u 11 recomendada):
https://www.oracle.com/java/technologies/javase-downloads.html

2. Instalar el JDK siguiendo los pasos del instalador

3. Verificar instalación abriendo una terminal:

```bash
java -version
```
---
## Instalación de Apache Tomcat 9

1. Ir a:
https://tomcat.apache.org/

2. Seleccionar "Tomcat 9" en la sección de descargas

3. Descargar:
"64-bit Windows zip"

4. Descomprimir el archivo

5. Renombrar la carpeta a:
webserver

6. Mover la carpeta a:
C:\webserver

## Configuración de Apache Tomcat en NetBeans

1. Abrir Apache NetBeans

2. Ir a la pestaña "Services" (Servicios)

3. Clic derecho en "Servers"

4. Seleccionar "Add Server..."

5. Elegir:
Apache Tomcat or TomEE

6. En "Server Location":
- Seleccionar la carpeta:
  C:\webserver

7. Marcar:
- Use Private Configuration Folder (Catalina Base)
- Volver a seleccionar la carpeta:
  C:\webserver


9. Ingresar:
  - Username
  - Password  
(Marcar "Create user if it doesn't exist")

10. Seleccionar **"Finish"** para finalizar la configuración

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


## Configuración de Conexión por direccón IP

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
