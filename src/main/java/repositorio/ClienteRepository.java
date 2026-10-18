package repositorio;

import java.util.List;
import modelo.Cliente;

public interface ClienteRepository {
    boolean registrar(Cliente cliente);
    List<Cliente> listarTodos();
    Cliente buscarPorId(int id);
    boolean actualizar(Cliente cliente);
    boolean cambiarEstado(int id, String nuevoEstado);
    boolean eliminar(int id);
}