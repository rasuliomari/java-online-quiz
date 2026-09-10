package tz.udom.quiz.servlet;

import java.io.IOException;
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

@WebServlet("/adminChangePassword")
public class AdminChangePasswordServlet extends HttpServlet {

    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 16;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin login
        if (session == null ||
            !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("adminId");

        if (adminId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        // Basic validation
        if (currentPassword == null ||
            newPassword == null ||
            confirmPassword == null ||
            currentPassword.isEmpty() ||
            newPassword.isEmpty() ||
            confirmPassword.isEmpty()) {

            response.sendRedirect(
                    "admin/settings.jsp?error=All password fields are required."
            );
            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    "admin/settings.jsp?error=New password and confirmation do not match."
            );
            return;
        }

        if (newPassword.length() < 6) {

            response.sendRedirect(
                    "admin/settings.jsp?error=New password must contain at least 6 characters."
            );
            return;
        }

        try (Connection connection = DBConnection.getConnection()) {

            /*
             * Get the current password hash
             */
            String selectSql =
                    "SELECT password_hash FROM admins WHERE id = ?";

            String storedHash = null;

            try (PreparedStatement ps =
                         connection.prepareStatement(selectSql)) {

                ps.setInt(1, adminId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        storedHash = rs.getString("password_hash");
                    }
                }
            }

            if (storedHash == null) {

                response.sendRedirect(
                        "admin/settings.jsp?error=Administrator account was not found."
                );
                return;
            }

            /*
             * Verify current password
             */
            if (!verifyPassword(currentPassword, storedHash)) {

                response.sendRedirect(
                        "admin/settings.jsp?error=Current password is incorrect."
                );
                return;
            }

            /*
             * Generate hash for new password
             */
            String newPasswordHash =
                    hashPassword(newPassword);

            /*
             * Update database
             */
            String updateSql =
                    "UPDATE admins " +
                    "SET password_hash = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";

            try (PreparedStatement ps =
                         connection.prepareStatement(updateSql)) {

                ps.setString(1, newPasswordHash);
                ps.setInt(2, adminId);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated == 1) {

                    response.sendRedirect(
                            "admin/settings.jsp?success=Password updated successfully."
                    );

                } else {

                    response.sendRedirect(
                            "admin/settings.jsp?error=Password could not be updated."
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "admin/settings.jsp?error=An error occurred while changing the password."
            );
        }
    }


    /*
     * Generate PBKDF2 password hash
     *
     * Format:
     *
     * iterations:salt:hash
     */
    private String hashPassword(String password)
            throws Exception {

        SecureRandom random = new SecureRandom();

        byte[] salt = new byte[SALT_LENGTH];

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
                Base64.getEncoder().encodeToString(salt);

        String encodedHash =
                Base64.getEncoder().encodeToString(hash);

        return ITERATIONS +
                ":" +
                encodedSalt +
                ":" +
                encodedHash;
    }


    /*
     * Verify password against stored PBKDF2 hash
     */
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
                Base64.getDecoder().decode(parts[1]);

        byte[] expectedHash =
                Base64.getDecoder().decode(parts[2]);

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


    /*
     * Constant-time comparison
     */
    private boolean constantTimeEquals(
            byte[] a,
            byte[] b) {

        if (a.length != b.length) {
            return false;
        }

        int result = 0;

        for (int i = 0; i < a.length; i++) {
            result |= a[i] ^ b[i];
        }

        return result == 0;
    }
}