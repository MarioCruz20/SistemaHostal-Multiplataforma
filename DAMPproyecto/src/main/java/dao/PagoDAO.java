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
import model.Pago;

import java.sql.*;
import java.util.*;

public class PagoDAO {

    public List<Pago> listar(Integer reservaId) {
        List<Pago> list = new ArrayList<>();
        String sql
                = "SELECT p.Id, p.ReservaId, p.Monto, p.FormaPago, p.TipoPago, p.FechaPago, "
                + "       h.Nombre AS HuespedNombre, hb.Numero AS HabitacionNumero "
                + "FROM Pagos p "
                + "LEFT JOIN Reservas r    ON r.Id = p.ReservaId "
                + "LEFT JOIN [Huéspedes] h ON h.Id = r.HuespedId "
                + "LEFT JOIN Habitaciones hb ON hb.Id = r.HabitacionId "
                + "WHERE (? IS NULL OR p.ReservaId = ?) "
                + "ORDER BY p.FechaPago DESC, p.Id DESC";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            if (reservaId == null) {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(1, reservaId);
                ps.setInt(2, reservaId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pago p = new Pago();
                    p.setId(rs.getInt("Id"));
                    p.setReservaId((Integer) rs.getObject("ReservaId"));
                    p.setMonto(rs.getDouble("Monto"));
                    p.setFormaPago(rs.getString("FormaPago"));
                    p.setTipoPago(rs.getString("TipoPago"));
                    p.setFechaPago(rs.getTimestamp("FechaPago"));
                    p.setHuespedNombre(rs.getString("HuespedNombre"));
                    p.setHabitacionNumero(rs.getString("HabitacionNumero"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean crear(Pago p) {
        String sql = "INSERT INTO Pagos (ReservaId, Monto, FormaPago, TipoPago) VALUES (?,?,?,?)";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setObject(1, p.getReservaId());
            ps.setDouble(2, p.getMonto());
            ps.setString(3, p.getFormaPago());
            ps.setString(4, p.getTipoPago());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM Pagos WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Resumen por reserva: noches * precioDia (estimado) y total pagado
     */
    public Map<String, Object> resumenReserva(int reservaId) {
        String sql
                = "SELECT r.Id, r.FechaEntrada, r.FechaSalida, hb.PrecioDia, hb.Numero AS HabitacionNumero, "
                + "       h.Nombre AS HuespedNombre, "
                + "       DATEDIFF(DAY, r.FechaEntrada, r.FechaSalida) AS Dias, "
                + "       (SELECT ISNULL(SUM(Monto),0) FROM Pagos WHERE ReservaId = r.Id) AS Pagado "
                + "FROM Reservas r "
                + "LEFT JOIN Habitaciones hb ON hb.Id = r.HabitacionId "
                + "LEFT JOIN [Huéspedes] h   ON h.Id = r.HuespedId "
                + "WHERE r.Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reservaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int dias = rs.getInt("Dias");
                    double precioDia = rs.getDouble("PrecioDia");
                    double estimado = Math.max(0, dias) * precioDia;
                    double pagado = rs.getDouble("Pagado");
                    double saldo = estimado - pagado;

                    Map<String, Object> m = new HashMap<>();
                    m.put("reservaId", rs.getInt("Id"));
                    m.put("huesped", rs.getString("HuespedNombre"));
                    m.put("habitacion", rs.getString("HabitacionNumero"));
                    m.put("dias", dias);
                    m.put("precioDia", precioDia);
                    m.put("estimado", estimado);
                    m.put("pagado", pagado);
                    m.put("saldo", saldo);
                    return m;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Para combo: Res #id - Hab NNN - Huesped - fechas
     */
    public List<Map<String, String>> reservasCombo() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql
                = "SELECT r.Id, hb.Numero AS Numero, h.Nombre AS Nombre, r.FechaEntrada, r.FechaSalida "
                + "FROM Reservas r "
                + "LEFT JOIN Habitaciones hb ON hb.Id = r.HabitacionId "
                + "LEFT JOIN [Huéspedes] h   ON h.Id = r.HuespedId "
                + "ORDER BY r.Id DESC";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", String.valueOf(rs.getInt("Id")));
                String label = "Res #" + rs.getInt("Id") + " • Hab " + rs.getString("Numero")
                        + " • " + rs.getString("Nombre")
                        + " • " + rs.getDate("FechaEntrada") + " → " + rs.getDate("FechaSalida");
                m.put("text", label);
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
