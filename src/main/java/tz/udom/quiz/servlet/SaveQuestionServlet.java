
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

@WebServlet("/saveQuestion")
public class SaveQuestionServlet extends HttpServlet {

    @Override
    protected void doPost( HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get values from the form
        String quizIdValue = request.getParameter("quizId");
        String questionNumberValue = request.getParameter("questionNumber");
        String questionText = request.getParameter("questionText");

        String answerA = request.getParameter("answerA");
        String answerB = request.getParameter("answerB");
        String answerC = request.getParameter("answerC");
        String answerD = request.getParameter("answerD");

        String correctAnswer = request.getParameter("correctAnswer");

        // Check required fields
        if (quizIdValue == null || questionNumberValue == null
                || questionText == null
                || answerA == null
                || answerB == null
                || answerC == null
                || answerD == null
                || correctAnswer == null) {

            response.sendError( HttpServletResponse.SC_BAD_REQUEST,  "Please provide all question and answer information."
            );
            return;
        }

        // Check empty fields
        if (questionText.trim().isEmpty()
                || answerA.trim().isEmpty()
                || answerB.trim().isEmpty()
                || answerC.trim().isEmpty()
                || answerD.trim().isEmpty()
                || correctAnswer.trim().isEmpty()) {

            response.sendError( HttpServletResponse.SC_BAD_REQUEST, "Question and all four answers are required."
            );
            return;
        }

        int quizId;
        int questionNumber;

        try {
            quizId = Integer.parseInt(quizIdValue);
            questionNumber = Integer.parseInt(questionNumberValue);
        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid quiz ID or question number."
            );
            return;
        }

        // Only A, B, C or D are allowed
        correctAnswer = correctAnswer.trim().toUpperCase();

        if (!correctAnswer.equals("A")
                && !correctAnswer.equals("B")
                && !correctAnswer.equals("C")
                && !correctAnswer.equals("D")) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Correct answer must be A, B, C or D."
            );
            return;
        }

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            // Start transaction
            connection.setAutoCommit(false);

            /*
             * ---------------------------------------------------------
             * STEP 1:
             * Check whether the quiz exists and get the allowed
             * number of questions.
             * ---------------------------------------------------------
             */
            String quizSql =
                    "SELECT question_count FROM quizzes WHERE id = ?";

            int allowedQuestions;

            try (PreparedStatement statement =
                         connection.prepareStatement(quizSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Quiz was not found."
                        );
                        return;
                    }

                    allowedQuestions =
                            resultSet.getInt("question_count");
                }
            }

            /*
             * ---------------------------------------------------------
             * STEP 2:
             * Check how many questions already exist.
             * ---------------------------------------------------------
             */
            String countSql =
                    "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

            int existingQuestions;

            try (PreparedStatement statement =
                         connection.prepareStatement(countSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    resultSet.next();
                    existingQuestions = resultSet.getInt(1);
                }
            }

            /*
             * Prevent adding more questions than specified
             * when the quiz was created.
             */
            if (existingQuestions >= allowedQuestions) {

                connection.rollback();

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "The quiz already has the maximum number of questions."
                );
                return;
            }

            /*
             * ---------------------------------------------------------
             * STEP 3:
             * Insert the question.
             * ---------------------------------------------------------
             */
            String questionSql =
                    "INSERT INTO questions "
                    + "(quiz_id, question_text, question_number) "
                    + "VALUES (?, ?, ?) RETURNING id";

            int questionId;

            try (PreparedStatement statement =
                         connection.prepareStatement(questionSql)) {

                statement.setInt(1, quizId);
                statement.setString(2, questionText.trim());
                statement.setInt(3, questionNumber);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Question could not be saved."
                        );
                        return;
                    }

                    questionId = resultSet.getInt("id");
                }
            }

            /*
             * ---------------------------------------------------------
             * STEP 4:
             * Insert the four answers.
             * ---------------------------------------------------------
             */
            String answerSql =
                    "INSERT INTO answers "
                    + "(question_id, option_label, answer_text, is_correct) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement statement =
                         connection.prepareStatement(answerSql)) {

                // Answer A
                statement.setInt(1, questionId);
                statement.setString(2, "A");
                statement.setString(3, answerA.trim());
                statement.setBoolean(
                        4,
                        correctAnswer.equals("A")
                );
                statement.executeUpdate();

                // Answer B
                statement.setInt(1, questionId);
                statement.setString(2, "B");
                statement.setString(3, answerB.trim());
                statement.setBoolean(
                        4,
                        correctAnswer.equals("B")
                );
                statement.executeUpdate();

                // Answer C
                statement.setInt(1, questionId);
                statement.setString(2, "C");
                statement.setString(3, answerC.trim());
                statement.setBoolean(
                        4,
                        correctAnswer.equals("C")
                );
                statement.executeUpdate();

                // Answer D
                statement.setInt(1, questionId);
                statement.setString(2, "D");
                statement.setString(3, answerD.trim());
                statement.setBoolean(
                        4,
                        correctAnswer.equals("D")
                );
                statement.executeUpdate();
            }

            /*
             * ---------------------------------------------------------
             * STEP 5:
             * Everything succeeded, so save the transaction.
             * ---------------------------------------------------------
             */
            connection.commit();

            /*
             * Return to the Add Questions page.
             * The next question number will be calculated there.
             */
            response.sendRedirect(
                    "teacher/add-questions.jsp?quizId=" + quizId
            );

        } catch (SQLException e) {

            /*
             * If anything goes wrong, undo all database changes.
             */
            if (connection != null) {

                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while saving the question."
            );

        } finally {

            /*
             * Close the database connection.
             */
            if (connection != null) {

                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

