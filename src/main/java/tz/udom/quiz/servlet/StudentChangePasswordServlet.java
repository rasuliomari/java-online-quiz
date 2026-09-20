package tz.udom.quiz.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/studentChangePassword")
public class StudentChangePasswordServlet extends HttpServlet {

    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // GET SESSION
        // =====================================================

        HttpSession session =
                request.getSession(false);


        // =====================================================
        // CHECK STUDENT LOGIN
        // =====================================================

        if (session == null ||
            !Boolean.TRUE.equals(
                    session.getAttribute("studentLoggedIn")) ||
            !"STUDENT".equals(
                    session.getAttribute("userRole"))) {

            response.sendRedirect("login.jsp");
            return;
        }


        // =====================================================
        // GET STUDENT ID
        // =====================================================

        Object studentIdObject =
                session.getAttribute("studentId");

        if (studentIdObject == null) {

            response.sendRedirect("login.jsp");
            return;
        }


        int studentId;

        try {

            studentId =
                    Integer.parseInt(
                            studentIdObject.toString());

        } catch (NumberFormatException e) {

            response.sendRedirect("login.jsp");
            return;
        }


        // =====================================================
        // GET FORM DATA
        // =====================================================

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");


        // =====================================================
        // VALIDATE EMPTY FIELDS
        // =====================================================

        if (currentPassword == null ||
            newPassword == null ||
            confirmPassword == null ||
            currentPassword.trim().isEmpty() ||
            newPassword.trim().isEmpty() ||
            confirmPassword.trim().isEmpty()) {

            redirectError(
                    response,
                    "All password fields are required."
            );

            return;
        }


        // =====================================================
        // CONFIRM NEW PASSWORD
        // =====================================================

        if (!newPassword.equals(confirmPassword)) {

            redirectError(
                    response,
                    "New password and confirmation do not match."
            );

            return;
        }


        // =====================================================
        // PASSWORD LENGTH
        // =====================================================

        if (newPassword.length() < 6) {

            redirectError(
                    response,
                    "New password must contain at least 6 characters."
            );

            return;
        }


        // =====================================================
        // PREVENT SAME PASSWORD
        // =====================================================

        if (currentPassword.equals(newPassword)) {

            redirectError(
                    response,
                    "New password must be different from your current password."
            );

            return;
        }


        // =====================================================
        // DATABASE
        // =====================================================

        try (Connection connection =
                     DBConnection.getConnection()) {


            // =================================================
            // GET CURRENT PASSWORD HASH
            // =================================================

            String selectSql =
                    "SELECT password_hash " +
                    "FROM students " +
                    "WHERE id = ?";


            String storedHash = null;


            try (PreparedStatement ps =
                         connection.prepareStatement(selectSql)) {

                ps.setInt(1, studentId);

                try (ResultSet rs =
                             ps.executeQuery()) {

                    if (rs.next()) {

                        storedHash =
                                rs.getString(
                                        "password_hash");
                    }
                }
            }


            // =================================================
            // STUDENT NOT FOUND
            // =================================================

            if (storedHash == null) {

                redirectError(
                        response,
                        "Student account was not found."
                );

                return;
            }


            // =================================================
            // VERIFY CURRENT PASSWORD
            // =================================================

            if (!verifyPassword(
                    currentPassword,
                    storedHash)) {

                redirectError(
                        response,
                        "Current password is incorrect."
                );

                return;
            }


            // =================================================
            // HASH NEW PASSWORD
            // =================================================

            String newPasswordHash =
                    hashPassword(newPassword);


            // =================================================
            // UPDATE PASSWORD
            // =================================================

            String updateSql =
                    "UPDATE students " +
                    "SET password_hash = ?, " +
                    "updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";


            try (PreparedStatement ps =
                         connection.prepareStatement(updateSql)) {

                ps.setString(1, newPasswordHash);
                ps.setInt(2, studentId);


                int rowsUpdated =
                        ps.executeUpdate();


                if (rowsUpdated == 1) {

                    response.sendRedirect(
                            "student/settings.jsp" +
                            "?success=" +
                            URLEncoder.encode(
                                    "Password updated successfully.",
                                    StandardCharsets.UTF_8
                            )
                    );

                } else {

                    redirectError(
                            response,
                            "Password could not be updated."
                    );
                }
            }


        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    response,
                    "An error occurred while changing the password."
            );
        }
    }


    // =========================================================
    // REDIRECT ERROR
    // =========================================================

    private void redirectError(
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                "student/settings.jsp?error=" +
                URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }


    // =========================================================
    // HASH PASSWORD
    // =========================================================

    private String hashPassword(
            String password)
            throws Exception {

        SecureRandom random =
                new SecureRandom();


        byte[] salt =
                new byte[SALT_LENGTH];


        random.nextBytes(salt);


        PBEKeySpec spec =
                new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        ITERATIONS,
                        KEY_LENGTH
                );


        SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256"
                );


        byte[] hash =
                factory.generateSecret(spec)
                       .getEncoded();


        spec.clearPassword();


        String encodedSalt =
                Base64.getEncoder()
                      .encodeToString(salt);


        String encodedHash =
                Base64.getEncoder()
                      .encodeToString(hash);


        return ITERATIONS +
                ":" +
                encodedSalt +
                ":" +
                encodedHash;
    }


    // =========================================================
    // VERIFY PASSWORD
    // =========================================================

    private boolean verifyPassword(
            String password,
            String storedHash)
            throws Exception {

        String[] parts =
                storedHash.split(":");


        if (parts.length != 3) {
            return false;
        }


        int iterations =
                Integer.parseInt(parts[0]);


        byte[] salt =
                Base64.getDecoder()
                      .decode(parts[1]);


        byte[] expectedHash =
                Base64.getDecoder()
                      .decode(parts[2]);


        PBEKeySpec spec =
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


        spec.clearPassword();


        return constantTimeEquals(
                expectedHash,
                actualHash
        );
    }


    // =========================================================
    // CONSTANT-TIME COMPARISON
    // =========================================================

    private boolean constantTimeEquals(
            byte[] a,
            byte[] b) {

        if (a.length != b.length) {
            return false;
        }


        int result = 0;


        for (int i = 0; i < a.length; i++) {

            result |=
                    a[i] ^ b[i];
        }


        return result == 0;
    }
}