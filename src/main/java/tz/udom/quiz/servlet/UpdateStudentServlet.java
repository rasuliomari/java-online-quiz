package tz.udom.quiz.servlet;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.Date;
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
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/updateStudent")
public class UpdateStudentServlet extends HttpServlet {

/*
 * =========================================================
 * PBKDF2 SETTINGS
 * =========================================================
 *
 * IMPORTANT:
 * These settings must match the password format used by
 * StudentRegisterServlet/LoginServlet.
 */

private static final int ITERATIONS = 65536;

private static final int KEY_LENGTH = 256;

private static final int SALT_LENGTH = 16;



/*
 * =========================================================
 * POST
 * =========================================================
 */

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {


    /*
     * =====================================================
     * ADMIN AUTHENTICATION
     * =====================================================
     */

    HttpSession session =
            request.getSession(false);


    if (session == null
            || !Boolean.TRUE.equals(
                    session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(
                    session.getAttribute("userRole"))) {

        response.sendRedirect("login.jsp");

        return;
    }



    /*
     * =====================================================
     * GET FORM DATA
     * =====================================================
     */

    String studentIdParameter =
            request.getParameter("studentId");

    String firstName =
            request.getParameter("firstName");

    String middleName =
            request.getParameter("middleName");

    String lastName =
            request.getParameter("lastName");

    String gender =
            request.getParameter("gender");

    String dateOfBirthParameter =
            request.getParameter("dateOfBirth");

    String registrationNumber =
            request.getParameter("registrationNumber");

    String college =
            request.getParameter("college");

    String programme =
            request.getParameter("programme");

    String yearOfStudyParameter =
            request.getParameter("yearOfStudy");

    String email =
            request.getParameter("email");

    String phone =
            request.getParameter("phone");


    /*
     * Password fields
     *
     * DO NOT trim passwords.
     * Spaces can technically be part of a password.
     */

    String newPassword =
            request.getParameter("newPassword");

    String confirmPassword =
            request.getParameter("confirmPassword");



    /*
     * =====================================================
     * BASIC VALIDATION
     * =====================================================
     */

    if (studentIdParameter == null
            || studentIdParameter.trim().isEmpty()) {

        response.sendRedirect(
                "admin/manage-students.jsp?error=invalid_student");

        return;
    }


    int studentId;

    try {

        studentId =
                Integer.parseInt(studentIdParameter);

    } catch (NumberFormatException e) {

        response.sendRedirect(
                "admin/manage-students.jsp?error=invalid_student");

        return;
    }



    if (firstName == null
            || firstName.trim().isEmpty()
            || lastName == null
            || lastName.trim().isEmpty()
            || gender == null
            || gender.trim().isEmpty()
            || dateOfBirthParameter == null
            || dateOfBirthParameter.trim().isEmpty()
            || registrationNumber == null
            || registrationNumber.trim().isEmpty()
            || college == null
            || college.trim().isEmpty()
            || programme == null
            || programme.trim().isEmpty()
            || yearOfStudyParameter == null
            || yearOfStudyParameter.trim().isEmpty()
            || email == null
            || email.trim().isEmpty()
            || phone == null
            || phone.trim().isEmpty()) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");

        return;
    }



    /*
     * =====================================================
     * VALIDATE GENDER
     * =====================================================
     */

    gender =
            gender.trim().toUpperCase();


    if (!"MALE".equals(gender)
            && !"FEMALE".equals(gender)) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");

        return;
    }



    /*
     * =====================================================
     * VALIDATE YEAR OF STUDY
     * =====================================================
     */

    int yearOfStudy;

    try {

        yearOfStudy =
                Integer.parseInt(
                        yearOfStudyParameter);

    } catch (NumberFormatException e) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");

