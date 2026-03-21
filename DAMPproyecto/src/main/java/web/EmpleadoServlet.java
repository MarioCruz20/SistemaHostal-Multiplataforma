/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package web;

import dao.EmpleadoDAO;
import model.Empleado;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "EmpleadoServlet", urlPatterns = {"/empleados"})
public class EmpleadoServlet extends HttpServlet {

    private final EmpleadoDAO dao = new EmpleadoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String op = req.getParameter("op");
        if (op == null || op.equals("list")) {
            String q = req.getParameter("q");
            req.setAttribute("empleados", dao.listar(q));
            req.getRequestDispatcher("empleados.jsp").forward(req, resp);
            return;
        }
        if (op.equals("get")) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("e", dao.obtener(id));
            req.setAttribute("empleados", dao.listar(null));
            req.getRequestDispatcher("empleados.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/empleados?op=list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Empleado e = bind(req);
            boolean ok = dao.crear(e);
            req.getSession().setAttribute("flash", ok ? "Empleado creado" : "No se pudo crear");
            resp.sendRedirect(req.getContextPath() + "/empleados?op=list");
            return;
        }
        if ("update".equals(op)) {
            Empleado e = bind(req);
            e.setId(Integer.parseInt(req.getParameter("id")));
            boolean ok = dao.actualizar(e);
            req.getSession().setAttribute("flash", ok ? "Empleado actualizado" : "No se pudo actualizar");
            resp.sendRedirect(req.getContextPath() + "/empleados?op=list");
            return;
        }
        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int usuariosCount = dao.contarUsuarios(id);
            if (usuariosCount > 0) {
                req.getSession().setAttribute("flash", "No se puede eliminar el empleado porque tiene " + usuariosCount + " usuario(s) asociado(s). Elimine primero los usuarios.");
            } else {
                boolean ok = dao.eliminar(id);
                req.getSession().setAttribute("flash", ok ? "Empleado eliminado exitosamente" : "Error al eliminar el empleado");
            }
            resp.sendRedirect(req.getContextPath() + "/empleados?op=list");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/empleados?op=list");
    }

    private Empleado bind(HttpServletRequest req) {
        Empleado e = new Empleado();
        e.setNombre(req.getParameter("nombre"));
        e.setDui(req.getParameter("dui"));
        e.setTelefono(req.getParameter("telefono"));
        e.setEmail(req.getParameter("email"));
        e.setPuesto(req.getParameter("puesto"));
        e.setFechaContratacion(parseDate(req.getParameter("fechaContratacion")));
        e.setEstado("1".equals(req.getParameter("estado")) || "true".equalsIgnoreCase(req.getParameter("estado")));
        return e;
    }

    private java.sql.Date parseDate(String s) {
        try {
            return java.sql.Date.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }
}
