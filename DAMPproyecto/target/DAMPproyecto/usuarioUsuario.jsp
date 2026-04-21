<%-- 
    Document   : usuarioUsuario
    Created on : 9 nov. 2025
    Author     : cresp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%
    String ctx = request.getContextPath();
    HttpSession ses = request.getSession(false);
    String role = (ses != null) ? (String) ses.getAttribute("rol") : null;
    String username = (ses != null) ? (String) ses.getAttribute("username") : null;

    // Solo verificamos que esté logueado, SIN forzar rol ADMIN
    if (role == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    
    // Obtener datos del dashboard desde el servlet
    Double ocupacionHoy = (Double) request.getAttribute("ocupacionHoy");
    Double ingresosMes = (Double) request.getAttribute("ingresosMes");
    Integer reservasActivas = (Integer) request.getAttribute("reservasActivas");
    Integer huespedesFrecuentes = (Integer) request.getAttribute("huespedesFrecuentes");
    Double variacionIngresos = (Double) request.getAttribute("variacionIngresos");
    Double variacionOcupacion = (Double) request.getAttribute("variacionOcupacion");
    
    // Valores por defecto si no vienen del servlet
    if (ocupacionHoy == null) ocupacionHoy = 0.0;
    if (ingresosMes == null) ingresosMes = 0.0;
    if (reservasActivas == null) reservasActivas = 0;
    if (huespedesFrecuentes == null) huespedesFrecuentes = 0;
    if (variacionIngresos == null) variacionIngresos = 0.0;
    if (variacionOcupacion == null) variacionOcupacion = 0.0;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Usuario - Hostal</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            .brand-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                display: inline-block;
                background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                margin-right: 0.75rem;
                box-shadow: 0 0 10px rgba(59, 130, 246, 0.5);
            }
        </style>
    </head>
    <body class="bg-light">

        <!-- Navbar superior -->
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <!-- Hamburguesa -->
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuLateralAdmin" aria-controls="menuLateralAdmin">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Título -->
                <span class="navbar-text mx-auto text-white fw-semibold">
                    <span class="brand-dot"></span> Panel de Usuario
                </span>

                <!-- Usuario + Salir -->
                <div class="d-flex align-items-center gap-2">
                    <span class="text-white-50 small d-none d-sm-inline"><%= (username != null ? username : "Usuario")%></span>
                    <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
                </div>
            </div>
        </nav>

        <!-- Menú lateral (offcanvas) -->
        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuLateralAdmin" aria-labelledby="menuLateralAdminLabel">
            <div class="offcanvas-header">
                <div>
                    <h5 class="offcanvas-title" id="menuLateralAdminLabel">Menú Usuario</h5>
                    <small>Operaciones del día a día</small>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/dashboardUsuario">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitacionesUsuario?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedesUsuario?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservasUsuario?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagosUsuario">💳 Pagos</a></li>
                    <li class="nav-item mt-3"><hr class="border-secondary"></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%=ctx%>/Logout">🚪 Cerrar sesión</a></li>
                </ul>
            </div>
        </div>

        <!-- Contenido principal -->
        <main class="content container-fluid">
            <div class="row g-3">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h4 class="card-title mb-3">Bienvenido, <%= (username != null ? username : "Usuario")%> 👋</h4>
                            <p class="text-muted mb-0">
                                Usa el menú de la izquierda para gestionar habitaciones, huéspedes, reservas y pagos diarios del hostal.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Tarjetas de estadísticas -->
                <div class="col-md-6 col-xl-3">
                    <div class="stats-card fade-in">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted small fw-semibold text-uppercase">Ocupación hoy</span>
                            <span class="badge bg-primary">%</span>
                        </div>
                        <h3 class="mb-1"><%= String.format("%.0f", ocupacionHoy)%>%</h3>
                        <small class="<%= variacionOcupacion >= 0 ? "text-success" : "text-danger"%> d-flex align-items-center">
                            <span class="me-1"><%= variacionOcupacion >= 0 ? "▲" : "▼"%></span> 
                            <%= variacionOcupacion >= 0 ? "+" : ""%><%= String.format("%.1f", variacionOcupacion)%>% vs. ayer
                        </small>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="stats-card fade-in" style="border-left-color: #10b981;">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted small fw-semibold text-uppercase">Ingresos (mes)</span>
                            <span class="badge bg-success">USD</span>
                        </div>
                        <h3 class="mb-1">$<%= String.format(java.util.Locale.US, "%,.2f", ingresosMes)%></h3>
                        <small class="<%= variacionIngresos >= 0 ? "text-success" : "text-danger"%> d-flex align-items-center">
                            <span class="me-1"><%= variacionIngresos >= 0 ? "▲" : "▼"%></span> 
                            <%= variacionIngresos >= 0 ? "+" : ""%><%= String.format("%.1f", variacionIngresos)%>% vs. mes anterior
                        </small>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="stats-card fade-in" style="border-left-color: #f59e0b;">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted small fw-semibold text-uppercase">Reservas activas</span>
                            <span class="badge bg-warning">#</span>
                        </div>
                        <h3 class="mb-1"><%= reservasActivas%></h3>
                        <small class="text-muted">Incluye check-ins de hoy</small>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="stats-card fade-in" style="border-left-color: #06b6d4;">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="text-muted small fw-semibold text-uppercase">Huéspedes frecuentes</span>
                            <span class="badge bg-info">#</span>
                        </div>
                        <h3 class="mb-1"><%= huespedesFrecuentes%></h3>
                        <small class="text-muted">Últimos 90 días</small>
                    </div>
                </div>
            </div>
        </main>

    </body>
</html>
