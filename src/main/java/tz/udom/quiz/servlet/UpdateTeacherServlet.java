package tz.udom.quiz.servlet;

import java.io.IOException;
import java.net.URLEncoder;
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

@WebServlet("/updateTeacher")
public class UpdateTeacherServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

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


        /*
         * ==========================================================
         * GET FORM DATA
         * ==========================================================
         */

        String teacherIdParam =
                request.getParameter("teacherId");

        String firstName =
                clean(request.getParameter("firstName"));

        String middleName =
                clean(request.getParameter("middleName"));

        String lastName =
                clean(request.getParameter("lastName"));

        String staffNumber =
                clean(request.getParameter("staffNumber"));

        String college =
                clean(request.getParameter("college"));

        String department =
                clean(request.getParameter("department"));

        String email =
                clean(request.getParameter("email"));

        String phone =
                clean(request.getParameter("phone"));

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");


        /*
         * ==========================================================
         * VALIDATE TEACHER ID
         * ==========================================================
         */

        int teacherId;

        try {

            teacherId =
                    Integer.parseInt(teacherIdParam);

        } catch (Exception e) {

            redirectError(
                    request,
                    response,
                    null,
                    "Invalid teacher ID."
            );

            return;
        }


        /*
         * ==========================================================
         * VALIDATE REQUIRED FIELDS
         * ==========================================================
         */

        if (isEmpty(firstName)
                || isEmpty(lastName)
                || isEmpty(staffNumber)
                || isEmpty(college)
                || isEmpty(department)
                || isEmpty(email)
                || isEmpty(phone)) {

            redirectError(
                    request,
                    response,
                    teacherId,
                    "Please fill in all required fields."
            );

            return;
        }


        /*
         * ==========================================================
         * VALIDATE EMAIL
         * ==========================================================
         */

        if (!email.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            redirectError(
                    request,
                    response,
                    teacherId,
                    "Please enter a valid email address."
            );

            return;
        }


        /*
         * ==========================================================
         * PASSWORD VALIDATION
         *
         * Password is optional during editing.
         * Empty = keep existing password.
         * ==========================================================
         */

        boolean changePassword =
                !isEmpty(password);

        if (changePassword) {

            if (!password.equals(confirmPassword)) {

                redirectError(
                        request,
                        response,
                        teacherId,
                        "Passwords do not match."
                );

                return;
            }

            if (password.length() < 8) {

                redirectError(
                        request,
                        response,
                        teacherId,
                        "Password must contain at least 8 characters."
                );

                return;
            }
        }


        /*
         * ==========================================================
         * CHECK DUPLICATE STAFF NUMBER / EMAIL
         *
         * Ignore the current teacher.
         * ==========================================================
         */

        String duplicateSql =
                "SELECT id, staff_number, email "
                + "FROM teachers "
                + "WHERE (staff_number = ? OR email = ?) "
                + "AND id <> ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(duplicateSql)) {

            statement.setString(1, staffNumber);
            statement.setString(2, email);
            statement.setInt(3, teacherId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

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
                                teacherId,
                                "The staff number already exists."
                        );

                        return;
                    }


                    if (email.equalsIgnoreCase(
                            existingEmail)) {

                        redirectError(
                                request,
                                response,
                                teacherId,
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
                    teacherId,
                    "Unable to check existing teacher information."
            );

            return;
        }


        /*
         * ==========================================================
         * UPDATE TEACHER
         * ==========================================================
         */

        String updateSql;

        if (changePassword) {

            updateSql =
                    "UPDATE teachers SET "
                    + "first_name = ?, "
                    + "middle_name = ?, "
                    + "last_name = ?, "
                    + "staff_number = ?, "
                    + "college = ?, "
                    + "department = ?, "
                    + "email = ?, "
                    + "phone = ?, "
                    + "password_hash = ?, "
                    + "updated_at = CURRENT_TIMESTAMP "
                    + "WHERE id = ?";

        } else {

            updateSql =
                    "UPDATE teachers SET "
                    + "first_name = ?, "
                    + "middle_name = ?, "
                    + "last_name = ?, "
                    + "staff_number = ?, "
                    + "college = ?, "
                    + "department = ?, "
                    + "email = ?, "
                    + "phone = ?, "
                    + "updated_at = CURRENT_TIMESTAMP "
                    + "WHERE id = ?";
        }


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(updateSql)) {

            int index = 1;


            statement.setString(index++, firstName);


            if (isEmpty(middleName)) {

                statement.setNull(
                        index++,
                        java.sql.Types.VARCHAR
                );

            } else {

                statement.setString(
                        index++,
                        middleName
                );
            }


            statement.setString(
                    index++,
                    lastName
            );

            statement.setString(
                    index++,
                    staffNumber
            );

            statement.setString(
                    index++,
                    college
            );

            statement.setString(
                    index++,
                    department
            );

            statement.setString(
                    index++,
                    email
            );

            statement.setString(
                    index++,
                    phone
            );


            /*
             * Password only changes when the admin
             * entered a new password.
             */

            if (changePassword) {

                String passwordHash =
                        hashPassword(password);

                statement.setString(
                        index++,
                        passwordHash
                );
            }


            statement.setInt(
                    index,
                    teacherId
            );


            int rowsUpdated =
                    statement.executeUpdate();


            if (rowsUpdated == 1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/manage-teachers.jsp"
                        + "?status=success"
                        + "&message="
                        + URLEncoder.encode(
                                "Teacher information updated successfully.",
                                StandardCharsets.UTF_8
                        )
                );

                return;
            }


            redirectError(
                    request,
                    response,
                    teacherId,
                    "Teacher information could not be updated."
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    teacherId,
                    "An error occurred while updating the teacher account."
            );
        }
    }


    /*
     * ==============================================================
     * PBKDF2 PASSWORD HASHING
     * ============================================================== 
     */

    private static String hashPassword(
            String password)
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


    /*
     * ==============================================================
     * CLEAN INPUT
     * ============================================================== 
     */

    private static String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    /*
     * ==============================================================
     * EMPTY CHECK
     * ============================================================== 
     */

    private static boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }


    /*
     * ==============================================================
     * ERROR REDIRECT
     * ============================================================== 
     */

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer teacherId,
            String message)
            throws IOException {

        String destination;

        if (teacherId == null) {

            destination =
                    request.getContextPath()
                    + "/admin/manage-teachers.jsp";

        } else {

            destination =
                    request.getContextPath()
                    + "/admin/edit-teacher.jsp?id="
                    + teacherId;
        }


        response.sendRedirect(
                destination
                + (destination.contains("?") ? "&" : "?")
                + "status=error"
                + "&message="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}