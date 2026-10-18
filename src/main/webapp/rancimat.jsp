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
    <title>RanciLab - Estabilidad Oxidativa Rancimat (OSI)</title>
    <!-- Tipografías de precisión técnica -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Apache ECharts -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>

    <style>
        :root {
            --navy-deep: #0b1120;
            --slate-panel: #0f172a;
            --teal-accent: #0d9488;
            --border-subtle: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
        }
        .navbar-custom {
            background-color: var(--navy-deep);
            padding: 12px 28px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .badge-iso {
            background: rgba(13, 148, 136, 0.15);
            color: #0d9488;
            border: 1px solid rgba(13, 148, 136, 0.3);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.72rem;
            letter-spacing: 0.5px;
            padding: 4px 10px;
            border-radius: 6px;
        }
        .card-enterprise {
            background: #ffffff;
            border: 1px solid var(--border-subtle);
            border-radius: 14px;
            box-shadow: 0 4px 20px -4px rgba(15, 23, 42, 0.05);
        }
        .instrument-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f1f5f9;
            color: #334155;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-family: 'JetBrains Mono', monospace;
        }
        .indicator-pulse {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #10b981;
            box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
            animation: pulse 1.8s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }
        .mono-num {
            font-family: 'JetBrains Mono', monospace;
        }
        .chart-viewport {
            height: 380px;
            width: 100%;
        }
        .btn-teal {
            background-color: var(--teal-accent);
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-teal:hover {
            background-color: #0f766e;
            color: #ffffff;
        }
    </style>
</head>
<body>

    <!-- Header Corporativo -->
    <nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i>
                <span>RanciLab <span class="fw-light text-secondary">LIMS Enterprise</span></span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="badge-iso"><i class="bi bi-award me-1"></i>ISO/IEC 17025 ACCREDITED</span>
                <div class="vr bg-secondary opacity-50 d-none d-md-block"></div>
                <div class="d-flex align-items-center gap-2 text-white small">
                    <div class="indicator-pulse"></div>
                    <span class="text-secondary">Analista:</span> <strong class="mono-num text-white"><%= usuario %></strong>
                </div>
                <a href="panel.jsp" class="btn btn-outline-light btn-sm ms-2"><i class="bi bi-arrow-left"></i> Menú</a>
            </div>
        </div>
    </nav>

    <!-- Contenedor Principal -->
    <div class="container-fluid px-4 my-4">
        
        <!-- Fila de Encabezado y Estado de Instrumento -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h3 class="fw-bold mb-0">Determinación de Estabilidad Oxidativa (OSI) & TOTOX</h3>
                    <span class="badge bg-light text-dark border mono-num">AOCS Cd 12b-92 / ISO 6886</span>
                </div>
                <p class="text-muted small mb-0">Ensayo termoacelerado Rancimat con detección de conductividad eléctrica continua y modelado de vida útil.</p>
            </div>
            <div class="d-flex gap-2 align-items-center">
                <span class="instrument-badge">
                    <i class="bi bi-cpu text-primary"></i> Metrohm 892 Rancimat (Canal A)
                </span>
                <span class="instrument-badge">
                    <i class="bi bi-shield-check text-success"></i> Calibración Vigente
                </span>
            </div>
        </div>

        <!-- Layout en 2 Columnas: Parámetros a la izquierda, Gráfico y Métricas a la derecha -->
        <div class="row g-4">
            
            <!-- Columna Parámetros de Ensayo -->
            <div class="col-lg-4">
                <div class="card card-enterprise p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-sliders text-teal me-2"></i>Condiciones de Prueba</h5>
                    <form id="formRancimat" onsubmit="procesarRancimat(event)">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Identificador de Muestra / Lote:</label>
                            <input type="text" id="lote" class="form-control mono-num" value="LOTE-SOYA-2026-A" required>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Temp. Bloque (°C):</label>
                                <input type="number" step="0.5" id="temp" class="form-control mono-num" value="110.0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Flujo Aire (L/h):</label>
                                <input type="number" step="0.5" id="flujo" class="form-control mono-num" value="10.0" required>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">POV Previo (meq O₂):</label>
                                <input type="number" step="0.01" id="pov" class="form-control mono-num" value="2.30" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">AnV Previo (adimensional):</label>
                                <input type="number" step="0.01" id="anv" class="form-control mono-num" value="4.15" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold">Tiempo de Inducción Hallado (OSI, h):</label>
                            <input type="number" step="0.1" id="osiHoras" class="form-control mono-num fw-bold text-primary" value="8.4" required>
                            <small class="text-muted" style="font-size: 0.72rem;">* Determinado por inflexión de segunda derivada.</small>
                        </div>

                        <button type="submit" class="btn btn-teal w-100 py-2">
                            <i class="bi bi-graph-up-arrow me-1"></i> Generar Curva Cinética
                        </button>
                    </form>

                    <!-- Tarjetas de Diagnóstico Rápido -->
                    <div class="mt-4 pt-3 border-top">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="small text-muted fw-bold">VALOR TOTOX:</span>
                            <span id="txtTotox" class="mono-num fw-bold fs-5 text-dark">8.75</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="small text-muted fw-bold">ESTIMACIÓN 20°C:</span>
                            <span id="txtVidaUtil" class="mono-num fw-bold text-teal">11.9 meses</span>
                        </div>
                        <div class="p-2 bg-light rounded text-center mt-3">
                            <span id="txtDictamen" class="badge bg-success p-2 w-100">CONFORME - ACEITE ESTABLE</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Columna Curva Cinética en Vivo -->
            <div class="col-lg-8">
                <div class="card card-enterprise p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold mb-0"><i class="bi bi-activity text-teal me-2"></i>Curva de Conductividad Eléctrica vs. Tiempo</h5>
                            <small class="text-muted">AOCS Cd 12b-92: Formación de ácidos carboxílicos de cadena corta</small>
                        </div>
                        <span class="badge bg-light text-dark border mono-num" id="tagLote">LOTE-SOYA-2026-A</span>
                    </div>

                    <!-- Gráfico ECharts de la Curva Cinética -->
                    <div id="chartCineticRancimat" class="chart-viewport"></div>

                    <!-- Leyenda Explicativa de Metrología -->
                    <div class="row g-2 mt-3 text-muted" style="font-size: 0.75rem;">
                        <div class="col-md-4">
                            <i class="bi bi-circle-fill text-teal me-1"></i> <strong>Fase de Inducción:</strong> Absorción lenta de O₂ y consumo de tocoferoles.
                        </div>
                        <div class="col-md-4">
                            <i class="bi bi-triangle-fill text-danger me-1"></i> <strong>Punto Crítico (OSI):</strong> Disparo exponencial de ácidos volátiles.
                        </div>
                        <div class="col-md-4">
                            <i class="bi bi-clock-history text-primary me-1"></i> <strong>Cálculo TOTOX:</strong> <code>(2 × POV) + AnV</code>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <!-- Script de Inicialización de la Curva Cinética Sigmoidal -->
    <script>
        var chartRancimat;

        function generarPuntosCurva(osiPunto) {
            var datos = [];
            // Simular curva sigmoidea de oxidación: conductividad base 5-15 uS/cm, que luego se dispara exponencialmente
            for (var t = 0; t <= 14; t += 0.5) {
                var conductividad = 10 + 200 / (1 + Math.exp(-1.5 * (t - osiPunto)));
                datos.push([t.toFixed(1), conductividad.toFixed(1)]);
            }
            return datos;
        }

        document.addEventListener("DOMContentLoaded", function () {
            var dom = document.getElementById('chartCineticRancimat');
            chartRancimat = echarts.init(dom);
            renderizarCurva(8.4, 'LOTE-SOYA-2026-A');

            window.addEventListener('resize', function () {
                chartRancimat.resize();
            });
        });

        function renderizarCurva(osiHoras, nombreLote) {
            var puntos = generarPuntosCurva(osiHoras);

            var option = {
                animationDuration: 1500,
                animationEasing: 'cubicOut',
                tooltip: {
                    trigger: 'axis',
                    formatter: function (params) {
                        return 'Tiempo: <b>' + params[0].value[0] + ' h</b><br/>' +
                               'Conductividad: <b>' + params[0].value[1] + ' µS/cm</b>';
                    }
                },
                toolbox: {
                    feature: {
                        saveAsImage: { title: 'Guardar PNG' },
                        dataView: { readOnly: true, title: 'Datos' }
                    }
                },
                grid: {
                    left: '4%',
                    right: '6%',
                    bottom: '10%',
                    top: '12%',
                    containLabel: true
                },
                xAxis: {
                    type: 'value',
                    name: 'Tiempo (h)',
                    nameLocation: 'middle',
                    nameGap: 30,
                    min: 0,
                    max: 14,
                    splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } }
                },
                yAxis: {
                    type: 'value',
                    name: 'Conductividad (µS/cm)',
                    splitLine: { lineStyle: { type: 'dashed', color: '#e2e8f0' } }
                },
                series: [{
                    name: 'Conductividad',
                    type: 'line',
                    smooth: true,
                    data: puntos,
                    lineStyle: { width: 3, color: '#0d9488' },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgba(13, 148, 136, 0.35)' },
                            { offset: 1, color: 'rgba(13, 148, 136, 0.02)' }
                        ])
                    },
                    markLine: {
                        symbol: ['none', 'none'],
                        label: {
                            formatter: 'Punto de Inducción OSI\n' + osiHoras + ' h',
                            position: 'insideEndTop',
                            fontWeight: 'bold',
                            color: '#b91c1c'
                        },
                        lineStyle: { color: '#ef4444', width: 2, type: 'dashed' },
                        data: [{ xAxis: osiHoras }]
                    },
                    markPoint: {
                        data: [
                            {
                                coord: [osiHoras, 110],
                                value: osiHoras + ' h',
                                itemStyle: { color: '#ef4444' }
                            }
                        ]
                    }
                }]
            };

            chartRancimat.setOption(option);
        }

        function procesarRancimat(e) {
            e.preventDefault();
            var osi = parseFloat(document.getElementById('osiHoras').value);
            var pov = parseFloat(document.getElementById('pov').value);
            var anv = parseFloat(document.getElementById('anv').value);
            var lote = document.getElementById('lote').value;

            // Cálculo TOTOX
            var totox = (2 * pov) + anv;
            document.getElementById('txtTotox').innerText = totox.toFixed(2);

            // Estimación de vida útil (regla Q10 térmica ~2 a 20°C)
            var meses = (osi * Math.pow(2, (110 - 20) / 10) / 720).toFixed(1);
            document.getElementById('txtVidaUtil').innerText = meses + ' meses';

            // Dictamen
            var dict = document.getElementById('txtDictamen');
            if (totox <= 10.0 && osi >= 6.0) {
                dict.className = 'badge bg-success p-2 w-100';
                dict.innerText = 'CONFORME - ACEITE ESTABLE (Codex)';
            } else if (totox <= 26.0) {
                dict.className = 'badge bg-warning text-dark p-2 w-100';
                dict.innerText = 'ACEPTABLE - LÍMITE DE CALIDAD';
            } else {
                dict.className = 'badge bg-danger p-2 w-100';
                dict.innerText = 'NO CONFORME - RANCIDEZ AVANZADA';
            }

            document.getElementById('tagLote').innerText = lote;
            renderizarCurva(osi, lote);
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>