package repositorio;

import java.util.List;
import modelo.Usuario;

public interface UsuarioRepository {
    boolean registrar(Usuario usuario);
    List<Usuario> listarTodos();
    Usuario buscarPorId(int id);
    Usuario buscarPorUsername(String username);
    boolean actualizar(Usuario usuario);
    boolean cambiarEstado(int id, String nuevoEstado);
    boolean reiniciarIntentos(int id);
    boolean eliminar(int id);
}