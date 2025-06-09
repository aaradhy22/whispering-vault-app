package com.secretletters.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.secretletters.models.Letter;
import com.secretletters.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class Dashboard extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_code") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userCode = (String) session.getAttribute("user_code");
        List<Letter> letterList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT l.id, l.letter_content, l.created_at, l.updated_at FROM letters l " +
                     "JOIN secrets s ON l.secret_id = s.id " +
                     "WHERE s.secret_code = ? " +
                     "ORDER BY l.created_at DESC";
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, userCode);
            rs = ps.executeQuery();

            while (rs.next()) {
                letterList.add(new Letter(
                    rs.getInt("id"),
                    rs.getString("letter_content"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }

        request.setAttribute("letterList", letterList);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}