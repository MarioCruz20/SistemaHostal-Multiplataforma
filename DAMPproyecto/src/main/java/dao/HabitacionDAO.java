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
import model.Habitacion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HabitacionDAO {

    private Habitacion map(ResultSet rs) throws SQLException {
        Habitacion h = new Habitacion();
        h.setId(rs.getInt("Id"));
        h.setNumero(rs.getString("Numero"));
        h.setTipo(rs.getString("Tipo"));
        h.setCapacidad(rs.getInt("Capacidad"));
        h.setPrecioDia(rs.getDouble("PrecioDia"));
        h.setPrecioNoche(rs.getDouble("PrecioNoche"));
        h.setPrecioFinSemana(rs.getDouble("PrecioFinSemana"));
        h.setEstado(rs.getString("Estado"));
        h.setServicios(rs.getString("Servicios"));
        h.setImagen(rs.getString("Imagen"));
        return h;
    }

    // LISTAR con filtros opcionales
    public List<Habitacion> listar(String qNumero, String qTipo, String qEstado) {
        List<Habitacion> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT Id, Numero, Tipo, Capacidad, PrecioDia, PrecioNoche, PrecioFinSemana, Estado, Servicios, Imagen " +
            "FROM Habitaciones WHERE 1=1 "
        );

        if (qNumero != null && !qNumero.trim().isEmpty()) sql.append("AND Numero LIKE ? ");
        if (qTipo != null && !qTipo.trim().isEmpty())     sql.append("AND Tipo = ? ");
        if (qEstado != null && !qEstado.trim().isEmpty()) sql.append("AND Estado = ? ");
        sql.append("ORDER BY Numero");

        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            int i = 1;
            if (qNumero != null && !qNumero.trim().isEmpty()) ps.setString(i++, "%" + qNumero + "%");
            if (qTipo != null && !qTipo.trim().isEmpty())     ps.setString(i++, qTipo);
            if (qEstado != null && !qEstado.trim().isEmpty()) ps.setString(i++, qEstado);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Habitacion obtener(int id) {
        String sql = "SELECT * FROM Habitaciones WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean crear(Habitacion h) {
        String sql = "INSERT INTO Habitaciones (Numero, Tipo, Capacidad, PrecioDia, PrecioNoche, PrecioFinSemana, Estado, Servicios, Imagen) " +
                     "VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNumero());
            ps.setString(2, h.getTipo());
            ps.setInt(3, h.getCapacidad());
            ps.setDouble(4, h.getPrecioDia());
            ps.setDouble(5, h.getPrecioNoche());
            ps.setDouble(6, h.getPrecioFinSemana());
            ps.setString(7, h.getEstado());
            ps.setString(8, h.getServicios());
            ps.setString(9, h.getImagen());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean actualizar(Habitacion h) {
        String sql = "UPDATE Habitaciones SET Numero=?, Tipo=?, Capacidad=?, PrecioDia=?, PrecioNoche=?, PrecioFinSemana=?, Estado=?, Servicios=?, Imagen=? " +
                     "WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNumero());
            ps.setString(2, h.getTipo());
            ps.setInt(3, h.getCapacidad());
            ps.setDouble(4, h.getPrecioDia());
            ps.setDouble(5, h.getPrecioNoche());
            ps.setDouble(6, h.getPrecioFinSemana());
            ps.setString(7, h.getEstado());
            ps.setString(8, h.getServicios());
            ps.setString(9, h.getImagen());
            ps.setInt(10, h.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean eliminar(int id) {
        // Verificar si tiene reservas activas (no canceladas ni completadas)
        String sqlCheck = "SELECT COUNT(*) FROM Reservas WHERE HabitacionId = ? AND Estado NOT IN ('cancelada', 'completada')";
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
        String sql = "DELETE FROM Habitaciones WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }
    
    public int contarReservas(int habitacionId) {
        String sql = "SELECT COUNT(*) FROM Reservas WHERE HabitacionId = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, habitacionId);
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

    // Cambiar estado rápido
    public boolean cambiarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE Habitaciones SET Estado = ? WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
