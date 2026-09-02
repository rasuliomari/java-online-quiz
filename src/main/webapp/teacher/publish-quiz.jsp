<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
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


String title = "";
String course = "";
String description = "";
String status = "";

int durationMinutes = 0;
int requiredQuestionCount = 0;
int passMark = 0;

int savedQuestionCount = 0;

boolean quizFound = false;


try (Connection connection = DBConnection.getConnection()) {

    /*
     * =====================================================
     * LOAD QUIZ
     * =====================================================
     */

    String quizSql =
        "SELECT title, course, description, duration_minutes, " +
        "question_count, pass_mark, status " +
        "FROM quizzes WHERE id = ?";

    try (PreparedStatement statement =
                 connection.prepareStatement(quizSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                quizFound = true;

                title =
                        resultSet.getString("title");

                course =
                        resultSet.getString("course");

                description =
                        resultSet.getString("description");

                durationMinutes =
                        resultSet.getInt("duration_minutes");

                requiredQuestionCount =
                        resultSet.getInt("question_count");

                passMark =
                        resultSet.getInt("pass_mark");

                status =
                        resultSet.getString("status");
            }
        }
    }


    if (!quizFound) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Quiz not found."
        );

        return;
    }


    /*
     * =====================================================
     * COUNT SAVED QUESTIONS
     * =====================================================
     */

   String countSql =
        "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

    try (PreparedStatement statement =
                 connection.prepareStatement(countSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                savedQuestionCount =
                        resultSet.getInt(1);
            }
        }
    }

} catch (SQLException e) {

    e.printStackTrace();

    response.sendError(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
            "Database error while loading quiz information."
    );

    return;
}


boolean questionCountComplete =
        savedQuestionCount == requiredQuestionCount;

boolean isDraft =
        "DRAFT".equalsIgnoreCase(status);

boolean canPublish =
        questionCountComplete && isDraft;

%>

<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="UTF-8">

<meta
    name="viewport"
    content="width=device-width, initial-scale=1.0">

<title>
    Publish Quiz - UDOM Online Quiz System
</title>


<!-- Bootstrap CSS -->
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

<!-- ========================================================= -->

<!-- NAVBAR -->

<!-- ========================================================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- BRAND -->

    <a
        class="navbar-brand d-flex align-items-center"
        href="dashboard.jsp">

        <i class="bi bi-mortarboard-fill me-2"></i>

        <span>

            UDOM

            <small class="d-block">
                Online Quiz System
            </small>

        </span>

    </a>


    <!-- MOBILE MENU -->

    <button
        class="btn btn-outline-light d-lg-none"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#teacherSidebar">

        <i class="bi bi-list"></i>

    </button>


    <!-- RIGHT SIDE -->

    <div class="d-flex align-items-center">


        <!-- NOTIFICATIONS -->

        <a
            href="#"
            class="text-white position-relative me-4">

            <i class="bi bi-bell-fill fs-5"></i>

            <span
                class="position-absolute top-0 start-100
                       translate-middle badge rounded-pill bg-danger">

                4

            </span>

        </a>


        <!-- PROFILE -->

        <div class="dropdown">

            <button
                class="btn btn-transparent text-white dropdown-toggle
                       d-flex align-items-center"
                type="button"
                data-bs-toggle="dropdown">


                <div
                    class="rounded-circle bg-primary text-white
                           d-flex align-items-center justify-content-center
                           me-2"
                    style="width:40px;height:40px;">

                    RO

                </div>


                <div class="text-start d-none d-md-block">

                    <strong>
                        Lecturer
                    </strong>

                    <small class="d-block text-light">
                        Academic Staff
                    </small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end">

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
                        href="#">

                        <i class="bi bi-box-arrow-right me-2"></i>

                        Logout

                    </a>

                </li>

            </ul>

        </div>

    </div>

</div>

</nav>

<!-- ========================================================= -->

<!-- SIDEBAR -->

<!-- ========================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="teacherSidebar">

<div class="offcanvas-header d-lg-none">

    <h5 class="offcanvas-title">
        Menu
    </h5>

    <button
        type="button"
        class="btn-close"
        data-bs-dismiss="offcanvas">
    </button>

</div>


