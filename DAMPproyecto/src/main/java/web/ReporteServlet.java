package web;

import dao.ReservaDAO;
import model.Reserva;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/reportes"})
public class ReporteServlet extends HttpServlet {

    private final ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String tipo = req.getParameter("tipo");
        String formato = req.getParameter("formato");
        
        if ("download".equals(tipo) && formato != null && "html".equalsIgnoreCase(formato)) {
            generarYDescargarReporte(req, resp, formato);
            return;
        }
        
        // Mostrar vista normal
        req.getRequestDispatcher("reportes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        String tipo = req.getParameter("tipo");
        String formato = req.getParameter("formato");
        
        if (formato != null && !formato.isEmpty() && "html".equalsIgnoreCase(formato)) {
            generarYDescargarReporte(req, resp, formato);
        } else {
            // Guardar parámetros en sesión para la descarga
            HttpSession session = req.getSession();
            session.setAttribute("reporte_tipo", tipo);
            session.setAttribute("reporte_fechaInicio", req.getParameter("fechaInicio"));
            session.setAttribute("reporte_fechaFin", req.getParameter("fechaFin"));
            session.setAttribute("reporte_habitacion", req.getParameter("habitacion"));
            
            // Generar vista previa con datos reales
            req.setAttribute("reporteGenerado", true);
            req.setAttribute("datosReporte", generarDatosReporte(req, tipo));
            req.getRequestDispatcher("reportes.jsp").forward(req, resp);
        }
    }

    private void generarYDescargarReporte(HttpServletRequest req, HttpServletResponse resp, String formato) 
            throws IOException {
        
        HttpSession session = req.getSession();
        String tipo = req.getParameter("tipoReporte");
        if (tipo == null || tipo.isEmpty()) {
            tipo = (String) session.getAttribute("reporte_tipo");
        }
        
        // Crear un request wrapper que obtiene parámetros de la request o de la sesión
        final HttpSession finalSession = session;
        HttpServletRequest reqWrapper = new HttpServletRequestWrapper(req) {
            @Override
            public String getParameter(String name) {
                String param = super.getParameter(name);
                if (param == null || param.isEmpty()) {
                    String sessionKey = "reporte_" + name;
                    Object value = finalSession.getAttribute(sessionKey);
                    if (value != null) {
                        return value.toString();
                    }
                }
                return param;
            }
        };
        
        List<Map<String, String>> datos = generarDatosReporte(reqWrapper, tipo);
        
        String nombreArchivo = "reporte_" + tipo + "_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date());
        
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + ".html\"");
        generarHTML(resp.getWriter(), datos, tipo);
    }

    private List<Map<String, String>> generarDatosReporte(HttpServletRequest req, String tipo) {
        List<Map<String, String>> datos = new ArrayList<>();
        
        // Obtener datos reales de la base de datos
        if ("reservas".equals(tipo)) {
            String fechaInicioStr = req.getParameter("fechaInicio");
            String fechaFinStr = req.getParameter("fechaFin");
            String habitacion = req.getParameter("habitacion");
            
            Date fechaInicio = null;
            Date fechaFin = null;
            
            try {
                if (fechaInicioStr != null && !fechaInicioStr.trim().isEmpty()) {
                    fechaInicio = Date.valueOf(fechaInicioStr);
                }
                if (fechaFinStr != null && !fechaFinStr.trim().isEmpty()) {
                    fechaFin = Date.valueOf(fechaFinStr);
                }
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
            
            // Consultar reservas reales de la base de datos
            List<Reserva> reservas = reservaDAO.listarParaReporte(fechaInicio, fechaFin, habitacion);
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            
            for (Reserva r : reservas) {
                Map<String, String> fila = new HashMap<>();
                fila.put("ID", String.valueOf(r.getId()));
                fila.put("Huésped", r.getHuespedNombre() != null ? r.getHuespedNombre() : "N/A");
                fila.put("Habitación", r.getHabitacionNumero() != null ? r.getHabitacionNumero() : "N/A");
                fila.put("Fecha Entrada", r.getFechaEntrada() != null ? sdf.format(r.getFechaEntrada()) : "N/A");
                fila.put("Fecha Salida", r.getFechaSalida() != null ? sdf.format(r.getFechaSalida()) : "N/A");
                fila.put("Estado", r.getEstado() != null ? r.getEstado() : "N/A");
                fila.put("N° Huéspedes", r.getNumeroHuespedes() != null ? String.valueOf(r.getNumeroHuespedes()) : "N/A");
                fila.put("Importe Estimado", r.getImporteEstimado() != null ? 
                    String.format("$%.2f", r.getImporteEstimado()) : "N/A");
                datos.add(fila);
            }
        }
        
        return datos;
    }

    private void generarHTML(PrintWriter out, List<Map<String, String>> datos, String tipo) {
        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Reporte de Reservas</title>");
        out.println("<style>");
        out.println("body{font-family:'Segoe UI',Arial,sans-serif;margin:20px;background-color:#f5f5f5;}");
        out.println(".container{max-width:1200px;margin:0 auto;background:white;padding:30px;border-radius:8px;box-shadow:0 2px 10px rgba(0,0,0,0.1);}");
        out.println("h1{color:#2563eb;border-bottom:3px solid #2563eb;padding-bottom:10px;}");
        out.println("table{border-collapse:collapse;width:100%;margin-top:20px;font-size:14px;}");
        out.println("th,td{border:1px solid #ddd;padding:12px;text-align:left;}");
        out.println("th{background-color:#2563eb;color:white;font-weight:600;}");
        out.println("tr:nth-child(even){background-color:#f9fafb;}");
        out.println("tr:hover{background-color:#e0e7ff;}");
        out.println(".info{background-color:#dbeafe;padding:15px;border-radius:5px;margin-bottom:20px;color:#1e40af;}");
        out.println("</style></head><body>");
        out.println("<div class='container'>");
        out.println("<h1>📊 Reporte de Reservas</h1>");
        out.println("<div class='info'>");
        out.println("<strong>Fecha de generación:</strong> " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()));
        out.println("</div>");
        
        if (datos.isEmpty()) {
            out.println("<p style='text-align:center;color:#6b7280;padding:40px;'>No hay datos para mostrar con los filtros seleccionados.</p>");
        } else {
            out.println("<table>");
            Set<String> columnas = datos.get(0).keySet();
            
            // Encabezados
            out.println("<thead><tr>");
            for (String col : columnas) {
                out.println("<th>" + col + "</th>");
            }
            out.println("</tr></thead>");
            
            // Datos
            out.println("<tbody>");
            for (Map<String, String> fila : datos) {
                out.println("<tr>");
                for (String col : columnas) {
                    String valor = fila.get(col) != null ? fila.get(col) : "";
                    // Escapar HTML para seguridad
                    valor = valor.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
                    out.println("<td>" + valor + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</tbody>");
            out.println("</table>");
            out.println("<p style='margin-top:20px;color:#6b7280;'><strong>Total de registros:</strong> " + datos.size() + "</p>");
        }
        
        out.println("</div>");
        out.println("</body></html>");
    }
}

