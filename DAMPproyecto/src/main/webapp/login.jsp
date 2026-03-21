<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Login - Hostal</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            :root {
                --accent: #2563eb;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                height: 100%;
                width: 100%;
                font-family: 'Inter', sans-serif;
                overflow-x: hidden;
            }

            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                background-attachment: fixed;
            }

            .login-wrapper {
                min-height: 100vh;
                width: 100%;
                overflow: hidden;
            }
            
            .login-wrapper .container-fluid {
                min-height: 100vh;
            }

            .img-side {
                position: relative;
                height: 100vh;
                background-image: url('img/hostal.jpg');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                overflow: hidden;
            }

            .img-side::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(37, 99, 235, 0.8) 0%, rgba(30, 64, 175, 0.8) 100%);
            }

            @media (max-width: 991.98px) {
                .img-side {
                    height: 40vh;
                    min-height: 40vh;
                }
                
                .col-lg-6[style*="min-height: 100vh"] {
                    min-height: auto !important;
                    padding: 2rem 1rem !important;
                }
            }

            .card-login {
                border: 0;
                border-radius: 1.5rem;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                background: rgba(255, 255, 255, 0.98);
                backdrop-filter: blur(10px);
                animation: fadeIn 0.5s ease-out;
            }

            .brand-title {
                font-weight: 800;
                letter-spacing: 0.5px;
                background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-size: 1.75rem;
            }

            .btn-accent {
                background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
                border: none;
                color: white;
                font-weight: 600;
                padding: 0.75rem 2rem;
                border-radius: 0.5rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(37, 99, 235, 0.4);
            }

            .btn-accent:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(37, 99, 235, 0.5);
                filter: brightness(1.05);
            }

            .form-control {
                border: 2px solid #e2e8f0;
                border-radius: 0.5rem;
                padding: 0.75rem 1rem;
                transition: all 0.3s ease;
                font-size: 0.9375rem;
            }

            .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                outline: none;
            }

            .form-label {
                font-weight: 500;
                color: #374151;
                margin-bottom: 0.5rem;
                font-size: 0.875rem;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <div class="login-wrapper">
            <div class="container-fluid px-0">
                <div class="row g-0">
                    <div class="col-lg-6 img-side d-none d-lg-block"></div>

                    <!-- Formulario derecha -->
                    <div class="col-lg-6 d-flex align-items-center justify-content-center p-4 p-md-5" style="min-height: 100vh;">
                        <div class="card card-login p-4 p-md-5 w-100" style="max-width: 440px;">
                            <div class="text-center mb-4">
                                <h4 class="brand-title mb-2">HOSTAL ITCA-FEPADE</h4>
                                <p class="text-muted mb-0">Información Gerencial para Hostal</p>
                            </div>

                            <form action="<%=request.getContextPath()%>/login" method="post" autocomplete="off">
                                <div class="mb-3">
                                    <label class="form-label">Usuario</label>
                                    <input name="usuario" type="text" class="form-control" placeholder="Ingrese su usuario" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Contraseña</label>
                                    <input name="password" type="password" class="form-control" placeholder="Ingrese su contraseña" required>
                                </div>

                                <% if (request.getAttribute("error") != null) {%>
                                <div class="alert alert-danger mb-3"><%= request.getAttribute("error")%></div>
                                <% }%>

                                <button type="submit" class="btn btn-accent btn-lg w-100">Iniciar sesión</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
