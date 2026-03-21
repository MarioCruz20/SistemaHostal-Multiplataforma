<%-- 
    Document   : usuarios
    Created on : 12 nov. 2025, 06:30:58
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Map"%>
<%@page import="model.Usuario"%>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
    
    "unchecked")
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    if (usuarios == null) {
        usuarios = java.util.Collections.emptyList();
    }
    @SuppressWarnings(
    
    "unchecked")
    List<Map<String, String>> rolesCombo = (List<Map<String, String>>) request.getAttribute("rolesCombo");
    if (rolesCombo == null) {
        rolesCombo = java.util.Collections.emptyList();
    }
    @SuppressWarnings(
    
    "unchecked")
    List<Map<String, String>> empleadosCombo = (List<Map<String, String>>) request.getAttribute("empleadosCombo");
    if (empleadosCombo == null) {
        empleadosCombo = java.util.Collections.emptyList();
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
        <title>Administrador - Usuarios</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">⚙️ Usuarios / Roles</span>
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuAdmin">
            <div class="offcanvas-header"><h5 class="offcanvas-title">Menú</h5><button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button></div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/usuarios.jsp">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitaciones?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedes?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/usuarios?op=list">⚙️ Usuarios / Roles</a></li>
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
                    <h4 class="m-0">Gestión de Usuarios</h4>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlNuevo">+ Nuevo</button>
                </div>
            </div>

            <!-- Buscar -->
            <form class="row g-2 mb-3" action="<%=ctx%>/usuarios" method="get">
                <input type="hidden" name="op" value="list">
                <div class="col-md-9"><input class="form-control" name="q" placeholder="Usuario / Rol / Empleado" value="<%= request.getParameter("q") == null ? "" : request.getParameter("q")%>"></div>
                <div class="col-md-3 d-grid"><button class="btn btn-outline-secondary">Buscar</button></div>
            </form>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th><th>Usuario</th><th>Rol</th><th>Empleado</th><th>Estado</th><th class="text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (usuarios.isEmpty()) {
                            %>
                            <tr><td colspan="6" class="text-center text-muted py-4">Sin resultados</td></tr>
                            <%
                            } else {
                                int i = 1;
                                for (Usuario u : usuarios) {
                                    String badge = (u.getEstado() != null && u.getEstado()) ? "bg-success" : "bg-secondary";
                            %>
                            <tr>
                                <td><%= i++%></td>
                                <td><%= u.getUsuario()%></td>
                                <td><%= u.getRolNombre() == null ? "" : u.getRolNombre()%></td>
                                <td><%= u.getEmpleadoNombre() == null ? "" : u.getEmpleadoNombre()%></td>
                                <td><span class="badge <%=badge%>"><%= (u.getEstado() != null && u.getEstado()) ? "Activo" : "Inactivo"%></span></td>
                                <td class="text-end">
                                    <!-- Edit -->
                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                            data-bs-toggle="modal" data-bs-target="#mdlEditar"
                                            data-id="<%=u.getId()%>" data-rol="<%=u.getRolId()%>" data-emp="<%=u.getEmpleadoId()%>"
                                            data-estado="<%=(u.getEstado() != null && u.getEstado()) ? 1 : 0%>">Editar</button>
                                    <!-- Reset pass -->
                                    <button type="button" class="btn btn-sm btn-outline-warning"
                                            data-bs-toggle="modal" data-bs-target="#mdlReset"
                                            data-id="<%=u.getId()%>">Reset Pass</button>
                                    <!-- Delete -->
                                    <form action="<%=ctx%>/usuarios" method="post" class="d-inline" onsubmit="return confirm('¿Eliminar usuario?');">
                                        <input type="hidden" name="op" value="delete">
                                        <input type="hidden" name="id" value="<%=u.getId()%>">
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
            <div class="modal-dialog"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/usuarios" method="post" autocomplete="off">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header"><h5 class="modal-title">Nuevo Usuario</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
                        <div class="modal-body">
                            <div class="col-12"><label class="form-label">Usuario</label><input name="usuario" class="form-control" required></div>
                            <div class="col-12"><label class="form-label">Contraseña</label><input type="password" name="password" class="form-control" required></div>
                            <div class="col-12"><label class="form-label">Rol</label>
                                <select class="form-select" name="rolId" required>
                                    <option value="">Seleccione…</option>
                                    <% for (Map<String, String> r : rolesCombo) {%>
                                    <option value="<%=r.get("id")%>"><%=r.get("text")%></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-12"><label class="form-label">Empleado (opcional)</label>
                                <select class="form-select" name="empleadoId">
                                    <option value="">—</option>
                                    <% for (Map<String, String> e : empleadosCombo) {%>
                                    <option value="<%=e.get("id")%>"><%=e.get("text")%></option>
                                    <% }%>
                                </select>
                            </div>
                            <div class="col-12"><label class="form-label">Estado</label>
                                <select class="form-select" name="estado"><option value="1">Activo</option><option value="0">Inactivo</option></select>
                            </div>
                        </div>
                        <div class="modal-footer"><button class="btn btn-primary">Guardar</button><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                    </form>
                </div></div>
        </div>

        <!-- Modal Editar -->
        <div class="modal fade" id="mdlEditar" tabindex="-1">
            <div class="modal-dialog"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/usuarios" method="post">
                        <input type="hidden" name="op" value="update">
                        <input type="hidden" name="id" id="u-id">
                        <div class="modal-header"><h5 class="modal-title">Editar Usuario</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
                        <div class="modal-body">
                            <div class="col-12"><label class="form-label">Rol</label>
                                <select class="form-select" name="rolId" id="u-rol">
                                    <% for (Map<String, String> r : rolesCombo) {%>
                                    <option value="<%=r.get("id")%>"><%=r.get("text")%></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-12"><label class="form-label">Empleado</label>
                                <select class="form-select" name="empleadoId" id="u-emp">
                                    <option value="">—</option>
                                    <% for (Map<String, String> e : empleadosCombo) {%>
                                    <option value="<%=e.get("id")%>"><%=e.get("text")%></option>
                                    <% }%>
                                </select>
                            </div>
                            <div class="col-12"><label class="form-label">Estado</label>
                                <select class="form-select" name="estado" id="u-estado"><option value="1">Activo</option><option value="0">Inactivo</option></select>
                            </div>
                        </div>
                        <div class="modal-footer"><button class="btn btn-primary">Guardar cambios</button><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                    </form>
                </div></div>
        </div>

        <!-- Modal Reset Password -->
        <div class="modal fade" id="mdlReset" tabindex="-1">
            <div class="modal-dialog"><div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/usuarios" method="post" autocomplete="off">
                        <input type="hidden" name="op" value="reset">
                        <input type="hidden" name="id" id="r-id">
                        <div class="modal-header"><h5 class="modal-title">Resetear Contraseña</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
                        <div class="modal-body">
                            <div class="col-12"><label class="form-label">Nueva contraseña</label><input type="password" name="newpass" class="form-control" required></div>
                        </div>
                        <div class="modal-footer"><button class="btn btn-warning">Actualizar</button><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button></div>
                    </form>
                </div></div>
        </div>

        <script>
            const mdlEditar = document.getElementById('mdlEditar');
            mdlEditar.addEventListener('show.bs.modal', ev => {
                const b = ev.relatedTarget;
                document.getElementById('u-id').value = b.getAttribute('data-id');
                document.getElementById('u-rol').value = b.getAttribute('data-rol') || '';
                document.getElementById('u-emp').value = b.getAttribute('data-emp') || '';
                document.getElementById('u-estado').value = b.getAttribute('data-estado') || '1';
            });

            const mdlReset = document.getElementById('mdlReset');
            mdlReset.addEventListener('show.bs.modal', ev => {
                const b = ev.relatedTarget;
                document.getElementById('r-id').value = b.getAttribute('data-id');
            });
        </script>
    </body>
</html>

