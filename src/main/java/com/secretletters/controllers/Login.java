package com.secretletters.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Import your DBUtil class
import com.secretletters.utils.DBUtil; 

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. GET THE SUBMITTED CODE FROM THE FORM
        String secretCode = request.getParameter("secret_code");

        // 2. SERVER-SIDE VALIDATION (IMPORTANT!)
        if (secretCode == null || !secretCode.matches("\\d{6}")) {
            request.setAttribute("error", "The key must be exactly 6 digits.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 3. GET A CONNECTION FROM OUR UTILITY CLASS
            conn = DBUtil.getConnection();

            // 4. PREPARE THE SQL QUERY TO CHECK IF THE CODE EXISTS
            // A PreparedStatement is used to prevent SQL Injection attacks.
            String sql = "SELECT secret_code FROM secrets WHERE secret_code = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, secretCode);

            // 5. EXECUTE THE QUERY
            rs = ps.executeQuery();

            // 6. PROCESS THE RESULT
            if (rs.next()) {
                // SUCCESS: The code exists in the database.
                // rs.next() returns true if a record was found.
                
                // Create a session to mark the user as logged in.
                HttpSession session = request.getSession();
                session.setAttribute("user_code", secretCode); // Store the user's code in the session
                
                // Redirect to the main application page (e.g., a dashboard).
                // Using redirect prevents form resubmission on refresh (Post-Redirect-Get pattern).
                response.sendRedirect("dashboard.jsp"); 

            } else {
                // FAILURE: The code does not exist.
                // rs.next() returns false if no records were found.
                
                // Set an error message to be displayed on the login page.
                request.setAttribute("error", "The key you whispered was not recognized.");
                
                // Forward the request back to the login page to show the error.
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // Handle any database-related errors
            e.printStackTrace(); // Log the error for the developer
            request.setAttribute("error", "A server error occurred. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // 7. ALWAYS CLOSE DATABASE RESOURCES
            // Use the DBUtil helper to close the connection, statement, and result set.
            DBUtil.close(conn, ps, rs);
        }
    }
}