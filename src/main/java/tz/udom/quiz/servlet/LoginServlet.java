package tz.udom.quiz.servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Preserve email when returning to the login page
        request.setAttribute("email", email);

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute(
                    "loginError",
                    "Please enter your email address."
            );

            forwardToLogin(request, response);
            return;
        }

        // Validate password
        if (password == null || password.isEmpty()) {
            request.setAttribute(
                    "loginError",
                    "Please enter your password."
            );

            forwardToLogin(request, response);
            return;
        }

        String cleanEmail = email.trim().toLowerCase();

        String sql = """
                SELECT
                    id,
                    first_name,
                    middle_name,
                    last_name,
                    registration_number,
                    college,
                    programme,
                    year_of_study,
                    email,
                    password_hash
                FROM students
                WHERE email = ?
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(1, cleanEmail);

            try (ResultSet resultSet = statement.executeQuery()) {

                // Student does not exist
                if (!resultSet.next()) {

                    request.setAttribute(
                            "loginError",
                            "Invalid email or password."
                    );

                    forwardToLogin(request, response);
                    return;
                }

                int studentId = resultSet.getInt("id");

                String firstName =
                        resultSet.getString("first_name");

                String middleName =
                        resultSet.getString("middle_name");

                String lastName =
                        resultSet.getString("last_name");

                String registrationNumber =
                        resultSet.getString("registration_number");

                String college =
                        resultSet.getString("college");

                String programme =
                        resultSet.getString("programme");

                int yearOfStudy =
                        resultSet.getInt("year_of_study");

                String studentEmail =
                        resultSet.getString("email");

                String storedPasswordHash =
                        resultSet.getString("password_hash");

                // Verify PBKDF2 password
                boolean passwordValid;

                try {

                    passwordValid =
                            verifyPassword(
                                    password,
                                    storedPasswordHash
                            );

                } catch (Exception e) {

                    e.printStackTrace();

                    request.setAttribute(
                            "generalError",
                            "Unable to process login. Please try again."
                    );

                    forwardToLogin(request, response);
                    return;
                }

                // Wrong password
                if (!passwordValid) {

                    request.setAttribute(
                            "loginError",
                            "Invalid email or password."
                    );

                    forwardToLogin(request, response);
                    return;
                }

                /*
                 * Login successful
                 */

                HttpSession session =
                        request.getSession(true);

                // Prevent session fixation
                request.changeSessionId();

                // Store student information in session
                session.setAttribute(
                        "studentId",
                        studentId
                );

                session.setAttribute(
                        "studentRegistrationNumber",
                        registrationNumber
                );

                session.setAttribute(
                        "studentFirstName",
                        firstName
                );

                session.setAttribute(
                        "studentMiddleName",
                        middleName
                );

                session.setAttribute(
                        "studentLastName",
                        lastName
                );

                session.setAttribute(
                        "studentEmail",
                        studentEmail
                );

                session.setAttribute(
                        "studentCollege",
                        college
                );

                session.setAttribute(
                        "studentProgramme",
                        programme
                );

                session.setAttribute(
                        "studentYearOfStudy",
                        yearOfStudy
                );

                session.setAttribute(
                        "studentLoggedIn",
                        true
                );

                session.setAttribute(
                        "userRole",
                        "STUDENT"
                );

                // Redirect to student dashboard
                response.sendRedirect(
                        request.getContextPath()
                                + "/student/dashboard.jsp"
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute(
                    "generalError",
                    "A database error occurred. Please try again."
            );

            forwardToLogin(request, response);
        }
    }

    /**
     * Return to login page while preserving validation errors.
     */
    private void forwardToLogin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/login.jsp"
        ).forward(request, response);
    }

    /**
     * Verify a PBKDF2-HMAC-SHA256 password.
     *
     * Stored format:
     *
     * iterations:salt:hash
     */
    private boolean verifyPassword(
            String password,
            String storedPassword)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        if (storedPassword == null ||
                storedPassword.trim().isEmpty()) {

            return false;
        }

        String[] parts =
                storedPassword.split(":");

        // Expected:
        // iterations:salt:hash
        if (parts.length != 3) {
            return false;
        }

        int iterations;

        try {

            iterations =
                    Integer.parseInt(parts[0]);

        } catch (NumberFormatException e) {

            return false;
        }

        if (iterations <= 0) {
            return false;
        }

        byte[] salt;
        byte[] expectedHash;

        try {

            salt =
                    Base64.getDecoder()
                            .decode(parts[1]);

            expectedHash =
                    Base64.getDecoder()
                            .decode(parts[2]);

        } catch (IllegalArgumentException e) {

            return false;
        }

        KeySpec spec =
                new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        iterations,
                        expectedHash.length * 8
                );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256"
                );

        byte[] actualHash =
                factory.generateSecret(spec)
                        .getEncoded();

        /*
         * Constant-time comparison prevents
         * timing-based password comparison attacks.
         */
        return MessageDigest.isEqual(
                actualHash,
                expectedHash
        );
    }
}