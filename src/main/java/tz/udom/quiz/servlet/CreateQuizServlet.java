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

        HttpSession session =
                request.getSession(false);


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

        String course =
                clean(request.getParameter("course"));

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
                || isEmpty(course)
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

        int duration;

        int questionCount;

        int passMark;


        try {

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
                    "Duration, question count and pass mark must be valid numbers."
            );

            return;
        }


        /*
         * ==========================================================
         * NUMERIC VALIDATION
         * ==========================================================
         */

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
         * INSERT QUIZ
         * ==========================================================
         */

        String insertSql =
                "INSERT INTO quizzes "
                + "(teacher_id, title, course, description, "
                + "duration_minutes, question_count, pass_mark, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                + "RETURNING id";


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(insertSql)) {


            statement.setInt(
                    1,
                    teacherId
            );


            statement.setString(
                    2,
                    quizTitle
            );


            statement.setString(
                    3,
                    course
            );


            statement.setString(
                    4,
                    description
            );


            statement.setInt(
                    5,
                    duration
            );


            statement.setInt(
                    6,
                    questionCount
            );


            statement.setInt(
                    7,
                    passMark
            );


            statement.setString(
                    8,
                    status
            );


            try (ResultSet resultSet =
                         statement.executeQuery()) {


                if (resultSet.next()) {

                    int quizId =
                            resultSet.getInt("id");


                    /*
                     * Continue → Add Questions
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
                     * Save Draft
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
     * ==========================================================
     * CLEAN INPUT
     * ==========================================================
     */

    private static String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    /*
     * ==========================================================
     * EMPTY CHECK
     * ==========================================================
     */

    private static boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }


    /*
     * ==========================================================
     * ERROR REDIRECT
     * ==========================================================
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