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
    <title>RanciLab - Executive Soft Dashboard</title>
    <!-- Fuentes modernas -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Apache ECharts -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>

    <style>
        :root {
            --sidebar-navy: #193153;
            --sidebar-hover: #223f68;
            --bg-soft: #e9edf3;
            --card-white: #ffffff;
            --accent-orange: #f59e0b;
            --accent-dark-orange: #d97706;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-soft);
            color: var(--text-dark);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .mono {
            font-family: 'JetBrains Mono', monospace;
        }

        /* Layout con Sidebar Fijo */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Azul Marino */
        .sidebar {
            width: 250px;
            background-color: var(--sidebar-navy);
            color: #ffffff;
            padding: 28px 18px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .profile-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .avatar-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: #2a4874;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px auto;
            border: 3px solid rgba(255, 255, 255, 0.15);
            font-size: 2.2rem;
            color: #ffffff;
            box-shadow: 0 8px 16px rgba(0,0,0,0.25);
        }

        .user-name {
            font-weight: 800;
            font-size: 1.05rem;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .user-email {
            font-size: 0.72rem;
            color: #94a3b8;
        }

        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .nav-item-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 0.84rem;
            font-weight: 500;
            border-radius: 8px;
            margin-bottom: 6px;
            transition: all 0.2s ease;
        }

        .nav-item-link:hover, .nav-item-link.active {
            background-color: var(--sidebar-hover);
            color: #ffffff;
        }

        .nav-item-link i {
            font-size: 1.1rem;
        }

        /* Área de Contenido Principal */
        .main-content {
            flex-grow: 1;
            padding: 24px 32px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .dashboard-title {
            font-weight: 800;
            font-size: 1.35rem;
            color: #1e293b;
            margin: 0;
        }

        /* Tarjetas Flotantes Suaves (Estilo Imagen) */
        .soft-card {
            background-color: var(--card-white);
            border-radius: 14px;
            padding: 18px 20px;
            border: 1px solid rgba(255, 255, 255, 0.8);
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.05), 0 8px 10px -6px rgba(15, 23, 42, 0.03);
            position: relative;
        }

        .kpi-dark-card {
            background-color: var(--sidebar-navy);
            color: #ffffff;
        }

        .kpi-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 8px;
        }

        .kpi-dark-card .kpi-header {
            color: #94a3b8;
        }

        .kpi-number {
            font-size: 1.85rem;
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .icon-indicator {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
        }

        /* Botón Naranja */
        .btn-orange {
            background-color: var(--accent-orange);
            color: #ffffff;
            font-weight: 700;
            font-size: 0.75rem;
            padding: 5px 14px;
            border-radius: 6px;
            border: none;
            transition: background 0.2s;
        }

        .btn-orange:hover {
            background-color: var(--accent-dark-orange);
            color: #ffffff;
        }

        .chart-viewport-bars {
            height: 220px;
            width: 100%;
        }

        .chart-viewport-waves {
            height: 180px;
            width: 100%;
        }

        .chart-viewport-donut {
            height: 190px;
            width: 100%;
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        
        <!-- SIDEBAR IZQUIERDO -->
        <aside class="sidebar">
            <div>
                <!-- Perfil -->
                <div class="profile-section">
                    <div class="avatar-circle">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="user-name mono"><%= usuario.toUpperCase() %></div>
                    <div class="user-email">analista@rancilab.pe</div>
                </div>

                <!-- Menú de Navegación -->
                <ul class="nav-menu">
                    <li><a href="panel.jsp" class="nav-item-link active"><i class="bi bi-house-door-fill"></i> Panel Principal</a></li>
                    <li><a href="muestras.jsp" class="nav-item-link"><i class="bi bi-folder-fill"></i> Custodia Muestras</a></li>
                    <li><a href="SolicitudServlet" class="nav-item-link"><i class="bi bi-receipt"></i> Ventas & SOLPED</a></li>
                    <li><a href="ReporteServlet" class="nav-item-link"><i class="bi bi-bar-chart-line-fill"></i> Reportes OLAP</a></li>
                    <li><a href="informe_ensayo.jsp" class="nav-item-link"><i class="bi bi-file-earmark-check-fill"></i> Emitir CoA</a></li>
                    <li><a href="AuditoriaServlet" class="nav-item-link"><i class="bi bi-shield-lock-fill"></i> Auditoría / Backups</a></li>
                </ul>
            </div>

            <!-- Botón Salir en Pie -->
            <div class="pt-3 border-top border-secondary">
                <a href="login.jsp" class="nav-item-link text-danger p-0">
                    <i class="bi bi-box-arrow-left"></i> Cerrar Sesión
                </a>
            </div>
        </aside>

        <!-- CONTENIDO PRINCIPAL DEL DASHBOARD -->
        <main class="main-content">
            
            <!-- Barra Superior -->
            <div class="top-bar">
                <h4 class="dashboard-title">Panel de Control de Calidad</h4>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-light text-dark border mono"><i class="bi bi-award text-success me-1"></i>ISO/IEC 17025</span>
                    <a href="panel.jsp" class="btn btn-outline-secondary btn-sm"><i class="bi bi-grid-3x3-gap-fill"></i></a>
                </div>
            </div>

            <!-- Fila 1: 4 Tarjetas KPI -->
            <div class="row g-3 mb-3">
                <!-- Tarjeta 1 (Azul Oscura destacada) -->
                <div class="col-md-3">
                    <div class="soft-card kpi-dark-card">
                        <div class="kpi-header">
                            <span>Ingresos Ensayos</span>
                            <span class="icon-indicator bg-white text-dark"><i class="bi bi-currency-dollar"></i></span>
                        </div>
                        <h3 class="kpi-number mono">S/. 826</h3>
                    </div>
                </div>
                <!-- Tarjeta 2 -->
                <div class="col-md-3">
                    <div class="soft-card">
                        <div class="kpi-header">
                            <span>Muestras Lote</span>
                            <span class="icon-indicator text-warning"><i class="bi bi-share-fill"></i></span>
                        </div>
                        <h3 class="kpi-number mono">24</h3>
                    </div>
                </div>
                <!-- Tarjeta 3 -->
                <div class="col-md-3">
                    <div class="soft-card">
                        <div class="kpi-header">
                            <span>Horas Estables OSI</span>
                            <span class="icon-indicator text-warning"><i class="bi bi-hand-thumbs-up-fill"></i></span>
                        </div>
                        <h3 class="kpi-number mono">8.6 h</h3>
                    </div>
                </div>
                <!-- Tarjeta 4 -->
                <div class="col-md-3">
                    <div class="soft-card">
                        <div class="kpi-header">
                            <span>Índice Conformidad</span>
                            <span class="icon-indicator text-warning"><i class="bi bi-star-fill"></i></span>
                        </div>
                        <h3 class="kpi-number mono">9.2 / 10</h3>
                    </div>
                </div>
            </div>

            <!-- Fila 2: Gráficos Centrales + Panel Derecho -->
            <div class="row g-3">
                
                <!-- Columna Izquierda (Gráficos Principales) -->
                <div class="col-lg-8">
                    
                    <!-- Gráfico Superior: Barras Comparativas -->
                    <div class="soft-card mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <span class="fw-bold small text-dark">Monitoreo de Rancidez: Aceite Soya vs. Girasol (POV meq/kg)</span>
                            </div>
                            <button class="btn-orange" onclick="location.href='reportes.jsp'">Ver Detalle</button>
                        </div>
                        <div id="chartBarrasMes" class="chart-viewport-bars"></div>
                    </div>

                    <!-- Gráfico Inferior: Curvas Suaves de Degradación Cinética -->
                    <div class="soft-card">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold small text-dark">Cinética de Oxidación Acelerada (Arrhenius vs Conductividad)</span>
                            <small class="mono text-muted" style="font-size:0.68rem;">T = 110 °C | Aire: 10 L/h</small>
                        </div>
                        <div id="chartCurvasCineticas" class="chart-viewport-waves"></div>
                    </div>

                </div>

                <!-- Columna Derecha: Dona + Lista de Verificación -->
                <div class="col-lg-4">
                    <div class="soft-card h-100 d-flex flex-column justify-content-between">
                        <div>
                            <!-- Dona de Calidad -->
                            <div id="chartDonaCalidad" class="chart-viewport-donut"></div>
                            
                            <!-- Lista descriptiva -->
                            <div class="mt-2 border-top pt-3">
                                <div class="d-flex justify-content-between small text-muted py-1">
                                    <span>Lotes Conformes Codex</span>
                                    <strong class="mono text-success">92%</strong>
                                </div>
                                <div class="d-flex justify-content-between small text-muted py-1">
                                    <span>Límite Tolerancia</span>
                                    <strong class="mono text-warning">5%</strong>
                                </div>
                                <div class="d-flex justify-content-between small text-muted py-1">
                                    <span>Rancidez Observada</span>
                                    <strong class="mono text-danger">3%</strong>
                                </div>
                                <div class="d-flex justify-content-between small text-muted py-1">
                                    <span>Stock Tiosulfato</span>
                                    <strong class="mono text-dark">Óptimo</strong>
                                </div>
                            </div>
                        </div>

                        <!-- Botón de Acción -->
                        <div class="mt-3">
                            <a href="informe_ensayo.jsp" class="btn-orange w-100 text-center d-block py-2 text-decoration-none">
                                <i class="bi bi-printer me-1"></i> Emitir Dictamen CoA
                            </a>
                        </div>
                    </div>
                </div>

            </div>

        </main>
    </div>

    <!-- Scripts de Gráficos ECharts Idénticos a la Imagen -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            
            // 1. Gráfico de Barras Dobles (Azul Marino y Naranja)
            var domBarras = document.getElementById('chartBarrasMes');
            var chartBarras = echarts.init(domBarras);
            chartBarras.setOption({
                tooltip: { trigger: 'axis' },
                legend: { data: ['Aceite Soya', 'Girasol'], right: '4%', top: '0%' },
                grid: { left: '3%', right: '4%', bottom: '8%', top: '15%', containLabel: true },
                xAxis: {
                    type: 'category',
                    data: ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP'],
                    axisLine: { lineStyle: { color: '#cbd5e1' } },
                    axisLabel: { color: '#64748b', fontSize: 10 }
                },
                yAxis: {
                    type: 'value',
                    splitLine: { lineStyle: { type: 'dashed', color: '#f1f5f9' } }
                },
                series: [
                    {
                        name: 'Aceite Soya',
                        type: 'bar',
                        data: [20, 40, 22, 35, 12, 48, 15, 25, 20],
                        itemStyle: { color: '#193153', borderRadius: [3, 3, 0, 0] },
                        barWidth: '10px'
                    },
                    {
                        name: 'Girasol',
                        type: 'bar',
                        data: [15, 25, 18, 22, 38, 28, 35, 30, 32],
                        itemStyle: { color: '#f59e0b', borderRadius: [3, 3, 0, 0] },
                        barWidth: '10px'
                    }
                ]
            });

            // 2. Gráfico de Ondas Suaves / Cinética (Naranja y Azul)
            var domCurvas = document.getElementById('chartCurvasCineticas');
            var chartCurvas = echarts.init(domCurvas);
            chartCurvas.setOption({
                tooltip: { trigger: 'axis' },
                grid: { left: '3%', right: '3%', bottom: '5%', top: '10%', containLabel: true },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ['0h', '2h', '4h', '6h', '8h', '10h', '12h'],
                    axisLine: { show: false }
                },
                yAxis: { type: 'value', show: false },
                series: [
                    {
                        name: 'Cinética Primaria',
                        type: 'line',
                        smooth: 0.5,
                        data: [10, 25, 60, 45, 90, 40, 70],
                        lineStyle: { color: '#f59e0b', width: 2 },
                        showSymbol: false,
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgba(245, 158, 11, 0.45)' },
                                { offset: 1, color: 'rgba(245, 158, 11, 0.02)' }
                            ])
                        }
                    },
                    {
                        name: 'Conductividad Acumulada',
                        type: 'line',
                        smooth: 0.5,
                        data: [5, 12, 30, 40, 35, 65, 55],
                        lineStyle: { color: '#193153', width: 2 },
                        showSymbol: false,
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgba(25, 49, 83, 0.35)' },
                                { offset: 1, color: 'rgba(25, 49, 83, 0.02)' }
                            ])
                        }
                    }
                ]
            });

            // 3. Gráfico Dona de Conformidad
            var domDona = document.getElementById('chartDonaCalidad');
            var chartDona = echarts.init(domDona);
            chartDona.setOption({
                series: [{
                    type: 'pie',
                    radius: ['60%', '82%'],
                    avoidLabelOverlap: false,
                    label: {
                        show: true,
                        position: 'center',
                        formatter: '92%\nConforme',
                        fontSize: 16,
                        fontWeight: 'bold',
                        color: '#1e293b'
                    },
                    data: [
                        { value: 92, itemStyle: { color: '#193153' } },
                        { value: 8, itemStyle: { color: '#f59e0b' } }
                    ]
                }]
            });

            window.addEventListener('resize', function () {
                chartBarras.resize();
                chartCurvas.resize();
                chartDona.resize();
            });
        });
    </script>
</body>
</html>