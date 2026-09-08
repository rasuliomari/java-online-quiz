
package tz.udom.quiz.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

@WebServlet("/createQuiz")
public class CreateQuizServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        /*
         * ==========================================================
         * TEACHER AUTHORIZATION
         * ==========================================================
         */

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

        /*
         * ==========================================================
         * GET TEACHER ID FROM SESSION
         * ==========================================================
         */

        Integer teacherId =
                (Integer) session.getAttribute("teacherId");

        if (teacherId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=teacherLoginRequired"
            );

            return;
        }

        /*
         * ==========================================================
         * GET FORM DATA
         * ==========================================================
         */

        String quizTitle =
                clean(request.getParameter("quizTitle"));

        String courseIdValue =
                clean(request.getParameter("courseId"));

        String description =
                clean(request.getParameter("description"));

        String durationValue =
                clean(request.getParameter("duration"));

        String questionCountValue =
                clean(request.getParameter("questionCount"));

        String passMarkValue =
                clean(request.getParameter("passMark"));

        String action =
                clean(request.getParameter("action"));

        /*
         * ==========================================================
         * REQUIRED FIELD VALIDATION
         * ==========================================================
         */

        if (isEmpty(quizTitle)
                || isEmpty(courseIdValue)
                || isEmpty(description)
                || isEmpty(durationValue)
                || isEmpty(questionCountValue)
                || isEmpty(passMarkValue)) {

            redirectError(
                    request,
                    response,
                    "Please fill in all required quiz information."
            );

            return;
        }

        /*
         * ==========================================================
         * CONVERT NUMERIC VALUES
         * ==========================================================
         */

        int courseId;
        int duration;
        int questionCount;
        int passMark;

        try {

            courseId =
                    Integer.parseInt(courseIdValue);

            duration =
                    Integer.parseInt(durationValue);

            questionCount =
                    Integer.parseInt(questionCountValue);

            passMark =
                    Integer.parseInt(passMarkValue);

        } catch (NumberFormatException e) {

            redirectError(
                    request,
                    response,
                    "Course, duration, question count and pass mark must be valid numbers."
            );

            return;
        }

        /*
         * ==========================================================
         * NUMERIC VALIDATION
         * ==========================================================
         */

        if (courseId < 1) {

            redirectError(
                    request,
                    response,
                    "Please select a valid assigned course."
            );

            return;
        }

        if (duration < 1) {

            redirectError(
                    request,
                    response,
                    "Quiz duration must be at least 1 minute."
            );

            return;
        }

        if (questionCount < 1) {

            redirectError(
                    request,
                    response,
                    "Question count must be at least 1."
            );

            return;
        }

        if (passMark < 1 || passMark > 100) {

            redirectError(
                    request,
                    response,
                    "Pass mark must be between 1 and 100 percent."
            );

            return;
        }

        /*
         * ==========================================================
         * DETERMINE QUIZ STATUS
         * ==========================================================
         */

        String status = "DRAFT";

        if ("continue".equalsIgnoreCase(action)) {

            status = "DRAFT";

        } else if ("draft".equalsIgnoreCase(action)) {

            status = "DRAFT";
        }

        /*
         * ==========================================================
         * VERIFY COURSE ASSIGNMENT
         *
         * The teacher is NOT allowed to create a quiz for an
         * arbitrary course ID.
         *
         * The course must exist AND be assigned to this teacher.
         * ==========================================================
         */

        String courseSql =
                "SELECT c.id, "
                + "c.course_code, "
                + "c.course_name "
                + "FROM courses c "
                + "INNER JOIN teacher_courses tc "
                + "ON tc.course_id = c.id "
                + "WHERE tc.teacher_id = ? "
                + "AND c.id = ?";

        /*
         * ==========================================================
         * GET COURSE INFORMATION
         * ==========================================================
         */

        String courseCode;
        String courseName;

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement courseStatement =
                     connection.prepareStatement(courseSql)) {

            courseStatement.setInt(1, teacherId);
            courseStatement.setInt(2, courseId);

            try (ResultSet resultSet =
                         courseStatement.executeQuery()) {

                if (!resultSet.next()) {

                    redirectError(
                            request,
                            response,
                            "You are not assigned to the selected course."
                    );

                    return;
                }

                courseCode =
                        resultSet.getString("course_code");

                courseName =
                        resultSet.getString("course_name");
            }

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "Unable to verify the selected course."
            );

            return;
        }

        /*
         * ==========================================================
         * DISPLAY VALUE FOR EXISTING course COLUMN
         *
         * We keep the existing "course" column because it is
         * currently NOT NULL and existing pages still use it.
         *
         * The normalized relationship is stored in course_id.
         * ==========================================================
         */

        String courseDisplay =
                courseCode + " - " + courseName;

        /*
         * ==========================================================
         * INSERT QUIZ
         * ==========================================================
         */

        String insertSql =
                "INSERT INTO quizzes "
                + "(teacher_id, title, course, course_id, "
                + "description, duration_minutes, question_count, "
                + "pass_mark, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) "
                + "RETURNING id";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(insertSql)) {

            /*
             * Teacher who owns the quiz
             */
            statement.setInt(
                    1,
                    teacherId
            );

            /*
             * Quiz title
             */
            statement.setString(
                    2,
                    quizTitle
            );

            /*
             * Existing course display column
             */
            statement.setString(
                    3,
                    courseDisplay
            );

            /*
             * Normalized course foreign key
             */
            statement.setInt(
                    4,
                    courseId
            );

            /*
             * Description
             */
            statement.setString(
                    5,
                    description
            );

            /*
             * Duration
             */
            statement.setInt(
                    6,
                    duration
            );

            /*
             * Number of questions
             */
            statement.setInt(
                    7,
                    questionCount
            );

            /*
             * Pass mark
             */
            statement.setInt(
                    8,
                    passMark
            );

            /*
             * Status
             */
            statement.setString(
                    9,
                    status
            );

            /*
             * ======================================================
             * GET GENERATED QUIZ ID
             * ======================================================
             */

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    int quizId =
                            resultSet.getInt("id");

                    /*
                     * ==================================================
                     * CONTINUE → ADD QUESTIONS
                     * ==================================================
                     */

                    if ("continue".equalsIgnoreCase(action)) {

                        response.sendRedirect(
                                request.getContextPath()
                                + "/teacher/add-questions.jsp"
                                + "?quizId="
                                + quizId
                        );

                        return;
                    }

                    /*
                     * ==================================================
                     * SAVE DRAFT
                     * ==================================================
                     */

                    response.sendRedirect(
                            request.getContextPath()
                            + "/teacher/create-quiz.jsp"
                            + "?status=success"
                            + "&message="
                            + URLEncoder.encode(
                                    "Quiz draft saved successfully.",
                                    StandardCharsets.UTF_8
                            )
                    );

                    return;
                }
            }

            /*
             * ==========================================================
             * INSERT FAILED
             * ==========================================================
             */

            redirectError(
                    request,
                    response,
                    "Quiz could not be created."
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "An error occurred while creating the quiz."
            );
        }
    }

    /*
     * ==============================================================
     * CLEAN INPUT
     * ==============================================================
     */

    private static String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    /*
     * ==============================================================
     * EMPTY CHECK
     * ==============================================================
     */

    private static boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }

    /*
     * ==============================================================
     * ERROR REDIRECT
     * ==============================================================
     */

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/teacher/create-quiz.jsp"
                + "?status=error"
                + "&message="
                + URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );
    }
}
