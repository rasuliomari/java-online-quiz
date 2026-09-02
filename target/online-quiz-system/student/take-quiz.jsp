
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
       PREVENT SECOND ATTEMPT
       ============================================================ */

    jakarta.servlet.http.HttpSession currentSession =
            request.getSession(false);

    String attemptKey =
            "quizAttempted_" + quizId;

    if (currentSession != null
            && Boolean.TRUE.equals(
                    currentSession.getAttribute(attemptKey))) {

        response.sendRedirect(
                "quiz-already-attempted.jsp?quizId=" + quizId
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

                    quizTitle =
                            resultSet.getString("title");

                    course =
                            resultSet.getString("course");

                    description =
                            resultSet.getString("description");

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
        <%= quizTitle %> - Take Quiz
    </title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Dashboard CSS -->
    <link
        rel="stylesheet"
        href="<%= request.getContextPath() %>/css/dashboard.css">

    <style>

        .quiz-header {
            background: linear-gradient(
                135deg,
                #0d6efd,
                #084298
            );
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
        }

        .quiz-info-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .question-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .question-number {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #0d6efd;
            color: white;
            font-weight: 600;
            flex-shrink: 0;
        }

        .option-label {
            display: block;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .option-label:hover {
            border-color: #0d6efd;
            background-color: #f8faff;
        }

        .option-label input {
            margin-right: 10px;
        }

        .timer-card {
            position: sticky;
            top: 20px;
            z-index: 100;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .timer-value {
            font-size: 30px;
            font-weight: 700;
            color: #0d6efd;
        }

        .timer-danger {
            color: #dc3545 !important;
        }

        .progress {
            height: 8px;
            border-radius: 10px;
        }

        .submit-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .submit-btn {
            min-width: 180px;
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
        }

        .quiz-description {
            white-space: pre-line;
        }

    </style>

</head>


<body>


<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">

    <div class="container-fluid">

        <a class="navbar-brand fw-bold"
           href="<%= request.getContextPath() %>/student/dashboard.jsp">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM Online Quiz

        </a>


        <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarContent">

            <span class="navbar-toggler-icon"></span>

        </button>


        <div
            class="collapse navbar-collapse"
            id="navbarContent">

            <ul class="navbar-nav ms-auto">

                <li class="nav-item">

                    <a
                        class="nav-link"
                        href="<%= request.getContextPath() %>/student/dashboard.jsp">

                        <i class="bi bi-house-door me-1"></i>

                        Dashboard

                    </a>

                </li>


                <li class="nav-item">

                    <a
                        class="nav-link"
                        href="<%= request.getContextPath() %>/student/dashboard.jsp">

                        <i class="bi bi-journal-text me-1"></i>

                        Quizzes

                    </a>

                </li>


                <li class="nav-item">

                    <a
                        class="nav-link"
                        href="<%= request.getContextPath() %>/index.jsp">

                        <i class="bi bi-box-arrow-right me-1"></i>

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

    <div class="row">


        <!-- ====================================================
             SIDEBAR
             ==================================================== -->

        <div class="col-lg-2 mb-4">

            <div class="card shadow-sm border-0">

                <div class="card-body">

                    <h6 class="text-muted mb-3">

                        <i class="bi bi-grid me-2"></i>

                        Student Menu

                    </h6>


                    <div class="list-group list-group-flush">

                        <a
                            href="<%= request.getContextPath() %>/student/dashboard.jsp"
                            class="list-group-item list-group-item-action">

                            <i class="bi bi-speedometer2 me-2"></i>

                            Dashboard

                        </a>


                        <a
                            href="<%= request.getContextPath() %>/student/dashboard.jsp"
                            class="list-group-item list-group-item-action active">

                            <i class="bi bi-question-circle me-2"></i>

                            Take Quiz

                        </a>


                        <a
                            href="<%= request.getContextPath() %>/student/dashboard.jsp"
                            class="list-group-item list-group-item-action">

                            <i class="bi bi-bar-chart me-2"></i>

                            My Results

                        </a>

                    </div>

                </div>

            </div>

        </div>



        <!-- ====================================================
             QUIZ CONTENT
             ==================================================== -->

        <div class="col-lg-8">


            <!-- =================================================
                 QUIZ HEADER
                 ================================================= -->

            <div class="quiz-header">

                <div class="d-flex align-items-start">

                    <div class="me-3">

                        <i
                            class="bi bi-journal-check fs-1">
                        </i>

                    </div>


                    <div>

                        <h2 class="fw-bold mb-2">

                            <%= quizTitle %>

                        </h2>


                        <div class="mb-2">

                            <span class="badge bg-light text-primary me-2">

                                <i class="bi bi-book me-1"></i>

                                <%= course %>

                            </span>


                            <span class="badge bg-light text-primary">

                                <i class="bi bi-check-circle me-1"></i>

                                Published

                            </span>

                        </div>


                        <% if (description != null
                                && !description.trim().isEmpty()) { %>

                            <p class="mb-0 quiz-description">

                                <%= description %>

                            </p>

                        <% } %>

                    </div>

                </div>

            </div>



            <!-- =================================================
                 QUIZ INFORMATION
                 ================================================= -->

            <div class="card quiz-info-card mb-4">

                <div class="card-body">

                    <div class="row text-center">

                        <div class="col-md-3 mb-3 mb-md-0">

                            <i
                                class="bi bi-list-ol text-primary fs-3">
                            </i>

                            <h6 class="mt-2 mb-1">

                                Questions

                            </h6>

                            <strong>

                                <%= questionCount %>

                            </strong>

                        </div>


                        <div class="col-md-3 mb-3 mb-md-0">

                            <i
                                class="bi bi-clock text-primary fs-3">
                            </i>

                            <h6 class="mt-2 mb-1">

                                Duration

                            </h6>

                            <strong>

                                <%= duration %> minutes

                            </strong>

                        </div>


                        <div class="col-md-3 mb-3 mb-md-0">

                            <i
                                class="bi bi-trophy text-primary fs-3">
                            </i>

                            <h6 class="mt-2 mb-1">

                                Pass Mark

                            </h6>

                            <strong>

                                <%= passMark %>%

                            </strong>

                        </div>


                        <div class="col-md-3">

                            <i
                                class="bi bi-collection text-primary fs-3">
                            </i>

                            <h6 class="mt-2 mb-1">

                                Available

                            </h6>

                            <strong>

                                <%= availableQuizzes %>

                            </strong>

                        </div>

                    </div>

                </div>

            </div>



            <!-- =================================================
                 WARNING
                 ================================================= -->

            <div class="alert alert-warning d-flex align-items-start">

                <i class="bi bi-exclamation-triangle-fill me-2 mt-1"></i>

                <div>

                    <strong>Important:</strong>

                    You are allowed only one attempt for this quiz.

                    Once you submit your answers, you cannot take this
                    quiz again.

                </div>

            </div>



            <!-- =================================================
                 QUIZ FORM
                 ================================================= -->

            <form
                id="quizForm"
                action="<%= request.getContextPath() %>/submitQuiz"
                method="post">


                <input
                    type="hidden"
                    name="quizId"
                    value="<%= quizId %>">


                <%
                    /* ====================================================
                       LOAD QUESTIONS
                       ==================================================== */

                    String questionSql =
                            "SELECT id, question_text, question_number " +
                            "FROM questions " +
                            "WHERE quiz_id = ? " +
                            "ORDER BY question_number ASC";

                    try (Connection questionConnection =
                                 DBConnection.getConnection();
                         PreparedStatement questionStatement =
                                 questionConnection.prepareStatement(
                                         questionSql)) {

                        questionStatement.setInt(1, quizId);

                        try (ResultSet questionResult =
                                     questionStatement.executeQuery()) {

                            while (questionResult.next()) {

                                int questionId =
                                        questionResult.getInt("id");

                                String questionText =
                                        questionResult.getString(
                                                "question_text");

                                int questionNumber =
                                        questionResult.getInt(
                                                "question_number");
                %>


                <!-- ====================================================
                     QUESTION CARD
                     ==================================================== -->

                <div class="card question-card">

                    <div class="card-body p-4">


                        <div class="d-flex align-items-start mb-4">

                            <div class="question-number me-3">

                                <%= questionNumber %>

                            </div>


                            <div class="flex-grow-1">

                                <h5 class="fw-semibold mb-0">

                                    <%= questionText %>

                                </h5>

                            </div>

                        </div>



                        <!-- ============================================
                             ANSWERS
                             ============================================ -->

                        <%
                            String answerSql =
                                    "SELECT option_label, answer_text " +
                                    "FROM answers " +
                                    "WHERE question_id = ? " +
                                    "ORDER BY option_label ASC";

                            try (PreparedStatement answerStatement =
                                         questionConnection.prepareStatement(
                                                 answerSql)) {

                                answerStatement.setInt(
                                        1,
                                        questionId
                                );

                                try (ResultSet answerResult =
                                             answerStatement.executeQuery()) {

                                    while (answerResult.next()) {

                                        String optionLabel =
                                                answerResult.getString(
                                                        "option_label");

                                        String answerText =
                                                answerResult.getString(
                                                        "answer_text");
                        %>


                        <label class="option-label">

                            <input
                                type="radio"
                                class="form-check-input"
                                name="question_<%= questionId %>"
                                value="<%= optionLabel %>"
                                required>

                            <strong class="me-2">

                                <%= optionLabel %>.

                            </strong>

                            <%= answerText %>

                        </label>


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

                    } catch (SQLException e) {

                        e.printStackTrace();
                %>


                <div class="alert alert-danger">

                    <i class="bi bi-database-x me-2"></i>

                    Unable to load quiz questions.

                </div>


                <%
                    }
                %>


                <!-- =================================================
                     SUBMIT CARD
                     ================================================= -->

                <div class="card submit-card mb-4">

                    <div class="card-body p-4 text-center">

                        <i
                            class="bi bi-send-check text-primary fs-1">
                        </i>


                        <h5 class="fw-bold mt-3">

                            Ready to Submit?

                        </h5>


                        <p class="text-muted">

                            Make sure you have answered every question
                            before submitting.

                        </p>


                        <button
                            type="submit"
                            class="btn btn-primary submit-btn">

                            <i class="bi bi-check-circle me-2"></i>

                            Submit Quiz

                        </button>

                    </div>

                </div>

            </form>

        </div>



        <!-- ====================================================
             RIGHT SIDEBAR
             ==================================================== -->

        <div class="col-lg-2">

            <div class="card timer-card">

                <div class="card-body text-center">

                    <i
                        class="bi bi-stopwatch text-primary fs-2">
                    </i>


                    <h6 class="mt-2">

                        Time Remaining

                    </h6>


                    <div
                        id="timer"
                        class="timer-value">

                        <%= duration %>:00

                    </div>


                    <div class="progress mt-3">

                        <div
                            id="progressBar"
                            class="progress-bar"
                            role="progressbar"
                            style="width: 100%;">

                        </div>

                    </div>


                    <small
                        id="timerMessage"
                        class="text-muted d-block mt-2">

                        Manage your time carefully.

                    </small>

                </div>

            </div>


            <div class="card shadow-sm border-0 mt-3">

                <div class="card-body">

                    <h6 class="fw-bold">

                        <i
                            class="bi bi-info-circle text-primary me-2">
                        </i>

                        Quiz Rules

                    </h6>


                    <ul class="small text-muted ps-3 mb-0">

                        <li class="mb-2">
                            Answer all questions.
                        </li>

                        <li class="mb-2">
                            Each question has one correct answer.
                        </li>

                        <li class="mb-2">
                            You have one attempt only.
                        </li>

                        <li>
                            Submit before the timer ends.
                        </li>

                    </ul>

                </div>

            </div>

        </div>

    </div>

</div>



<!-- ============================================================
     FOOTER
     ============================================================ -->

<footer class="bg-light border-top py-4 mt-4">

    <div class="container text-center">

        <p class="mb-1 text-muted">

            UDOM Online Quiz System

        </p>

        <small class="text-muted">

            University of Dodoma

        </small>

    </div>

</footer>



<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>



<!-- ============================================================
     QUIZ TIMER
     ============================================================ -->

<script>

    let durationMinutes = <%= duration %>;

    let totalSeconds = durationMinutes * 60;

    let remainingSeconds = totalSeconds;


    const timerElement =
        document.getElementById("timer");

    const progressBar =
        document.getElementById("progressBar");

    const timerMessage =
        document.getElementById("timerMessage");

    const quizForm =
        document.getElementById("quizForm");


    function updateTimer() {

        const minutes =
            Math.floor(remainingSeconds / 60);

        const seconds =
            remainingSeconds % 60;


        timerElement.textContent =
            minutes + ":" +
            String(seconds).padStart(2, "0");


        if (totalSeconds > 0) {

            const percentage =
                (remainingSeconds / totalSeconds) * 100;

            progressBar.style.width =
                percentage + "%";

        }


        if (remainingSeconds <= 60) {

            timerElement.classList.add(
                "timer-danger"
            );

            timerMessage.textContent =
                "Less than one minute remaining!";

        }


        if (remainingSeconds <= 0) {

            clearInterval(timerInterval);

            timerElement.textContent =
                "0:00";

            timerMessage.textContent =
                "Time is over. Submitting your quiz...";


            quizForm.submit();

            return;

        }


        remainingSeconds--;

    }


    updateTimer();


    const timerInterval =
        setInterval(updateTimer, 1000);



    /* ============================================================
       PREVENT ACCIDENTAL DOUBLE SUBMISSION
       ============================================================ */

    let submitted = false;


    quizForm.addEventListener(
        "submit",
        function (event) {

            if (submitted) {

                event.preventDefault();

                return;

            }


            submitted = true;

        }
    );



    /* ============================================================
       WARN BEFORE LEAVING PAGE
       ============================================================ */

    window.addEventListener(
        "beforeunload",
        function (event) {

            if (!submitted) {

                event.preventDefault();

                event.returnValue = "";

            }

        }
    );

</script>

</body>

</html>
