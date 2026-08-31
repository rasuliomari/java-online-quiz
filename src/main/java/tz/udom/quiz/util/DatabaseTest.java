package tz.udom.quiz.util;

import java.sql.Connection;

public class DatabaseTest {

    public static void main(String[] args) {

        try {

            Connection connection =
                    DBConnection.getConnection();

            System.out.println(
                    "PostgreSQL connection successful!"
            );

            connection.close();

        } catch (Exception e) {

            System.out.println(
                    "Database connection failed!"
            );

            e.printStackTrace();
        }
    }
}