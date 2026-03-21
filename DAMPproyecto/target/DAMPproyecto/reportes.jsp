<%-- 
    Document   : reportes
    Created on : 11 nov. 2025, 16:55:23
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map,java.util.Set"%>
<%
    String ctx = request.getContextPath();
    
    @SuppressWarnings("unchecked")
    List<Map<String, String>> datosReporte = (List<Map<String, String>>) request.getAttribute("datosReporte");
    if (datosReporte == null) {
        datosReporte = java.util.Collections.emptyList();
    }
    
    Boolean reporteGenerado = (Boolean) request.getAttribute("reporteGenerado");
    if (reporteGenerado == null) {
        reporteGenerado = false;
    }
    
    String tipoReporte = request.getParameter("tipo");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Administrador - Reportes</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">📊 Reportes</span>
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuAdmin">
            <div class="offcanvas-header"><h5 class="offcanvas-title">Menú Admin</h5><button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button></div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/dashboard">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitaciones?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedes?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/usuarios?op=list">⚙️ Usuarios / Roles</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/proveedores">🚚 Proveedores</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/reportes">📊 Reportes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/graficos.jsp">📈 Gráficos</a></li>
                </ul>
            </div>
        </div>

        <main class="content container-fluid">
            <div class="row g-3">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="mb-0">📊 Generador de Reportes</h4>
                                <span class="text-muted">Seleccione el tipo de reporte y configure los filtros</span>
                            </div>
                            
                            <div class="row g-3 mb-4">
                                <!-- Reporte de Reservas -->
                                <div class="col-md-8 mx-auto">
                                    <div class="card border h-100">
                                        <div class="card-body">
                                            <h6 class="card-title mb-3">
                                                <span class="badge bg-primary me-2">📅</span>
                                                Reporte de Reservas
                                            </h6>
                                            <p class="text-muted small mb-3">Genera un reporte de reservas con información de huéspedes y habitaciones ocupadas desde la base de datos</p>
                                            <form action="<%=ctx%>/reportes" method="post" class="row g-2">
                                                <input type="hidden" name="tipo" value="reservas">
                                                <div class="col-md-6">
                                                    <label class="form-label small">Fecha Inicio <span class="text-danger">*</span></label>
                                                    <input type="date" name="fechaInicio" class="form-control form-control-sm" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small">Fecha Fin <span class="text-danger">*</span></label>
                                                    <input type="date" name="fechaFin" class="form-control form-control-sm" required>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label small">Habitación (opcional)</label>
                                                    <input type="text" name="habitacion" class="form-control form-control-sm" placeholder="Ej: 101 - Dejar vacío para todas las habitaciones">
                                                </div>
                                                <div class="col-12">
                                                    <button type="submit" class="btn btn-primary btn-sm w-100">🔍 Ver Vista Previa</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Resultados del reporte -->
                            <% if (reporteGenerado && !datosReporte.isEmpty()) { %>
                            <hr class="my-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">📋 Resultados del Reporte</h5>
                                <a href="<%=ctx%>/reportes?tipo=download&formato=html" class="btn btn-primary btn-sm">
                                    📥 Descargar Reporte HTML
                                </a>
                            </div>
                            
                            <div class="card shadow-sm">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle m-0">
                                        <thead class="table-light">
                                            <tr>
                                                <% 
                                                    if (!datosReporte.isEmpty()) {
                                                        Set<String> columnas = datosReporte.get(0).keySet();
                                                        for (String col : columnas) {
                                                %>
                                                <th><%= col.substring(0, 1).toUpperCase() + col.substring(1).replaceAll("([A-Z])", " $1")%></th>
                                                <% 
                                                        }
                                                    }
                                                %>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                if (datosReporte.isEmpty()) {
                                            %>
                                            <tr>
                                                <td colspan="10" class="text-center text-muted py-4">No hay datos para mostrar</td>
                                            </tr>
                                            <%
                                                } else {
                                                    int i = 1;
                                                    for (Map<String, String> fila : datosReporte) {
                                            %>
                                            <tr>
                                                <% 
                                                    Set<String> columnas = fila.keySet();
                                                    for (String col : columnas) {
                                                %>
                                                <td><%= fila.get(col) != null ? fila.get(col) : ""%></td>
                                                <% 
                                                    }
                                                %>
                                            </tr>
                                            <%
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <% } else if (reporteGenerado && datosReporte.isEmpty()) { %>
                            <hr class="my-4">
                            <div class="alert alert-warning">
                                <strong>⚠️ Sin resultados</strong><br>
                                No se encontraron datos con los filtros seleccionados. Intente con otros parámetros.
                            </div>
                            <% } else { %>
                            <div class="alert alert-info">
                                <strong>ℹ️ Instrucciones:</strong><br>
                                1. Seleccione el rango de fechas para el reporte (campos requeridos)<br>
                                2. Opcionalmente, filtre por número de habitación específica<br>
                                3. Haga clic en "Ver Vista Previa" para ver los resultados desde la base de datos<br>
                                4. Use el botón "Descargar Reporte HTML" para exportar el reporte completo
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>

