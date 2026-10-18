<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>RanciLab - Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container" style="max-width: 420px;">
        <div class="card shadow-sm p-4">
            <h3 class="text-center mb-3">RanciLab LIMS</h3>
            <p class="text-muted text-center small mb-4">Control de Rancidez Lipídica</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger p-2 small text-center">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label small">Usuario / Analista</label>
                    <input type="text" name="usuario" class="form-control" placeholder="admin" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small">Contraseña</label>
                    <input type="password" name="clave" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Ingresar al Sistema</button>
            </form>
        </div>
    </div>
</body>
</html>
