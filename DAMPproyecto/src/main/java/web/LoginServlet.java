package web;

import dao.UsuarioDAO;
import model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        if (usuario == null || password == null
                || usuario.trim().isEmpty()
                || password.trim().isEmpty()) {

            request.setAttribute("error", "Usuario o contraseña no pueden estar vacíos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();
        Usuario u = dao.login(usuario.trim(), password);

        if (u == null) {
            request.setAttribute("error", "Credenciales inválidas o usuario inactivo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession ses = request.getSession(true);
        ses.setAttribute("usuarioLogueado", u);
        ses.setAttribute("username", u.getUsuario());

        String rol = u.getRolNombre();
        String rolSesion = "USER";
        if (rol != null && rol.equalsIgnoreCase("admin")) {
            rolSesion = "ADMIN";
        }
        ses.setAttribute("rol", rolSesion);

        ses.setMaxInactiveInterval(30 * 60); // 30 minutos

        String ctx = request.getContextPath();
        String redirectPath = "ADMIN".equals(rolSesion)
                ? ctx + "/dashboard"
                : ctx + "/dashboardUsuario";

        response.sendRedirect(redirectPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
