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

        // =========================================================
        // GET FORM VALUES
        // =========================================================

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
        String terms = request.getParameter("terms");

        // =========================================================
        // PRESERVE ENTERED VALUES
        // =========================================================

        request.setAttribute("firstName", firstName);
        request.setAttribute("middleName", middleName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("gender", gender);
        request.setAttribute("dateOfBirth", dateOfBirth);
        request.setAttribute("registrationNumber", registrationNumber);
        request.setAttribute("college", college);
        request.setAttribute("programme", programme);
        request.setAttribute("yearOfStudy", yearOfStudy);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);

        // =========================================================
        // REQUIRED FIELD VALIDATION
        // =========================================================

        if (isEmpty(firstName)) {
            returnError(
                    request,
                    response,
                    "firstNameError",
                    "First name is required."
            );
            return;
        }

        if (isEmpty(lastName)) {
            returnError(
                    request,
                    response,
                    "lastNameError",
                    "Last name is required."
            );
            return;
        }

        if (isEmpty(gender)) {
            returnError(
                    request,
                    response,
                    "genderError",
                    "Please select your gender."
            );
            return;
        }

        if (isEmpty(dateOfBirth)) {
            returnError(
                    request,
                    response,
                    "dateOfBirthError",
                    "Date of birth is required."
            );
            return;
        }

        if (isEmpty(registrationNumber)) {
            returnError(
                    request,
                    response,
                    "registrationNumberError",
                    "Registration number is required."
            );
            return;
        }

        if (isEmpty(college)) {
            returnError(
                    request,
                    response,
                    "collegeError",
                    "Please select your college or school."
            );
            return;
        }

        if (isEmpty(programme)) {
            returnError(
                    request,
                    response,
                    "programmeError",
                    "Programme is required."
            );
            return;
        }

        if (isEmpty(yearOfStudy)) {
            returnError(
                    request,
                    response,
                    "yearOfStudyError",
                    "Please select your year of study."
            );
            return;
        }

        if (isEmpty(email)) {
            returnError(
                    request,
                    response,
                    "emailError",
                    "Email address is required."
            );
            return;
        }

        if (isEmpty(phone)) {
            returnError(
                    request,
                    response,
                    "phoneError",
                    "Phone number is required."
            );
            return;
        }

        if (isEmpty(password)) {
            returnError(
                    request,
                    response,
                    "passwordError",
                    "Password is required."
            );
            return;
        }

        if (isEmpty(confirmPassword)) {
            returnError(
                    request,
                    response,
                    "confirmPasswordError",
                    "Please confirm your password."
            );
            return;
        }

        // =========================================================
        // TERMS VALIDATION
        // =========================================================

        if (terms == null) {
            returnError(
                    request,
                    response,
                    "termsError",
                    "You must confirm that the information provided is accurate."
            );
            return;
        }

        // =========================================================
        // PASSWORD VALIDATION
        // =========================================================

        if (password.length() < 8) {

            returnError(
                    request,
                    response,
                    "passwordError",
                    "Password must be at least 8 characters long."
            );

            return;
        }

        if (!password.equals(confirmPassword)) {

            returnError(
                    request,
                    response,
                    "confirmPasswordError",
                    "Passwords do not match."
            );

            return;
        }

        // =========================================================
        // GENDER VALIDATION
        // =========================================================

        if (!gender.equals("MALE") && !gender.equals("FEMALE")) {

            returnError(
                    request,
                    response,
                    "genderError",
                    "Please select a valid gender."
            );

            return;
        }

        // =========================================================
        // YEAR VALIDATION
        // =========================================================

        int year;

        try {

            year = Integer.parseInt(yearOfStudy);

            if (year < 1 || year > 4) {

                returnError(
                        request,
                        response,
                        "yearOfStudyError",
                        "Please select a valid year of study."
                );

                return;
            }

        } catch (NumberFormatException e) {

            returnError(
                    request,
                    response,
                    "yearOfStudyError",
                    "Please select a valid year of study."
            );

            return;
        }

        // =========================================================
        // DATE VALIDATION
        // =========================================================

        java.sql.Date sqlDate;

        try {

            sqlDate = java.sql.Date.valueOf(dateOfBirth);

        } catch (IllegalArgumentException e) {

            returnError(
                    request,
                    response,
                    "dateOfBirthError",
                    "Please enter a valid date of birth."
            );

            return;
        }

        // =========================================================
        // EMAIL FORMAT VALIDATION
        // =========================================================

        String cleanEmail = email.trim().toLowerCase();

        if (!cleanEmail.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            returnError(
                    request,
                    response,
                    "emailError",
                    "Please enter a valid email address."
            );

            return;
        }

        // =========================================================
        // HASH PASSWORD
        // =========================================================

        String passwordHash;

        try {

            passwordHash = hashPassword(password);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "generalError",
                    "Unable to process registration. Please try again."
            );

            forwardToRegistration(request, response);

            return;
        }

        // =========================================================
        // INSERT STUDENT
        // =========================================================

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
                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    firstName.trim()
            );

            if (middleName == null
                    || middleName.trim().isEmpty()) {

                statement.setNull(
                        2,
                        java.sql.Types.VARCHAR
                );

            } else {

                statement.setString(
                        2,
                        middleName.trim()
                );
            }

            statement.setString(
                    3,
                    lastName.trim()
            );

            statement.setString(
                    4,
                    gender
            );

            statement.setDate(
                    5,
                    sqlDate
            );

            statement.setString(
                    6,
                    registrationNumber.trim()
            );

            statement.setString(
                    7,
                    college.trim()
            );

            statement.setString(
                    8,
                    programme.trim()
            );

            statement.setInt(
                    9,
                    year
            );

            statement.setString(
                    10,
                    cleanEmail
            );

            statement.setString(
                    11,
                    phone.trim()
            );

            statement.setString(
                    12,
                    passwordHash
            );

            statement.executeUpdate();

            // =====================================================
            // SUCCESS
            // =====================================================

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp?registered=success"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            // PostgreSQL unique constraint
            if ("23505".equals(e.getSQLState())) {

                String errorMessage =
                        e.getMessage() == null
                                ? ""
                                : e.getMessage().toLowerCase();

                if (errorMessage.contains(
                        "students_email_key")) {

                    request.setAttribute(
                            "emailError",
                            "This email address is already registered."
                    );

                } else if (errorMessage.contains(
                        "students_registration_number_key")) {

                    request.setAttribute(
                            "registrationNumberError",
                            "This registration number is already registered."
                    );

                } else {

                    request.setAttribute(
                            "generalError",
                            "The email or registration number is already registered."
                    );
                }

                forwardToRegistration(
                        request,
                        response
                );

                return;
            }

            // =====================================================
            // OTHER DATABASE ERROR
            // =====================================================

            request.setAttribute(
                    "generalError",
                    "A database error occurred. Please try again."
            );

            forwardToRegistration(
                    request,
                    response
            );
        }
    }

    // =============================================================
    // DISPLAY FIELD ERROR
    // =============================================================

    private void returnError(
            HttpServletRequest request,
            HttpServletResponse response,
            String attributeName,
            String message)
            throws ServletException, IOException {

        request.setAttribute(
                attributeName,
                message
        );

        forwardToRegistration(
                request,
                response
        );
    }

    // =============================================================
    // FORWARD BACK TO REGISTRATION PAGE
    // =============================================================

    private void forwardToRegistration(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/student-registration.jsp"
        ).forward(
                request,
                response
        );
    }

    // =============================================================
    // EMPTY CHECK
    // =============================================================

    private boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }

    // =============================================================
    // PASSWORD HASHING
    // =============================================================

    private String hashPassword(String password)
            throws NoSuchAlgorithmException,
            InvalidKeySpecException {

        SecureRandom random =
                new SecureRandom();

        byte[] salt =
                new byte[SALT_LENGTH];

        random.nextBytes(salt);

        KeySpec spec =
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

        return ITERATIONS
                + ":"
                + Base64.getEncoder()
                        .encodeToString(salt)
                + ":"
                + Base64.getEncoder()
                        .encodeToString(hash);
    }
}