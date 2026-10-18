package repositorio;

import java.util.List;
import modelo.ReactivoInsumo;

public interface InsumoRepository {
    boolean registrar(ReactivoInsumo insumo);
    List<ReactivoInsumo> listarTodos();
    ReactivoInsumo buscarPorId(int id);
    boolean actualizarStock(int id, double nuevoStock);
    boolean eliminar(int id);
}
