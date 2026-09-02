<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /* ============================================================
       GET QUIZ ID
       ============================================================ */

    String quizIdValue = request.getParameter("quizId");

    if (quizIdValue == null || quizIdValue.trim().isEmpty()) {
        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Quiz ID is required."
        );
        return;
    }

    int quizId;

    try {
        quizId = Integer.parseInt(quizIdValue);
    } catch (NumberFormatException e) {
        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid quiz ID."
        );
        return;
    }


    /* ============================================================
       VARIABLES
       ============================================================ */

    String quizTitle = "";
    String course = "";
    String description = "";
    String status = "";

    int duration = 0;
    int questionCount = 0;
    int passMark = 0;

    int availableQuizzes = 0;


    /* ============================================================
       DATABASE
       ============================================================ */

    try (Connection connection = DBConnection.getConnection()) {

        /* --------------------------------------------------------
           COUNT AVAILABLE PUBLISHED QUIZZES
           -------------------------------------------------------- */

        String countSql =
                "SELECT COUNT(*) " +
                "FROM quizzes " +
                "WHERE status = 'PUBLISHED'";

        try (PreparedStatement statement =
                     connection.prepareStatement(countSql);
             ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {
                availableQuizzes = resultSet.getInt(1);
            }
        }


        /* --------------------------------------------------------
           LOAD QUIZ
           -------------------------------------------------------- */

        String quizSql =
                "SELECT title, course, description, " +
                "duration_minutes, question_count, " +
                "pass_mark, status " +
                "FROM quizzes " +
                "WHERE id = ? " +
                "AND status = 'PUBLISHED'";

        try (PreparedStatement statement =
                     connection.prepareStatement(quizSql)) {

            statement.setInt(1, quizId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    quizTitle = resultSet.getString("title");
                    course = resultSet.getString("course");
                    description = resultSet.getString("description");

                    duration =
                            resultSet.getInt("duration_minutes");

                    questionCount =
                            resultSet.getInt("question_count");

                    passMark =
                            resultSet.getInt("pass_mark");

                    status =
                            resultSet.getString("status");

                } else {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Quiz not found or it is not published."
                    );

                    return;
                }
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Database error while loading the quiz."
        );

        return;
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Take Quiz - <%= quizTitle %>
    </title>


    <!-- Bootstrap CSS -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- SAME DASHBOARD CSS -->

    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>


<body>


<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">


        <!-- Mobile Sidebar Button -->

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#studentSidebar">

            <i class="bi bi-list"></i>

        </button>


        <!-- Brand -->

        <a
            class="navbar-brand d-flex align-items-center"
            href="dashboard.jsp">

            <div class="brand-icon">

                <i class="bi bi-mortarboard-fill"></i>

            </div>

            <div class="brand-text">

                <span>UDOM</span>

                <small>
                    Online Quiz System
                </small>

            </div>

        </a>


        <!-- Right Side -->

        <div class="d-flex align-items-center ms-auto">


            <!-- Notification -->

            <button
                class="notification-btn me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    3
                </span>

            </button>


            <!-- Profile -->

            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        RO
                    </div>

                    <div class="student-name d-none d-md-block">

                        <strong>
                            Student
                        </strong>

                        <small>
                            Student Account
                        </small>

                    </div>

                </button>


                <ul
                    class="dropdown-menu dropdown-menu-end shadow">

                    <li>

                        <a
                            class="dropdown-item"
                            href="#">

                            <i class="bi bi-person me-2"></i>

                            My Profile

                        </a>

                    </li>


                    <li>

                        <a
                            class="dropdown-item"
                            href="#">

                            <i class="bi bi-gear me-2"></i>

                            Settings

                        </a>

                    </li>


                    <li>

                        <hr class="dropdown-divider">

                    </li>


                    <li>

                        <a
                            class="dropdown-item text-danger"
                            href="../login.jsp">

                            <i class="bi bi-box-arrow-right me-2"></i>

                            Logout

                        </a>

                    </li>

                </ul>

            </div>

        </div>

    </div>

