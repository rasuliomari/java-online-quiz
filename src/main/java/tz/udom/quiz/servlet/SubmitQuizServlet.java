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

@WebServlet("/submitQuiz")
public class SubmitQuizServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String quizIdValue = request.getParameter("quizId");

        if (quizIdValue == null || quizIdValue.trim().isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Quiz ID is required."
            );
            return;
        }

        int quizId;

        try {
            quizId = Integer.parseInt(quizIdValue);
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid quiz ID."
            );
            return;
        }

        int score = 0;
        int totalQuestions = 0;
        int passMark = 0;
        String quizTitle = "";

        try (Connection connection = DBConnection.getConnection()) {

            /*
             * Get quiz information.
             * Only published quizzes can be submitted.
             */
            String quizSql =
                    "SELECT title, question_count, pass_mark " +
                    "FROM quizzes " +
                    "WHERE id = ? " +
                    "AND status = 'PUBLISHED'";

            try (PreparedStatement statement =
                         connection.prepareStatement(quizSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {
                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Published quiz not found."
                        );
                        return;
                    }

                    quizTitle =
                            resultSet.getString("title");

                    passMark =
                            resultSet.getInt("pass_mark");
                }
            }

            /*
             * Get all questions and their correct answers.
             */
            String questionSql =
                    "SELECT q.id, a.option_label " +
                    "FROM questions q " +
                    "JOIN answers a " +
                    "ON q.id = a.question_id " +
                    "AND a.is_correct = TRUE " +
                    "WHERE q.quiz_id = ? " +
                    "ORDER BY q.question_number ASC";

            try (PreparedStatement statement =
                         connection.prepareStatement(questionSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    while (resultSet.next()) {

                        totalQuestions++;

                        int questionId =
                                resultSet.getInt("id");

                        String correctAnswer =
                                resultSet.getString("option_label");

                        String submittedAnswer =
                                request.getParameter(
                                        "question_" + questionId
                                );

                        /*
                         * If the student did not answer,
                         * it is counted as incorrect.
                         */
                        if (submittedAnswer != null
                                && submittedAnswer.equalsIgnoreCase(
                                        correctAnswer)) {

                            score++;
                        }
                    }
                }
            }

            /*
             * Calculate percentage.
             */
            double percentage = 0.0;

            if (totalQuestions > 0) {
                percentage =
                        ((double) score / totalQuestions) * 100.0;
            }

            /*
             * Determine whether the student passed.
             */
            boolean passed =
                    percentage >= passMark;

            /*
             * Store result temporarily in the session.
             * We will later replace this with permanent
             * database storage when student accounts/results
             * are implemented.
             */
            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "quizResultQuizId",
                    quizId
            );

            session.setAttribute(
                    "quizResultTitle",
                    quizTitle
            );

            session.setAttribute(
                    "quizResultScore",
                    score
            );

            session.setAttribute(
                    "quizResultTotal",
                    totalQuestions
            );

            session.setAttribute(
                    "quizResultPercentage",
                    percentage
            );

            session.setAttribute(
                    "quizResultPassMark",
                    passMark
            );

            session.setAttribute(
                    "quizResultPassed",
                    passed
            );

            /*
             * Redirect to result page.
             */
            response.sendRedirect(
                    "student/quiz-result.jsp"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while submitting the quiz."
            );
        }
    }
}