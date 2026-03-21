/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package web;

import dao.HabitacionDAO;
import model.Habitacion;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HabitacionUsuarioServlet", urlPatterns = {"/habitacionesUsuario"})
public class HabitacionUsuarioServlet extends HttpServlet {

    private final HabitacionDAO dao = new HabitacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String op = req.getParameter("op");
        if (op == null || op.equals("list")) {
            // filtros
            String fNum = req.getParameter("q");
            String fTipo = req.getParameter("tipo");
            String fEstado = req.getParameter("estado");

            List<Habitacion> data = dao.listar(fNum, fTipo, fEstado);
            req.setAttribute("habitaciones", data);
            req.getRequestDispatcher("habitacionesUsuario.jsp").forward(req, resp);
            return;
        }

        if ("get".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Habitacion h = dao.obtener(id);
            req.setAttribute("hab", h);
            req.getRequestDispatcher("habitacionesUsuario.jsp").forward(req, resp);
            return;
        }

        // default
        resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Habitacion h = bind(req);
            boolean ok = dao.crear(h);
            req.getSession().setAttribute("flash", ok ? "Habitación creada" : "Error al crear");
            resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
            return;
        }

        if ("update".equals(op)) {
            Habitacion h = bind(req);
            h.setId(Integer.parseInt(req.getParameter("id")));
            boolean ok = dao.actualizar(h);
            req.getSession().setAttribute("flash", ok ? "Habitación actualizada" : "Error al actualizar");
            resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int reservasCount = dao.contarReservas(id);
            if (reservasCount > 0) {
                req.getSession().setAttribute("flash", "No se puede eliminar la habitación porque tiene " + reservasCount + " reserva(s) asociada(s). Elimine primero las reservas.");
            } else {
                boolean ok = dao.eliminar(id);
                req.getSession().setAttribute("flash", ok ? "Habitación eliminada exitosamente" : "Error al eliminar la habitación");
            }
            resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
            return;
        }

        if ("estado".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String estado = req.getParameter("estado");
            boolean ok = dao.cambiarEstado(id, estado);
            req.getSession().setAttribute("flash", ok ? "Estado actualizado" : "Error al cambiar estado");
            resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/habitacionesUsuario?op=list");
    }

    private Habitacion bind(HttpServletRequest req) {
        Habitacion h = new Habitacion();
        h.setNumero(req.getParameter("numero"));
        h.setTipo(req.getParameter("tipo"));
        h.setCapacidad(parseInt(req.getParameter("capacidad"), 1));
        h.setPrecioDia(parseDouble(req.getParameter("precioDia")));
        h.setPrecioNoche(parseDouble(req.getParameter("precioNoche")));
        h.setPrecioFinSemana(parseDouble(req.getParameter("precioFinSemana")));
        h.setEstado(req.getParameter("estado"));
        h.setServicios(req.getParameter("servicios"));
        h.setImagen(null); // Campo deshabilitado
        return h;
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private double parseDouble(String s) {
        try {
            return Double.parseDouble(s);
        } catch (Exception e) {
            return 0d;
        }
    }
}
