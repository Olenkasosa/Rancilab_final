<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Control de Rancidez Lipídica</title>
    <!-- Fuentes Plus Jakarta Sans e iconos -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-teal: #0d9488;
            --teal-light: #ccfbf1;
            --teal-accent: #14b8a6;
            --bg-mint: #eafaf7;
            --card-border: #e2e8f0;
            --text-dark: #0f172a;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(180deg, #d8f5ef 0%, #eefbf8 40%, #f4fbf9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 16px;
            color: var(--text-dark);
        }

        .auth-container {
            width: 100%;
            max-width: 410px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /* Barra de estado superior */
        .system-status-bar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(8px);
            border: 1px solid #d1fae5;
            border-radius: 12px;
            padding: 8px 14px;
            font-size: 0.72rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(13, 148, 136, 0.05);
        }

        .status-badge {
            background: #dcfce7;
            color: #15803d;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.65rem;
            letter-spacing: 0.5px;
        }

        .calibration-chip {
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            color: #0f766e;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.68rem;
            padding: 5px 10px;
            border-radius: 8px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        /* Tarjeta Central */
        .auth-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 28px 24px 22px 24px;
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06), 0 8px 10px -6px rgba(15, 23, 42, 0.04);
            text-align: center;
        }

        .brand-logo-wrap {
            margin-bottom: 18px;
            display: inline-flex;
            flex-direction: column;
            align-items: center;
        }

        .brand-icon {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #0d9488 0%, #0284c7 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 20px;
            box-shadow: 0 4px 12px rgba(13, 148, 136, 0.3);
            margin-bottom: 10px;
        }

        .brand-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--primary-navy);
            letter-spacing: -0.3px;
        }

        .brand-subtitle {
            font-size: 0.68rem;
            text-transform: uppercase;
            font-weight: 700;
            color: var(--primary-teal);
            letter-spacing: 1.5px;
            margin-top: 3px;
        }

        .brand-desc {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 6px;
            line-height: 1.4;
        }

        /* Formulario */
        .form-group {
            text-align: left;
            margin-bottom: 14px;
        }

        .form-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .form-label-row label {
            font-size: 0.73rem;
            font-weight: 600;
            color: #334155;
        }

        .form-label-row .code-hint {
            font-size: 0.65rem;
            color: var(--text-muted);
            font-family: 'JetBrains Mono', monospace;
        }

        .input-group-custom {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon-left {
            position: absolute;
            left: 12px;
            color: #94a3b8;
            font-size: 15px;
        }

        .input-icon-right {
            position: absolute;
            right: 12px;
            color: #94a3b8;
            font-size: 15px;
            cursor: pointer;
            transition: color 0.15s ease;
        }

        .input-icon-right:hover {
            color: var(--primary-teal);
        }

        .form-control-custom {
            width: 100%;
            padding: 10px 38px;
            font-size: 0.82rem;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 9px;
            background-color: #f8fafc;
            color: var(--text-dark);
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: var(--primary-teal);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.12);
        }

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.70rem;
            color: var(--text-muted);
            margin: 12px 0 18px 0;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }

        .form-check input {
            accent-color: var(--primary-teal);
            cursor: pointer;
        }

        .btn-submit {
            width: 100%;
            background: #0f172a;
            border: none;
            color: #ffffff;
            padding: 11px 16px;
            border-radius: 9px;
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.2px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 10px rgba(15, 23, 42, 0.15);
        }

        .btn-submit:hover {
            background: #1e293b;
            transform: translateY(-1px);
            box-shadow: 0 6px 14px rgba(15, 23, 42, 0.2);
        }

        /* Banner de error */
        .error-alert {
            background-color: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            font-size: 0.72rem;
            padding: 7px 10px;
            border-radius: 8px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
            text-align: left;
        }

        /* Tarjeta inferior con normativas */
        .norms-section {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(6px);
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 12px 14px;
            text-align: center;
        }

        .norms-header {
            font-size: 0.62rem;
            text-transform: uppercase;
            font-weight: 700;
            color: #64748b;
            letter-spacing: 0.6px;
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .norm-cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 6px;
            margin-bottom: 8px;
        }

        .norm-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 6px 4px;
            display: flex;
            flex-direction: column;
            gap: 1px;
        }

        .norm-card .label {
            font-size: 0.58rem;
            color: #94a3b8;
            font-weight: 600;
            text-transform: uppercase;
        }

        .norm-card .value {
            font-size: 0.70rem;
            font-weight: 700;
            color: #0f172a;
            font-family: 'JetBrains Mono', monospace;
        }

        .norm-card.highlight .value {
            color: #d97706;
        }

        .legal-footer {
            font-size: 0.62rem;
            color: #94a3b8;
            line-height: 1.35;
        }
    </style>
