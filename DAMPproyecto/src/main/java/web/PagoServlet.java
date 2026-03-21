/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package web;

import dao.PagoDAO;
import model.Pago;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Map;

@WebServlet(name = "PagoServlet", urlPatterns = {"/pagos"})
public class PagoServlet extends HttpServlet {

    private final PagoDAO dao = new PagoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer reservaFiltro = parseInt(req.getParameter("reservaId"));
        req.setAttribute("pagos", dao.listar(reservaFiltro));
        req.setAttribute("reservasCombo", dao.reservasCombo());

        if (reservaFiltro != null) {
            Map<String, Object> resumen = dao.resumenReserva(reservaFiltro);
            req.setAttribute("resumen", resumen);
        }

        req.getRequestDispatcher("pagos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String op = req.getParameter("op");

        if ("create".equals(op)) {
            Pago p = new Pago();
            p.setReservaId(parseInt(req.getParameter("reservaId")));
            p.setMonto(parseDouble(req.getParameter("monto")));
            p.setFormaPago(req.getParameter("formaPago"));
            p.setTipoPago(req.getParameter("tipoPago"));
            p.setFechaPago(new Timestamp(System.currentTimeMillis()));

            boolean ok = p.getReservaId() != null && p.getMonto() != null && p.getMonto() > 0 && dao.crear(p);
            String mensaje = ok 
                ? "✅ Pago procesado y registrado exitosamente. Monto: $" + String.format("%.2f", p.getMonto()) + " - " + p.getFormaPago()
                : "❌ No se pudo registrar el pago. Verifique los datos e intente nuevamente.";
            req.getSession().setAttribute("flash", mensaje);
            resp.sendRedirect(req.getContextPath() + "/pagos?reservaId=" + (p.getReservaId() == null ? "" : p.getReservaId()));
            return;
        }

        if ("delete".equals(op)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = dao.eliminar(id);
            req.getSession().setAttribute("flash", ok ? "Pago eliminado exitosamente" : "Error al eliminar el pago");
            resp.sendRedirect(req.getContextPath() + "/pagos");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/pagos");
    }

    private Integer parseInt(String s) {
        try {
            return Integer.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDouble(String s) {
        try {
            return Double.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }
}
