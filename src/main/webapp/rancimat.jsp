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
    <title>RanciLab - Estabilidad Oxidativa (OSI)</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-amber: #d97706;
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
        .btn-amber {
            background-color: var(--primary-amber);
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-amber:hover {
            background-color: #b45309;
            color: #ffffff;
        }
        .calc-result-box {
            background-color: #fffbeb;
            border: 1px solid #fef3c7;
            border-radius: 12px;
            padding: 20px;
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
    <div class="container my-4" style="max-width: 950px;">
        <div class="mb-4">
            <span class="badge bg-warning text-dark mb-2">Norma Técnica AOCS Cd 12b-92 / ISO 6886</span>
            <h3 class="fw-bold mb-1">Índice de Estabilidad Oxidativa (OSI) & Valor TOTOX</h3>
            <p class="text-muted small">Determinación del tiempo de inducción mediante ensayo acelerado Rancimat y cálculo de oxidación total.</p>
        </div>

        <div class="row g-4">
            <!-- Formulario de Ensayo -->
            <div class="col-md-7">
                <div class="card card-custom p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-thermometer-sun text-warning me-2"></i>Parámetros de Ensayo Rancimat</h5>
                    <form id="formOSI" onsubmit="calcularOSI(event)">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Identificación de Muestra / Lote:</label>
                            <input type="text" id="loteOSI" class="form-control" placeholder="ej. ACEITE-PALMA-L03" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Temperatura de Bloque (°C):</label>
                                <input type="number" step="0.1" id="temp" class="form-control" value="110.0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Flujo de Aire (L/h):</label>
                                <input type="number" step="0.1" id="flujo" class="form-control" value="10.0" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Tiempo de Inducción Medido (h):</label>
                                <input type="number" step="0.1" id="tiempoInduccion" class="form-control" placeholder="ej. 8.5" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Índice de Peróxidos previo (POV):</label>
                                <input type="number" step="0.01" id="povPrevio" class="form-control" placeholder="ej. 2.10" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Valor p-Anisidina previo (AnV):</label>
                            <input type="number" step="0.01" id="anvPrevio" class="form-control" placeholder="ej. 4.30" required>
                        </div>
                        <button type="submit" class="btn btn-amber w-100">
                            <i class="bi bi-calculator me-1"></i> Calcular Estabilidad y TOTOX
                        </button>
                    </form>
                </div>
            </div>

            <!-- Panel de Resultados -->
            <div class="col-md-5">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <h5 class="fw-bold mb-3"><i class="bi bi-shield-check text-success me-2"></i>Resultados de Estabilidad</h5>
                        <div class="calc-result-box text-center mb-3">
                            <span class="small text-muted d-block text-uppercase fw-bold">Valor Total de Oxidación (TOTOX)</span>
                            <span id="valorTotox" class="display-6 fw-bold text-dark font-monospace">--</span>
                            <span class="d-block small text-muted">adimensional</span>
                        </div>
                        <div class="p-3 rounded-3 bg-light text-center mb-2">
                            <span class="small text-muted d-block">Vida Útil Estimada a 20°C:</span>
                            <span id="vidaUtil" class="fw-bold text-dark font-monospace">--</span>
                        </div>
                        <div id="dictamenBox" class="p-2 rounded-3 text-center">
                            <span id="estadoTotox" class="fw-bold text-secondary">Pendiente de cálculo</span>
                        </div>
                    </div>
                    <div class="mt-4 pt-3 border-top small text-muted">
                        <strong>Fórmula TOTOX:</strong><br>
                        <code>TOTOX = (2 × POV) + AnV</code><br>
                        <small>Criterio: TOTOX &lt; 10 indica excelente calidad.</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function calcularOSI(e) {
            e.preventDefault();
            const horas = parseFloat(document.getElementById('tiempoInduccion').value);
            const pov = parseFloat(document.getElementById('povPrevio').value);
            const anv = parseFloat(document.getElementById('anvPrevio').value);

            const totox = (2 * pov) + anv;
            document.getElementById('valorTotox').innerText = totox.toFixed(2);

            // Factor térmico de extrapolación aproximado (Q10 ~ 2 por cada 10°C)
            const mesesEstimados = (horas * Math.pow(2, (110 - 20) / 10) / 720).toFixed(1);
            document.getElementById('vidaUtil').innerText = mesesEstimados + ' meses';

            const dictamen = document.getElementById('estadoTotox');
            if (totox <= 10.0) {
                dictamen.className = 'fw-bold text-success';
                dictamen.innerText = 'CONFORME (Excelente Estabilidad Oxidativa)';
            } else if (totox <= 26.0) {
                dictamen.className = 'fw-bold text-warning';
                dictamen.innerText = 'ACEPTABLE (Estabilidad Comercial Estándar)';
            } else {
                dictamen.className = 'fw-bold text-danger';
                dictamen.innerText = 'NO CONFORME (Elevado Deterioro Oxidativo)';
            }
        }
    </script>
</body>
</html>