<%-- 
    Document   : habitacionesUsuario
    Created on : 17 nov. 2025, 02:55:29
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Habitacion"%>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
            
    
    "unchecked")
    List<Habitacion> habitaciones = (List<Habitacion>) request.getAttribute("habitaciones");
    if (habitaciones == null) {
        habitaciones = java.util.Collections.emptyList();
    }

    // Flash desde sesión (opcional)
    String flash = null;
    if (session != null && session.getAttribute("flash") != null) {
        flash = (String) session.getAttribute("flash");
        session.removeAttribute("flash");
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Habitaciones - Usuario</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <!-- Navbar superior -->
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">

                <!-- Botón hamburguesa (menú lateral) -->
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuLateral" aria-controls="menuLateral">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Título centrado -->
                <span class="navbar-text mx-auto text-white fw-semibold">
                    Usuario • Habitaciones
                </span>

                <!-- Botón Salir -->
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <!-- Menú lateral -->
        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuLateral" aria-labelledby="menuLateralLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="menuLateralLabel">Menú</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/dashboardUsuario">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/habitacionesUsuario?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedesUsuario?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservasUsuario?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagosUsuario">💳 Pagos</a></li>
                    <li class="nav-item mt-3"><hr class="border-secondary"></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%=ctx%>/Logout">🚪 Cerrar sesión</a></li>
                </ul>
            </div>
        </div>

        <!-- Contenido -->
        <div class="container my-4">

            <% if (flash != null) {%>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= flash%>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <% }%>

            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
                <h4 class="m-0">Listado de habitaciones</h4>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNueva">
                    + Nueva habitación
                </button>
            </div>

            <!-- Filtros -->
            <form class="row g-2 mb-3" action="<%=ctx%>/habitacionesUsuario" method="get">
                <input type="hidden" name="op" value="list">
                <div class="col-md-4">
                    <input name="q" class="form-control" placeholder="Buscar por número">
                </div>
                <div class="col-md-4">
                    <select name="tipo" class="form-select">
                        <option value="">Tipo</option>
                        <option>individual</option>
                        <option>doble</option>
                        <option>familiar</option>
                        <option>suite</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="estado" class="form-select">
                        <option value="">Estado</option>
                        <option>disponible</option>
                        <option>ocupada</option>
                        <option>limpieza</option>
                        <option>mantenimiento</option>
                    </select>
                </div>
                <div class="col-md-1 d-grid">
                    <button class="btn btn-outline-secondary">Filtrar</button>
                </div>
            </form>

            <!-- Tabla -->
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Número</th>
                                <th>Tipo</th>
                                <th>Capacidad</th>
                                <th>Precio/día</th>
                                <th>Estado</th>
                                <th class="text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (habitaciones.isEmpty()) {
                            %>
                            <tr><td colspan="7" class="text-center text-muted py-4">Sin resultados</td></tr>
                            <%
                            } else {
                                int i = 1;
                                for (Habitacion h : habitaciones) {
                                    String badge = "bg-secondary";
                                    if ("disponible".equals(h.getEstado()))
                                        badge = "bg-success";
                                    else if ("ocupada".equals(h.getEstado()))
                                        badge = "bg-primary";
                                    else if ("limpieza".equals(h.getEstado()))
                                        badge = "bg-warning text-dark";
                                    else if ("mantenimiento".equals(h.getEstado()))
                                        badge = "bg-danger";
                            %>
                            <tr>
                                <td><%= (i++)%></td>
                                <td><%= h.getNumero()%></td>
                                <td><%= h.getTipo()%></td>
                                <td><%= h.getCapacidad()%></td>
                                <td>$<%= String.format(java.util.Locale.US, "%.2f", h.getPrecioDia())%></td>
                                <td><span class="badge <%= badge%>"><%= h.getEstado()%></span></td>
                                <td class="text-end">
                                    <!-- Cambiar estado rápido -->
                                    <div class="btn-group btn-group-sm" role="group">
                                        <form action="<%=ctx%>/habitacionesUsuario" method="post" class="d-inline">
                                            <input type="hidden" name="op" value="estado">
                                            <input type="hidden" name="id" value="<%= h.getId()%>">
                                            <input type="hidden" name="estado" value="disponible">
                                            <button class="btn btn-outline-success" title="Marcar como disponible">✓ Disponible</button>
                                        </form>
                                        <form action="<%=ctx%>/habitacionesUsuario" method="post" class="d-inline">
                                            <input type="hidden" name="op" value="estado">
                                            <input type="hidden" name="id" value="<%= h.getId()%>">
                                            <input type="hidden" name="estado" value="ocupada">
                                            <button class="btn btn-outline-primary" title="Marcar como ocupada">🏠 Ocupada</button>
                                        </form>
                                        <form action="<%=ctx%>/habitacionesUsuario" method="post" class="d-inline">
                                            <input type="hidden" name="op" value="estado">
                                            <input type="hidden" name="id" value="<%= h.getId()%>">
                                            <input type="hidden" name="estado" value="limpieza">
                                            <button class="btn btn-outline-warning" title="Marcar en limpieza">🧹 Limpieza</button>
                                        </form>
                                        <form action="<%=ctx%>/habitacionesUsuario" method="post" class="d-inline">
                                            <input type="hidden" name="op" value="estado">
                                            <input type="hidden" name="id" value="<%= h.getId()%>">
                                            <input type="hidden" name="estado" value="mantenimiento">
                                            <button class="btn btn-outline-danger" title="Marcar en mantenimiento">🔧 Mantenimiento</button>
                                        </form>
                                    </div>
                                    <form action="<%=ctx%>/habitacionesUsuario" method="post" class="d-inline mt-1" onsubmit="return confirm('¿Eliminar habitación?');">
                                        <input type="hidden" name="op" value="delete">
                                        <input type="hidden" name="id" value="<%= h.getId()%>">
                                        <button class="btn btn-sm btn-outline-secondary">🗑️ Eliminar</button>
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

        <!-- Modal: Nueva habitación -->
        <div class="modal fade" id="modalNueva" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/habitacionesUsuario" method="post">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">Nueva habitación</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-4">
                                <label class="form-label">Número</label>
                                <input name="numero" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tipo</label>
                                <select name="tipo" class="form-select" required>
                                    <option>individual</option><option>doble</option><option>familiar</option><option>suite</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Capacidad</label>
                                <input name="capacidad" type="number" min="1" value="1" class="form-control" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Precio Día</label>
                                <input name="precioDia" type="number" step="0.01" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Precio Noche</label>
                                <input name="precioNoche" type="number" step="0.01" class="form-control">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Precio Fin Semana</label>
                                <input name="precioFinSemana" type="number" step="0.01" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Estado</label>
                                <select name="estado" class="form-select">
                                    <option>disponible</option><option>ocupada</option><option>limpieza</option><option>mantenimiento</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Servicios</label>
                                <input name="servicios" class="form-control" placeholder="wi-fi, aire, tv...">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary">Guardar</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
