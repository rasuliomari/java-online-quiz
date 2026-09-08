
package tz.udom.quiz.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

        request.setCharacterEncoding("UTF-8");

        /* =====================================================
           1. CHECK TEACHER LOGIN
           ===================================================== */

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

        Integer teacherId =
                (Integer) session.getAttribute("teacherId");

        if (teacherId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=teacherLoginRequired"
            );

            return;
        }


        /* =====================================================
           2. READ FORM DATA
           ===================================================== */

        String quizIdValue =
                clean(request.getParameter("quizId"));

        String questionText =
                clean(request.getParameter("questionText"));

        String questionNumberValue =
                clean(request.getParameter("questionNumber"));

        String answerA =
                clean(request.getParameter("answerA"));

        String answerB =
                clean(request.getParameter("answerB"));

        String answerC =
                clean(request.getParameter("answerC"));

        String answerD =
                clean(request.getParameter("answerD"));

        String correctAnswer =
                clean(request.getParameter("correctAnswer"));

        String action =
                clean(request.getParameter("action"));


        /* =====================================================
           3. VALIDATE QUIZ ID
           ===================================================== */

        if (isEmpty(quizIdValue)) {

            redirectError(
                    request,
                    response,
                    "Quiz ID is required."
            );

            return;
        }

        int quizId;

        try {

            quizId = Integer.parseInt(quizIdValue);

        } catch (NumberFormatException e) {

            redirectError(
                    request,
                    response,
                    "Invalid quiz ID."
            );

            return;
        }


        /* =====================================================
           4. VALIDATE QUESTION DATA
           ===================================================== */

        if (isEmpty(questionText)
                || isEmpty(answerA)
                || isEmpty(answerB)
                || isEmpty(answerC)
                || isEmpty(answerD)
                || isEmpty(correctAnswer)) {

            redirectError(
                    request,
                    response,
                    "Please fill in the question and all four answer options."
            );

            return;
        }


        /* =====================================================
           5. VALIDATE CORRECT ANSWER
           ===================================================== */

        correctAnswer =
                correctAnswer.toUpperCase();

        if (!correctAnswer.equals("A")
                && !correctAnswer.equals("B")
                && !correctAnswer.equals("C")
                && !correctAnswer.equals("D")) {

            redirectError(
                    request,
                    response,
                    "The correct answer must be A, B, C or D."
            );

            return;
        }


        /* =====================================================
           6. DATABASE TRANSACTION
           ===================================================== */

        Connection connection = null;

        try {

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);


            /* =================================================
               7. VERIFY QUIZ OWNERSHIP AND DRAFT STATUS
               ================================================= */

            String quizSql =
                    "SELECT question_count, status "
                    + "FROM quizzes "
                    + "WHERE id = ? "
                    + "AND teacher_id = ?";

            int allowedQuestions;
            String quizStatus;

            try (PreparedStatement statement =
                         connection.prepareStatement(quizSql)) {

                statement.setInt(1, quizId);
                statement.setInt(2, teacherId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You do not have permission to modify this quiz."
                        );

                        return;
                    }

                    allowedQuestions =
                            resultSet.getInt("question_count");

                    quizStatus =
                            resultSet.getString("status");
                }
            }


            /* =================================================
               8. MAKE SURE QUIZ IS STILL A DRAFT
               ================================================= */

            if (quizStatus == null
                    || !"DRAFT".equalsIgnoreCase(quizStatus)) {

                connection.rollback();

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "This quiz is no longer in draft status and cannot be modified."
                );

                return;
            }


            /* =================================================
               9. VALIDATE QUESTION COUNT
               ================================================= */

            if (allowedQuestions < 1) {

                connection.rollback();

                redirectError(
                        request,
                        response,
                        "This quiz does not allow any questions."
                );

                return;
            }


            /* =================================================
               10. COUNT EXISTING QUESTIONS
               ================================================= */

            String countSql =
                    "SELECT COUNT(*) "
                    + "FROM questions "
                    + "WHERE quiz_id = ?";

            int existingQuestions = 0;

            try (PreparedStatement statement =
                         connection.prepareStatement(countSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next()) {

                        existingQuestions =
                                resultSet.getInt(1);
                    }
                }
            }


            /* =================================================
               11. PREVENT ADDING EXTRA QUESTIONS
               ================================================= */

            if (existingQuestions >= allowedQuestions) {

                connection.rollback();

                redirectError(
                        request,
                        response,
                        "The maximum number of questions for this quiz has already been reached."
                );

                return;
            }


            /* =================================================
               12. DETERMINE NEXT QUESTION NUMBER
               
               We intentionally ignore the question number
               sent by the browser and generate it on the
               server.
               ================================================= */

            int nextQuestionNumber =
                    existingQuestions + 1;


            /* =================================================
               13. INSERT QUESTION
               ================================================= */

            String questionSql =
                    "INSERT INTO questions "
                    + "(quiz_id, question_text, question_number) "
                    + "VALUES (?, ?, ?) "
                    + "RETURNING id";

            int questionId;

            try (PreparedStatement statement =
                         connection.prepareStatement(questionSql)) {

                statement.setInt(1, quizId);
                statement.setString(2, questionText);
                statement.setInt(3, nextQuestionNumber);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        redirectError(
                                request,
                                response,
                                "Question could not be saved."
                        );

                        return;
                    }

                    questionId =
                            resultSet.getInt("id");
                }
            }


            /* =================================================
               14. INSERT FOUR ANSWERS
               ================================================= */

            String answerSql =
                    "INSERT INTO answers "
                    + "(question_id, option_label, answer_text, is_correct) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement statement =
                         connection.prepareStatement(answerSql)) {

                /* ---------------------------------------------
                   Answer A
                   --------------------------------------------- */

                statement.setInt(1, questionId);
                statement.setString(2, "A");
                statement.setString(3, answerA);
                statement.setBoolean(
                        4,
                        "A".equals(correctAnswer)
                );

                statement.executeUpdate();


                /* ---------------------------------------------
                   Answer B
                   --------------------------------------------- */

                statement.setInt(1, questionId);
                statement.setString(2, "B");
                statement.setString(3, answerB);
                statement.setBoolean(
                        4,
                        "B".equals(correctAnswer)
                );

                statement.executeUpdate();


                /* ---------------------------------------------
                   Answer C
                   --------------------------------------------- */

                statement.setInt(1, questionId);
                statement.setString(2, "C");
                statement.setString(3, answerC);
                statement.setBoolean(
                        4,
                        "C".equals(correctAnswer)
                );

                statement.executeUpdate();


                /* ---------------------------------------------
                   Answer D
                   --------------------------------------------- */

                statement.setInt(1, questionId);
                statement.setString(2, "D");
                statement.setString(3, answerD);
                statement.setBoolean(
                        4,
                        "D".equals(correctAnswer)
                );

                statement.executeUpdate();
            }


            /* =================================================
               15. COMMIT TRANSACTION
               ================================================= */

            connection.commit();


            /* =================================================
               16. DETERMINE WHETHER QUIZ IS COMPLETE
               ================================================= */

            boolean quizComplete =
                    nextQuestionNumber >= allowedQuestions;


            /* =================================================
               17. REDIRECT AFTER SUCCESS
               ================================================= */

            if (quizComplete) {

                /*
                 * All questions have now been added.
                 * Send teacher to Review Quiz.
                 */

                response.sendRedirect(
                        request.getContextPath()
                        + "/teacher/review-quiz.jsp"
                        + "?quizId=" + quizId
                );

                return;
            }


            /*
             * Quiz still needs more questions.
             * Send teacher back to Add Questions.
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/teacher/add-questions.jsp"
                    + "?quizId=" + quizId
                    + "&status=success"
                    + "&message="
                    + URLEncoder.encode(
                            "Question saved successfully.",
                            StandardCharsets.UTF_8
                    )
            );

        } catch (SQLException e) {

            /* =================================================
               18. ROLLBACK IF DATABASE ERROR OCCURS
               ================================================= */

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (SQLException rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "A database error occurred while saving the question."
            );

        } catch (Exception e) {

            /* =================================================
               19. ROLLBACK FOR OTHER ERRORS
               ================================================= */

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (SQLException rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "An error occurred while saving the question."
            );

        } finally {

            /* =================================================
               20. CLOSE CONNECTION
               ================================================= */

            if (connection != null) {

                try {

                    connection.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }


    /* =========================================================
       CLEAN INPUT
       ========================================================= */

    private static String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    /* =========================================================
       CHECK EMPTY VALUE
       ========================================================= */

    private static boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }


    /* =========================================================
       REDIRECT WITH ERROR MESSAGE
       ========================================================= */

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/teacher/add-questions.jsp"
                + "?quizId="
                + URLEncoder.encode(
                        request.getParameter("quizId") == null
                                ? ""
                                : request.getParameter("quizId"),
                        StandardCharsets.UTF_8
                )
                + "&status=error"
                + "&message="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}
