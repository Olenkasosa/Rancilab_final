<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Solicitud"%>
<%@page import="modelo.ReactivoInsumo"%>
<%@page import="modelo.Cliente"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Solicitud> solicitudes = (List<Solicitud>) request.getAttribute("listaSolicitudes");
    List<ReactivoInsumo> insumos = (List<ReactivoInsumo>) request.getAttribute("listaInsumos");
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("listaClientes");

    double totalFacturado = 0.0;
    int emitidos = 0;
    if (solicitudes != null) {
        for (Solicitud s : solicitudes) {
            if (!"ANULADO".equalsIgnoreCase(s.getEstado())) {
                totalFacturado += s.getTotal();
            }
            emitidos++;
        }
    }

    int stockCriticoCount = 0;
    int disponiblesCount = 0;
    if (insumos != null) {
        for (ReactivoInsumo r : insumos) {
            if (r.getStockActual() <= r.getStockMinimo()) {
                stockCriticoCount++;
            } else {
                disponiblesCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Reportería Ejecutiva & ECharts</title>
    <!-- Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Librerías de la Etapa 7: Apache ECharts & SheetJS (Excel) -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>

    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-teal: #0d9488;
            --card-border: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
        }
        .navbar-custom {
            background-color: var(--primary-navy);
            padding: 14px 28px;
        }
        .card-custom {
            border: 1px solid var(--card-border);
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04);
            background: #ffffff;
        }
        .kpi-title {
            font-size: 0.8rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .kpi-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary-navy);
        }
        .chart-box {
            height: 340px;
            width: 100%;
        }
        .btn-excel {
            background-color: #107c41;
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-excel:hover {
            background-color: #0c5e31;
            color: #ffffff;
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i> RanciLab LIMS
            </a>
            <div class="d-flex align-items-center gap-3 text-white">
                <a href="panel.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Volver al Menú</a>
                <span class="small text-secondary">Analista: <strong class="text-white"><%= usuario %></strong></span>
            </div>
        </div>
    </nav>

    <!-- Contenedor Principal -->
    <div class="container-fluid px-4 my-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">Módulo de Reportería & Business Analytics</h3>
                <p class="text-muted small mb-0">Visualizaciones interactivas con Apache ECharts y exportación automatizada a Microsoft Excel (Etapa 7).</p>
            </div>
        </div>

        <!-- Fila de Indicadores KPI -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Facturación Total Neta</span>
                    <span class="kpi-value text-primary">S/. <%= String.format("%.2f", totalFacturado) %></span>
                    <small class="text-muted"><i class="bi bi-graph-up-arrow text-success"></i> Órdenes procesadas</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Órdenes Emitidas</span>
                    <span class="kpi-value"><%= emitidos %></span>
                    <small class="text-muted">SOLPEDs transaccionales</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Insumos Registrados</span>
                    <span class="kpi-value"><%= insumos != null ? insumos.size() : 0 %></span>
                    <small class="text-muted">Reactivos y patrones</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Alertas de Stock</span>
                    <span class="kpi-value <%= stockCriticoCount > 0 ? "text-danger" : "text-success" %>"><%= stockCriticoCount %></span>
                    <small class="text-muted">Bajo nivel de inventario</small>
                </div>
            </div>
        </div>

        <!-- Fila de Gráficos Apache ECharts -->
        <div class="row g-4 mb-4">
            <!-- Gráfico 1: Ingresos por Servicios -->
            <div class="col-lg-6">
                <div class="card card-custom p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-bar-chart-line text-primary me-2"></i>Facturación por Ensayo Físicoquímico</h5>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaVentas', 'Reporte_Ventas_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div id="chartVentas" class="chart-box"></div>
                </div>
            </div>

            <!-- Gráfico 2: Stock de Reactivos -->
            <div class="col-lg-6">
                <div class="card card-custom p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-pie-chart text-warning me-2"></i>Disponibilidad de Reactivos e Insumos</h5>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaInsumos', 'Reporte_Insumos_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div id="chartReactivos" class="chart-box"></div>
                </div>
            </div>
        </div>

        <!-- Tablas Ocultas / Respaldo para Exportar a Excel -->
        <div class="d-none">
            <table id="tablaVentas">
                <thead>
                    <tr>
                        <th>Código SOLPED</th>
                        <th>Cliente</th>
                        <th>Tipo Comprobante</th>
                        <th>Fecha</th>
                        <th>Subtotal (S/.)</th>
                        <th>IGV (S/.)</th>
                        <th>Total (S/.)</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (solicitudes != null) {
                        for (Solicitud s : solicitudes) { %>
                            <tr>
                                <td><%= s.getCodigoSolped() %></td>
                                <td><%= s.getNombreCliente() %></td>
                                <td><%= s.getTipoComprobante() %></td>
                                <td><%= s.getFechaEmision() %></td>
                                <td><%= s.getSubtotal() %></td>
                                <td><%= s.getIgv() %></td>
                                <td><%= s.getTotal() %></td>
                                <td><%= s.getEstado() %></td>
                            </tr>
                    <%  }
                    } %>
                </tbody>
            </table>

            <table id="tablaInsumos">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Nombre</th>
                        <th>Grado</th>
                        <th>Stock Actual</th>
                        <th>Stock Mínimo</th>
                        <th>Unidad</th>
                        <th>Proveedor</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (insumos != null) {
                        for (ReactivoInsumo r : insumos) { %>
                            <tr>
                                <td><%= r.getCodigo() %></td>
                                <td><%= r.getNombre() %></td>
                                <td><%= r.getPurezaGrado() %></td>
                                <td><%= r.getStockActual() %></td>
                                <td><%= r.getStockMinimo() %></td>
                                <td><%= r.getUnidadMedida() %></td>
                                <td><%= r.getNombreProveedor() %></td>
                                <td><%= r.getEstado() %></td>
                            </tr>
                    <%  }
                    } %>
                </tbody>
            </table>
        </div>

    </div>

    <!-- Script de Inicialización de Apache ECharts & Descarga Excel -->
    <script>
        // 1. Configuración Gráfico 1: Ventas por Ensayo
        var chartVentasDom = document.getElementById('chartVentas');
        var myChartVentas = echarts.init(chartVentasDom);
        var optionVentas = {
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '3%', right: '4%', bottom: '8%', containLabel: true },
            xAxis: [
                {
                    type: 'category',
                    data: ['POV (Peróxidos)', 'p-Anisidina', 'Rancimat (OSI)'],
                    axisTick: { alignWithLabel: true }
                }
            ],
            yAxis: [{ type: 'value', name: 'Ingresos (S/.)' }],
            series: [
                {
                    name: 'Monto Total',
                    type: 'bar',
                    barWidth: '40%',
                    data: [170.00, 95.00, 360.00],
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#0d9488' },
                            { offset: 1, color: '#115e59' }
                        ]),
                        borderRadius: [6, 6, 0, 0]
                    }
                }
            ]
        };
        myChartVentas.setOption(optionVentas);

        // 2. Configuración Gráfico 2: Stock de Reactivos
        var chartReactivosDom = document.getElementById('chartReactivos');
        var myChartReactivos = echarts.init(chartReactivosDom);
        var optionReactivos = {
            tooltip: { trigger: 'item' },
            legend: { bottom: '5%', left: 'center' },
            series: [
                {
                    name: 'Inventario LIMS',
                    type: 'pie',
                    radius: ['45%', '70%'],
                    avoidLabelOverlap: false,
                    itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
                    label: { show: false, position: 'center' },
                    emphasis: {
                        label: { show: true, fontSize: 16, fontWeight: 'bold' }
                    },
                    data: [
                        { value: <%= disponiblesCount %>, name: 'Stock Óptimo / Disponible', itemStyle: { color: '#10b981' } },
                        { value: <%= stockCriticoCount %>, name: 'Stock Crítico / Alerta', itemStyle: { color: '#ef4444' } }
                    ]
                }
            ]
        };
        myChartReactivos.setOption(optionReactivos);

        // Responsivo en cambios de ventana
        window.addEventListener('resize', function() {
            myChartVentas.resize();
            myChartReactivos.resize();
        });

        // Función para exportar a Excel utilizando SheetJS
        function exportarTablaExcel(tablaId, nombreArchivo) {
            var tabla = document.getElementById(tablaId);
            var libro = XLSX.utils.table_to_book(tabla, { sheet: "Reporte" });
            XLSX.writeFile(libro, nombreArchivo + ".xlsx");
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>