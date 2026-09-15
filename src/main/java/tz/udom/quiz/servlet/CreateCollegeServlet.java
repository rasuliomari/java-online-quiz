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

@WebServlet("/createCollege")
public class CreateCollegeServlet extends HttpServlet {

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

        String collegeName = request.getParameter("collegeName");

        if (collegeName == null || collegeName.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=college_required"
            );
            return;
        }

        collegeName = collegeName.trim();

        String sql =
                "INSERT INTO colleges (name) VALUES (?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, collegeName);
            statement.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?success=college_added"
            );

        } catch (SQLException e) {

            if ("23505".equals(e.getSQLState())) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=college_exists"
                );

            } else {

                e.printStackTrace();

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=college_failed"
                );
            }
        }
    }
}