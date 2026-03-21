package web;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final String[] PUBLIC_PATHS = {
        "/login.jsp",
        "/login",
        "/Logout",
        "/css/",
        "/js/",
        "/img/",
        "/assets/",
        "/favicon"
    };

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest rq = (HttpServletRequest) req;
        HttpServletResponse rp = (HttpServletResponse) res;

        String ctx = rq.getContextPath();          // /DAMPproyecto
        String requestURI = rq.getRequestURI();    // /DAMPproyecto/usuarioUsuario.jsp
        String path = requestURI.substring(ctx.length());

        if (path.isEmpty()) {
            path = "/";
        }

        // 1) ¿Ruta pública?
        boolean isPublic = false;
        for (String p : PUBLIC_PATHS) {
            if (path.startsWith(p)) {
                isPublic = true;
                break;
            }
        }

        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // 2) Validar sesión
        HttpSession session = rq.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("rol");

        if (role == null) {
            // Si no hay sesión, SIEMPRE mandamos a login (menos recursos estáticos)
            rp.sendRedirect(ctx + "/login.jsp");
            return;
        }

        boolean isAdmin = "ADMIN".equals(role);

        // 3) Rutas SOLO ADMIN (configuración y cosas críticas)
        boolean adminOnlyArea = path.startsWith("/administrador.jsp")
                || path.startsWith("/dashboard") && !path.startsWith("/dashboardUsuario") // dashboard admin
                || path.startsWith("/usuarios.jsp") // gestión de usuarios/roles
                || path.startsWith("/usuarios") && !path.startsWith("/usuarioUsuario") // gestión de usuarios/roles
                || path.startsWith("/empleados") // empleados
                || path.startsWith("/proveedores") // proveedores
                || path.startsWith("/reportes") // reportes gerenciales
                || path.startsWith("/graficos.jsp") // gráficas
                || path.startsWith("/habitaciones") && !path.startsWith("/habitacionesUsuario") // habitaciones admin
                || path.startsWith("/huespedes") && !path.startsWith("/huespedesUsuario") // huespedes admin
                || path.startsWith("/reservas") && !path.startsWith("/reservasUsuario") // reservas admin
                || path.startsWith("/pagos") && !path.startsWith("/pagosUsuario"); // pagos admin

        // 4) Página principal de USUARIO (recepción, call center, etc.)
        boolean userHome = path.startsWith("/usuarioUsuario.jsp") || path.startsWith("/dashboardUsuario");

        if (isAdmin) {
            // ADMIN puede ir a todo, no redirigimos
            chain.doFilter(req, res);
            return;
        } else {
            // Es USER (u otro rol no admin)
            if (adminOnlyArea) {
                // Si intenta entrar a zona de admin, lo mandamos a su home
                if (!userHome) { // evitamos bucle
                    rp.sendRedirect(ctx + "/dashboardUsuario");
                    return;
                }
            }
            // Si viene a /dashboardUsuario, /usuarioUsuario.jsp o a módulos operativos de usuario, lo dejamos pasar
            chain.doFilter(req, res);
        }
    }
}
