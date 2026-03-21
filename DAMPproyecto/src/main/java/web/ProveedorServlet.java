package web;

import dao.ProveedorDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProveedorServlet", urlPatterns = {"/proveedores"})
public class ProveedorServlet extends HttpServlet {

    private final ProveedorDAO dao = new ProveedorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Obtener parámetros de filtro
        String q = req.getParameter("q");
        String telefono = req.getParameter("telefono");
        String email = req.getParameter("email");
        
        // Obtener proveedores de la base de datos
        List<Map<String, String>> proveedores = dao.listar(q, telefono, email);
        req.setAttribute("proveedores", proveedores);
        
        req.getRequestDispatcher("proveedores.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            String nombre = req.getParameter("nombre");
            String contacto = req.getParameter("contacto");
            String telefono = req.getParameter("telefono");
            String email = req.getParameter("email");
            String direccion = req.getParameter("direccion");
            
            boolean ok = dao.crear(nombre, contacto, telefono, email, direccion);
            req.getSession().setAttribute("flash", ok ? "Proveedor registrado exitosamente" : "Error al registrar proveedor");
            resp.sendRedirect(req.getContextPath() + "/proveedores");
            return;
        }

        if ("update".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String nombre = req.getParameter("nombre");
            String contacto = req.getParameter("contacto");
            String telefono = req.getParameter("telefono");
            String email = req.getParameter("email");
            String direccion = req.getParameter("direccion");
            
            boolean ok = dao.actualizar(id, nombre, contacto, telefono, email, direccion);
            req.getSession().setAttribute("flash", ok ? "Proveedor actualizado exitosamente" : "Error al actualizar proveedor");
            resp.sendRedirect(req.getContextPath() + "/proveedores");
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = dao.eliminar(id);
            req.getSession().setAttribute("flash", ok ? "Proveedor eliminado exitosamente" : "Error al eliminar proveedor");
            resp.sendRedirect(req.getContextPath() + "/proveedores");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/proveedores");
    }
}



