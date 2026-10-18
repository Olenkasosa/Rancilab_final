package repositorio;

import config.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Solicitud;
import modelo.SolicitudDetalle;

public class SolicitudRepositoryImpl implements SolicitudRepository {

    @Override
    public boolean registrarTransaccional(Solicitud s) {
        String sqlCabecera = "INSERT INTO solicitudes (codigo_solped, id_cliente, id_analista, tipo_comprobante, subtotal, igv, total, estado) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
        String sqlDetalle = "INSERT INTO solicitud_detalles (id_solicitud, codigo_muestra, tipo_ensayo, cantidad, precio_unitario, subtotal_linea) "
                          + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection con = null;
        try {
            con = ConexionBD.getInstance().getConexion();
            con.setAutoCommit(false); // INICIO TRANSACCIÓN ACID

            int idGenerado = 0;
            try (PreparedStatement psCab = con.prepareStatement(sqlCabecera)) {
                psCab.setString(1, s.getCodigoSolped());
                psCab.setInt(2, s.getIdCliente());
                psCab.setInt(3, s.getIdAnalista());
                psCab.setString(4, s.getTipoComprobante());
                psCab.setDouble(5, s.getSubtotal());
                psCab.setDouble(6, s.getIgv());
                psCab.setDouble(7, s.getTotal());
                psCab.setString(8, s.getEstado() != null ? s.getEstado() : "EMITIDO");

                try (ResultSet rs = psCab.executeQuery()) {
                    if (rs.next()) {
                        idGenerado = rs.getInt(1);
                    }
                }
            }

            if (idGenerado > 0 && s.getDetalles() != null) {
                try (PreparedStatement psDet = con.prepareStatement(sqlDetalle)) {
                    for (SolicitudDetalle det : s.getDetalles()) {
                        psDet.setInt(1, idGenerado);
                        psDet.setString(2, det.getCodigoMuestra());
                        psDet.setString(3, det.getTipoEnsayo());
                        psDet.setInt(4, det.getCantidad());
                        psDet.setDouble(5, det.getPrecioUnitario());
                        psDet.setDouble(6, det.getSubtotalLinea());
                        psDet.addBatch();
                    }
                    psDet.executeBatch();
                }
            }

            con.commit(); // CONFIRMACIÓN DE LA TRANSACCIÓN
            con.setAutoCommit(true);
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); // DESHACER EN CASO DE ERROR
                    con.setAutoCommit(true);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Solicitud> listarCabeceras() {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.id, s.codigo_solped, s.tipo_comprobante, s.fecha_emision, s.subtotal, s.igv, s.total, s.estado, "
                   + "c.razon_social AS cliente_nombre, u.nombre_completo AS analista_nombre "
                   + "FROM solicitudes s "
                   + "JOIN clientes c ON s.id_cliente = c.id "
                   + "JOIN usuarios u ON s.id_analista = u.id "
                   + "ORDER BY s.id DESC";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Solicitud s = new Solicitud();
                s.setId(rs.getInt("id"));
                s.setCodigoSolped(rs.getString("codigo_solped"));
                s.setTipoComprobante(rs.getString("tipo_comprobante"));
                s.setFechaEmision(rs.getString("fecha_emision"));
                s.setSubtotal(rs.getDouble("subtotal"));
                s.setIgv(rs.getDouble("igv"));
                s.setTotal(rs.getDouble("total"));
                s.setEstado(rs.getString("estado"));
                s.setNombreCliente(rs.getString("cliente_nombre"));
                s.setNombreAnalista(rs.getString("analista_nombre"));
                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public Solicitud obtenerPorIdConDetalles(int id) {
        Solicitud s = null;
        String sqlCab = "SELECT s.*, c.razon_social AS cliente_nombre, u.nombre_completo AS analista_nombre "
                      + "FROM solicitudes s "
                      + "JOIN clientes c ON s.id_cliente = c.id "
                      + "JOIN usuarios u ON s.id_analista = u.id WHERE s.id = ?";
        String sqlDet = "SELECT * FROM solicitud_detalles WHERE id_solicitud = ?";

        try (Connection con = ConexionBD.getInstance().getConexion()) {
            try (PreparedStatement psCab = con.prepareStatement(sqlCab)) {
                psCab.setInt(1, id);
                try (ResultSet rs = psCab.executeQuery()) {
                    if (rs.next()) {
                        s = new Solicitud();
                        s.setId(rs.getInt("id"));
                        s.setCodigoSolped(rs.getString("codigo_solped"));
                        s.setTipoComprobante(rs.getString("tipo_comprobante"));
                        s.setFechaEmision(rs.getString("fecha_emision"));
                        s.setSubtotal(rs.getDouble("subtotal"));
                        s.setIgv(rs.getDouble("igv"));
                        s.setTotal(rs.getDouble("total"));
                        s.setEstado(rs.getString("estado"));
                        s.setNombreCliente(rs.getString("cliente_nombre"));
                        s.setNombreAnalista(rs.getString("analista_nombre"));
                    }
                }
            }

            if (s != null) {
                try (PreparedStatement psDet = con.prepareStatement(sqlDet)) {
                    psDet.setInt(1, id);
                    try (ResultSet rsDet = psDet.executeQuery()) {
                        while (rsDet.next()) {
                            SolicitudDetalle d = new SolicitudDetalle();
                            d.setId(rsDet.getInt("id"));
                            d.setIdSolicitud(rsDet.getInt("id_solicitud"));
                            d.setCodigoMuestra(rsDet.getString("codigo_muestra"));
                            d.setTipoEnsayo(rsDet.getString("tipo_ensayo"));
                            d.setCantidad(rsDet.getInt("cantidad"));
                            d.setPrecioUnitario(rsDet.getDouble("precio_unitario"));
                            d.setSubtotalLinea(rsDet.getDouble("subtotal_linea"));
                            s.getDetalles().add(d);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return s;
    }

    @Override
    public boolean cambiarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE solicitudes SET estado = ? WHERE id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
