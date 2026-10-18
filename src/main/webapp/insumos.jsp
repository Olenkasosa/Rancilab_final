<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.ReactivoInsumo"%>
<%@page import="modelo.Proveedor"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<ReactivoInsumo> listaInsumos = (List<ReactivoInsumo>) request.getAttribute("listaInsumos");
    List<Proveedor> listaProveedores = (List<Proveedor>) request.getAttribute("listaProveedores");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Control de Reactivos e Insumos</title>
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
        .badge-optimo { background-color: #dcfce7; color: #15803d; font-weight: 700; }
        .badge-alerta { background-color: #fee2e2; color: #b91c1c; font-weight: 700; }
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
                <h3 class="fw-bold mb-1">Inventario de Reactivos e Insumos Analíticos</h3>
                <p class="text-muted small mb-0">Control de stock de solventes, patrones químicos y grado de pureza (Patrón Repository - Etapa 5).</p>
            </div>
            <button class="btn btn-teal" data-bs-toggle="modal" data-bs-target="#modalNuevoInsumo">
                <i class="bi bi-plus-circle me-1"></i> Registrar Insumo
            </button>
        </div>

        <div class="card card-custom p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Nombre del Reactivo</th>
                            <th>Grado / Pureza</th>
                            <th>Stock Disponible</th>
                            <th>Stock Mínimo</th>
                            <th>Proveedor</th>
                            <th>Vencimiento</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaInsumos != null && !listaInsumos.isEmpty()) { 
                            for (ReactivoInsumo r : listaInsumos) { 
                                boolean stockBajo = r.getStockActual() <= r.getStockMinimo();
                        %>
                                <tr>
                                    <td class="font-monospace"><strong><%= r.getCodigo() %></strong></td>
                                    <td><%= r.getNombre() %></td>
                                    <td><span class="badge bg-light text-secondary border"><%= r.getPurezaGrado() %></span></td>
                                    <td class="fw-bold <%= stockBajo ? "text-danger" : "text-success" %>">
                                        <%= String.format("%.2f", r.getStockActual()) %> <%= r.getUnidadMedida() %>
                                    </td>
                                    <td class="text-muted"><%= String.format("%.2f", r.getStockMinimo()) %> <%= r.getUnidadMedida() %></td>
                                    <td><%= r.getNombreProveedor() %></td>
                                    <td class="font-monospace text-muted"><%= r.getFechaVencimiento() %></td>
                                    <td>
                                        <% if (stockBajo) { %>
                                            <span class="badge badge-alerta p-2">STOCK CRÍTICO</span>
                                        <% } else { %>
                                            <span class="badge badge-optimo p-2">DISPONIBLE</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <a href="InsumoServlet?accion=eliminar&id=<%= r.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Confirma eliminar este insumo?');" title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">No hay reactivos registrados.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Registrar Insumo -->
    <div class="modal fade" id="modalNuevoInsumo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="InsumoServlet" method="POST">
                    <input type="hidden" name="accion" value="guardar">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-flask"></i> Registrar Insumo / Reactivo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label small fw-bold">Código:</label>
                                <input type="text" name="codigo" class="form-control" placeholder="ej. REA-ISO-04" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label small fw-bold">Grado / Pureza:</label>
                                <input type="text" name="purezaGrado" class="form-control" placeholder="ej. ACS Grade / ≥99%" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Nombre del Reactivo:</label>
                            <input type="text" name="nombre" class="form-control" placeholder="ej. Isooctano grado espectrofotométrico" required>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label small fw-bold">Stock Actual:</label>
                                <input type="number" step="0.01" name="stockActual" class="form-control" placeholder="1000" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label small fw-bold">Stock Mínimo:</label>
                                <input type="number" step="0.01" name="stockMinimo" class="form-control" placeholder="250" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label small fw-bold">Unidad:</label>
                                <select name="unidadMedida" class="form-select">
                                    <option value="mL">mL</option>
                                    <option value="L">L</option>
                                    <option value="g">g</option>
                                    <option value="kg">kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Proveedor:</label>
                            <select name="idProveedor" class="form-select" required>
                                <% if (listaProveedores != null) {
                                    for (Proveedor p : listaProveedores) { %>
                                        <option value="<%= p.getId() %>"><%= p.getRazonSocial() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Fecha de Vencimiento:</label>
                            <input type="date" name="fechaVencimiento" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-teal">Guardar Insumo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>