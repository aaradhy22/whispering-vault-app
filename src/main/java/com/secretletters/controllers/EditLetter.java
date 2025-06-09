package com.secretletters.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.secretletters.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/editLetter")
public class EditLetter extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- The DELETE operation will be handled by a GET request ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_code") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int letterId = Integer.parseInt(request.getParameter("id"));
            
            // For security, you should also verify this letter belongs to the logged-in user before deleting.
            // (This is an advanced step, for now we will trust the ID).
            
            Connection conn = null;
            PreparedStatement ps = null;
            
            try {
                conn = DBUtil.getConnection();
                String sql = "DELETE FROM letters WHERE id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, letterId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, ps);
            }
            
        } catch (NumberFormatException e) {
            // Handle cases where the ID is not a valid number
            e.printStackTrace();
        }

        // Redirect back to the dashboard to show the updated list
        response.sendRedirect("dashboard");
    }

    // --- The UPDATE operation will be handled by a POST request ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_code") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int letterId = Integer.parseInt(request.getParameter("id"));
            String letterContent = request.getParameter("content");

            if (letterContent == null || letterContent.trim().isEmpty()) {
                // If content is empty, treat it as a delete request
                doGet(request, response);
                return;
            }

            Connection conn = null;
            PreparedStatement ps = null;

            try {
                conn = DBUtil.getConnection();
                String sql = "UPDATE letters SET letter_content = ? WHERE id = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, letterContent);
                ps.setInt(2, letterId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, ps);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // Redirect back to the dashboard
        response.sendRedirect("dashboard");
    }
}