package repositorio;

import config.ConexionBD;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Proveedor;

public class ProveedorRepositoryImpl implements ProveedorRepository {

    @Override
    public boolean registrar(Proveedor p) {
        String sql = "INSERT INTO proveedores (ruc, razon_social, categoria, contacto, telefono, email, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getRuc() != null ? p.getRuc().trim() : "");
            ps.setString(2, p.getRazonSocial() != null ? p.getRazonSocial().trim() : "");
            ps.setString(3, p.getCategoria());
            ps.setString(4, p.getContacto());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEstado() != null ? p.getEstado() : "ACTIVO");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Proveedor> listarTodos() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM proveedores ORDER BY id ASC";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setId(rs.getInt("id"));
                p.setRuc(rs.getString("ruc"));
                p.setRazonSocial(rs.getString("razon_social"));
                p.setCategoria(rs.getString("categoria"));
                p.setContacto(rs.getString("contacto"));
                p.setTelefono(rs.getString("telefono"));
                p.setEmail(rs.getString("email"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public Proveedor buscarPorId(int id) {
        String sql = "SELECT * FROM proveedores WHERE id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Proveedor p = new Proveedor();
                    p.setId(rs.getInt("id"));
                    p.setRuc(rs.getString("ruc"));
                    p.setRazonSocial(rs.getString("razon_social"));
                    p.setCategoria(rs.getString("categoria"));
                    p.setContacto(rs.getString("contacto"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setEmail(rs.getString("email"));
                    p.setEstado(rs.getString("estado"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean actualizar(Proveedor p) {
        String sql = "UPDATE proveedores SET ruc = ?, razon_social = ?, categoria = ?, contacto = ?, telefono = ?, email = ?, estado = ? WHERE id = ?";
        try (Connection con = ConexionBD.getInstance().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getRuc() != null ? p.getRuc().trim() : "");
            ps.setString(2, p.getRazonSocial() != null ? p.getRazonSocial().trim() : "");
            ps.setString(3, p.getCategoria());
            ps.setString(4, p.getContacto());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEstado());
            ps.setInt(8, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cambiarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE proveedores SET estado = ? WHERE id = ?";
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

    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM proveedores WHERE id = ?";
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