package repositorio;

import java.util.List;
import modelo.Proveedor;

public interface ProveedorRepository {
    boolean registrar(Proveedor proveedor);
    List<Proveedor> listarTodos();
    Proveedor buscarPorId(int id);
    boolean actualizar(Proveedor proveedor);
    boolean cambiarEstado(int id, String nuevoEstado);
    boolean eliminar(int id);
}
