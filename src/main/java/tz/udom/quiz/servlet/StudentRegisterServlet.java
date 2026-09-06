package tz.udom.quiz.servlet;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/student-register")
public class StudentRegisterServlet extends HttpServlet {

    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get form values
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String registrationNumber = request.getParameter("registrationNumber");
        String college = request.getParameter("college");
        String programme = request.getParameter("programme");
        String yearOfStudy = request.getParameter("yearOfStudy");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate required fields
        if (isEmpty(firstName)
                || isEmpty(lastName)
                || isEmpty(gender)
                || isEmpty(dateOfBirth)
                || isEmpty(registrationNumber)
                || isEmpty(college)
                || isEmpty(programme)
                || isEmpty(yearOfStudy)
                || isEmpty(email)
                || isEmpty(phone)
                || isEmpty(password)
                || isEmpty(confirmPassword)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/student-registration.jsp?error=missing"
            );
            return;
        }

        // Validate password length
        if (password.length() < 8) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=password_length"
            );
            return;
        }

        // Validate password confirmation
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=password_mismatch"
            );
            return;
        }

        // Validate gender
        if (!gender.equals("MALE") && !gender.equals("FEMALE")) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=gender"
            );
            return;
        }

        // Validate year of study
        int year;

        try {
            year = Integer.parseInt(yearOfStudy);

            if (year < 1 || year > 4) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=year"
            );
            return;
        }

        // Hash password
        String passwordHash;

        try {
            passwordHash = hashPassword(password);
        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=server"
            );
            return;
        }

        // Insert student
        String sql = """
                INSERT INTO students (
                    first_name,
                    middle_name,
                    last_name,
                    gender,
                    date_of_birth,
                    registration_number,
                    college,
                    programme,
                    year_of_study,
                    email,
                    phone,
                    password_hash
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setString(1, firstName.trim());

            if (middleName == null || middleName.trim().isEmpty()) {
                statement.setNull(2, java.sql.Types.VARCHAR);
            } else {
                statement.setString(2, middleName.trim());
            }

            statement.setString(3, lastName.trim());
            statement.setString(4, gender);
            statement.setDate(
                    5,
                    java.sql.Date.valueOf(dateOfBirth)
            );
            statement.setString(6, registrationNumber.trim());
            statement.setString(7, college.trim());
            statement.setString(8, programme.trim());
            statement.setInt(9, year);
            statement.setString(10, email.trim().toLowerCase());
            statement.setString(11, phone.trim());
            statement.setString(12, passwordHash);

            statement.executeUpdate();

            // Registration successful
            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp?registered=success"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            // PostgreSQL unique constraint violation
            if ("23505".equals(e.getSQLState())) {

                String message = "duplicate";

                if (e.getMessage() != null) {

                    String errorMessage =
                            e.getMessage().toLowerCase();

                    if (errorMessage.contains("students_email_key")) {
                        message = "email_exists";
                    } else if (
                            errorMessage.contains(
                                    "students_registration_number_key")) {
                        message = "registration_exists";
                    }
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/student/student-registration.jsp?error="
                                + message
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/student/student-registration.jsp?error=database"
                );
            }

        } catch (IllegalArgumentException e) {

            // Invalid date format
            response.sendRedirect(
                    request.getContextPath()
                            + "/student/student-registration.jsp?error=date"
            );
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Creates a secure PBKDF2 password hash.
     *
     * Stored format:
     * iterations:salt:hash
     */
    private String hashPassword(String password)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        SecureRandom random = new SecureRandom();

        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);

        KeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256"
                );

        byte[] hash = factory.generateSecret(spec)
                .getEncoded();

        return ITERATIONS
                + ":"
                + Base64.getEncoder().encodeToString(salt)
                + ":"
                + Base64.getEncoder().encodeToString(hash);
    }
}