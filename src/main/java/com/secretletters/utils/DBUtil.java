package com.secretletters.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class DBUtil {

    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("FATAL ERROR: JDBC Driver not found.");
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }

    /**
     * Build the JDBC URL dynamically from environment variables.
     * Uses Railway environment variables if available, else falls back to local defaults.
     */
    private static String getDbUrl() {
        // Railway environment variables
        String host = System.getenv("MYSQL_HOST");
        String port = System.getenv("MYSQL_PORT");
        String database = System.getenv("MYSQL_DATABASE");

        // Local fallback values (for local development)
        if (host == null) host = "localhost";
        if (port == null) port = "3306";
        if (database == null) database = "secretletters";

        // Build JDBC URL with common parameters
        return String.format("jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC", host, port, database);
    }

    private static String getUser() {
        String user = System.getenv("MYSQL_USER");
        if (user == null) {
            // Local fallback user
            user = "root";
        }
        return user;
    }

    private static String getPassword() {
        String password = System.getenv("MYSQL_PASSWORD");
        if (password == null) {
            // Local fallback password - keep empty or your local password here
            password = "Radhe@22#";
        }
        return password;
    }

    /**
     * Get a database connection using the current environment configuration.
     * @return Connection to MySQL database.
     * @throws SQLException if connection fails.
     */
    public static Connection getConnection() throws SQLException {
        String url = getDbUrl();
        String user = getUser();
        String password = getPassword();

        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Close resources safely.
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }

    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
