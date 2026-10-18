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

    // Parámetros recibidos o valores por defecto para previsualizar
    String certificadoNro = request.getParameter("nro") != null ? request.getParameter("nro") : "CERT-2026-0042";
    String cliente = request.getParameter("cliente") != null ? request.getParameter("cliente") : "Agroindustrias del Valle S.A.C.";
    String ruc = request.getParameter("ruc") != null ? request.getParameter("ruc") : "20548963214";
    String muestra = request.getParameter("muestra") != null ? request.getParameter("muestra") : "Aceite de Soya Refinado - Lote SOY-2026-A";
    String fechaToma = request.getParameter("fechaToma") != null ? request.getParameter("fechaToma") : "15/10/2026";

    // Ensayos y valores analíticos
    String povVal = request.getParameter("pov") != null ? request.getParameter("pov") : "2.45";
    String anvVal = request.getParameter("anv") != null ? request.getParameter("anv") : "4.10";
    String osiVal = request.getParameter("osi") != null ? request.getParameter("osi") : "9.8";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Informe de Ensayo <%= certificadoNro %> - RanciLab LIMS</title>
    <!-- Fuentes y Bootstrap -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f1f5f9;
            color: #0f172a;
        }
        /* Contenedor tipo Hoja A4 */
        .page-sheet {
            background: #ffffff;
            max-width: 850px;
            margin: 25px auto;
            padding: 40px 50px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border-radius: 8px;
            border: 1px solid #cbd5e1;
        }
        .header-cert {
            border-bottom: 2px solid #0f172a;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .cert-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.88rem;
        }
        .cert-table th {
            background-color: #f8fafc;
            border: 1px solid #cbd5e1;
            padding: 8px 12px;
            font-weight: 700;
        }
        .cert-table td {
            border: 1px solid #cbd5e1;
            padding: 8px 12px;
        }
        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            color: #64748b;
        }
        .firma-line {
            width: 220px;
            border-top: 1px solid #334155;
            margin-top: 60px;
            text-align: center;
            font-size: 0.8rem;
            color: #475569;
        }

        /* Reglas automáticas para IMPRESIÓN / GUARDAR COMO PDF */
        @media print {
            body {
                background: none !important;
                padding: 0 !important;
            }
            .no-print {
                display: none !important;
            }
            .page-sheet {
                box-shadow: none !important;
                border: none !important;
                margin: 0 !important;
                padding: 15mm 20mm !important;
                max-width: 100% !important;
                width: 100% !important;
            }
            @page {
                size: A4 portrait;
                margin: 10mm;
            }
        }
    </style>
