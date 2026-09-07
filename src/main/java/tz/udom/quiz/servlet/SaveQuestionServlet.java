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

@WebServlet("/saveQuestion")
public class SaveQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =========================================================
        // TEACHER AUTHENTICATION
        // =========================================================

        HttpSession session = request.getSession(false);

        boolean teacherLoggedIn =
                session != null
                && Boolean.TRUE.equals(
                        session.getAttribute("teacherLoggedIn")
                )
                && "TEACHER".equals(
                        session.getAttribute("userRole")
                );

        if (!teacherLoggedIn) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=teacherLoginRequired"
            );

            return;
        }


        // =========================================================
        // GET TEACHER ID FROM SESSION
        // =========================================================

        Integer teacherId =
                (Integer) session.getAttribute("teacherId");

        if (teacherId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=teacherLoginRequired"
            );

            return;
        }


        // =========================================================
        // GET FORM VALUES
        // =========================================================

        String quizIdValue =
                request.getParameter("quizId");

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

        String action =
                request.getParameter("action");


        // =========================================================
        // VALIDATE REQUIRED FIELDS
        // =========================================================

        if (quizIdValue == null
                || questionNumberValue == null
                || questionText == null
                || answerA == null
                || answerB == null
                || answerC == null
                || answerD == null
                || correctAnswer == null) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please provide all question and answer information."
            );

            return;
        }


        // =========================================================
        // VALIDATE EMPTY FIELDS
        // =========================================================

        if (questionText.trim().isEmpty()
                || answerA.trim().isEmpty()
                || answerB.trim().isEmpty()
                || answerC.trim().isEmpty()
                || answerD.trim().isEmpty()
                || correctAnswer.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Question and all four answers are required."
            );

            return;
        }


        // =========================================================
        // CONVERT IDS TO INTEGER
        // =========================================================

        int quizId;
        int questionNumber;

        try {

            quizId =
                    Integer.parseInt(quizIdValue);

            questionNumber =
                    Integer.parseInt(questionNumberValue);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid quiz ID or question number."
            );

            return;
        }


        // =========================================================
        // VALIDATE QUESTION NUMBER
        // =========================================================

        if (questionNumber < 1) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid question number."
            );

            return;
        }


        // =========================================================
        // NORMALIZE CORRECT ANSWER
        // =========================================================

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

            // =====================================================
            // CONNECT TO DATABASE
            // =====================================================

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);


            // =====================================================
            // STEP 1
            // VERIFY QUIZ OWNERSHIP AND GET QUESTION LIMIT
            // =====================================================

            /*
             * IMPORTANT:
             *
             * The teacher ID comes from the authenticated session.
             *
             * We DO NOT trust a teacherId sent from the browser.
             *
             * This makes sure that Teacher A cannot add questions
             * to Teacher B's quiz.
             */

            String quizSql =
                    "SELECT question_count " +
                    "FROM quizzes " +
                    "WHERE id = ? " +
                    "AND teacher_id = ?";

            int allowedQuestions;


            try (PreparedStatement statement =
                         connection.prepareStatement(quizSql)) {

                statement.setInt(
                        1,
                        quizId
                );

                statement.setInt(
                        2,
                        teacherId
                );


                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You are not authorized to add questions to this quiz."
                        );

                        return;
                    }


                    allowedQuestions =
                            resultSet.getInt(
                                    "question_count"
                            );
                }
            }


            // =====================================================
            // STEP 2
            // COUNT EXISTING QUESTIONS
            // =====================================================

            String countSql =
                    "SELECT COUNT(*) " +
                    "FROM questions " +
                    "WHERE quiz_id = ?";

            int existingQuestions;


            try (PreparedStatement statement =
                         connection.prepareStatement(countSql)) {

                statement.setInt(
                        1,
                        quizId
                );


                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    resultSet.next();

                    existingQuestions =
                            resultSet.getInt(1);
                }
            }


            // =====================================================
            // STEP 3
            // PREVENT EXTRA QUESTIONS
            // =====================================================

            if (existingQuestions >= allowedQuestions) {

                connection.rollback();

                /*
                 * The quiz already contains the required number
                 * of questions.
                 *
                 * Send the teacher directly to Review Quiz.
                 */

                response.sendRedirect(
                        request.getContextPath()
                        + "/teacher/review-quiz.jsp?quizId="
                        + quizId
                );

                return;
            }


            // =====================================================
            // STEP 4
            // DETERMINE CORRECT QUESTION NUMBER
            // =====================================================

            int correctQuestionNumber =
                    existingQuestions + 1;


            /*
             * We don't trust the hidden questionNumber input.
             *
             * The database determines the next question number.
             */

            questionNumber =
                    correctQuestionNumber;


            // =====================================================
            // STEP 5
            // INSERT QUESTION
            // =====================================================

            String questionSql =
                    "INSERT INTO questions " +
                    "(quiz_id, question_text, question_number) " +
                    "VALUES (?, ?, ?) " +
                    "RETURNING id";

            int questionId;


            try (PreparedStatement statement =
                         connection.prepareStatement(questionSql)) {

                statement.setInt(
                        1,
                        quizId
                );

                statement.setString(
                        2,
                        questionText.trim()
                );

                statement.setInt(
                        3,
                        questionNumber
                );


                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Question could not be saved."
                        );

                        return;
                    }


                    questionId =
                            resultSet.getInt("id");
                }
            }


            // =====================================================
            // STEP 6
            // INSERT ANSWERS
            // =====================================================

            String answerSql =
                    "INSERT INTO answers " +
                    "(question_id, option_label, answer_text, is_correct) " +
                    "VALUES (?, ?, ?, ?)";


            try (PreparedStatement statement =
                         connection.prepareStatement(answerSql)) {


                // -------------------------------------------------
                // ANSWER A
                // -------------------------------------------------

                statement.setInt(
                        1,
                        questionId
                );

                statement.setString(
                        2,
                        "A"
                );

                statement.setString(
                        3,
                        answerA.trim()
                );

                statement.setBoolean(
                        4,
                        correctAnswer.equals("A")
                );

                statement.executeUpdate();


                // -------------------------------------------------
                // ANSWER B
                // -------------------------------------------------

                statement.setInt(
                        1,
                        questionId
                );

                statement.setString(
                        2,
                        "B"
                );

                statement.setString(
                        3,
                        answerB.trim()
                );

                statement.setBoolean(
                        4,
                        correctAnswer.equals("B")
                );

                statement.executeUpdate();


                // -------------------------------------------------
                // ANSWER C
                // -------------------------------------------------

                statement.setInt(
                        1,
                        questionId
                );

                statement.setString(
                        2,
                        "C"
                );

                statement.setString(
                        3,
                        answerC.trim()
                );

                statement.setBoolean(
                        4,
                        correctAnswer.equals("C")
                );

                statement.executeUpdate();


                // -------------------------------------------------
                // ANSWER D
                // -------------------------------------------------

                statement.setInt(
                        1,
                        questionId
                );

                statement.setString(
                        2,
                        "D"
                );

                statement.setString(
                        3,
                        answerD.trim()
                );

                statement.setBoolean(
                        4,
                        correctAnswer.equals("D")
                );

                statement.executeUpdate();
            }


            // =====================================================
            // STEP 7
            // COMMIT TRANSACTION
            // =====================================================

            connection.commit();


            // =====================================================
            // STEP 8
            // DETERMINE NEXT PAGE
            // =====================================================

            int totalQuestionsAfterSave =
                    existingQuestions + 1;


            // =====================================================
            // LAST QUESTION
            // =====================================================

            if (totalQuestionsAfterSave >= allowedQuestions) {

                /*
                 * The quiz is now complete.
                 *
                 * Send the teacher directly to Review Quiz.
                 */

                response.sendRedirect(
                        request.getContextPath()
                        + "/teacher/review-quiz.jsp?quizId="
                        + quizId
                );

                return;
            }


            // =====================================================
            // MORE QUESTIONS REMAIN
            // =====================================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/teacher/add-questions.jsp?quizId="
                    + quizId
            );


        } catch (SQLException e) {


            // =====================================================
            // ROLLBACK ON DATABASE ERROR
            // =====================================================

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


            // =====================================================
            // CLOSE DATABASE CONNECTION
            // =====================================================

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