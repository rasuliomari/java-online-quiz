package tz.udom.quiz.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
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

    private static final long serialVersionUID = 1L;


    /*
     * ============================
     * GET
     * ============================
     *
     * action=list
     *
     * Returns courses belonging to:
     *
     * Programme
     * +
     * Year
     *
     * and tells whether each course
     * is already assigned to the
     * selected teacher.
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * ADMIN AUTHENTICATION
         */

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "You must be logged in."
            );

            return;
        }


        Boolean adminLoggedIn =
                (Boolean) session.getAttribute(
                        "adminLoggedIn"
                );

        String userRole =
                (String) session.getAttribute(
                        "userRole"
                );


        if (adminLoggedIn == null ||
            !adminLoggedIn ||
            !"ADMIN".equals(userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Administrator access required."
            );

            return;
        }


        /*
         * CHECK ACTION
         */

        String action =
                request.getParameter("action");


        if (!"list".equalsIgnoreCase(action)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action."
            );

            return;
        }


        /*
         * READ PARAMETERS
         */

        int teacherId;
        int programmeId;
        int year;


        try {

            teacherId =
                    Integer.parseInt(
                            request.getParameter("teacherId")
                    );

            programmeId =
                    Integer.parseInt(
                            request.getParameter("programmeId")
                    );

            year =
                    Integer.parseInt(
                            request.getParameter("year")
                    );

        } catch (Exception e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid teacher, programme or year."
            );

            return;
        }


        /*
         * VALIDATE VALUES
         */

        if (teacherId <= 0 ||
            programmeId <= 0 ||
            year < 1 ||
            year > 4) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid assignment parameters."
            );

            return;
        }


        /*
         * JSON RESPONSE
         */

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );


        /*
         * SQL
         *
         * LEFT JOIN allows us to return
         * every course and determine
         * whether it is assigned.
         */

        String sql =
                "SELECT " +
                "c.id, " +
                "c.course_code, " +
                "c.course_name, " +
                "c.year_of_study, " +
                "CASE " +
                "WHEN tc.id IS NULL THEN false " +
                "ELSE true " +
                "END AS assigned " +
                "FROM courses c " +
                "LEFT JOIN teacher_courses tc " +
                "ON tc.course_id = c.id " +
                "AND tc.teacher_id = ? " +
                "WHERE c.programme_id = ? " +
                "AND c.year_of_study = ? " +
                "ORDER BY c.course_code";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    teacherId
            );

            statement.setInt(
                    2,
                    programmeId
            );

            statement.setInt(
                    3,
                    year
            );


            try (
                    ResultSet resultSet =
                            statement.executeQuery();

                    PrintWriter out =
                            response.getWriter()
            ) {

                StringBuilder json =
                        new StringBuilder();

                json.append("[");


                boolean first =
                        true;


                while (resultSet.next()) {

                    if (!first) {

                        json.append(",");

                    }

                    first = false;


                    int courseId =
                            resultSet.getInt("id");

                    String courseCode =
                            resultSet.getString(
                                    "course_code"
                            );

                    String courseName =
                            resultSet.getString(
                                    "course_name"
                            );

                    int courseYear =
                            resultSet.getInt(
                                    "year_of_study"
                            );

                    boolean assigned =
                            resultSet.getBoolean(
                                    "assigned"
                            );


                    json.append("{");

                    json.append(
                            "\"id\":"
                    );

                    json.append(
                            courseId
                    );

                    json.append(",");


                    json.append(
                            "\"course_code\":\""
                    );

                    json.append(
                            escapeJson(courseCode)
                    );

                    json.append("\",");


                    json.append(
                            "\"course_name\":\""
                    );

                    json.append(
                            escapeJson(courseName)
                    );

                    json.append("\",");


                    json.append(
                            "\"year_of_study\":"
                    );

                    json.append(
                            courseYear
                    );

                    json.append(",");


                    json.append(
                            "\"assigned\":"
                    );

                    json.append(
                            assigned
                    );

                    json.append("}");

                }


                json.append("]");


                out.print(
                        json.toString()
                );

                out.flush();

            }


        } catch (SQLException e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database error while loading courses."
            );
        }

    }


    /*
     * ============================
     * POST
     * ============================
     *
     * Saves teacher course
     * assignments.
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /*
         * ADMIN AUTHENTICATION
         */

        HttpSession session =
                request.getSession(false);


        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        Boolean adminLoggedIn =
                (Boolean) session.getAttribute(
                        "adminLoggedIn"
                );

        String userRole =
                (String) session.getAttribute(
                        "userRole"
                );


        if (adminLoggedIn == null ||
            !adminLoggedIn ||
            !"ADMIN".equals(userRole)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        /*
         * READ PARAMETERS
         */

        int teacherId;
        int programmeId;
        int year;


        try {

            teacherId =
                    Integer.parseInt(
                            request.getParameter(
                                    "teacherId"
                            )
                    );

            programmeId =
                    Integer.parseInt(
                            request.getParameter(
                                    "programmeId"
                            )
                    );

            year =
                    Integer.parseInt(
                            request.getParameter(
                                    "year"
                            )
                    );

        } catch (Exception e) {

            redirectWithMessage(
                    request,
                    response,
                    0,
                    "error",
                    "Invalid teacher, programme or year."
            );

            return;
        }


        /*
         * VALIDATE PARAMETERS
         */

        if (teacherId <= 0 ||
            programmeId <= 0 ||
            year < 1 ||
            year > 4) {

            redirectWithMessage(
                    request,
                    response,
                    teacherId,
                    "error",
                    "Invalid assignment information."
            );

            return;
        }


        /*
         * SELECTED COURSE IDS
         */

        String[] courseIds =
                request.getParameterValues(
                        "courseIds"
                );


        Connection connection =
                null;


        try {

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);


            /*
             * ============================
             * VERIFY TEACHER
             * ============================
             */

            String teacherCheckSql =
                    "SELECT id " +
                    "FROM teachers " +
                    "WHERE id = ?";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    teacherCheckSql
                            )
            ) {

                statement.setInt(
                        1,
                        teacherId
                );


                try (
                        ResultSet resultSet =
                                statement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                teacherId,
                                "error",
                                "Selected teacher does not exist."
                        );

                        return;
                    }
                }
            }


            /*
             * ============================
             * VERIFY PROGRAMME
             * ============================
             */

            String programmeCheckSql =
                    "SELECT id " +
                    "FROM programmes " +
                    "WHERE id = ?";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    programmeCheckSql
                            )
            ) {

                statement.setInt(
                        1,
                        programmeId
                );


                try (
                        ResultSet resultSet =
                                statement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                teacherId,
                                "error",
                                "Selected programme does not exist."
                        );

                        return;
                    }
                }
            }


            /*
             * ============================
             * DELETE OLD ASSIGNMENTS
             *
             * ONLY for the selected
             * programme + year.
             *
             * Other programme/year
             * assignments remain untouched.
             * ============================
             */

            String deleteSql =
                    "DELETE FROM teacher_courses " +
                    "WHERE teacher_id = ? " +
                    "AND course_id IN (" +
                    "SELECT id " +
                    "FROM courses " +
                    "WHERE programme_id = ? " +
                    "AND year_of_study = ?" +
                    ")";


            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    deleteSql
                            )
            ) {

                statement.setInt(
                        1,
                        teacherId
                );

                statement.setInt(
                        2,
                        programmeId
                );

                statement.setInt(
                        3,
                        year
                );

                statement.executeUpdate();
            }


            /*
             * ============================
             * INSERT SELECTED COURSES
             * ============================
             */

            if (courseIds != null &&
                courseIds.length > 0) {


                String validateCourseSql =
                        "SELECT id " +
                        "FROM courses " +
                        "WHERE id = ? " +
                        "AND programme_id = ? " +
                        "AND year_of_study = ?";


                String insertSql =
                        "INSERT INTO teacher_courses " +
                        "(teacher_id, course_id) " +
                        "VALUES (?, ?) " +
                        "ON CONFLICT " +
                        "(teacher_id, course_id) " +
                        "DO NOTHING";


                try (
                        PreparedStatement validateStatement =
                                connection.prepareStatement(
                                        validateCourseSql
                                );

                        PreparedStatement insertStatement =
                                connection.prepareStatement(
                                        insertSql
                                )
                ) {


                    for (String courseIdString :
                            courseIds) {


                        int courseId;


                        try {

                            courseId =
                                    Integer.parseInt(
                                            courseIdString
                                    );

                        } catch (NumberFormatException e) {

                            connection.rollback();

                            redirectWithMessage(
                                    request,
                                    response,
                                    teacherId,
                                    "error",
                                    "Invalid course selected."
                            );

                            return;
                        }


                        /*
                         * VERIFY COURSE
                         *
                         * The course must belong
                         * to the selected programme
                         * and year.
                         */

                        validateStatement.setInt(
                                1,
                                courseId
                        );

                        validateStatement.setInt(
                                2,
                                programmeId
                        );

                        validateStatement.setInt(
                                3,
                                year
                        );


                        boolean validCourse =
                                false;


                        try (
                                ResultSet resultSet =
                                        validateStatement
                                                .executeQuery()
                        ) {

                            if (resultSet.next()) {

                                validCourse = true;

                            }
                        }


                        if (!validCourse) {

                            connection.rollback();

                            redirectWithMessage(
                                    request,
                                    response,
                                    teacherId,
                                    "error",
                                    "One or more selected courses do not belong to the selected programme and year."
                            );

                            return;
                        }


                        /*
                         * INSERT ASSIGNMENT
                         */

                        insertStatement.setInt(
                                1,
                                teacherId
                        );

                        insertStatement.setInt(
                                2,
                                courseId
                        );

                        insertStatement.addBatch();

                    }


                    insertStatement.executeBatch();

                }

            }


            /*
             * COMMIT
             */

            connection.commit();


            redirectWithMessage(
                    request,
                    response,
                    teacherId,
                    "success",
                    "Course assignments saved successfully."
            );


        } catch (SQLException e) {

            e.printStackTrace();


            if (connection != null) {

                try {

                    connection.rollback();

                } catch (SQLException rollbackException) {

                    rollbackException.printStackTrace();

                }
            }


            redirectWithMessage(
                    request,
                    response,
                    teacherId,
                    "error",
                    "Database error while saving course assignments."
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


    /*
     * ============================
     * REDIRECT WITH MESSAGE
     * ============================
     */

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            int teacherId,
            String status,
            String message)
            throws IOException {


        String encodedMessage =
                URLEncoder.encode(
                        message,
                        "UTF-8"
                );


        String url =
                request.getContextPath()
                + "/admin/assign-courses.jsp"
                + "?teacherId="
                + teacherId
                + "&status="
                + URLEncoder.encode(
                        status,
                        "UTF-8"
                )
                + "&message="
                + encodedMessage;


        response.sendRedirect(url);

    }


    /*
     * ============================
     * JSON ESCAPE
     * ============================
     */

    private String escapeJson(
            String value) {

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