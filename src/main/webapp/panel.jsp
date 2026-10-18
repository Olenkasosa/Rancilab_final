<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Manejo de Cierre de Sesión seguro
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect("login.jsp");
        return;
    }

    // Verificación de sesión activa
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
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
    <title>RanciLab - Menú Central</title>
    <!-- Tipografía e Iconos -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-teal: #0d9488;
            --teal-light: #ccfbf1;
            --bg-body: #f8fafc;
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
            background-color: var(--bg-body);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Barra de navegación superior */
        .navbar {
            background-color: #0f172a;
            color: #ffffff;
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #1e293b;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.1rem;
            font-weight: 700;
            color: #ffffff;
            text-decoration: none;
        }

        .navbar-brand i {
            color: #14b8a6;
            font-size: 1.3rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 0.85rem;
        }

        .user-tag {
            color: #cbd5e1;
        }

        .user-tag strong {
            color: #ffffff;
        }

        .btn-logout {
            background-color: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.3);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.8rem;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-logout:hover {
            background-color: #ef4444;
            color: #ffffff;
        }

        /* Contenedor Principal */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 36px 24px;
            width: 100%;
            flex: 1;
        }

        .header-title-section {
            margin-bottom: 28px;
        }

        .header-title-section h1 {
            font-size: 1.7rem;
            font-weight: 800;
            color: var(--primary-navy);
            letter-spacing: -0.5px;
        }

        .header-title-section p {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        /* Grid de Módulos Operativos */
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }

        .module-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04);
            transition: all 0.25s ease;
            text-decoration: none;
            color: inherit;
        }

        .module-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 20px -5px rgba(15, 23, 42, 0.08);
            border-color: #cbd5e1;
        }

        .card-top {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 16px;
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .icon-teal   { background: #ccfbf1; color: #0f766e; }
        .icon-blue   { background: #e0f2fe; color: #0369a1; }
        .icon-amber  { background: #fef3c7; color: #b45309; }
        .icon-purple { background: #f3e8ff; color: #7e22ce; }
        .icon-indigo { background: #e0e7ff; color: #4338ca; }
        .icon-slate  { background: #f1f5f9; color: #334155; }

        .card-body h3 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin-bottom: 6px;
        }

        .card-body p {
            font-size: 0.82rem;
            color: var(--text-muted);
            line-height: 1.45;
        }

        .card-footer-info {
            border-top: 1px solid #f1f5f9;
            padding-top: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.75rem;
        }

        .norm-badge {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: #475569;
            background: #f1f5f9;
            padding: 3px 8px;
            border-radius: 6px;
        }

        .card-arrow {
            color: var(--primary-teal);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <nav class="navbar">
        <a href="panel.jsp" class="navbar-brand">
            <i class="bi bi-moisture"></i>
            <span>RanciLab LIMS</span>
        </a>
        <div class="user-info">
            <span class="user-tag">Analista: <strong><%= usuario %></strong> (<%= rol != null ? rol : "OPERADOR" %>)</span>
            <a href="panel.jsp?action=logout" class="btn-logout">
                <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
            </a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-container">
        <div class="header-title-section">
            <h1>Menú Central del Sistema</h1>
            <p>Selecciona un módulo operativo para gestionar la información analítica, analistas y ensayos fisicoquímicos.</p>
        </div>

        <!-- Módulos Operativos -->
        <div class="modules-grid">

            <!-- Módulo Obligatorio Etapa 4: CRUD de Usuarios / Analistas (Patrón Repository) -->
            <a href="UsuarioServlet?accion=listar" class="module-card">
                <div>
                    <div class="card-top">
                        <div class="card-icon icon-indigo">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div class="card-body">
                            <h3>Gestión de Analistas y Usuarios</h3>
                            <p>Control de roles, operadores certificados, desbloqueo de cuentas bloqueadas y altas con SHA-256.</p>
                        </div>
                    </div>
                </div>
                <div class="card-footer-info">
                    <span class="norm-badge">Patrón Repository</span>
                    <span class="card-arrow">Administrar <i class="bi bi-chevron-right"></i></span>
                </div>
            </a>

            <!-- Módulo 1: Peróxidos -->
            <a href="peroxidos.jsp" class="module-card">
                <div>
                    <div class="card-top">
                        <div class="card-icon icon-teal">
                            <i class="bi bi-droplet-half"></i>
                        </div>
                        <div class="card-body">
                            <h3>Índice de Peróxidos (POV)</h3>
                            <p>Registro de titulación iodométrica para determinar la formación primaria de hidroperóxidos lipídicos.</p>
                        </div>
                    </div>
                </div>
                <div class="card-footer-info">
                    <span class="norm-badge">AOCS Cd 8b-90</span>
                    <span class="card-arrow">Ingresar <i class="bi bi-chevron-right"></i></span>
                </div>
            </a>

            <!-- Módulo 2: p-Anisidina -->
            <a href="anisidina.jsp" class="module-card">
                <div>
                    <div class="card-top">
                        <div class="card-icon icon-blue">
                            <i class="bi bi-eyedropper"></i>
                        </div>
                        <div class="card-body">
                            <h3>Valor de p-Anisidina</h3>
                            <p>Medición espectrofotométrica a 350 nm para cuantificación de aldehídos secundarios (2-alquenales).</p>
                        </div>
                    </div>
                </div>
                <div class="card-footer-info">
                    <span class="norm-badge">ISO 3960:2017</span>
                    <span class="card-arrow">Ingresar <i class="bi bi-chevron-right"></i></span>
                </div>
            </a>

            <!-- Módulo 3: Rancimat / TOTOX -->
            <a href="rancimat.jsp" class="module-card">
                <div>
                    <div class="card-top">
                        <div class="card-icon icon-amber">
                            <i class="bi bi-thermometer-sun"></i>
                        </div>
                        <div class="card-body">
                            <h3>Estabilidad Oxidativa (OSI)</h3>
                            <p>Determinación del período de inducción acelerado Rancimat y cómputo de Valor Total de Oxidación (TOTOX).</p>
                        </div>
                    </div>
                </div>
                <div class="card-footer-info">
                    <span class="norm-badge">AOCS Cd 12b-92</span>
                    <span class="card-arrow">Ingresar <i class="bi bi-chevron-right"></i></span>
                </div>
            </a>

            <!-- Módulo 4: Registro y Muestras -->
            <a href="muestras.jsp" class="module-card">
                <div>
                    <div class="card-top">
                        <div class="card-icon icon-purple">
                            <i class="bi bi-journal-check"></i>
                        </div>
                        <div class="card-body">
                            <h3>Trazabilidad de Muestras</h3>
                            <p>Gestión de lotes de aceites y grasas, matriz biológica, fecha de ingreso y control de condiciones de custodia.</p>
                        </div>
                    </div>
                </div>
                <div class="card-footer-info">
                    <span class="norm-badge">GLP / LIMS</span>
                    <span class="card-arrow">Ingresar <i class="bi bi-chevron-right"></i></span>
                </div>
            </a>

         <!-- Módulo Clientes (Etapa 5 - Repository) -->
<a href="ClienteServlet?accion=listar" class="module-card">
    <div>
        <div class="card-top">
            <div class="card-icon icon-teal">
                <i class="bi bi-buildings"></i>
            </div>
            <div class="card-body">
                <h3>Directorio de Clientes</h3>
                <p>Plantas y empresas agroindustriales solicitantes de control de calidad lipídico.</p>
            </div>
        </div>
    </div>
    <div class="card-footer-info">
        <span class="norm-badge">Patrón Repository</span>
        <span class="card-arrow">Administrar <i class="bi bi-chevron-right"></i></span>
    </div>
</a>
    <!-- Módulo Proveedores (Etapa 5 - Repository) -->
<a href="ProveedorServlet?accion=listar" class="module-card">
    <div>
        <div class="card-top">
            <div class="card-icon icon-amber">
                <i class="bi bi-truck"></i>
            </div>
            <div class="card-body">
                <h3>Proveedores de Laboratorio</h3>
                <p>Gestión de suministros químicos, reactivos valorados, cristalería y servicios metrológicos.</p>
            </div>
        </div>
    </div>
    <div class="card-footer-info">
        <span class="norm-badge">Patrón Repository</span>
        <span class="card-arrow">Administrar <i class="bi bi-chevron-right"></i></span>
    </div>
</a>     
    <!-- Módulo Insumos / Reactivos (Etapa 5 - Repository) -->
<a href="InsumoServlet?accion=listar" class="module-card">
    <div>
        <div class="card-top">
            <div class="card-icon icon-teal">
                <i class="bi bi-flask"></i>
            </div>
            <div class="card-body">
                <h3>Reactivos e Insumos</h3>
                <p>Control de stock de reactivos valorados, solventes p.a. y fechas de caducidad.</p>
            </div>
        </div>
    </div>
    <div class="card-footer-info">
        <span class="norm-badge">Patrón Repository</span>
        <span class="card-arrow">Administrar <i class="bi bi-chevron-right"></i></span>
    </div>
</a>  
    <!-- Módulo Ventas & SOLPED (Etapa 6 - Cabecera/Detalle) -->
<a href="SolicitudServlet?accion=listar" class="module-card">
    <div>
        <div class="card-top">
            <div class="card-icon icon-purple">
                <i class="bi bi-receipt"></i>
            </div>
            <div class="card-body">
                <h3>Ventas & SOLPED de Ensayos</h3>
                <p>Gestión de órdenes de análisis, facturación de servicios y flujo transaccional Cabecera-Detalle.</p>
            </div>
        </div>
    </div>
    <div class="card-footer-info">
        <span class="norm-badge">Transacciones ACID</span>
        <span class="card-arrow">Gestionar <i class="bi bi-chevron-right"></i></span>
    </div>
</a>
    <!-- Módulo Reportería con Apache ECharts & Excel (Etapa 7) -->
<a href="ReporteServlet" class="module-card">
    <div>
        <div class="card-top">
            <div class="card-icon icon-blue">
                <i class="bi bi-pie-chart-fill"></i>
            </div>
            <div class="card-body">
                <h3>Reportería & Analytics</h3>
                <p>Gráficos analíticos con Apache ECharts y exportación de reportes a Microsoft Excel.</p>
            </div>
        </div>
    </div>
    <div class="card-footer-info">
        <span class="norm-badge">Apache ECharts & XLSX</span>
        <span class="card-arrow">Ver Reportes <i class="bi bi-chevron-right"></i></span>
    </div>
</a>
    
        </div>
    </div>

</body>
</html>