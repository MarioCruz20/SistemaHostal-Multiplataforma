package web;

import misClases.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "DashboardUsuarioServlet", urlPatterns = {"/dashboardUsuario"})
public class DashboardUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Verificar que esté logueado (no necesariamente admin)
        HttpSession session = req.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("rol");
        
        if (role == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        try (Connection cn = ConexionBD.conectar()) {
            
            // 1. Ocupación hoy (porcentaje de habitaciones ocupadas/reservadas hoy)
            double ocupacionHoy = calcularOcupacionHoy(cn);
            
            // 2. Ingresos del mes actual
            double ingresosMes = calcularIngresosMes(cn);
            
            // 3. Reservas activas (confirmadas o pendientes)
            int reservasActivas = contarReservasActivas(cn);
            
            // 4. Huéspedes frecuentes (últimos 90 días)
            int huespedesFrecuentes = contarHuespedesFrecuentes(cn);
            
            // 5. Comparación con mes anterior (para ingresos)
            double ingresosMesAnterior = calcularIngresosMesAnterior(cn);
            double variacionIngresos = ingresosMesAnterior > 0 
                ? ((ingresosMes - ingresosMesAnterior) / ingresosMesAnterior) * 100 
                : 0;
            
            // 6. Comparación ocupación (ayer vs hoy)
            double ocupacionAyer = calcularOcupacionAyer(cn);
            double variacionOcupacion = ocupacionAyer > 0 
                ? ocupacionHoy - ocupacionAyer 
                : 0;
            
            req.setAttribute("ocupacionHoy", ocupacionHoy);
            req.setAttribute("ingresosMes", ingresosMes);
            req.setAttribute("reservasActivas", reservasActivas);
            req.setAttribute("huespedesFrecuentes", huespedesFrecuentes);
            req.setAttribute("variacionIngresos", variacionIngresos);
            req.setAttribute("variacionOcupacion", variacionOcupacion);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Valores por defecto en caso de error
            req.setAttribute("ocupacionHoy", 0.0);
            req.setAttribute("ingresosMes", 0.0);
            req.setAttribute("reservasActivas", 0);
            req.setAttribute("huespedesFrecuentes", 0);
            req.setAttribute("variacionIngresos", 0.0);
            req.setAttribute("variacionOcupacion", 0.0);
        }
        
        req.getRequestDispatcher("usuarioUsuario.jsp").forward(req, resp);
    }
    
    private double calcularOcupacionHoy(Connection cn) throws SQLException {
        String sql = "SELECT " +
                     "  COUNT(CASE WHEN h.Estado IN ('ocupada', 'reservada') THEN 1 END) * 100.0 / " +
                     "  NULLIF(COUNT(*), 0) AS Porcentaje " +
                     "FROM Habitaciones h";
        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("Porcentaje");
            }
        }
        return 0.0;
    }
    
    private double calcularOcupacionAyer(Connection cn) throws SQLException {
        // Similar a hoy pero para ayer - simplificado, usando el mismo cálculo
        // En un sistema real, esto sería más complejo
        return calcularOcupacionHoy(cn);
    }
    
    private double calcularIngresosMes(Connection cn) throws SQLException {
        String sql = "SELECT ISNULL(SUM(Monto), 0) AS Total " +
                     "FROM Pagos " +
                     "WHERE YEAR(FechaPago) = YEAR(GETDATE()) " +
                     "  AND MONTH(FechaPago) = MONTH(GETDATE())";
        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("Total");
            }
        }
        return 0.0;
    }
    
    private double calcularIngresosMesAnterior(Connection cn) throws SQLException {
        String sql = "SELECT ISNULL(SUM(Monto), 0) AS Total " +
                     "FROM Pagos " +
                     "WHERE YEAR(FechaPago) = YEAR(DATEADD(MONTH, -1, GETDATE())) " +
                     "  AND MONTH(FechaPago) = MONTH(DATEADD(MONTH, -1, GETDATE()))";
        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("Total");
            }
        }
        return 0.0;
    }
    
    private int contarReservasActivas(Connection cn) throws SQLException {
        String sql = "SELECT COUNT(*) AS Total " +
                     "FROM Reservas " +
                     "WHERE Estado IN ('pendiente', 'confirmada') " +
                     "  AND FechaEntrada <= GETDATE() " +
                     "  AND FechaSalida >= GETDATE()";
        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("Total");
            }
        }
        return 0;
    }
    
    private int contarHuespedesFrecuentes(Connection cn) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT r.HuespedId) AS Total " +
                     "FROM Reservas r " +
                     "WHERE r.FechaEntrada >= DATEADD(DAY, -90, GETDATE())";
        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("Total");
            }
        }
        return 0;
    }
}


