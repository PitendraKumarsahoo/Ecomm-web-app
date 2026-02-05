package com.giet;

import java.sql.*;

public class DBConnection 
{
    private static final String URL = "jdbc:mysql://localhost:3306/ecomdb";
    private static final String USER = "root";  
    private static final String PASSWORD = "root"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected Successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM products");
            while (rs.next()) {
                System.out.println(rs.getInt("id") + " | " + rs.getString("name") + " | " + rs.getString("price"));
            }
        } catch (Exception e) 
        
        
        

        {
            e.printStackTrace();
        }
    }
}