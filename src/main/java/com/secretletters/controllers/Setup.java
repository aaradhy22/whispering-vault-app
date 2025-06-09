package com.secretletters.controllers;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Import your new DBUtil class
import com.secretletters.utils.DBUtil; 

@WebServlet("/Setup")
public class Setup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- NO MORE DATABASE CREDENTIALS HERE! They are now in DBUtil. ---

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String secretCode = request.getParameter("generated_code");

        if (secretCode == null || !secretCode.matches("\\d{6}")) {
            request.setAttribute("error", "The key must be exactly 6 digits.");
            request.getRequestDispatcher("setup.jsp").forward(request, response);
            return;
        }

        // Declare resources outside the try block so they are accessible in finally.
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // --- 1. Get connection from the utility class ---
            conn = DBUtil.getConnection();

            String sql = "INSERT INTO secrets (secret_code) VALUES (?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, secretCode);

            ps.executeUpdate();
            
            response.sendRedirect("success.jsp");

        } catch (SQLException e) {
            String errorMessage = "A technical error occurred. Please try again.";
            if (e.getSQLState().startsWith("23")) { // '23000' is common for constraint violations
                errorMessage = "This secret key has already been chosen. Please forge another.";
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("setup.jsp").forward(request, response);
            e.printStackTrace();

        } finally {
            // --- 2. Close resources using the utility class ---
            // This single line replaces multiple try-catch blocks.
            DBUtil.close(conn, ps);
        }
    }
}