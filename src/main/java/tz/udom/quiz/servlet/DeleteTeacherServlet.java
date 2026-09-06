package tz.udom.quiz.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/deleteTeacher")
public class DeleteTeacherServlet extends HttpServlet {

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
         * GET TEACHER ID
         * ==========================================================
         */

        String teacherIdParam =
                request.getParameter("teacherId");

        int teacherId;

        try {

            teacherId =
                    Integer.parseInt(teacherIdParam);

        } catch (Exception e) {

            redirectError(
                    request,
                    response,
                    "Invalid teacher ID."
            );

            return;
        }


        /*
         * ==========================================================
         * DELETE TEACHER
         * ==========================================================
         */

        String deleteSql =
                "DELETE FROM teachers WHERE id = ?";


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(deleteSql)) {

            statement.setInt(1, teacherId);

            int rowsDeleted =
                    statement.executeUpdate();


            if (rowsDeleted == 1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/manage-teachers.jsp"
                        + "?status=success"
                        + "&message="
                        + URLEncoder.encode(
                                "Teacher account permanently deleted.",
                                StandardCharsets.UTF_8
                        )
                );

                return;
            }


            redirectError(
                    request,
                    response,
                    "Teacher account was not found."
            );


        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "An error occurred while deleting the teacher account."
            );
        }
    }


    /*
     * ==========================================================
     * ERROR REDIRECT
     * ==========================================================
     */

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-teachers.jsp"
                + "?status=error"
                + "&message="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}