</head>
<body>

<div class="auth-container">

    <!-- Barra de Estado del Servidor -->
    <div class="system-status-bar">
        <div>
            <i class="bi bi-hdd-network text-teal-600"></i>
            <span class="ms-1 fw-bold">Servidor Analítico Activo</span>
            <span class="text-muted ms-1">v3.4.2</span>
        </div>
        <div class="status-badge">LIMS ONLINE</div>
    </div>

    <!-- Chip de Calibración -->
    <div class="calibration-chip">
        <i class="bi bi-thermometer-half"></i> Espectrofotometría / Rancimat calibrado a <strong>120.0°C ± 0.1°</strong>
    </div>

    <!-- Tarjeta Principal de Login -->
    <div class="auth-card">
        <div class="brand-logo-wrap">
            <div class="brand-icon">
                <i class="bi bi-moisture"></i>
            </div>
            <div class="brand-title">RanciLab</div>
            <div class="brand-subtitle">CONTROL DE RANCIDEZ LIPÍDICA</div>
            <div class="brand-desc">
                Plataforma automatizada de Peróxidos (POV), Anisidina e Índice Rancimat
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <form action="LoginServlet" method="POST" autocomplete="off">
            <!-- ID Operador -->
            <div class="form-group">
                <div class="form-label-row">
                    <label for="usuario">ID de Analista Certificado</label>
                    <span class="code-hint">COD. OPERADOR</span>
                </div>
                <div class="input-group-custom">
                    <i class="bi bi-person-badge input-icon-left"></i>
                    <input type="text" id="usuario" name="usuario" class="form-control-custom" placeholder="ANL-04920 / admin" required autofocus>
                </div>
            </div>

            <!-- Clave Criptográfica -->
            <div class="form-group">
                <div class="form-label-row">
                    <label for="clave">Clave Criptográfica LIMS</label>
                    <a href="#" style="text-decoration:none; color:var(--primary-teal); font-size:0.65rem; font-weight:600;">¿Restablecer?</a>
                </div>
                <div class="input-group-custom">
                    <i class="bi bi-shield-lock input-icon-left"></i>
                    <input type="password" id="clave" name="clave" class="form-control-custom" placeholder="••••••••••••" required>
                    <i class="bi bi-eye input-icon-right" id="togglePassword"></i>
                </div>
            </div>

            <!-- Recordar sesión -->
            <div class="form-options">
                <label class="form-check">
                    <input type="checkbox" name="remember" checked>
                    <span>Recordar sesión y protocolo de flujo continuo</span>
                </label>
            </div>

            <!-- Botón de Envío -->
            <button type="submit" class="btn-submit">
                <i class="bi bi-box-arrow-in-right"></i>
                <span>Iniciar Sesión Analítica</span>
            </button>
        </form>
    </div>

    <!-- Sección de Normas y Certificaciones -->
    <div class="norms-section">
        <div class="norms-header">
            <span>Validación de Ensayos Vigentes</span>
            <span style="color:var(--primary-teal); font-weight:700;"><i class="bi bi-check-circle-fill"></i> GLP COMPLIANT</span>
        </div>
        <div class="norm-cards-grid">
            <div class="norm-card">
                <span class="label">Índice Peróxidos</span>
                <span class="value">AOCS Cd 8b</span>
            </div>
            <div class="norm-card">
                <span class="label">p-Anisidina</span>
                <span class="value">ISO 3960</span>
            </div>
            <div class="norm-card highlight">
                <span class="label">Estabilidad OSI</span>
                <span class="value">Rancimat</span>
            </div>
        </div>
        <div class="legal-footer">
            Módulo de Análisis Fisicoquímico y Sensorial · Cumple normas AOCS Cd 8b-90 & ISO 3960:2017 para determinación de peróxidos y anisidina. Conexión segura TLS 1.3 con cifrado SHA-256.
        </div>
    </div>

</div>

<!-- Script para alternar visibilidad de contraseña -->
<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#clave');

    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('bi-eye');
        this.classList.toggle('bi-eye-slash');
    });
</script>

</body>
</html>