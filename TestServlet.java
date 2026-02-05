package com.giet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class TestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        res.getWriter().println("Servlet is running!");
    }
}
