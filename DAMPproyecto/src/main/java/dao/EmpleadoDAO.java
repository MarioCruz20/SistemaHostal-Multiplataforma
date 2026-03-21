/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author cresp
 */
import misClases.ConexionBD;
import model.Empleado;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {

    public List<Empleado> listar(String q) {
        List<Empleado> list = new ArrayList<>();
        String sql
                = "SELECT Id, Nombre, DUI, Telefono, Email, Puesto, FechaContratacion, Estado "
                + "FROM Empleados "
                + "WHERE (? IS NULL OR ? = '' OR Nombre LIKE ? OR DUI LIKE ? OR Puesto LIKE ?) "
                + "ORDER BY Nombre";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, q);
            ps.setString(2, q);
            String like = q == null ? null : "%" + q + "%";
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Empleado e = new Empleado();
                    e.setId(rs.getInt("Id"));
                    e.setNombre(rs.getString("Nombre"));
                    e.setDui(rs.getString("DUI"));
                    e.setTelefono(rs.getString("Telefono"));
                    e.setEmail(rs.getString("Email"));
                    e.setPuesto(rs.getString("Puesto"));
                    e.setFechaContratacion(rs.getDate("FechaContratacion"));
                    e.setEstado(rs.getBoolean("Estado"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Empleado obtener(int id) {
        String sql = "SELECT * FROM Empleados WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Empleado e = new Empleado();
                    e.setId(rs.getInt("Id"));
                    e.setNombre(rs.getString("Nombre"));
                    e.setDui(rs.getString("DUI"));
                    e.setTelefono(rs.getString("Telefono"));
                    e.setEmail(rs.getString("Email"));
                    e.setPuesto(rs.getString("Puesto"));
                    e.setFechaContratacion(rs.getDate("FechaContratacion"));
                    e.setEstado(rs.getBoolean("Estado"));
                    return e;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean crear(Empleado e) {
        String sql
                = "INSERT INTO Empleados (Nombre, DUI, Telefono, Email, Puesto, FechaContratacion, Estado) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDui());
            ps.setString(3, e.getTelefono());
            ps.setString(4, e.getEmail());
            ps.setString(5, e.getPuesto());
            ps.setDate(6, e.getFechaContratacion());
            ps.setBoolean(7, e.getEstado() == null ? true : e.getEstado());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Empleado e) {
        String sql
                = "UPDATE Empleados SET Nombre=?, DUI=?, Telefono=?, Email=?, Puesto=?, FechaContratacion=?, Estado=? "
                + "WHERE Id=?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDui());
            ps.setString(3, e.getTelefono());
            ps.setString(4, e.getEmail());
            ps.setString(5, e.getPuesto());
            ps.setDate(6, e.getFechaContratacion());
            ps.setBoolean(7, e.getEstado() == null ? true : e.getEstado());
            ps.setInt(8, e.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        // Verificar si tiene usuarios asociados
        String sqlCheck = "SELECT COUNT(*) FROM Usuarios WHERE EmpleadoId = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement psCheck = cn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, id);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Tiene usuarios asociados, no se puede eliminar
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Si no tiene usuarios, proceder con la eliminación
        String sql = "DELETE FROM Empleados WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
    
    public int contarUsuarios(int empleadoId) {
        String sql = "SELECT COUNT(*) FROM Usuarios WHERE EmpleadoId = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, empleadoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
