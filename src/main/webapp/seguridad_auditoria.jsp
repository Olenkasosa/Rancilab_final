<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, Object>> logs = (List<Map<String, Object>>) request.getAttribute("listaAuditoria");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Seguridad, Auditoría y Respaldos</title>
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
        
        <!-- Fila de Cabecera con Botón de Respaldo (Módulo 10) -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">Módulos 9 y 10: Seguridad, Auditoría & Respaldos</h3>
                <p class="text-muted small mb-0">Trazabilidad de operaciones críticas, accesos del sistema y descarga de copias de seguridad.</p>
            </div>
            <a href="AuditoriaServlet?accion=respaldo" class="btn btn-teal">
                <i class="bi bi-cloud-arrow-down-fill me-1"></i> Generar Respaldo SQL (Dump)
            </a>
        </div>

        <!-- Tarjetas de Políticas de Seguridad y Disaster Recovery -->
        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card card-custom p-3">
                    <h6 class="fw-bold text-dark"><i class="bi bi-shield-lock-fill text-primary me-2"></i>Módulo 9: Políticas de Seguridad</h6>
                    <ul class="small text-muted mb-0 ps-3">
                        <li>Cifrado irreversible de credenciales mediante función hash <strong>SHA-256</strong>.</li>
                        <li>Bloqueo preventivo de analistas tras <strong>3 intentos erróneos</strong>.</li>
                        <li>Registro de sesiones y validación de tokens de usuario mediante <code>HttpSession</code>.</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card card-custom p-3">
                    <h6 class="fw-bold text-dark"><i class="bi bi-database-check text-success me-2"></i>Módulo 10: Integridad y Recuperación</h6>
                    <ul class="small text-muted mb-0 ps-3">
                        <li>Almacenamiento persistente en volumen Docker gestionado por Railway.</li>
                        <li>Snapshots automatizados diarios a nivel de motor PostgreSQL.</li>
                        <li>Exportación lógica bajo demanda en formato SQL estándar para migración.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Tabla de Trazabilidad y Auditoría -->
        <div class="card card-custom p-3">
            <div class="d-flex justify-content-between align-items-center p-2 mb-2">
                <h6 class="fw-bold mb-0"><i class="bi bi-journal-text me-2"></i>Registro de Actividades y Trazabilidad (Últimos Eventos)</h6>
                <span class="badge bg-light text-dark border">Auditoría en tiempo real</span>
            </div>
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Usuario / Operador</th>
                            <th>Módulo</th>
                            <th>Acción Ejecutada</th>
                            <th>Dirección IP</th>
                            <th>Fecha y Hora</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (logs != null && !logs.isEmpty()) {
                            for (Map<String, Object> log : logs) { %>
                                <tr>
                                    <td class="font-monospace text-muted">#<%= log.get("id") %></td>
                                    <td><strong><%= log.get("usuario") %></strong></td>
                                    <td><span class="badge bg-light text-primary border"><%= log.get("modulo") %></span></td>
                                    <td><%= log.get("accion") %></td>
                                    <td class="font-monospace small"><%= log.get("ip") %></td>
                                    <td class="small text-muted"><%= log.get("fecha") %></td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">Sin registros de auditoría recientes.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>