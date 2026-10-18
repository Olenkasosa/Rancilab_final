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
    <title>RanciLab - Trazabilidad & Rótulos de Custodia</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Generador de Códigos de Barras JsBarcode -->
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>

    <style>
        :root {
            --slate-900: #0f172a;
            --purple-600: #7e22ce;
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
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
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
        /* Etiqueta Adhesiva Metrológica */
        .sample-label {
            background: #ffffff;
            border: 2px solid #0f172a;
            border-radius: 6px;
            padding: 16px;
            width: 340px;
            margin: 0 auto;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        @media print {
            body * {
                visibility: hidden;
            }
            #printableLabelArea, #printableLabelArea * {
                visibility: visible;
            }
            #printableLabelArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <nav class="navbar navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i>
                <span>RanciLab <span class="fw-light text-secondary">LIMS</span></span>
            </a>
            <div class="d-flex align-items-center gap-3 text-white">
                <a href="panel.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Volver al Menú</a>
                <span class="small text-secondary">Analista: <strong class="mono text-white"><%= usuario %></strong></span>
            </div>
        </div>
    </nav>

    <!-- Contenido -->
    <div class="container-fluid px-4 my-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">Cadena de Custodia & Trazabilidad de Muestras</h3>
                <p class="text-muted small mb-0">Recepción, preservación térmica y generación de etiquetas de código de barras según norma ISO/IEC 17025.</p>
            </div>
            <button class="btn btn-dark fw-bold btn-sm" onclick="alert('Registro de recepción rápida disponible.');">
                <i class="bi bi-plus-circle me-1"></i> Recepcionar Nueva Muestra
            </button>
        </div>

        <div class="card card-enterprise p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Código Custodia</th>
                            <th>Matriz Lipídica</th>
                            <th>Lote de Origen</th>
                            <th>Condición Preservación</th>
                            <th>Fecha Recepción</th>
                            <th>Estado Analítico</th>
                            <th class="text-end">Rótulo Metrológico</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="mono fw-bold text-primary">MUE-2026-001</td>
                            <td>Aceite de Soya Virgen</td>
                            <td class="mono">SOY-2026-A</td>
                            <td><span class="badge bg-light text-dark border">Refrigeración (4°C, Oscuridad)</span></td>
                            <td class="mono small">2026-10-16</td>
                            <td><span class="badge bg-success mono">EN PROCESO</span></td>
                            <td class="text-end">
                                <button class="btn btn-outline-dark btn-sm mono" onclick="abrirRotulo('MUE-2026-001', 'Aceite de Soya Virgen', 'SOY-2026-A', 'Refrigerado 4°C')">
                                    <i class="bi bi-upc-scan me-1"></i> Imprimir Rótulo
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td class="mono fw-bold text-primary">MUE-2026-002</td>
                            <td>Aceite de Girasol Alto Oleico</td>
                            <td class="mono">GIR-OLEO-994</td>
                            <td><span class="badge bg-light text-dark border">Ambiente Controlado (20°C)</span></td>
                            <td class="mono small">2026-10-17</td>
                            <td><span class="badge bg-warning text-dark mono">RECEPCIONADO</span></td>
                            <td class="text-end">
                                <button class="btn btn-outline-dark btn-sm mono" onclick="abrirRotulo('MUE-2026-002', 'Girasol Alto Oleico', 'GIR-OLEO-994', 'Ambiente 20°C')">
                                    <i class="bi bi-upc-scan me-1"></i> Imprimir Rótulo
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td class="mono fw-bold text-primary">MUE-2026-003</td>
                            <td>Manteca de Palma Fraccionada</td>
                            <td class="mono">PLM-FRAC-551</td>
                            <td><span class="badge bg-light text-dark border">Congelación (-18°C)</span></td>
                            <td class="mono small">2026-10-18</td>
                            <td><span class="badge bg-info text-dark mono">ASIGNADO</span></td>
                            <td class="text-end">
                                <button class="btn btn-outline-dark btn-sm mono" onclick="abrirRotulo('MUE-2026-003', 'Palma Fraccionada', 'PLM-FRAC-551', 'Congelado -18°C')">
                                    <i class="bi bi-upc-scan me-1"></i> Imprimir Rótulo
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal para Rótulo Adhesivo Térmico -->
    <div class="modal fade" id="modalRotulo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title fw-bold"><i class="bi bi-tag-fill text-primary me-2"></i>Rótulo Metrológico de Muestra</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-4" id="printableLabelArea">
                    <div class="sample-label text-start">
                        <div class="d-flex justify-content-between align-items-center border-bottom pb-1 mb-2">
                            <strong class="mono text-dark" style="font-size: 0.75rem;">RANCILAB LIMS ISO 17025</strong>
                            <span class="badge bg-dark mono" style="font-size: 0.60rem;">GLP CUSTODIA</span>
                        </div>
                        <div class="text-center my-2">
                            <svg id="barcodeModal"></svg>
                        </div>
                        <div class="mono small" style="font-size: 0.75rem; line-height: 1.35;">
                            <div><strong>Muestra:</strong> <span id="lblMuestra">--</span></div>
                            <div><strong>Lote:</strong> <span id="lblLote">--</span></div>
                            <div><strong>Condición:</strong> <span id="lblCondicion">--</span></div>
                            <div><strong>Ingreso:</strong> 18/10/2026 &bull; <strong>Analista:</strong> <%= usuario %></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-success btn-sm fw-bold" onclick="window.print()">
                        <i class="bi bi-printer me-1"></i> Imprimir Etiqueta
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var modalRotulo;
        document.addEventListener("DOMContentLoaded", function () {
            modalRotulo = new bootstrap.Modal(document.getElementById('modalRotulo'));
        });

        function abrirRotulo(codigo, matriz, lote, condicion) {
            document.getElementById('lblMuestra').innerText = matriz;
            document.getElementById('lblLote').innerText = lote;
            document.getElementById('lblCondicion').innerText = condicion;

            JsBarcode("#barcodeModal", codigo, {
                format: "CODE128",
                width: 1.6,
                height: 38,
                fontSize: 12,
                displayValue: true
            });

            modalRotulo.show();
        }
    </script>
</body>
</html>
