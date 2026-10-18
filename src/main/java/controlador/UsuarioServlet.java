package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Usuario;
import repositorio.UsuarioRepository;
import repositorio.UsuarioRepositoryImpl;
import util.HashUtil;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioRepository usuarioRepo = new UsuarioRepositoryImpl();

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
            case "desbloquear":
                int idDesbloquear = Integer.parseInt(request.getParameter("id"));
                usuarioRepo.reiniciarIntentos(idDesbloquear);
                response.sendRedirect("UsuarioServlet?accion=listar");
                break;

            case "cambiarEstado":
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String nuevoEstado = request.getParameter("estado");
                usuarioRepo.cambiarEstado(idEstado, nuevoEstado);
                response.sendRedirect("UsuarioServlet?accion=listar");
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                usuarioRepo.eliminar(idEliminar);
                response.sendRedirect("UsuarioServlet?accion=listar");
                break;

            case "listar":
            default:
                List<Usuario> lista = usuarioRepo.listarTodos();
                request.setAttribute("listaUsuarios", lista);
                request.getRequestDispatcher("usuarios.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("guardar".equals(accion)) {
            String username = request.getParameter("username");
            String clave = request.getParameter("clave");
            String nombreCompleto = request.getParameter("nombreCompleto");
            String rol = request.getParameter("rol");

            Usuario nuevo = new Usuario();
            nuevo.setUsername(username);
            nuevo.setPasswordHash(HashUtil.encriptarSHA256(clave));
            nuevo.setNombreCompleto(nombreCompleto);
            nuevo.setRol(rol);
            nuevo.setEstado("ACTIVO");

            usuarioRepo.registrar(nuevo);
            response.sendRedirect("UsuarioServlet?accion=listar");
        } else if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombreCompleto = request.getParameter("nombreCompleto");
            String rol = request.getParameter("rol");
            String estado = request.getParameter("estado");

            Usuario u = new Usuario();
            u.setId(id);
            u.setNombreCompleto(nombreCompleto);
            u.setRol(rol);
            u.setEstado(estado);

            usuarioRepo.actualizar(u);
            response.sendRedirect("UsuarioServlet?accion=listar");
        }
    }
}