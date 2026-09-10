package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/adminUpdateQuiz")
public class AdminUpdateQuizServlet extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    // =========================================
    // ADMIN AUTHENTICATION
    // =========================================

    HttpSession session = request.getSession(false);

    if (session == null ||
        !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn")) ||
        !"ADMIN".equals(session.getAttribute("userRole"))) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    // =========================================
    // GET QUIZ ID
    // =========================================

    String quizIdParameter =
            request.getParameter("quizId");

    if (quizIdParameter == null ||
        quizIdParameter.trim().isEmpty()) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=invalid_quiz"
        );
        return;
    }

    int quizId;

    try {

        quizId = Integer.parseInt(
                quizIdParameter.trim()
        );

    } catch (NumberFormatException e) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=invalid_quiz"
        );
        return;
    }

    // =========================================
    // GET FORM DATA
    // =========================================

    String title =
            request.getParameter("title");

    String courseIdParameter =
            request.getParameter("courseId");

    String description =
            request.getParameter("description");

    String durationParameter =
            request.getParameter("durationMinutes");

    String passMarkParameter =
            request.getParameter("passMark");

    String status =
            request.getParameter("status");

    // =========================================
    // BASIC VALIDATION
    // =========================================

    if (title == null ||
        title.trim().isEmpty() ||
        courseIdParameter == null ||
        courseIdParameter.trim().isEmpty() ||
        durationParameter == null ||
        durationParameter.trim().isEmpty() ||
        passMarkParameter == null ||
        passMarkParameter.trim().isEmpty() ||
        status == null ||
        status.trim().isEmpty()) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_data"
        );
        return;
    }

    title = title.trim();

    if (description != null) {
        description = description.trim();
    }

    status = status.trim().toUpperCase();

    // =========================================
    // VALIDATE STATUS
    // =========================================

    if (!"DRAFT".equals(status) &&
        !"PUBLISHED".equals(status)) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_status"
        );
        return;
    }

    // =========================================
    // PARSE COURSE ID
    // =========================================

    int courseId;

    try {

        courseId = Integer.parseInt(
                courseIdParameter.trim()
        );

    } catch (NumberFormatException e) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_course"
        );
        return;
    }

    // =========================================
    // PARSE DURATION
    // =========================================

    int durationMinutes;

    try {

        durationMinutes = Integer.parseInt(
                durationParameter.trim()
        );

    } catch (NumberFormatException e) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_duration"
        );
        return;
    }

    if (durationMinutes < 1 ||
        durationMinutes > 600) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_duration"
        );
        return;
    }

    // =========================================
    // PARSE PASS MARK
    // =========================================

    int passMark;

    try {

        passMark = Integer.parseInt(
                passMarkParameter.trim()
        );

    } catch (NumberFormatException e) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_pass_mark"
        );
        return;
    }

    if (passMark < 1 ||
        passMark > 100) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=invalid_pass_mark"
        );
        return;
    }

    // =========================================
    // DATABASE
    // =========================================

    String courseSql =
            "SELECT course_code, course_name " +
            "FROM courses " +
            "WHERE id = ?";

    String questionCountSql =
            "SELECT COUNT(*) " +
            "FROM questions " +
            "WHERE quiz_id = ?";

    String updateSql =
            "UPDATE quizzes SET " +
            "title = ?, " +
            "course = ?, " +
            "course_id = ?, " +
            "description = ?, " +
            "duration_minutes = ?, " +
            "question_count = ?, " +
            "pass_mark = ?, " +
            "status = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE id = ?";

    try (Connection conn =
                 DBConnection.getConnection()) {

        conn.setAutoCommit(false);

        // =====================================
        // VERIFY COURSE
        // =====================================

        String courseCode;
        String courseName;

        try (PreparedStatement ps =
                     conn.prepareStatement(courseSql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (!rs.next()) {

                    conn.rollback();

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/edit-quiz.jsp?id="
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

        // =====================================
        // GET REAL QUESTION COUNT
        // =====================================

        int questionCount = 0;

        try (PreparedStatement ps =
                     conn.prepareStatement(
                             questionCountSql)) {

            ps.setInt(1, quizId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    questionCount =
                            rs.getInt(1);
                }
            }
        }

        // =====================================
        // COURSE DISPLAY
        // =====================================

        String courseDisplay =
                courseCode + " - " + courseName;

        // =====================================
        // UPDATE QUIZ
        // =====================================

        int rowsUpdated;

        try (PreparedStatement ps =
                     conn.prepareStatement(updateSql)) {

            ps.setString(1, title);

            ps.setString(2, courseDisplay);

            ps.setInt(3, courseId);

            if (description == null ||
                description.isEmpty()) {

                ps.setNull(
                        4,
                        java.sql.Types.VARCHAR
                );

            } else {

                ps.setString(
                        4,
                        description
                );
            }

            ps.setInt(
                    5,
                    durationMinutes
            );

            ps.setInt(
                    6,
                    questionCount
            );

            ps.setInt(
                    7,
                    passMark
            );

            ps.setString(
                    8,
                    status
            );

            ps.setInt(
                    9,
                    quizId
            );

            rowsUpdated =
                    ps.executeUpdate();
        }

        if (rowsUpdated != 1) {

            conn.rollback();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/edit-quiz.jsp?id="
                    + quizId
                    + "&error=quiz_not_found"
            );
            return;
        }

        // =====================================
        // COMMIT
        // =====================================

        conn.commit();

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&updated=success"
        );

    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                request.getContextPath()
                + "/admin/edit-quiz.jsp?id="
                + quizId
                + "&error=database_error"
        );
    }
}

}
