<%-- 
    Document   : reservas
    Created on : 11 nov. 2025, 16:53:41
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map"%>
<%@page import="model.Reserva"%>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
    
    "unchecked")
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    if (reservas == null) {
        reservas = java.util.Collections.emptyList();
    }
    @SuppressWarnings(
    
    "unchecked")
    List<Map<String, String>> huespedesCombo = (List<Map<String, String>>) request.getAttribute("huespedesCombo");
    if (huespedesCombo == null) {
        huespedesCombo = java.util.Collections.emptyList();
    }
    @SuppressWarnings(
    
    "unchecked")
    List<Map<String, String>> habitacionesCombo = (List<Map<String, String>>) request.getAttribute("habitacionesCombo");
    if (habitacionesCombo == null) {
        habitacionesCombo = java.util.Collections.emptyList();
    }

    String flash = null;
    if (session != null) {
        flash = (String) session.getAttribute("flash");
        if (flash != null)
            session.removeAttribute("flash");
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Administrador - Reservas</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">📅 Reservas</span>
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuAdmin">
            <div class="offcanvas-header"><h5 class="offcanvas-title">Menú</h5><button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button></div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/dashboard">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitaciones?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedes?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/usuarios?op=list">⚙️ Usuarios / Roles</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/proveedores">🚚 Proveedores</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reportes">📊 Reportes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/graficos.jsp">📈 Gráficos</a></li>
                </ul>
            </div>
        </div>

        <div class="container my-4">
            <% if (flash != null) {%>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= flash%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <div class="card shadow-sm mb-3">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <h4 class="m-0">Gestión de Reservas</h4>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlNueva">+ Nueva</button>
                </div>
            </div>

            <!-- Filtro simple por estado -->
            <form class="row g-2 mb-3" action="<%=ctx%>/reservas" method="get">
                <input type="hidden" name="op" value="list">
                <div class="col-md-4">
                    <select class="form-select" name="estado">
                        <option value="">Todos los estados</option>
                        <option value="pendiente" <%= "pendiente".equals(request.getParameter("estado")) ? "selected" : ""%>>pendiente</option>
                        <option value="confirmada" <%= "confirmada".equals(request.getParameter("estado")) ? "selected" : ""%>>confirmada</option>
                        <option value="cancelada" <%= "cancelada".equals(request.getParameter("estado")) ? "selected" : ""%>>cancelada</option>
                        <option value="completada" <%= "completada".equals(request.getParameter("estado")) ? "selected" : ""%>>completada</option>
                    </select>
                </div>
                <div class="col-md-2 d-grid">
                    <button class="btn btn-outline-secondary">Filtrar</button>
                </div>
            </form>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Huésped</th>
                                <th>Habitación</th>
                                <th>Entrada</th>
                                <th>Salida</th>
                                <th>Huésp.</th>
                                <th>Estado</th>
                                <th>Importe</th>
                                <th class="text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (reservas.isEmpty()) {
                            %>
                            <tr><td colspan="9" class="text-center text-muted py-4">Sin resultados</td></tr>
                            <%
                            } else {
                                int i = 1;
                                for (Reserva r : reservas) {
                                    String badge = "bg-secondary";
                                    if ("pendiente".equals(r.getEstado()))
                                        badge = "bg-warning text-dark";
                                    else if ("confirmada".equals(r.getEstado()))
                                        badge = "bg-success";
                                    else if ("cancelada".equals(r.getEstado()))
                                        badge = "bg-danger";
                                    else if ("completada".equals(r.getEstado()))
                                        badge = "bg-primary";
                            %>
                            <tr>
                                <td><%= i++%></td>
                                <td><%= r.getHuespedNombre() == null ? "" : r.getHuespedNombre()%></td>
                                <td><%= r.getHabitacionNumero() == null ? "" : r.getHabitacionNumero()%></td>
                                <td><%= r.getFechaEntrada()%></td>
                                <td><%= r.getFechaSalida()%></td>
                                <td><%= r.getNumeroHuespedes() == null ? 0 : r.getNumeroHuespedes()%></td>
                                <td><span class="badge <%= badge%>"><%= r.getEstado()%></span></td>
                                <td>
                                    <%= r.getImporteEstimado() == null ? "-" : "$" + String.format(java.util.Locale.US, "%.2f", r.getImporteEstimado())%>
                                </td>
                                <td class="text-end">
                                    <!-- Cambiar estado -->
                                    <form action="<%=ctx%>/reservas" method="post" class="d-inline">
                                        <input type="hidden" name="op" value="estado">
                                        <input type="hidden" name="id" value="<%= r.getId()%>">
                                        <input type="hidden" name="estado" value="confirmada">
                                        <button class="btn btn-sm btn-outline-success">Confirmar</button>
                                    </form>
                                    <form action="<%=ctx%>/reservas" method="post" class="d-inline">
                                        <input type="hidden" name="op" value="estado">
                                        <input type="hidden" name="id" value="<%= r.getId()%>">
                                        <input type="hidden" name="estado" value="cancelada">
                                        <button class="btn btn-sm btn-outline-danger">Cancelar</button>
                                    </form>
                                    <form action="<%=ctx%>/reservas" method="post" class="d-inline">
                                        <input type="hidden" name="op" value="estado">
                                        <input type="hidden" name="id" value="<%= r.getId()%>">
                                        <input type="hidden" name="estado" value="completada">
                                        <button class="btn btn-sm btn-outline-primary">Completar</button>
                                    </form>
                                    <form action="<%=ctx%>/reservas" method="post" class="d-inline" onsubmit="return confirm('¿Eliminar reserva?');">
                                        <input type="hidden" name="op" value="delete">
                                        <input type="hidden" name="id" value="<%= r.getId()%>">
                                        <button class="btn btn-sm btn-outline-secondary">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- MODAL NUEVA RESERVA -->
        <div class="modal fade" id="mdlNueva" tabindex="-1">
            <div class="modal-dialog modal-lg"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/reservas" method="post">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">Nueva Reserva</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-6">
                                <label class="form-label">Huésped</label>
                                <select class="form-select" name="huespedId" required>
                                    <option value="">Seleccione…</option>
                                    <%
                                        for (Map<String, String> m : huespedesCombo) {
                                    %>
                                    <option value="<%= m.get("id")%>"><%= m.get("text")%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Habitación</label>
                                <select class="form-select" name="habitacionId" required>
                                    <option value="">Seleccione…</option>
                                    <%
                                        for (Map<String, String> m : habitacionesCombo) {
                                    %>
                                    <option value="<%= m.get("id")%>"><%= m.get("text")%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Entrada</label>
                                <input type="date" class="form-control" name="fechaEntrada" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Salida</label>
                                <input type="date" class="form-control" name="fechaSalida" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label"># Huéspedes</label>
                                <input type="number" class="form-control" name="numeroHuespedes" min="1" value="1" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Estado</label>
                                <select class="form-select" name="estado">
                                    <option>pendiente</option>
                                    <option>confirmada</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Observaciones</label>
                                <input class="form-control" name="observaciones">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary">Guardar</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div></div>
        </div>
    </body>
</html>


