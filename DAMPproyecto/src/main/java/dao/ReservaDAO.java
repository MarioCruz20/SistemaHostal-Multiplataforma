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
import model.Reserva;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    // LISTAR con joins (nombre huésped, número habitación) e importe estimado simple
    public List<Reserva> listar(String estadoFiltro) {
        List<Reserva> list = new ArrayList<>();
        String sql
                = "SELECT r.Id, r.HuespedId, r.HabitacionId, r.FechaEntrada, r.FechaSalida, r.Estado, "
                + "       r.NumeroHuespedes, r.Observaciones, "
                + "       h.Nombre AS HuespedNombre, hb.Numero AS HabitacionNumero, hb.PrecioDia "
                + "FROM Reservas r "
                + "LEFT JOIN [Huéspedes] h ON h.Id = r.HuespedId "
                + "LEFT JOIN Habitaciones hb ON hb.Id = r.HabitacionId "
                + "WHERE (? IS NULL OR ? = '' OR r.Estado = ?) "
                + "ORDER BY r.FechaEntrada DESC, r.Id DESC";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estadoFiltro);
            ps.setString(2, estadoFiltro);
            ps.setString(3, estadoFiltro);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("Id"));
                    r.setHuespedId((Integer) rs.getObject("HuespedId"));
                    r.setHabitacionId((Integer) rs.getObject("HabitacionId"));
                    r.setFechaEntrada(rs.getDate("FechaEntrada"));
                    r.setFechaSalida(rs.getDate("FechaSalida"));
                    r.setEstado(rs.getString("Estado"));
                    r.setNumeroHuespedes((Integer) rs.getObject("NumeroHuespedes"));
                    r.setObservaciones(rs.getString("Observaciones"));
                    r.setHuespedNombre(rs.getString("HuespedNombre"));
                    r.setHabitacionNumero(rs.getString("HabitacionNumero"));

                    // importe estimado simple: días * PrecioDia
                    Date fe = r.getFechaEntrada();
                    Date fs = r.getFechaSalida();
                    double precioDia = rs.getDouble("PrecioDia");
                    if (fe != null && fs != null && precioDia > 0) {
                        long dias = Math.max(0, (fs.getTime() - fe.getTime()) / (1000L * 60 * 60 * 24));
                        r.setImporteEstimado(dias * precioDia);
                    } else {
                        r.setImporteEstimado(null);
                    }
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Reserva obtener(int id) {
        String sql = "SELECT * FROM Reservas WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("Id"));
                    r.setHuespedId((Integer) rs.getObject("HuespedId"));
                    r.setHabitacionId((Integer) rs.getObject("HabitacionId"));
                    r.setFechaEntrada(rs.getDate("FechaEntrada"));
                    r.setFechaSalida(rs.getDate("FechaSalida"));
                    r.setEstado(rs.getString("Estado"));
                    r.setNumeroHuespedes((Integer) rs.getObject("NumeroHuespedes"));
                    r.setObservaciones(rs.getString("Observaciones"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Verifica disponibilidad: que no exista reserva que se traslape en la misma habitación (excepto cancelada y completada)
    public boolean habitacionDisponible(int habitacionId, Date entrada, Date salida) {
        String sql
                = "SELECT COUNT(1) "
                + "FROM Reservas r "
                + "WHERE r.HabitacionId = ? "
                + "  AND r.Estado NOT IN ('cancelada', 'completada') "
                + "  AND NOT (r.FechaSalida <= ? OR r.FechaEntrada >= ?)";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, habitacionId);
            ps.setDate(2, entrada);
            ps.setDate(3, salida);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean crear(Reserva r) {
        if (!habitacionDisponible(r.getHabitacionId(), r.getFechaEntrada(), r.getFechaSalida())) {
            return false;
        }
        String sql = "INSERT INTO Reservas (HuespedId, HabitacionId, FechaEntrada, FechaSalida, Estado, NumeroHuespedes, Observaciones) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setObject(1, r.getHuespedId());
                ps.setObject(2, r.getHabitacionId());
                ps.setDate(3, r.getFechaEntrada());
                ps.setDate(4, r.getFechaSalida());
                ps.setString(5, r.getEstado());
                ps.setObject(6, r.getNumeroHuespedes());
                ps.setString(7, r.getObservaciones());
                
                if (ps.executeUpdate() == 1) {
                    // Actualizar estado de la habitación según el estado de la reserva
                    String estadoHabitacion = determinarEstadoHabitacion(r.getEstado());
                    String sqlUpdateHab = "UPDATE Habitaciones SET Estado = ? WHERE Id = ?";
                    try (PreparedStatement psHab = cn.prepareStatement(sqlUpdateHab)) {
                        psHab.setString(1, estadoHabitacion);
                        psHab.setInt(2, r.getHabitacionId());
                        psHab.executeUpdate();
                    }
                    cn.commit();
                    return true;
                } else {
                    cn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private String determinarEstadoHabitacion(String estadoReserva) {
        if (estadoReserva == null) return "disponible";
        switch (estadoReserva.toLowerCase()) {
            case "confirmada":
                return "ocupada";
            case "pendiente":
                return "reservada";
            case "cancelada":
                return "disponible";
            case "completada":
                return "limpieza";
            default:
                return "reservada";
        }
    }

    public boolean actualizar(Reserva r) {
        // si cambia habitacion o fechas, vuelve a validar disponibilidad
        if (r.getHabitacionId() != null && r.getFechaEntrada() != null && r.getFechaSalida() != null) {
            // Para update, permitir traslape consigo misma:
            String sqlChk
                    = "SELECT COUNT(1) FROM Reservas r "
                    + "WHERE r.HabitacionId = ? AND r.Id <> ? AND r.Estado NOT IN ('cancelada', 'completada') "
                    + "  AND NOT (r.FechaSalida <= ? OR r.FechaEntrada >= ?)";
            try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sqlChk)) {
                ps.setInt(1, r.getHabitacionId());
                ps.setInt(2, r.getId());
                ps.setDate(3, r.getFechaEntrada());
                ps.setDate(4, r.getFechaSalida());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return false;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        String sql = "UPDATE Reservas SET HuespedId=?, HabitacionId=?, FechaEntrada=?, FechaSalida=?, Estado=?, NumeroHuespedes=?, Observaciones=? "
                + "WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setObject(1, r.getHuespedId());
                ps.setObject(2, r.getHabitacionId());
                ps.setDate(3, r.getFechaEntrada());
                ps.setDate(4, r.getFechaSalida());
                ps.setString(5, r.getEstado());
                ps.setObject(6, r.getNumeroHuespedes());
                ps.setString(7, r.getObservaciones());
                ps.setInt(8, r.getId());
                
                if (ps.executeUpdate() == 1) {
                    // Actualizar estado de la habitación según el estado de la reserva
                    String estadoHabitacion = determinarEstadoHabitacion(r.getEstado());
                    String sqlUpdateHab = "UPDATE Habitaciones SET Estado = ? WHERE Id = ?";
                    try (PreparedStatement psHab = cn.prepareStatement(sqlUpdateHab)) {
                        psHab.setString(1, estadoHabitacion);
                        psHab.setInt(2, r.getHabitacionId());
                        psHab.executeUpdate();
                    }
                    cn.commit();
                    return true;
                } else {
                    cn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cambiarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE Reservas SET Estado = ? WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setString(1, nuevoEstado);
                ps.setInt(2, id);
                
                if (ps.executeUpdate() == 1) {
                    // Obtener el HabitacionId de la reserva
                    String sqlGetHab = "SELECT HabitacionId FROM Reservas WHERE Id = ?";
                    try (PreparedStatement psGet = cn.prepareStatement(sqlGetHab)) {
                        psGet.setInt(1, id);
                        try (ResultSet rs = psGet.executeQuery()) {
                            if (rs.next()) {
                                int habitacionId = rs.getInt("HabitacionId");
                                // Actualizar estado de la habitación
                                String estadoHabitacion = determinarEstadoHabitacion(nuevoEstado);
                                String sqlUpdateHab = "UPDATE Habitaciones SET Estado = ? WHERE Id = ?";
                                try (PreparedStatement psHab = cn.prepareStatement(sqlUpdateHab)) {
                                    psHab.setString(1, estadoHabitacion);
                                    psHab.setInt(2, habitacionId);
                                    psHab.executeUpdate();
                                }
                            }
                        }
                    }
                    cn.commit();
                    return true;
                } else {
                    cn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        // Verificar si tiene pagos asociados
        String sqlCheck = "SELECT COUNT(*) FROM Pagos WHERE ReservaId = ?";
        try (Connection cn = ConexionBD.conectar(); 
             PreparedStatement psCheck = cn.prepareStatement(sqlCheck)) {
            psCheck.setInt(1, id);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Tiene pagos asociados, no se puede eliminar directamente
                    // Opción: eliminar pagos primero o usar transacción
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Si no tiene pagos, proceder con la eliminación
        // También actualizar el estado de la habitación a disponible
        try (Connection cn = ConexionBD.conectar()) {
            cn.setAutoCommit(false);
            try {
                // Obtener el HabitacionId antes de eliminar
                String sqlGetHab = "SELECT HabitacionId FROM Reservas WHERE Id = ?";
                int habitacionId = -1;
                try (PreparedStatement psGet = cn.prepareStatement(sqlGetHab)) {
                    psGet.setInt(1, id);
                    try (ResultSet rs = psGet.executeQuery()) {
                        if (rs.next()) {
                            habitacionId = rs.getInt("HabitacionId");
                        }
                    }
                }
                
                // Eliminar la reserva
                String sql = "DELETE FROM Reservas WHERE Id = ?";
                try (PreparedStatement ps = cn.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    if (ps.executeUpdate() == 1) {
                        // Actualizar estado de la habitación a disponible
                        if (habitacionId > 0) {
                            String sqlUpdateHab = "UPDATE Habitaciones SET Estado = 'disponible' WHERE Id = ?";
                            try (PreparedStatement psHab = cn.prepareStatement(sqlUpdateHab)) {
                                psHab.setInt(1, habitacionId);
                                psHab.executeUpdate();
                            }
                        }
                        cn.commit();
                        return true;
                    } else {
                        cn.rollback();
                        return false;
                    }
                }
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int contarPagos(int reservaId) {
        String sql = "SELECT COUNT(*) FROM Pagos WHERE ReservaId = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, reservaId);
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

    // Datos para combos
    public List<int[]> listarHabitacionesBasicas() {
        // devuelve [id, numero] como par (id en [0], numero en [1] parseado a int si se puede)
        List<int[]> ret = new ArrayList<>();
        String sql = "SELECT Id, Numero FROM Habitaciones ORDER BY Numero";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // si Numero no es numérico, poner 0 y manejar en JSP con otro atributo
                int id = rs.getInt("Id");
                // guardo el id y no uso el numero aquí, lo enviaremos como atributo separado
                ret.add(new int[]{id});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ret;
    }

    // REPORTES: Listar reservas por rango de fechas y opcionalmente por habitación
    public List<Reserva> listarParaReporte(Date fechaInicio, Date fechaFin, String habitacionNumero) {
        List<Reserva> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.Id, r.HuespedId, r.HabitacionId, r.FechaEntrada, r.FechaSalida, r.Estado, " +
            "       r.NumeroHuespedes, r.Observaciones, " +
            "       h.Nombre AS HuespedNombre, h.Telefono AS HuespedTelefono, h.Email AS HuespedEmail, " +
            "       hb.Numero AS HabitacionNumero, hb.PrecioDia, hb.Tipo AS HabitacionTipo " +
            "FROM Reservas r " +
            "LEFT JOIN [Huéspedes] h ON h.Id = r.HuespedId " +
            "LEFT JOIN Habitaciones hb ON hb.Id = r.HabitacionId " +
            "WHERE 1=1 "
        );

        if (fechaInicio != null) {
            sql.append("AND r.FechaEntrada >= ? ");
        }
        if (fechaFin != null) {
            sql.append("AND r.FechaSalida <= ? ");
        }
        if (habitacionNumero != null && !habitacionNumero.trim().isEmpty()) {
            sql.append("AND hb.Numero = ? ");
        }
        sql.append("ORDER BY r.FechaEntrada DESC, r.Id DESC");

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (fechaInicio != null) {
                ps.setDate(paramIndex++, fechaInicio);
            }
            if (fechaFin != null) {
                ps.setDate(paramIndex++, fechaFin);
            }
            if (habitacionNumero != null && !habitacionNumero.trim().isEmpty()) {
                ps.setString(paramIndex++, habitacionNumero);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("Id"));
                    r.setHuespedId((Integer) rs.getObject("HuespedId"));
                    r.setHabitacionId((Integer) rs.getObject("HabitacionId"));
                    r.setFechaEntrada(rs.getDate("FechaEntrada"));
                    r.setFechaSalida(rs.getDate("FechaSalida"));
                    r.setEstado(rs.getString("Estado"));
                    r.setNumeroHuespedes((Integer) rs.getObject("NumeroHuespedes"));
                    r.setObservaciones(rs.getString("Observaciones"));
                    r.setHuespedNombre(rs.getString("HuespedNombre"));
                    r.setHabitacionNumero(rs.getString("HabitacionNumero"));

                    // importe estimado simple: días * PrecioDia
                    Date fe = r.getFechaEntrada();
                    Date fs = r.getFechaSalida();
                    double precioDia = rs.getDouble("PrecioDia");
                    if (fe != null && fs != null && precioDia > 0) {
                        long dias = Math.max(0, (fs.getTime() - fe.getTime()) / (1000L * 60 * 60 * 24));
                        r.setImporteEstimado(dias * precioDia);
                    } else {
                        r.setImporteEstimado(null);
                    }
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
