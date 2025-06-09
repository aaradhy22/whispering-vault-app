package com.secretletters.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.secretletters.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Letter")
public class Letter extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_code") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String userCode = (String) session.getAttribute("user_code");
        String letterContent = request.getParameter("letter_content");

        if (letterContent == null || letterContent.trim().isEmpty()) {
            response.sendRedirect("dashboard");
            return;
        }
        
        Connection conn = null;
        // BEST PRACTICE: Use separate statement variables for separate queries
        PreparedStatement psGetId = null; 
        PreparedStatement psInsert = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            int secretId = -1;
            String getIdSql = "SELECT id FROM secrets WHERE secret_code = ?";
            psGetId = conn.prepareStatement(getIdSql);
            psGetId.setString(1, userCode);
            rs = psGetId.executeQuery();
            
            if (rs.next()) {
                secretId = rs.getInt("id");
            } else {
                session.invalidate();
                response.sendRedirect("login.jsp");
                return;
            }
            
            // THE FIX: Include the timestamp columns in your INSERT statement.
            // Using NOW() lets the database handle generating the current time.
            String insertSql = "INSERT INTO letters (letter_content, secret_id, created_at, updated_at) VALUES (?, ?, NOW(), NOW())";
            
            psInsert = conn.prepareStatement(insertSql);
            psInsert.setString(1, letterContent.trim()); // Also good to trim the content before saving
            psInsert.setInt(2, secretId);
            
            psInsert.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error for debugging.
            // For a production app, you might redirect to an error page.
            throw new ServletException("Database error saving letter", e);
        } finally {
            // BEST PRACTICE: Close all resources individually in the finally block.
            DBUtil.close(null, psInsert, null);
            DBUtil.close(conn, psGetId, rs);
        }
        
        // This redirect is correct. It triggers the Dashboard servlet to run again.
        response.sendRedirect("dashboard");
    }
}