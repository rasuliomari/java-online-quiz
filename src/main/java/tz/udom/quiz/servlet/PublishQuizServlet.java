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

@WebServlet("/publishQuiz")
public class PublishQuizServlet extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {


    /*
     * =====================================================
     * GET QUIZ ID
     * =====================================================
     */

    String quizIdValue =
            request.getParameter("quizId");


    if (quizIdValue == null
            || quizIdValue.trim().isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Quiz ID is required."
        );

        return;
    }


    int quizId;


    try {

        quizId =
                Integer.parseInt(quizIdValue);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid quiz ID."
        );

        return;
    }


    Connection connection = null;


    try {

        /*
         * =================================================
         * CONNECT TO DATABASE
         * =================================================
         */

        connection =
                DBConnection.getConnection();


        /*
         * =================================================
         * START TRANSACTION
         * =================================================
         */

        connection.setAutoCommit(false);


        /*
         * =================================================
         * LOAD QUIZ INFORMATION
         * =================================================
         */

        String quizSql = """
                SELECT
                    question_count,
                    status
                FROM quizzes
                WHERE id = ?
                FOR UPDATE
                """;


        int requiredQuestionCount;

        String status;


        try (PreparedStatement statement =
                     connection.prepareStatement(quizSql)) {


            statement.setInt(
                    1,
                    quizId
            );


            try (ResultSet resultSet =
                         statement.executeQuery()) {


                if (!resultSet.next()) {

                    connection.rollback();

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Quiz not found."
                    );

                    return;
                }


                requiredQuestionCount =
                        resultSet.getInt(
                                "question_count"
                        );


                status =
                        resultSet.getString(
                                "status"
                        );
            }
        }


        /*
         * =================================================
         * CHECK STATUS
         * =================================================
         */

        if (!"DRAFT".equalsIgnoreCase(status)) {

            connection.rollback();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Only draft quizzes can be published."
            );

            return;
        }


        /*
         * =================================================
         * COUNT QUESTIONS
         * =================================================
         */

        String questionCountSql = """
                SELECT COUNT(*)
                FROM questions
                WHERE quiz_id = ?
                """;


        int actualQuestionCount;


        try (PreparedStatement statement =
                     connection.prepareStatement(
                             questionCountSql)) {


            statement.setInt(
                    1,
                    quizId
            );


            try (ResultSet resultSet =
                         statement.executeQuery()) {


                resultSet.next();


                actualQuestionCount =
                        resultSet.getInt(1);
            }
        }


        /*
         * =================================================
         * CHECK QUESTION COUNT
         * =================================================
         */

        if (actualQuestionCount
                != requiredQuestionCount) {

            connection.rollback();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,

                    "Quiz cannot be published. "
                    + "Required questions: "
                    + requiredQuestionCount
                    + ", saved questions: "
                    + actualQuestionCount
            );

            return;
        }


        /*
         * =================================================
         * LOAD ALL QUESTIONS
         * =================================================
         */

        String questionsSql = """
                SELECT id
                FROM questions
                WHERE quiz_id = ?
                ORDER BY question_number ASC
                """;


        try (PreparedStatement statement =
                     connection.prepareStatement(
                             questionsSql)) {


            statement.setInt(
                    1,
                    quizId
            );


            try (ResultSet resultSet =
                         statement.executeQuery()) {


                while (resultSet.next()) {


                    int questionId =
                            resultSet.getInt("id");


                    /*
                     * =====================================
                     * COUNT ANSWERS FOR QUESTION
                     * =====================================
                     */

                    String answerCountSql = """
                            SELECT COUNT(*)
                            FROM answers
                            WHERE question_id = ?
                            """;


                    int answerCount;


                    try (PreparedStatement answerStatement =
                                 connection.prepareStatement(
                                         answerCountSql)) {


                        answerStatement.setInt(
                                1,
                                questionId
                        );


                        try (ResultSet answerResult =
                                     answerStatement.executeQuery()) {


                            answerResult.next();


                            answerCount =
                                    answerResult.getInt(1);
                        }
                    }


                    /*
                     * =====================================
                     * EVERY QUESTION MUST HAVE 4 ANSWERS
                     * =====================================
                     */

                    if (answerCount != 4) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,

                                "Question "
                                + questionId
                                + " must have exactly 4 answers."
                        );

                        return;
                    }


                    /*
                     * =====================================
                     * COUNT CORRECT ANSWERS
                     * =====================================
                     */

                    String correctAnswerSql = """
                            SELECT COUNT(*)
                            FROM answers
                            WHERE question_id = ?
                              AND is_correct = TRUE
                            """;


                    int correctAnswerCount;


                    try (PreparedStatement correctStatement =
                                 connection.prepareStatement(
                                         correctAnswerSql)) {


                        correctStatement.setInt(
                                1,
                                questionId
                        );


                        try (ResultSet correctResult =
                                     correctStatement.executeQuery()) {


                            correctResult.next();


                            correctAnswerCount =
                                    correctResult.getInt(1);
                        }
                    }


                    /*
                     * =====================================
                     * EXACTLY ONE CORRECT ANSWER
                     * =====================================
                     */

                    if (correctAnswerCount != 1) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,

                                "Question "
                                + questionId
                                + " must have exactly one correct answer."
                        );

                        return;
                    }
                }
            }
        }


        /*
         * =================================================
         * PUBLISH QUIZ
         * =================================================
         */

        String publishSql = """
                UPDATE quizzes
                SET status = 'PUBLISHED',
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """;


        try (PreparedStatement statement =
                     connection.prepareStatement(
                             publishSql)) {


            statement.setInt(
                    1,
                    quizId
            );


            int rowsUpdated =
                    statement.executeUpdate();


            if (rowsUpdated != 1) {

                connection.rollback();

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Quiz could not be published."
                );

                return;
            }
        }


        /*
         * =================================================
         * COMMIT
         * =================================================
         */

        connection.commit();


        /*
         * =================================================
         * REDIRECT TO DASHBOARD
         * =================================================
         */

        response.sendRedirect(
                "teacher/dashboard.jsp?published=success"
        );


    } catch (SQLException e) {


        /*
         * =================================================
         * ROLLBACK
         * =================================================
         */

        if (connection != null) {

            try {

                connection.rollback();

            } catch (SQLException rollbackException) {

                rollbackException.printStackTrace();
            }
        }


        e.printStackTrace();


        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Database error while publishing the quiz."
        );


    } finally {


        /*
         * =================================================
         * CLOSE CONNECTION
         * =================================================
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