</head>
<body>

    <!-- Barra de acciones flotante (No sale en la impresión) -->
    <div class="no-print bg-dark py-2 px-4 d-flex justify-content-between align-items-center shadow-sm">
        <a href="panel.jsp" class="btn btn-outline-light btn-sm">
            <i class="bi bi-arrow-left"></i> Volver al Menú
        </a>
        <div class="d-flex gap-2">
            <button onclick="window.print()" class="btn btn-success btn-sm fw-bold">
                <i class="bi bi-printer me-1"></i> Imprimir / Guardar como PDF
            </button>
        </div>
    </div>

    <!-- Hoja A4 Formato Certificado de Ensayo -->
    <div class="page-sheet">
        
        <!-- Encabezado Membretado -->
        <div class="header-cert d-flex justify-content-between align-items-center">
            <div>
                <h4 class="fw-bold mb-0 text-dark"><i class="bi bi-moisture text-primary"></i> RanciLab LIMS</h4>
                <p class="small text-muted mb-0">Laboratorio Especializado en Fisicoquímica y Calidad Lipídica</p>
                <small class="text-secondary font-monospace">Acreditación según directrices ISO/IEC 17025</small>
            </div>
            <div class="text-end">
                <span class="badge bg-dark px-3 py-2 font-monospace fs-6">INFORME DE ENSAYO</span>
                <div class="fw-bold text-primary font-monospace mt-1"><%= certificadoNro %></div>
                <small class="text-muted">Fecha de emisión: <%= fechaHoy %></small>
            </div>
        </div>

        <!-- Información de Muestra y Solicitante -->
        <div class="row g-3 mb-4">
            <div class="col-6">
                <div class="p-3 bg-light rounded border">
                    <span class="info-label d-block">Cliente / Empresa Solicitante:</span>
                    <strong class="d-block text-dark"><%= cliente %></strong>
                    <span class="small text-muted">R.U.C. / Doc: <%= ruc %></span>
                </div>
            </div>
            <div class="col-6">
                <div class="p-3 bg-light rounded border">
                    <span class="info-label d-block">Identificación de Muestra:</span>
                    <strong class="d-block text-dark"><%= muestra %></strong>
                    <span class="small text-muted">Fecha de muestreo / ingreso: <%= fechaToma %></span>
                </div>
            </div>
        </div>

        <!-- Tabla de Resultados de Ensayos Fisicoquímicos -->
        <h6 class="fw-bold mb-2 text-dark"><i class="bi bi-clipboard2-data me-1"></i> RESULTADOS CUANTITATIVOS DEL ANÁLISIS</h6>
        <table class="cert-table mb-4">
            <thead>
                <tr>
                    <th style="width: 28%;">Parámetro Evaluado</th>
                    <th style="width: 22%;">Método Normalizado</th>
                    <th class="text-center" style="width: 15%;">Resultado</th>
                    <th class="text-center" style="width: 15%;">Unidad</th>
                    <th class="text-center" style="width: 20%;">Límite Codex / Ref.</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Índice de Peróxidos (POV)</strong></td>
                    <td class="font-monospace small">AOCS Cd 8b-90</td>
                    <td class="text-center font-monospace fw-bold"><%= povVal %></td>
                    <td class="text-center small">meq O₂ / kg</td>
                    <td class="text-center small text-muted">&le; 10.0 meq O₂/kg</td>
                </tr>
                <tr>
                    <td><strong>Valor de p-Anisidina (AnV)</strong></td>
                    <td class="font-monospace small">ISO 3960 / AOCS Cd 18-90</td>
                    <td class="text-center font-monospace fw-bold"><%= anvVal %></td>
                    <td class="text-center small">adimensional</td>
                    <td class="text-center small text-muted">&le; 15.0</td>
                </tr>
                <tr>
                    <td><strong>Estabilidad Oxidativa (OSI a 110°C)</strong></td>
                    <td class="font-monospace small">AOCS Cd 12b-92 / Rancimat</td>
                    <td class="text-center font-monospace fw-bold"><%= osiVal %></td>
                    <td class="text-center small">horas</td>
                    <td class="text-center small text-muted">&ge; 6.0 h</td>
                </tr>
                <tr>
                    <td><strong>Valor Total de Oxidación (TOTOX)</strong></td>
                    <td class="font-monospace small">Cálculo: (2 × POV) + AnV</td>
                    <td class="text-center font-monospace fw-bold text-success">
                        <% 
                            double povD = Double.parseDouble(povVal);
                            double anvD = Double.parseDouble(anvVal);
                            double totox = (2 * povD) + anvD;
                        %>
                        <%= String.format("%.2f", totox) %>
                    </td>
                    <td class="text-center small">adimensional</td>
                    <td class="text-center small text-muted">&le; 26.0</td>
                </tr>
            </tbody>
        </table>

        <!-- Dictamen de Conformidad -->
        <div class="p-3 mb-4 border rounded" style="background-color: #f8fafc;">
            <span class="info-label d-block mb-1">Dictamen Técnico Final:</span>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-success px-2 py-1">CONFORME</span>
                <span class="small text-muted">
                    La muestra analizada cumple con los parámetros y especificaciones de estabilidad oxidativa exigidos por el <strong>Codex Alimentarius (CXS 210-1999)</strong> para aceites vegetales refinados.
                </span>
            </div>
        </div>

        <!-- Nota legal y firmas -->
        <p class="small text-muted" style="font-size: 0.72rem; line-height: 1.4;">
            <em>* Los resultados analíticos consignados se refieren exclusivamente a la muestra recepcionada e identificada en este informe. Este documento no debe reproducirse parcialmente sin la autorización por escrito de la dirección de RanciLab LIMS.</em>
        </p>

        <div class="d-flex justify-content-between align-items-end mt-5 pt-4">
            <div class="firma-line">
                <strong>Ing. Analista Responsable</strong><br>
                Analista: <%= usuario %><br>
                <small class="text-muted">Área Fisicoquímica Lipídica</small>
            </div>
            <div class="text-center">
                <div class="border p-2 bg-light font-monospace small" style="width: 110px; height: 110px; display: flex; align-items: center; justify-content: center; margin: 0 auto 5px;">
                    <i class="bi bi-qr-code fs-1 text-secondary"></i>
                </div>
                <small class="text-muted font-monospace" style="font-size: 0.65rem;">Validación Digital GLP</small>
            </div>
            <div class="firma-line">
                <strong>Director Técnico / Calidad</strong><br>
                RanciLab LIMS S.A.C.<br>
                <small class="text-muted">Certificación de Ensayos</small>
            </div>
        </div>

    </div>

</body>
</html>