package dao;

import misClases.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProveedorDAO {

    public List<Map<String, String>> listar(String q, String telefono, String email) {
        List<Map<String, String>> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT Id, Nombre, Contacto, Telefono, Email, Direccion " +
            "FROM Proveedores WHERE 1=1 "
        );
        
        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (Nombre LIKE ? OR Contacto LIKE ?) ");
        }
        if (telefono != null && !telefono.trim().isEmpty()) {
            sql.append("AND Telefono LIKE ? ");
        }
        if (email != null && !email.trim().isEmpty()) {
            sql.append("AND Email LIKE ? ");
        }
        
        sql.append("ORDER BY Nombre");
        
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (q != null && !q.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + q + "%");
                ps.setString(paramIndex++, "%" + q + "%");
            }
            if (telefono != null && !telefono.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + telefono + "%");
            }
            if (email != null && !email.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + email + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", String.valueOf(rs.getInt("Id")));
                    p.put("nombre", rs.getString("Nombre") != null ? rs.getString("Nombre") : "");
                    p.put("contacto", rs.getString("Contacto") != null ? rs.getString("Contacto") : "");
                    p.put("telefono", rs.getString("Telefono") != null ? rs.getString("Telefono") : "");
                    p.put("email", rs.getString("Email") != null ? rs.getString("Email") : "");
                    p.put("direccion", rs.getString("Direccion") != null ? rs.getString("Direccion") : "");
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, String> obtener(int id) {
        String sql = "SELECT Id, Nombre, Contacto, Telefono, Email, Direccion FROM Proveedores WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", String.valueOf(rs.getInt("Id")));
                    p.put("nombre", rs.getString("Nombre") != null ? rs.getString("Nombre") : "");
                    p.put("contacto", rs.getString("Contacto") != null ? rs.getString("Contacto") : "");
                    p.put("telefono", rs.getString("Telefono") != null ? rs.getString("Telefono") : "");
                    p.put("email", rs.getString("Email") != null ? rs.getString("Email") : "");
                    p.put("direccion", rs.getString("Direccion") != null ? rs.getString("Direccion") : "");
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean crear(String nombre, String contacto, String telefono, String email, String direccion) {
        String sql = "INSERT INTO Proveedores (Nombre, Contacto, Telefono, Email, Direccion) VALUES (?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, contacto);
            ps.setString(3, telefono);
            ps.setString(4, email);
            ps.setString(5, direccion);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(int id, String nombre, String contacto, String telefono, String email, String direccion) {
        String sql = "UPDATE Proveedores SET Nombre=?, Contacto=?, Telefono=?, Email=?, Direccion=? WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, contacto);
            ps.setString(3, telefono);
            ps.setString(4, email);
            ps.setString(5, direccion);
            ps.setInt(6, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM Proveedores WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}



