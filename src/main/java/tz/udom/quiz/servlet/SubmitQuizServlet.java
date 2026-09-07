
package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
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

        request.setCharacterEncoding("UTF-8");

        /*
         * ============================================================
         * 1. STUDENT AUTHENTICATION
         * ============================================================
         */

        HttpSession session =
                request.getSession(false);

        boolean studentLoggedIn =
                session != null
                && Boolean.TRUE.equals(
                        session.getAttribute("studentLoggedIn")
                )
                && "STUDENT".equals(
                        session.getAttribute("userRole")
                );

        if (!studentLoggedIn) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=studentLoginRequired"
            );

            return;
        }

        Integer studentId =
                (Integer) session.getAttribute("studentId");

        if (studentId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=studentLoginRequired"
            );

            return;
        }


        /*
         * ============================================================
         * 2. GET QUIZ ID
         * ============================================================
         */

        String quizIdValue =
                request.getParameter("quizId");

        if (quizIdValue == null
                || quizIdValue.trim().isEmpty()) {

            redirectError(
                    request,
                    response,
                    "Quiz information is missing."
            );

            return;
        }

        int quizId;

        try {

            quizId =
                    Integer.parseInt(
                            quizIdValue.trim()
                    );

        } catch (NumberFormatException e) {

            redirectError(
                    request,
                    response,
                    "Invalid quiz information."
            );

            return;
        }


        /*
         * ============================================================
         * 3. PREVENT DUPLICATE ATTEMPT
         * ============================================================
         */

        String attemptKey =
                "quizAttempted_" + quizId;

        if (Boolean.TRUE.equals(
                session.getAttribute(attemptKey))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/quiz-already-attempted.jsp"
                    + "?quizId="
                    + quizId
            );

            return;
        }


        /*
         * ============================================================
         * 4. LOAD ONLY PUBLISHED QUIZ
         * ============================================================
         */

        String quizSql =
                "SELECT title, question_count, pass_mark "
                + "FROM quizzes "
                + "WHERE id = ? "
                + "AND status = 'PUBLISHED'";


        /*
         * ============================================================
         * 5. LOAD CORRECT ANSWERS
         * ============================================================
         */

        String answersSql =
                "SELECT q.id, a.option_label "
                + "FROM questions q "
                + "JOIN answers a "
                + "ON q.id = a.question_id "
                + "AND a.is_correct = TRUE "
                + "WHERE q.quiz_id = ? "
                + "ORDER BY q.question_number ASC";


        try (Connection connection =
                     DBConnection.getConnection()) {


            /*
             * ========================================================
             * LOAD QUIZ
             * ========================================================
             */

            String quizTitle = null;
            int expectedQuestionCount = 0;
            int passMark = 0;

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 quizSql
                         )) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        redirectError(
                                request,
                                response,
                                "This quiz is not available."
                        );

                        return;
                    }

                    quizTitle =
                            resultSet.getString(
                                    "title"
                            );

                    expectedQuestionCount =
                            resultSet.getInt(
                                    "question_count"
                            );

                    passMark =
                            resultSet.getInt(
                                    "pass_mark"
                            );
                }
            }


            /*
             * ========================================================
             * LOAD CORRECT ANSWERS FROM DATABASE
             * ========================================================
             */

            Map<Integer, String> correctAnswers =
                    new HashMap<>();

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 answersSql
                         )) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    while (resultSet.next()) {

                        int questionId =
                                resultSet.getInt("id");

                        String correctOption =
                                resultSet.getString(
                                        "option_label"
                                );

                        correctAnswers.put(
                                questionId,
                                correctOption
                        );
                    }
                }
            }


            /*
             * ========================================================
             * VERIFY QUESTION COUNT
             * ========================================================
             */

            if (correctAnswers.size()
                    != expectedQuestionCount) {

                redirectError(
                        request,
                        response,
                        "This quiz is not properly configured."
                );

                return;
            }


            /*
             * ========================================================
             * CALCULATE SCORE
             * ========================================================
             */

            int score = 0;

            List<Integer> questionIds =
                    new ArrayList<>(
                            correctAnswers.keySet()
                    );

            Map<Integer, String> submittedAnswers =
                    new HashMap<>();


            for (Integer questionId : questionIds) {

                String parameterName =
                        "question_" + questionId;

                String submittedAnswer =
                        request.getParameter(
                                parameterName
                        );

                if (submittedAnswer != null) {

                    submittedAnswer =
                            submittedAnswer
                                    .trim()
                                    .toUpperCase();

                    /*
                     * Only A, B, C or D are accepted.
                     */
                    if (!submittedAnswer.equals("A")
                            && !submittedAnswer.equals("B")
                            && !submittedAnswer.equals("C")
                            && !submittedAnswer.equals("D")) {

                        submittedAnswer = null;
                    }
                }

                if (submittedAnswer != null) {

                    submittedAnswers.put(
                            questionId,
                            submittedAnswer
                    );

                    String correctAnswer =
                            correctAnswers.get(
                                    questionId
                            );

                    if (submittedAnswer.equals(
                            correctAnswer
                    )) {

                        score++;
                    }
                }
            }


            /*
             * ========================================================
             * CALCULATE RESULT
             * ========================================================
             */

            int total =
                    correctAnswers.size();

            double percentage =
                    total > 0
                    ? ((double) score / total) * 100
                    : 0;

            boolean passed =
                    percentage >= passMark;


            /*
             * ========================================================
             * MARK QUIZ AS ATTEMPTED
             * ========================================================
             */

            session.setAttribute(
                    attemptKey,
                    true
            );


            /*
             * ========================================================
             * STORE CURRENT RESULT
             * ========================================================
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
                    total
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

            session.setAttribute(
                    "quizSubmittedAnswers_" + quizId,
                    submittedAnswers
            );


            /*
             * ========================================================
             * STORE RESULT HISTORY
             * ========================================================
             */

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> history =
                    (List<Map<String, Object>>)
                    session.getAttribute(
                            "quizResultHistory"
                    );

            if (history == null) {

                history =
                        new ArrayList<>();
            }

            Map<String, Object> result =
                    new HashMap<>();

            result.put(
                    "quizId",
                    quizId
            );

            result.put(
                    "title",
                    quizTitle
            );

            result.put(
                    "score",
                    score
            );

            result.put(
                    "total",
                    total
            );

            result.put(
                    "percentage",
                    percentage
            );

            result.put(
                    "passMark",
                    passMark
            );

            result.put(
                    "passed",
                    passed
            );

            history.add(
                    0,
                    result
            );


            /*
             * Keep only the latest 10 results.
             */

            if (history.size() > 10) {

                history =
                        new ArrayList<>(
                                history.subList(
                                        0,
                                        10
                                )
                        );
            }

            session.setAttribute(
                    "quizResultHistory",
                    history
            );


            /*
             * ========================================================
             * 6. REDIRECT TO RESULT PAGE
             * ========================================================
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/quiz-result.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "An error occurred while submitting the quiz."
            );
        }
    }


    /*
     * ================================================================
     * ERROR REDIRECT
     * ================================================================
     */

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/student/take-quiz.jsp"
                + "?quizId="
                + request.getParameter("quizId")
                + "&error="
                + java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                )
        );
    }
}
