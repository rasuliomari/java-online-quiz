
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /*
     * ============================================================
     * STUDENT AUTHENTICATION
     * ============================================================
     */

    HttpSession studentSession = request.getSession(false);

    if (studentSession == null
            || !Boolean.TRUE.equals(
                    studentSession.getAttribute("studentLoggedIn"))
            || !"STUDENT".equals(
                    studentSession.getAttribute("userRole"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    Object studentIdObject =
            studentSession.getAttribute("studentId");

    if (studentIdObject == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int studentId;

    try {

        studentId =
                Integer.parseInt(
                        studentIdObject.toString()
                );

    } catch (NumberFormatException e) {

        response.sendRedirect("../login.jsp");
        return;
    }


    /*
     * ============================================================
     * GET QUIZ ID
     * ============================================================
     */

    String quizIdParameter =
            request.getParameter("quizId");

    if (quizIdParameter == null
            || quizIdParameter.trim().isEmpty()) {

        response.sendRedirect("dashboard.jsp");
        return;
    }

    int quizId;

    try {

        quizId =
                Integer.parseInt(
                        quizIdParameter
                );

    } catch (NumberFormatException e) {

        response.sendRedirect("dashboard.jsp");
        return;
    }


    /*
     * ============================================================
     * PERMANENT ATTEMPT CHECK
     *
     * Check PostgreSQL before allowing the quiz to open.
     *
     * If the student has already submitted this quiz,
     * the student cannot attempt it again.
     * ============================================================
     */

    Connection attemptConnection = null;
    PreparedStatement attemptStatement = null;
    ResultSet attemptResult = null;

    try {

        attemptConnection =
                DBConnection.getConnection();

        attemptStatement =
                attemptConnection.prepareStatement(
                        "SELECT id " +
                        "FROM quiz_attempts " +
                        "WHERE quiz_id = ? " +
                        "AND student_id = ?"
                );

        attemptStatement.setInt(1, quizId);
        attemptStatement.setInt(2, studentId);

        attemptResult =
                attemptStatement.executeQuery();

        if (attemptResult.next()) {

            response.sendRedirect(
                    "quiz-already-attempted.jsp?quizId="
                    + quizId
            );

            return;
        }

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to check previous quiz attempt."
        );

        return;

    } finally {

        if (attemptResult != null) {

            try {
                attemptResult.close();
            } catch (SQLException ignored) {
            }
        }

        if (attemptStatement != null) {

            try {
                attemptStatement.close();
            } catch (SQLException ignored) {
            }
        }

        if (attemptConnection != null) {

            try {
                attemptConnection.close();
            } catch (SQLException ignored) {
            }
        }
    }


    /*
     * ============================================================
     * LOAD QUIZ
     * ============================================================
     */

    String quizTitle = "";
    String course = "";
    String description = "";

    int durationMinutes = 0;
    int questionCount = 0;
    int passMark = 0;

    Connection connection = null;
    PreparedStatement quizStatement = null;
    ResultSet quizResult = null;

    try {

        connection =
                DBConnection.getConnection();

        quizStatement =
                connection.prepareStatement(
                        "SELECT title, course, description, " +
                        "duration_minutes, question_count, " +
                        "pass_mark, status " +
                        "FROM quizzes " +
                        "WHERE id = ? " +
                        "AND status = 'PUBLISHED'"
                );

        quizStatement.setInt(1, quizId);

        quizResult =
                quizStatement.executeQuery();

        if (!quizResult.next()) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Quiz not found or is not published."
            );

            return;
        }

        quizTitle =
                quizResult.getString("title");

        course =
                quizResult.getString("course");

        description =
                quizResult.getString("description");

        durationMinutes =
                quizResult.getInt("duration_minutes");

        questionCount =
                quizResult.getInt("question_count");

        passMark =
                quizResult.getInt("pass_mark");

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load quiz."
        );

        return;

    } finally {

        if (quizResult != null) {

            try {
                quizResult.close();
            } catch (SQLException ignored) {
            }
        }

        if (quizStatement != null) {

            try {
                quizStatement.close();
            } catch (SQLException ignored) {
            }
        }

        if (connection != null) {

            try {
                connection.close();
            } catch (SQLException ignored) {
            }
        }
    }


    /*
     * ============================================================
     * STUDENT INFORMATION
     * ============================================================
     */

    String studentFirstName =
            String.valueOf(
                    studentSession.getAttribute(
                            "studentFirstName"
                    )
            );

    String studentLastName =
            String.valueOf(
                    studentSession.getAttribute(
                            "studentLastName"
                    )
            );

    String studentFullName =
            studentFirstName;

    if (studentLastName != null
            && !"null".equals(studentLastName)
            && !studentLastName.trim().isEmpty()) {

        studentFullName =
                studentFirstName
                + " "
                + studentLastName;
    }

    String initials = "ST";

    if (studentFirstName != null
            && !studentFirstName.isEmpty()) {

        initials =
                studentFirstName
                        .substring(0, 1)
                        .toUpperCase();

        if (studentLastName != null
                && !studentLastName.isEmpty()
                && !"null".equals(studentLastName)) {

            initials +=
                    studentLastName
                            .substring(0, 1)
                            .toUpperCase();
        }
    }


    /*
     * ============================================================
     * COUNT AVAILABLE QUIZZES
     * ============================================================
     */

    int availableQuizCount = 0;

    connection = null;
    PreparedStatement availableStatement = null;
    ResultSet availableResult = null;

    try {

        connection =
                DBConnection.getConnection();

        availableStatement =
                connection.prepareStatement(
                        "SELECT COUNT(*) " +
                        "FROM quizzes " +
                        "WHERE status = 'PUBLISHED'"
                );

        availableResult =
                availableStatement.executeQuery();

        if (availableResult.next()) {

            availableQuizCount =
                    availableResult.getInt(1);
        }

    } catch (SQLException e) {

        e.printStackTrace();

    } finally {

        if (availableResult != null) {

            try {
                availableResult.close();
            } catch (SQLException ignored) {
            }
        }

        if (availableStatement != null) {

            try {
                availableStatement.close();
            } catch (SQLException ignored) {
            }
        }

        if (connection != null) {

            try {
                connection.close();
            } catch (SQLException ignored) {
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Take Quiz - UDOM Online Quiz System</title>


    <!-- ========================================================
         BOOTSTRAP
         ======================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- ========================================================
         BOOTSTRAP ICONS
         ======================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">


    <!-- ========================================================
         DASHBOARD CSS
         ======================================================== -->

    <link
        rel="stylesheet"
        href="../css/dashboard.css">


    <style>

        .quiz-header-card {
            border: none;
            border-radius: 18px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
        }


        .question-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }


        .answer-option {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 13px 16px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: 0.2s;
        }


        .answer-option:hover {
            background-color: #f8f9fa;
            border-color: #0d6efd;
        }


        .answer-option:has(
            input[type="radio"]:checked
        ) {
            background-color: #e7f1ff;
            border-color: #0d6efd;
        }


        .timer-box {
            position: sticky;
            top: 15px;
            z-index: 100;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }


        .quiz-question-number {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #0d6efd;
            color: white;
            font-weight: 600;
            margin-right: 10px;
            flex-shrink: 0;
        }


        /*
         * TIMER WARNING
         */

        .timer-warning {
            color: #dc3545 !important;
        }


        .timer-danger {
            color: #dc3545 !important;
            animation: timerPulse 1s infinite;
        }


        @keyframes timerPulse {

            0% {
                opacity: 1;
            }

            50% {
                opacity: 0.45;
            }

            100% {
                opacity: 1;
            }
        }

    </style>

</head>


<body>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div class="offcanvas offcanvas-start student-sidebar"
     tabindex="-1"
     id="studentSidebar">


    <div class="offcanvas-header">

        <h5 class="fw-bold mb-0">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM

        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="offcanvas-body">

        <div class="mb-4">

            <div class="small text-muted">

                Online Quiz System

            </div>

        </div>


        <ul class="nav flex-column gap-2">


            <li class="nav-item">

                <a class="nav-link"
                   href="dashboard.jsp">

                    <i class="bi bi-grid me-2"></i>

                    Dashboard

                </a>

            </li>


            <li class="nav-item">

                <a class="nav-link"
                   href="dashboard.jsp#available-quizzes">

                    <i class="bi bi-journal-check me-2"></i>

                    Available Quizzes

                    <span class="badge bg-primary float-end">

                        <%= availableQuizCount %>

                    </span>

                </a>

            </li>


            <li class="nav-item">

                <a class="nav-link"
                   href="quiz-history.jsp">

                    <i class="bi bi-bar-chart me-2"></i>

                    My Results

                </a>

            </li>


            <li class="nav-item">

                <a class="nav-link"
                   href="quiz-history.jsp">

                    <i class="bi bi-clock-history me-2"></i>

                    Quiz History

                </a>

            </li>


            <li class="nav-item">

                <a class="nav-link"
                   href="profile.jsp">

                    <i class="bi bi-person me-2"></i>

                    Profile

                </a>

            </li>


            <li class="nav-item mt-3">

                <a class="nav-link text-danger"
                   href="../logout">

                    <i class="bi bi-box-arrow-right me-2"></i>

                    Logout

                </a>

            </li>


        </ul>

    </div>

</div>


<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar bg-white shadow-sm">


    <div class="container-fluid">


        <button
            class="btn btn-outline-primary d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#studentSidebar">

            <i class="bi bi-list"></i>

        </button>


        <a class="navbar-brand fw-bold"
           href="dashboard.jsp">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM Online Quiz System

        </a>


        <div class="dropdown ms-auto">


            <button
                class="btn d-flex align-items-center"
                data-bs-toggle="dropdown">


                <span
                    class="rounded-circle bg-primary text-white
                           d-inline-flex align-items-center
                           justify-content-center me-2"
                    style="width:40px;height:40px;">

                    <%= initials %>

                </span>


                <span class="d-none d-md-inline">

                    <%= studentFullName %>

                </span>


                <i class="bi bi-chevron-down ms-2"></i>


            </button>


            <ul class="dropdown-menu dropdown-menu-end">


                <li>

                    <a class="dropdown-item"
                       href="profile.jsp">

                        <i class="bi bi-person me-2"></i>

                        Profile

                    </a>

                </li>


                <li>

                    <hr class="dropdown-divider">

                </li>


                <li>

                    <a class="dropdown-item text-danger"
                       href="../logout">

                        <i class="bi bi-box-arrow-right me-2"></i>

                        Logout

                    </a>

                </li>


            </ul>

        </div>

    </div>

</nav>


<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<div class="container-fluid py-4">


    <div class="row g-4">


        <!-- ====================================================
             LEFT CONTENT
             ==================================================== -->

        <div class="col-lg-9">


            <!-- =================================================
                 QUIZ HEADER
                 ================================================= -->

            <div class="card quiz-header-card mb-4">


                <div class="card-body p-4">


                    <div
                        class="d-flex justify-content-between
                               align-items-start flex-wrap gap-3">


                        <div>


                            <span class="badge bg-primary mb-2">

                                Published Quiz

                            </span>


                            <h2 class="fw-bold mb-2">

                                <%= quizTitle %>

                            </h2>


                            <div class="text-muted mb-2">

                                <i class="bi bi-book me-1"></i>

                                <%= course %>

                            </div>


                            <% if (description != null
                                    && !description.trim().isEmpty()) { %>


                                <p class="text-muted mb-0">

                                    <%= description %>

                                </p>


                            <% } %>


                        </div>


                        <!-- =================================================
                             EXIT BUTTON
                             ================================================= -->

                        <button
                            type="button"
                            id="exitQuizButton"
                            class="btn btn-outline-secondary">

                            <i class="bi bi-box-arrow-left me-1"></i>

                            Exit

                        </button>


                    </div>


                    <hr>


                    <div class="row g-3">


                        <div class="col-md-3">


                            <div class="p-3 bg-light rounded-3">


                                <div class="text-muted small">

                                    Questions

                                </div>


                                <div class="fw-bold fs-5">

                                    <%= questionCount %>

                                </div>


                            </div>

                        </div>


                        <div class="col-md-3">


                            <div class="p-3 bg-light rounded-3">


                                <div class="text-muted small">

                                    Duration

                                </div>


                                <div class="fw-bold fs-5">

                                    <%= durationMinutes %> min

                                </div>


                            </div>

                        </div>


                        <div class="col-md-3">


                            <div class="p-3 bg-light rounded-3">


                                <div class="text-muted small">

                                    Pass Mark

                                </div>


                                <div class="fw-bold fs-5">

                                    <%= passMark %>%

                                </div>


                            </div>

                        </div>


                        <div class="col-md-3">


                            <div class="p-3 bg-light rounded-3">


                                <div class="text-muted small">

                                    Student

                                </div>


                                <div class="fw-bold">

                                    <%= studentFirstName %>

                                </div>


                            </div>

                        </div>


                    </div>

                </div>

            </div>


            <!-- =================================================
                 WARNING
                 ================================================= -->

            <div class="alert alert-warning border-0 shadow-sm">


                <i class="bi bi-exclamation-triangle-fill me-2"></i>


                <strong>Important:</strong>


                Once you submit or exit this quiz, your attempt
                will be recorded and you cannot attempt this quiz again.


            </div>


            <!-- =================================================
                 QUIZ FORM
                 ================================================= -->

            <form
                method="post"
                action="<%= request.getContextPath() %>/submitQuiz"
                id="quizForm">


                <!-- QUIZ ID -->

                <input
                    type="hidden"
                    name="quizId"
                    value="<%= quizId %>">


                <!-- =================================================
                     SUBMISSION TYPE
                     
                     normal       = Submit Quiz button
                     exit         = Exit button
                     time_expired = Timer reached zero
                     ================================================= -->

                <input
                    type="hidden"
                    name="submissionType"
                    id="submissionType"
                    value="normal">


                <%
                    /*
                     * ====================================================
                     * LOAD QUESTIONS
                     * ====================================================
                     */

                    Connection questionConnection = null;
                    PreparedStatement questionStatement = null;
                    ResultSet questionResult = null;

                    try {

                        questionConnection =
                                DBConnection.getConnection();

                        questionStatement =
                                questionConnection.prepareStatement(
                                        "SELECT id, question_text, " +
                                        "question_number " +
                                        "FROM questions " +
                                        "WHERE quiz_id = ? " +
                                        "ORDER BY question_number ASC"
                                );

                        questionStatement.setInt(
                                1,
                                quizId
                        );

                        questionResult =
                                questionStatement.executeQuery();


                        while (questionResult.next()) {


                            int currentQuestionId =
                                    questionResult.getInt("id");


                            int currentQuestionNumber =
                                    questionResult.getInt(
                                            "question_number"
                                    );


                            String questionText =
                                    questionResult.getString(
                                            "question_text"
                                    );
                %>


                <!-- =================================================
                     QUESTION CARD
                     ================================================= -->

                <div class="card question-card">


                    <div class="card-body p-4">


                        <div
                            class="d-flex align-items-start mb-3">


                            <span
                                class="quiz-question-number">

                                <%= currentQuestionNumber %>

                            </span>


                            <h5
                                class="fw-semibold mb-0 pt-1">

                                <%= questionText %>

                            </h5>


                        </div>


                        <%
                            /*
                             * =================================================
                             * LOAD ANSWERS
                             * =================================================
                             */

                            PreparedStatement answerStatement =
                                    null;

                            ResultSet answerResult =
                                    null;

                            try {

                                answerStatement =
                                        questionConnection.prepareStatement(
                                                "SELECT option_label, " +
                                                "answer_text " +
                                                "FROM answers " +
                                                "WHERE question_id = ? " +
                                                "ORDER BY option_label ASC"
                                        );


                                answerStatement.setInt(
                                        1,
                                        currentQuestionId
                                );


                                answerResult =
                                        answerStatement.executeQuery();


                                while (answerResult.next()) {


                                    String optionLabel =
                                            answerResult.getString(
                                                    "option_label"
                                            );


                                    String answerText =
                                            answerResult.getString(
                                                    "answer_text"
                                            );
                        %>


                        <!-- =================================================
                             ANSWER OPTION
                             ================================================= -->

                        <label
                            class="answer-option d-block">


                            <div class="form-check">


                                <input
                                    class="form-check-input"
                                    type="radio"
                                    name="question_<%= currentQuestionId %>"
                                    value="<%= optionLabel %>">


                                <span
                                    class="form-check-label">


                                    <strong>

                                        <%= optionLabel %>.

                                    </strong>


                                    <%= answerText %>


                                </span>


                            </div>


                        </label>


                        <%
                                }

                            } finally {


                                if (answerResult != null) {

                                    try {

                                        answerResult.close();

                                    } catch (SQLException ignored) {
                                    }

                                }


                                if (answerStatement != null) {

                                    try {

                                        answerStatement.close();

                                    } catch (SQLException ignored) {
                                    }

                                }

                            }
                        %>


                    </div>

                </div>


                <%
                        }

                    } catch (SQLException e) {


                        e.printStackTrace();


                        out.println(
                            "<div class='alert alert-danger'>" +
                            "Unable to load quiz questions." +
                            "</div>"
                        );


                    } finally {


                        if (questionResult != null) {

                            try {

                                questionResult.close();

                            } catch (SQLException ignored) {
                            }

                        }


                        if (questionStatement != null) {

                            try {

                                questionStatement.close();

                            } catch (SQLException ignored) {
                            }

                        }


                        if (questionConnection != null) {

                            try {

                                questionConnection.close();

                            } catch (SQLException ignored) {
                            }

                        }

                    }
                %>


                <!-- =================================================
                     NORMAL SUBMIT
                     ================================================= -->

                <div class="card question-card">


                    <div class="card-body p-4 text-center">


                        <h5 class="fw-bold">

                            Ready to submit?

                        </h5>


                        <p class="text-muted">

                            Review your answers before submitting.
                            Unanswered questions will be submitted
                            without an answer.

                        </p>


                        <button
                            type="submit"
                            id="submitQuizButton"
                            class="btn btn-primary btn-lg px-5">


                            <i class="bi bi-send-check me-2"></i>


                            Submit Quiz


                        </button>


                    </div>

                </div>


            </form>


        </div>


        <!-- ====================================================
             RIGHT TIMER
             ==================================================== -->

        <div class="col-lg-3">


            <div class="card timer-box">


                <div class="card-body text-center p-4">


                    <div class="text-muted mb-2">


                        <i class="bi bi-clock me-1"></i>


                        Time Remaining


                    </div>


                    <div
                        id="timer"
                        class="fw-bold fs-2 text-primary">


                        <%= durationMinutes %>:00


                    </div>


                    <hr>


                    <div class="small text-muted">


                        The quiz will automatically be submitted
                        when the timer reaches zero.


                    </div>


                </div>

            </div>


        </div>


    </div>

</div>


<!-- ============================================================
     BOOTSTRAP JAVASCRIPT
     ============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>

    /*
     * ============================================================
     * QUIZ FORM
     * ============================================================
     */

    const quizForm =
        document.getElementById("quizForm");


    const timerElement =
        document.getElementById("timer");


    const exitQuizButton =
        document.getElementById("exitQuizButton");


    const submitQuizButton =
        document.getElementById("submitQuizButton");


    const submissionType =
        document.getElementById("submissionType");


    /*
     * ============================================================
     * QUIZ STATE
     * ============================================================
     */

    let quizSubmitted = false;

    let timeExpired = false;


    /*
     * ============================================================
     * SUBMIT QUIZ FUNCTION
     *
     * type can be:
     *
     * normal
     * exit
     * time_expired
     * ============================================================
     */

    function submitQuiz(type) {


        /*
         * Prevent duplicate submissions.
         */

        if (quizSubmitted) {

            return;
        }


        /*
         * Mark quiz as submitted.
         */

        quizSubmitted = true;


        /*
         * Store the submission type.
         */

        submissionType.value =
                type;


        /*
         * Stop the timer.
         */

        clearInterval(
                timerInterval
        );


        /*
         * Remove the browser's
         * leave-page warning.
         */

        window.removeEventListener(
                "beforeunload",
                preventLeaving
        );


        /*
         * Disable buttons so the
         * student cannot submit twice.
         */

        if (exitQuizButton) {

            exitQuizButton.disabled = true;
        }


        if (submitQuizButton) {

            submitQuizButton.disabled = true;
        }


        /*
         * Submit the complete form.
         *
         * All selected radio-button answers
         * will be sent to SubmitQuizServlet.
         *
         * Questions not answered will simply
         * have no parameter.
         */

        quizForm.submit();

    }


    /*
     * ============================================================
     * EXIT QUIZ
     * ============================================================
     */

    exitQuizButton.addEventListener(
        "click",
        function () {


            /*
             * Ask the student for confirmation.
             */

            const confirmExit =
                    confirm(
                        "Are you sure you want to exit this quiz?\n\n"
                        +
                        "Your quiz will be submitted with the answers "
                        +
                        "you have provided so far.\n\n"
                        +
                        "Any unanswered questions will remain "
                        +
                        "unanswered and you will not be able "
                        +
                        "to attempt this quiz again."
                    );


            /*
             * Student cancelled.
             */

            if (!confirmExit) {

                return;
            }


            /*
             * Submit the quiz.
             */

            submitQuiz("exit");

        }
    );


    /*
     * ============================================================
     * TIMER
     * ============================================================
     */

    let totalSeconds =
            <%= durationMinutes %> * 60;


    /*
     * ============================================================
     * UPDATE TIMER
     * ============================================================
     */

    function updateTimer() {


        /*
         * Do nothing if quiz was already submitted.
         */

        if (quizSubmitted) {

            return;
        }


        /*
         * Calculate minutes.
         */

        let minutes =
                Math.floor(
                    totalSeconds / 60
                );


        /*
         * Calculate seconds.
         */

        let seconds =
                totalSeconds % 60;


        /*
         * Add leading zero.
         */

        seconds =
                seconds < 10
                    ? "0" + seconds
                    : seconds;


        /*
         * Display timer.
         */

        timerElement.textContent =
                minutes + ":" + seconds;


        /*
         * ========================================================
         * TIME EXPIRED
         * ========================================================
         */

        if (totalSeconds <= 0) {


            /*
             * Stop timer.
             */

            clearInterval(
                    timerInterval
            );


            timeExpired = true;


            /*
             * Change timer appearance.
             */

            timerElement.textContent =
                    "00:00";


            timerElement.classList.remove(
                    "text-primary"
            );


            timerElement.classList.add(
                    "timer-danger"
            );


            /*
             * Tell the student what happened.
             */

            alert(
                "Time is over. Your quiz will now be submitted automatically."
            );


            /*
             * Automatically submit quiz.
             */

            submitQuiz(
                    "time_expired"
            );


            return;
        }


        /*
         * ========================================================
         * TIMER WARNINGS
         * ========================================================
         */

        /*
         * Last 5 minutes.
         */

        if (totalSeconds <= 300) {

            timerElement.classList.add(
                    "timer-warning"
            );
        }


        /*
         * Last 60 seconds.
         */

        if (totalSeconds <= 60) {

            timerElement.classList.remove(
                    "timer-warning"
            );


            timerElement.classList.add(
                    "timer-danger"
            );
        }


        /*
         * Move to next second.
         */

        totalSeconds--;

    }


    /*
     * ============================================================
     * START TIMER
     * ============================================================
     */

    updateTimer();


    const timerInterval =
            setInterval(
                updateTimer,
                1000
            );


    /*
     * ============================================================
     * NORMAL SUBMIT
     *
     * This happens when the student clicks
     * "Submit Quiz".
     * ============================================================
     */

    quizForm.addEventListener(
        "submit",
        function () {


            /*
             * If the form was submitted through
             * the Exit or timer function,
             * do not change the submission type.
             */

            if (!quizSubmitted) {

                quizSubmitted = true;


                submissionType.value =
                        "normal";


                clearInterval(
                        timerInterval
                );


                window.removeEventListener(
                        "beforeunload",
                        preventLeaving
                );

            }

        }
    );


    /*
     * ============================================================
     * PREVENT ACCIDENTAL PAGE LEAVING
     * ============================================================
     */

    function preventLeaving(event) {


        if (!quizSubmitted) {

            event.preventDefault();

            event.returnValue = "";

        }

    }


    window.addEventListener(
        "beforeunload",
        preventLeaving
    );

</script>


</body>

</html>
