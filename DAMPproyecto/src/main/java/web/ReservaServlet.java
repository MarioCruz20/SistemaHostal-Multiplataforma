/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package web;

import dao.HabitacionDAO;
import dao.ReservaDAO;
import misClases.ConexionBD;
import model.Habitacion;
import model.Reserva;
import tools.ParseUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReservaServlet", urlPatterns = {"/reservas"})
public class ReservaServlet extends HttpServlet {

    private final ReservaDAO dao = new ReservaDAO();
    private final HabitacionDAO habitacionDAO = new HabitacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String op = req.getParameter("op");
        if (op == null || op.equals("list")) {
            String estado = req.getParameter("estado"); // opcional
            req.setAttribute("reservas", dao.listar(estado));

            // combos básicos
            req.setAttribute("huespedesCombo", obtenerHuespedesCombo());
            req.setAttribute("habitacionesCombo", obtenerHabitacionesCombo());

            req.getRequestDispatcher("reservas.jsp").forward(req, resp);
            return;
        }

        if (op.equals("get")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Reserva r = dao.obtener(id);
            req.setAttribute("r", r);
            req.setAttribute("reservas", dao.listar(null));
            req.setAttribute("huespedesCombo", obtenerHuespedesCombo());
            req.setAttribute("habitacionesCombo", obtenerHabitacionesCombo());
            req.getRequestDispatcher("reservas.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Reserva r = bind(req);
            String error = validarReserva(r);
            if (error != null) {
                req.getSession().setAttribute("flash", error);
            } else {
                boolean ok = dao.crear(r);
                req.getSession().setAttribute("flash", ok ? "Reserva creada exitosamente" : "La habitación no está disponible para ese rango de fechas.");
            }
            resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
            return;
        }

        if ("update".equals(op)) {
            Reserva r = bind(req);
            r.setId(Integer.parseInt(req.getParameter("id")));
            String error = validarReserva(r);
            if (error != null) {
                req.getSession().setAttribute("flash", error);
            } else {
                boolean ok = dao.actualizar(r);
                req.getSession().setAttribute("flash", ok ? "Reserva actualizada exitosamente" : "No se pudo actualizar (ver disponibilidad).");
            }
            resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
            return;
        }

        if ("estado".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String estado = req.getParameter("estado");
            boolean ok = dao.cambiarEstado(id, estado);
            req.getSession().setAttribute("flash", ok ? "Estado actualizado" : "No se pudo cambiar estado");
            resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int pagosCount = dao.contarPagos(id);
            if (pagosCount > 0) {
                req.getSession().setAttribute("flash", "No se puede eliminar la reserva porque tiene " + pagosCount + " pago(s) asociado(s). Elimine primero los pagos.");
            } else {
                boolean ok = dao.eliminar(id);
                req.getSession().setAttribute("flash", ok ? "Reserva eliminada exitosamente. La habitación ha sido marcada como disponible." : "Error al eliminar la reserva");
            }
            resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reservas?op=list");
    }

    private Reserva bind(HttpServletRequest req) {
        Reserva r = new Reserva();
        r.setHuespedId(ParseUtils.parseInt(req.getParameter("huespedId")));
        r.setHabitacionId(ParseUtils.parseInt(req.getParameter("habitacionId")));
        r.setFechaEntrada(ParseUtils.parseDate(req.getParameter("fechaEntrada")));
        r.setFechaSalida(ParseUtils.parseDate(req.getParameter("fechaSalida")));
        r.setEstado(req.getParameter("estado"));
        r.setNumeroHuespedes(ParseUtils.parseInt(req.getParameter("numeroHuespedes")));
        r.setObservaciones(req.getParameter("observaciones"));
        return r;
    }
    
    /**
     * Valida los datos de una reserva antes de guardarla
     * @param r Reserva a validar
     * @return Mensaje de error o null si es válida
     */
    private String validarReserva(Reserva r) {
        // Validar que las fechas no sean nulas
        if (r.getFechaEntrada() == null) {
            return "La fecha de entrada es requerida";
        }
        if (r.getFechaSalida() == null) {
            return "La fecha de salida es requerida";
        }
        
        // Validar que fechaEntrada < fechaSalida
        if (!ParseUtils.validarRangoFechas(r.getFechaEntrada(), r.getFechaSalida())) {
            return "La fecha de entrada debe ser anterior a la fecha de salida";
        }
        
        // Validar que tenga huésped y habitación
        if (r.getHuespedId() == null) {
            return "Debe seleccionar un huésped";
        }
        if (r.getHabitacionId() == null) {
            return "Debe seleccionar una habitación";
        }
        
        // Validar capacidad de la habitación
        if (r.getNumeroHuespedes() != null && r.getNumeroHuespedes() > 0) {
            Habitacion hab = habitacionDAO.obtener(r.getHabitacionId());
            if (hab != null && r.getNumeroHuespedes() > hab.getCapacidad()) {
                return "El número de huéspedes (" + r.getNumeroHuespedes() + 
                       ") excede la capacidad de la habitación (" + hab.getCapacidad() + ")";
            }
        }
        
        return null; // Reserva válida
    }

    // === combos simples ===
    private List<Map<String, String>> obtenerHuespedesCombo() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT Id, Nombre FROM [Huéspedes] ORDER BY Nombre";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", String.valueOf(rs.getInt("Id")));
                m.put("text", rs.getString("Nombre"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Map<String, String>> obtenerHabitacionesCombo() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT Id, Numero FROM Habitaciones ORDER BY Numero";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", String.valueOf(rs.getInt("Id")));
                m.put("text", rs.getString("Numero"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
