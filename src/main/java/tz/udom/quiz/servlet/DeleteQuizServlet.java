package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/deleteQuiz")
public class DeleteQuizServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);

        if (session == null
                || !Boolean.TRUE.equals(
                        session.getAttribute("adminLoggedIn"))
                || !"ADMIN".equals(
                        session.getAttribute("userRole"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get quiz ID
        String quizIdParameter =
                request.getParameter("quizId");

        if (quizIdParameter == null
                || quizIdParameter.trim().isEmpty()) {

            response.sendRedirect(
                    "admin/manage-quizzes.jsp?error=invalid_quiz");

            return;
        }

        int quizId;

        try {

            quizId = Integer.parseInt(
                    quizIdParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "admin/manage-quizzes.jsp?error=invalid_quiz");

            return;
        }

        String deleteSql =
                "DELETE FROM quizzes WHERE id = ?";

        try (Connection conn =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     conn.prepareStatement(deleteSql)) {

            ps.setInt(1, quizId);

            int rowsDeleted =
                    ps.executeUpdate();

            if (rowsDeleted == 1) {

                response.sendRedirect(
                        "admin/manage-quizzes.jsp?deleted=success");

            } else {

                response.sendRedirect(
                        "admin/manage-quizzes.jsp?error=not_found");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "admin/manage-quizzes.jsp?error=delete_failed");
        }
    }
}