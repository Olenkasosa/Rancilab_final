package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Proveedor;
import modelo.ReactivoInsumo;
import repositorio.InsumoRepository;
import repositorio.InsumoRepositoryImpl;
import repositorio.ProveedorRepository;
import repositorio.ProveedorRepositoryImpl;

@WebServlet("/InsumoServlet")
public class InsumoServlet extends HttpServlet {

    private final InsumoRepository insumoRepo = new InsumoRepositoryImpl();
    private final ProveedorRepository proveedorRepo = new ProveedorRepositoryImpl();

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
            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                insumoRepo.eliminar(idEliminar);
                response.sendRedirect("InsumoServlet?accion=listar");
                break;

            case "listar":
            default:
                List<ReactivoInsumo> lista = insumoRepo.listarTodos();
                List<Proveedor> listaProveedores = proveedorRepo.listarTodos();
                request.setAttribute("listaInsumos", lista);
                request.setAttribute("listaProveedores", listaProveedores);
                request.getRequestDispatcher("insumos.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("guardar".equals(accion)) {
            ReactivoInsumo r = new ReactivoInsumo();
            r.setCodigo(request.getParameter("codigo"));
            r.setNombre(request.getParameter("nombre"));
            r.setPurezaGrado(request.getParameter("purezaGrado"));
            r.setStockActual(Double.parseDouble(request.getParameter("stockActual")));
            r.setStockMinimo(Double.parseDouble(request.getParameter("stockMinimo")));
            r.setUnidadMedida(request.getParameter("unidadMedida"));
            r.setIdProveedor(Integer.parseInt(request.getParameter("idProveedor")));
            r.setFechaVencimiento(request.getParameter("fechaVencimiento"));
            r.setEstado("DISPONIBLE");

            insumoRepo.registrar(r);
            response.sendRedirect("InsumoServlet?accion=listar");
        }
    }
}