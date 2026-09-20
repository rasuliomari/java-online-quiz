package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

        HttpSession session = request.getSession(false);

        // =========================================================
        // 1. CHECK STUDENT LOGIN
        // =========================================================
        if (session == null
                || !Boolean.TRUE.equals(
                        session.getAttribute("studentLoggedIn"))
                || !"STUDENT".equals(
                        session.getAttribute("userRole"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Object studentIdObject =
                session.getAttribute("studentId");

        if (studentIdObject == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int studentId;

        try {

            studentId =
                    Integer.parseInt(
                            studentIdObject.toString()
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // =========================================================
        // 2. GET QUIZ ID
        // =========================================================
        String quizIdParameter =
                request.getParameter("quizId");

        if (quizIdParameter == null
                || quizIdParameter.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/student/dashboard.jsp?error=invalidQuiz"
            );
            return;
        }

        int quizId;

        try {

            quizId =
                    Integer.parseInt(
                            quizIdParameter.trim()
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/student/dashboard.jsp?error=invalidQuiz"
            );
            return;
        }

        // =========================================================
        // 3. GET SUBMISSION TYPE
        // =========================================================
        String submissionType =
                request.getParameter("submissionType");

        if (submissionType == null
                || submissionType.trim().isEmpty()) {

            submissionType = "normal";

        } else {

            submissionType =
                    submissionType.trim().toLowerCase();
        }

        // Only these submission types are allowed
        if (!submissionType.equals("normal")
                && !submissionType.equals("exit")
                && !submissionType.equals("time_expired")) {

            submissionType = "normal";
        }

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            // =====================================================
            // START TRANSACTION
            // =====================================================
            connection.setAutoCommit(false);

            // =====================================================
            // 4. LOAD PUBLISHED QUIZ
            // =====================================================
            String quizSql =
                    "SELECT title, question_count, pass_mark " +
                    "FROM quizzes " +
                    "WHERE id = ? " +
                    "AND status = 'PUBLISHED'";

            String quizTitle;
            int expectedQuestionCount;
            int passMark;

            try (PreparedStatement statement =
                         connection.prepareStatement(quizSql)) {

                statement.setInt(1, quizId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/student/dashboard.jsp?error=quizNotFound"
                        );

                        return;
                    }

                    quizTitle =
                            resultSet.getString("title");

                    expectedQuestionCount =
                            resultSet.getInt("question_count");

                    passMark =
                            resultSet.getInt("pass_mark");
                }
            }

            // =====================================================
            // 5. CHECK IF STUDENT ALREADY ATTEMPTED QUIZ
            // =====================================================
            String existingAttemptSql =
                    "SELECT id " +
                    "FROM quiz_attempts " +
                    "WHERE quiz_id = ? " +
                    "AND student_id = ? " +
                    "LIMIT 1";

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 existingAttemptSql)) {

                statement.setInt(1, quizId);
                statement.setInt(2, studentId);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next()) {

                        connection.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/student/quiz-already-attempted.jsp?quizId="
                                        + quizId
                        );

                        return;
                    }
                }
            }

            // =====================================================
            // 6. LOAD CORRECT ANSWERS
            // =====================================================
            String correctAnswerSql =
                    "SELECT q.id, a.option_label " +
                    "FROM questions q " +
                    "INNER JOIN answers a " +
                    "ON q.id = a.question_id " +
                    "AND a.is_correct = TRUE " +
                    "WHERE q.quiz_id = ? " +
                    "ORDER BY q.question_number ASC";

            Map<Integer, String> correctAnswers =
                    new LinkedHashMap<>();

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 correctAnswerSql)) {

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

                        if (correctOption != null) {

                            correctOption =
                                    correctOption
                                            .trim()
                                            .toUpperCase();
                        }

                        correctAnswers.put(
                                questionId,
                                correctOption
                        );
                    }
                }
            }

            // =====================================================
            // 7. VERIFY QUESTION COUNT
            // =====================================================
            if (correctAnswers.size()
                    != expectedQuestionCount) {

                connection.rollback();

                response.sendRedirect(
                        request.getContextPath()
                                + "/student/take-quiz.jsp?quizId="
                                + quizId
                                + "&error=quizIncomplete"
                );

                return;
            }

            // =====================================================
            // 8. READ STUDENT ANSWERS AND CALCULATE SCORE
            // =====================================================
            int score = 0;

            Map<Integer, String> submittedAnswers =
                    new LinkedHashMap<>();

            Map<Integer, Boolean> answerCorrectness =
                    new LinkedHashMap<>();

            for (Map.Entry<Integer, String> entry
                    : correctAnswers.entrySet()) {

                int questionId =
                        entry.getKey();

                String correctOption =
                        entry.getValue();

                String submittedOption =
                        request.getParameter(
                                "question_" + questionId
                        );

                /*
                 * IMPORTANT:
                 *
                 * If the student did not answer a question,
                 * submittedOption will be null.
                 *
                 * This is NOT treated as a submission error.
                 * It simply means the question is unanswered.
                 */
                if (submittedOption != null) {

                    submittedOption =
                            submittedOption
                                    .trim()
                                    .toUpperCase();

                    // Only accept A, B, C or D
                    if (!submittedOption.equals("A")
                            && !submittedOption.equals("B")
                            && !submittedOption.equals("C")
                            && !submittedOption.equals("D")) {

                        submittedOption = null;
                    }
                }

                submittedAnswers.put(
                        questionId,
                        submittedOption
                );

                boolean isCorrect =
                        submittedOption != null
                                && correctOption != null
                                && submittedOption.equals(
                                        correctOption
                                );

                answerCorrectness.put(
                        questionId,
                        isCorrect
                );

                if (isCorrect) {
                    score++;
                }
            }

            // =====================================================
            // 9. CALCULATE PERCENTAGE
            // =====================================================
            double percentage = 0.0;

            if (expectedQuestionCount > 0) {

                percentage =
                        ((double) score
                                / expectedQuestionCount)
                                * 100.0;
            }

            boolean passed =
                    percentage >= passMark;

            String resultStatus =
                    passed ? "PASS" : "FAIL";

            // =====================================================
            // 10. INSERT QUIZ ATTEMPT
            // =====================================================
            String insertAttemptSql =
                    "INSERT INTO quiz_attempts " +
                    "(quiz_id, student_id, score, total_questions, " +
                    "percentage, result_status, started_at, submitted_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, " +
                    "CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) " +
                    "RETURNING id";

            int attemptId;

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 insertAttemptSql)) {

                statement.setInt(1, quizId);
                statement.setInt(2, studentId);
                statement.setInt(3, score);
                statement.setInt(4, expectedQuestionCount);
                statement.setDouble(5, percentage);
                statement.setString(6, resultStatus);

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (!resultSet.next()) {

                        throw new SQLException(
                                "Unable to create quiz attempt."
                        );
                    }

                    attemptId =
                            resultSet.getInt(1);
                }
            }

            // =====================================================
            // 11. SAVE STUDENT ANSWERS
            // =====================================================
            String insertAnswerSql =
                    "INSERT INTO quiz_attempt_answers " +
                    "(attempt_id, question_id, selected_option, is_correct) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 insertAnswerSql)) {

                for (Integer questionId :
                        correctAnswers.keySet()) {

                    String selectedOption =
                            submittedAnswers.get(questionId);

                    boolean isCorrect =
                            answerCorrectness.get(questionId);

                    statement.setInt(
                            1,
                            attemptId
                    );

                    statement.setInt(
                            2,
                            questionId
                    );

                    if (selectedOption == null) {

                        statement.setNull(
                                3,
                                java.sql.Types.CHAR
                        );

                    } else {

                        statement.setString(
                                3,
                                selectedOption
                        );
                    }

                    statement.setBoolean(
                            4,
                            isCorrect
                    );

                    statement.addBatch();
                }

                statement.executeBatch();
            }

            // =====================================================
            // 12. COMMIT DATABASE TRANSACTION
            // =====================================================
            connection.commit();

            // =====================================================
            // 13. SAVE RESULT INFORMATION IN SESSION
            // =====================================================
            session.setAttribute(
                    "quizAttempted_" + quizId,
                    true
            );

            session.setAttribute(
                    "quizResultQuizId",
                    quizId
            );

            session.setAttribute(
                    "quizResultAttemptId",
                    attemptId
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
                    expectedQuestionCount
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

            // Save how the quiz was submitted
            session.setAttribute(
                    "quizResultSubmissionType_" + quizId,
                    submissionType
            );

            // Save submitted answers
            session.setAttribute(
                    "quizSubmittedAnswers_" + quizId,
                    submittedAnswers
            );

            // =====================================================
            // 14. SAVE RESULT IN SESSION HISTORY
            // =====================================================
            List<Map<String, Object>> history;

            Object historyObject =
                    session.getAttribute(
                            "quizResultHistory"
                    );

            if (historyObject instanceof List<?>) {

                history =
                        new ArrayList<>();

                for (Object item :
                        (List<?>) historyObject) {

                    if (item instanceof Map<?, ?>) {

                        Map<String, Object> copy =
                                new LinkedHashMap<>();

                        for (Map.Entry<?, ?> entry :
                                ((Map<?, ?>) item).entrySet()) {

                            copy.put(
                                    String.valueOf(
                                            entry.getKey()
                                    ),
                                    entry.getValue()
                            );
                        }

                        history.add(copy);
                    }
                }

            } else {

                history =
                        new ArrayList<>();
            }

            Map<String, Object> result =
                    new LinkedHashMap<>();

            result.put(
                    "quizId",
                    quizId
            );

            result.put(
                    "attemptId",
                    attemptId
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
                    expectedQuestionCount
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

            result.put(
                    "submissionType",
                    submissionType
            );

            // Newest result first
            history.add(
                    0,
                    result
            );

            // Keep latest 10 results
            if (history.size() > 10) {

                history =
                        new ArrayList<>(
                                history.subList(0, 10)
                        );
            }

            session.setAttribute(
                    "quizResultHistory",
                    history
            );

            // =====================================================
            // 15. REDIRECT TO RESULT PAGE
            // =====================================================
            response.sendRedirect(
                    request.getContextPath()
                            + "/student/quiz-result.jsp?quizId="
                            + quizId
                            + "&attemptId="
                            + attemptId
            );

        } catch (SQLException e) {

            // =====================================================
            // ROLLBACK IF DATABASE ERROR OCCURS
            // =====================================================
            if (connection != null) {

                try {
                    connection.rollback();

                } catch (SQLException rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            e.printStackTrace();

            // PostgreSQL unique_violation
            // SQLState 23505
            if ("23505".equals(e.getSQLState())) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/student/quiz-already-attempted.jsp?quizId="
                                + quizId
                );

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                            + "/student/take-quiz.jsp?quizId="
                            + quizId
                            + "&error=submitFailed"
            );

        } finally {

            // =====================================================
            // CLOSE DATABASE CONNECTION
            // =====================================================
            if (connection != null) {

                try {
                    connection.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }
}