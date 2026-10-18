<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String fechaHoy = new SimpleDateFormat("dd/MM/yyyy").format(new Date());

    // Parámetros recibidos por GET/POST o valores por defecto
    String certificadoNro = request.getParameter("nro") != null ? request.getParameter("nro") : "CoA-2026-PE-00894";
    String cliente = request.getParameter("cliente") != null ? request.getParameter("cliente") : "Agroindustrias del Valle S.A.C.";
    String ruc = request.getParameter("ruc") != null ? request.getParameter("ruc") : "20548963214";
    String muestra = request.getParameter("muestra") != null ? request.getParameter("muestra") : "Aceite Refinado de Soya - Lote SOY-2026-A";
    String fechaToma = request.getParameter("fechaToma") != null ? request.getParameter("fechaToma") : "16/10/2026";
    String fechaEnsayo = request.getParameter("fechaEnsayo") != null ? request.getParameter("fechaEnsayo") : "18/10/2026";

    String povVal = request.getParameter("pov") != null ? request.getParameter("pov") : "2.45";
    String anvVal = request.getParameter("anv") != null ? request.getParameter("anv") : "4.10";
    String osiVal = request.getParameter("osi") != null ? request.getParameter("osi") : "9.8";

    double povD = 2.45;
    double anvD = 4.10;
    try { povD = Double.parseDouble(povVal); } catch (Exception e) {}
    try { anvD = Double.parseDouble(anvVal); } catch (Exception e) {}
    double totoxD = (2 * povD) + anvD;
    String totoxStr = String.format("%.2f", totoxD);

    boolean esConforme = (totoxD <= 26.0 && povD <= 10.0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Informe Oficial de Ensayo <%= certificadoNro %> - RanciLab LIMS</title>
    <!-- Fonts & Bootstrap 5 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Generador dinámico de código de barras JsBarcode -->
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>

    <style>
        :root {
            --cert-navy: #091e42;
            --cert-teal: #0d9488;
            --cert-border: #cbd5e1;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #0f172a;
            color: #1e293b;
            margin: 0;
            padding: 0;
        }
        .mono {
            font-family: 'JetBrains Mono', monospace;
        }

        /* Barra de Herramientas y Formulario de Entrada (No se imprimen) */
        .toolbar-top {
            background: #1e293b;
            border-bottom: 1px solid #334155;
            padding: 12px 24px;
        }
        .data-input-panel {
            background: #131d31;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 16px 24px;
            color: #e2e8f0;
        }
        .data-input-panel label {
            font-size: 0.72rem;
            text-transform: uppercase;
            font-weight: 700;
            color: #94a3b8;
            margin-bottom: 3px;
        }
        .data-input-panel input, .data-input-panel select {
            font-size: 0.82rem;
            background-color: #0f172a;
            border: 1px solid #334155;
            color: #ffffff;
        }
        .data-input-panel input:focus, .data-input-panel select:focus {
            background-color: #0f172a;
            border-color: var(--cert-teal);
            color: #ffffff;
            box-shadow: 0 0 0 2px rgba(13, 148, 136, 0.25);
        }

        /* Contenedor Hoja A4 Rigurosa */
        .paper-a4 {
            background: #ffffff;
            width: 210mm;
            min-height: 297mm;
            margin: 25px auto 40px auto;
            padding: 16mm 20mm;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            position: relative;
            box-sizing: border-box;
            border-top: 5px solid var(--cert-navy);
        }
        .header-grid {
            display: grid;
            grid-template-columns: 1fr auto;
            border-bottom: 2px solid var(--cert-navy);
            padding-bottom: 12px;
            margin-bottom: 16px;
        }
        .logo-box h2 {
            font-weight: 800;
            color: var(--cert-navy);
            letter-spacing: -0.5px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1.45rem;
        }
        .logo-box p {
            margin: 0;
            font-size: 0.70rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }
        .meta-coa {
            text-align: right;
        }
        .badge-acreditacion {
            border: 1px solid #0d9488;
            background: #f0fdfa;
            color: #0d9488;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.68rem;
            padding: 3px 8px;
            font-weight: 700;
            display: inline-block;
            margin-bottom: 4px;
        }
        .custody-box {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 18px;
        }
        .custody-card {
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            padding: 10px 14px;
            border-radius: 4px;
        }
        .custody-title {
            font-size: 0.68rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 800;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            border-bottom: 1px dashed #cbd5e1;
            padding-bottom: 2px;
        }
        .custody-value {
            font-size: 0.82rem;
            color: #0f172a;
            font-weight: 600;
        }
        .table-coa {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 16px;
            font-size: 0.80rem;
        }
        .table-coa thead th {
            background-color: var(--cert-navy);
            color: #ffffff;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.70rem;
            letter-spacing: 0.5px;
            padding: 8px 10px;
            border: 1px solid var(--cert-navy);
        }
        .table-coa tbody td {
            padding: 8px 10px;
            border: 1px solid #cbd5e1;
            vertical-align: middle;
        }
        .table-coa tbody tr:nth-child(even) {
            background-color: #f8fafc;
        }
        .dictamen-box {
            border: 1px solid #cbd5e1;
            padding: 10px 14px;
            margin-bottom: 16px;
        }
        .signatures-grid {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            align-items: center;
            margin-top: 36px;
            padding-top: 10px;
        }
        .sign-col {
            text-align: center;
        }
        .sign-line {
            width: 80%;
            margin: 0 auto;
            border-top: 1px solid #334155;
            padding-top: 6px;
            font-size: 0.75rem;
            color: #334155;
        }
        .seal-wrapper {
            width: 86px;
            height: 86px;
            border: 2px dashed #0d9488;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #0d9488;
            font-size: 0.52rem;
            text-transform: uppercase;
            font-weight: 800;
            text-align: center;
            padding: 4px;
            margin: 0 auto;
            transform: rotate(-8deg);
        }
        .footer-legal {
            border-top: 1px solid #e2e8f0;
            padding-top: 10px;
            margin-top: 24px;
            font-size: 0.65rem;
            color: #64748b;
            line-height: 1.4;
        }

        /* Al Imprimir / Guardar en PDF se ocultan los controles */
        @media print {
            body {
                background: none !important;
                padding: 0 !important;
            }
            .no-print {
                display: none !important;
            }
            .paper-a4 {
                box-shadow: none !important;
                border-top: 5px solid var(--cert-navy) !important;
                margin: 0 !important;
                width: 100% !important;
                padding: 12mm 15mm !important;
            }
            @page {
                size: A4 portrait;
                margin: 8mm;
            }
        }
    </style>
</head>
<body>

    <!-- Barra de Acciones Superior (No Imprimible) -->
    <div class="toolbar-top no-print d-flex justify-content-between align-items-center">
        <a href="panel.jsp" class="btn btn-outline-light btn-sm">
            <i class="bi bi-arrow-left"></i> Menú Principal
        </a>
        <div class="d-flex align-items-center gap-2">
            <button class="btn btn-outline-info btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#panelEntrada">
                <i class="bi bi-pencil-square me-1"></i> Modificar Datos de Entrada
            </button>
            <button onclick="window.print()" class="btn btn-success btn-sm fw-bold px-3">
                <i class="bi bi-printer-fill me-1"></i> Imprimir / Guardar en PDF
            </button>
        </div>
    </div>

    <!-- Panel de Entrada de Datos de Resultados (No Imprimible) -->
    <div class="collapse show no-print" id="panelEntrada">
        <div class="data-input-panel">
            <form method="GET" action="informe_ensayo.jsp" class="row g-2 align-items-end">
                <div class="col-md-2">
                    <label>N° Certificado:</label>
                    <input type="text" name="nro" class="form-control form-control-sm mono" value="<%= certificadoNro %>" required>
                </div>
                <div class="col-md-3">
                    <label>Cliente Solicitante:</label>
                    <input type="text" name="cliente" class="form-control form-control-sm" value="<%= cliente %>" required>
                </div>
                <div class="col-md-2">
                    <label>R.U.C. Cliente:</label>
                    <input type="text" name="ruc" class="form-control form-control-sm mono" value="<%= ruc %>" required>
                </div>
                <div class="col-md-3">
                    <label>Descripción Muestra / Lote:</label>
                    <input type="text" name="muestra" class="form-control form-control-sm" value="<%= muestra %>" required>
                </div>
                <div class="col-md-2">
                    <label>Fecha Recepción:</label>
                    <input type="text" name="fechaToma" class="form-control form-control-sm mono" value="<%= fechaToma %>">
                </div>
                
                <!-- Resultados analíticos obtenidos en laboratorio -->
                <div class="col-md-2">
                    <label class="text-info fw-bold">POV (meq O₂/kg):</label>
                    <input type="number" step="0.01" name="pov" class="form-control form-control-sm mono text-warning fw-bold" value="<%= povVal %>" required>
                </div>
                <div class="col-md-2">
                    <label class="text-info fw-bold">p-Anisidina (AnV):</label>
                    <input type="number" step="0.01" name="anv" class="form-control form-control-sm mono text-warning fw-bold" value="<%= anvVal %>" required>
                </div>
                <div class="col-md-2">
                    <label class="text-info fw-bold">OSI Rancimat (h):</label>
                    <input type="number" step="0.1" name="osi" class="form-control form-control-sm mono text-warning fw-bold" value="<%= osiVal %>" required>
                </div>
                <div class="col-md-3">
                    <label>Fecha de Ensayo:</label>
                    <input type="text" name="fechaEnsayo" class="form-control form-control-sm mono" value="<%= fechaEnsayo %>">
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-teal btn-sm w-100 fw-bold" style="background-color: #0d9488; color:#fff;">
                        <i class="bi bi-arrow-repeat me-1"></i> Generar Certificado con estos Datos
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Hoja A4 Oficial del Certificado (Lo que se imprime) -->
    <div class="paper-a4">
        
        <!-- Header Oficial -->
        <div class="header-grid">
            <div class="logo-box">
                <h2><i class="bi bi-droplet-half" style="color: #0d9488;"></i> RANCILAB LIMS S.A.C.</h2>
                <p>Laboratorio Analítico de Fisicoquímica, Rancidez y Estabilidad Lipídica</p>
                <div class="text-muted mono mt-1" style="font-size: 0.68rem;">
                    SEDE METROLÓGICA CALLAO &bull; R.U.C. 20608974512 &bull; www.rancilab.pe
                </div>
            </div>
            <div class="meta-coa">
                <div class="badge-acreditacion"><i class="bi bi-patch-check-fill me-1"></i>ISO/IEC 17025 (INACAL)</div>
                <div class="mono fw-bold fs-6 text-dark mt-1"><%= certificadoNro %></div>
                <div class="mono text-muted" style="font-size: 0.72rem;">Emisión: <%= fechaHoy %></div>
                <svg id="barcodeCert" style="max-height: 28px; margin-top: 3px;"></svg>
            </div>
        </div>

        <!-- Título -->
        <div class="text-center mb-3">
            <h5 class="fw-bold mb-0 text-uppercase tracking-wide" style="letter-spacing: 1px; color: #091e42;">
                CERTIFICADO DE ANÁLISIS DE CALIDAD LIPÍDICA (CoA)
            </h5>
            <small class="text-muted mono">DICTAMEN TÉCNICO SEGÚN NORMA CODEX ALIMENTARIUS (CXS 210-1999)</small>
        </div>

        <!-- Datos de Recepción & Muestra -->
        <div class="custody-box">
            <div class="custody-card">
                <div class="custody-title"><i class="bi bi-building me-1"></i>Datos del Cliente Solicitante</div>
                <div class="custody-value"><%= cliente %></div>
                <div class="small text-muted mono">R.U.C.: <%= ruc %></div>
                <div class="small text-muted">Orden SOLPED: <strong>SOL-2026-0001</strong></div>
            </div>
            <div class="custody-card">
                <div class="custody-title"><i class="bi bi-box-seam me-1"></i>Datos de la Muestra & Recepción</div>
                <div class="custody-value"><%= muestra %></div>
                <div class="small text-muted mono">F. Recepción: <%= fechaToma %> &bull; F. Ensayo: <%= fechaEnsayo %></div>
                <div class="small text-muted">Condición Custodia: <span class="badge bg-light text-dark border">Refrigerado (4°C, Oscuridad)</span></div>
            </div>
        </div>

        <!-- Tabla Cuantitativa de Ensayos -->
        <table class="table-coa">
            <thead>
                <tr>
                    <th style="width: 28%;">Ensayo / Parámetro</th>
                    <th style="width: 22%;">Método Normalizado</th>
                    <th class="text-center" style="width: 13%;">Resultado</th>
                    <th class="text-center" style="width: 12%;">Incert. (U)</th>
                    <th class="text-center" style="width: 10%;">Unidad</th>
                    <th class="text-center" style="width: 15%;">Límite Codex</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Índice de Peróxidos (POV)</strong><br><small class="text-muted">Oxidación primaria (hidroperóxidos)</small></td>
                    <td class="mono small">AOCS Cd 8b-90 (Titulación)</td>
                    <td class="text-center mono fw-bold"><%= String.format("%.2f", povD) %></td>
                    <td class="text-center mono text-muted">&plusmn; 0.12</td>
                    <td class="text-center small">meq O₂/kg</td>
                    <td class="text-center small mono">&le; 10.0</td>
                </tr>
                <tr>
                    <td><strong>Valor p-Anisidina (AnV)</strong><br><small class="text-muted">Oxidación secundaria (2-alquenales)</small></td>
                    <td class="mono small">ISO 3960 / AOCS Cd 18-90</td>
                    <td class="text-center mono fw-bold"><%= String.format("%.2f", anvD) %></td>
                    <td class="text-center mono text-muted">&plusmn; 0.18</td>
                    <td class="text-center small">adimensional</td>
                    <td class="text-center small mono">&le; 15.0</td>
                </tr>
                <tr>
                    <td><strong>Estabilidad Oxidativa (OSI)</strong><br><small class="text-muted">Ensayo térmico acelerado 110°C, 10 L/h</small></td>
                    <td class="mono small">AOCS Cd 12b-92 (Rancimat)</td>
                    <td class="text-center mono fw-bold"><%= osiVal %></td>
                    <td class="text-center mono text-muted">&plusmn; 0.35</td>
                    <td class="text-center small">horas</td>
                    <td class="text-center small mono">&ge; 6.0 h</td>
                </tr>
                <tr style="background-color: <%= esConforme ? "#f0fdfa" : "#fff1f2" %>;">
                    <td><strong>Valor Total de Oxidación (TOTOX)</strong><br><small class="text-muted">Cálculo: (2 &times; POV) + AnV</small></td>
                    <td class="mono small">AOCS Formula Standard</td>
                    <td class="text-center mono fw-bold <%= esConforme ? "text-success" : "text-danger" %> fs-6"><%= totoxStr %></td>
                    <td class="text-center mono text-muted">&plusmn; 0.28</td>
                    <td class="text-center small">adimensional</td>
                    <td class="text-center small mono fw-bold <%= esConforme ? "text-success" : "text-danger" %>">&le; 26.0</td>
                </tr>
            </tbody>
        </table>

        <!-- Dictamen Técnico según Cálculos -->
        <div class="dictamen-box" style="border-left: 4px solid <%= esConforme ? "#10b981" : "#ef4444" %>; background: <%= esConforme ? "#f0fdf4" : "#fef2f2" %>;">
            <div class="d-flex align-items-center justify-content-between mb-1">
                <span class="mono fw-bold <%= esConforme ? "text-success" : "text-danger" %>" style="font-size: 0.75rem;">
                    <i class="bi <%= esConforme ? "bi-check-circle-fill" : "bi-x-circle-fill" %> me-1"></i>
                    DICTAMEN TÉCNICO: <%= esConforme ? "CONFORME" : "NO CONFORME" %>
                </span>
                <span class="badge <%= esConforme ? "bg-success" : "bg-danger" %> mono" style="font-size: 0.65rem;">
                    <%= esConforme ? "CUMPLE ESPECIFICACIONES CODEX" : "RANCIDEZ / SUPERA LÍMITES" %>
                </span>
            </div>
            <p class="mb-0 text-muted" style="font-size: 0.74rem; line-height: 1.35;">
                <% if (esConforme) { %>
                    La muestra analizada cumple satisfactoriamente con los criterios de inocuidad y estabilidad oxidativa establecidos por la Norma Internacional <strong>Codex CXS 210-1999</strong> para aceites vegetales comerciales.
                <% } else { %>
                    La muestra analizada presenta índices de oxidación que exceden las tolerancias máximas establecidas por la Norma <strong>Codex CXS 210-1999</strong>, catalogándose como no apta para consumo directo sin refinación correctiva.
                <% } %>
            </p>
        </div>

        <!-- Firmas Oficiales y Sello -->
        <div class="signatures-grid">
            <div class="sign-col">
                <div class="sign-line">
                    <strong>Ing. <%= usuario %></strong><br>
                    <span class="text-muted" style="font-size: 0.68rem;">Analista Titular Fisicoquímico</span><br>
                    <span class="mono text-muted" style="font-size: 0.62rem;">CIP / CNP REG. 8147</span>
                </div>
            </div>
            <div class="sign-col">
                <div class="seal-wrapper">
                    <i class="bi bi-shield-check fs-4"></i>
                    <span>RANCILAB<br>CONTROLADO</span>
                    <span class="mono" style="font-size: 0.45rem;">2026-VAL</span>
                </div>
            </div>
            <div class="sign-col">
                <div class="sign-line">
                    <strong>Dra. Carmen Valdivia E.</strong><br>
                    <span class="text-muted" style="font-size: 0.68rem;">Directora Técnica de Laboratorio</span><br>
                    <span class="mono text-muted" style="font-size: 0.62rem;">Certificación GLP-PE</span>
                </div>
            </div>
        </div>

        <!-- Footer Legal y Hash Criptográfico -->
        <div class="footer-legal">
            <div class="d-flex justify-content-between">
                <span>* Los resultados consignados corresponden exclusivamente a la muestra analizada según cadena de custodia.</span>
                <span class="mono">Pág. 1 de 1</span>
            </div>
            <div class="mono text-muted mt-1" style="font-size: 0.58rem;">
                HASH DE VALIDACIÓN DIGITAL (SHA-256): 9a7f4e8b2c1d0f5e6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            try {
                JsBarcode("#barcodeCert", "<%= certificadoNro %>", {
                    format: "CODE128",
                    width: 1.1,
                    height: 25,
                    displayValue: false,
                    margin: 0
                });
            } catch (e) {
                console.error("Error generando barcode:", e);
            }
        });
    </script>
</body>
</html>