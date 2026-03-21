<%-- 
    Document   : huespedes
    Created on : 11 nov. 2025, 16:52:37
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Huesped"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings(
    
    "unchecked")
    List<Huesped> huespedes = (List<Huesped>) request.getAttribute("huespedes");
    if (huespedes == null) {
        huespedes = java.util.Collections.emptyList();
    }

    String flash = null;
    if (session != null) {
        flash = (String) session.getAttribute("flash");
        if (flash != null) {
            session.removeAttribute("flash");
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Administrador - Huéspedes</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <span class="navbar-text mx-auto text-white fw-semibold">👥 Huéspedes</span>
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuAdmin">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title">Menú Admin</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/dashboard">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitaciones?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/huespedes?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/usuarios?op=list">⚙️ Usuarios / Roles</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/proveedores">🚚 Proveedores</a></li>
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
                            <h4 class="mb-0">Gestión de Huéspedes</h4>
                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#mdlNuevo">+ Nuevo</button>
                        </div>
                    </div>
                </div>

                <!-- BUSCAR -->
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <form class="row g-2 mb-3" action="<%=ctx%>/huespedes" method="get">
                                <input type="hidden" name="op" value="list">
                                <div class="col-md-9">
                                    <input class="form-control" name="q" placeholder="Nombre / DUI / Teléfono"
                                           value="<%= request.getParameter("q") == null ? "" : request.getParameter("q")%>">
                                </div>
                                <div class="col-md-3 d-grid">
                                    <button class="btn btn-outline-secondary w-100">Buscar</button>
                                </div>
                            </form>

                            <!-- TABLA -->
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th><th>Nombre</th><th>DUI/Pass</th><th>Teléfono</th><th>Email</th><th>Visitas</th><th class="text-end">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (huespedes.isEmpty()) {
                                        %>
                                        <tr><td colspan="7" class="text-center text-muted py-4">Sin resultados</td></tr>
                                        <%
                                        } else {
                                            int i = 1;
                                            for (Huesped h : huespedes) {
                                                String fechaStr = (h.getFechaNacimiento() != null) ? sdf.format(h.getFechaNacimiento()) : "";
                                        %>
                                        <tr>
                                            <td><%= i++%></td>
                                            <td><%= h.getNombre()%></td>
                                            <td><%= h.getDui() == null ? "" : h.getDui()%></td>
                                            <td><%= h.getTelefono() == null ? "" : h.getTelefono()%></td>
                                            <td><%= h.getEmail() == null ? "" : h.getEmail()%></td>
                                            <td><%= h.getVisitasPrevias() == null ? 0 : h.getVisitasPrevias()%></td>
                                            <td class="text-end">
                                                <!-- botón editar -->
                                                <button type="button"
                                                        class="btn btn-sm btn-outline-primary"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#mdlEditar"
                                                        data-id="<%=h.getId()%>"
                                                        data-nombre="<%=h.getNombre()%>"
                                                        data-fecha="<%=fechaStr%>"
                                                        data-sexo="<%=h.getSexo() == null ? "" : h.getSexo()%>"
                                                        data-direccion="<%=h.getDireccion() == null ? "" : h.getDireccion()%>"
                                                        data-telefono="<%=h.getTelefono() == null ? "" : h.getTelefono()%>"
                                                        data-dui="<%=h.getDui() == null ? "" : h.getDui()%>"
                                                        data-email="<%=h.getEmail() == null ? "" : h.getEmail()%>"
                                                        data-visitas="<%=h.getVisitasPrevias() == null ? 0 : h.getVisitasPrevias()%>">
                                                    Editar
                                                </button>

                                                <!-- eliminar -->
                                                <form action="<%=ctx%>/huespedes" method="post" class="d-inline"
                                                      onsubmit="return confirm('¿Eliminar huésped?');">
                                                    <input type="hidden" name="op" value="delete">
                                                    <input type="hidden" name="id" value="<%= h.getId()%>">
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
                </div>
            </div>
        </main>

        <!-- MODAL NUEVO -->
        <div class="modal fade" id="mdlNuevo" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/huespedes" method="post">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">Nuevo Huésped</h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-6">
                                <label class="form-label">Nombre</label>
                                <input class="form-control" name="nombre" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Fecha Nac.</label>
                                <input type="date" class="form-control" name="fechaNacimiento">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Sexo</label>
                                <select class="form-select" name="sexo">
                                    <option value="">-</option><option>M</option><option>F</option><option>O</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Dirección</label>
                                <input class="form-control" name="direccion">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Teléfono</label>
                                <input class="form-control" name="telefono">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">DUI/Pasaporte</label>
                                <input class="form-control" name="dui">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Visitas previas</label>
                                <input type="number" class="form-control" name="visitasPrevias" value="0" min="0">
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

        <!-- MODAL EDITAR -->
        <div class="modal fade" id="mdlEditar" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form class="row g-3" action="<%=ctx%>/huespedes" method="post">
                        <input type="hidden" name="op" value="update">
                        <input type="hidden" name="id" id="e-id">
                        <div class="modal-header">
                            <h5 class="modal-title">Editar Huésped</h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="col-md-6">
                                <label class="form-label">Nombre</label>
                                <input class="form-control" name="nombre" id="e-nombre" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Fecha Nac.</label>
                                <input type="date" class="form-control" name="fechaNacimiento" id="e-fecha">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Sexo</label>
                                <select class="form-select" name="sexo" id="e-sexo">
                                    <option value="">-</option><option>M</option><option>F</option><option>O</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Dirección</label>
                                <input class="form-control" name="direccion" id="e-direccion">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Teléfono</label>
                                <input class="form-control" name="telefono" id="e-telefono">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">DUI/Pasaporte</label>
                                <input class="form-control" name="dui" id="e-dui">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" id="e-email">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Visitas previas</label>
                                <input type="number" class="form-control" name="visitasPrevias" id="e-visitas" min="0">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary">Guardar cambios</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            const mdlEditar = document.getElementById('mdlEditar');
            mdlEditar.addEventListener('show.bs.modal', ev => {
                const b = ev.relatedTarget;
                document.getElementById('e-id').value = b.getAttribute('data-id');
                document.getElementById('e-nombre').value = b.getAttribute('data-nombre') || '';
                document.getElementById('e-fecha').value = b.getAttribute('data-fecha') || '';
                document.getElementById('e-sexo').value = b.getAttribute('data-sexo') || '';
                document.getElementById('e-direccion').value = b.getAttribute('data-direccion') || '';
                document.getElementById('e-telefono').value = b.getAttribute('data-telefono') || '';
                document.getElementById('e-dui').value = b.getAttribute('data-dui') || '';
                document.getElementById('e-email').value = b.getAttribute('data-email') || '';
                document.getElementById('e-visitas').value = b.getAttribute('data-visitas') || '0';
            });
        </script>
    </body>
</html>
