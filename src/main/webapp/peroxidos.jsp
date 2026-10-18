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
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

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
        .btn-teal {
            background-color: var(--primary-teal);
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-teal:hover {
            background-color: #0f766e;
            color: #ffffff;
        }
        .calc-result-box {
            background-color: #f0fdfa;
            border: 1px solid #ccfbf1;
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
            <span class="badge bg-teal text-white mb-2" style="background-color: #0d9488;">Norma Técnica AOCS Cd 8b-90</span>
            <h3 class="fw-bold mb-1">Determinación del Índice de Peróxidos (POV)</h3>
            <p class="text-muted small">Titulación iodométrica de hidroperóxidos lipídicos primarios expresado en meq O₂/kg de muestra.</p>
        </div>

        <div class="row g-4">
            <!-- Formulario de Cálculo -->
            <div class="col-md-7">
                <div class="card card-custom p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-droplet-half text-teal me-2"></i>Datos de Titulación</h5>
                    <form id="formPOV" onsubmit="calcularPOV(event)">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Identificación de Muestra / Lote:</label>
                            <input type="text" id="lote" class="form-control" placeholder="ej. ACEITE-SOYA-L01" required>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Gasto Titulante Muestra (S, mL):</label>
                                <input type="number" step="0.01" id="gastoMuestra" class="form-control" placeholder="ej. 3.45" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Gasto Blanco (B, mL):</label>
                                <input type="number" step="0.01" id="gastoBlanco" class="form-control" value="0.05" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Normalidad Na₂S₂O₃ (N):</label>
                                <input type="number" step="0.0001" id="normalidad" class="form-control" value="0.0100" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Peso de la Muestra (W, g):</label>
                                <input type="number" step="0.0001" id="pesoMuestra" class="form-control" placeholder="ej. 5.0124" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-teal w-100">
                            <i class="bi bi-calculator me-1"></i> Calcular y Evaluar POV
                        </button>
                    </form>
                </div>
            </div>

            <!-- Panel de Resultados & Dictamen -->
            <div class="col-md-5">
                <div class="card card-custom p-4 h-100 d-flex flex-column justify-content-between">
                    <div>
                        <h5 class="fw-bold mb-3"><i class="bi bi-check2-circle text-success me-2"></i>Resultado Analítico</h5>
                        <div class="calc-result-box text-center mb-3">
                            <span class="small text-muted d-block text-uppercase fw-bold">Índice de Peróxidos Calculado</span>
                            <span id="valorPOV" class="display-6 fw-bold text-dark font-monospace">--</span>
                            <span class="d-block small text-muted">meq O₂ / kg</span>
                        </div>
                        <div id="dictamenBox" class="p-3 rounded-3 bg-light text-center">
                            <span class="small text-muted d-block">Dictamen según Codex Alimentarius / AOCS:</span>
                            <span id="estadoPOV" class="fw-bold text-secondary">Pendiente de cálculo</span>
                        </div>
                    </div>
                    <div class="mt-4 pt-3 border-top small text-muted">
                        <strong>Fórmula AOCS:</strong><br>
                        <code>POV = ((S - B) × N × 1000) / W</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function calcularPOV(e) {
            e.preventDefault();
            const S = parseFloat(document.getElementById('gastoMuestra').value);
            const B = parseFloat(document.getElementById('gastoBlanco').value);
            const N = parseFloat(document.getElementById('normalidad').value);
            const W = parseFloat(document.getElementById('pesoMuestra').value);

            if (W <= 0) {
                alert('El peso de la muestra debe ser mayor a cero.');
                return;
            }

            const pov = ((S - B) * N * 1000) / W;
            document.getElementById('valorPOV').innerText = pov.toFixed(2);

            const dictamen = document.getElementById('estadoPOV');
            if (pov <= 5.0) {
                dictamen.className = 'fw-bold text-success';
                dictamen.innerText = 'CONFORME (Aceite Fresco / Primario)';
            } else if (pov <= 10.0) {
                dictamen.className = 'fw-bold text-warning';
                dictamen.innerText = 'ACEPTABLE (Límite máximo permitido refinados)';
            } else {
                dictamen.className = 'fw-bold text-danger';
                dictamen.innerText = 'NO CONFORME (Oxidación Lipídica Avanzada)';
            }
        }
    </script>
</body>
</html>
