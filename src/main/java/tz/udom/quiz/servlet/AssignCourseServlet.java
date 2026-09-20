package tz.udom.quiz.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/assignCourse")
public class AssignCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"ADMIN".equals(session.getAttribute("userRole"))
                || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {

            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                    "Unauthorized access.");
            return;
        }

        String action = request.getParameter("action");

        if (!"list".equalsIgnoreCase(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
            return;
        }

        String teacherIdParam = request.getParameter("teacherId");
        String programmeIdParam = request.getParameter("programmeId");
        String yearParam = request.getParameter("year");

        if (teacherIdParam == null
                || programmeIdParam == null
                || yearParam == null
                || teacherIdParam.isBlank()
                || programmeIdParam.isBlank()
                || yearParam.isBlank()) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Teacher, programme and year are required.");
            return;
        }

        int teacherId;
        int programmeId;
        int year;

        try {
            teacherId = Integer.parseInt(teacherIdParam);
            programmeId = Integer.parseInt(programmeIdParam);
            year = Integer.parseInt(yearParam);
        } catch (NumberFormatException e) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid teacher, programme or year.");
            return;
        }

        /*
         * We intentionally DO NOT change the database structure.
         *
         * This query returns:
         * - assigned = course belongs to selected teacher
         * - assigned_to_another_teacher = course belongs to another teacher
         * - assigned_teacher_id = ID of the other teacher
         * - assigned_teacher_name = name of the other teacher
         * - assigned_teacher_staff_number = staff number
         *
         * This allows the JSP to prevent assigning a course that is
         * already assigned to somebody else.
         */
        String sql =
                "SELECT " +
                "    c.id, " +
                "    c.course_code, " +
                "    c.course_name, " +
                "    c.year_of_study, " +

                "    EXISTS ( " +
                "        SELECT 1 " +
                "        FROM teacher_courses tc_selected " +
                "        WHERE tc_selected.course_id = c.id " +
                "        AND tc_selected.teacher_id = ? " +
                "    ) AS assigned, " +

                "    other_tc.teacher_id AS assigned_teacher_id, " +
                "    CONCAT_WS(' ', " +
                "        other_t.first_name, " +
                "        other_t.middle_name, " +
                "        other_t.last_name " +
                "    ) AS assigned_teacher_name, " +
                "    other_t.staff_number AS assigned_teacher_staff_number " +

                "FROM courses c " +

                "LEFT JOIN LATERAL ( " +
                "    SELECT tc.teacher_id " +
                "    FROM teacher_courses tc " +
                "    WHERE tc.course_id = c.id " +
                "    AND tc.teacher_id <> ? " +
                "    ORDER BY tc.id " +
                "    LIMIT 1 " +
                ") other_tc ON TRUE " +

                "LEFT JOIN teachers other_t " +
                "    ON other_t.id = other_tc.teacher_id " +

                "WHERE c.programme_id = ? " +
                "AND c.year_of_study = ? " +

                "ORDER BY c.course_code";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)
        ) {

            statement.setInt(1, teacherId);
            statement.setInt(2, teacherId);
            statement.setInt(3, programmeId);
            statement.setInt(4, year);

            try (ResultSet rs = statement.executeQuery()) {

                PrintWriter out = response.getWriter();

                out.print("[");

                boolean first = true;

                while (rs.next()) {

                    if (!first) {
                        out.print(",");
                    }

                    first = false;

                    int courseId = rs.getInt("id");
                    String courseCode = rs.getString("course_code");
                    String courseName = rs.getString("course_name");
                    int yearOfStudy = rs.getInt("year_of_study");

                    boolean assigned = rs.getBoolean("assigned");

                    Object assignedTeacherId = rs.getObject(
                            "assigned_teacher_id"
                    );

                    String assignedTeacherName =
                            rs.getString("assigned_teacher_name");

                    String assignedTeacherStaffNumber =
                            rs.getString("assigned_teacher_staff_number");

                    boolean assignedToAnotherTeacher =
                            assignedTeacherId != null;

                    out.print("{");

                    out.print("\"id\":" + courseId + ",");

                    out.print("\"course_code\":\""
                            + escapeJson(courseCode)
                            + "\",");

                    out.print("\"course_name\":\""
                            + escapeJson(courseName)
                            + "\",");

                    out.print("\"year_of_study\":"
                            + yearOfStudy
                            + ",");

                    out.print("\"assigned\":"
                            + assigned
                            + ",");

                    out.print("\"assigned_to_another_teacher\":"
                            + assignedToAnotherTeacher
                            + ",");

                    if (assignedTeacherId != null) {

                        out.print("\"assigned_teacher_id\":"
                                + assignedTeacherId
                                + ",");

                        out.print("\"assigned_teacher_name\":\""
                                + escapeJson(assignedTeacherName)
                                + "\",");

                        out.print("\"assigned_teacher_staff_number\":\""
                                + escapeJson(assignedTeacherStaffNumber)
                                + "\"");

                    } else {

                        out.print("\"assigned_teacher_id\":null,");
                        out.print("\"assigned_teacher_name\":null,");
                        out.print("\"assigned_teacher_staff_number\":null");
                    }

                    out.print("}");
                }

                out.print("]");
            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                    "{\"error\":\"Failed to load courses.\"}"
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"ADMIN".equals(session.getAttribute("userRole"))
                || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {

            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                    "Unauthorized access.");
            return;
        }

        String teacherIdParam = request.getParameter("teacherId");
        String programmeIdParam = request.getParameter("programmeId");
        String yearParam = request.getParameter("year");

        if (teacherIdParam == null
                || programmeIdParam == null
                || yearParam == null
                || teacherIdParam.isBlank()
                || programmeIdParam.isBlank()
                || yearParam.isBlank()) {

            redirectWithMessage(
                    response,
                    teacherIdParam,
                    "danger",
                    "Teacher, programme and year are required."
            );
            return;
        }

        int teacherId;
        int programmeId;
        int year;

        try {

            teacherId = Integer.parseInt(teacherIdParam);
            programmeId = Integer.parseInt(programmeIdParam);
            year = Integer.parseInt(yearParam);

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    response,
                    teacherIdParam,
                    "danger",
                    "Invalid teacher, programme or year."
            );
            return;
        }

        /*
         * courseIds contains the courses that the admin wants this
         * teacher to have AFTER saving.
         *
         * If a previously assigned course is NOT included,
         * its teacher_courses row will be deleted.
         *
         * Therefore unchecking a course + Save = REMOVE assignment.
         */
        String[] courseIdParams = request.getParameterValues("courseIds");

        List<Integer> selectedCourseIds = new ArrayList<>();

        if (courseIdParams != null) {

            for (String value : courseIdParams) {

                try {

                    int courseId = Integer.parseInt(value);

                    if (!selectedCourseIds.contains(courseId)) {
                        selectedCourseIds.add(courseId);
                    }

                } catch (NumberFormatException ignored) {
                    // Ignore invalid course IDs.
                }
            }
        }

        String teacherExistsSql =
                "SELECT 1 FROM teachers WHERE id = ?";

        String programmeExistsSql =
                "SELECT 1 FROM programmes WHERE id = ?";

        /*
         * Verify that every selected course belongs to the selected
         * programme and year.
         */
        String courseValidationSql =
                "SELECT id " +
                "FROM courses " +
                "WHERE id = ? " +
                "AND programme_id = ? " +
                "AND year_of_study = ?";

        /*
         * IMPORTANT:
         *
         * Because the database is not being changed, we check here
         * whether another teacher already owns the course.
         */
        String otherTeacherCheckSql =
                "SELECT " +
                "    t.first_name, " +
                "    t.middle_name, " +
                "    t.last_name, " +
                "    t.staff_number " +
                "FROM teacher_courses tc " +
                "INNER JOIN teachers t " +
                "    ON t.id = tc.teacher_id " +
                "WHERE tc.course_id = ? " +
                "AND tc.teacher_id <> ? " +
                "LIMIT 1";

        String deleteSql =
                "DELETE FROM teacher_courses " +
                "WHERE teacher_id = ? " +
                "AND course_id IN ( " +
                "    SELECT id " +
                "    FROM courses " +
                "    WHERE programme_id = ? " +
                "    AND year_of_study = ? " +
                ")";

        String insertSql =
                "INSERT INTO teacher_courses " +
                "(teacher_id, course_id) " +
                "VALUES (?, ?) " +
                "ON CONFLICT (teacher_id, course_id) " +
                "DO NOTHING";

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            /*
             * Verify teacher.
             */
            try (PreparedStatement statement =
                         connection.prepareStatement(teacherExistsSql)) {

                statement.setInt(1, teacherId);

                try (ResultSet rs = statement.executeQuery()) {

                    if (!rs.next()) {

                        connection.rollback();

                        redirectWithMessage(
                                response,
                                String.valueOf(teacherId),
                                "danger",
                                "Selected teacher does not exist."
                        );

                        return;
                    }
                }
            }

            /*
             * Verify programme.
             */
            try (PreparedStatement statement =
                         connection.prepareStatement(programmeExistsSql)) {

                statement.setInt(1, programmeId);

                try (ResultSet rs = statement.executeQuery()) {

                    if (!rs.next()) {

                        connection.rollback();

                        redirectWithMessage(
                                response,
                                String.valueOf(teacherId),
                                "danger",
                                "Selected programme does not exist."
                        );

                        return;
                    }
                }
            }

            /*
             * Validate selected courses BEFORE deleting anything.
             *
             * This is important because we don't want to remove the
             * teacher's existing assignments if the new selection
             * contains an invalid course.
             */
            for (Integer courseId : selectedCourseIds) {

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     courseValidationSql)) {

                    statement.setInt(1, courseId);
                    statement.setInt(2, programmeId);
                    statement.setInt(3, year);

                    try (ResultSet rs = statement.executeQuery()) {

                        if (!rs.next()) {

                            connection.rollback();

                            redirectWithMessage(
                                    response,
                                    String.valueOf(teacherId),
                                    "danger",
                                    "One or more selected courses do not belong to the selected programme and year."
                            );

                            return;
                        }
                    }
                }
            }

            /*
             * Check whether any selected course belongs to another
             * teacher.
             *
             * We do this BEFORE deleting the selected teacher's
             * current assignments.
             */
            for (Integer courseId : selectedCourseIds) {

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     otherTeacherCheckSql)) {

                    statement.setInt(1, courseId);
                    statement.setInt(2, teacherId);

                    try (ResultSet rs = statement.executeQuery()) {

                        if (rs.next()) {

                            String firstName =
                                    rs.getString("first_name");

                            String middleName =
                                    rs.getString("middle_name");

                            String lastName =
                                    rs.getString("last_name");

                            String staffNumber =
                                    rs.getString("staff_number");

                            String teacherName =
                                    buildFullName(
                                            firstName,
                                            middleName,
                                            lastName
                                    );

                            connection.rollback();

                            String message =
                                    "Course is already assigned to "
                                    + teacherName
                                    + " (Staff No: "
                                    + staffNumber
                                    + "). Remove the course from that teacher before assigning it to another teacher.";

                            redirectWithMessage(
                                    response,
                                    String.valueOf(teacherId),
                                    "warning",
                                    message
                            );

                            return;
                        }
                    }
                }
            }

            /*
             * Remove courses that the admin has unchecked.
             */
            try (PreparedStatement statement =
                         connection.prepareStatement(deleteSql)) {

                statement.setInt(1, teacherId);
                statement.setInt(2, programmeId);
                statement.setInt(3, year);

                statement.executeUpdate();
            }

            /*
             * Add the courses that remain selected.
             */
            try (PreparedStatement statement =
                         connection.prepareStatement(insertSql)) {

                for (Integer courseId : selectedCourseIds) {

                    statement.setInt(1, teacherId);
                    statement.setInt(2, courseId);

                    statement.addBatch();
                }

                if (!selectedCourseIds.isEmpty()) {
                    statement.executeBatch();
                }
            }

            connection.commit();

            redirectWithMessage(
                    response,
                    String.valueOf(teacherId),
                    "success",
                    "Course assignments updated successfully."
            );

        } catch (SQLException e) {

            if (connection != null) {

                try {
                    connection.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            e.printStackTrace();

            redirectWithMessage(
                    response,
                    String.valueOf(teacherId),
                    "danger",
                    "Failed to update course assignments: "
                            + e.getMessage()
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

    private void redirectWithMessage(
            HttpServletResponse response,
            String teacherId,
            String status,
            String message
    ) throws IOException {

        String encodedMessage =
                java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                );

        response.sendRedirect(
                "admin/assign-courses.jsp"
                        + "?teacherId="
                        + (teacherId == null ? "" : teacherId)
                        + "&status="
                        + status
                        + "&message="
                        + encodedMessage
        );
    }

    private String buildFullName(
            String firstName,
            String middleName,
            String lastName
    ) {

        StringBuilder name = new StringBuilder();

        if (firstName != null && !firstName.isBlank()) {
            name.append(firstName.trim());
        }

        if (middleName != null && !middleName.isBlank()) {

            if (!name.isEmpty()) {
                name.append(" ");
            }

            name.append(middleName.trim());
        }

        if (lastName != null && !lastName.isBlank()) {

            if (!name.isEmpty()) {
                name.append(" ");
            }

            name.append(lastName.trim());
        }

        return name.toString();
    }

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}