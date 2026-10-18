package config;

import java.net.URI;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    private static ConexionBD instancia;
    private Connection conexion;

    private ConexionBD() {
        try {
            Class.forName("org.postgresql.Driver");

            // Leer la variable que Railway provee automáticamente
            String databaseUrl = System.getenv("DATABASE_URL");

            if (databaseUrl != null && !databaseUrl.isEmpty()) {
                // Configuración automática para producción en Railway
                URI uri = new URI(databaseUrl);
                String username = uri.getUserInfo().split(":")[0];
                String password = uri.getUserInfo().split(":")[1];
                String dbUrl = "jdbc:postgresql://" + uri.getHost() + ":" + uri.getPort() + uri.getPath();

                this.conexion = DriverManager.getConnection(dbUrl, username, password);
                System.out.println("Conexión exitosa a PostgreSQL usando DATABASE_URL.");
            } else {
                // Respaldo en caso de variables separadas o pruebas locales
                String host = System.getenv("PGHOST") != null ? System.getenv("PGHOST") : "localhost";
                String port = System.getenv("PGPORT") != null ? System.getenv("PGPORT") : "5432";
                String db   = System.getenv("PGDATABASE") != null ? System.getenv("PGDATABASE") : "railway";
                String user = System.getenv("PGUSER") != null ? System.getenv("PGUSER") : "postgres";
                String pass = System.getenv("PGPASSWORD") != null ? System.getenv("PGPASSWORD") : "";

                String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + "/" + db;
                this.conexion = DriverManager.getConnection(jdbcUrl, user, pass);
                System.out.println("Conexión establecida usando variables individuales.");
            }
        } catch (Exception e) {
            System.err.println("Error de conexión BD: " + e.getMessage());
            e.printStackTrace();
        }
    }

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