</nav>



<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="studentSidebar">


    <!-- Mobile Header -->

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            Student Menu
        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="sidebar-content">


        <!-- Sidebar Profile -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                RO
            </div>

            <div>

                <h6>
                    Student
                </h6>

                <span>
                    Student Account
                </span>

            </div>

        </div>



        <!-- Sidebar Menu -->

        <div class="sidebar-menu">


            <p class="menu-title">
                MAIN MENU
            </p>


            <!-- Dashboard -->

            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- Available Quizzes -->

            <a
                href="dashboard.jsp"
                class="sidebar-link active">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

                <span class="menu-badge">
                    <%= availableQuizzes %>
                </span>

            </a>


            <!-- Quiz History -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <!-- My Results -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
                </span>

            </a>


            <!-- Account -->

            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <!-- Profile -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person-fill"></i>

                <span>
                    My Profile
                </span>

            </a>


            <!-- Settings -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear-fill"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>



        <!-- Sidebar Bottom -->

        <div class="sidebar-bottom">

            <a
                href="../login.jsp"
                class="logout-link">

                <i class="bi bi-box-arrow-left"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>



<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="dashboard-main">


    <div class="container-fluid dashboard-container">


        <!-- ====================================================
             PAGE HEADER
             ==================================================== -->

        <div class="welcome-section">

            <div>

                <h1>
                    Take Quiz
                </h1>

                <p>
                    Answer all questions before submitting your quiz.
                </p>

            </div>


            <div>

                <a
                    href="dashboard.jsp"
                    class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left me-1"></i>

                    Back to Dashboard

                </a>

            </div>

        </div>



        <!-- ====================================================
             QUIZ INFORMATION
             ==================================================== -->

        <div class="content-card mb-4">


            <div class="card-header-custom">

                <div>

                    <h5 class="mb-1">

                        <i class="bi bi-journal-text me-2"></i>

                        <%= quizTitle %>

                    </h5>

                    <small class="text-muted">

                        <%= course %>

                    </small>

                </div>


                <span class="badge bg-success">

                    <%= status %>

                </span>

            </div>



            <div class="card-body">


                <% if (description != null
                        && !description.trim().isEmpty()) { %>

                    <p class="text-muted mb-4">

                        <%= description %>

                    </p>

                <% } %>



                <div class="row g-3">


                    <!-- Duration -->

                    <div class="col-md-3">

                        <div class="border rounded p-3 h-100">

                            <div class="text-muted small">

                                <i class="bi bi-clock me-1"></i>

                                Duration

                            </div>

                            <h5 class="mb-0 mt-1">

                                <%= duration %> minutes

                            </h5>

                        </div>

                    </div>



                    <!-- Questions -->

                    <div class="col-md-3">

                        <div class="border rounded p-3 h-100">

                            <div class="text-muted small">

                                <i class="bi bi-question-circle me-1"></i>

                                Questions

                            </div>

                            <h5 class="mb-0 mt-1">

                                <%= questionCount %>

                            </h5>

                        </div>

                    </div>



                    <!-- Pass Mark -->

                    <div class="col-md-3">

                        <div class="border rounded p-3 h-100">

                            <div class="text-muted small">

                                <i class="bi bi-check-circle me-1"></i>

                                Pass Mark

                            </div>

                            <h5 class="mb-0 mt-1">

                                <%= passMark %>%

                            </h5>

                        </div>

                    </div>



                    <!-- Status -->

                    <div class="col-md-3">

                        <div class="border rounded p-3 h-100">

                            <div class="text-muted small">

                                <i class="bi bi-shield-check me-1"></i>

                                Status

                            </div>

                            <h5 class="mb-0 mt-1 text-success">

                                Published

                            </h5>

                        </div>

                    </div>

                </div>

            </div>

        </div>



        <!-- ====================================================
             QUIZ TOOLBAR
             ==================================================== -->

        <div
            class="content-card mb-4">

            <div
                class="d-flex justify-content-between align-items-center flex-wrap gap-3">

                <div>

                    <strong>

                        <i class="bi bi-list-check me-2"></i>

                        Quiz Progress

                    </strong>

                    <div class="text-muted small mt-1">

                        Answered
                        <span id="answeredCount">0</span>
                        of
                        <%= questionCount %>
                        questions

                    </div>

                </div>


                <!-- Timer -->

                <div class="text-center">

                    <div class="text-muted small">

                        Time Remaining

                    </div>

                    <h4
                        id="timer"
                        class="mb-0">

                        <%= duration %>:00

                    </h4>

                </div>

            </div>


            <!-- Progress -->

            <div class="progress mt-3"
                 role="progressbar"
                 aria-label="Quiz progress"
                 aria-valuemin="0"
                 aria-valuemax="100">

                <div
                    id="quizProgress"
                    class="progress-bar"
                    style="width: 0%;">

                    0%

                </div>

            </div>

        </div>



        <!-- ====================================================
             QUIZ FORM
             ==================================================== -->

        <form
            id="quizForm"
            action="../submitQuiz"
            method="post">


            <input
                type="hidden"
                name="quizId"
                value="<%= quizId %>">



            <!-- =================================================
                 QUESTIONS
                 ================================================= -->

            <%
                try (Connection connection =
                             DBConnection.getConnection()) {

                    String questionSql =
                            "SELECT id, question_text, question_number " +
                            "FROM questions " +
                            "WHERE quiz_id = ? " +
                            "ORDER BY question_number ASC";

                    try (PreparedStatement questionStatement =
                                 connection.prepareStatement(questionSql)) {

                        questionStatement.setInt(1, quizId);

                        try (ResultSet questionResult =
                                     questionStatement.executeQuery()) {

                            while (questionResult.next()) {

                                int currentQuestionId =
                                        questionResult.getInt("id");

                                int currentQuestionNumber =
                                        questionResult.getInt("question_number");

                                String currentQuestionText =
                                        questionResult.getString("question_text");
            %>


            <!-- =================================================
                 QUESTION CARD
                 ================================================= -->

            <div class="content-card mb-4">


                <!-- Question Header -->

                <div
                    class="d-flex justify-content-between align-items-center mb-3">


                    <div>

                        <span class="badge bg-primary rounded-pill">

                            Question
                            <%= currentQuestionNumber %>

                        </span>

                    </div>


                    <span class="text-muted small">

                        <%= currentQuestionNumber %>
                        /
                        <%= questionCount %>

                    </span>

                </div>



                <!-- Question -->

                <div class="mb-4">

                    <h5 class="mb-0">

                        <%= currentQuestionText %>

                    </h5>

                </div>



                <!-- Answers -->

                <div>


                    <%
                        String answerSql =
                                "SELECT option_label, answer_text " +
                                "FROM answers " +
                                "WHERE question_id = ? " +
                                "ORDER BY option_label ASC";

                        try (PreparedStatement answerStatement =
                                     connection.prepareStatement(answerSql)) {

                            answerStatement.setInt(
                                    1,
                                    currentQuestionId
                            );

                            try (ResultSet answerResult =
                                         answerStatement.executeQuery()) {

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


                    <!-- Answer -->

                    <div
                        class="form-check border rounded p-3 mb-2">

                        <input
                            class="form-check-input ms-0 me-2"
                            type="radio"
                            name="question_<%= currentQuestionId %>"
                            id="question_<%= currentQuestionId %>_<%= optionLabel %>"
                            value="<%= optionLabel %>"
                            required>


                        <label
                            class="form-check-label w-100"
                            for="question_<%= currentQuestionId %>_<%= optionLabel %>">

                            <strong class="me-2">

                                <%= optionLabel %>.

                            </strong>

                            <%= answerText %>

                        </label>

                    </div>


                    <%
                                }
                            }
                        }
                    %>


                </div>

            </div>


            <%
                            }
                        }
                    }

                } catch (SQLException e) {

                    e.printStackTrace();
            %>


            <div class="alert alert-danger">

                <i class="bi bi-exclamation-triangle me-2"></i>

                Unable to load quiz questions.

            </div>


            <%
                }
            %>


        </form>



        <!-- ====================================================
             SUBMIT AREA
             ==================================================== -->

        <div class="content-card mb-4">


            <div
                class="d-flex justify-content-between align-items-center flex-wrap gap-3">


                <div>

                    <strong>

                        <i class="bi bi-info-circle me-2"></i>

                        Ready to submit?

                    </strong>

                    <p class="text-muted small mb-0 mt-1">

                        Make sure you have answered all questions.

                    </p>

                </div>


                <button
                    type="submit"
                    form="quizForm"
                    class="btn btn-primary">

                    <i class="bi bi-send-fill me-1"></i>

                    Submit Quiz

                </button>

            </div>

        </div>



        <!-- ====================================================
             FOOTER
             ==================================================== -->

        <footer class="dashboard-footer">

            <p>
                © 2026 UDOM Online Quiz System.
                University of Dodoma.
            </p>

            <div>

                <a href="#">
                    Help
                </a>

                <a href="#">
                    Privacy
                </a>

                <a href="#">
                    Support
                </a>

            </div>

        </footer>


    </div>

