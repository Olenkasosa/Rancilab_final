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
                                    ? s.getFechaEmision().substring(0, 10) : "Sin Fecha";
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
    <title>RanciLab - Reportes OLAP & Business Analytics</title>
    <!-- Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Apache ECharts & SheetJS -->
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
            font-size: 0.75rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .kpi-value {
            font-size: 1.7rem;
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
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
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
        }
        .nav-tabs .nav-link.active {
            color: var(--primary-teal);
            border-bottom: 2px solid var(--primary-teal);
            background: transparent;
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
                <h3 class="fw-bold mb-1">Módulo 8: Reportes OLAP & Business Analytics</h3>
                <p class="text-muted small mb-0">Consolidado dimensional de ingresos, stock, salidas y servicios más demandados.</p>
            </div>
        </div>

        <!-- Fila de Indicadores KPI -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Ingresos Totales Registrados</span>
                    <span class="kpi-value text-primary">S/. <%= String.format("%.2f", totalIngresos) %></span>
                    <small class="text-muted"><i class="bi bi-cash-stack text-success"></i> Suma acumulada de ventas</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Ventas Concretadas</span>
                    <span class="kpi-value"><%= totalVentasCount %></span>
                    <small class="text-muted">Órdenes facturadas</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Stock Disponible</span>
                    <span class="kpi-value text-success"><%= disponiblesCount %></span>
                    <small class="text-muted">Insumos y patrones conformes</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-custom p-3">
                    <span class="kpi-title">Alertas de Stock Crítico</span>
                    <span class="kpi-value <%= stockCriticoCount > 0 ? "text-danger" : "text-secondary" %>"><%= stockCriticoCount %></span>
                    <small class="text-muted">Insumos bajo el límite mínimo</small>
                </div>
            </div>
        </div>

        <!-- Fila de Gráficos ECharts -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="card card-custom p-4">
                    <div id="chartServicios" class="chart-box"></div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card card-custom p-4">
                    <div id="chartStock" class="chart-box"></div>
                </div>
            </div>
        </div>

        <!-- Sección de Tablas de Reporte Requeridas con Descarga a Excel -->
        <div class="card card-custom p-4">
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
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-muted">Ingresos acumulados por cada fecha de registro</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaIngresosDiarios', 'Reporte_Diario_Ingresos')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaIngresosDiarios" class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha de Emisión</th>
                                    <th>Concepto de Ingreso</th>
                                    <th class="text-end">Monto Total Recaudado (S/.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (!ingresosPorFecha.isEmpty()) {
                                    for (Map.Entry<String, Double> entry : ingresosPorFecha.entrySet()) { %>
                                        <tr>
                                            <td class="font-monospace fw-bold"><%= entry.getKey() %></td>
                                            <td>Servicios Analíticos / Ensayos Fisicoquímicos</td>
                                            <td class="text-end font-monospace fw-bold text-success">S/. <%= String.format("%.2f", entry.getValue()) %></td>
                                        </tr>
                                <%  }
                                } else { %>
                                    <tr><td colspan="3" class="text-center text-muted">Sin registros de ingresos.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 2. Reporte General de Todas las Ventas -->
                <div class="tab-pane fade" id="tabVentasGenerales">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-muted">Historial completo de ventas, clientes y comprobantes</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaVentasGen', 'Reporte_General_Ventas')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaVentasGen" class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Código SOLPED</th>
                                    <th>Cliente / Empresa</th>
                                    <th>Comprobante</th>
                                    <th>Fecha</th>
                                    <th>Subtotal (S/.)</th>
                                    <th>IGV (S/.)</th>
                                    <th>Total (S/.)</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (solicitudes != null && !solicitudes.isEmpty()) {
                                    for (Solicitud s : solicitudes) { %>
                                        <tr>
                                            <td class="font-monospace"><strong><%= s.getCodigoSolped() %></strong></td>
                                            <td><%= s.getNombreCliente() %></td>
                                            <td><span class="badge bg-light text-dark border"><%= s.getTipoComprobante() %></span></td>
                                            <td><%= s.getFechaEmision() != null ? s.getFechaEmision().substring(0, 10) : "" %></td>
                                            <td class="font-monospace">S/. <%= String.format("%.2f", s.getSubtotal()) %></td>
                                            <td class="font-monospace text-muted">S/. <%= String.format("%.2f", s.getIgv()) %></td>
                                            <td class="font-monospace fw-bold text-primary">S/. <%= String.format("%.2f", s.getTotal()) %></td>
                                            <td><span class="badge bg-success"><%= s.getEstado() %></span></td>
                                        </tr>
                                <%  }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 3. Reporte Actualizado del Stock -->
                <div class="tab-pane fade" id="tabStockActualizado">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0 text-muted">Nivel actual de stock de insumos, grado y proveedor</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaStockAct', 'Reporte_Stock_Insumos')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaStockAct" class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Código</th>
                                    <th>Nombre del Reactivo</th>
                                    <th>Grado / Pureza</th>
                                    <th>Stock Actual</th>
                                    <th>Stock Mínimo</th>
                                    <th>Proveedor</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (insumos != null) {
                                    for (ReactivoInsumo r : insumos) { 
                                        boolean bajo = r.getStockActual() <= r.getStockMinimo();
                                %>
                                        <tr>
                                            <td class="font-monospace fw-bold"><%= r.getCodigo() %></td>
                                            <td><%= r.getNombre() %></td>
                                            <td><%= r.getPurezaGrado() %></td>
                                            <td class="font-monospace fw-bold <%= bajo ? "text-danger" : "text-success" %>"><%= String.format("%.2f", r.getStockActual()) %> <%= r.getUnidadMedida() %></td>
                                            <td class="font-monospace text-muted"><%= String.format("%.2f", r.getStockMinimo()) %> <%= r.getUnidadMedida() %></td>
                                            <td><%= r.getNombreProveedor() %></td>
                                            <td><span class="badge <%= bajo ? "bg-danger" : "bg-success" %>"><%= bajo ? "CRÍTICO" : "DISPONIBLE" %></span></td>
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
                        <h6 class="fw-bold mb-0 text-muted">Salidas operativas de reactivos por ensayos ejecutados</h6>
                        <button class="btn btn-excel" onclick="exportarTablaExcel('tablaSalidasDiarias', 'Reporte_Salidas_Insumos')">
                            <i class="bi bi-file-earmark-excel"></i> Descargar Excel
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table id="tablaSalidasDiarias" class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha</th>
                                    <th>Insumo Utilizado</th>
                                    <th>Cantidad Consumida</th>
                                    <th>Ensayo Vinculado</th>
                                    <th>Analista</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>2026-10-18</td>
                                    <td>Tiosulfato de Sodio 0.01N</td>
                                    <td>25.00 mL</td>
                                    <td>POV (Peróxidos AOCS Cd 8b-90)</td>
                                    <td>admin</td>
                                </tr>
                                <tr>
                                    <td>2026-10-18</td>
                                    <td>Cloroformo Grado HPLC</td>
                                    <td>50.00 mL</td>
                                    <td>POV (Peróxidos AOCS Cd 8b-90)</td>
                                    <td>admin</td>
                                </tr>
                                <tr>
                                    <td>2026-10-18</td>
                                    <td>p-Anisidina Grado Espectral</td>
                                    <td>5.00 g</td>
                                    <td>p-Anisidina (ISO 3960)</td>
                                    <td>admin</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

 <!-- Script de Inicialización Robusto de ECharts -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 1. Gráfico de Barras: Servicios Más Demandados
            var domServicios = document.getElementById('chartServicios');
            if (domServicios) {
                var chartServicios = echarts.init(domServicios);
                var optionServicios = {
                    title: {
                        text: 'Ingresos por Ensayo Fisicoquímico',
                        left: 'left',
                        textStyle: { fontSize: 15, fontWeight: 'bold', color: '#0f172a' }
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: { type: 'shadow' },
                        formatter: '{b}: <b>S/. {c}</b>'
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: { show: true, type: ['bar', 'line'], title: { bar: 'Barras', line: 'Líneas' } },
                            dataView: { show: true, readOnly: true, title: 'Datos' },
                            saveAsImage: { show: true, title: 'Descargar PNG' }
                        }
                    },
                    grid: {
                        left: '3%',
                        right: '4%',
                        bottom: '8%',
                        top: '18%',
                        containLabel: true
                    },
                    xAxis: {
                        type: 'category',
                        data: ['Rancimat (OSI)', 'POV (Peróxidos)', 'p-Anisidina'],
                        axisTick: { alignWithLabel: true },
                        axisLabel: { fontWeight: '600', color: '#334155' }
                    },
                    yAxis: {
                        type: 'value',
                        name: 'Ingresos (S/.)'
                    },
                    series: [{
                        name: 'Ingresos',
                        type: 'bar',
                        barWidth: '40%',
                        data: [
                            { value: 430.00, itemStyle: { color: '#0d9488' } },
                            { value: 245.00, itemStyle: { color: '#0284c7' } },
                            { value: 151.00, itemStyle: { color: '#d97706' } }
                        ],
                        label: {
                            show: true,
                            position: 'top',
                            formatter: 'S/. {c}',
                            fontWeight: 'bold',
                            color: '#0f172a'
                        },
                        itemStyle: {
                            borderRadius: [6, 6, 0, 0]
                        }
                    }]
                };
                chartServicios.setOption(optionServicios);
            }

            // 2. Gráfico de Dona: Estado del Stock de Insumos
            var domStock = document.getElementById('chartStock');
            if (domStock) {
                var chartStock = echarts.init(domStock);
                var optionStock = {
                    title: {
                        text: 'Disponibilidad de Reactivos',
                        left: 'left',
                        textStyle: { fontSize: 15, fontWeight: 'bold', color: '#0f172a' }
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: '{b}: <b>{c}</b> ({d}%)'
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            saveAsImage: { show: true, title: 'Descargar PNG' }
                        }
                    },
                    legend: {
                        bottom: '0%',
                        left: 'center'
                    },
                    series: [{
                        name: 'Inventario',
                        type: 'pie',
                        radius: ['45%', '70%'],
                        center: ['50%', '50%'],
                        avoidLabelOverlap: false,
                        itemStyle: {
                            borderRadius: 8,
                            borderColor: '#fff',
                            borderWidth: 2
                        },
                        data: [
                            { value: <%= disponiblesCount %>, name: 'Stock Disponible', itemStyle: { color: '#10b981' } },
                            { value: <%= stockCriticoCount %>, name: 'Stock Crítico', itemStyle: { color: '#ef4444' } }
                        ]
                    }]
                };
                chartStock.setOption(optionStock);
            }

            // Redimensionamiento responsivo
            window.addEventListener('resize', function () {
                if (chartServicios) chartServicios.resize();
                if (chartStock) chartStock.resize();
            });
        });

        // Función para exportar a Excel con SheetJS
        function exportarTablaExcel(tablaId, nombreArchivo) {
            var tabla = document.getElementById(tablaId);
            if (!tabla) return;
            var libro = XLSX.utils.table_to_book(tabla, { sheet: "Reporte" });
            XLSX.writeFile(libro, nombreArchivo + ".xlsx");
        }
    </script>