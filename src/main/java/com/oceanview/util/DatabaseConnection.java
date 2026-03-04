package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DatabaseConnection - Singleton Pattern (Creational Pattern)
 * Ensures only ONE database connection instance exists
 * @version 1.0.0
 */
public class DatabaseConnection {

    // ─── SINGLETON INSTANCE ───
    private static DatabaseConnection instance;
    private Connection connection;

    // ─── DATABASE CONFIG ───
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/oceanview_resort";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "your_password_here";
    private static final String DB_DRIVER   = "com.mysql.cj.jdbc.Driver";

    // ─── PRIVATE CONSTRUCTOR ───
    private DatabaseConnection() {
        try {
            Class.forName(DB_DRIVER);
            this.connection = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        } catch (SQLException e) {
            throw new RuntimeException("Database connection failed", e);
        }
    }

    // ─── GET INSTANCE ───
    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    // ─── GET CONNECTION ───
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get connection", e);
        }
        return connection;
    }

    // ─── CLOSE CONNECTION ───
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                instance = null;
                System.out.println("Database connection closed!");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}