package servicio;

import java.util.List;
import modelo.Cliente;
import modelo.ReactivoInsumo;
import modelo.Solicitud;
import repositorio.*;

public class ReporteFacade {
    private final SolicitudRepository solicitudRepo = new SolicitudRepositoryImpl();
    private final InsumoRepository insumoRepo = new InsumoRepositoryImpl();
    private final ClienteRepository clienteRepo = new ClienteRepositoryImpl();

    public List<Solicitud> obtenerVentasConsolidadas() {
        return solicitudRepo.listarCabeceras();
    }

    public List<ReactivoInsumo> obtenerInventarioInsumos() {
        return insumoRepo.listarTodos();
    }

    public List<Cliente> obtenerCarteraClientes() {
        return clienteRepo.listarTodos();
    }
}