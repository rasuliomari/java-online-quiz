
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
import tz.udom.quiz.util.DBConnection;

@WebServlet("/updateQuestion")
public class UpdateQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // GET FORM VALUES
        // =====================================================

        String quizIdValue =
                request.getParameter("quizId");

        String questionIdValue =
                request.getParameter("questionId");

        String questionNumberValue =
                request.getParameter("questionNumber");

        String questionText =
                request.getParameter("questionText");

        String answerA =
                request.getParameter("answerA");

        String answerB =
                request.getParameter("answerB");

        String answerC =
                request.getParameter("answerC");

        String answerD =
                request.getParameter("answerD");

        String correctAnswer =
                request.getParameter("correctAnswer");


        // =====================================================
        // BASIC VALIDATION
        // =====================================================

        if (quizIdValue == null
                || questionIdValue == null
                || questionNumberValue == null
                || questionText == null
                || answerA == null
                || answerB == null
                || answerC == null
                || answerD == null
                || correctAnswer == null) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "All question information is required."
            );

            return;
        }


        if (questionText.trim().isEmpty()
                || answerA.trim().isEmpty()
                || answerB.trim().isEmpty()
                || answerC.trim().isEmpty()
                || answerD.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Question and all four answers are required."
            );

            return;
        }


        // =====================================================
        // CONVERT IDS
        // =====================================================

        int quizId;
        int questionId;
        int questionNumber;

        try {

            quizId =
                    Integer.parseInt(quizIdValue);

            questionId =
                    Integer.parseInt(questionIdValue);

            questionNumber =
                    Integer.parseInt(questionNumberValue);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid quiz ID, question ID or question number."
            );

            return;
        }


        // =====================================================
        // VALIDATE CORRECT ANSWER
        // =====================================================

        correctAnswer =
                correctAnswer.trim().toUpperCase();

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

            // =================================================
            // DATABASE CONNECTION
            // =================================================

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);


            // =================================================
            // VERIFY QUESTION BELONGS TO QUIZ
            // =================================================

            String verifySql =
                    "SELECT id FROM questions " +
                    "WHERE id = ? AND quiz_id = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(verifySql)
            ) {

                statement.setInt(1, questionId);
                statement.setInt(2, quizId);


                try (
                    var resultSet =
                            statement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Question was not found in this quiz."
                        );

                        return;
                    }
                }
            }


            // =================================================
            // UPDATE QUESTION
            // =================================================

            String updateQuestionSql =
                    "UPDATE questions " +
                    "SET question_text = ?, " +
                    "question_number = ? " +
                    "WHERE id = ? AND quiz_id = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                updateQuestionSql
                        )
            ) {

                statement.setString(
                        1,
                        questionText.trim()
                );

                statement.setInt(
                        2,
                        questionNumber
                );

                statement.setInt(
                        3,
                        questionId
                );

                statement.setInt(
                        4,
                        quizId
                );

                statement.executeUpdate();
            }


            // =================================================
            // UPDATE ANSWER A
            // =================================================

            String updateAnswerSql =
                    "UPDATE answers " +
                    "SET answer_text = ?, is_correct = ? " +
                    "WHERE question_id = ? AND option_label = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                updateAnswerSql
                        )
            ) {

                // Answer A

                statement.setString(
                        1,
                        answerA.trim()
                );

                statement.setBoolean(
                        2,
                        correctAnswer.equals("A")
                );

                statement.setInt(
                        3,
                        questionId
                );

                statement.setString(
                        4,
                        "A"
                );

                statement.executeUpdate();


                // Answer B

                statement.setString(
                        1,
                        answerB.trim()
                );

                statement.setBoolean(
                        2,
                        correctAnswer.equals("B")
                );

                statement.setInt(
                        3,
                        questionId
                );

                statement.setString(
                        4,
                        "B"
                );

                statement.executeUpdate();


                // Answer C

                statement.setString(
                        1,
                        answerC.trim()
                );

                statement.setBoolean(
                        2,
                        correctAnswer.equals("C")
                );

                statement.setInt(
                        3,
                        questionId
                );

                statement.setString(
                        4,
                        "C"
                );

                statement.executeUpdate();


                // Answer D

                statement.setString(
                        1,
                        answerD.trim()
                );

                statement.setBoolean(
                        2,
                        correctAnswer.equals("D")
                );

                statement.setInt(
                        3,
                        questionId
                );

                statement.setString(
                        4,
                        "D"
                );

                statement.executeUpdate();
            }


            // =================================================
            // COMMIT
            // =================================================

            connection.commit();


            // =================================================
            // RETURN TO REVIEW PAGE
            // =================================================

            response.sendRedirect(
                    "teacher/review-quiz.jsp?quizId="
                    + quizId
            );


        } catch (SQLException e) {

            // =================================================
            // ROLLBACK
            // =================================================

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
                    "Database error while updating the question."
            );


        } finally {

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
