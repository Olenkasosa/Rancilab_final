<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab LIMS - Command Center</title>
    <!-- Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --slate-950: #020617;
            --slate-900: #0f172a;
            --slate-850: #131d31;
            --slate-800: #1e293b;
            --teal-500: #14b8a6;
            --teal-600: #0d9488;
            --blue-500: #3b82f6;
            --amber-500: #f59e0b;
            --purple-500: #a855f7;
            --border-card: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
        }
        .mono {
            font-family: 'JetBrains Mono', monospace;
        }
        /* Top Navigation */
        .navbar-top {
            background-color: var(--slate-900);
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding: 12px 28px;
        }
        /* Telemetría Strip */
        .telemetry-bar {
            background-color: var(--slate-850);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding: 8px 28px;
            font-size: 0.72rem;
            color: #94a3b8;
        }
        .telemetry-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .pulse-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background-color: #10b981;
            box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
            animation: pulse-green 2s infinite;
        }
        @keyframes pulse-green {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7); }
            70% { box-shadow: 0 0 0 6px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }
        /* Section Headings */
        .area-title {
            font-size: 0.78rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #64748b;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        /* Module Cards */
        .card-module {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 20px;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        .card-module:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 24px -6px rgba(15, 23, 42, 0.08);
            border-color: #cbd5e1;
            color: inherit;
        }
        .card-module::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: transparent;
            transition: background 0.2s ease;
        }
        .card-module:hover::before {
            background: var(--teal-600);
        }
        .icon-circle {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 14px;
        }
        .icon-teal { background: #f0fdfa; color: #0d9488; }
        .icon-blue { background: #eff6ff; color: #2563eb; }
        .icon-amber { background: #fffbeb; color: #d97706; }
        .icon-purple { background: #faf5ff; color: #7e22ce; }
        .icon-slate { background: #f1f5f9; color: #475569; }

        .module-badge {
            font-size: 0.68rem;
            font-family: 'JetBrains Mono', monospace;
            padding: 3px 8px;
            border-radius: 5px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #475569;
        }
    </style>
</head>
<body>

    <!-- Header Cockpit -->
    <nav class="navbar navbar-top navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info fs-4"></i>
                <div class="d-flex flex-column">
                    <span class="fs-5 tracking-tight">RanciLab <span class="fw-light text-secondary">LIMS Enterprise</span></span>
                    <span class="mono text-muted" style="font-size: 0.62rem;">PLATAFORMA METROLÓGICA ACREDITADA ISO/IEC 17025</span>
                </div>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-dark border border-secondary text-info mono px-2 py-1" style="font-size: 0.70rem;">
                    <i class="bi bi-shield-check me-1"></i>21 CFR PART 11 READY
                </span>
                <div class="d-flex align-items-center gap-2 text-white small">
                    <div class="pulse-dot"></div>
                    <span class="text-secondary">Analista Titular:</span> <strong class="mono"><%= usuario %></strong>
                </div>
                <a href="login.jsp" class="btn btn-outline-danger btn-sm mono ms-2">
                    <i class="bi bi-box-arrow-right"></i> Salir
                </a>
            </div>
        </div>
    </nav>

    <!-- Barra de Telemetría e Instrumentación Activa en Laboratorio -->
    <div class="telemetry-bar d-flex flex-wrap justify-content-between align-items-center gap-2">
        <div class="d-flex align-items-center gap-4 flex-wrap">
            <div class="telemetry-item">
                <span class="pulse-dot"></span>
                <span>DB Railway PostgreSQL: <strong class="text-white mono">CONECTADO</strong></span>
            </div>
            <div class="telemetry-item">
                <i class="bi bi-cpu text-info"></i>
                <span>Rancimat 892 Metrohm: <strong class="text-white mono">CANAL A LISTO (110°C)</strong></span>
            </div>
            <div class="telemetry-item">
                <i class="bi bi-thermometer-half text-warning"></i>
                <span>Ambiente Laboratorio: <strong class="text-white mono">20.4 °C | 52% HR</strong></span>
            </div>
        </div>
        <div class="mono text-secondary" style="font-size: 0.68rem;">
            SEDE CENTRAL METROLÓGICA CALLAO &bull; TERMINAL ID: 01-LIMS
        </div>
    </div>

    <!-- Contenido Modular Agrupado -->
    <div class="container-fluid px-4 my-4">

        <!-- GRUPO 1: METROLOGÍA, ENSAYOS Y CUSTODIA (ISO 17025) -->
        <div class="mb-4">
            <div class="area-title">
                <i class="bi bi-bezier2 text-teal-600"></i> I. Área Metrológica, Ensayos & Custodia Lipídica
            </div>
            <div class="row g-3">
                <div class="col-md-3">
                    <a href="peroxidos.jsp" class="card-module">
                        <div>
                            <div class="icon-circle icon-teal"><i class="bi bi-droplet-half"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Índice de Peróxidos (POV)</h6>
                            <p class="text-muted small mb-3">Titulación iodométrica para hidroperóxidos lipídicos primarios.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">AOCS Cd 8b-90</span>
                            <span class="text-primary small fw-bold">Calcular <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="anisidina.jsp" class="card-module">
                        <div>
                            <div class="icon-circle icon-blue"><i class="bi bi-eyedropper"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Valor de p-Anisidina</h6>
                            <p class="text-muted small mb-3">Espectrofotometría a 350 nm de compuestos carbonílicos 2-alquenales.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">ISO 3960 / AOCS</span>
                            <span class="text-primary small fw-bold">Calcular <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="rancimat.jsp" class="card-module">
                        <div>
                            <div class="icon-circle icon-amber"><i class="bi bi-activity"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Estabilidad Oxidativa (OSI)</h6>
                            <p class="text-muted small mb-3">Curva de conductividad sigmoidal y valor TOTOX automatizado.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Rancimat Metrohm</span>
                            <span class="text-primary small fw-bold">Monitorear <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="muestras.jsp" class="card-module">
                        <div>
                            <div class="icon-circle icon-purple"><i class="bi bi-upc-scan"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Trazabilidad & Custodia</h6>
                            <p class="text-muted small mb-3">Generación de rótulos térmicos con códigos de barra para lotes.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">GLP / Custodia</span>
                            <span class="text-primary small fw-bold">Rótulos <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <!-- GRUPO 2: GESTIÓN OPERATIVA & TRANSACCIONAL (ERP / LIMS) -->
        <div class="mb-4">
            <div class="area-title">
                <i class="bi bi-briefcase text-primary"></i> II. Operaciones Comerciales, Inventarios & Usuarios
            </div>
            <div class="row g-3">
                <div class="col-md-3">
                    <a href="UsuarioServlet" class="card-module">
                        <div>
                            <div class="icon-circle icon-slate"><i class="bi bi-people-fill"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Gestión de Analistas</h6>
                            <p class="text-muted small mb-3">Roles, operadores acreditados y control de bloqueo SHA-256.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Repository + Factory</span>
                            <span class="text-secondary small fw-bold">Gestionar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="ClienteServlet" class="card-module">
                        <div>
                            <div class="icon-circle icon-blue"><i class="bi bi-building-check"></i></div>
                            <h6 class="fw-bold text-dark mb-1">Directorio de Clientes</h6>
                            <p class="text-muted small mb-3">Plantas agroindustriales y empresas solicitantes de ensayos.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Repository + Prototype</span>
                            <span class="text-secondary small fw-bold">Gestionar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="InsumoServlet" class="card-module">
                        <div>
                            <div class="icon-circle icon-teal"><i class="bi bi-boxes"></i></div>
                            <h
                                