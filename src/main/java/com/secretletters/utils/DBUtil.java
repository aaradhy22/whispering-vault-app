package com.secretletters.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * A utility class for handling database connections.
 * This class centralizes all JDBC connection information and provides
 * helper methods for getting a connection and closing resources.
 * This approach promotes code reuse and makes maintenance significantly easier.
 * 
 * <p><b>How to use:</b></p>
 * <pre>{@code
 * Connection conn = null;
 * PreparedStatement ps = null;
 * try {
 *     conn = DBUtil.getConnection();
 *     // ... prepare and execute your statement ...
 * } catch (SQLException e) {
 *     e.printStackTrace();
 * } finally {
 *     DBUtil.close(conn, ps);
 * }
 * }</pre>
 */
public final class DBUtil {

    // --- CONFIGURE YOUR DATABASE CONNECTION DETAILS HERE ---
    // Using private static final makes these constants for the class.
    private static final String DB_URL = "jdbc:mysql://localhost:3306/secretletters";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Radhe@22#";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Private constructor to prevent instantiation of this utility class.
     * All methods are static and should be called directly via the class name.
     */
    private DBUtil() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    /**
     * This static block loads the JDBC driver once when the class is first loaded into memory.
     * This is more efficient than loading it on every connection request.
     */
    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            // This is a critical failure: the application cannot connect to the DB without the driver.
            // We throw a RuntimeException to halt the application's startup.
            System.err.println("FATAL ERROR: JDBC Driver not found. Ensure the MySQL connector JAR is in WEB-INF/lib.");
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }

    /**
     * Establishes and returns a connection to the database.
     * 
     * @return A Connection object to the database.
     * @throws SQLException if a database access error occurs.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * A helper method to close a Connection and a PreparedStatement.
     * It checks for nulls before attempting to close the resources.
     * 
     * @param conn The Connection to close.
     * @param ps   The PreparedStatement to close.
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }

    /**
     * A helper method to close a Connection, a PreparedStatement, and a ResultSet.
     * It checks for nulls and closes each resource individually to ensure
     * that even if one close fails, the others are still attempted.
     * 
     * @param conn The Connection to close.
     * @param ps   The PreparedStatement to close.
     * @param rs   The ResultSet to close.
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Or log with a logging framework
        }
        
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}