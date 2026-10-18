package servicio;

import config.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import modelo.Solicitud;

// Patrón de Comportamiento Observer para auditoría de ventas
public class VentaObserver {

    public static void notificarVentaGenerada(Solicitud s, String usuario) {
        String sql = "INSERT INTO auditoria (usuario, accion, modulo, ip_origen) VALUES (?, ?, ?, 'WEB-CLIENT')";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario != null ? usuario : "SISTEMA");
            ps.setString(2, "VENTA EMITIDA: " + s.getCodigoSolped() + " TOTAL: S/." + s.getTotal());
            ps.setString(3, "VENTAS");
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}