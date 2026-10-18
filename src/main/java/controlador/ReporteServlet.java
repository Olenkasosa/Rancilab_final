package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Cliente;
import modelo.ReactivoInsumo;
import modelo.Solicitud;
import repositorio.ClienteRepository;
import repositorio.ClienteRepositoryImpl;
import repositorio.InsumoRepository;
import repositorio.InsumoRepositoryImpl;
import repositorio.SolicitudRepository;
import repositorio.SolicitudRepositoryImpl;

@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    private final SolicitudRepository solicitudRepo = new SolicitudRepositoryImpl();
    private final InsumoRepository insumoRepo = new InsumoRepositoryImpl();
    private final ClienteRepository clienteRepo = new ClienteRepositoryImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Solicitud> listaSolicitudes = solicitudRepo.listarCabeceras();
        List<ReactivoInsumo> listaInsumos = insumoRepo.listarTodos();
        List<Cliente> listaClientes = clienteRepo.listarTodos();

        request.setAttribute("listaSolicitudes", listaSolicitudes);
        request.setAttribute("listaInsumos", listaInsumos);
        request.setAttribute("listaClientes", listaClientes);

        request.getRequestDispatcher("reportes.jsp").forward(request, response);
    }
}