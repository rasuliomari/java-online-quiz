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

@WebServlet("/updateQuiz")
public class UpdateQuizServlet extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    // ==============================
    // AUTHENTICATION
    // ==============================

    if (session == null ||
        !Boolean.TRUE.equals(session.getAttribute("teacherLoggedIn")) ||
        !"TEACHER".equals(session.getAttribute("userRole"))) {

        response.sendRedirect("login.jsp");
        return;
    }

    Integer teacherId =
            (Integer) session.getAttribute("teacherId");

    if (teacherId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ==============================
    // READ FORM DATA
    // ==============================

    String quizIdParam =
            request.getParameter("quizId");

    String quizTitle =
            request.getParameter("quizTitle");

    String courseIdParam =
            request.getParameter("courseId");

    String description =
            request.getParameter("description");

    String durationParam =
            request.getParameter("duration");

    String questionCountParam =
            request.getParameter("questionCount");

    String passMarkParam =
            request.getParameter("passMark");

    // ==============================
    // BASIC VALIDATION
    // ==============================

    if (quizIdParam == null ||
        quizTitle == null ||
        courseIdParam == null ||
        durationParam == null ||
        questionCountParam == null ||
        passMarkParam == null) {

        response.sendRedirect(
            "teacher/dashboard.jsp?error=missing_data"
        );

        return;
    }

    quizTitle = quizTitle.trim();

    if (quizTitle.isEmpty()) {

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizIdParam
            + "&error=empty_title"
        );

        return;
    }

    int quizId;
    int courseId;
    int duration;
    int questionCount;
    int passMark;

    try {

        quizId =
            Integer.parseInt(quizIdParam);

        courseId =
            Integer.parseInt(courseIdParam);

        duration =
            Integer.parseInt(durationParam);

        questionCount =
            Integer.parseInt(questionCountParam);

        passMark =
            Integer.parseInt(passMarkParam);

    } catch (NumberFormatException e) {

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizIdParam
            + "&error=invalid_data"
        );

        return;
    }

    // ==============================
    // VALIDATE NUMBERS
    // ==============================

    if (duration < 1) {

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizId
            + "&error=invalid_duration"
        );

        return;
    }

    if (questionCount < 1) {

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizId
            + "&error=invalid_question_count"
        );

        return;
    }

    if (passMark < 1 || passMark > 100) {

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizId
            + "&error=invalid_pass_mark"
        );

        return;
    }

    // ==============================
    // DATABASE TRANSACTION
    // ==============================

    Connection conn = null;

    try {

        conn = DBConnection.getConnection();

        conn.setAutoCommit(false);

        // ==============================
        // VERIFY COURSE ASSIGNMENT
        // ==============================

        String courseSql =
            "SELECT c.id, c.course_code, c.course_name " +
            "FROM courses c " +
            "INNER JOIN teacher_courses tc " +
            "ON tc.course_id = c.id " +
            "WHERE tc.teacher_id = ? " +
            "AND c.id = ?";

        String courseCode = null;
        String courseName = null;

        try (PreparedStatement ps =
                 conn.prepareStatement(courseSql)) {

            ps.setInt(1, teacherId);
            ps.setInt(2, courseId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (!rs.next()) {

                    conn.rollback();

                    response.sendRedirect(
                        "teacher/edit-quiz.jsp?quizId="
                        + quizId
                        + "&error=invalid_course"
                    );

                    return;
                }

                courseCode =
                    rs.getString("course_code");

                courseName =
                    rs.getString("course_name");
            }
        }

        // ==============================
        // VERIFY QUIZ OWNERSHIP
        // AND DRAFT STATUS
        // ==============================

        String quizSql =
            "SELECT question_count, status " +
            "FROM quizzes " +
            "WHERE id = ? " +
            "AND teacher_id = ?";

        String status = null;

        try (PreparedStatement ps =
                 conn.prepareStatement(quizSql)) {

            ps.setInt(1, quizId);
            ps.setInt(2, teacherId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (!rs.next()) {

                    conn.rollback();

                    response.sendRedirect(
                        "teacher/dashboard.jsp?error=quiz_not_found"
                    );

                    return;
                }

                status =
                    rs.getString("status");
            }
        }

        if (!"DRAFT".equalsIgnoreCase(status)) {

            conn.rollback();

            response.sendRedirect(
                "teacher/review-quiz.jsp?quizId="
                + quizId
                + "&error=quiz_not_editable"
            );

            return;
        }

        // ==============================
        // COUNT EXISTING QUESTIONS
        // ==============================

        int existingQuestions = 0;

        String countSql =
            "SELECT COUNT(*) " +
            "FROM questions " +
            "WHERE quiz_id = ?";

        try (PreparedStatement ps =
                 conn.prepareStatement(countSql)) {

            ps.setInt(1, quizId);

            try (ResultSet rs =
                     ps.executeQuery()) {

                if (rs.next()) {
                    existingQuestions =
                        rs.getInt(1);
                }
            }
        }

        // The new question count cannot
        // be lower than already saved questions.

        if (questionCount < existingQuestions) {

            conn.rollback();

            response.sendRedirect(
                "teacher/edit-quiz.jsp?quizId="
                + quizId
                + "&error=question_count_too_low"
            );

            return;
        }

        // ==============================
        // COURSE DISPLAY
        // ==============================

        String courseDisplay =
            courseCode + " - " + courseName;

        // ==============================
        // UPDATE QUIZ
        // ==============================

        String updateSql =
            "UPDATE quizzes SET " +
            "title = ?, " +
            "course = ?, " +
            "course_id = ?, " +
            "description = ?, " +
            "duration_minutes = ?, " +
            "question_count = ?, " +
            "pass_mark = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE id = ? " +
            "AND teacher_id = ? " +
            "AND status = 'DRAFT'";

        int rowsUpdated;

        try (PreparedStatement ps =
                 conn.prepareStatement(updateSql)) {

            ps.setString(1, quizTitle);

            ps.setString(2, courseDisplay);

            ps.setInt(3, courseId);

            if (description == null ||
                description.trim().isEmpty()) {

                ps.setNull(
                    4,
                    java.sql.Types.VARCHAR
                );

            } else {

                ps.setString(
                    4,
                    description.trim()
                );
            }

            ps.setInt(5, duration);

            ps.setInt(6, questionCount);

            ps.setInt(7, passMark);

            ps.setInt(8, quizId);

            ps.setInt(9, teacherId);

            rowsUpdated =
                ps.executeUpdate();
        }

        if (rowsUpdated != 1) {

            conn.rollback();

            response.sendRedirect(
                "teacher/edit-quiz.jsp?quizId="
                + quizId
                + "&error=update_failed"
            );

            return;
        }

        // ==============================
        // COMMIT
        // ==============================

        conn.commit();

        response.sendRedirect(
            "teacher/review-quiz.jsp?quizId="
            + quizId
            + "&updated=success"
        );

    } catch (SQLException e) {

        if (conn != null) {

            try {
                conn.rollback();
            } catch (SQLException rollbackException) {
                rollbackException.printStackTrace();
            }
        }

        e.printStackTrace();

        response.sendRedirect(
            "teacher/edit-quiz.jsp?quizId="
            + quizId
            + "&error=database_error"
        );

    } finally {

        if (conn != null) {

            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

}
