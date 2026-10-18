<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Usuario"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Gestión de Usuarios y Analistas</title>
    <!-- Fonts & Bootstrap 5 -->
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
        .badge-bloqueado { background-color: #fee2e2; color: #b91c1c; font-weight: 700; }
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
                <h3 class="fw-bold mb-1">Gestión de Usuarios y Analistas</h3>
                <p class="text-muted small mb-0">Control de acceso basado en roles, estados y desbloqueo de operadores (Patrón Repository).</p>
            </div>
            <button class="btn btn-teal" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario">
                <i class="bi bi-person-plus-fill me-1"></i> Registrar Operador
            </button>
        </div>

        <div class="card card-custom p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Usuario / Código</th>
                            <th>Nombre Completo</th>
                            <th>Rol / Perfil</th>
                            <th>Estado</th>
                            <th>Intentos Fallidos</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) { 
                            for (Usuario u : listaUsuarios) { %>
                                <tr>
                                    <td class="font-monospace text-muted">#<%= u.getId() %></td>
                                    <td><strong><%= u.getUsername() %></strong></td>
                                    <td><%= u.getNombreCompleto() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= u.getRol() %></span></td>
                                    <td>
                                        <% if ("ACTIVO".equalsIgnoreCase(u.getEstado())) { %>
                                            <span class="badge badge-activo p-2">ACTIVO</span>
                                        <% } else if ("BLOQUEADO".equalsIgnoreCase(u.getEstado())) { %>
                                            <span class="badge badge-bloqueado p-2">BLOQUEADO</span>
                                        <% } else { %>
                                            <span class="badge badge-inactivo p-2"><%= u.getEstado() %></span>
                                        <% } %>
                                    </td>
                                    <td class="font-monospace"><%= u.getIntentosFallidos() %> / 3</td>
                                    <td class="text-center">
                                        <% if ("BLOQUEADO".equalsIgnoreCase(u.getEstado()) || u.getIntentosFallidos() > 0) { %>
                                            <a href="UsuarioServlet?accion=desbloquear&id=<%= u.getId() %>" class="btn btn-sm btn-outline-warning" title="Desbloquear y reiniciar intentos">
                                                <i class="bi bi-unlock-fill"></i> Desbloquear
                                            </a>
                                        <% } %>
                                        
                                        <% if ("ACTIVO".equalsIgnoreCase(u.getEstado())) { %>
                                            <a href="UsuarioServlet?accion=cambiarEstado&id=<%= u.getId() %>&estado=INACTIVO" class="btn btn-sm btn-outline-secondary" title="Inactivar">
                                                <i class="bi bi-pause-circle"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="UsuarioServlet?accion=cambiarEstado&id=<%= u.getId() %>&estado=ACTIVO" class="btn btn-sm btn-outline-success" title="Activar">
                                                <i class="bi bi-play-circle"></i>
                                            </a>
                                        <% } %>

                                        <a href="UsuarioServlet?accion=eliminar&id=<%= u.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Confirma que desea eliminar este usuario?');" title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No hay usuarios registrados en el sistema.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Registrar Usuario -->
    <div class="modal fade" id="modalNuevoUsuario" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="UsuarioServlet" method="POST">
                    <input type="hidden" name="accion" value="guardar">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-person-plus"></i> Nuevo Analista / Operador</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Usuario (Código de Operador):</label>
                            <input type="text" name="username" class="form-control" placeholder="ej. anl_lucia" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Nombre Completo:</label>
                            <input type="text" name="nombreCompleto" class="form-control" placeholder="ej. Lucía Morales" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Rol en el Sistema:</label>
                            <select name="rol" class="form-select">
                                <option value="ANALISTA">ANALISTA</option>
                                <option value="ADMIN">ADMINISTRADOR</option>
                                <option value="SUPERVISOR">SUPERVISOR DE CALIDAD</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Contraseña Inicial:</label>
                            <input type="password" name="clave" class="form-control" placeholder="••••••••" required>
                            <small class="text-muted">Se almacenará encriptada con SHA-256 en la base de datos.</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-teal">Guardar Operador</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
