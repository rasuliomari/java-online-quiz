<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /*
     * ============================================================
     * GET SESSION
     * ============================================================
     */

    HttpSession quizSession =
            request.getSession(false);


    if (quizSession == null
            || quizSession.getAttribute(
                    "quizResultQuizId") == null) {

        response.sendRedirect("dashboard.jsp");

        return;
    }


    /*
     * ============================================================
     * RESULT INFORMATION
     * ============================================================
     */

    int quizId =
            (Integer) quizSession.getAttribute(
                    "quizResultQuizId");


    String quizTitle =
            (String) quizSession.getAttribute(
                    "quizResultTitle");


    int score =
            (Integer) quizSession.getAttribute(
                    "quizResultScore");


    int totalQuestions =
            (Integer) quizSession.getAttribute(
                    "quizResultTotal");


    double percentage =
            (Double) quizSession.getAttribute(
                    "quizResultPercentage");


    int passMark =
            (Integer) quizSession.getAttribute(
                    "quizResultPassMark");


    boolean passed =
            (Boolean) quizSession.getAttribute(
                    "quizResultPassed");


    /*
     * ============================================================
     * GET STUDENT'S SUBMITTED ANSWERS
     * ============================================================
     */

    Map<Integer, String> submittedAnswers = null;

    Object submittedAnswersObject =
            quizSession.getAttribute(
                    "quizSubmittedAnswers_" + quizId);


    if (submittedAnswersObject instanceof Map) {

        submittedAnswers =
                (Map<Integer, String>) submittedAnswersObject;
    }


    String resultMessage;


    if (passed) {

        resultMessage =
                "Congratulations! You have passed the quiz.";

    } else {

        resultMessage =
                "You did not reach the required pass mark.";
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


    <title>
        Quiz Result - UDOM Online Quiz System
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
        href="../css/dashboard.css">

</head>


<body>


<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">


        <!-- Mobile Menu -->

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

                <span>
                    UDOM
                </span>

                <small>
                    Online Quiz System
                </small>

            </div>

        </a>


        <!-- Right Navigation -->

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


        <!-- Profile -->

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


        <!-- Menu -->

        <div class="sidebar-menu">


            <p class="menu-title">
                MAIN MENU
            </p>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link active">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person-fill"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear-fill"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>


        <!-- Logout -->

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
             HEADER
             ==================================================== -->

        <div class="welcome-section">

            <div>

                <h2>
                    Quiz Result
                </h2>

                <p>
                    Your quiz submission has been evaluated.
                </p>

            </div>

        </div>



        <!-- ====================================================
             RESULT SUMMARY
             ==================================================== -->

        <div class="content-card mb-4">

            <div class="card-body p-4">


                <div class="text-center">


                    <% if (passed) { %>

                        <div class="mb-3">

                            <i
                                class="bi bi-check-circle-fill text-success"
                                style="font-size: 4rem;">
                            </i>

                        </div>


                        <h3 class="fw-bold text-success">
                            Quiz Passed
                        </h3>


                    <% } else { %>


                        <div class="mb-3">

                            <i
                                class="bi bi-x-circle-fill text-danger"
                                style="font-size: 4rem;">
                            </i>

                        </div>


                        <h3 class="fw-bold text-danger">
                            Quiz Not Passed
                        </h3>


                    <% } %>


                    <p class="text-muted mb-4">
                        <%= resultMessage %>
                    </p>

                </div>



                <!-- Result Cards -->

                <div class="row g-4">


                    <!-- Quiz -->

                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-journal-text fs-2 mb-2">
                            </i>


                            <h6 class="text-muted">
                                Quiz
                            </h6>


                            <h5 class="fw-bold">
                                <%= quizTitle %>
                            </h5>

                        </div>

                    </div>


                    <!-- Score -->

                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-check2-square fs-2 mb-2">
                            </i>


                            <h6 class="text-muted">
                                Score
                            </h6>


                            <h2 class="fw-bold">
                                <%= score %>/<%= totalQuestions %>
                            </h2>

                        </div>

                    </div>


                    <!-- Percentage -->

                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-percent fs-2 mb-2">
                            </i>


                            <h6 class="text-muted">
                                Percentage
                            </h6>


                            <h2 class="fw-bold">

                                <%= String.format(
                                        "%.1f",
                                        percentage
                                ) %>%

                            </h2>

                        </div>

                    </div>


                    <!-- Pass Mark -->

                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-flag-fill fs-2 mb-2">
                            </i>


                            <h6 class="text-muted">
                                Pass Mark
                            </h6>


                            <h2 class="fw-bold">
                                <%= passMark %>%
                            </h2>

                        </div>

                    </div>

                </div>



                <!-- Performance -->

                <div class="mt-4">

                    <div
                        class="d-flex justify-content-between mb-2">

                        <span class="fw-semibold">
                            Your Performance
                        </span>


                        <span class="fw-semibold">

                            <%= String.format(
                                    "%.1f",
                                    percentage
                            ) %>%

                        </span>

                    </div>


                    <div
                        class="progress"
                        style="height: 12px;">

                        <div
                            class="progress-bar <%= passed
                                    ? "bg-success"
                                    : "bg-danger" %>"
                            role="progressbar"
                            style="width: <%= Math.min(
                                    percentage,
                                    100
                            ) %>%;">
                        </div>

                    </div>

                </div>

            </div>

        </div>



        <!-- ====================================================
             ANSWER REVIEW
             ==================================================== -->

        <div class="content-card mb-4">


            <div class="card-header-custom">

                <div>

                    <h4>
                        <i class="bi bi-list-check me-2"></i>
                        Question Review
                    </h4>

                    <p>
                        Review your answers and compare them
                        with the correct answers.
                    </p>

                </div>

            </div>


            <div class="card-body p-4">


                <%
                    try (Connection connection =
                                 DBConnection.getConnection()) {


                        String questionSql =
                                "SELECT id, question_text, " +
                                "question_number " +
                                "FROM questions " +
                                "WHERE quiz_id = ? " +
                                "ORDER BY question_number ASC";


                        try (PreparedStatement questionStatement =
                                     connection.prepareStatement(
                                             questionSql)) {


                            questionStatement.setInt(
                                    1,
                                    quizId
                            );


                            try (ResultSet questionResult =
                                         questionStatement.executeQuery()) {


                                while (questionResult.next()) {


                                    int currentQuestionId =
                                            questionResult.getInt(
                                                    "id"
                                            );


                                    int currentQuestionNumber =
                                            questionResult.getInt(
                                                    "question_number"
                                            );


                                    String currentQuestionText =
                                            questionResult.getString(
                                                    "question_text"
                                            );


                                    String selectedAnswer = null;


                                    if (submittedAnswers != null) {

                                        selectedAnswer =
                                                submittedAnswers.get(
                                                        currentQuestionId
                                                );
                                    }


                                    String correctAnswer = null;

                                    String correctAnswerText = null;
                %>


                <!-- QUESTION -->

                <div class="border rounded p-4 mb-4">


                    <!-- Question Header -->

                    <div
                        class="d-flex justify-content-between align-items-center mb-3">


                        <span class="badge bg-primary rounded-pill">

                            Question
                            <%= currentQuestionNumber %>

                        </span>


                        <%
                            /*
                             * Find correct answer.
                             */
                            String correctSql =
                                    "SELECT option_label, answer_text " +
                                    "FROM answers " +
                                    "WHERE question_id = ? " +
                                    "AND is_correct = TRUE";


                            try (PreparedStatement correctStatement =
                                         connection.prepareStatement(
                                                 correctSql)) {


                                correctStatement.setInt(
                                        1,
                                        currentQuestionId
                                );


                                try (ResultSet correctResult =
                                             correctStatement.executeQuery()) {


                                    if (correctResult.next()) {

                                        correctAnswer =
                                                correctResult.getString(
                                                        "option_label"
                                                );


                                        correctAnswerText =
                                                correctResult.getString(
                                                        "answer_text"
                                                );
                                    }
                                }
                            }


                            boolean answerCorrect =
                                    selectedAnswer != null
                                    && selectedAnswer.equalsIgnoreCase(
                                            correctAnswer
                                    );
                        %>


                        <% if (answerCorrect) { %>

                            <span class="badge bg-success">

                                <i
                                    class="bi bi-check-circle-fill me-1">
                                </i>

                                Correct

                            </span>

                        <% } else { %>

                            <span class="badge bg-danger">

                                <i
                                    class="bi bi-x-circle-fill me-1">
                                </i>

                                Wrong

                            </span>

                        <% } %>

                    </div>



                    <!-- Question Text -->

                    <h5 class="mb-4">

                        <%= currentQuestionText %>

                    </h5>



                    <!-- OPTIONS -->

                    <%
                        String answerSql =
                                "SELECT option_label, answer_text, " +
                                "is_correct " +
                                "FROM answers " +
                                "WHERE question_id = ? " +
                                "ORDER BY option_label ASC";


                        try (PreparedStatement answerStatement =
                                     connection.prepareStatement(
                                             answerSql)) {


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


                                    boolean isCorrect =
                                            answerResult.getBoolean(
                                                    "is_correct"
                                            );


                                    boolean isSelected =
                                            selectedAnswer != null
                                            && selectedAnswer.equalsIgnoreCase(
                                                    optionLabel
                                            );


                                    String borderClass =
                                            "border";


                                    String backgroundClass = "";


                                    if (isSelected && isCorrect) {

                                        borderClass =
                                                "border border-success";

                                        backgroundClass =
                                                "bg-success-subtle";

                                    } else if (isSelected) {

                                        borderClass =
                                                "border border-danger";

                                        backgroundClass =
                                                "bg-danger-subtle";

                                    } else if (isCorrect) {

                                        borderClass =
                                                "border border-success";
                                    }
                    %>


                    <div
                        class="<%= borderClass %> rounded p-3 mb-2 <%= backgroundClass %>">


                        <div
                            class="d-flex align-items-center justify-content-between flex-wrap gap-2">


                            <div>


                                <strong class="me-2">

                                    <%= optionLabel %>.

                                </strong>


                                <span>

                                    <%= answerText %>

                                </span>

                            </div>


                            <div>


                                <% if (isSelected) { %>


                                    <% if (isCorrect) { %>

                                        <span
                                            class="badge bg-success">

                                            <i
                                                class="bi bi-person-check-fill me-1">
                                            </i>

                                            Your Answer

                                        </span>


                                    <% } else { %>

                                        <span
                                            class="badge bg-danger">

                                            <i
                                                class="bi bi-person-x-fill me-1">
                                            </i>

                                            Your Answer

                                        </span>

                                    <% } %>


                                <% } %>


                                <% if (isCorrect) { %>

                                    <span
                                        class="badge bg-success">

                                        <i
                                            class="bi bi-check-lg me-1">
                                        </i>

                                        Correct Answer

                                    </span>

                                <% } %>

                            </div>

                        </div>

                    </div>


                    <%
                                }
                            }
                        }
                    %>


                    <!-- Answer Summary -->

                    <div class="mt-4">


                        <% if (selectedAnswer != null) { %>


                            <% if (answerCorrect) { %>

                                <div class="alert alert-success mb-2">

                                    <i
                                        class="bi bi-check-circle-fill me-2">
                                    </i>


                                    <strong>
                                        Your answer:
                                    </strong>


                                    <%= selectedAnswer %>

                                    —
                                    <%= submittedAnswers != null
                                            ? "Selected answer"
                                            : "" %>

                                </div>


                            <% } else { %>

                                <div class="alert alert-danger mb-2">

                                    <i
                                        class="bi bi-x-circle-fill me-2">
                                    </i>


                                    <strong>
                                        Your answer:
                                    </strong>


                                    <%= selectedAnswer %>

                                    — Incorrect

                                </div>

                            <% } %>


                        <% } else { %>


                            <div class="alert alert-warning mb-2">

                                <i
                                    class="bi bi-exclamation-circle-fill me-2">
                                </i>


                                <strong>
                                    Your answer:
                                </strong>

                                Not answered

                            </div>


                        <% } %>


                        <div class="alert alert-success mb-0">

                            <i
                                class="bi bi-check-circle-fill me-2">
                            </i>


                            <strong>
                                Correct answer:
                            </strong>


                            <%= correctAnswer %>.


                            <%= correctAnswerText %>

                        </div>

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

                    <i
                        class="bi bi-exclamation-triangle-fill me-2">
                    </i>

                    Unable to load the question review.

                </div>


                <%
                    }
                %>

            </div>

        </div>



        <!-- ====================================================
             RESULT SUMMARY
             ==================================================== -->

        <div class="content-card mb-4">


            <div class="card-body p-4">


                <h5 class="fw-bold mb-3">

                    <i class="bi bi-info-circle me-2"></i>

                    Result Summary

                </h5>


                <div
                    class="alert <%= passed
                            ? "alert-success"
                            : "alert-danger" %>">


                    <% if (passed) { %>


                        <strong>
                            Well done!
                        </strong>


                        You achieved

                        <strong>
                            <%= String.format(
                                    "%.1f",
                                    percentage
                            ) %>%
                        </strong>

                        which meets or exceeds the required pass mark of

                        <strong>
                            <%= passMark %>%
                        </strong>.


                    <% } else { %>


                        <strong>
                            Keep practicing.
                        </strong>


                        You achieved

                        <strong>
                            <%= String.format(
                                    "%.1f",
                                    percentage
                            ) %>%
                        </strong>

                        while the required pass mark is

                        <strong>
                            <%= passMark %>%
                        </strong>.


                    <% } %>

                </div>


                <!-- ONLY BACK TO DASHBOARD -->

                <div class="d-flex flex-wrap gap-2 mt-4">

                    <a
                        href="dashboard.jsp"
                        class="btn btn-primary">

                        <i
                            class="bi bi-grid-1x2-fill me-1">
                        </i>

                        Back to Dashboard

                    </a>

                </div>

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



<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>