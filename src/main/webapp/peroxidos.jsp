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
    <title>RanciLab - Índice de Peróxidos (POV)</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Apache ECharts -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>

    <style>
        :root {
            --slate-900: #0f172a;
            --teal-600: #0d9488;
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
        .navbar-custom {
            background-color: var(--slate-900);
            padding: 12px 28px;
        }
        .card-enterprise {
            background: #ffffff;
            border: 1px solid var(--border-card);
            border-radius: 14px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
        }
        .gauge-viewport {
            height: 280px;
            width: 100%;
        }
        .btn-teal {
            background-color: var(--teal-600);
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

    <!-- Header Navbar -->
    <nav class="navbar navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i> RanciLab LIMS
            </a>
            <div class="d-flex align-items-center gap-3 text-white">
                <a href="panel.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Volver al Menú</a>
                <span class="small text-secondary">Analista: <strong class="mono text-white"><%= usuario %></strong></span>
            </div>
        </div>
    </nav>

    <!-- Contenido -->
    <div class="container my-4" style="max-width: 980px;">
        <div class="mb-4">
            <span class="badge bg-teal text-white mono mb-2" style="background-color: #0d9488;">Norma Técnica AOCS Cd 8b-90 / Codex Stan 210</span>
            <h3 class="fw-bold mb-1">Determinación del Índice de Peróxidos (POV)</h3>
            <p class="text-muted small">Titulación iodométrica para cuantificar hidroperóxidos lipídicos primarios expresados en meq O₂/kg.</p>
        </div>

        <div class="row g-4">
            <!-- Formulario de Titulación -->
            <div class="col-md-6">
                <div class="card card-enterprise p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-droplet-half text-teal me-2" style="color:#0d9488;"></i>Datos Experimentales</h5>
                    <form id="formPOV" onsubmit="ejecutarCalculo(event)">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Identificación de Lote / Matriz:</label>
                            <input type="text" id="lote" class="form-control mono" value="ACEITE-SOYA-L01" required>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Gasto Muestra (S, mL):</label>
                                <input type="number" step="0.01" id="gastoS" class="form-control mono" value="1.25" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Gasto Blanco (B, mL):</label>
                                <input type="number" step="0.01" id="gastoB" class="form-control mono" value="0.05" required>
                            </div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Normalidad Na₂S₂O₃:</label>
                                <input type="number" step="0.0001" id="normN" class="form-control mono" value="0.0100" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Peso Muestra (W, g):</label>
                                <input type="number" step="0.0001" id="pesoW" class="form-control mono" value="5.0210" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-teal w-100 py-2">
                            <i class="bi bi-calculator me-1"></i> Calcular & Evaluar Tolerancia
                        </button>
                    </form>
                    <div class="mt-4 pt-3 border-top small text-muted mono">
                        <code>POV = ((S - B) × N × 1000) / W</code>
                    </div>
                </div>
            </div>

            <!-- Tacómetro Analítico de Tolerancia -->
            <div class="col-md-6">
                <div class="card card-enterprise p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="fw-bold mb-0"><i class="bi bi-speedometer2 text-primary me-2"></i>Evaluación Codex</h5>
                            <span class="badge bg-light text-dark border mono" id="badgePOV">2.39 meq O₂</span>
                        </div>
                        <!-- Tacómetro ECharts -->
                        <div id="gaugePOV" class="gauge-viewport"></div>
                    </div>
                    <div id="boxDictamen" class="p-3 bg-light rounded text-center">
                        <span class="small text-muted d-block mono mb-1">DICTAMEN TÉCNICO CODEX ALIMENTARIUS:</span>
                        <span id="txtDictamen" class="badge bg-success p-2 w-100 mono">CONFORME (ACEITE FRESCO / PRIMARIO)</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script del Tacómetro ECharts -->
    <script>
        var chartGauge;

        document.addEventListener("DOMContentLoaded", function () {
            var dom = document.getElementById('gaugePOV');
            chartGauge = echarts.init(dom);
            actualizarGauge(2.39);

            window.addEventListener('resize', function () {
                chartGauge.resize();
            });
        });

        function actualizarGauge(valor) {
            var option = {
                series: [{
                    type: 'gauge',
                    min: 0,
                    max: 15,
                    splitNumber: 3,
                    axisLine: {
                        lineStyle: {
                            width: 14,
                            color: [
                                [0.33, '#10b981'], // 0 a 5: Verde (Fresco)
                                [0.66, '#f59e0b'], // 5 a 10: Amarillo (Aceptable)
                                [1.0, '#ef4444']   // > 10: Rojo (Rancidez)
                            ]
                        }
                    },
                    pointer: { itemStyle: { color: '#0f172a' }, width: 4 },
                    axisTick: { distance: -14, length: 6, lineStyle: { color: '#fff', width: 2 } },
                    splitLine: { distance: -14, length: 14, lineStyle: { color: '#fff', width: 3 } },
                    axisLabel: { color: '#64748b', distance: 22, fontSize: 11 },
                    detail: {
                        valueAnimation: true,
                        formatter: '{value} meq',
                        color: '#0f172a',
                        fontSize: 22,
                        offsetCenter: [0, '70%'],
                        fontWeight: 'bold'
                    },
                    data: [{ value: valor }]
                }]
            };
            chartGauge.setOption(option);
        }

        function ejecutarCalculo(e) {
            e.preventDefault();
            var S = parseFloat(document.getElementById('gastoS').value);
            var B = parseFloat(document.getElementById('gastoB').value);
            var N = parseFloat(document.getElementById('normN').value);
            var W = parseFloat(document.getElementById('pesoW').value);

            if (W <= 0) {
                alert('El peso debe ser mayor a 0');
                return;
            }

            var pov = ((S - B) * N * 1000) / W;
            var povRedondeado = parseFloat(pov.toFixed(2));
            document.getElementById('badgePOV').innerText = povRedondeado + ' meq O₂';
            actualizarGauge(povRedondeado);

            var dict = document.getElementById('txtDictamen');
            if (povRedondeado <= 5.0) {
                dict.className = 'badge bg-success p-2 w-100 mono';
                dict.innerText = 'CONFORME (ACEITE FRESCO / PRIMARIO)';
            } else if (povRedondeado <= 10.0) {
                dict.className = 'badge bg-warning text-dark p-2 w-100 mono';
                dict.innerText = 'ACEPTABLE (LÍMITE MÁXIMO PERMITIDO REFINADOS)';
            } else {
                dict.className = 'badge bg-danger p-2 w-100 mono';
                dict.innerText = 'NO CONFORME (OXIDACIÓN LIPÍDICA AVANZADA)';
            }
        }
    </script>
</body>
</html>
