package tz.udom.quiz.util;

import java.sql.Connection;

public class DatabaseTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {
            if (connection != null) {
                System.out.println("=================================");
                System.out.println("PostgreSQL connection successful!");
                System.out.println("Database: " + connection.getCatalog());
                System.out.println("=================================");
            }

        } catch (Exception e) {

            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}