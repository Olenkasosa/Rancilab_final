<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Proveedor"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Proveedor> listaProveedores = (List<Proveedor>) request.getAttribute("listaProveedores");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Gestión de Proveedores</title>
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
        .badge-activo { background-color: #dcfce7; color: #15803d; font-weight: 700; }
        .badge-inactivo { background-color: #f1f5f9; color: #64748b; font-weight: 700; }
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
                <h3 class="fw-bold mb-1">Proveedores de Reactivos y Equipos</h3>
                <p class="text-muted small mb-0">Gestión de distribuidores de estándares analíticos, solventes y calibración (Patrón Repository - Etapa 5).</p>
            </div>
            <button class="btn btn-teal" data-bs-toggle="modal" data-bs-target="#modalNuevoProveedor">
                <i class="bi bi-truck me-1"></i> Registrar Proveedor
            </button>
        </div>

        <div class="card card-custom p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>RUC</th>
                            <th>Razón Social</th>
                            <th>Categoría / Rubro</th>
                            <th>Contacto</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaProveedores != null && !listaProveedores.isEmpty()) { 
                            for (Proveedor p : listaProveedores) { %>
                                <tr>
                                    <td class="font-monospace text-muted">#<%= p.getId() %></td>
                                    <td class="font-monospace"><strong><%= p.getRuc() %></strong></td>
                                    <td><%= p.getRazonSocial() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= p.getCategoria() %></span></td>
                                    <td><%= p.getContacto() %></td>
                                    <td><%= p.getTelefono() %></td>
                                    <td><%= p.getEmail() %></td>
                                    <td>
                                        <% if ("ACTIVO".equalsIgnoreCase(p.getEstado())) { %>
                                            <span class="badge badge-activo p-2">ACTIVO</span>
                                        <% } else { %>
                                            <span class="badge badge-inactivo p-2"><%= p.getEstado() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("ACTIVO".equalsIgnoreCase(p.getEstado())) { %>
                                            <a href="ProveedorServlet?accion=cambiarEstado&id=<%= p.getId() %>&estado=INACTIVO" class="btn btn-sm btn-outline-secondary" title="Inactivar">
                                                <i class="bi bi-pause-circle"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="ProveedorServlet?accion=cambiarEstado&id=<%= p.getId() %>&estado=ACTIVO" class="btn btn-sm btn-outline-success" title="Activar">
                                                <i class="bi bi-play-circle"></i>
                                            </a>
                                        <% } %>

                                        <a href="ProveedorServlet?accion=eliminar&id=<%= p.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Confirma eliminar este proveedor?');" title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">No hay proveedores registrados.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Registrar Proveedor -->
    <div class="modal fade" id="modalNuevoProveedor" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="ProveedorServlet" method="POST">
                    <input type="hidden" name="accion" value="guardar">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-truck"></i> Registrar Proveedor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">RUC del Proveedor:</label>
                            <input type="text" name="ruc" class="form-control" placeholder="ej. 20100458712" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Razón Social:</label>
                            <input type="text" name="razonSocial" class="form-control" placeholder="ej. Merck Peruana S.A." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Categoría / Suministro:</label>
                            <select name="categoria" class="form-select">
                                <option value="Reactivos Químicos">Reactivos Químicos</option>
                                <option value="Equipos y Sensores">Equipos y Sensores</option>
                                <option value="Cristalería y Consumibles">Cristalería y Consumibles</option>
                                <option value="Servicios de Calibración">Servicios de Calibración</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Contacto Comercial:</label>
                            <input type="text" name="contacto" class="form-control" placeholder="ej. Carlos Méndez">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Teléfono:</label>
                            <input type="text" name="telefono" class="form-control" placeholder="01-4458900">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Correo Electrónico:</label>
                            <input type="email" name="email" class="form-control" placeholder="ventas@proveedor.pe">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-teal">Guardar Proveedor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>