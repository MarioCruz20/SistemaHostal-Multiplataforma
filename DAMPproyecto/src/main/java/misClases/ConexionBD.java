/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package misClases;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionBD {

    private static final String URL = "jdbc:sqlserver://DESKTOP-BNQVQ6M:1433;databaseName=HostalDB;encrypt=false;";
    private static final String USER = "sa";       
    private static final String PASS = "1234";

    public static Connection conectar() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            throw new RuntimeException("Error al conectar a SQL Server: " + e.getMessage(), e);
        }
    }
}
