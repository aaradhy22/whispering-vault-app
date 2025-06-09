package com.secretletters.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Logout") // This makes the servlet listen to the "/Logout" URL from your link
public class Logout extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // --- 1. GET THE CURRENT SESSION ---
        // The 'false' parameter is important: it means "get the existing session, but don't create a new one if it doesn't exist".
        HttpSession session = request.getSession(false);
        
        // --- 2. DESTROY THE SESSION (if it exists) ---
        if (session != null) {
            // session.invalidate() is the command that logs the user out.
            // It clears all attributes (like "user_code") and effectively ends the session.
            session.invalidate();
        }
        
        // --- 3. REDIRECT TO A PUBLIC PAGE ---
        // After logging out, the user should be sent to a safe, public page.
        // The login page is the perfect destination.
        response.sendRedirect("login.jsp");
    }

    /**
     * It's good practice to handle both GET and POST for logout,
     * in case a form is ever used. This method simply calls the doGet method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}