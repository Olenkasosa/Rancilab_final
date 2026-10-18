<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%
    HttpSession sesion = request.getSession(false);
    Usuario user = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>RanciLab LIMS - Panel Central</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="#">RanciLab LIMS</a>
        <div class="ms-auto text-white">
            <span>Analista: <strong><%= user.getUsername() %></strong> (<%= user.getRol() %>)</span>
            <a href="login.jsp" class="btn btn-sm btn-outline-danger ms-3">Cerrar Sesión</a>
        </div>
    </nav>
    <div class="container mt-4">
        <h2>Menú Central del Sistema</h2>
        <p class="text-muted">Selecciona un módulo operativo para gestionar la información analítica y administrativa.</p>
        <!-- Aquí van las 6 tarjetas de tu Menú Central -->
    </div>
</body>
</html>