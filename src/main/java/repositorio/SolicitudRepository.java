package repositorio;

import java.util.List;
import modelo.Solicitud;

public interface SolicitudRepository {
    boolean registrarTransaccional(Solicitud solicitud);
    List<Solicitud> listarCabeceras();
    Solicitud obtenerPorIdConDetalles(int id);
    boolean cambiarEstado(int id, String nuevoEstado);
}
