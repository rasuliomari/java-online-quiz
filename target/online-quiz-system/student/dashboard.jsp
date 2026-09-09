
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
/*
 * ============================================================
 * STUDENT SESSION CHECK
 * ============================================================
 */

Boolean studentLoggedIn =
        (Boolean) session.getAttribute("studentLoggedIn");

if (studentLoggedIn == null || !studentLoggedIn) {

    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );

    return;
}


/*
 * ============================================================
 * CHECK STUDENT ROLE
 * ============================================================
 */

String userRole =
        (String) session.getAttribute("userRole");

if (!"STUDENT".equals(userRole)) {

    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );

    return;
}


/*
 * ============================================================
 * GET STUDENT ID
 * ============================================================
 */

Object studentIdObject =
        session.getAttribute("studentId");

if (studentIdObject == null) {

    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );

    return;
}

int studentId;

try {

    studentId =
            Integer.parseInt(
                    studentIdObject.toString()
            );

} catch (NumberFormatException e) {

    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );

    return;
}


/*
 * ============================================================
 * GET STUDENT INFORMATION
 * ============================================================
 */

String firstName =
        (String) session.getAttribute(
                "studentFirstName"
        );

String middleName =
        (String) session.getAttribute(
                "studentMiddleName"
        );

String lastName =
        (String) session.getAttribute(
                "studentLastName"
        );

String registrationNumber =
        (String) session.getAttribute(
                "studentRegistrationNumber"
        );

String email =
        (String) session.getAttribute(
                "studentEmail"
        );

String college =
        (String) session.getAttribute(
                "studentCollege"
        );

String programme =
        (String) session.getAttribute(
                "studentProgramme"
        );

Integer yearOfStudy =
        (Integer) session.getAttribute(
                "studentYearOfStudy"
        );


/*
 * ============================================================
 * DEFAULT VALUES
 * ============================================================
 */

if (firstName == null || firstName.trim().isEmpty()) {
    firstName = "Student";
}

if (middleName == null) {
    middleName = "";
}

if (lastName == null) {
    lastName = "";
}

if (registrationNumber == null) {
    registrationNumber = "";
}

if (email == null) {
    email = "";
}

if (college == null) {
    college = "";
}

if (programme == null) {
    programme = "";
}

if (yearOfStudy == null) {
    yearOfStudy = 0;
}


/*
 * ============================================================
 * FULL NAME
 * ============================================================
 */

String fullName = firstName;

if (!middleName.trim().isEmpty()) {
    fullName += " " + middleName;
}

if (!lastName.trim().isEmpty()) {
    fullName += " " + lastName;
}


/*
 * ============================================================
 * STUDENT INITIALS
 * ============================================================
 */

String initials =
        firstName.substring(0, 1).toUpperCase();

if (!lastName.trim().isEmpty()) {

    initials +=
            lastName.substring(0, 1).toUpperCase();
}


/*
 * ============================================================
 * QUIZ STATISTICS
 * ============================================================
 */

int availableQuizzes = 0;

int completedQuizzes = 0;

double averageScore = 0.0;

double highestScore = 0.0;

double lowestScore = 0.0;


/*
 * ============================================================
 * LOAD QUIZ STATISTICS FROM DATABASE
 *
 * IMPORTANT:
 * These values are NOT taken from session anymore.
 * They come permanently from quiz_attempts.
 * ============================================================
 */

try (
        Connection connection =
                DBConnection.getConnection()
) {

    String statisticsSql =
            "SELECT " +
            "COUNT(*) AS completed_quizzes, " +
            "COALESCE(AVG(percentage), 0) AS average_score, " +
            "COALESCE(MAX(percentage), 0) AS highest_score, " +
            "COALESCE(MIN(percentage), 0) AS lowest_score " +
            "FROM quiz_attempts " +
            "WHERE student_id = ?";


    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            statisticsSql
                    )
    ) {

        statement.setInt(
                1,
                studentId
        );


        try (
                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            if (resultSet.next()) {

                completedQuizzes =
                        resultSet.getInt(
                                "completed_quizzes"
                        );

                averageScore =
                        resultSet.getDouble(
                                "average_score"
                        );

                highestScore =
                        resultSet.getDouble(
                                "highest_score"
                        );

                lowestScore =
                        resultSet.getDouble(
                                "lowest_score"
                        );
            }
        }
    }


} catch (SQLException e) {

    e.printStackTrace();
}


