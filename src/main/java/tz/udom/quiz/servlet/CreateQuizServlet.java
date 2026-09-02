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

@WebServlet("/createQuiz")
public class CreateQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get values from the Create Quiz form
        String title = request.getParameter("quizTitle");
        String course = request.getParameter("course");
        String description = request.getParameter("description");
        String durationValue = request.getParameter("duration");
        String questionCountValue = request.getParameter("questionCount");
        String passMarkValue = request.getParameter("passMark");

        // Basic validation
        if (title == null || title.trim().isEmpty()
                || course == null || course.trim().isEmpty()
                || durationValue == null || durationValue.trim().isEmpty()
                || questionCountValue == null || questionCountValue.trim().isEmpty()
                || passMarkValue == null || passMarkValue.trim().isEmpty()) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,  "Please fill in all required quiz fields."
            );
            return;
        }

        try {

            int duration = Integer.parseInt(durationValue);
            int questionCount = Integer.parseInt(questionCountValue);
            int passMark = Integer.parseInt(passMarkValue);

            String sql = """
                    INSERT INTO quizzes
                    (title, course, description, duration_minutes,
                     question_count, pass_mark, status)
                    VALUES (?, ?, ?, ?, ?, ?, 'DRAFT')
                    RETURNING id
                    """;

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {

                statement.setString(1, title.trim());
                statement.setString(2, course.trim());
                statement.setString(3, description != null ? description.trim() : "");
                statement.setInt(4, duration);
                statement.setInt(5, questionCount);
                statement.setInt(6, passMark);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (resultSet.next()) {

                        int quizId = resultSet.getInt("id");

                        // Send the newly-created quiz ID
                        // to the Add Questions page.
                        response.sendRedirect(
                                "teacher/add-questions.jsp?quizId=" + quizId
                        );

                    } else {

                        response.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Quiz could not be created."
                        );
                    }
                }
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Duration, question count and pass mark must be valid numbers."
            );

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while creating the quiz."
            );
        }
    }
}