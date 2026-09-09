
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /*
     * ============================================================
     * STUDENT AUTHENTICATION
     * ============================================================
     */

    HttpSession studentSession =
            request.getSession(false);

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
     * LOAD PREVIOUS ATTEMPT FROM DATABASE
     * ============================================================
     */

    int attemptId = 0;

    String quizTitle = "";

    int score = 0;
    int totalQuestions = 0;
    double percentage = 0;
    String resultStatus = "";
    String submittedAt = "";
    int passMark = 0;

    boolean attemptFound = false;

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet result = null;

    try {

        connection =
                DBConnection.getConnection();

        statement =
                connection.prepareStatement(
                        "SELECT qa.id AS attempt_id, " +
                        "q.id AS quiz_id, " +
                        "q.title, " +
                        "q.pass_mark, " +
                        "qa.score, " +
                        "qa.total_questions, " +
                        "qa.percentage, " +
                        "qa.result_status, " +
                        "qa.submitted_at " +
                        "FROM quiz_attempts qa " +
                        "INNER JOIN quizzes q " +
                        "ON qa.quiz_id = q.id " +
                        "WHERE qa.quiz_id = ? " +
                        "AND qa.student_id = ?"
                );

        statement.setInt(1, quizId);
        statement.setInt(2, studentId);

        result =
                statement.executeQuery();

        if (result.next()) {

            attemptFound = true;

            attemptId =
                    result.getInt("attempt_id");

            quizTitle =
                    result.getString("title");

            passMark =
                    result.getInt("pass_mark");

            score =
                    result.getInt("score");

            totalQuestions =
                    result.getInt("total_questions");

            percentage =
                    result.getDouble("percentage");

            resultStatus =
                    result.getString("result_status");

            if (result.getTimestamp("submitted_at") != null) {

                submittedAt =
                        result.getTimestamp(
                                "submitted_at"
                        ).toString();
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                500,
                "Unable to load previous quiz attempt."
        );

        return;

    } finally {

        if (result != null) {

            try {
                result.close();
            } catch (SQLException ignored) {
            }
        }

        if (statement != null) {

            try {
                statement.close();
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
     * If no attempt exists, return to dashboard.
     */

    if (!attemptFound) {

        response.sendRedirect("dashboard.jsp");
        return;
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
                studentFirstName.substring(0, 1)
                        .toUpperCase();

        if (studentLastName != null
                && !studentLastName.isEmpty()
                && !"null".equals(studentLastName)) {

            initials +=
                    studentLastName.substring(0, 1)
                            .toUpperCase();
        }
    }


    /*
     * ============================================================
     * AVAILABLE QUIZ COUNT
     * ============================================================
     */

    int availableQuizCount = 0;

    connection = null;
    statement = null;
    result = null;

    try {

        connection =
                DBConnection.getConnection();

        statement =
                connection.prepareStatement(
                        "SELECT COUNT(*) " +
                        "FROM quizzes " +
                        "WHERE status = 'PUBLISHED'"
                );

        result =
                statement.executeQuery();

        if (result.next()) {

            availableQuizCount =
                    result.getInt(1);
        }

    } catch (SQLException e) {

        e.printStackTrace();

    } finally {

        if (result != null) {

            try {
                result.close();
            } catch (SQLException ignored) {
            }
        }

        if (statement != null) {

            try {
                statement.close();
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

    <title>
        Quiz Already Attempted - UDOM Online Quiz System
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

    <style>

        .attempt-card {
            max-width: 750px;
            margin: 50px auto;
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .attempt-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fff3cd;
            color: #856404;
            font-size: 38px;
        }

        .result-box {
            border-radius: 14px;
            background: #f8f9fa;
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

<div class="container-fluid">

    <div class="card attempt-card">

        <div class="card-body p-5 text-center">

            <div class="attempt-icon mb-4">

                <i class="bi bi-check-circle"></i>

            </div>


            <h2 class="fw-bold mb-3">

                Quiz Already Attempted

            </h2>


            <p class="text-muted mb-4">

                You have already completed this quiz.
                Each quiz can only be attempted once.

            </p>


            <h4 class="fw-bold mb-4">

                <%= quizTitle %>

            </h4>


            <!-- RESULT INFORMATION -->

            <div class="row g-3 mb-4">

                <div class="col-md-3">

                    <div class="result-box p-3">

                        <div class="small text-muted">
                            Score
                        </div>

                        <div class="fw-bold fs-4">

                            <%= score %>/<%= totalQuestions %>

                        </div>

                    </div>

                </div>


                <div class="col-md-3">

                    <div class="result-box p-3">

                        <div class="small text-muted">
                            Percentage
                        </div>

                        <div class="fw-bold fs-4">

                            <%= String.format(
                                    "%.2f",
                                    percentage
                               ) %>%

                        </div>

                    </div>

                </div>


                <div class="col-md-3">

                    <div class="result-box p-3">

                        <div class="small text-muted">
                            Pass Mark
                        </div>

                        <div class="fw-bold fs-4">

                            <%= passMark %>%

                        </div>

                    </div>

                </div>


                <div class="col-md-3">

                    <div class="result-box p-3">

                        <div class="small text-muted">
                            Result
                        </div>

                        <% if ("PASS".equalsIgnoreCase(resultStatus)) { %>

                            <span class="badge bg-success fs-6 mt-2">
                                PASS
                            </span>

                        <% } else { %>

                            <span class="badge bg-danger fs-6 mt-2">
                                FAIL
                            </span>

                        <% } %>

                    </div>

                </div>

            </div>


            <!-- SUBMISSION TIME -->

            <% if (submittedAt != null
                    && !submittedAt.trim().isEmpty()) { %>

                <p class="text-muted mb-4">

                    <i class="bi bi-calendar-check me-1"></i>

                    Submitted:

                    <%= submittedAt %>

                </p>

            <% } %>


            <!-- BUTTONS -->

            <div class="d-flex justify-content-center
                        flex-wrap gap-2">

                <a
                    href="quiz-result.jsp?quizId=<%= quizId %>&attemptId=<%= attemptId %>"
                    class="btn btn-primary">

                    <i class="bi bi-eye me-1"></i>

                    View Result

                </a>


                <a
                    href="quiz-history.jsp"
                    class="btn btn-outline-primary">

                    <i class="bi bi-clock-history me-1"></i>

                    Quiz History

                </a>


                <a
                    href="dashboard.jsp"
                    class="btn btn-outline-secondary">

                    <i class="bi bi-grid me-1"></i>

                    Dashboard

                </a>

            </div>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
