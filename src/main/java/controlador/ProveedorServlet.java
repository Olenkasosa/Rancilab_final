package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Proveedor;
import repositorio.ProveedorRepository;
import repositorio.ProveedorRepositoryImpl;

@WebServlet("/ProveedorServlet")
public class ProveedorServlet extends HttpServlet {

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
            case "cambiarEstado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String nuevoEstado = request.getParameter("estado");
                proveedorRepo.cambiarEstado(idEstado, nuevoEstado);
                response.sendRedirect("ProveedorServlet?accion=listar");
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                proveedorRepo.eliminar(idEliminar);
                response.sendRedirect("ProveedorServlet?accion=listar");
                break;

            case "listar":
            default:
                List<Proveedor> lista = proveedorRepo.listarTodos();
                request.setAttribute("listaProveedores", lista);
                request.getRequestDispatcher("proveedores.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("guardar".equals(accion)) {
            Proveedor nuevo = new Proveedor();
            nuevo.setRuc(request.getParameter("ruc"));
            nuevo.setRazonSocial(request.getParameter("razonSocial"));
            nuevo.setCategoria(request.getParameter("categoria"));
            nuevo.setContacto(request.getParameter("contacto"));
            nuevo.setTelefono(request.getParameter("telefono"));
            nuevo.setEmail(request.getParameter("email"));
            nuevo.setEstado("ACTIVO");

            proveedorRepo.registrar(nuevo);
            response.sendRedirect("ProveedorServlet?accion=listar");
        } else if ("actualizar".equals(accion)) {
            Proveedor p = new Proveedor();
            p.setId(Integer.parseInt(request.getParameter("id")));
            p.setRuc(request.getParameter("ruc"));
            p.setRazonSocial(request.getParameter("razonSocial"));
            p.setCategoria(request.getParameter("categoria"));
            p.setContacto(request.getParameter("contacto"));
            p.setTelefono(request.getParameter("telefono"));
            p.setEmail(request.getParameter("email"));
            p.setEstado(request.getParameter("estado"));

            proveedorRepo.actualizar(p);
            response.sendRedirect("ProveedorServlet?accion=listar");
        }
    }
}