/*
 * ============================================================
 * COUNT AVAILABLE PUBLISHED QUIZZES
 * ============================================================
 */

try (
        Connection connection =
                DBConnection.getConnection()
) {

    String countSql =
            "SELECT COUNT(*) " +
            "FROM quizzes " +
            "WHERE status = 'PUBLISHED'";


    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            countSql
                    );

            ResultSet resultSet =
                    statement.executeQuery()
    ) {

        if (resultSet.next()) {

            availableQuizzes =
                    resultSet.getInt(1);
        }
    }

} catch (SQLException e) {

    e.printStackTrace();
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
    Student Dashboard | UDOM Online Quiz System
</title>


<!-- =========================================================
     BOOTSTRAP 5.3.3
========================================================= -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- =========================================================
     BOOTSTRAP ICONS
========================================================= -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<!-- =========================================================
     DASHBOARD CSS
========================================================= -->

<link
    rel="stylesheet"
    href="../css/dashboard.css">

</head>


<body>


<!-- =========================================================
     TOP NAVBAR
========================================================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

<div class="container-fluid">


<!-- Mobile menu button -->

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


<!-- Right navigation -->

<div class="d-flex align-items-center ms-auto">


    <!-- Notification -->

    <button
        class="notification-btn me-3"
        type="button">

        <i class="bi bi-bell"></i>

        <span class="notification-badge">
            3
        </span>

    </button>


    <!-- Student profile -->

    <div class="dropdown">

        <button
            class="profile-button dropdown-toggle"
            data-bs-toggle="dropdown"
            type="button">


            <div class="student-avatar">

                <%= initials %>

            </div>


            <div class="student-name d-none d-md-block">

                <strong>
                    <%= fullName %>
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
                    href="profile.jsp">

                    <i class="bi bi-person me-2"></i>

                    My Profile

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



<!-- =========================================================
     SIDEBAR
========================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="studentSidebar">


<!-- Mobile sidebar header -->

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


<!-- =====================================================
     STUDENT PROFILE
====================================================== -->

<div class="sidebar-profile">


    <div class="sidebar-avatar">

        <%= initials %>

    </div>


    <div>

        <h6>
            <%= fullName %>
        </h6>

        <span>
            Student Account
        </span>

    </div>

</div>



<!-- =====================================================
     MENU
====================================================== -->

<div class="sidebar-menu">


<p class="menu-title">

    MAIN MENU

</p>


<!-- Dashboard -->

<a
    href="dashboard.jsp"
    class="sidebar-link active">

    <i class="bi bi-grid-1x2-fill"></i>

    <span>
        Dashboard
    </span>

</a>



<!-- Available Quizzes -->

<a
    href="#available-quizzes"
    class="sidebar-link">

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
    href="quiz-history.jsp"
    class="sidebar-link">

    <i class="bi bi-clock-history"></i>

    <span>
        Quiz History
    </span>

</a>



<!-- My Results -->

<a
    href="quiz-history.jsp"
    class="sidebar-link">

    <i class="bi bi-bar-chart-fill"></i>

    <span>
        My Results
    </span>

</a>



<p class="menu-title mt-4">

    ACCOUNT

</p>



<!-- Profile -->

<a
    href="profile.jsp"
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



<!-- =====================================================
     LOGOUT
====================================================== -->

<div class="sidebar-bottom">

    <a
        href="../logout"
        class="logout-link">

        <i class="bi bi-box-arrow-left"></i>

        <span>
            Logout
        </span>

    </a>

</div>


</div>

</div>



<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


<!-- =====================================================
     WELCOME SECTION
====================================================== -->

<div class="welcome-section">


    <div>

        <span class="welcome-label">

            STUDENT DASHBOARD

        </span>


        <h1>

            Welcome back,
            <%= firstName %>! 👋

        </h1>


        <p>

            Ready to test your knowledge?
            Explore available quizzes and keep
            improving your academic performance.

        </p>

    </div>


    <div class="welcome-icon">

        <i class="bi bi-mortarboard-fill"></i>

    </div>


</div>



<!-- =====================================================
     STUDENT INFORMATION
====================================================== -->

<div
    class="content-card mb-4"
    id="student-information">


<div class="card-header-custom">

    <div>

        <h4>
            Student Information
        </h4>

        <p>
            Your registered academic information
        </p>

    </div>

</div>


<div class="row g-4">


<div class="col-lg-3 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            Full Name
        </small>

        <h6 class="mt-1 mb-0">
            <%= fullName %>
        </h6>

    </div>

</div>



<div class="col-lg-3 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            Registration Number
        </small>

        <h6 class="mt-1 mb-0">
            <%= registrationNumber %>
        </h6>

    </div>

</div>



<div class="col-lg-3 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            Programme
        </small>

        <h6 class="mt-1 mb-0">
            <%= programme %>
        </h6>

    </div>

</div>



<div class="col-lg-3 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            Year of Study
        </small>

        <h6 class="mt-1 mb-0">

            <% if (yearOfStudy > 0) { %>

                Year <%= yearOfStudy %>

            <% } else { %>

                Not available

            <% } %>

        </h6>

    </div>

</div>



<div class="col-lg-6 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            College
        </small>

        <h6 class="mt-1 mb-0">
            <%= college %>
        </h6>

    </div>

</div>



<div class="col-lg-6 col-md-6">

    <div class="p-3">

        <small class="text-muted">
            Email
        </small>

        <h6 class="mt-1 mb-0">
            <%= email %>
        </h6>

    </div>

</div>


</div>

</div>



<!-- =====================================================
     STATISTICS
====================================================== -->

<div class="row g-4 mb-4">


<!-- Available quizzes -->

<div class="col-xl-3 col-md-6">

<div class="stat-card">


<div class="stat-icon icon-blue">

    <i class="bi bi-journal-check"></i>

</div>


<div>

    <span>
        Available Quizzes
    </span>

    <h2>
        <%= availableQuizzes %>
    </h2>

    <small>

        <i class="bi bi-journal-check"></i>

        Published quizzes

    </small>

</div>


</div>

</div>



<!-- Completed quizzes -->

<div class="col-xl-3 col-md-6">

<div class="stat-card">


<div class="stat-icon icon-green">

    <i class="bi bi-check-circle-fill"></i>

</div>


<div>

    <span>
        Completed Quizzes
    </span>

    <h2>
        <%= completedQuizzes %>
    </h2>


    <small>

        <i class="bi bi-check2"></i>

        <%= completedQuizzes > 0
                ? "Keep up the good work"
                : "No quizzes completed yet" %>

    </small>

</div>


</div>

</div>



<!-- Average score -->

<div class="col-xl-3 col-md-6">

<div class="stat-card">


<div class="stat-icon icon-purple">

    <i class="bi bi-bar-chart-fill"></i>

</div>


<div>

    <span>
        Average Score
    </span>

    <h2>
        <%= Math.round(averageScore) %>%
    </h2>


    <small>

        <i class="bi bi-bar-chart"></i>

        Based on completed quizzes

    </small>

</div>


</div>

</div>



<!-- Ranking -->

<div class="col-xl-3 col-md-6">

<div class="stat-card">


<div class="stat-icon icon-orange">

    <i class="bi bi-trophy-fill"></i>

</div>


<div>

    <span>
        Class Ranking
    </span>

    <h2>
        —
    </h2>


    <small>

        <i class="bi bi-info-circle"></i>

        Ranking not available

    </small>

</div>


</div>

</div>


</div>



<!-- =====================================================
     MAIN ROW
====================================================== -->

<div class="row g-4">


<!-- =================================================
     AVAILABLE QUIZZES
================================================== -->

<div
    class="col-xl-8"
    id="available-quizzes">


<div class="content-card">


<div class="card-header-custom">

    <div>

        <h4>
            Available Quizzes
        </h4>

        <p>
            Quizzes available for you to attempt
        </p>

    </div>


    <a href="#available-quizzes">

        View All

        <i class="bi bi-arrow-right"></i>

    </a>

</div>



<%
String quizSql =
        "SELECT id, title, course, " +
        "question_count, duration_minutes, " +
        "pass_mark " +
        "FROM quizzes " +
        "WHERE status = 'PUBLISHED' " +
        "ORDER BY created_at DESC " +
        "LIMIT 5";


try (
        Connection connection =
                DBConnection.getConnection();

        PreparedStatement statement =
                connection.prepareStatement(
                        quizSql
                );

        ResultSet resultSet =
                statement.executeQuery()
) {


    boolean hasQuizzes = false;


    while (resultSet.next()) {

        hasQuizzes = true;


        int quizId =
                resultSet.getInt("id");


        String title =
                resultSet.getString("title");


        String course =
                resultSet.getString("course");


        int questionCount =
                resultSet.getInt(
                        "question_count"
                );


        int duration =
                resultSet.getInt(
                        "duration_minutes"
                );


        int passMark =
                resultSet.getInt(
                        "pass_mark"
                );


        String icon =
                "bi-journal-check";


        if (course != null) {

            String courseLower =
                    course.toLowerCase();


            if (courseLower.contains(
                    "security")) {

                icon =
                        "bi-shield-lock-fill";

            } else if (
                    courseLower.contains(
                            "network")) {

                icon =
                        "bi-diagram-3-fill";

            } else if (
                    courseLower.contains(
                            "software")) {

                icon =
                        "bi-code-slash";

            } else if (
                    courseLower.contains(
                            "database")) {

                icon =
                        "bi-database-fill";
            }
        }

%>


<div class="quiz-item">


<div class="quiz-icon">

    <i class="bi <%= icon %>"></i>

</div>


<div class="quiz-information">

    <h5>
        <%= title %>
    </h5>


    <div class="quiz-meta">


        <span>

            <i class="bi bi-book"></i>

            <%= course %>

        </span>


        <span>

            <i class="bi bi-question-circle"></i>

            <%= questionCount %>
            Questions

        </span>


        <span>

            <i class="bi bi-clock"></i>

            <%= duration %>
            Minutes

        </span>

    </div>

</div>


<div class="quiz-action">


<span class="quiz-status">

    Available

</span>


<a
    href="take-quiz.jsp?quizId=<%= quizId %>"
    class="btn start-quiz-btn">

    Start Quiz

    <i class="bi bi-arrow-right"></i>

</a>


</div>


</div>


<%

    }


    if (!hasQuizzes) {

%>


<div class="text-center py-5">


<i
    class="bi bi-journal-x"
    style="font-size: 3rem; color: #94a3b8;">

</i>


<h5 class="mt-3">

    No Quizzes Available

</h5>


<p class="text-muted mb-0">

    There are currently no published
    quizzes available.

</p>


</div>


<%

    }

} catch (SQLException e) {

%>


<div class="alert alert-danger">

    <i
        class="bi bi-exclamation-triangle me-2">
    </i>

    Unable to load available quizzes.

</div>


<%

    e.printStackTrace();

}

%>


</div>

</div>



<!-- =================================================
     PERFORMANCE
================================================== -->

<div class="col-xl-4">


<div class="content-card performance-card">


<div class="card-header-custom">


<div>

    <h4>
        My Performance
    </h4>

    <p>
        Your quiz performance
    </p>

</div>


</div>



<div class="performance-circle">


<div class="circle-inner">


<strong>

    <%= Math.round(averageScore) %>%

</strong>


<span>
    Average
</span>


</div>

</div>



<div class="performance-info">


<div>

    <span>
        Highest Score
    </span>


    <strong>

        <%= Math.round(highestScore) %>%

    </strong>

</div>


<div>

    <span>
        Lowest Score
    </span>


    <strong>

        <%= Math.round(lowestScore) %>%

    </strong>

</div>


</div>



<div class="progress-section">


<div
    class="d-flex justify-content-between">


    <span>
        Overall Progress
    </span>


    <strong>

        <%= Math.round(averageScore) %>%

    </strong>

</div>


<div class="progress">


<div
    class="progress-bar"
    style="width: <%= Math.min(100, Math.max(0, Math.round(averageScore))) %>%">

</div>


</div>


</div>


</div>



<!-- =================================================
     UPCOMING
================================================== -->

<div
    class="content-card upcoming-card mt-4">


<div class="card-header-custom">


<div>

    <h4>
        Upcoming
    </h4>


    <p>
        Important quiz deadlines
    </p>


</div>


</div>



<div class="upcoming-item">


<div class="calendar-icon">

    <strong>
        05
    </strong>

    <span>
        SEP
    </span>

</div>


<div>

    <h6>
        Computer Security
    </h6>


    <small>
        Deadline: 11:59 PM
    </small>

</div>


</div>



<div class="upcoming-item">


<div class="calendar-icon">

    <strong>
        08
    </strong>

    <span>
        SEP
    </span>

</div>


<div>

    <h6>
        Database Systems
    </h6>


    <small>
        Deadline: 11:59 PM
    </small>

</div>


</div>


</div>


</div>


</div>



<!-- =====================================================
     RECENT RESULTS
====================================================== -->

<div
    class="content-card mt-4"
    id="recent-results">


<div class="card-header-custom">


<div>

    <h4>
        Recent Results
    </h4>


    <p>
        Your latest quiz performance
    </p>


</div>


<!-- IMPORTANT:
     This now goes to permanent database history.
-->

<a href="quiz-history.jsp">

    View All

    <i class="bi bi-arrow-right"></i>

</a>


</div>



<div class="table-responsive">


<table
    class="table result-table align-middle">


<thead>

<tr>

    <th>
        Quiz
    </th>


    <th>
        Date
    </th>


    <th>
        Questions
    </th>


    <th>
        Score
    </th>


    <th>
        Result
    </th>


    <th>
    </th>

</tr>

</thead>



<tbody>


<%
/*
 * ============================================================
 * LOAD RECENT RESULTS DIRECTLY FROM DATABASE
 * ============================================================
 */

boolean hasRecentResults = false;


try (
        Connection connection =
                DBConnection.getConnection()
) {

    String recentResultsSql =
            "SELECT " +
            "qa.id AS attempt_id, " +
            "qa.quiz_id, " +
            "q.title, " +
            "qa.score, " +
            "qa.total_questions, " +
            "qa.percentage, " +
            "qa.result_status, " +
            "qa.submitted_at " +
            "FROM quiz_attempts qa " +
            "INNER JOIN quizzes q " +
            "ON qa.quiz_id = q.id " +
            "WHERE qa.student_id = ? " +
            "ORDER BY qa.submitted_at DESC " +
            "LIMIT 5";


    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            recentResultsSql
                    )
    ) {

        statement.setInt(
                1,
                studentId
        );


        try (
                ResultSet resultSet =
                        statement.executeQuery()
        ) {


            while (resultSet.next()) {

                hasRecentResults = true;


                int attemptId =
                        resultSet.getInt(
                                "attempt_id"
                        );


                int resultQuizId =
                        resultSet.getInt(
                                "quiz_id"
                        );


                String resultTitle =
                        resultSet.getString(
                                "title"
                        );


                int resultScore =
                        resultSet.getInt(
                                "score"
                        );


                int resultTotal =
                        resultSet.getInt(
                                "total_questions"
                        );


                double resultPercentage =
                        resultSet.getDouble(
                                "percentage"
                        );


                String resultStatus =
                        resultSet.getString(
                                "result_status"
                        );


                java.sql.Timestamp submittedAt =
                        resultSet.getTimestamp(
                                "submitted_at"
                        );

%>


<tr>


<td>

    <strong>

        <%= resultTitle %>

    </strong>

</td>


<td>

    <%
    if (submittedAt != null) {
    %>

        <%= submittedAt.toString() %>

    <%
    } else {
    %>

        —

    <%
    }
    %>

</td>


<td>

    <%= resultTotal %>

</td>


<td>

    <strong>

        <%= resultScore %>
        /
        <%= resultTotal %>

    </strong>


    <small class="text-muted">

        (<%= Math.round(
                resultPercentage
        ) %>%)

    </small>

</td>


<td>


<%
if ("PASS".equalsIgnoreCase(resultStatus)) {
%>


    <span class="result-pass">

        Passed

    </span>


<%
} else {
%>


    <span class="result-warning">

        Needs Improvement

    </span>


<%
}
%>


</td>


<td>


<a
    href="quiz-result.jsp?quizId=<%= resultQuizId %>&attemptId=<%= attemptId %>"
    class="btn result-btn">

    View

</a>


</td>


</tr>


<%

            }

        }

    }


} catch (SQLException e) {

    e.printStackTrace();

%>


<tr>

<td
    colspan="6"
    class="text-center text-danger py-4">

    <i
        class="bi bi-exclamation-triangle me-2">
    </i>

    Unable to load recent quiz results.

</td>

</tr>


<%

}


/*
 * ============================================================
 * NO RESULTS
 * ============================================================
 */

if (!hasRecentResults) {

%>


<tr>

<td
    colspan="6"
    class="text-center py-5">


<i
    class="bi bi-clipboard-x"
    style="
        font-size: 2.5rem;
        color: #94a3b8;
    ">

</i>


<h6 class="mt-3">

    No Quiz Results Yet

</h6>


<p class="text-muted mb-0">

    Complete a quiz to see
    your results here.

</p>


</td>

</tr>


<%

}

%>


</tbody>

</table>


</div>


</div>



<!-- =====================================================
     FOOTER
====================================================== -->

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



<!-- =========================================================
     BOOTSTRAP JAVASCRIPT
========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>
