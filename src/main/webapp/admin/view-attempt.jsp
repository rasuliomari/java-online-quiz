<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    HttpSession currentSession = request.getSession(false);

    if (currentSession == null ||
        !Boolean.TRUE.equals(currentSession.getAttribute("adminLoggedIn")) ||
        !"ADMIN".equals(currentSession.getAttribute("userRole"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String adminFirstName =
            (String) currentSession.getAttribute("adminFirstName");

    String adminLastName =
            (String) currentSession.getAttribute("adminLastName");

    if (adminFirstName == null) {
        adminFirstName = "Administrator";
    }

    if (adminLastName == null) {
        adminLastName = "";
    }

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();


    String idParameter = request.getParameter("id");

    int attemptId = 0;

    try {
        attemptId = Integer.parseInt(idParameter);
    } catch (Exception e) {
        response.sendRedirect(
                request.getContextPath() + "/admin/results.jsp"
        );
        return;
    }


    String studentName = "";
    String registrationNumber = "";
    String email = "";
    String college = "";
    String programme = "";

    String quizTitle = "";
    String courseCode = "";
    String courseName = "";

    int score = 0;
    int totalQuestions = 0;
    double percentage = 0.0;

    String resultStatus = "";

    Timestamp startedAt = null;
    Timestamp submittedAt = null;

    boolean attemptFound = false;


    String attemptSql =
            "SELECT " +
            "qa.score, " +
            "qa.total_questions, " +
            "qa.percentage, " +
            "qa.result_status, " +
            "qa.started_at, " +
            "qa.submitted_at, " +

            "s.first_name, " +
            "s.middle_name, " +
            "s.last_name, " +
            "s.registration_number, " +
            "s.email, " +
            "s.college, " +
            "s.programme, " +

            "q.title AS quiz_title, " +
            "COALESCE(c.course_code, q.course) AS course_code, " +
            "COALESCE(c.course_name, q.course) AS course_name " +

            "FROM quiz_attempts qa " +

            "JOIN students s " +
            "ON qa.student_id = s.id " +

            "JOIN quizzes q " +
            "ON qa.quiz_id = q.id " +

            "LEFT JOIN courses c " +
            "ON q.course_id = c.id " +

            "WHERE qa.id = ?";


    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps =
             conn.prepareStatement(attemptSql)) {

        ps.setInt(1, attemptId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                attemptFound = true;

                String firstName =
                        rs.getString("first_name");

                String middleName =
                        rs.getString("middle_name");

                String lastName =
                        rs.getString("last_name");

                studentName =
                        ((firstName == null ? "" : firstName)
                        + " "
                        + (middleName == null ? "" : middleName)
                        + " "
                        + (lastName == null ? "" : lastName))
                        .trim();

                registrationNumber =
                        rs.getString("registration_number");

                email =
                        rs.getString("email");

                college =
                        rs.getString("college");

                programme =
                        rs.getString("programme");

                quizTitle =
                        rs.getString("quiz_title");

                courseCode =
                        rs.getString("course_code");

                courseName =
                        rs.getString("course_name");

                score =
                        rs.getInt("score");

                totalQuestions =
                        rs.getInt("total_questions");

                percentage =
                        rs.getDouble("percentage");

                resultStatus =
                        rs.getString("result_status");

                startedAt =
                        rs.getTimestamp("started_at");

                submittedAt =
                        rs.getTimestamp("submitted_at");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }


    if (!attemptFound) {

        response.sendRedirect(
                request.getContextPath() +
                "/admin/results.jsp?error=attempt_not_found"
        );

        return;
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        View Student Result | UDOM Online Quiz System
    </title>


    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">


    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>


<body>


<!-- ================= NAVBAR ================= -->

<nav class="navbar dashboard-navbar fixed-top">

    <div class="container-fluid">


        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>


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


        <div class="ms-auto d-flex align-items-center">


            <button
                class="notification-btn me-3"
                type="button">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    4
                </span>

            </button>


            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">


                    <div class="student-avatar">

                        <%= adminFirstName
                                .substring(0, 1)
                                .toUpperCase() %>

                    </div>


                    <div class="student-name d-none d-md-block">

                        <strong>
                            <%= adminFullName %>
                        </strong>

                        <small>
                            System Administrator
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
                            href="../logout">

                            <i class="bi bi-box-arrow-right me-2"></i>
                            Logout

                        </a>

                    </li>

                </ul>

            </div>

        </div>

    </div>

</nav>


<!-- ================= SIDEBAR ================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">


    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            UDOM Online Quiz System
        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="sidebar-content">


        <div class="sidebar-profile">

            <div class="student-avatar">

                <%= adminFirstName
                        .substring(0, 1)
                        .toUpperCase() %>

            </div>


            <div>

                <strong>
                    <%= adminFullName %>
                </strong>

                <small>
                    Administrator
                </small>

            </div>

        </div>


        <div class="sidebar-menu">


            <p class="menu-title">
                MAIN MENU
            </p>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-speedometer2"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="create-teacher.jsp"
                class="sidebar-link">

                <i class="bi bi-person-plus"></i>

                <span>
                    Create Teacher
                </span>

            </a>


            <a
                href="manage-teachers.jsp"
                class="sidebar-link">

                <i class="bi bi-person-badge"></i>

                <span>
                    Manage Teachers
                </span>

            </a>


            <a
                href="assign-courses.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Assign Courses
                </span>

            </a>


            <a
                href="manage-students.jsp"
                class="sidebar-link">

                <i class="bi bi-people"></i>

                <span>
                    Manage Students
                </span>

            </a>


            <a
                href="manage-quizzes.jsp"
                class="sidebar-link">

                <i class="bi bi-question-circle"></i>

                <span>
                    Manage Quizzes
                </span>

            </a>


            <a
                href="results.jsp"
                class="sidebar-link active">

                <i class="bi bi-bar-chart-line"></i>

                <span>
                    Student Results
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>

                <span>
                    Reports
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person"></i>

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

        </div>


        <div class="sidebar-bottom">

            <a
                href="../logout"
                class="logout-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>


<!-- ================= MAIN ================= -->

<main class="dashboard-main">


    <div class="container-fluid dashboard-container">


        <!-- HEADER -->

        <div class="welcome-section">

            <span class="welcome-label">
                RESULT DETAILS
            </span>


            <h1>
                Student Quiz Result
            </h1>


            <p>
                View the complete result and answers submitted
                by the student.
            </p>


            <div class="mt-3">

                <a
                    href="results.jsp"
                    class="btn btn-outline-secondary me-2">

                    <i class="bi bi-arrow-left me-1"></i>

                    Back to Results

                </a>

            </div>

        </div>


        <!-- ================= RESULT SUMMARY ================= -->

        <div class="row g-4 mb-4">


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-person"></i>

                    </div>


                    <div>

                        <small>
                            Student
                        </small>

                        <h6 class="mb-0">
                            <%= studentName %>
                        </h6>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-award"></i>

                    </div>


                    <div>

                        <small>
                            Score
                        </small>

                        <h3>

                            <%= score %>/<%= totalQuestions %>

                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-percent"></i>

                    </div>


                    <div>

                        <small>
                            Percentage
                        </small>

                        <h3>

                            <%= String.format(
                                "%.2f",
                                percentage
                            ) %>%

                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-check-circle"></i>

                    </div>


                    <div>

                        <small>
                            Result
                        </small>

                        <h3>

                            <%= resultStatus %>

                        </h3>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================= STUDENT INFORMATION ================= -->

        <div class="content-card mb-4">


            <div class="card-header-custom">

                <div>

                    <h5>
                        Student Information
                    </h5>

                    <p>
                        Details of the student who completed the quiz.
                    </p>

                </div>

            </div>


            <div class="row g-4">


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Full Name
                    </small>

                    <div class="fw-semibold">
                        <%= studentName %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Registration Number
                    </small>

                    <div class="fw-semibold">
                        <%= registrationNumber %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Email
                    </small>

                    <div class="fw-semibold">
                        <%= email %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        College
                    </small>

                    <div class="fw-semibold">
                        <%= college %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Programme
                    </small>

                    <div class="fw-semibold">
                        <%= programme %>
                    </div>

                </div>


            </div>

        </div>


        <!-- ================= QUIZ INFORMATION ================= -->

        <div class="content-card mb-4">


            <div class="card-header-custom">

                <div>

                    <h5>
                        Quiz Information
                    </h5>

                    <p>
                        Details of the completed quiz attempt.
                    </p>

                </div>


                <div>

<%
    if ("PASS".equals(resultStatus)) {
%>

                    <span class="badge bg-success">
                        PASS
                    </span>

<%
    } else {
%>

                    <span class="badge bg-danger">
                        FAIL
                    </span>

<%
    }
%>

                </div>

            </div>


            <div class="row g-4">


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Quiz Title
                    </small>

                    <div class="fw-semibold">
                        <%= quizTitle %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Course Code
                    </small>

                    <div class="fw-semibold">
                        <%= courseCode == null
                            ? "-"
                            : courseCode %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Course Name
                    </small>

                    <div class="fw-semibold">
                        <%= courseName == null
                            ? "-"
                            : courseName %>
                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Score
                    </small>

                    <div class="fw-semibold">

                        <%= score %>
                        /
                        <%= totalQuestions %>

                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Started At
                    </small>

                    <div class="fw-semibold">

                        <%= startedAt == null
                            ? "-"
                            : startedAt %>

                    </div>

                </div>


                <div class="col-md-6 col-lg-4">

                    <small class="text-muted">
                        Submitted At
                    </small>

                    <div class="fw-semibold">

                        <%= submittedAt == null
                            ? "-"
                            : submittedAt %>

                    </div>

                </div>


            </div>

        </div>


        <!-- ================= ANSWERS ================= -->

        <div class="content-card mb-4">


            <div class="card-header-custom">

                <div>

                    <h5>
                        Submitted Answers
                    </h5>

                    <p>
                        Questions, selected answers and correct answers.
                    </p>

                </div>

            </div>


            <div class="mt-3">

<%
    String questionsSql =
            "SELECT " +
            "q.id AS question_id, " +
            "q.question_number, " +
            "q.question_text, " +
            "qaa.selected_option, " +
            "qaa.is_correct AS attempt_is_correct, " +

            "(SELECT a.answer_text " +
            " FROM answers a " +
            " WHERE a.question_id = q.id " +
            " AND a.is_correct = TRUE " +
            " LIMIT 1) AS correct_answer_text, " +

            "(SELECT a.option_label " +
            " FROM answers a " +
            " WHERE a.question_id = q.id " +
            " AND a.is_correct = TRUE " +
            " LIMIT 1) AS correct_option " +

            "FROM quiz_attempt_answers qaa " +

            "JOIN questions q " +
            "ON qaa.question_id = q.id " +

            "WHERE qaa.attempt_id = ? " +

            "ORDER BY q.question_number";


    int questionCounter = 0;


    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps =
             conn.prepareStatement(questionsSql)) {

        ps.setInt(1, attemptId);


        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                questionCounter++;

                int questionNumber =
                        rs.getInt("question_number");

                String questionText =
                        rs.getString("question_text");

                String selectedOption =
                        rs.getString("selected_option");

                String correctOption =
                        rs.getString("correct_option");

                String correctAnswerText =
                        rs.getString("correct_answer_text");

                boolean isCorrect =
                        rs.getBoolean("attempt_is_correct");
%>


                <div class="border rounded-3 p-4 mb-4">


                    <div
                        class="d-flex justify-content-between align-items-start mb-3">


                        <h6 class="mb-0">

                            Question
                            <%= questionNumber %>

                        </h6>


<%
    if (isCorrect) {
%>

                        <span class="badge bg-success">

                            <i class="bi bi-check-circle me-1"></i>

                            Correct

                        </span>

<%
    } else {
%>

                        <span class="badge bg-danger">

                            <i class="bi bi-x-circle me-1"></i>

                            Incorrect

                        </span>

<%
    }
%>

                    </div>


                    <p class="mb-4">

                        <%= questionText %>

                    </p>


                    <div class="row g-3">


                        <div class="col-md-6">


                            <div class="p-3 rounded bg-light">


                                <small class="text-muted d-block mb-1">

                                    Student's Answer

                                </small>


<%
    if (selectedOption == null) {
%>

                                <strong class="text-muted">

                                    Not Answered

                                </strong>

<%
    } else {
%>

                                <strong>

                                    Option <%= selectedOption %>

                                </strong>

<%
    }
%>

                            </div>

                        </div>


                        <div class="col-md-6">


                            <div class="p-3 rounded bg-light">


                                <small class="text-muted d-block mb-1">

                                    Correct Answer

                                </small>


                                <strong>

                                    Option
                                    <%= correctOption == null
                                        ? "-"
                                        : correctOption %>

                                    <% if (correctAnswerText != null) { %>

                                        — <%= correctAnswerText %>

                                    <% } %>

                                </strong>

                            </div>

                        </div>


                    </div>


                    <!-- SHOW OPTIONS -->

                    <div class="mt-4">


                        <small
                            class="text-muted d-block mb-2">

                            Answer Options

                        </small>


                        <div class="row g-2">


<%
    String optionsSql =
            "SELECT option_label, answer_text, is_correct " +
            "FROM answers " +
            "WHERE question_id = ? " +
            "ORDER BY option_label";


    try (PreparedStatement optionPs =
             conn.prepareStatement(optionsSql)) {

        optionPs.setInt(
                1,
                rs.getInt("question_id")
        );


        try (ResultSet optionRs =
                 optionPs.executeQuery()) {

            while (optionRs.next()) {

                String optionLabel =
                        optionRs.getString("option_label");

                String answerText =
                        optionRs.getString("answer_text");

                boolean optionCorrect =
                        optionRs.getBoolean("is_correct");
%>


                            <div class="col-12">


                                <div class="border rounded p-2">


                                    <strong>
                                        <%= optionLabel %>.
                                    </strong>


                                    <span>
                                        <%= answerText %>
                                    </span>


<%
    if (optionCorrect) {
%>

                                    <span
                                        class="badge bg-success ms-2">

                                        Correct

                                    </span>

<%
    }
%>

                                </div>

                            </div>


<%
            }
        }
    }
%>


                        </div>

                    </div>


                </div>


<%
            }


            if (questionCounter == 0) {
%>


                <div class="text-center py-5 text-muted">

                    <i
                        class="bi bi-question-circle fs-1 d-block mb-3">
                    </i>

                    <h6>
                        No question answers found
                    </h6>

                    <p class="mb-0">
                        This attempt does not contain recorded answers.
                    </p>

                </div>


<%
            }

        }


    } catch (Exception e) {

        e.printStackTrace();
%>


                <div class="alert alert-danger">

                    <i class="bi bi-exclamation-triangle me-2"></i>

                    Unable to load the submitted answers.

                </div>


<%
    }
%>

            </div>

        </div>


    </div>

</main>


<!-- ================= FOOTER ================= -->

<footer class="dashboard-footer">

    <div class="container-fluid">

        <div
            class="d-flex justify-content-between align-items-center flex-wrap">


            <p class="mb-0">

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

        </div>

    </div>

</footer>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>