        return;
    }


    if (yearOfStudy < 1
            || yearOfStudy > 4) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");

        return;
    }



    /*
     * =====================================================
     * DATE OF BIRTH
     * =====================================================
     */

    Date dateOfBirth;

    try {

        dateOfBirth =
                Date.valueOf(
                        dateOfBirthParameter);

    } catch (IllegalArgumentException e) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");

        return;
    }



    /*
     * =====================================================
     * NORMALIZE NON-PASSWORD VALUES
     * =====================================================
     */

    firstName =
            firstName.trim();

    lastName =
            lastName.trim();

    registrationNumber =
            registrationNumber.trim();

    college =
            college.trim();

    programme =
            programme.trim();

    email =
            email.trim();

    phone =
            phone.trim();


    if (middleName != null) {

        middleName =
                middleName.trim();

    }



    /*
     * =====================================================
     * PASSWORD VALIDATION
     * =====================================================
     *
     * Empty new password:
     *
     *     Keep current password.
     *
     * Non-empty new password:
     *
     *     Require confirmation.
     *     Check length.
     *     Check equality.
     */

    boolean changePassword =
            newPassword != null
            && !newPassword.isEmpty();


    if (changePassword) {


        if (confirmPassword == null
                || confirmPassword.isEmpty()) {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=password_required");

            return;
        }


        if (newPassword.length() < 8) {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=password_short");

            return;
        }


        if (!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=password_mismatch");

            return;
        }

    }



    /*
     * =====================================================
     * DATABASE UPDATE
     * =====================================================
     */

    String normalUpdateSql =
            "UPDATE students SET " +
            "first_name = ?, " +
            "middle_name = ?, " +
            "last_name = ?, " +
            "gender = ?, " +
            "date_of_birth = ?, " +
            "registration_number = ?, " +
            "college = ?, " +
            "programme = ?, " +
            "year_of_study = ?, " +
            "email = ?, " +
            "phone = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE id = ?";


    String passwordUpdateSql =
            "UPDATE students SET " +
            "first_name = ?, " +
            "middle_name = ?, " +
            "last_name = ?, " +
            "gender = ?, " +
            "date_of_birth = ?, " +
            "registration_number = ?, " +
            "college = ?, " +
            "programme = ?, " +
            "year_of_study = ?, " +
            "email = ?, " +
            "phone = ?, " +
            "password_hash = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE id = ?";



    try (Connection connection =
                 DBConnection.getConnection()) {


        int rowsUpdated;


        /*
         * =================================================
         * CHANGE PASSWORD
         * =================================================
         */

        if (changePassword) {


            String passwordHash =
                    hashPassword(newPassword);


            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 passwordUpdateSql)) {


                statement.setString(
                        1,
                        firstName);

                statement.setString(
                        2,
                        middleName == null
                                || middleName.isEmpty()
                                ? null
                                : middleName);

                statement.setString(
                        3,
                        lastName);

                statement.setString(
                        4,
                        gender);

                statement.setDate(
                        5,
                        dateOfBirth);

                statement.setString(
                        6,
                        registrationNumber);

                statement.setString(
                        7,
                        college);

                statement.setString(
                        8,
                        programme);

                statement.setInt(
                        9,
                        yearOfStudy);

                statement.setString(
                        10,
                        email);

                statement.setString(
                        11,
                        phone);

                statement.setString(
                        12,
                        passwordHash);

                statement.setInt(
                        13,
                        studentId);


                rowsUpdated =
                        statement.executeUpdate();
            }


        } else {


            /*
             * =============================================
             * UPDATE WITHOUT CHANGING PASSWORD
             * =============================================
             */

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 normalUpdateSql)) {


                statement.setString(
                        1,
                        firstName);

                statement.setString(
                        2,
                        middleName == null
                                || middleName.isEmpty()
                                ? null
                                : middleName);

                statement.setString(
                        3,
                        lastName);

                statement.setString(
                        4,
                        gender);

                statement.setDate(
                        5,
                        dateOfBirth);

                statement.setString(
                        6,
                        registrationNumber);

                statement.setString(
                        7,
                        college);

                statement.setString(
                        8,
                        programme);

                statement.setInt(
                        9,
                        yearOfStudy);

                statement.setString(
                        10,
                        email);

                statement.setString(
                        11,
                        phone);

                statement.setInt(
                        12,
                        studentId);


                rowsUpdated =
                        statement.executeUpdate();
            }

        }



        /*
         * =================================================
         * CHECK RESULT
         * =================================================
         */

        if (rowsUpdated == 1) {

            response.sendRedirect(
                    "admin/view-student.jsp?id="
                            + studentId
                            + "&updated=success");

        } else {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=update_failed");
        }


    } catch (SQLException e) {


        /*
         * PostgreSQL duplicate key
         *
         * 23505 = unique_violation
         */

        if ("23505".equals(
                e.getSQLState())) {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=duplicate");

        } else {

            e.printStackTrace();

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                            + studentId
                            + "&error=update_failed");
        }


    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                        + studentId
                        + "&error=update_failed");
    }

}



/*
 * =========================================================
 * PASSWORD HASHING
 * =========================================================
 *
 * Format:
 *
 * iterations:salt:hash
 *
 * Example:
 *
 * 65536:Base64Salt:Base64Hash
 *
 */

private String hashPassword(
        String password)
        throws Exception {


    /*
     * Generate random salt
     */

    SecureRandom secureRandom =
            new SecureRandom();

    byte[] salt =
            new byte[SALT_LENGTH];

    secureRandom.nextBytes(salt);



    /*
     * Create password specification
     */

    PBEKeySpec keySpec =
            new PBEKeySpec(
                    password.toCharArray(),
                    salt,
                    ITERATIONS,
                    KEY_LENGTH);



    try {

        /*
         * PBKDF2-HMAC-SHA256
         */

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256");


        byte[] hash =
                factory.generateSecret(
                        keySpec)
                       .getEncoded();



        /*
         * Convert salt and hash
         * to Base64
         */

        String saltBase64 =
                Base64.getEncoder()
                      .encodeToString(salt);

        String hashBase64 =
                Base64.getEncoder()
                      .encodeToString(hash);



        /*
         * Store:
         *
         * iterations:salt:hash
         */

        return ITERATIONS
                + ":"
                + saltBase64
                + ":"
                + hashBase64;


    } finally {

        /*
         * Clear password from memory
         */

        keySpec.clearPassword();
    }

}

}
