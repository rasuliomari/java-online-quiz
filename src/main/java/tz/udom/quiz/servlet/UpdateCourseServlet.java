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
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/updateCourse")
public class UpdateCourseServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("adminLoggedIn") == null ||
                !(Boolean) session.getAttribute("adminLoggedIn")) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String courseIdText = request.getParameter("courseId");
        String programmeIdText = request.getParameter("programmeId");
        String yearText = request.getParameter("yearOfStudy");
        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");

        if (courseIdText == null ||
                programmeIdText == null ||
                yearText == null ||
                courseCode == null ||
                courseName == null ||
                courseIdText.trim().isEmpty() ||
                programmeIdText.trim().isEmpty() ||
                yearText.trim().isEmpty() ||
                courseCode.trim().isEmpty() ||
                courseName.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=course_required"
            );
            return;
        }

        int courseId;
        int programmeId;
        int yearOfStudy;

        try {

            courseId = Integer.parseInt(courseIdText);
            programmeId = Integer.parseInt(programmeIdText);
            yearOfStudy = Integer.parseInt(yearText);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_course_data"
            );
            return;
        }

        if (yearOfStudy < 1 || yearOfStudy > 4) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_year"
            );
            return;
        }

        courseCode = courseCode.trim().toUpperCase();
        courseName = courseName.trim();

        try (Connection connection = DBConnection.getConnection()) {

            String checkProgramme =
                    "SELECT id FROM programmes WHERE id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(checkProgramme)) {

                statement.setInt(1, programmeId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/admin/manage-courses.jsp?error=invalid_programme"
                        );
                        return;
                    }
                }
            }

            String sql =
                    "UPDATE courses "
                            + "SET programme_id = ?, "
                            + "course_code = ?, "
                            + "course_name = ?, "
                            + "year_of_study = ? "
                            + "WHERE id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setInt(1, programmeId);
                statement.setString(2, courseCode);
                statement.setString(3, courseName);
                statement.setInt(4, yearOfStudy);
                statement.setInt(5, courseId);

                int rows = statement.executeUpdate();

                if (rows == 0) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/manage-courses.jsp?error=course_not_found"
                    );
                    return;
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?success=course_updated"
                );
            }

        } catch (SQLException e) {

            if ("23505".equals(e.getSQLState())) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=course_exists"
                );

            } else {

                e.printStackTrace();

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=course_failed"
                );
            }
        }
    }
}