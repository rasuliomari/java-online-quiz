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

@WebServlet("/deleteCourse")
public class DeleteCourseServlet extends HttpServlet {

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

        String courseIdText =
                request.getParameter("courseId");

        if (courseIdText == null ||
                courseIdText.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_course"
            );
            return;
        }

        int courseId;

        try {

            courseId = Integer.parseInt(courseIdText);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_course"
            );
            return;
        }

        try (Connection connection =
                     DBConnection.getConnection()) {

            /*
             * Check whether the course is assigned
             * to any teacher.
             */
            String teacherCheck =
                    "SELECT COUNT(*) "
                            + "FROM teacher_courses "
                            + "WHERE course_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(teacherCheck)) {

                statement.setInt(1, courseId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next() &&
                            resultSet.getInt(1) > 0) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/admin/manage-courses.jsp?error=course_assigned"
                        );
                        return;
                    }
                }
            }


            /*
             * Check whether the course is used
             * by any quiz.
             */
            String quizCheck =
                    "SELECT COUNT(*) "
                            + "FROM quizzes "
                            + "WHERE course_id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(quizCheck)) {

                statement.setInt(1, courseId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next() &&
                            resultSet.getInt(1) > 0) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/admin/manage-courses.jsp?error=course_used_quiz"
                        );
                        return;
                    }
                }
            }


            /*
             * Delete the course.
             */
            String deleteSql =
                    "DELETE FROM courses WHERE id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(deleteSql)) {

                statement.setInt(1, courseId);

                int rows =
                        statement.executeUpdate();

                if (rows == 0) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/manage-courses.jsp?error=course_not_found"
                    );
                    return;
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?success=course_deleted"
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=course_delete_failed"
            );
        }
    }
}