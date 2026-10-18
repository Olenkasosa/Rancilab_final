package repositorio;

import config.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.ReactivoInsumo;

public class InsumoRepositoryImpl implements InsumoRepository {

    @Override
    public boolean registrar(ReactivoInsumo r) {
        String sql = "INSERT INTO reactivos_insumos (codigo, nombre, pureza_grado, stock_actual, stock_minimo, unidad_medida, id_proveedor, fecha_vencimiento, estado) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, CAST(? AS DATE), ?)";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, r.getCodigo().trim());
            ps.setString(2, r.getNombre().trim());
            ps.setString(3, r.getPurezaGrado());
            ps.setDouble(4, r.getStockActual());
            ps.setDouble(5, r.getStockMinimo());
            ps.setString(6, r.getUnidadMedida());
            ps.setInt(7, r.getIdProveedor());
            ps.setString(8, r.getFechaVencimiento());
            ps.setString(9, r.getEstado() != null ? r.getEstado() : "DISPONIBLE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<ReactivoInsumo> listarTodos() {
        List<ReactivoInsumo> lista = new ArrayList<>();
        String sql = "SELECT r.id, r.codigo, r.nombre, r.pureza_grado, r.stock_actual, r.stock_minimo, "
                   + "r.unidad_medida, r.id_proveedor, p.razon_social AS proveedor_nombre, r.fecha_vencimiento, r.estado "
                   + "FROM reactivos_insumos r "
                   + "LEFT JOIN proveedores p ON r.id_proveedor = p.id "
                   + "ORDER BY r.id ASC";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReactivoInsumo r = new ReactivoInsumo();
                r.setId(rs.getInt("id"));
                r.setCodigo(rs.getString("codigo"));
                r.setNombre(rs.getString("nombre"));
                r.setPurezaGrado(rs.getString("pureza_grado"));
                r.setStockActual(rs.getDouble("stock_actual"));
                r.setStockMinimo(rs.getDouble("stock_minimo"));
                r.setUnidadMedida(rs.getString("unidad_medida"));
                r.setIdProveedor(rs.getInt("id_proveedor"));
                r.setNombreProveedor(rs.getString("proveedor_nombre") != null ? rs.getString("proveedor_nombre") : "Sin Proveedor");
                r.setFechaVencimiento(rs.getString("fecha_vencimiento"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public ReactivoInsumo buscarPorId(int id) {
        String sql = "SELECT r.*, p.razon_social AS proveedor_nombre FROM reactivos_insumos r "
                   + "LEFT JOIN proveedores p ON r.id_proveedor = p.id WHERE r.id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReactivoInsumo r = new ReactivoInsumo();
                    r.setId(rs.getInt("id"));
                    r.setCodigo(rs.getString("codigo"));
                    r.setNombre(rs.getString("nombre"));
                    r.setPurezaGrado(rs.getString("pureza_grado"));
                    r.setStockActual(rs.getDouble("stock_actual"));
                    r.setStockMinimo(rs.getDouble("stock_minimo"));
                    r.setUnidadMedida(rs.getString("unidad_medida"));
                    r.setIdProveedor(rs.getInt("id_proveedor"));
                    r.setNombreProveedor(rs.getString("proveedor_nombre"));
                    r.setFechaVencimiento(rs.getString("fecha_vencimiento"));
                    r.setEstado(rs.getString("estado"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean actualizarStock(int id, double nuevoStock) {
        String sql = "UPDATE reactivos_insumos SET stock_actual = ? WHERE id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, nuevoStock);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM reactivos_insumos WHERE id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
