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
import model.Huesped;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HuespedDAO {

    private Huesped map(ResultSet rs) throws SQLException {
        Huesped h = new Huesped();
        h.setId(rs.getInt("Id"));
        h.setNombre(rs.getString("Nombre"));
        h.setFechaNacimiento(rs.getDate("FechaNacimiento"));
        h.setDireccion(rs.getString("Direccion"));
        h.setSexo(rs.getString("Sexo"));
        h.setTelefono(rs.getString("Telefono"));
        h.setDui(rs.getString("DUI"));
        h.setEmail(rs.getString("Email"));
        h.setVisitasPrevias((Integer) rs.getObject("VisitasPrevias"));
        return h;
    }

    /**
     * Listado con filtro simple por nombre/dui/teléfono
     */
    public List<Huesped> listar(String q) {
        List<Huesped> list = new ArrayList<>();
        String sql
                = "SELECT Id, Nombre, FechaNacimiento, Direccion, Sexo, Telefono, DUI, Email, VisitasPrevias "
                + "FROM [Huéspedes] "
                + "WHERE (? IS NULL OR ? = '' OR Nombre LIKE ? OR DUI LIKE ? OR Telefono LIKE ?) "
                + "ORDER BY Nombre";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            String like = (q == null) ? "" : "%" + q + "%";
            ps.setString(1, q);
            ps.setString(2, q);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Huesped obtener(int id) {
        String sql = "SELECT * FROM [Huéspedes] WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean crear(Huesped h) {
        String sql = "INSERT INTO [Huéspedes] (Nombre, FechaNacimiento, Direccion, Sexo, Telefono, DUI, Email, VisitasPrevias) "
                + "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNombre());
            ps.setDate(2, h.getFechaNacimiento());
            ps.setString(3, h.getDireccion());
            ps.setString(4, h.getSexo());
            ps.setString(5, h.getTelefono());
            ps.setString(6, h.getDui());
            ps.setString(7, h.getEmail());
            ps.setObject(8, h.getVisitasPrevias());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Huesped h) {
        String sql = "UPDATE [Huéspedes] SET Nombre=?, FechaNacimiento=?, Direccion=?, Sexo=?, Telefono=?, DUI=?, Email=?, VisitasPrevias=? "
                + "WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNombre());
            ps.setDate(2, h.getFechaNacimiento());
            ps.setString(3, h.getDireccion());
            ps.setString(4, h.getSexo());
            ps.setString(5, h.getTelefono());
            ps.setString(6, h.getDui());
            ps.setString(7, h.getEmail());
            ps.setObject(8, h.getVisitasPrevias());
            ps.setInt(9, h.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        // Verificar si tiene reservas activas (no canceladas ni completadas)
        String sqlCheck = "SELECT COUNT(*) FROM Reservas WHERE HuespedId = ? AND Estado NOT IN ('cancelada', 'completada')";
        try (Connection cn = ConexionBD.conectar(); 
             PreparedStatement psCheck = cn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, id);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Tiene reservas activas asociadas, no se puede eliminar
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Si no tiene reservas activas, proceder con la eliminación
        String sql = "DELETE FROM [Huéspedes] WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int contarReservas(int huespedId) {
        String sql = "SELECT COUNT(*) FROM Reservas WHERE HuespedId = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, huespedId);
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

    /**
     * Extra: sumar una visita (útil en check-in)
     */
    public boolean incrementarVisita(int id) {
        String sql = "UPDATE [Huéspedes] SET VisitasPrevias = ISNULL(VisitasPrevias,0) + 1 WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
