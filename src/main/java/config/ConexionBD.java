package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    // 1. Instancia única estática (Patrón Creacional Singleton)
    private static ConexionBD instancia;
    private Connection conexion;

    // 2. Parámetros de conexión a Railway
    // Reemplaza los valores con los que están en la pestaña 'Variables' de tu Postgres en Railway
    private static final String HOST = "tu_pghost_aqui";      // Ej: postgres.railway.internal o el host TCP público
    private static final String PUERTO = "5432";              // O el puerto de Railway
    private static final String BD = "railway";               // PGDATABASE
    private static final String USUARIO = "postgres";         // PGUSER
    private static final String CLAVE = "tu_pgpassword_aqui"; // PGPASSWORD

    // 3. Constructor privado para evitar 'new ConexionBD()' externo
    private ConexionBD() {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://" + HOST + ":" + PUERTO + "/" + BD;
            this.conexion = DriverManager.getConnection(url, USUARIO, CLAVE);
            System.out.println("Conexión Singleton a PostgreSQL establecida correctamente.");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error al conectar con la base de datos: " + e.getMessage());
        }
    }

    // 4. Método global de acceso sincronizado
    public static synchronized ConexionBD getInstance() {
        try {
            if (instancia == null || instancia.getConexion() == null || instancia.getConexion().isClosed()) {
                instancia = new ConexionBD();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return instancia;
    }

    public Connection getConexion() {
        return conexion;
    }
}