<div class="sidebar-content">


    <a
        href="dashboard.jsp"
        class="sidebar-link">

        <i class="bi bi-speedometer2"></i>

        <span>
            Dashboard
        </span>

    </a>


    <a
        href="create-quiz.jsp"
        class="sidebar-link active">

        <i class="bi bi-plus-circle"></i>

        <span>
            Create Quiz
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-journal-text"></i>

        <span>
            My Quizzes
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-question-circle"></i>

        <span>
            Questions
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-bar-chart-fill"></i>

        <span>
            Student Results
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-file-earmark-bar-graph"></i>

        <span>
            Quiz Reports
        </span>

    </a>


    <hr>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-person-circle"></i>

        <span>
            My Profile
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-gear"></i>

        <span>
            Settings
        </span>

    </a>


    <a
        href="#"
        class="sidebar-link text-danger">

        <i class="bi bi-box-arrow-right"></i>

        <span>
            Logout
        </span>

    </a>

</div>

</div>

<!-- ========================================================= -->

<!-- MAIN CONTENT -->

<!-- ========================================================= -->

<main class="dashboard-main">
<div class="dashboard-container">


    <!-- PAGE HEADER -->

    <div class="welcome-section mb-4">

        <div>

            <h1>

                <i class="bi bi-send-fill me-2"></i>

                Publish Quiz

            </h1>

            <p class="text-muted mb-0">

                Review the quiz information before publishing.

            </p>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- QUIZ INFORMATION -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-body">


            <div
                class="d-flex justify-content-between
                       align-items-start flex-wrap gap-3">


                <div>

                    <h3 class="mb-2">

                        <%= title %>

                    </h3>


                    <p class="text-muted mb-1">

                        <i class="bi bi-book me-2"></i>

                        <strong>
                            Course:
                        </strong>

                        <%= course %>

                    </p>


                    <p class="text-muted mb-0">

                        <i class="bi bi-clock me-2"></i>

                        <strong>
                            Duration:
                        </strong>

                        <%= durationMinutes %> minutes

                    </p>

                </div>


                <div>

                    <% if ("PUBLISHED".equalsIgnoreCase(status)) { %>

                        <span class="badge bg-success fs-6">

                            <i class="bi bi-check-circle me-1"></i>

                            PUBLISHED

                        </span>

                    <% } else { %>

                        <span class="badge bg-warning text-dark fs-6">

                            <i class="bi bi-pencil-square me-1"></i>

                            DRAFT

                        </span>

                    <% } %>

                </div>

            </div>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- PUBLISH CHECKLIST -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-body">


            <h4 class="mb-4">

                <i class="bi bi-check2-square me-2"></i>

                Publication Checklist

            </h4>


            <!-- QUESTION COUNT -->

            <div
                class="d-flex align-items-center
                       justify-content-between
                       border-bottom py-3">

                <div
                    class="d-flex align-items-center">

                    <% if (questionCountComplete) { %>

                        <i
                            class="bi bi-check-circle-fill
                                   text-success fs-4 me-3">
                        </i>

                    <% } else { %>

                        <i
                            class="bi bi-exclamation-circle-fill
                                   text-warning fs-4 me-3">
                        </i>

                    <% } %>


                    <div>

                        <strong>
                            Required Questions
                        </strong>

                        <small class="d-block text-muted">

                            Questions saved:

                            <%= savedQuestionCount %>

                            /

                            <%= requiredQuestionCount %>

                        </small>

                    </div>

                </div>


                <% if (questionCountComplete) { %>

                    <span class="badge bg-success">
                        Complete
                    </span>

                <% } else { %>

                    <span class="badge bg-warning text-dark">
                        Incomplete
                    </span>

                <% } %>

            </div>


            <!-- STATUS -->

            <div
                class="d-flex align-items-center
                       justify-content-between
                       border-bottom py-3">


                <div
                    class="d-flex align-items-center">

                    <% if (isDraft) { %>

                        <i
                            class="bi bi-check-circle-fill
                                   text-success fs-4 me-3">
                        </i>

                    <% } else { %>

                        <i
                            class="bi bi-info-circle-fill
                                   text-primary fs-4 me-3">
                        </i>

                    <% } %>


                    <div>

                        <strong>
                            Quiz Status
                        </strong>

                        <small class="d-block text-muted">

                            Current status:
                            <%= status %>

                        </small>

                    </div>

                </div>


                <% if (isDraft) { %>

                    <span class="badge bg-success">
                        Ready
                    </span>

                <% } else { %>

                    <span class="badge bg-primary">
                        <%= status %>
                    </span>

                <% } %>

            </div>


            <!-- PASS MARK -->

            <div
                class="d-flex align-items-center
                       justify-content-between
                       py-3">


                <div
                    class="d-flex align-items-center">

                    <i
                        class="bi bi-award-fill
                               text-primary fs-4 me-3">
                    </i>


                    <div>

                        <strong>
                            Pass Mark
                        </strong>

                        <small class="d-block text-muted">

                            Students must achieve at least

                            <%= passMark %>%

                        </small>

                    </div>

                </div>


                <span class="badge bg-primary">

                    <%= passMark %>%

                </span>

            </div>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- DESCRIPTION -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-body">

            <h5>

                <i class="bi bi-card-text me-2"></i>

                Quiz Description

            </h5>


            <p class="text-muted mb-0">

                <%
                    if (description != null
                            && !description.trim().isEmpty()) {
                %>

                    <%= description %>

                <%
                    } else {
                %>

                    No description provided.

                <%
                    }
                %>

            </p>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- WARNING -->
    <!-- ================================================= -->

    <% if (!questionCountComplete) { %>

        <div
            class="alert alert-warning
                   d-flex align-items-start mb-4">

            <i
                class="bi bi-exclamation-triangle-fill
                       fs-4 me-3">
            </i>


            <div>

                <strong>
                    Quiz is not ready to publish.
                </strong>

                <p class="mb-0 mt-1">

                    You need to add all required questions
                    before this quiz can be published.

                </p>

            </div>

        </div>

    <% } %>


    <!-- ================================================= -->
    <!-- ALREADY PUBLISHED -->
    <!-- ================================================= -->

    <% if ("PUBLISHED".equalsIgnoreCase(status)) { %>

        <div
            class="alert alert-success
                   d-flex align-items-center mb-4">

            <i
                class="bi bi-check-circle-fill
                       fs-4 me-3">
            </i>


            <div>

                <strong>
                    This quiz has already been published.
                </strong>

                <p class="mb-0">
                    The quiz is currently available as published.
                </p>

            </div>

        </div>

    <% } %>


    <!-- ================================================= -->
    <!-- ACTIONS -->
    <!-- ================================================= -->

    <div
        class="content-card">

        <div
            class="card-body">

            <div
                class="d-flex justify-content-between
                       align-items-center flex-wrap gap-3">


                <!-- BACK -->

                <a
                    href="review-quiz.jsp?quizId=<%= quizId %>"
                    class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left me-1"></i>

                    Back to Review

                </a>


                <div class="d-flex gap-2">


                    <!-- ADD QUESTIONS -->

                    <% if (!questionCountComplete
                            && isDraft) { %>

                        <a
                            href="add-questions.jsp?quizId=<%= quizId %>"
                            class="btn btn-outline-primary">

                            <i class="bi bi-plus-circle me-1"></i>

                            Add Questions

                        </a>

                    <% } %>


                    <!-- PUBLISH -->

                    <% if (canPublish) { %>

                        <form
                            action="../publishQuiz"
                            method="post"
                            class="d-inline">

                            <input
                                type="hidden"
                                name="quizId"
                                value="<%= quizId %>">


                            <button
                                type="submit"
                                class="btn btn-primary"
                                onclick="return confirm(
                                    'Are you sure you want to publish this quiz?'
                                );">

                                <i
                                    class="bi bi-send-fill me-1">
                                </i>

                                Confirm Publish

                            </button>

                        </form>

                    <% } else if (!"PUBLISHED".equalsIgnoreCase(status)) { %>

                        <button
                            type="button"
                            class="btn btn-secondary"
                            disabled>

                            <i
                                class="bi bi-lock-fill me-1">
                            </i>

                            Publish Quiz

                        </button>

                    <% } %>

                </div>

            </div>

        </div>

    </div>


</div>

</main>

<!-- ========================================================= -->

<!-- FOOTER -->

<!-- ========================================================= -->

<footer class="dashboard-footer">
<div class="container-fluid">

    <div class="text-center">

        <small>

            © 2026 University of Dodoma -
            Online Quiz System

        </small>

    </div>

</div>

</footer>

<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
