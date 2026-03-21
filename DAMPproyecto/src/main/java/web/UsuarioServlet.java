/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package web;

import dao.UsuarioDAO;
import model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/usuarios"})
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String op = req.getParameter("op");
        if (op == null || op.equals("list")) {
            String q = req.getParameter("q");
            req.setAttribute("usuarios", dao.listar(q));
            req.setAttribute("rolesCombo", dao.rolesCombo());
            req.setAttribute("empleadosCombo", dao.empleadosCombo());
            req.getRequestDispatcher("usuarios.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Usuario u = new Usuario();
            u.setUsuario(req.getParameter("usuario"));
            u.setRolId(parseInt(req.getParameter("rolId")));
            u.setEmpleadoId(parseInt(req.getParameter("empleadoId")));
            u.setEstado("1".equals(req.getParameter("estado")) || "true".equalsIgnoreCase(req.getParameter("estado")));
            String pass = req.getParameter("password");
            boolean ok = pass != null && !pass.trim().isEmpty() && dao.crear(u, pass);
            req.getSession().setAttribute("flash", ok ? "Usuario creado" : "No se pudo crear");
            resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
            return;
        }

        if ("update".equals(op)) {
            Usuario u = new Usuario();
            u.setId(Integer.parseInt(req.getParameter("id")));
            u.setRolId(parseInt(req.getParameter("rolId")));
            u.setEmpleadoId(parseInt(req.getParameter("empleadoId")));
            u.setEstado("1".equals(req.getParameter("estado")));
            boolean ok = dao.actualizar(u);
            req.getSession().setAttribute("flash", ok ? "Usuario actualizado" : "No se pudo actualizar");
            resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
            return;
        }

        if ("reset".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String np = req.getParameter("newpass");
            boolean ok = np != null && !np.trim().isEmpty() && dao.resetPassword(id, np);
            req.getSession().setAttribute("flash", ok ? "Contraseña actualizada" : "No se pudo actualizar la contraseña");
            resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = dao.eliminar(id);
            req.getSession().setAttribute("flash", ok ? "Usuario eliminado exitosamente" : "Error al eliminar el usuario");
            resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/usuarios?op=list");
    }

    private Integer parseInt(String s) {
        try {
            return Integer.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }
}
