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
    <title>RanciLab LIMS - Menú Central del Sistema</title>
    <!-- Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --slate-900: #0f172a;
            --slate-800: #1e293b;
            --teal-600: #0d9488;
            --border-card: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
            margin: 0;
            padding-bottom: 40px;
        }
        .mono {
            font-family: 'JetBrains Mono', monospace;
        }
        .navbar-top {
            background-color: var(--slate-900);
            padding: 12px 28px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        .telemetry-strip {
            background-color: #131d31;
            padding: 8px 28px;
            font-size: 0.72rem;
            color: #94a3b8;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
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
        .section-header {
            font-size: 0.8rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #475569;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .module-card {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 18px;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
            position: relative;
        }
        .module-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px -5px rgba(15, 23, 42, 0.08);
            border-color: #cbd5e1;
            color: inherit;
        }
        .module-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 12px;
        }
        .icon-teal { background: #f0fdfa; color: #0d9488; }
        .icon-blue { background: #eff6ff; color: #2563eb; }
        .icon-amber { background: #fffbeb; color: #d97706; }
        .icon-purple { background: #faf5ff; color: #7e22ce; }
        .icon-slate { background: #f1f5f9; color: #475569; }
        .icon-rose { background: #fff1f2; color: #e11d48; }

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
                    <span class="text-secondary">Analista Titular:</span> <strong class="mono text-white"><%= usuario %></strong>
                </div>
                <a href="login.jsp" class="btn btn-outline-danger btn-sm mono ms-2">
                    <i class="bi bi-box-arrow-right"></i> Salir
                </a>
            </div>
        </div>
    </nav>

    <!-- Telemetría de Instrumentos y Conexión Cloud -->
    <div class="telemetry-strip d-flex flex-wrap justify-content-between align-items-center gap-2">
        <div class="d-flex align-items-center gap-4 flex-wrap">
            <div class="d-inline-flex align-items-center gap-2">
                <span class="pulse-dot"></span>
                <span>PostgreSQL Cloud (Railway): <strong class="text-white mono">CONECTADO</strong></span>
            </div>
            <div class="d-inline-flex align-items-center gap-2">
                <i class="bi bi-cpu text-info"></i>
                <span>Metrohm 892 Rancimat: <strong class="text-white mono">CANAL A ACTIVO (110°C)</strong></span>
            </div>
            <div class="d-inline-flex align-items-center gap-2">
                <i class="bi bi-thermometer-half text-warning"></i>
                <span>Ambiente Laboratorio: <strong class="text-white mono">20.4 °C | 52% HR</strong></span>
            </div>
        </div>
        <div class="mono text-secondary" style="font-size: 0.68rem;">
            SEDE CENTRAL CALLAO &bull; TERMINAL METROLÓGICO 01
        </div>
    </div>

    <div class="container-fluid px-4 my-4">

        <!-- SECCIÓN 1: ENSAYOS FISICOQUÍMICOS & TRAZABILIDAD METROLÓGICA -->
        <div class="mb-4">
            <div class="section-header">
                <i class="bi bi-bezier2 text-teal"></i> I. Área Metrológica, Ensayos & Custodia Lipídica
            </div>
            <div class="row g-3">
                <div class="col-md-3">
                    <a href="peroxidos.jsp" class="module-card">
                        <div>
                            <div class="module-icon icon-teal"><i class="bi bi-droplet-half"></i></div>
                            <h6 class="fw-bold mb-1">Índice de Peróxidos (POV)</h6>
                            <p class="text-muted small mb-3">Titulación iodométrica para hidroperóxidos lipídicos primarios.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">AOCS Cd 8b-90</span>
                            <span class="text-primary small fw-bold">Calcular <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="anisidina.jsp" class="module-card">
                        <div>
                            <div class="module-icon icon-blue"><i class="bi bi-eyedropper"></i></div>
                            <h6 class="fw-bold mb-1">Valor de p-Anisidina</h6>
                            <p class="text-muted small mb-3">Espectrofotometría a 350 nm de compuestos carbonílicos 2-alquenales.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">ISO 3960 / AOCS</span>
                            <span class="text-primary small fw-bold">Calcular <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="rancimat.jsp" class="module-card">
                        <div>
                            <div class="module-icon icon-amber"><i class="bi bi-activity"></i></div>
                            <h6 class="fw-bold mb-1">Estabilidad Oxidativa (OSI)</h6>
                            <p class="text-muted small mb-3">Curva de conductividad sigmoidal y valor TOTOX automatizado.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Rancimat Metrohm</span>
                            <span class="text-primary small fw-bold">Monitorear <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="muestras.jsp" class="module-card">
                        <div>
                            <div class="module-icon icon-purple"><i class="bi bi-upc-scan"></i></div>
                            <h6 class="fw-bold mb-1">Trazabilidad & Custodia</h6>
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

        <!-- SECCIÓN 2: GESTIÓN DE ENTIDADES DEL NEGOCIO (MÓDULOS 3, 4, 5, 6, 7) -->
        <div class="mb-4">
            <div class="section-header">
                <i class="bi bi-briefcase text-primary"></i> II. Operaciones Comerciales, Inventario & Usuarios (Módulos 3 al 7)
            </div>
            <div class="row g-3">
                <!-- Módulo 3: Usuarios -->
                <div class="col-md-4 col-lg">
                    <a href="UsuarioServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-slate"><i class="bi bi-people-fill"></i></div>
                            <h6 class="fw-bold mb-1">Gestión de Analistas</h6>
                            <p class="text-muted small mb-3">Roles, operadores acreditados y control de bloqueo SHA-256.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 3: Usuarios</span>
                            <span class="text-secondary small fw-bold">Gestionar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Módulo 4: Clientes -->
                <div class="col-md-4 col-lg">
                    <a href="ClienteServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-blue"><i class="bi bi-building-check"></i></div>
                            <h6 class="fw-bold mb-1">Directorio de Clientes</h6>
                            <p class="text-muted small mb-3">Plantas agroindustriales y empresas solicitantes de ensayos.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 4: Clientes</span>
                            <span class="text-secondary small fw-bold">Gestionar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Módulo 5: Proveedores -->
                <div class="col-md-4 col-lg">
                    <a href="ProveedorServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-rose"><i class="bi bi-truck"></i></div>
                            <h6 class="fw-bold mb-1">Gestión de Proveedores</h6>
                            <p class="text-muted small mb-3">Proveedores de reactivos, solventes grado HPLC y calibración.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 5: Proveedores</span>
                            <span class="text-secondary small fw-bold">Gestionar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Módulo 6: Insumos / Mercadería -->
                <div class="col-md-6 col-lg">
                    <a href="InsumoServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-teal"><i class="bi bi-boxes"></i></div>
                            <h6 class="fw-bold mb-1">Reactivos & Insumos</h6>
                            <p class="text-muted small mb-3">Control de pureza, lotes, stocks mínimos y alertas de inventario.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 6: Insumos</span>
                            <span class="text-secondary small fw-bold">Inventario <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Módulo 7: Ventas -->
                <div class="col-md-6 col-lg">
                    <a href="SolicitudServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-amber"><i class="bi bi-receipt"></i></div>
                            <h6 class="fw-bold mb-1">Ventas & SOLPED</h6>
                            <p class="text-muted small mb-3">Cotizaciones, facturación formal, boletas y transacciones ACID.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 7: Ventas</span>
                            <span class="text-secondary small fw-bold">Facturar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <!-- SECCIÓN 3: REPORTES, CERTIFICADOS, SEGURIDAD & RESPALDOS (MÓDULOS 8, 9, 10) -->
        <div>
            <div class="section-header">
                <i class="bi bi-graph-up-arrow text-success"></i> III. Reportería OLAP, Certificados, Seguridad & Respaldos (Módulos 8 al 10)
            </div>
            <div class="row g-3">
                <!-- Módulo 8: Reportes -->
                <div class="col-md-4">
                    <a href="ReporteServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-blue"><i class="bi bi-pie-chart-fill"></i></div>
                            <h6 class="fw-bold mb-1">Módulo 8: Reportería & Business Analytics</h6>
                            <p class="text-muted small mb-3">Visualizaciones dimensionales con Apache ECharts y exportación automatizada a Microsoft Excel (.xlsx).</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulo 8: OLAP / BI</span>
                            <span class="text-primary small fw-bold">Abrir BI <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Certificados de Ensayo (Entregable del LIMS) -->
                <div class="col-md-4">
                    <a href="informe_ensayo.jsp" class="module-card">
                        <div>
                            <div class="module-icon icon-teal"><i class="bi bi-file-earmark-check-fill"></i></div>
                            <h6 class="fw-bold mb-1">Certificados de Análisis (CoA)</h6>
                            <p class="text-muted small mb-3">Emisión membretada con código de barras, timbre digital e incertidumbre A4 listo para imprimir en PDF.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">ISO 17025 A4 Ready</span>
                            <span class="text-teal small fw-bold" style="color:#0d9488;">Emitir CoA <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
                <!-- Módulos 9 y 10: Seguridad, Auditoría y Respaldos -->
                <div class="col-md-4">
                    <a href="AuditoriaServlet" class="module-card">
                        <div>
                            <div class="module-icon icon-slate"><i class="bi bi-shield-shaded"></i></div>
                            <h6 class="fw-bold mb-1">Módulos 9 & 10: Seguridad, Auditoría & Respaldos</h6>
                            <p class="text-muted small mb-3">Logs de seguridad 21 CFR Part 11, pistas de auditoría inmutables y descarga de copias de seguridad SQL.</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="module-badge">Módulos 9 & 10: Backups</span>
                            <span class="text-secondary small fw-bold">Supervisar <i class="bi bi-arrow-right"></i></span>
                        </div>
                    </a>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>  