package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/createCourse")
public class CreateCourseServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession()
                .getAttribute("adminLoggedIn") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

            return;
        }

        String collegeIdText =
                request.getParameter("collegeId");

        String programmeIdText =
                request.getParameter("programmeId");

        String yearText =
                request.getParameter("yearOfStudy");

        String courseCode =
                request.getParameter("courseCode");

        String courseName =
                request.getParameter("courseName");


        if (collegeIdText == null ||
                programmeIdText == null ||
                yearText == null ||
                courseCode == null ||
                courseName == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/manage-courses.jsp?error=missing");

            return;
        }


        courseCode = courseCode.trim();
        courseName = courseName.trim();


        if (courseCode.isEmpty() ||
                courseName.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/manage-courses.jsp?error=empty");

            return;
        }


        try {

            int collegeId =
                    Integer.parseInt(collegeIdText);

            int programmeId =
                    Integer.parseInt(programmeIdText);

            int yearOfStudy =
                    Integer.parseInt(yearText);


            if (yearOfStudy < 1 ||
                    yearOfStudy > 4) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/manage-courses.jsp?error=year");

                return;
            }


            try (Connection connection =
                         DBConnection.getConnection()) {


                /*
                 * Verify that the selected programme
                 * actually belongs to the selected college.
                 */

                String verifySql =
                        "SELECT id " +
                        "FROM programmes " +
                        "WHERE id = ? " +
                        "AND college_id = ?";


                try (PreparedStatement ps =
                             connection.prepareStatement(verifySql)) {

                    ps.setInt(1, programmeId);
                    ps.setInt(2, collegeId);

                    try (ResultSet rs =
                                 ps.executeQuery()) {

                        if (!rs.next()) {

                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/admin/manage-courses.jsp"
                                    + "?error=programme");

                            return;
                        }
                    }
                }


                /*
                 * Insert course
                 */

                String insertSql =
                        "INSERT INTO courses " +
                        "(programme_id, course_code, " +
                        "course_name, year_of_study) " +
                        "VALUES (?, ?, ?, ?)";


                try (PreparedStatement ps =
                             connection.prepareStatement(insertSql)) {

                    ps.setInt(1, programmeId);
                    ps.setString(2, courseCode);
                    ps.setString(3, courseName);
                    ps.setInt(4, yearOfStudy);

                    ps.executeUpdate();
                }
            }


            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/manage-courses.jsp?success=created");


        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/manage-courses.jsp?error=invalid");


        } catch (SQLException e) {

            e.printStackTrace();

            /*
             * PostgreSQL duplicate constraint:
             * unique (programme_id, course_code)
             */

            if ("23505".equals(e.getSQLState())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/manage-courses.jsp?error=duplicate");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/manage-courses.jsp?error=database");
            }
        }
    }
}