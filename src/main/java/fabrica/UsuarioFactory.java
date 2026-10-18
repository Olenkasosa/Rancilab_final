package fabrica;

import modelo.Usuario;
import util.HashUtil;

public class UsuarioFactory {

    public static Usuario crearUsuario(String tipoRol, String username, String clavePlana, String nombreCompleto) {
        Usuario u = new Usuario();
        u.setUsername(username.trim());
        u.setPasswordHash(HashUtil.encriptarSHA256(clavePlana));
        u.setNombreCompleto(nombreCompleto.trim());
        u.setEstado("ACTIVO");
        u.setIntentosFallidos(0);

        if (tipoRol == null) {
            u.setRol("ANALISTA");
            return u;
        }

        switch (tipoRol.toUpperCase().trim()) {
            case "ADMIN":
                u.setRol("ADMIN");
                break;
            case "SUPERVISOR":
                u.setRol("SUPERVISOR");
                break;
            case "ANALISTA":
            default:
                u.setRol("ANALISTA");
                break;
        }
        return u;
    }
}
