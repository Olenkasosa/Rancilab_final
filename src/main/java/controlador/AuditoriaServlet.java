package controlador;

import config.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/AuditoriaServlet")
public class AuditoriaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        // Módulo 10: Generador y descarga de respaldo de datos (SQL Dump lógico)
        if ("respaldo".equals(accion)) {
            response.setContentType("application/sql");
            response.setHeader("Content-Disposition", "attachment; filename=\"backup_rancilab_" + System.currentTimeMillis() + ".sql\"");
            try (PrintWriter out = response.getWriter();
                 Connection con = ConexionBD.getInstance().getConexion()) {
                
                out.println("-- =====================================================");
                out.println("-- COPIA DE SEGURIDAD Y RESPALDO DE DATOS - RANCILAB");
                out.println("-- GENERADO AUTOMÁTICAMENTE EL: " + new java.util.Date());
                out.println("-- =====================================================\n");

                String[] tablas = {"usuarios", "clientes", "proveedores", "reactivos_insumos", "solicitudes", "solicitud_detalles", "auditoria"};
                for (String t : tablas) {
                    try (Statement st = con.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM " + t)) {
                        ResultSetMetaData md = rs.getMetaData();
                        int cols = md.getColumnCount();
                        out.println("-- Respaldo de la tabla: " + t);
                        while (rs.next()) {
                            StringBuilder sb = new StringBuilder("INSERT INTO " + t + " VALUES (");
                            for (int i = 1; i <= cols; i++) {
                                Object val = rs.getObject(i);
                                if (val == null) {
                                    sb.append("NULL");
                                } else if (val instanceof Number) {
                                    sb.append(val);
                                } else {
                                    sb.append("'").append(val.toString().replace("'", "''")).append("'");
                                }
                                if (i < cols) sb.append(", ");
                            }
                            sb.append(");\n");
                            out.print(sb.toString());
                        }
                        out.println();
                    } catch (Exception ex) {
                        out.println("-- Error respaldando " + t + ": " + ex.getMessage());
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return;
        }

        // Módulo 9: Listar historial de auditoría
        List<Map<String, Object>> logs = new ArrayList<>();
        String sql = "SELECT * FROM auditoria ORDER BY id DESC LIMIT 50";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("id", rs.getInt("id"));
                fila.put("usuario", rs.getString("usuario"));
                fila.put("accion", rs.getString("accion"));
                fila.put("modulo", rs.getString("modulo"));
                fila.put("ip", rs.getString("ip_origen"));
                fila.put("fecha", rs.getString("fecha_hora"));
                logs.add(fila);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("listaAuditoria", logs);
        request.getRequestDispatcher("seguridad_auditoria.jsp").forward(request, response);
    }
}