<%-- 
    Document   : pagos
    Created on : 11 nov. 2025, 16:54:02
    Author     : cresp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map"%>
<%@page import="model.Pago"%>
<%
    String ctx = request.getContextPath();

    @SuppressWarnings(
            
    
    "unchecked")
    List<Pago> pagos = (List<Pago>) request.getAttribute("pagos");
    if (pagos == null) {
        pagos = java.util.Collections.emptyList();
    }

    @SuppressWarnings(
            
    
    "unchecked")
    List<Map<String, String>> reservasCombo = (List<Map<String, String>>) request.getAttribute("reservasCombo");
    if (reservasCombo == null) {
        reservasCombo = java.util.Collections.emptyList();
    }

    Map<String, Object> resumen = (Map<String, Object>) request.getAttribute("resumen");

    String flash = null;
    if (session != null) {
        flash = (String) session.getAttribute("flash");
        if (flash != null) {
            session.removeAttribute("flash");
        }
    }

    // ✅ Usar UNA SOLA variable para el id seleccionado en toda la página
    String selReserva = request.getParameter("reservaId");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Administrador - Pagos</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark px-3 sticky-top">
            <div class="container-fluid">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#menuAdmin"><span class="navbar-toggler-icon"></span></button>
                <span class="navbar-text mx-auto text-white fw-semibold">💳 Pagos</span>
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
                    <li class="nav-item mb-3"><a class="nav-link active text-white" href="<%=ctx%>/pagos">💳 Pagos</a></li>
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

            <!-- Filtro por Reserva -->
            <form class="row g-2 mb-3" action="<%=ctx%>/pagos" method="get">
                <div class="col-md-9">
                    <select class="form-select" name="reservaId">
                        <option value="">Todas las reservas</option>
                        <%
                            for (Map<String, String> m : reservasCombo) {
                                String v = m.get("id");
                                String txt = m.get("text");
                        %>
                        <option value="<%=v%>" <%= v.equals(selReserva) ? "selected" : ""%>><%= txt%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3 d-grid">
                    <button class="btn btn-outline-secondary">Filtrar</button>
                </div>
            </form>

            <% if (resumen != null) {%>
            <div class="card border-0 shadow-sm mb-3">
                <div class="card-body">
                    <div class="d-flex flex-wrap align-items-center gap-3">
                        <div><strong>Reserva #</strong><%= resumen.get("reservaId")%></div>
                        <div><strong>Huésped:</strong> <%= resumen.get("huesped")%></div>
                        <div><strong>Hab:</strong> <%= resumen.get("habitacion")%></div>
                        <div><strong>Días:</strong> <%= resumen.get("dias")%></div>
                        <div><strong>Estimado:</strong> $<%= String.format(java.util.Locale.US, "%.2f", (Double) resumen.get("estimado"))%></div>
                        <div><strong>Pagado:</strong> $<%= String.format(java.util.Locale.US, "%.2f", (Double) resumen.get("pagado"))%></div>
                        <div><strong>Saldo:</strong> $<%= String.format(java.util.Locale.US, "%.2f", (Double) resumen.get("saldo"))%></div>
                    </div>
                </div>
            </div>
            <% } %>

            <div class="card shadow-sm mb-3">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <h5 class="m-0">Pagos registrados</h5>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlNuevo">+ Nuevo pago</button>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Reserva</th>
                                <th>Huésped</th>
                                <th>Hab.</th>
                                <th>Monto</th>
                                <th>Forma</th>
                                <th>Tipo</th>
                                <th>Fecha</th>
                                <th class="text-end">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (pagos.isEmpty()) {
                            %>
                            <tr><td colspan="9" class="text-center text-muted py-4">Sin pagos</td></tr>
                            <%
                            } else {
                                int i = 1;
                                for (Pago p : pagos) {
                            %>
                            <tr>
                                <td><%= i++%></td>
                                <td>#<%= p.getReservaId()%></td>
                                <td><%= p.getHuespedNombre() == null ? "" : p.getHuespedNombre()%></td>
                                <td><%= p.getHabitacionNumero() == null ? "" : p.getHabitacionNumero()%></td>
                                <td>$<%= String.format(java.util.Locale.US, "%.2f", p.getMonto())%></td>
                                <td><%= p.getFormaPago()%></td>
                                <td><%= p.getTipoPago()%></td>
                                <td><%= p.getFechaPago()%></td>
                                <td class="text-end">
                                    <form action="<%=ctx%>/pagos" method="post" class="d-inline" onsubmit="return confirm('¿Eliminar pago?');">
                                        <input type="hidden" name="op" value="delete">
                                        <input type="hidden" name="id" value="<%= p.getId()%>">
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

        <!-- Modal: Nuevo pago -->
        <div class="modal fade" id="mdlNuevo" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="formPago" class="row g-3" action="<%=ctx%>/pagos" method="post" onsubmit="return validarYProcesarPago(event)">
                        <input type="hidden" name="op" value="create">
                        <div class="modal-header">
                            <h5 class="modal-title">💳 Procesar Pago</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div id="alertContainer"></div>

                            <div class="col-12">
                                <label class="form-label">Reserva <span class="text-danger">*</span></label>
                                <select class="form-select" name="reservaId" id="reservaId" required>
                                    <option value="">Seleccione una reserva…</option>
                                    <%
                                        for (Map<String, String> m : reservasCombo) {
                                            String v = m.get("id");
                                            String txt = m.get("text");
                                    %>
                                    <option value="<%=v%>" <%= (selReserva != null && selReserva.equals(v)) ? "selected" : ""%>><%= txt%></option>
                                    <% }%>
                                </select>
                                <div class="invalid-feedback">Debe seleccionar una reserva</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Monto ($) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="0.01" class="form-control" name="monto" id="monto" required placeholder="0.00">
                                <div class="invalid-feedback">El monto debe ser mayor a $0.00</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Forma de pago <span class="text-danger">*</span></label>
                                <select class="form-select" name="formaPago" id="formaPago" required>
                                    <option value="">Seleccione…</option>
                                    <option value="Efectivo">Efectivo</option>
                                    <option value="Tarjeta">Tarjeta de Crédito/Débito</option>
                                    <option value="Transferencia">Transferencia Bancaria</option>
                                    <option value="Otro">Otro</option>
                                </select>
                                <div class="invalid-feedback">Debe seleccionar una forma de pago</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Tipo de pago <span class="text-danger">*</span></label>
                                <select class="form-select" name="tipoPago" id="tipoPago" required>
                                    <option value="">Seleccione…</option>
                                    <option value="Anticipo">Anticipo</option>
                                    <option value="Total">Pago Total</option>
                                    <option value="Extra">Pago Extra</option>
                                </select>
                                <div class="invalid-feedback">Debe seleccionar un tipo de pago</div>
                            </div>

                            <!-- Campos adicionales para simulación -->
                            <div id="camposTarjeta" class="col-12" style="display: none;">
                                <hr>
                                <h6 class="mb-3">Datos de Tarjeta (Simulación)</h6>
                                <div class="row g-2">
                                    <div class="col-12">
                                        <label class="form-label">Número de Tarjeta</label>
                                        <input type="text" class="form-control" id="numeroTarjeta" placeholder="1234 5678 9012 3456" maxlength="19">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Fecha de Vencimiento</label>
                                        <input type="text" class="form-control" id="fechaVencimiento" placeholder="MM/AA" maxlength="5">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="cvv" placeholder="123" maxlength="3">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Nombre del Titular</label>
                                        <input type="text" class="form-control" id="nombreTitular" placeholder="Juan Pérez">
                                    </div>
                                </div>
                            </div>

                            <div id="camposTransferencia" class="col-12" style="display: none;">
                                <hr>
                                <h6 class="mb-3">Datos de Transferencia (Simulación)</h6>
                                <div class="row g-2">
                                    <div class="col-12">
                                        <label class="form-label">Número de Referencia</label>
                                        <input type="text" class="form-control" id="referencia" placeholder="TRF-123456789">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Banco</label>
                                        <select class="form-select" id="banco">
                                            <option value="">Seleccione…</option>
                                            <option>Banco Agrícola</option>
                                            <option>Banco Cuscatlán</option>
                                            <option>Banco de América Central</option>
                                            <option>Banco Promerica</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary" id="btnProcesar">
                                <span id="btnText">Procesar Pago</span>
                                <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status"></span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Mostrar/ocultar campos según forma de pago
            document.getElementById('formaPago').addEventListener('change', function () {
                const formaPago = this.value;
                const camposTarjeta = document.getElementById('camposTarjeta');
                const camposTransferencia = document.getElementById('camposTransferencia');

                camposTarjeta.style.display = formaPago === 'Tarjeta' ? 'block' : 'none';
                camposTransferencia.style.display = formaPago === 'Transferencia' ? 'block' : 'none';
            });

            // Formatear número de tarjeta
            document.getElementById('numeroTarjeta')?.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\s/g, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                e.target.value = formattedValue;
            });

            // Formatear fecha de vencimiento
            document.getElementById('fechaVencimiento')?.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                e.target.value = value;
            });

            // Solo números para CVV
            document.getElementById('cvv')?.addEventListener('input', function (e) {
                e.target.value = e.target.value.replace(/\D/g, '');
            });

            function validarYProcesarPago(event) {
                event.preventDefault();

                const form = document.getElementById('formPago');
                const alertContainer = document.getElementById('alertContainer');
                const btnProcesar = document.getElementById('btnProcesar');
                const btnText = document.getElementById('btnText');
                const btnSpinner = document.getElementById('btnSpinner');

                // Limpiar alertas anteriores
                alertContainer.innerHTML = '';

                // Validaciones
                const reservaId = document.getElementById('reservaId').value;
                const monto = parseFloat(document.getElementById('monto').value);
                const formaPago = document.getElementById('formaPago').value;
                const tipoPago = document.getElementById('tipoPago').value;

                let errores = [];

                if (!reservaId) {
                    errores.push('Debe seleccionar una reserva');
                }

                if (!monto || monto <= 0) {
                    errores.push('El monto debe ser mayor a $0.00');
                }

                if (!formaPago) {
                    errores.push('Debe seleccionar una forma de pago');
                }

                if (!tipoPago) {
                    errores.push('Debe seleccionar un tipo de pago');
                }

                // Validaciones específicas por forma de pago
                if (formaPago === 'Tarjeta') {
                    const numeroTarjeta = document.getElementById('numeroTarjeta').value.replace(/\s/g, '');
                    const fechaVencimiento = document.getElementById('fechaVencimiento').value;
                    const cvv = document.getElementById('cvv').value;
                    const nombreTitular = document.getElementById('nombreTitular').value;

                    if (numeroTarjeta.length < 16) {
                        errores.push('El número de tarjeta debe tener 16 dígitos');
                    }
                    if (fechaVencimiento.length !== 5) {
                        errores.push('La fecha de vencimiento debe tener formato MM/AA');
                    }
                    if (cvv.length !== 3) {
                        errores.push('El CVV debe tener 3 dígitos');
                    }
                    if (!nombreTitular.trim()) {
                        errores.push('Debe ingresar el nombre del titular');
                    }
                }

                if (formaPago === 'Transferencia') {
                    const referencia = document.getElementById('referencia').value;
                    const banco = document.getElementById('banco').value;

                    if (!referencia.trim()) {
                        errores.push('Debe ingresar el número de referencia');
                    }
                    if (!banco) {
                        errores.push('Debe seleccionar un banco');
                    }
                }

                // Mostrar errores si hay
                if (errores.length > 0) {
                    let alertHTML = '<div class="alert alert-danger"><ul class="mb-0">';
                    errores.forEach(error => {
                        alertHTML += '<li>' + error + '</li>';
                    });
                    alertHTML += '</ul></div>';
                    alertContainer.innerHTML = alertHTML;
                    return false;
                }

                // Simular procesamiento
                btnProcesar.disabled = true;
                btnText.textContent = 'Procesando...';
                btnSpinner.classList.remove('d-none');

                // Simulación de pago (70% éxito, 30% fallo)
                setTimeout(() => {
                    const exito = Math.random() > 0.3; // 70% de éxito

                    if (exito) {
                        // Pago exitoso
                        alertContainer.innerHTML = '<div class="alert alert-success"><strong>✅ Pago procesado exitosamente!</strong><br>Transacción ID: ' + generarID() + '<br>Monto: $' + monto.toFixed(2) + '<br>Forma: ' + formaPago + '</div>';

                        // Enviar formulario después de 2 segundos
                        setTimeout(() => {
                            form.submit();
                        }, 2000);
                    } else {
                        // Pago fallido
                        const razones = [
                            'Fondos insuficientes',
                            'Tarjeta rechazada',
                            'Error de conexión con el banco',
                            'Tarjeta vencida',
                            'Límite de transacción excedido'
                        ];
                        const razon = razones[Math.floor(Math.random() * razones.length)];

                        alertContainer.innerHTML = '<div class="alert alert-danger"><strong>❌ Pago rechazado</strong><br>Razón: ' + razon + '<br>Por favor, intente con otro método de pago.</div>';

                        btnProcesar.disabled = false;
                        btnText.textContent = 'Procesar Pago';
                        btnSpinner.classList.add('d-none');
                    }
                }, 2000);

                return false;
            }

            function generarID() {
                return 'TXN-' + Math.random().toString(36).substr(2, 9).toUpperCase();
            }
        </script>
    </body>
</html>


