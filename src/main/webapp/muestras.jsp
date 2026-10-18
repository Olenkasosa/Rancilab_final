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
    <title>RanciLab - Trazabilidad de Muestras</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-purple: #7e22ce;
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
            white-space: nowrap;
        }
        .table-custom tbody td {
            padding: 14px 16px;
            vertical-align: middle;
            font-size: 0.85rem;
            white-space: nowrap;
        }
        .btn-purple {
            background-color: var(--primary-purple);
            color: #ffffff;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-purple:hover {
            background-color: #6b21a8;
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
    <div class="container-fluid px-4 my-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1">Trazabilidad & Custodia de Muestras</h3>
                <p class="text-muted small mb-0">Recepción, identificación de lotes de aceites/grasas y condiciones de almacenamiento (GLP / ISO 17025).</p>
            </div>
            <button class="btn btn-purple" onclick="alert('Formulario de recepción rápida listo.');">
                <i class="bi bi-plus-circle me-1"></i> Ingreso de Muestra
            </button>
        </div>

        <div class="card card-custom p-3">
            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle mb-0 w-100">
                    <thead>
                        <tr>
                            <th>Código Muestra</th>
                            <th>Matriz Lipídica</th>
                            <th>Lote del Fabricante</th>
                            <th>Condición de Almacenamiento</th>
                            <th>Fecha Recepción</th>
                            <th>Cadena Custodia</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="font-monospace fw-bold text-primary">MUE-2026-001</td>
                            <td>Aceite de Soya Virgen</td>
                            <td>LOTE-SOYA-2026-A</td>
                            <td>Refrigerado (4°C, Oscuridad)</td>
                            <td>2026-10-15</td>
                            <td><span class="badge bg-light text-dark border">En Custodia Analítica</span></td>
                            <td><span class="badge bg-success">EN PROCESO</span></td>
                        </tr>
                        <tr>
                            <td class="font-monospace fw-bold text-primary">MUE-2026-002</td>
                            <td>Aceite de Girasol Alto Oleico</td>
                            <td>GIR-OLEO-994</td>
                            <td>Ambiente Controlado (20°C)</td>
                            <td>2026-10-16</td>
                            <td><span class="badge bg-light text-dark border">Ingreso por Ventanilla</span></td>
                            <td><span class="badge bg-info text-dark">PENDIENTE</span></td>
                        </tr>
                        <tr>
                            <td class="font-monospace fw-bold text-primary">MUE-2026-003</td>
                            <td>Manteca de Palma Fraccionada</td>
                            <td>PLM-FRAC-551</td>
                            <td>Congelación (-18°C)</td>
                            <td>2026-10-17</td>
                            <td><span class="badge bg-light text-dark border">Validación Inicial</span></td>
                            <td><span class="badge bg-secondary">RECEPCIONADO</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
