package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/updateStudent")
public class UpdateStudentServlet extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    HttpSession session =
            request.getSession(false);

    // ==============================
    // ADMIN AUTHENTICATION
    // ==============================

    if (session == null
            || !Boolean.TRUE.equals(
                    session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(
                    session.getAttribute("userRole"))) {

        response.sendRedirect("login.jsp");
        return;
    }


    // ==============================
    // CHECK ADMIN ID
    // ==============================

    Object adminIdObject =
            session.getAttribute("adminId");

    if (adminIdObject == null) {

        response.sendRedirect("login.jsp");
        return;
    }


    // ==============================
    // GET STUDENT ID
    // ==============================

    String studentIdParameter =
            request.getParameter("studentId");

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


    // ==============================
    // GET FORM DATA
    // ==============================

    String firstName =
            request.getParameter("firstName");

    String middleName =
            request.getParameter("middleName");

    String lastName =
            request.getParameter("lastName");

    String gender =
            request.getParameter("gender");

    String dateOfBirth =
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


    // ==============================
    // CLEAN INPUT
    // ==============================

    if (firstName != null) {
        firstName = firstName.trim();
    }

    if (middleName != null) {
        middleName = middleName.trim();
    }

    if (lastName != null) {
        lastName = lastName.trim();
    }

    if (gender != null) {
        gender = gender.trim().toUpperCase();
    }

    if (dateOfBirth != null) {
        dateOfBirth = dateOfBirth.trim();
    }

    if (registrationNumber != null) {
        registrationNumber =
                registrationNumber.trim();
    }

    if (college != null) {
        college = college.trim();
    }

    if (programme != null) {
        programme = programme.trim();
    }

    if (email != null) {
        email = email.trim();
    }

    if (phone != null) {
        phone = phone.trim();
    }


    // ==============================
    // VALIDATION
    // ==============================

    if (firstName == null
            || firstName.isEmpty()
            || lastName == null
            || lastName.isEmpty()
            || gender == null
            || gender.isEmpty()
            || dateOfBirth == null
            || dateOfBirth.isEmpty()
            || registrationNumber == null
            || registrationNumber.isEmpty()
            || college == null
            || college.isEmpty()
            || programme == null
            || programme.isEmpty()
            || yearOfStudyParameter == null
            || yearOfStudyParameter.isEmpty()
            || email == null
            || email.isEmpty()
            || phone == null
            || phone.isEmpty()) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                + studentId
                + "&error=invalid");

        return;
    }


    // ==============================
    // VALIDATE GENDER
    // ==============================

    if (!"MALE".equals(gender)
            && !"FEMALE".equals(gender)) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                + studentId
                + "&error=invalid");

        return;
    }


    // ==============================
    // VALIDATE YEAR
    // ==============================

    int yearOfStudy;

    try {

        yearOfStudy =
                Integer.parseInt(
                        yearOfStudyParameter);

    } catch (NumberFormatException e) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                + studentId
                + "&error=invalid");

        return;
    }


    if (yearOfStudy < 1
            || yearOfStudy > 4) {

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                + studentId
                + "&error=invalid");

        return;
    }


    // ==============================
    // UPDATE SQL
    // ==============================

    String sql =
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


    try (Connection conn =
                 DBConnection.getConnection();
         PreparedStatement ps =
                 conn.prepareStatement(sql)) {


        ps.setString(1, firstName);


        if (middleName == null
                || middleName.isEmpty()) {

            ps.setNull(
                    2,
                    java.sql.Types.VARCHAR);

        } else {

            ps.setString(
                    2,
                    middleName);
        }


        ps.setString(3, lastName);

        ps.setString(4, gender);

        ps.setDate(
                5,
                java.sql.Date.valueOf(
                        dateOfBirth));

        ps.setString(
                6,
                registrationNumber);

        ps.setString(
                7,
                college);

        ps.setString(
                8,
                programme);

        ps.setInt(
                9,
                yearOfStudy);

        ps.setString(
                10,
                email);

        ps.setString(
                11,
                phone);

        ps.setInt(
                12,
                studentId);


        int rowsUpdated =
                ps.executeUpdate();


        if (rowsUpdated == 1) {

            response.sendRedirect(
                    "admin/view-student.jsp?id="
                    + studentId
                    + "&updated=success");

        } else {

            response.sendRedirect(
                    "admin/manage-students.jsp?error=not_found");
        }


    } catch (IllegalArgumentException e) {

        // Invalid date format

        response.sendRedirect(
                "admin/edit-student.jsp?id="
                + studentId
                + "&error=invalid");


    } catch (SQLException e) {

        e.printStackTrace();

        // PostgreSQL UNIQUE violation
        // 23505 = unique_violation

        if ("23505".equals(
                e.getSQLState())) {

            response.sendRedirect(
                    "admin/edit-student.jsp?id="
                    + studentId
                    + "&error=duplicate");

        } else {

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

}
