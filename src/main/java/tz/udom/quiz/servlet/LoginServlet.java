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

        request.setAttribute("email", email);

        // -----------------------------
        // Validate input
        // -----------------------------

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute(
                    "loginError",
                    "Please enter your email address."
            );
            forwardToLogin(request, response);
            return;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute(
                    "loginError",
                    "Please enter your password."
            );
            forwardToLogin(request, response);
            return;
        }

        String cleanEmail = email.trim().toLowerCase();

        try (Connection connection = DBConnection.getConnection()) {

            // =====================================================
            // 1. CHECK STUDENT
            // =====================================================

            String studentSql = """
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

            try (PreparedStatement statement =
                         connection.prepareStatement(studentSql)) {

                statement.setString(1, cleanEmail);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (resultSet.next()) {

                        String storedPasswordHash =
                                resultSet.getString("password_hash");

                        if (verifyPassword(password, storedPasswordHash)) {

                            HttpSession session =
                                    request.getSession(true);

                            request.changeSessionId();

                            clearRoleAttributes(session);

                            session.setAttribute(
                                    "studentId",
                                    resultSet.getInt("id")
                            );

                            session.setAttribute(
                                    "studentRegistrationNumber",
                                    resultSet.getString("registration_number")
                            );

                            session.setAttribute(
                                    "studentFirstName",
                                    resultSet.getString("first_name")
                            );

                            session.setAttribute(
                                    "studentMiddleName",
                                    resultSet.getString("middle_name")
                            );

                            session.setAttribute(
                                    "studentLastName",
                                    resultSet.getString("last_name")
                            );

                            session.setAttribute(
                                    "studentEmail",
                                    resultSet.getString("email")
                            );

                            session.setAttribute(
                                    "studentCollege",
                                    resultSet.getString("college")
                            );

                            session.setAttribute(
                                    "studentProgramme",
                                    resultSet.getString("programme")
                            );

                            session.setAttribute(
                                    "studentYearOfStudy",
                                    resultSet.getInt("year_of_study")
                            );

                            session.setAttribute(
                                    "studentLoggedIn",
                                    true
                            );

                            session.setAttribute(
                                    "userRole",
                                    "STUDENT"
                            );

                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/student/dashboard.jsp"
                            );

                            return;
                        }
                    }
                }
            }

            // =====================================================
            // 2. CHECK TEACHER
            // =====================================================

            String teacherSql = """
                    SELECT
                        id,
                        first_name,
                        middle_name,
                        last_name,
                        staff_number,
                        college,
                        department,
                        email,
                        phone,
                        password_hash
                    FROM teachers
                    WHERE email = ?
                    """;

            try (PreparedStatement statement =
                         connection.prepareStatement(teacherSql)) {

                statement.setString(1, cleanEmail);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (resultSet.next()) {

                        String storedPasswordHash =
                                resultSet.getString("password_hash");

                        if (verifyPassword(password, storedPasswordHash)) {

                            HttpSession session =
                                    request.getSession(true);

                            request.changeSessionId();

                            clearRoleAttributes(session);

                            session.setAttribute(
                                    "teacherId",
                                    resultSet.getInt("id")
                            );

                            session.setAttribute(
                                    "teacherStaffNumber",
                                    resultSet.getString("staff_number")
                            );

                            session.setAttribute(
                                    "teacherFirstName",
                                    resultSet.getString("first_name")
                            );

                            session.setAttribute(
                                    "teacherMiddleName",
                                    resultSet.getString("middle_name")
                            );

                            session.setAttribute(
                                    "teacherLastName",
                                    resultSet.getString("last_name")
                            );

                            session.setAttribute(
                                    "teacherEmail",
                                    resultSet.getString("email")
                            );

                            session.setAttribute(
                                    "teacherCollege",
                                    resultSet.getString("college")
                            );

                            session.setAttribute(
                                    "teacherDepartment",
                                    resultSet.getString("department")
                            );

                            session.setAttribute(
                                    "teacherPhone",
                                    resultSet.getString("phone")
                            );

                            session.setAttribute(
                                    "teacherLoggedIn",
                                    true
                            );

                            session.setAttribute(
                                    "userRole",
                                    "TEACHER"
                            );

                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/teacher/dashboard.jsp"
                            );

                            return;
                        }
                    }
                }
            }

            // =====================================================
            // 3. CHECK ADMIN
            // =====================================================

            String adminSql = """
                    SELECT
                        id,
                        first_name,
                        middle_name,
                        last_name,
                        username,
                        email,
                        password_hash
                    FROM admins
                    WHERE email = ?
                    """;

            try (PreparedStatement statement =
                         connection.prepareStatement(adminSql)) {

                statement.setString(1, cleanEmail);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (resultSet.next()) {

                        String storedPasswordHash =
                                resultSet.getString("password_hash");

                        if (verifyPassword(password, storedPasswordHash)) {

                            HttpSession session =
                                    request.getSession(true);

                            request.changeSessionId();

                            clearRoleAttributes(session);

                            session.setAttribute(
                                    "adminId",
                                    resultSet.getInt("id")
                            );

                            session.setAttribute(
                                    "adminUsername",
                                    resultSet.getString("username")
                            );

                            session.setAttribute(
                                    "adminFirstName",
                                    resultSet.getString("first_name")
                            );

                            session.setAttribute(
                                    "adminMiddleName",
                                    resultSet.getString("middle_name")
                            );

                            session.setAttribute(
                                    "adminLastName",
                                    resultSet.getString("last_name")
                            );

                            session.setAttribute(
                                    "adminEmail",
                                    resultSet.getString("email")
                            );

                            session.setAttribute(
                                    "adminLoggedIn",
                                    true
                            );

                            session.setAttribute(
                                    "userRole",
                                    "ADMIN"
                            );

                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/admin/dashboard.jsp"
                            );

                            return;
                        }
                    }
                }
            }

            // =====================================================
            // INVALID LOGIN
            // =====================================================

            request.setAttribute(
                    "loginError",
                    "Invalid email or password."
            );

            forwardToLogin(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute(
                    "generalError",
                    "A database error occurred. Please try again."
            );

            forwardToLogin(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "generalError",
                    "Unable to process login. Please try again."
            );

            forwardToLogin(request, response);
        }
    }

    // =============================================================
    // FORWARD TO LOGIN PAGE
    // =============================================================

    private void forwardToLogin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/login.jsp"
        ).forward(request, response);
    }

    // =============================================================
    // CLEAR PREVIOUS ROLE SESSION ATTRIBUTES
    // =============================================================

    private void clearRoleAttributes(HttpSession session) {

        // Student
        session.removeAttribute("studentId");
        session.removeAttribute("studentRegistrationNumber");
        session.removeAttribute("studentFirstName");
        session.removeAttribute("studentMiddleName");
        session.removeAttribute("studentLastName");
        session.removeAttribute("studentEmail");
        session.removeAttribute("studentCollege");
        session.removeAttribute("studentProgramme");
        session.removeAttribute("studentYearOfStudy");
        session.removeAttribute("studentLoggedIn");

        // Teacher
        session.removeAttribute("teacherId");
        session.removeAttribute("teacherStaffNumber");
        session.removeAttribute("teacherFirstName");
        session.removeAttribute("teacherMiddleName");
        session.removeAttribute("teacherLastName");
        session.removeAttribute("teacherEmail");
        session.removeAttribute("teacherCollege");
        session.removeAttribute("teacherDepartment");
        session.removeAttribute("teacherPhone");
        session.removeAttribute("teacherLoggedIn");

        // Admin
        session.removeAttribute("adminId");
        session.removeAttribute("adminUsername");
        session.removeAttribute("adminFirstName");
        session.removeAttribute("adminMiddleName");
        session.removeAttribute("adminLastName");
        session.removeAttribute("adminEmail");
        session.removeAttribute("adminLoggedIn");

        session.removeAttribute("userRole");
    }

    // =============================================================
    // PBKDF2 PASSWORD VERIFICATION
    // =============================================================

    private boolean verifyPassword(
            String password,
            String storedPassword)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        if (storedPassword == null ||
                storedPassword.trim().isEmpty()) {

            return false;
        }

        String[] parts = storedPassword.split(":");

        if (parts.length != 3) {
            return false;
        }

        int iterations;

        try {
            iterations = Integer.parseInt(parts[0]);

        } catch (NumberFormatException e) {

            return false;
        }

        if (iterations <= 0) {
            return false;
        }

        byte[] salt;
        byte[] expectedHash;

        try {

            salt = Base64.getDecoder().decode(parts[1]);
            expectedHash = Base64.getDecoder().decode(parts[2]);

        } catch (IllegalArgumentException e) {

            return false;
        }

        KeySpec spec = new PBEKeySpec(
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
                factory.generateSecret(spec).getEncoded();

        return MessageDigest.isEqual(
                actualHash,
                expectedHash
        );
    }
}