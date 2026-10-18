<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Solicitud"%>
<%@page import="modelo.Cliente"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Solicitud> listaSolicitudes = (List<Solicitud>) request.getAttribute("listaSolicitudes");
    List<Cliente> listaClientes = (List<Cliente>) request.getAttribute("listaClientes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Proceso de Ventas & SOLPED</title>
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
        .table-custom thead th {
            background-color: #f1f5f9;
            color: #475569;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
            padding: 12px 16px;
        }
        .table-custom tbody td {
            padding: 14px 16px;
            vertical-align: middle;
            font-size: 0.85rem;
        }
        .badge-facturado { background-color: #dcfce7; color: #15803d; font-weight: 700; }
        .badge-emitido { background-color: #e0f2fe; color: #0369a1; font-weight: 700; }
        .badge-anulado { background-color: #fee2e2; color: #b91c1c; font-weight: 700; }
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
    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Módulo de Ventas & SOLPED de Ensayos</h3>
                <p class="text-muted small mb-0">Gestión transaccional Cabecera-Detalle: Solicitud $\rightarrow$ Factura / Boleta (Etapa 6).</p>
            </div>
            <button class="btn btn-teal" data-bs-toggle="modal" data-bs-target="#modalNuevaVenta">
                <i class="bi bi-receipt me-1"></i> Generar Orden / Factura
            </button>
        </div>

        <div class="card card-custom p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Código SOLPED</th>
                            <th>Empresa / Cliente</th>
                            <th>Tipo Comprobante</th>
                            <th>Fecha</th>
                            <th>Subtotal</th>
                            <th>IGV (18%)</th>
                            <th>Total (S/.)</th>
                            <th>Estado</th>
                            <th class="text-center">Comprobante</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaSolicitudes != null && !listaSolicitudes.isEmpty()) { 
                            for (Solicitud s : listaSolicitudes) { %>
                                <tr>
                                    <td class="font-monospace"><strong><%= s.getCodigoSolped() %></strong></td>
                                    <td><%= s.getNombreCliente() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= s.getTipoComprobante() %></span></td>
                                    <td class="small text-muted"><%= s.getFechaEmision() != null ? s.getFechaEmision().substring(0, 10) : "" %></td>
                                    <td class="font-monospace">S/. <%= String.format("%.2f", s.getSubtotal()) %></td>
                                    <td class="font-monospace text-muted">S/. <%= String.format("%.2f", s.getIgv()) %></td>
                                    <td class="font-monospace fw-bold text-teal">S/. <%= String.format("%.2f", s.getTotal()) %></td>
                                    <td>
                                        <% if ("FACTURADO".equalsIgnoreCase(s.getEstado())) { %>
                                            <span class="badge badge-facturado p-2">FACTURADO</span>
                                        <% } else if ("ANULADO".equalsIgnoreCase(s.getEstado())) { %>
                                            <span class="badge badge-anulado p-2">ANULADO</span>
                                        <% } else { %>
                                            <span class="badge badge-emitido p-2"><%= s.getEstado() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <a href="SolicitudServlet?accion=ver&id=<%= s.getId() %>" class="btn btn-sm btn-outline-info" title="Ver Detalle y Desglose">
                                            <i class="bi bi-file-earmark-text"></i> Detalle
                                        </a>
                                        <% if (!"ANULADO".equalsIgnoreCase(s.getEstado())) { %>
                                            <a href="SolicitudServlet?accion=cambiarEstado&id=<%= s.getId() %>&estado=ANULADO" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Confirma anular esta orden?');" title="Anular">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">No hay órdenes de ensayo registradas.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Registrar Venta / SOLPED Dinámica -->
    <div class="modal fade" id="modalNuevaVenta" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="SolicitudServlet" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-file-earmark-plus"></i> Nueva Solicitud de Ensayos / Facturación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Cabecera -->
                        <div class="row mb-3">
                            <div class="col-md-7">
                                <label class="form-label small fw-bold">Cliente / Planta Solicitante:</label>
                                <select name="idCliente" class="form-select" required>
                                    <% if (listaClientes != null) {
                                        for (Cliente c : listaClientes) { %>
                                            <option value="<%= c.getId() %>"><%= c.getRazonSocial() %> (RUC: <%= c.getRucDni() %>)</option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label small fw-bold">Tipo de Comprobante:</label>
                                <select name="tipoComprobante" class="form-select">
                                    <option value="FACTURA">FACTURA ELECTRÓNICA</option>
                                    <option value="BOLETA">BOLETA DE VENTA</option>
                                </select>
                            </div>
                        </div>

                        <hr>
                        <h6 class="fw-bold mb-3"><i class="bi bi-list-check"></i> Ensayos Solicitados (Detalle Transaccional)</h6>

                        <!-- Detalle Línea 1 -->
                        <div class="row g-2 align-items-center mb-2">
                            <div class="col-md-4">
                                <input type="text" name="codigoMuestra[]" class="form-control form-control-sm" placeholder="Lote Muestra (ej. ACEITE-GIRASOL-01)" required>
                            </div>
                            <div class="col-md-4">
                                <select name="tipoEnsayo[]" class="form-select form-select-sm">
                                    <option value="Índice de Peróxidos (POV AOCS Cd 8b-90)">POV Peróxidos (S/. 85.00)</option>
                                    <option value="Valor p-Anisidina (ISO 3960:2017)">p-Anisidina 350nm (S/. 95.00)</option>
                                    <option value="Estabilidad Oxidativa Rancimat (AOCS Cd 12b-92)">Rancimat OSI 120°C (S/. 180.00)</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="number" name="cantidad[]" class="form-control form-control-sm" value="1" min="1" required>
                            </div>
                            <div class="col-md-2">
                                <input type="number" step="0.01" name="precioUnitario[]" class="form-control form-control-sm" value="85.00" required>
                            </div>
                        </div>

                        <!-- Detalle Línea 2 opcional -->
                        <div class="row g-2 align-items-center mb-2">
                            <div class="col-md-4">
                                <input type="text" name="codigoMuestra[]" class="form-control form-control-sm" placeholder="Segunda muestra o ensayo (opcional)">
                            </div>
                            <div class="col-md-4">
                                <select name="tipoEnsayo[]" class="form-select form-select-sm">
                                    <option value="Estabilidad Oxidativa Rancimat (AOCS Cd 12b-92)">Rancimat OSI 120°C (S/. 180.00)</option>
                                    <option value="Valor p-Anisidina (ISO 3960:2017)">p-Anisidina 350nm (S/. 95.00)</option>
                                    <option value="Índice de Peróxidos (POV AOCS Cd 8b-90)">POV Peróxidos (S/. 85.00)</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="number" name="cantidad[]" class="form-control form-control-sm" value="1" min="1">
                            </div>
                            <div class="col-md-2">
                                <input type="number" step="0.01" name="precioUnitario[]" class="form-control form-control-sm" value="180.00">
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-teal">Emitir Orden y Comprobante</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>