package tz.udom.quiz.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;


@WebServlet("/createTeacher")
public class CreateTeacherServlet extends HttpServlet {

    private static final int ITERATIONS = 65536;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


    /*
     * ==========================================================
     * ADMIN AUTHORIZATION
     * ==========================================================
     */

    HttpSession session =
            request.getSession(false);


    boolean adminLoggedIn =
            session != null
            && Boolean.TRUE.equals(
                    session.getAttribute("adminLoggedIn")
            )
            && "ADMIN".equals(
                    session.getAttribute("userRole")
            );


    if (!adminLoggedIn) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=adminLoginRequired"
        );

        return;
    }

    
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String staffNumber = request.getParameter("staffNumber");
        String college = request.getParameter("college");
        String department = request.getParameter("department");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Remove unnecessary spaces
        firstName = clean(firstName);
        middleName = clean(middleName);
        lastName = clean(lastName);
        staffNumber = clean(staffNumber);
        college = clean(college);
        department = clean(department);
        email = clean(email);
        phone = clean(phone);

        /*
         * Validate required fields.
         */
        if (isEmpty(firstName)
                || isEmpty(lastName)
                || isEmpty(staffNumber)
                || isEmpty(college)
                || isEmpty(department)
                || isEmpty(email)
                || isEmpty(phone)
                || isEmpty(password)
                || isEmpty(confirmPassword)) {

            redirectError(
                    request,
                    response,
                    "Please fill in all required fields."
            );
            return;
        }

        /*
         * Validate email.
         */
        if (!email.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            redirectError(
                    request,
                    response,
                    "Please enter a valid email address."
            );
            return;
        }

        /*
         * Check password confirmation.
         */
        if (!password.equals(confirmPassword)) {

            redirectError(
                    request,
                    response,
                    "Passwords do not match."
            );
            return;
        }

        /*
         * Basic password length validation.
         */
        if (password.length() < 8) {

            redirectError(
                    request,
                    response,
                    "Password must contain at least 8 characters."
            );
            return;
        }

        /*
         * Check duplicate staff number and email.
         */
        String duplicateSql =
                "SELECT staff_number, email "
                + "FROM teachers "
                + "WHERE staff_number = ? OR email = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(duplicateSql)) {

            statement.setString(1, staffNumber);
            statement.setString(2, email);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    String existingStaffNumber =
                            resultSet.getString("staff_number");

                    String existingEmail =
                            resultSet.getString("email");

                    if (staffNumber.equalsIgnoreCase(
                            existingStaffNumber)) {

                        redirectError(
                                request,
                                response,
                                "The staff number already exists."
                        );
                        return;
                    }

                    if (email.equalsIgnoreCase(existingEmail)) {

                        redirectError(
                                request,
                                response,
                                "The email address already exists."
                        );
                        return;
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "Unable to check teacher information."
            );
            return;
        }

        /*
         * Hash password using PBKDF2-HMAC-SHA256.
         */
        String passwordHash;

        try {

            passwordHash = hashPassword(password);

        } catch (GeneralSecurityException e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "Unable to securely process the password."
            );
            return;
        }

        /*
         * Insert teacher.
         */
        String insertSql =
                "INSERT INTO teachers "
                + "(first_name, middle_name, last_name, "
                + "staff_number, college, department, "
                + "email, phone, password_hash) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(insertSql)) {

            statement.setString(1, firstName);

            if (isEmpty(middleName)) {
                statement.setNull(
                        2,
                        java.sql.Types.VARCHAR
                );
            } else {
                statement.setString(2, middleName);
            }

            statement.setString(3, lastName);
            statement.setString(4, staffNumber);
            statement.setString(5, college);
            statement.setString(6, department);
            statement.setString(7, email);
            statement.setString(8, phone);
            statement.setString(9, passwordHash);

            int rowsInserted =
                    statement.executeUpdate();

            if (rowsInserted == 1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/create-teacher.jsp"
                        + "?success=teacherCreated"
                );

                return;
            }

            redirectError(
                    request,
                    response,
                    "Teacher account could not be created."
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "An error occurred while creating the teacher account."
            );
        }
    }


    /*
     * PBKDF2-HMAC-SHA256 password hashing.
     *
     * Stored format:
     *
     * iterations:salt:hash
     */
    private static String hashPassword(String password)
            throws GeneralSecurityException {

        SecureRandom secureRandom =
                new SecureRandom();

        byte[] salt =
                new byte[SALT_LENGTH];

        secureRandom.nextBytes(salt);

        javax.crypto.spec.PBEKeySpec spec =
                new javax.crypto.spec.PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        ITERATIONS,
                        KEY_LENGTH
                );

        try {

            javax.crypto.SecretKeyFactory factory =
                    javax.crypto.SecretKeyFactory.getInstance(
                            "PBKDF2WithHmacSHA256"
                    );

            byte[] hash =
                    factory.generateSecret(spec)
                            .getEncoded();

            return ITERATIONS
                    + ":"
                    + Base64.getEncoder()
                            .encodeToString(salt)
                    + ":"
                    + Base64.getEncoder()
                            .encodeToString(hash);

        } finally {

            spec.clearPassword();
        }
    }


    private static String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    private static boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }


    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/create-teacher.jsp"
                + "?status=error"
                + "&message="
                + java.net.URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}