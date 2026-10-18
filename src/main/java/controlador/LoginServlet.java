package controlador;

import config.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Usuario;
import util.HashUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("usuario");
        String pass = request.getParameter("clave");

        if (user == null || pass == null || user.trim().isEmpty() || pass.trim().isEmpty()) {
            request.setAttribute("error", "Por favor, complete todos los campos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        user = user.trim();
        pass = pass.trim();
        String passCifrada = HashUtil.encriptarSHA256(pass);

        try {
            Connection con = ConexionBD.getInstance().getConexion();
            if (con == null) {
                request.setAttribute("error", "Error: No se pudo conectar a la base de datos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Consultar datos del usuario
            String sqlCheck = "SELECT * FROM usuarios WHERE LOWER(TRIM(username)) = LOWER(?)";
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setString(1, user);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        String estado = rs.getString("estado");
                        int intentos = rs.getInt("intentos_fallidos");

                        // Verificar si está bloqueado
                        if ("BLOQUEADO".equalsIgnoreCase(estado)) {
                            request.setAttribute("error", "Usuario bloqueado por superar 3 intentos erróneos. Contacte al administrador.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                            return;
                        }

                        String passwordDB = rs.getString("password_hash");
                        if (passwordDB != null) {
                            passwordDB = passwordDB.trim();
                        }

                        // Validar credenciales: acepta hash SHA-256 o texto plano directo
                        boolean coincide = (passwordDB != null) && 
                                           (passwordDB.equals(passCifrada) || passwordDB.equals(pass));

                        if (coincide) {
                            // Éxito: restablecer intentos fallidos a 0
                            String sqlReset = "UPDATE usuarios SET intentos_fallidos = 0, estado = 'ACTIVO' WHERE LOWER(TRIM(username)) = LOWER(?)";
                            try (PreparedStatement psReset = con.prepareStatement(sqlReset)) {
                                psReset.setString(1, user);
                                psReset.executeUpdate();
                            }

                            // Crear objeto de usuario
                            Usuario usuarioSesion = new Usuario();
                            usuarioSesion.setId(rs.getInt("id"));
                            usuarioSesion.setUsername(rs.getString("username"));
                            usuarioSesion.setNombreCompleto(rs.getString("nombre_completo"));
                            usuarioSesion.setRol(rs.getString("rol"));

                            // Iniciar sesión y guardar atributos indispensables
                            HttpSession session = request.getSession();
                            session.setAttribute("usuarioLogueado", usuarioSesion);
                            session.setAttribute("usuario", usuarioSesion.getUsername());
                            session.setAttribute("rol", usuarioSesion.getRol());

                            // Redireccionar al panel central
                            response.sendRedirect("panel.jsp");
                        } else {
                            // Contraseña incorrecta: incrementar contador de intentos
                            intentos++;
                            if (intentos >= 3) {
                                String sqlBloquear = "UPDATE usuarios SET intentos_fallidos = ?, estado = 'BLOQUEADO' WHERE LOWER(TRIM(username)) = LOWER(?)";
                                try (PreparedStatement psBloquear = con.prepareStatement(sqlBloquear)) {
                                    psBloquear.setInt(1, intentos);
                                    psBloquear.setString(2, user);
                                    psBloquear.executeUpdate();
                                }
                                request.setAttribute("error", "Ha superado los 3 intentos. El usuario ha sido BLOQUEADO.");
                            } else {
                                String sqlIntento = "UPDATE usuarios SET intentos_fallidos = ? WHERE LOWER(TRIM(username)) = LOWER(?)";
                                try (PreparedStatement psIntento = con.prepareStatement(sqlIntento)) {
                                    psIntento.setInt(1, intentos);
                                    psIntento.setString(2, user);
                                    psIntento.executeUpdate();
                                }
                                request.setAttribute("error", "Contraseña incorrecta. Intento " + intentos + " de 3.");
                            }
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("error", "El usuario ingresado no existe.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Excepción SQL: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}