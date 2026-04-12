# Sistema de Gestión de Hostal

## Descripción

Aplicación multiplataforma desarrollada en Java para la gestión de un hostal.
Permite administrar habitaciones, clientes, reservas y pagos mediante una conexión a una base de datos SQL Server.

## Requisitos

* Java JDK 17 o superior
* Apache Tomcat 9
* SQL Server
* SQL Server Management Studio (SSMS)
* Conexión a la misma red local que el servidor de base de datos

## Instalación de la Base de Datos

1. Abrir **SQL Server Management Studio**.
2. Crear o seleccionar una instancia de SQL Server.
3. Importar el archivo de base de datos proporcionado (`proyecto-copia.sql`).

## Configuración de Conexión

El proyecto requiere conectarse a la base de datos mediante la **dirección IP del servidor** dentro de la misma red.

1. Ir al archivo:

```
DAMPproyecto/src/main/java/misClases/ConexionDB.java
```

2. Modificar los siguientes valores:

* **Línea 11**: colocar la dirección IP del servidor SQL Server.

```
jdbc:sqlserver://IP_DEL_SERVIDOR:1433;databaseName=HostalDB;encrypt=false
```

* **Línea 13**: colocar el nombre de usuario de SQL Server.
* **Línea 14**: colocar la contraseña del usuario.

Ejemplo:

```
private static final String URL = "jdbc:sqlserver://192.168.58.100:1433;databaseName=HostalDB;encrypt=false";
private static final String USER = "admin";
private static final String PASSWORD = "12345";
```

## Ejecución

1. Abrir el proyecto en el IDE (NetBeans / IntelliJ / Eclipse).
2. Compilar el proyecto.
3. Ejecutar la clase principal.

## Notas

* El servidor SQL Server debe permitir conexiones remotas.
* Las computadoras deben estar conectadas a la misma red local.