</main>



<!-- ============================================================
     BOOTSTRAP JS
     ============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>



<!-- ============================================================
     QUIZ JAVASCRIPT
     ============================================================ -->

<script>

    /* ============================================================
       TIMER
       ============================================================ */

    let totalSeconds = <%= duration %> * 60;

    const timer =
        document.getElementById("timer");

    const quizForm =
        document.getElementById("quizForm");


    function updateTimer() {

        const minutes =
            Math.floor(totalSeconds / 60);

        const seconds =
            totalSeconds % 60;


        timer.textContent =
            minutes +
            ":" +
            (seconds < 10 ? "0" : "") +
            seconds;


        /* Last minute warning */

        if (totalSeconds <= 60) {

            timer.classList.add("text-danger");

        } else {

            timer.classList.remove("text-danger");

        }


        /* Time finished */

        if (totalSeconds <= 0) {

            clearInterval(timerInterval);

            alert(
                "Time is over. Your quiz will be submitted automatically."
            );

            quizForm.submit();

            return;
        }


        totalSeconds--;

    }


    updateTimer();


    const timerInterval =
        setInterval(updateTimer, 1000);



    /* ============================================================
       QUIZ PROGRESS
       ============================================================ */

    const answeredCount =
        document.getElementById("answeredCount");

    const quizProgress =
        document.getElementById("quizProgress");


    function updateProgress() {

        const selectedAnswers =
            document.querySelectorAll(
                '#quizForm input[type="radio"]:checked'
            );


        const uniqueQuestions =
            new Set();


        selectedAnswers.forEach(function (radio) {

            uniqueQuestions.add(
                radio.name
            );

        });


        const answered =
            uniqueQuestions.size;


        const total =
            <%= questionCount %>;


        let percentage = 0;


        if (total > 0) {

            percentage =
                Math.round(
                    (answered / total) * 100
                );

        }


        answeredCount.textContent =
            answered;


        quizProgress.style.width =
            percentage + "%";


        quizProgress.textContent =
            percentage + "%";

    }


    document
        .querySelectorAll(
            '#quizForm input[type="radio"]'
        )
        .forEach(function (radio) {

            radio.addEventListener(
                "change",
                updateProgress
            );

        });


    updateProgress();



    /* ============================================================
       SUBMIT CONFIRMATION
       ============================================================ */

    quizForm.addEventListener(
        "submit",
        function (event) {

            const confirmed =
                confirm(
                    "Are you sure you want to submit this quiz?"
                );


            if (!confirmed) {

                event.preventDefault();

            }

        }
    );

</script>


</body>

</html>