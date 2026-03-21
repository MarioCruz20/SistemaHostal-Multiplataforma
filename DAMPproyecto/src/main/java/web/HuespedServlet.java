/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package web;

import dao.HuespedDAO;
import model.Huesped;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "HuespedServlet", urlPatterns = {"/huespedes"})
public class HuespedServlet extends HttpServlet {

    private final HuespedDAO dao = new HuespedDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String op = req.getParameter("op");
        if (op == null || op.equals("list")) {
            String q = req.getParameter("q");
            List<Huesped> data = dao.listar(q);
            req.setAttribute("huespedes", data);
            req.getRequestDispatcher("huespedes.jsp").forward(req, resp);
            return;
        }

        if (op.equals("get")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Huesped h = dao.obtener(id);
            req.setAttribute("h", h);
            req.getRequestDispatcher("huespedes.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/huespedes?op=list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Huesped h = bind(req);
            boolean ok = dao.crear(h);
            req.getSession().setAttribute("flash", ok ? "Huésped creado" : "Error al crear");
            resp.sendRedirect(req.getContextPath() + "/huespedes?op=list");
            return;
        }

        if ("update".equals(op)) {
            Huesped h = bind(req);
            h.setId(Integer.parseInt(req.getParameter("id")));
            boolean ok = dao.actualizar(h);
            req.getSession().setAttribute("flash", ok ? "Huésped actualizado" : "Error al actualizar");
            resp.sendRedirect(req.getContextPath() + "/huespedes?op=list");
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int reservasCount = dao.contarReservas(id);
            if (reservasCount > 0) {
                req.getSession().setAttribute("flash", "No se puede eliminar el huésped porque tiene " + reservasCount + " reserva(s) asociada(s). Elimine primero las reservas.");
            } else {
                boolean ok = dao.eliminar(id);
                req.getSession().setAttribute("flash", ok ? "Huésped eliminado exitosamente" : "Error al eliminar el huésped");
            }
            resp.sendRedirect(req.getContextPath() + "/huespedes?op=list");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/huespedes?op=list");
    }

    private Huesped bind(HttpServletRequest req) {
        Huesped h = new Huesped();
        h.setNombre(req.getParameter("nombre"));
        h.setFechaNacimiento(parseDate(req.getParameter("fechaNacimiento")));
        h.setDireccion(req.getParameter("direccion"));
        h.setSexo(req.getParameter("sexo")); // 'M','F','O'
        h.setTelefono(req.getParameter("telefono"));
        h.setDui(req.getParameter("dui"));
        h.setEmail(req.getParameter("email"));
        h.setVisitasPrevias(parseInt(req.getParameter("visitasPrevias")));
        return h;
    }

    private Date parseDate(String s) {
        try {
            return Date.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return null;
        }
    }
}
