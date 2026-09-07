package tz.udom.quiz.servlet;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/assignCourse")
public class AssignCourseServlet extends HttpServlet {

    // ============================================================
    // ADMIN AUTHENTICATION
    // ============================================================

    private boolean isAdmin(HttpServletRequest request) {

        HttpSession session =
                request.getSession(false);

        return session != null
                && Boolean.TRUE.equals(
                        session.getAttribute("adminLoggedIn")
                )
                && "ADMIN".equals(
                        session.getAttribute("userRole")
                );
    }


    // ============================================================
    // GET
    //
    // Used by assign-courses.jsp to load courses
    // ============================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Administrator login required."
            );

            return;
        }


        String action =
                request.getParameter("action");


        if ("list".equals(action)) {

            listCourses(
                    request,
                    response
            );

            return;
        }


        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid request."
        );
    }


    // ============================================================
    // LIST COURSES
    // ============================================================

    private void listCourses(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );


        String programmeIdParam =
                request.getParameter("programmeId");

        String yearParam =
                request.getParameter("year");

        String teacherIdParam =
                request.getParameter("teacherId");


        if (programmeIdParam == null
                || yearParam == null
                || teacherIdParam == null) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing parameters."
            );

            return;
        }


        int programmeId;
        int year;
        int teacherId;


        try {

            programmeId =
                    Integer.parseInt(programmeIdParam);

            year =
                    Integer.parseInt(yearParam);

            teacherId =
                    Integer.parseInt(teacherIdParam);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid parameter."
            );

            return;
        }


        String sql =
                "SELECT " +
                "c.id, " +
                "c.course_code, " +
                "c.course_name, " +
                "CASE " +
                "WHEN tc.id IS NOT NULL THEN TRUE " +
                "ELSE FALSE " +
                "END AS assigned " +
                "FROM courses c " +
                "LEFT JOIN teacher_courses tc " +
                "ON c.id = tc.course_id " +
                "AND tc.teacher_id = ? " +
                "WHERE c.programme_id = ? " +
                "AND c.year_of_study = ? " +
                "ORDER BY c.course_code";


        try (
                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(1, teacherId);
            ps.setInt(2, programmeId);
            ps.setInt(3, year);


            try (ResultSet rs =
                         ps.executeQuery()) {

                PrintWriter out =
                        response.getWriter();

                out.print("[");


                boolean first = true;


                while (rs.next()) {

                    if (!first) {
                        out.print(",");
                    }

                    first = false;


                    out.print("{");

                    out.print(
                            "\"id\":"
                            + rs.getInt("id")
                    );

                    out.print(",");

                    out.print(
                            "\"courseCode\":\""
                            + escapeJson(
                                    rs.getString(
                                            "course_code"
                                    )
                            )
                            + "\""
                    );

                    out.print(",");

                    out.print(
                            "\"courseName\":\""
                            + escapeJson(
                                    rs.getString(
                                            "course_name"
                                    )
                            )
                            + "\""
                    );

                    out.print(",");

                    out.print(
                            "\"assigned\":"
                            + rs.getBoolean(
                                    "assigned"
                            )
                    );

                    out.print("}");

                }


                out.print("]");

                out.flush();

            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error."
            );
        }
    }


    // ============================================================
    // POST
    //
    // Assign selected courses to teacher
    // ============================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=adminLoginRequired"
            );

            return;
        }


        String teacherIdParam =
                request.getParameter("teacherId");


        String[] courseIds =
                request.getParameterValues(
                        "courseIds"
                );


        if (teacherIdParam == null
                || courseIds == null
                || courseIds.length == 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/assign-courses.jsp?error=error"
            );

            return;
        }


        int teacherId;


        try {

            teacherId =
                    Integer.parseInt(
                            teacherIdParam
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/assign-courses.jsp?error=error"
            );

            return;
        }


        Connection conn = null;


        try {

            conn =
                    DBConnection.getConnection();

            conn.setAutoCommit(false);


            // ----------------------------------------------------
            // Verify teacher exists
            // ----------------------------------------------------

            String teacherCheckSql =
                    "SELECT id " +
                    "FROM teachers " +
                    "WHERE id = ?";


            try (
                    PreparedStatement ps =
                            conn.prepareStatement(
                                    teacherCheckSql
                            )
            ) {

                ps.setInt(
                        1,
                        teacherId
                );


                try (
                        ResultSet rs =
                                ps.executeQuery()
                ) {

                    if (!rs.next()) {

                        conn.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                + "/admin/assign-courses.jsp?error=error"
                        );

                        return;
                    }
                }
            }


            // ----------------------------------------------------
            // Insert assignments
            // ----------------------------------------------------

            String insertSql =
                    "INSERT INTO teacher_courses " +
                    "(teacher_id, course_id) " +
                    "VALUES (?, ?) " +
                    "ON CONFLICT " +
                    "(teacher_id, course_id) " +
                    "DO NOTHING";


            try (
                    PreparedStatement ps =
                            conn.prepareStatement(
                                    insertSql
                            )
            ) {

                for (String courseIdParam :
                        courseIds) {

                    int courseId;


                    try {

                        courseId =
                                Integer.parseInt(
                                        courseIdParam
                                );

                    } catch (
                            NumberFormatException e
                    ) {

                        continue;
                    }


                    ps.setInt(
                            1,
                            teacherId
                    );

                    ps.setInt(
                            2,
                            courseId
                    );

                    ps.addBatch();
                }


                ps.executeBatch();
            }


            conn.commit();


            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/assign-courses.jsp?message=success"
            );


        } catch (SQLException e) {

            e.printStackTrace();


            if (conn != null) {

                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }


            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/assign-courses.jsp?error=error"
            );


        } finally {

            if (conn != null) {

                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }


    // ============================================================
    // SIMPLE JSON ESCAPING
    // ============================================================

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}