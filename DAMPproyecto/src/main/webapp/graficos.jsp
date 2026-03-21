<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
<%@page import="misClases.ConexionBD"%>

<%
    String ctx = request.getContextPath();

    // ================================
    // 📊 1. OCUPACIÓN POR MES
    // ================================
    List<String[]> ocupacionMes = new ArrayList<>();
    try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(
            "SELECT FORMAT(FechaEntrada, 'yyyy-MM') AS Mes, COUNT(*) AS Total "
            + "FROM Reservas GROUP BY FORMAT(FechaEntrada, 'yyyy-MM') ORDER BY Mes")) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            ocupacionMes.add(new String[]{rs.getString("Mes"), rs.getString("Total")});
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // ================================
    // 💰 2. INGRESOS POR HABITACIÓN
    // ================================
    List<String[]> ingresosHab = new ArrayList<>();
    try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(
            "SELECT h.Numero, SUM(p.Monto) AS Total "
            + "FROM Pagos p "
            + "INNER JOIN Reservas r ON p.ReservaId = r.Id "
            + "INNER JOIN Habitaciones h ON r.HabitacionId = h.Id "
            + "GROUP BY h.Numero ORDER BY h.Numero")) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            ingresosHab.add(new String[]{rs.getString("Numero"), rs.getString("Total")});
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // ================================
    // 🛎️ 3. SERVICIOS MÁS VENDIDOS
    // ================================
    List<String[]> serviciosVendidos = new ArrayList<>();
    try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(
            "SELECT Servicios, COUNT(*) AS Total "
            + "FROM Habitaciones WHERE Servicios IS NOT NULL "
            + "GROUP BY Servicios")) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            serviciosVendidos.add(new String[]{rs.getString("Servicios"), rs.getString("Total")});
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

%>

<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Administrador - Gráficos</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <style>
            .chart-card {
                min-height: 350px;
                background: #fff;
            }
        </style>

        <!-- GOOGLE CHARTS -->
        <script src="https://www.gstatic.com/charts/loader.js"></script>

        <script>
            google.charts.load("current", {packages: ["corechart"]});
            google.charts.setOnLoadCallback(drawAll);

            function drawAll() {
                drawOcupacion();
                drawIngresos();
                drawServicios();
            }

            // ============================
            // 📊 1. OCUPACIÓN POR MES
            // ============================
            function drawOcupacion() {
                var data = google.visualization.arrayToDataTable([
                    ['Mes', 'Reservas'],
            <% for (String[] row : ocupacionMes) {%>
                    ['<%=row[0]%>', <%=row[1]%>],
            <% } %>
                ]);

                var options = {
                    title: 'Ocupación por mes',
                    legend: {position: 'bottom'},
                    curveType: 'function'
                };

                var chart = new google.visualization.LineChart(document.getElementById('chartOcupacion'));
                chart.draw(data, options);
            }

            // ============================
            // 💰 2. INGRESOS POR HABITACIÓN
            // ============================
            function drawIngresos() {
                var data = google.visualization.arrayToDataTable([
                    ['Habitación', 'Ingresos'],
            <% for (String[] row : ingresosHab) {%>
                    ['Hab <%=row[0]%>', <%=row[1]%>],
            <% } %>
                ]);

                var options = {
                    title: 'Ingresos por habitación',
                    legend: {position: 'none'}
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('chartIngresos'));
                chart.draw(data, options);
            }

            // ============================
            // 🛎️ 3. SERVICIOS MÁS VENDIDOS
            // ============================
            function drawServicios() {
                var data = google.visualization.arrayToDataTable([
                    ['Servicio', 'Cantidad'],
            <% for (String[] row : serviciosVendidos) {%>
                    ['<%=row[0]%>', <%=row[1]%>],
            <% }%>
                ]);

                var options = {
                    title: 'Servicios más vendidos',
                    pieHole: 0.3
                };

                var chart = new google.visualization.PieChart(document.getElementById('chartServicios'));
                chart.draw(data, options);
            }
        </script>
    </head>

    <body class="bg-light">

        <!-- NAVBAR -->
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <span class="navbar-text mx-auto text-white fw-semibold">📈 Gráficos</span>
                <a href="<%=ctx%>/Logout" class="btn btn-outline-light btn-sm">Salir</a>
            </div>
        </nav>

        <!-- MENÚ LATERAL (NO LO CAMBIÉ) -->
        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="menuAdmin">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title">Menú Admin</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav">
                    <li class="nav-item mb-1"><a class="nav-link active text-white" href="<%=ctx%>/dashboard">🏠 Dashboard</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/habitaciones?op=list">🛏️ Habitaciones</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/huespedes?op=list">👥 Huéspedes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reservas?op=list">📅 Reservas</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/empleados?op=list">🧑‍💼 Empleados</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/usuarios?op=list">⚙️ Usuarios / Roles</a></li>
                    <li class="nav-item mb-3"><a class="nav-link text-white" href="<%=ctx%>/proveedores">🚚 Proveedores</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/reportes">📊 Reportes</a></li>
                    <li class="nav-item mb-1"><a class="nav-link text-white" href="<%=ctx%>/graficos.jsp">📈 Gráficos</a></li>
                    <li class="nav-item mt-3"><hr class="border-secondary"></li>
                    <li class="nav-item"><a class="nav-link text-white-50" href="<%=ctx%>/Logout">🚪 Cerrar sesión</a></li>
                </ul>
            </div>
        </div>

        <!-- CONTENIDO -->
        <main class="content container-fluid my-4">
            <div class="row g-4">

                <div class="col-md-6">
                    <div class="card shadow-sm chart-card">
                        <div class="card-body">
                            <h6 class="mb-3">Ocupación por mes</h6>
                            <div id="chartOcupacion" style="width:100%; height:300px;"></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card shadow-sm chart-card">
                        <div class="card-body">
                            <h6 class="mb-3">Ingresos por habitación</h6>
                            <div id="chartIngresos" style="width:100%; height:300px;"></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card shadow-sm chart-card">
                        <div class="card-body">
                            <h6 class="mb-3">Servicios adicionales más vendidos</h6>
                            <div id="chartServicios" style="width:100%; height:300px;"></div>
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
