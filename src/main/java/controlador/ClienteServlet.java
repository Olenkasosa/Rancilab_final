package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Cliente;
import repositorio.ClienteRepository;
import repositorio.ClienteRepositoryImpl;

@WebServlet("/ClienteServlet")
public class ClienteServlet extends HttpServlet {

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
            case "cambiarEstado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String nuevoEstado = request.getParameter("estado");
                clienteRepo.cambiarEstado(idEstado, nuevoEstado);
                response.sendRedirect("ClienteServlet?accion=listar");
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                clienteRepo.eliminar(idEliminar);
                response.sendRedirect("ClienteServlet?accion=listar");
                break;

            case "listar":
            default:
                List<Cliente> lista = clienteRepo.listarTodos();
                request.setAttribute("listaClientes", lista);
                request.getRequestDispatcher("clientes.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("guardar".equals(accion)) {
            Cliente nuevo = new Cliente();
            nuevo.setRucDni(request.getParameter("rucDni"));
            nuevo.setRazonSocial(request.getParameter("razonSocial"));
            nuevo.setContacto(request.getParameter("contacto"));
            nuevo.setEmail(request.getParameter("email"));
            nuevo.setTelefono(request.getParameter("telefono"));
            nuevo.setEstado("ACTIVO");

            clienteRepo.registrar(nuevo);
            response.sendRedirect("ClienteServlet?accion=listar");
        } else if ("actualizar".equals(accion)) {
            Cliente c = new Cliente();
            c.setId(Integer.parseInt(request.getParameter("id")));
            c.setRucDni(request.getParameter("rucDni"));
            c.setRazonSocial(request.getParameter("razonSocial"));
            c.setContacto(request.getParameter("contacto"));
            c.setEmail(request.getParameter("email"));
            c.setTelefono(request.getParameter("telefono"));
            c.setEstado(request.getParameter("estado"));

            clienteRepo.actualizar(c);
            response.sendRedirect("ClienteServlet?accion=listar");
        }
    }
}
