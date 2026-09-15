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

@WebServlet("/createProgramme")
public class CreateProgrammeServlet extends HttpServlet {

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

        String collegeIdText = request.getParameter("collegeId");
        String programmeName = request.getParameter("programmeName");

        if (collegeIdText == null ||
                collegeIdText.trim().isEmpty() ||
                programmeName == null ||
                programmeName.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=programme_required"
            );
            return;
        }

        int collegeId;

        try {
            collegeId = Integer.parseInt(collegeIdText);
        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_college"
            );
            return;
        }

        programmeName = programmeName.trim();

        try (Connection connection = DBConnection.getConnection()) {

            // Verify that the college exists
            String checkCollege =
                    "SELECT id FROM colleges WHERE id = ?";

            try (PreparedStatement statement =
                         connection.prepareStatement(checkCollege)) {

                statement.setInt(1, collegeId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (!resultSet.next()) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/admin/manage-courses.jsp?error=invalid_college"
                        );
                        return;
                    }
                }
            }

            String sql =
                    "INSERT INTO programmes (college_id, name) "
                            + "VALUES (?, ?)";

            try (PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setInt(1, collegeId);
                statement.setString(2, programmeName);

                statement.executeUpdate();

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?success=programme_added"
                );
            }

        } catch (SQLException e) {

            if ("23505".equals(e.getSQLState())) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=programme_exists"
                );

            } else {

                e.printStackTrace();

                response.sendRedirect(
                        request.getContextPath()
                                + "/admin/manage-courses.jsp?error=programme_failed"
                );
            }
        }
    }
}