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
    <title>RanciLab - Valor de p-Anisidina</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-blue: #0284c7;
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
        .btn-blue {
            background-color: var(--primary-blue);
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-blue:hover {
            background-color: #0369a1;
            color: #ffffff;
        }
        .calc-result-box {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
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

    <!-- Contenido Principal -->
    <div class="container my-4" style="max-width: 950px;">
        <div class="mb-4">
            <span class="badge bg-primary text-white mb-2">Norma Técnica ISO 3960 / AOCS Cd 18-90</span>
            <h3 class="fw-bold mb-1">Determinación del Valor de p-Anisidina (AnV)</h3>
            <p class="text-muted small">Cuantificación espectrofotométrica a 350 nm de compuestos carbonílicos secundarios (2-alquenales y 2,4-dienales).</p>
        </div>

        <div class="row g-4">
            <!-- Formulario de Espectrofotometría -->
            <div class="col-md-7">
                <div class="card card-custom p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-eyedropper text-primary me-2"></i>Lecturas Espectrofotométricas (350 nm)</h5>
                    <form id="formAnisidina" onsubmit="calcularAnisidina(event)">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Identificación de Muestra / Lote:</label>
                            <input type="text" id="loteAni" class="form-control" placeholder="ej. ACEITE-GIRASOL-L02" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Absorbancia Muestra Reaccionada (As):</label>
                                <input type="number" step="0.001" id="absMuestra" class="form-control" placeholder="ej. 0.425" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Absorbancia del Blanco (Ab):</label>
                                <input type="number" step="0.001" id="absBlanco" class="form-control" placeholder="ej. 0.082" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Peso de Grasa / Aceite (m, g en 25 mL):</label>
                            <input type="number" step="0.0001" id="pesoGrasa" class="form-control" placeholder="ej. 1.0250" required>
                        </div>
                        <button type="submit" class="btn btn-blue w-100">
                            <i class="bi bi-calculator me-1"></i> Calcular Valor p-Anisidina
                        </button>
                    </form>
                </div>
            </div>

            <!-- Panel de Resultados -->
            <div class="col-md-5">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <h5 class="fw-bold mb-3"><i class="bi bi-check2-circle text-success me-2"></i>Resultado Espectral</h5>
                        <div class="calc-result-box text-center mb-3">
                            <span class="small text-muted d-block text-uppercase fw-bold">Valor p-Anisidina (AnV)</span>
                            <span id="valorAnisidina" class="display-6 fw-bold text-dark font-monospace">--</span>
                            <span class="d-block small text-muted">adimensional</span>
                        </div>
                        <div id="dictamenAnisidinaBox" class="p-3 rounded-3 bg-light text-center">
                            <span class="small text-muted d-block">Evaluación de Oxidación Secundaria:</span>
                            <span id="estadoAnisidina" class="fw-bold text-secondary">Pendiente de cálculo</span>
                        </div>
                    </div>
                    <div class="mt-4 pt-3 border-top small text-muted">
                        <strong>Fórmula ISO 3960:</strong><br>
                        <code>AnV = (25 × (1.2 × As - Ab)) / m</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function calcularAnisidina(e) {
            e.preventDefault();
            const As = parseFloat(document.getElementById('absMuestra').value);
            const Ab = parseFloat(document.getElementById('absBlanco').value);
            const m = parseFloat(document.getElementById('pesoGrasa').value);

            if (m <= 0) {
                alert('El peso de la muestra debe ser mayor a cero.');
                return;
            }

            const anv = (25 * (1.2 * As - Ab)) / m;
            document.getElementById('valorAnisidina').innerText = anv.toFixed(2);

            const dictamen = document.getElementById('estadoAnisidina');
            if (anv <= 10.0) {
                dictamen.className = 'fw-bold text-success';
                dictamen.innerText = 'CONFORME (Baja presencia de 2-alquenales)';
            } else if (anv <= 15.0) {
                dictamen.className = 'fw-bold text-warning';
                dictamen.innerText = 'LÍMITE (Inicio de alteración térmica/oxidativa)';
            } else {
                dictamen.className = 'fw-bold text-danger';
                dictamen.innerText = 'NO CONFORME (Rancidez secundaria elevada)';
            }
        }
    </script>
</body>
</html>