package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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


        /*
         * Get the current student session.
         */
        HttpSession session = request.getSession();


        /*
         * ========================================================
         * PREVENT SECOND ATTEMPT
         * ========================================================
         */

        String attemptKey =
                "quizAttempted_" + quizId;

        synchronized (session) {

            if (Boolean.TRUE.equals(
                    session.getAttribute(attemptKey))) {

                response.sendRedirect(
                        "student/quiz-already-attempted.jsp?quizId="
                                + quizId
                );

                return;
            }


            /*
             * Mark this quiz as attempted BEFORE processing.
             *
             * This prevents the student from submitting the same
             * quiz twice from two requests.
             */
            session.setAttribute(
                    attemptKey,
                    Boolean.TRUE
            );
        }


        int score = 0;
        int totalQuestions = 0;
        int passMark = 0;

        String quizTitle = "";


        /*
         * Store the student's selected answers.
         *
         * Key   = question ID
         * Value = selected option A/B/C/D
         */
        Map<Integer, String> submittedAnswers =
                new LinkedHashMap<>();


        try (Connection connection =
                     DBConnection.getConnection()) {


            /*
             * ====================================================
             * GET QUIZ INFORMATION
             * ====================================================
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

                        session.removeAttribute(attemptKey);

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
             * ====================================================
             * GET QUESTIONS AND CORRECT ANSWERS
             * ====================================================
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
                                resultSet.getString(
                                        "option_label"
                                );


                        /*
                         * Get the student's selected answer.
                         */
                        String submittedAnswer =
                                request.getParameter(
                                        "question_" + questionId
                                );


                        /*
                         * Store answer for the result review.
                         */
                        if (submittedAnswer != null
                                && !submittedAnswer.trim().isEmpty()) {

                            submittedAnswers.put(
                                    questionId,
                                    submittedAnswer
                            );
                        }


                        /*
                         * Check whether answer is correct.
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
             * ====================================================
             * CALCULATE RESULT
             * ====================================================
             */

            double percentage = 0.0;


            if (totalQuestions > 0) {

                percentage =
                        ((double) score / totalQuestions)
                                * 100.0;
            }


            boolean passed =
                    percentage >= passMark;


            /*
             * ====================================================
             * STORE RESULT IN SESSION
             * ====================================================
             */

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
             * Save student's answers so the result page
             * can display exactly what the student selected.
             */
            session.setAttribute(
                    "quizSubmittedAnswers_" + quizId,
                    submittedAnswers
            );

            // ================= STORE RESULT HISTORY =================

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> resultHistory =
                    (List<Map<String, Object>>) session.getAttribute(
                            "quizResultHistory"
                    );

            if (resultHistory == null) {
                resultHistory = new ArrayList<>();
            }

            Map<String, Object> result = new HashMap<>();

            result.put("quizId", quizId);
            result.put("title", quizTitle);
            result.put("score", score);
            result.put("total", totalQuestions);
            result.put("percentage", percentage);
            result.put("passed", passed);
            result.put("passMark", passMark);

            resultHistory.add(0, result);

            // Keep only the latest 10 results
            if (resultHistory.size() > 10) {
                resultHistory =
                        new ArrayList<>(
                                resultHistory.subList(0, 10)
                        );
            }

            session.setAttribute(
                    "quizResultHistory",
                    resultHistory
            );


            /*
             * ====================================================
             * GO TO RESULT PAGE
             * ====================================================
             */

            response.sendRedirect(
                    "student/quiz-result.jsp"
            );


        } catch (SQLException e) {

            e.printStackTrace();


            /*
             * If database processing fails, allow the student
             * to try again because the submission was not
             * successfully processed.
             */
            session.removeAttribute(attemptKey);


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while submitting the quiz."
            );
        }
    }
}