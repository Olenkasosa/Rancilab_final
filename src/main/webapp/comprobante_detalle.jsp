<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Solicitud"%>
<%@page import="modelo.SolicitudDetalle"%>
<%
    Solicitud s = (Solicitud) request.getAttribute("solicitud");
    if (s == null) {
        response.sendRedirect("SolicitudServlet?accion=listar");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Comprobante <%= s.getCodigoSolped() %> - RanciLab</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
    <div class="container" style="max-width: 800px;">
        <div class="card p-4 border-0 shadow-sm">
            <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-3">
                <div>
                    <h4 class="fw-bold mb-0">RanciLab LIMS S.A.C.</h4>
                    <small class="text-muted">Servicios de Ensayos Fisicoquímicos y Estabilidad Lipídica</small>
                </div>
                <div class="text-end">
                    <span class="badge bg-dark p-2 font-monospace"><%= s.getTipoComprobante() %></span>
                    <h5 class="fw-bold mt-1 text-primary"><%= s.getCodigoSolped() %></h5>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-6">
                    <p class="mb-1 small text-muted">CLIENTE / SOLICITANTE:</p>
                    <h6 class="fw-bold"><%= s.getNombreCliente() %></h6>
                    <p class="mb-0 small text-muted">Fecha: <%= s.getFechaEmision() %></p>
                </div>
                <div class="col-6 text-end">
                    <p class="mb-1 small text-muted">ANALISTA CERTIFICADO:</p>
                    <h6 class="fw-bold"><%= s.getNombreAnalista() %></h6>
                    <p class="mb-0 small text-muted">Estado: <span class="badge bg-success"><%= s.getEstado() %></span></p>
                </div>
            </div>

            <table class="table table-bordered mb-4">
                <thead class="table-light small">
                    <tr>
                        <th>Muestra Evaluada</th>
                        <th>Método / Ensayo Normado</th>
                        <th class="text-center">Cant.</th>
                        <th class="text-end">P. Unitario</th>
                        <th class="text-end">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SolicitudDetalle d : s.getDetalles()) { %>
                        <tr>
                            <td class="font-monospace small"><%= d.getCodigoMuestra() %></td>
                            <td><%= d.getTipoEnsayo() %></td>
                            <td class="text-center"><%= d.getCantidad() %></td>
                            <td class="text-end font-monospace">S/. <%= String.format("%.2f", d.getPrecioUnitario()) %></td>
                            <td class="text-end font-monospace fw-bold">S/. <%= String.format("%.2f", d.getSubtotalLinea()) %></td>
                        </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-end fw-bold">SUBTOTAL:</td>
                        <td class="text-end font-monospace">S/. <%= String.format("%.2f", s.getSubtotal()) %></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="text-end fw-bold">I.G.V. (18%):</td>
                        <td class="text-end font-monospace">S/. <%= String.format("%.2f", s.getIgv()) %></td>
                    </tr>
                    <tr class="table-light">
                        <td colspan="4" class="text-end fw-bold">TOTAL:</td>
                        <td class="text-end font-monospace fw-bold fs-5 text-primary">S/. <%= String.format("%.2f", s.getTotal()) %></td>
                    </tr>
                </tfoot>
            </table>

            <div class="d-flex justify-content-between">
                <a href="SolicitudServlet?accion=listar" class="btn btn-outline-secondary btn-sm">Volver al Listado</a>
                <button onclick="window.print();" class="btn btn-primary btn-sm">Imprimir Comprobante</button>
            </div>
        </div>
    </div>
</body>
</html>