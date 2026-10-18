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
    <title>RanciLab - Auditoría Forense & 21 CFR Part 11</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --slate-900: #0f172a;
            --teal-600: #0d9488;
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
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 5px;
            bottom: 5px;
            width: 2px;
            background: #cbd5e1;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 24px;
        }
        .timeline-dot {
            position: absolute;
            left: -26px;
            top: 2px;
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: var(--teal-600);
            border: 3px solid #ffffff;
            box-shadow: 0 0 0 1px #cbd5e1;
        }
        .btn-teal {
            background-color: var(--teal-600);
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
    <nav class="navbar navbar-custom navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="panel.jsp">
                <i class="bi bi-moisture text-info"></i>
                <span>RanciLab <span class="fw-light text-secondary">Security Cockpit</span></span>
            </a>
            <div class="d-flex align-items-center gap-3 text-white">
                <a href="panel.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Volver al Menú</a>
                <span class="small text-secondary">Analista: <strong class="mono text-white"><%= usuario %></strong></span>
            </div>
        </div>
    </nav>

    <!-- Contenido -->
    <div class="container my-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h3 class="fw-bold mb-0">Seguridad, Auditoría Forense & Respaldo</h3>
                    <span class="badge bg-dark border border-secondary text-info mono">21 CFR PART 11</span>
                </div>
                <p class="text-muted small mb-0">Registro inmutable de trazabilidad de accesos, modificaciones de datos y resguardo de la base de datos.</p>
            </div>
            <a href="AuditoriaServlet?accion=respaldo" class="btn btn-teal">
                <i class="bi bi-database-down me-1"></i> Descargar Respaldo SQL (Dump)
            </a>
        </div>

        <div class="row g-4">
            <!-- Timeline de Trazabilidad -->
            <div class="col-lg-7">
                <div class="card card-enterprise p-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-clock-history text-teal me-2" style="color:#0d9488;"></i>Línea de Tiempo de Eventos Críticos</h6>
                    <div class="timeline mt-3">
                        <% if (logs != null && !logs.isEmpty()) {
                            for (Map<String, Object> log : logs) { %>
                                <div class="timeline-item">
                                    <div class="timeline-dot"></div>
                                    <div class="d-flex justify-content-between align-items-start">
                                        <strong class="text-dark small"><%= log.get("accion") %></strong>
                                        <span class="mono text-muted" style="font-size: 0.68rem;"><%= log.get("fecha") %></span>
                                    </div>
                                    <div class="small text-muted mt-1">
                                        Operador: <strong class="mono text-primary"><%= log.get("usuario") %></strong> &bull;
                                        Módulo: <span class="badge bg-light text-secondary border mono"><%= log.get("modulo") %></span> &bull;
                                        IP: <span class="mono"><%= log.get("ip") %></span>
                                    </div>
                                </div>
                        <%  }
                        } else { %>
                            <p class="text-muted small py-3">Sin eventos registrados recientemente.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Políticas de Certificación -->
            <div class="col-lg-5">
                <div class="card card-enterprise p-4 mb-4">
                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-shield-lock-fill text-primary me-2"></i>Trazabilidad FDA 21 CFR Part 11</h6>
                    <ul class="small text-muted ps-3 mb-0" style="line-height: 1.6;">
                        <li>Firma electrónica individualizada de cada analista.</li>
                        <li>Pistas de auditoría (Audit Trails) generadas de forma automática e inalterable.</li>
                        <li>Cifrado irreversible de credenciales mediante algoritmos SHA-256.</li>
                        <li>Bloqueo automático tras 3 intentos no reconocidos.</li>
                    </ul>
                </div>
                <div class="card card-enterprise p-4">
                    <h6 class="fw-bold text-dark mb-2"><i class="bi bi-hdd-network-fill text-success me-2"></i>Políticas de Respaldo LIMS</h6>
                    <p class="small text-muted mb-3" style="line-height: 1.5;">
                        Los datos se persisten en volúmenes dedicados en Railway con volcados de seguridad automáticos diarios y exportación lógica descargable bajo demanda.
                    </p>
                    <a href="AuditoriaServlet?accion=respaldo" class="btn btn-outline-dark btn-sm w-100 mono">
                        <i class="bi bi-download me-1"></i> Generar Script de Recuperación (.sql)
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>