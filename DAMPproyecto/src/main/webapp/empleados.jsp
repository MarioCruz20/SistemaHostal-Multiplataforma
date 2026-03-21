

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Empleado"%>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
    
    "unchecked")
    List<Empleado> empleados = (List<Empleado>) request.getAttribute("empleados");
    if (empleados == null) {
        empleados = java.util.Collections.emptyList();
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
        <title>Administrador - Empleados</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">🧑‍💼 Empleados</span>
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
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
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
                    <h4 class="m-0">Gestión de Empleados</h4>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlNuevo">+ Nuevo</button>
                </div>
            </div>

            <!-- Buscar -->
            <form class="row g-2 mb-3" action="<%=ctx%>/empleados" method="get">
                <input type="hidden" name="op" value="list">
                <div class="col-md-9">
                    <input class="form-control" name="q" placeholder="Nombre / DUI / Puesto"
                           value="<%= request.getParameter("q") == null ? "" : request.getParameter("q")%>">
                </div>
                <div class="col-md-3 d-grid">
                    <button class="btn btn-outline-secondary">Buscar</button>
                </div>
            </form>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th><th>Nombre</th><th>DUI</th><th>Teléfono</th><th>Email</th><th>Puesto</th><th>Contratación</th><th>Estado</th><th class="text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (empleados.isEmpty()) {
                            %>
                            <tr><td colspan="9" class="text-center text-muted py-4">Sin resultados</td></tr>
                            <%
                            } else {
                                int i = 1;
                                for (Empleado e : empleados) {
                                    String badge = e.getEstado() != null && e.getEstado() ? "bg-success" : "bg-secondary";
                            %>
                            <tr>
                                <td><%= i++%></td>
                                <td><%= e.getNombre()%></td>
                                <td><%= e.getDui() == null ? "" : e.getDui()%></td>
                                <td><%= e.getTelefono() == null ? "" : e.getTelefono()%></td>
                                <td><%= e.getEmail() == null ? "" : e.getEmail()%></td>
                                <td><%= e.getPuesto() == null ? "" : e.getPuesto()%></td>
                                <td><%= e.getFechaContratacion() == null ? "" : e.getFechaContratacion()%></td>
                                <td><span class="badge <%=badge%>"><%= (e.getEstado() != null && e.getEstado()) ? "Activo" : "Inactivo"%></span></td>
                                <td class="text-end">
                                    <!-- Editar: rellena modal -->
                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                            data-bs-toggle="modal" data-bs-target="#mdlEditar"
                                            data-id="<%=e.getId()%>" data-nombre="<%=e.getNombre()%>" data-dui="<%=e.getDui()%>"
                                            data-telefono="<%=e.getTelefono()%>" data-email="<%=e.getEmail()%>"
                                            data-puesto="<%=e.getPuesto()%>" data-fecha="<%=e.getFechaContratacion()%>"
                                            data-estado="<%=(e.getEstado() != null && e.getEstado()) ? 1 : 0%>">
                                        Editar
                                    </button>
                                    <!-- Eliminar -->
                                    <form action="<%=ctx%>/empleados" method="post" class="d-inline" onsubmit="return confirm('¿Eliminar empleado?');">
                                        <input type="hidden" name="op" value="delete">
                                        <input type="hidden" name="id" value="<%= e.getId()%>">
                                        <button class="btn btn-sm btn-outline-danger">Eliminar</button>
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

        <!-- Modal Nuevo -->
        <div class="modal fade" id="mdlNuevo" tabindex="-1">
            <div class="modal-dialog modal-lg"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/empleados" method="post">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">Nuevo Empleado</h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-6"><label class="form-label">Nombre</label><input name="nombre" class="form-control" required></div>
                            <div class="col-md-3"><label class="form-label">DUI</label><input name="dui" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Teléfono</label><input name="telefono" class="form-control"></div>
                            <div class="col-md-6"><label class="form-label">Email</label><input type="email" name="email" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Puesto</label><input name="puesto" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Fecha Contratación</label><input type="date" name="fechaContratacion" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Estado</label>
                                <select name="estado" class="form-select"><option value="1">Activo</option><option value="0">Inactivo</option></select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary">Guardar</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div></div>
        </div>

        <!-- Modal Editar -->
        <div class="modal fade" id="mdlEditar" tabindex="-1">
            <div class="modal-dialog modal-lg"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/empleados" method="post">
                        <input type="hidden" name="op" value="update">
                        <input type="hidden" name="id" id="e-id">
                        <div class="modal-header">
                            <h5 class="modal-title">Editar Empleado</h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-6"><label class="form-label">Nombre</label><input name="nombre" id="e-nombre" class="form-control" required></div>
                            <div class="col-md-3"><label class="form-label">DUI</label><input name="dui" id="e-dui" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Teléfono</label><input name="telefono" id="e-telefono" class="form-control"></div>
                            <div class="col-md-6"><label class="form-label">Email</label><input type="email" name="email" id="e-email" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Puesto</label><input name="puesto" id="e-puesto" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Fecha Contratación</label><input type="date" name="fechaContratacion" id="e-fecha" class="form-control"></div>
                            <div class="col-md-3"><label class="form-label">Estado</label>
                                <select name="estado" id="e-estado" class="form-select"><option value="1">Activo</option><option value="0">Inactivo</option></select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary">Guardar cambios</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div></div>
        </div>

        <script>
            const mdlEditar = document.getElementById('mdlEditar');
            mdlEditar.addEventListener('show.bs.modal', event => {
                const btn = event.relatedTarget;
                document.getElementById('e-id').value = btn.getAttribute('data-id');
                document.getElementById('e-nombre').value = btn.getAttribute('data-nombre') || '';
                document.getElementById('e-dui').value = btn.getAttribute('data-dui') || '';
                document.getElementById('e-telefono').value = btn.getAttribute('data-telefono') || '';
                document.getElementById('e-email').value = btn.getAttribute('data-email') || '';
                document.getElementById('e-puesto').value = btn.getAttribute('data-puesto') || '';
                // fecha yyyy-mm-dd ya viene en el value del input date
                document.getElementById('e-fecha').value = (btn.getAttribute('data-fecha') || '');
                document.getElementById('e-estado').value = btn.getAttribute('data-estado') || '1';
            });
        </script>
    </body>
</html>

