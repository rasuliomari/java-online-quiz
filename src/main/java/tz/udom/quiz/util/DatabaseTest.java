// package removed to match expected default package
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {
            if (connection != null) {
                System.out.println("=================================");
                System.out.println("PostgreSQL connection successful!");
                System.out.println("Database: " + connection.getCatalog());
                System.out.println("=================================");
            }

        } catch (Exception e) {

            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}

// Minimal DBConnection helper to provide a JDBC Connection for tests.
class DBConnection {

    /**
     * Returns a JDBC connection. Uses environment variables if set:
     * DB_URL, DB_USER, DB_PASSWORD. Falls back to a local Postgres default.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Attempt to load the Postgres driver if available
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            // Driver not found on classpath; rethrow to let caller handle or proceed if driver auto-registered
            // Many JDBC setups auto-register the driver, so we don't fail here necessarily.
            // Rethrow to make the error explicit if needed.
            throw e;
        }

        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        if (url == null || url.isEmpty()) {
            url = "jdbc:postgresql://localhost:5432/postgres"; // default
        }
        if (user == null) {
            user = "postgres";
        }
        if (password == null) {
            password = "";
        }

        return DriverManager.getConnection(url, user, password);
    }
}