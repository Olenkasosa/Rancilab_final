package servicio;

import modelo.Usuario;
import repositorio.UsuarioRepository;
import repositorio.UsuarioRepositoryImpl;
import util.HashUtil;

public class AuthFacade {
    private final UsuarioRepository usuarioRepo;

    public AuthFacade() {
        this.usuarioRepo = new UsuarioRepositoryImpl();
    }

    public enum ResultadoAuth {
        EXITO,
        CREDENCIALES_INVALIDAS,
        USUARIO_BLOQUEADO,
        USUARIO_NO_EXISTE
    }

    public ResultadoAuth autenticar(String username, String clavePlana) {
        Usuario u = usuarioRepo.buscarPorUsername(username);
        if (u == null) {
            return ResultadoAuth.USUARIO_NO_EXISTE;
        }

        if ("BLOQUEADO".equalsIgnoreCase(u.getEstado())) {
            return ResultadoAuth.USUARIO_BLOQUEADO;
        }

        String hashIngresado = HashUtil.encriptarSHA256(clavePlana);
        if (u.getPasswordHash() != null && u.getPasswordHash().equals(hashIngresado)) {
            usuarioRepo.reiniciarIntentos(u.getId());
            return ResultadoAuth.EXITO;
        } else {
            int intentos = u.getIntentosFallidos() + 1;
            if (intentos >= 3) {
                usuarioRepo.cambiarEstado(u.getId(), "BLOQUEADO");
                return ResultadoAuth.USUARIO_BLOQUEADO;
            } else {
                usuarioRepo.actualizar(u);
                return ResultadoAuth.CREDENCIALES_INVALIDAS;
            }
        }
    }
}