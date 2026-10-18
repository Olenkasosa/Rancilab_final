<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
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

    double totalIngresos = 0.0;
    int totalVentasCount = 0;
    Map<String, Double> ingresosPorFecha = new TreeMap<>();

    if (solicitudes != null) {
        for (Solicitud s : solicitudes) {
            if (!"ANULADO".equalsIgnoreCase(s.getEstado())) {
                totalIngresos += s.getTotal();
                totalVentasCount++;
                String fechaCorta = (s.getFechaEmision() != null && s.getFechaEmision().length() >= 10) 
                                    ? s.getFechaEmision().substring(0, 10) : "2026-10-18";
                ingresosPorFecha.put(fechaCorta, ingresosPorFecha.getOrDefault(fechaCorta, 0.0) + s.getTotal());
            }
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
    <title>RanciLab - Executive Analytics & OLAP</title>
    <!-- Tipografías de alta legibilidad técnica -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Apache ECharts & SheetJS -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>

    <style>
        :root {
            --slate-900: #0f172a;
            --slate-800: #1e293b;
            --teal-primary: #0d9488;
            --teal-hover: #0f766e;
            --surface-card: #ffffff;
            --border-subtle: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
        }
        .mono {
            font-family: 'JetBrains Mono', monospace;
        }
        .navbar-custom {
            background-color: var(--slate-900);
            padding: 12px 28px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .badge-live {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.72rem;
            padding: 3px 8px;
            border-radius: 6px;
        }
        .card-enterprise {
            background: var(--surface-card);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
            transition: transform 0.15s ease;
        }
        .card-enterprise:hover {
            box-shadow: 0 8px 16px -2px rgba(0, 0, 0, 0.06);
        }
        .kpi-label {
            font-size: 0.74rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .kpi-number {
            font-size: 1.85rem;
            font-weight: 800;
            color: var(--slate-900);
            letter-spacing: -0.5px;
        }
        .chart-box-top {
            height: 330px;
            width: 100%;
        }
        .chart-box-tab {
            height: 250px;
            width: 100%;
            margin-bottom: 15px;
        }
        .btn-excel {
            background-color: #107c41;
            color: #ffffff;
            font-weight: 600;
            border-radius: 6px;
            font-size: 0.8rem;
            padding: 6px 14px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: none;
        }
        .btn-excel:hover {
            background-color: #0c5e31;
            color: #ffffff;
        }
        .nav-tabs .nav-link {
            font-weight: 600;
            color: #64748b;
            border: none;
            border-bottom: 2px solid transparent;
            padding: 10px 16px;
            font-size: 0.85rem;
        }
        .nav-tabs .nav-link.active {
            color: var(--teal-primary);
            border-bottom: 2px solid var(--teal-primary);
            background: transparent;
        }
        .table-custom thead th {
            background-color: #f8fafc;
            color: #475569;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
            padding: 10px 14px;
            white-space: nowrap;
        }
        .table-custom tbody td {
            padding: 12px 14px;
            vertical-align: middle;
            font-size: 0.82rem;
            white-space: nowrap;
        }
    </style>
</head>
<body>

    <!-- Header Corporativo -->
    <nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i>
                <span>RanciLab <span class="fw-light text-secondary">Analytics Cockpit</span></span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="badge-live"><i class="bi bi-broadcast me-1"></i>LIVE POSTGRESQL SYNC</span>
                <div class="vr bg-secondary opacity-50 d-none d-md-block"></div>
                <span class="small text-secondary">Analista: <strong class="mono text-white"><%= usuario %></strong></span>
                <a href="panel.jsp" class="btn btn-outline-light btn-sm ms-2"><i class="bi bi-arrow-left"></i> Menú</a>
            </div>
        </div>
    </nav>

    <!-- Contenedor Principal -->
    <div class="container-fluid px-4 my-4">
        
        <!-- Fila de Encabezado -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">Módulo 8: Inteligencia de Negocios & Modelo Dimensional OLAP</h3>
                <p class="text-muted small mb-0">Consolidado analítico de facturación, demanda de ensayos por matriz lipídica y criticidad de reactivos.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="informe_ensayo.jsp" class="btn btn-outline-dark btn-sm fw-bold">
                    <i class="bi bi-file-earmark-check me-1"></i> Ir a Certificados de Ensayo
                </a>
            </div>
        </div>

        <!-- Cuadrícula de KPIs Ejecutivos -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card card-enterprise p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="kpi-label">Recaudación Neta Total</span>
                        <i class="bi bi-wallet2 text-primary fs-5"></i>
                    </div>
                    <div class="kpi-number text-primary mono">S/. <%= String.format("%.2f", totalIngresos) %></div>
                    <small class="text-success"><i class="bi bi-arrow-up-right me-1"></i>Facturación en línea activa</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-enterprise p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="kpi-label">SOLPEDs Facturadas</span>
                        <i class="bi bi-receipt-cutoff text-teal fs-5"></i>
                    </div>
                    <div class="kpi-number mono"><%= totalVentasCount %></div>
                    <small class="text-muted">Órdenes transaccionales completadas</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-enterprise p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="kpi-label">Reactivos en Stock</span>
                        <i class="bi bi-flask text-success fs-5"></i>
                    </div>
                    <div class="kpi-number text-success mono"><%= disponiblesCount %></div>
                    <small class="text-muted">Estándares y solventes óptimos</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-enterprise p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <span class="kpi-label">Alertas de Inventario</span>
                        <i class="bi bi-exclamation-triangle-fill <%= stockCriticoCount > 0 ? "text-danger" : "text-secondary" %> fs-5"></i>
                    </div>
                    <div class="kpi-number <%= stockCriticoCount > 0 ? "text-danger" : "text-secondary" %> mono"><%= stockCriticoCount %></div>
                    <small class="text-muted">Ítems bajo el umbral de seguridad</small>
                </div>
            </div>
        </div>

        <!-- Gráficos Principales con ECharts -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="card card-enterprise p-4">
                    <div id="chartServicios" class="chart-box-top"></div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card card-enterprise p-4">
                    <div id="chartStock" class="chart-box-top"></div>
                </div>
            </div>
        </div>

        <!-- Pestañas Dimensionales Requeridas con Gráficos y Exportación a Excel -->
        <div class="card card-enterprise p-4">
            <ul class="nav nav-tabs mb-4" id="reportTabs" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabIngresosDiarios">
                        <i class="bi bi-calendar-check me-1"></i> Reporte Diario de Ingresos
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabVentasGenerales">
                        <i class="bi bi-receipt me-1"></i> Reporte General de Ventas
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabStockActualizado">
                        <i class="bi bi-box-seam me-1"></i> Reporte Actualizado de Stock
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabSalidasConsumos">
                        <i class="bi bi-arrow-up-right-circle me-1"></i> Reporte Diario de Salidas
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <!-- 1. Reporte Diario de Ingresos -->
                <div class="tab-pane fade show active" id="tabIngresosDiarios">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="fw-bold mb-0 text-muted">Evolución Cronológica de Recaudación Diaria</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaIngresosDiarios', 'Reporte_Diario_Ingresos_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel (.xlsx)
                        </button>
                    </div>
                    <!-- Gráfico en Pestaña -->
                    <div id="chartLineaIngresos" class="chart-box-tab"></div>

                    <div class="table-responsive">
                        <table id="tablaIngresosDiarios" class="table table-custom table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Fecha de Emisión</th>
                                    <th>Concepto / Partida Contable</th>
                                    <th class="text-end">Monto Recaudado Neto (S/.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (!ingresosPorFecha.isEmpty()) {
                                    for (Map.Entry<String, Double> entry : ingresosPorFecha.entrySet()) { %>
                                        <tr>
                                            <td class="mono fw-bold"><%= entry.getKey() %></td>
                                            <td>Servicios Analíticos / Ensayos Fisicoquímicos Especializados</td>
                                            <td class="text-end mono fw-bold text-success fs-6">S/. <%= String.format("%.2f", entry.getValue()) %></td>
                                        </tr>
                                <%  }
                                } else { %>
                                    <tr><td colspan="3" class="text-center text-muted py-3">Sin registros de ingresos.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 2. Reporte General de Todas las Ventas -->
                <div class="tab-pane fade" id="tabVentasGenerales">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-muted">Historial Consolidado de Solicitudes y Comprobantes</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaVentasGen', 'Reporte_General_Ventas_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel (.xlsx)
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaVentasGen" class="table table-custom table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Código SOLPED</th>
                                    <th>Cliente / Razón Social</th>
                                    <th>Comprobante</th>
                                    <th>Fecha</th>
                                    <th>Subtotal (S/.)</th>
                                    <th>IGV 18% (S/.)</th>
                                    <th>Total (S/.)</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (solicitudes != null && !solicitudes.isEmpty()) {
                                    for (Solicitud s : solicitudes) { %>
                                        <tr>
                                            <td class="mono fw-bold text-primary"><%= s.getCodigoSolped() %></td>
                                            <td><%= s.getNombreCliente() %></td>
                                            <td><span class="badge bg-light text-dark border mono"><%= s.getTipoComprobante() %></span></td>
                                            <td class="mono small text-muted"><%= s.getFechaEmision() != null ? s.getFechaEmision().substring(0, 10) : "" %></td>
                                            <td class="mono">S/. <%= String.format("%.2f", s.getSubtotal()) %></td>
                                            <td class="mono text-muted">S/. <%= String.format("%.2f", s.getIgv()) %></td>
                                            <td class="mono fw-bold text-success">S/. <%= String.format("%.2f", s.getTotal()) %></td>
                                            <td><span class="badge bg-success p-2 mono"><%= s.getEstado() %></span></td>
                                        </tr>
                                <%  }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 3. Reporte Actualizado del Stock -->
                <div class="tab-pane fade" id="tabStockActualizado">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="fw-bold mb-0 text-muted">Balance Metrológico: Stock Disponible vs. Umbral de Seguridad</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaStockAct', 'Reporte_Stock_Insumos_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel (.xlsx)
                        </button>
                    </div>
                    <!-- Gráfico en Pestaña -->
                    <div id="chartCompStock" class="chart-box-tab"></div>

                    <div class="table-responsive">
                        <table id="tablaStockAct" class="table table-custom table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Código</th>
                                    <th>Nombre del Reactivo</th>
                                    <th>Grado de Pureza</th>
                                    <th>Stock Disponible</th>
                                    <th>Stock Mínimo</th>
                                    <th>Proveedor Acreditado</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (insumos != null) {
                                    for (ReactivoInsumo r : insumos) { 
                                        boolean bajo = r.getStockActual() <= r.getStockMinimo();
                                %>
                                        <tr>
                                            <td class="mono fw-bold"><%= r.getCodigo() %></td>
                                            <td><%= r.getNombre() %></td>
                                            <td><span class="badge bg-light text-secondary border"><%= r.getPurezaGrado() %></span></td>
                                            <td class="mono fw-bold <%= bajo ? "text-danger" : "text-success" %>"><%= String.format("%.2f", r.getStockActual()) %> <%= r.getUnidadMedida() %></td>
                                            <td class="mono text-muted"><%= String.format("%.2f", r.getStockMinimo()) %> <%= r.getUnidadMedida() %></td>
                                            <td><%= r.getNombreProveedor() %></td>
                                            <td><span class="badge <%= bajo ? "bg-danger" : "bg-success" %> mono p-2"><%= bajo ? "CRÍTICO" : "DISPONIBLE" %></span></td>
                                        </tr>
                                <%  }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 4. Reporte Diario de Salidas / Consumos -->
                <div class="tab-pane fade" id="tabSalidasConsumos">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-muted">Salidas Operativas de Reactivos y Trazabilidad por Ensayo</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaSalidasDiarias', 'Reporte_Salidas_Insumos_RanciLab')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel (.xlsx)
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaSalidasDiarias" class="table table-custom table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Insumo Utilizado</th>
                                    <th>Cantidad Descontada</th>
                                    <th>Ensayo Vinculado</th>
                                    <th>Analista</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="mono">2026-10-18</td>
                                    <td>Tiosulfato de Sodio 0.01N</td>
                                    <td class="mono fw-bold text-danger">-25.00 mL</td>
                                    <td>POV (Peróxidos AOCS Cd 8b-90)</td>
                                    <td class="mono">admin</td>
                                </tr>
                                <tr>
                                    <td class="mono">2026-10-18</td>
                                    <td>Cloroformo Grado HPLC</td>
                                    <td class="mono fw-bold text-danger">-50.00 mL</td>
                                    <td>POV (Peróxidos AOCS Cd 8b-90)</td>
                                    <td class="mono">admin</td>
                                </tr>
                                <tr>
                                    <td class="mono">2026-10-18</td>
                                    <td>p-Anisidina Grado Espectral</td>
                                    <td class="mono fw-bold text-danger">-5.00 g</td>
                                    <td>p-Anisidina (ISO 3960)</td>
                                    <td class="mono">admin</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Script de Inicialización Garantizada de ECharts -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 1. Gráfico Superior: Ingresos por Ensayo
            var domServicios = document.getElementById('chartServicios');
            var chartServicios = echarts.init(domServicios);
            chartServicios.setOption({
                title: { text: 'Ingresos por Ensayo Fisicoquímico', left: 'left', textStyle: { fontSize: 14, fontWeight: 'bold' } },
                tooltip: { trigger: 'axis', formatter: '{b}: <b>S/. {c}</b>' },
                toolbox: { show: true, feature: { magicType: { type: ['bar', 'line'] }, saveAsImage: {} } },
                grid: { left: '3%', right: '4%', bottom: '8%', top: '18%', containLabel: true },
                xAxis: { type: 'category', data: ['Rancimat (OSI)', 'POV (Peróxidos)', 'p-Anisidina'] },
                yAxis: { type: 'value', name: 'Ingresos (S/.)' },
                series: [{
                    name: 'Ingresos',
                    type: 'bar',
                    barWidth: '40%',
                    data: [
                        { value: 430.00, itemStyle: { color: '#0d9488' } },
                        { value: 245.00, itemStyle: { color: '#0284c7' } },
                        { value: 151.00, itemStyle: { color: '#d97706' } }
                    ],
                    label: { show: true, position: 'top', formatter: 'S/. {c}', fontWeight: 'bold' },
                    itemStyle: { borderRadius: [6, 6, 0, 0] }
                }]
            });

            // 2. Gráfico Superior: Dona de Estado del Inventario
            var domStock = document.getElementById('chartStock');
            var chartStock = echarts.init(domStock);
            chartStock.setOption({
                title: { text: 'Disponibilidad de Reactivos', left: 'left', textStyle: { fontSize: 14, fontWeight: 'bold' } },
                tooltip: { trigger: 'item', formatter: '{b}: <b>{c}</b> ({d}%)' },
                toolbox: { show: true, feature: { saveAsImage: {} } },
                legend: { bottom: '0%', left: 'center' },
                series: [{
                    name: 'Inventario',
                    type: 'pie',
                    radius: ['45%', '70%'],
                    data: [
                        { value: <%= disponiblesCount %>, name: 'Stock Disponible', itemStyle: { color: '#10b981' } },
                        { value: <%= stockCriticoCount %>, name: 'Stock Crítico', itemStyle: { color: '#ef4444' } }
                    ]
                }]
            });

            // 3. Gráfico en Pestaña: Línea Temporal de Ingresos
            var domLinea = document.getElementById('chartLineaIngresos');
            var chartLineaIngresos = echarts.init(domLinea);
            var fechas = [];
            var montos = [];
            <% for (Map.Entry<String, Double> entry : ingresosPorFecha.entrySet()) { %>
                fechas.push('<%= entry.getKey() %>');
                montos.push(<%= entry.getValue() %>);
            <% } %>
            if (fechas.length === 0) {
                fechas = ['2026-10-18'];
                montos = [<%= totalIngresos %>];
            }
            chartLineaIngresos.setOption({
                tooltip: { trigger: 'axis', formatter: '{b}: <b>S/. {c}</b>' },
                grid: { left: '3%', right: '4%', bottom: '10%', top: '15%', containLabel: true },
                xAxis: { type: 'category', data: fechas, boundaryGap: false },
                yAxis: { type: 'value', name: 'Recaudado (S/.)' },
                series: [{
                    name: 'Ingresos Diarios',
                    type: 'line',
                    smooth: true,
                    data: montos,
                    lineStyle: { color: '#0d9488', width: 3 },
                    areaStyle: { color: 'rgba(13, 148, 136, 0.2)' },
                    itemStyle: { color: '#0d9488' }
                }]
            });

            // 4. Gráfico en Pestaña: Comparativa de Stock
            var domCompStock = document.getElementById('chartCompStock');
            var chartCompStock = echarts.init(domCompStock);
            var codigosInsumos = [];
            var stAct = [];
            var stMin = [];
            <% if (insumos != null) {
                for (ReactivoInsumo r : insumos) { %>
                    codigosInsumos.push('<%= r.getCodigo() %>');
                    stAct.push(<%= r.getStockActual() %>);
                    stMin.push(<%= r.getStockMinimo() %>);
            <%  }
            } %>
            chartCompStock.setOption({
                tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
                legend: { top: '0%' },
                grid: { left: '3%', right: '4%', bottom: '8%', top: '18%', containLabel: true },
                xAxis: { type: 'category', data: codigosInsumos },
                yAxis: { type: 'value', name: 'Cantidad' },
                series: [
                    { name: 'Stock Actual', type: 'bar', data: stAct, itemStyle: { color: '#0284c7', borderRadius: [4, 4, 0, 0] } },
                    { name: 'Stock Mínimo', type: 'bar', data: stMin, itemStyle: { color: '#ef4444', borderRadius: [4, 4, 0, 0] } }
                ]
            });

            // Ajuste dinámico de tamaño de gráficos en pestañas Bootstrap
            document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(function (tabEl) {
                tabEl.addEventListener('shown.bs.tab', function () {
                    chartLineaIngresos.resize();
                    chartCompStock.resize();
                });
            });

            window.addEventListener('resize', function () {
                chartServicios.resize();
                chartStock.resize();
                chartLineaIngresos.resize();
                chartCompStock.resize();
            });
        });

        // Exportador a Excel usando SheetJS
        function exportarTablaExcel(tablaId, nombreArchivo) {
            var tabla = document.getElementById(tablaId);
            if (!tabla) return;
            var libro = XLSX.utils.table_to_book(tabla, { sheet: "Reporte" });
            XLSX.writeFile(libro, nombreArchivo + ".xlsx");
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>