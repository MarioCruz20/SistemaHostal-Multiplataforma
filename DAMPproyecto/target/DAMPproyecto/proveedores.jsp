<%-- 
    Document   : proveedores
    Created on : 11 nov. 2025, 16:55:01
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map"%>
<%
    String ctx = request.getContextPath();
    
    @SuppressWarnings("unchecked")
    List<Map<String, String>> proveedores = (List<Map<String, String>>) request.getAttribute("proveedores");
    if (proveedores == null) {
        proveedores = java.util.Collections.emptyList();
    }
    
    String flash = null;
    if (session != null) {
        flash = (String) session.getAttribute("flash");
        if (flash != null) {
            session.removeAttribute("flash");
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Administrador - Proveedores</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">🚚 Proveedores</span>
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
                    <li class="nav-item mb-3"><a class="nav-link active text-white" href="<%=ctx%>/proveedores">🚚 Proveedores</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reportes">📊 Reportes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/graficos.jsp">📈 Gráficos</a></li>
                </ul>
            </div>
        </div>

        <main class="content container-fluid">
            <% if (flash != null) {%>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= flash%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% }%>
            
            <div class="row g-3">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">Gestión de Proveedores</h4>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlNuevoProv">+ Nuevo Proveedor</button>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <form class="row g-2 mb-3" action="<%=ctx%>/proveedores" method="get">
                                <div class="col-md-4">
                                    <input class="form-control" name="q" placeholder="Nombre / Contacto" value="<%= request.getParameter("q") == null ? "" : request.getParameter("q")%>">
                                </div>
                                <div class="col-md-3">
                                    <input class="form-control" name="telefono" placeholder="Teléfono" value="<%= request.getParameter("telefono") == null ? "" : request.getParameter("telefono")%>">
                                </div>
                                <div class="col-md-3">
                                    <input type="email" class="form-control" name="email" placeholder="Email" value="<%= request.getParameter("email") == null ? "" : request.getParameter("email")%>">
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-outline-secondary w-100">Buscar</button>
                                </div>
                            </form>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Nombre</th>
                                            <th>Contacto</th>
                                            <th>Teléfono</th>
                                            <th>Email</th>
                                            <th>Dirección</th>
                                            <th class="text-end">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (proveedores.isEmpty()) {
                                        %>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">Sin proveedores registrados</td>
                                        </tr>
                                        <%
                                            } else {
                                                int i = 1;
                                                for (Map<String, String> p : proveedores) {
                                        %>
                                        <tr>
                                            <td><%= i++%></td>
                                            <td><strong><%= p.get("nombre")%></strong></td>
                                            <td><%= p.get("contacto")%></td>
                                            <td><%= p.get("telefono")%></td>
                                            <td><%= p.get("email")%></td>
                                            <td><%= p.get("direccion")%></td>
                                            <td class="text-end">
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#mdlEditar"
                                                        data-id="<%= p.get("id")%>"
                                                        data-nombre="<%= p.get("nombre")%>"
                                                        data-contacto="<%= p.get("contacto")%>"
                                                        data-telefono="<%= p.get("telefono")%>"
                                                        data-email="<%= p.get("email")%>"
                                                        data-direccion="<%= p.get("direccion")%>">Editar</button>
                                                <form action="<%=ctx%>/proveedores" method="post" class="d-inline" onsubmit="return confirm('¿Eliminar proveedor?');">
                                                    <input type="hidden" name="op" value="delete">
                                                    <input type="hidden" name="id" value="<%= p.get("id")%>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">Eliminar</button>
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
                </div>
            </div>
        </main>

        <!-- Modal nuevo proveedor -->
        <div class="modal fade" id="mdlNuevoProv" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/proveedores" method="post">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">Nuevo Proveedor</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-12">
                                <label class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input class="form-control" name="nombre" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contacto</label>
                                <input class="form-control" name="contacto">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Teléfono</label>
                                <input class="form-control" name="telefono" placeholder="0000-0000">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Dirección</label>
                                <input class="form-control" name="direccion">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Modal editar proveedor -->
        <div class="modal fade" id="mdlEditar" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/proveedores" method="post">
                        <input type="hidden" name="op" value="update">
                        <input type="hidden" name="id" id="e-id">
                        <div class="modal-header">
                            <h5 class="modal-title">Editar Proveedor</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-12">
                                <label class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input class="form-control" name="nombre" id="e-nombre" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contacto</label>
                                <input class="form-control" name="contacto" id="e-contacto">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Teléfono</label>
                                <input class="form-control" name="telefono" id="e-telefono">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" id="e-email">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Dirección</label>
                                <input class="form-control" name="direccion" id="e-direccion">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <script>
            const mdlEditar = document.getElementById('mdlEditar');
            mdlEditar.addEventListener('show.bs.modal', ev => {
                const b = ev.relatedTarget;
                document.getElementById('e-id').value = b.getAttribute('data-id') || '';
                document.getElementById('e-nombre').value = b.getAttribute('data-nombre') || '';
                document.getElementById('e-contacto').value = b.getAttribute('data-contacto') || '';
                document.getElementById('e-telefono').value = b.getAttribute('data-telefono') || '';
                document.getElementById('e-email').value = b.getAttribute('data-email') || '';
                document.getElementById('e-direccion').value = b.getAttribute('data-direccion') || '';
            });
        </script>
    </body>
</html>

