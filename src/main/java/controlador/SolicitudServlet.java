package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Cliente;
import modelo.Solicitud;
import modelo.SolicitudDetalle;
import modelo.Usuario;
import repositorio.ClienteRepository;
import repositorio.ClienteRepositoryImpl;
import repositorio.SolicitudRepository;
import repositorio.SolicitudRepositoryImpl;

@WebServlet("/SolicitudServlet")
public class SolicitudServlet extends HttpServlet {

    private final SolicitudRepository solicitudRepo = new SolicitudRepositoryImpl();
    private final ClienteRepository clienteRepo = new ClienteRepositoryImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "ver":
                int idVer = Integer.parseInt(request.getParameter("id"));
                Solicitud sol = solicitudRepo.obtenerPorIdConDetalles(idVer);
                request.setAttribute("solicitud", sol);
                request.getRequestDispatcher("comprobante_detalle.jsp").forward(request, response);
                break;

            case "cambiarEstado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String nuevoEstado = request.getParameter("estado");
                solicitudRepo.cambiarEstado(idEstado, nuevoEstado);
                response.sendRedirect("SolicitudServlet?accion=listar");
                break;

            case "listar":
            default:
                List<Solicitud> lista = solicitudRepo.listarCabeceras();
                List<Cliente> listaClientes = clienteRepo.listarTodos();
                request.setAttribute("listaSolicitudes", lista);
                request.setAttribute("listaClientes", listaClientes);
                request.getRequestDispatcher("ventas_solped.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario analista = (Usuario) session.getAttribute("usuarioLogueado");

        int idAnalista = (analista != null) ? analista.getId() : 1;
        int idCliente = Integer.parseInt(request.getParameter("idCliente"));
        String comprobante = request.getParameter("tipoComprobante");
        String codigoSolped = "SOL-" + System.currentTimeMillis() % 100000;

        String[] muestras = request.getParameterValues("codigoMuestra[]");
        String[] ensayos = request.getParameterValues("tipoEnsayo[]");
        String[] cantidades = request.getParameterValues("cantidad[]");
        String[] precios = request.getParameterValues("precioUnitario[]");

        double subtotal = 0.0;
        Solicitud s = new Solicitud();
        s.setCodigoSolped(codigoSolped);
        s.setIdCliente(idCliente);
        s.setIdAnalista(idAnalista);
        s.setTipoComprobante(comprobante);

        if (muestras != null) {
            for (int i = 0; i < muestras.length; i++) {
                if (muestras[i] != null && !muestras[i].trim().isEmpty()) {
                    int cant = Integer.parseInt(cantidades[i]);
                    double precio = Double.parseDouble(precios[i]);
                    double subLinea = cant * precio;
                    subtotal += subLinea;

                    SolicitudDetalle det = new SolicitudDetalle();
                    det.setCodigoMuestra(muestras[i].trim());
                    det.setTipoEnsayo(ensayos[i]);
                    det.setCantidad(cant);
                    det.setPrecioUnitario(precio);
                    det.setSubtotalLinea(subLinea);
                    s.getDetalles().add(det);
                }
            }
        }

        double igv = subtotal * 0.18;
        double total = subtotal + igv;
        s.setSubtotal(subtotal);
        s.setIgv(igv);
        s.setTotal(total);
        s.setEstado("FACTURADO");

        solicitudRepo.registrarTransaccional(s);
        response.sendRedirect("SolicitudServlet?accion=listar");
    }
}
