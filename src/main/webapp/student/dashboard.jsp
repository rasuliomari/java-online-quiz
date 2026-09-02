<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
int availableQuizzes = 0;

try (Connection connection = DBConnection.getConnection()) {

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

} catch (SQLException e) {
    e.printStackTrace();
}

%>


<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard | UDOM Online Quiz System</title>

<!-- Bootstrap 5.3.3 -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- Bootstrap Icons -->
<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Dashboard CSS -->
<link rel="stylesheet" href="../css/dashboard.css">
</head>
<body>

<!-- ================= TOP NAVBAR ================= -->
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

    <a class="navbar-brand d-flex align-items-center" href="#">

        <div class="brand-icon">
            <i class="bi bi-mortarboard-fill"></i>
        </div>

        <div class="brand-text">
            <span>UDOM</span>
            <small>Online Quiz System</small>
        </div>

    </a>


    <!-- Right navigation -->

    <div class="d-flex align-items-center ms-auto">

        <!-- Notification -->

        <button class="notification-btn me-3">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">3</span>

        </button>


        <!-- Student profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                data-bs-toggle="dropdown">

                <div class="student-avatar">
                    RO
                </div>

                <div class="student-name d-none d-md-block">

                    <strong>Student</strong>

                    <small>Student Account</small>

                </div>

            </button>

            <ul class="dropdown-menu dropdown-menu-end shadow">

                <li>
                    <a class="dropdown-item" href="#">
                        <i class="bi bi-person me-2"></i>
                        My Profile
                    </a>
                </li>

                <li>
                    <a class="dropdown-item" href="#">
                        <i class="bi bi-gear me-2"></i>
                        Settings
                    </a>
                </li>

                <li>
                    <hr class="dropdown-divider">
                </li>

                <li>
                    <a class="dropdown-item text-danger" href="../login.jsp">
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

    <!-- Student information -->

    <div class="sidebar-profile">

        <div class="sidebar-avatar">
            RO
        </div>

        <div>

            <h6>Student</h6>

            <span>Student Account</span>

        </div>

    </div>


    <!-- Menu -->

    <div class="sidebar-menu">

        <p class="menu-title">
            MAIN MENU
        </p>

        <a href="#" class="sidebar-link active">

            <i class="bi bi-grid-1x2-fill"></i>

            <span>Dashboard</span>

        </a>


        <a href="#" class="sidebar-link">

            <i class="bi bi-journal-check"></i>

            <span>Available Quizzes</span>

            <span class="menu-badge"><%= availableQuizzes %></span>

        </a>


        <a href="#" class="sidebar-link">

            <i class="bi bi-clock-history"></i>

            <span>Quiz History</span>

        </a>


        <a href="#" class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>My Results</span>

        </a>


        <p class="menu-title mt-4">
            ACCOUNT
        </p>


        <a href="#" class="sidebar-link">

            <i class="bi bi-person-fill"></i>

            <span>My Profile</span>

        </a>


        <a href="#" class="sidebar-link">

            <i class="bi bi-gear-fill"></i>

            <span>Settings</span>

        </a>

    </div>


    <!-- Logout -->

    <div class="sidebar-bottom">

        <a href="../login.jsp" class="logout-link">

            <i class="bi bi-box-arrow-left"></i>

            <span>Logout</span>

        </a>

    </div>

</div>

</div>

<!-- ================= MAIN CONTENT ================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


    <!-- Welcome section -->

    <div class="welcome-section">

        <div>

            <span class="welcome-label">
                STUDENT DASHBOARD
            </span>

            <h1>
                Welcome back, Student! 👋
            </h1>

            <p>
                Ready to test your knowledge? Explore available quizzes
                and keep improving your academic performance.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-mortarboard-fill"></i>

        </div>

    </div>


    <!-- ================= STATISTICS ================= -->

    <div class="row g-4 mb-4">

        <!-- Available quizzes -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon icon-blue">

                    <i class="bi bi-journal-check"></i>

                </div>

                <div>

                    <span>Available Quizzes</span>

                    <h2><%= availableQuizzes %></h2>

                    <small>
                        <i class="bi bi-arrow-up"></i>
                        3 new this week
                    </small>

                </div>

            </div>

        </div>


        <!-- Completed -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon icon-green">

                    <i class="bi bi-check-circle-fill"></i>

                </div>

                <div>

                    <span>Completed Quizzes</span>

                    <h2>8</h2>

                    <small>
                        <i class="bi bi-check2"></i>
                        Good progress
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

                    <span>Average Score</span>

                    <h2>78%</h2>

                    <small>
                        <i class="bi bi-arrow-up"></i>
                        5% improvement
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

                    <span>Class Ranking</span>

                    <h2>#14</h2>

                    <small>
                        <i class="bi bi-arrow-up"></i>
                        Improved by 4
                    </small>

                </div>

            </div>

        </div>

    </div>


    <!-- ================= MAIN ROW ================= -->

    <div class="row g-4">


        <!-- Available quizzes -->

        <div class="col-xl-8">

            <div class="content-card">

                <div class="card-header-custom">

                    <div>

                        <h4>Available Quizzes</h4>

                        <p>
                            Quizzes available for you to attempt
                        </p>

                    </div>

                    <a href="#">
                        View All
                        <i class="bi bi-arrow-right"></i>
                    </a>

                </div>


               <%
                String quizSql =
                "SELECT id, title, course, question_count, " +
                "duration_minutes, pass_mark " +
                "FROM quizzes " +
                "WHERE status = 'PUBLISHED' " +
                "ORDER BY created_at DESC " +
                "LIMIT 5";

                try (Connection connection = DBConnection.getConnection();
                    PreparedStatement statement =
                            connection.prepareStatement(quizSql);
                    ResultSet resultSet =
                            statement.executeQuery()) {

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
                                resultSet.getInt("question_count");

                        int duration =
                                resultSet.getInt("duration_minutes");

                        int passMark =
                                resultSet.getInt("pass_mark");

                        String icon = "bi-journal-check";

                        if (course != null) {
                            String courseLower =
                                    course.toLowerCase();

                            if (courseLower.contains("security")) {
                                icon = "bi-shield-lock-fill";
                            } else if (courseLower.contains("network")) {
                                icon = "bi-diagram-3-fill";
                            } else if (courseLower.contains("software")) {
                                icon = "bi-code-slash";
                            } else if (courseLower.contains("database")) {
                                icon = "bi-database-fill";
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
                            <%= questionCount %> Questions
                        </span>

                        <span>
                            <i class="bi bi-clock"></i>
                            <%= duration %> Minutes
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
                    There are currently no published quizzes available.
                </p>

                </div>

                <%
                }

                } catch (SQLException e) {

                %>

                <div class="alert alert-danger">

                <i class="bi bi-exclamation-triangle me-2"></i>

                Unable to load available quizzes.

                </div>

                <%
                e.printStackTrace();
                }
                %>


            </div>

        </div>


        <!-- Performance -->

        <div class="col-xl-4">

            <div class="content-card performance-card">

                <div class="card-header-custom">

                    <div>

                        <h4>My Performance</h4>

                        <p>
                            Your quiz performance
                        </p>

                    </div>

                </div>


                <div class="performance-circle">

                    <div class="circle-inner">

                        <strong>78%</strong>

                        <span>Average</span>

                    </div>

                </div>


                <div class="performance-info">

                    <div>

                        <span>Highest Score</span>

                        <strong>95%</strong>

                    </div>

                    <div>

                        <span>Lowest Score</span>

                        <strong>62%</strong>

                    </div>

                </div>


                <div class="progress-section">

                    <div class="d-flex justify-content-between">

                        <span>Overall Progress</span>

                        <strong>78%</strong>

                    </div>

                    <div class="progress">

                        <div
                            class="progress-bar"
                            style="width: 78%">
                        </div>

                    </div>

                </div>

            </div>


            <!-- Upcoming -->

            <div class="content-card upcoming-card mt-4">

                <div class="card-header-custom">

                    <div>

                        <h4>Upcoming</h4>

                        <p>
                            Important quiz deadlines
                        </p>

                    </div>

                </div>


                <div class="upcoming-item">

                    <div class="calendar-icon">

                        <strong>05</strong>

                        <span>SEP</span>

                    </div>

                    <div>

                        <h6>Computer Security</h6>

                        <small>
                            Deadline: 11:59 PM
                        </small>

                    </div>

                </div>


                <div class="upcoming-item">

                    <div class="calendar-icon">

                        <strong>08</strong>

                        <span>SEP</span>

                    </div>

                    <div>

                        <h6>Database Systems</h6>

                        <small>
                            Deadline: 11:59 PM
                        </small>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <!-- ================= RECENT RESULTS ================= -->

    <div class="content-card mt-4">

        <div class="card-header-custom">

            <div>

                <h4>Recent Results</h4>

                <p>
                    Your latest quiz performance
                </p>

            </div>

            <a href="#">
                View All
                <i class="bi bi-arrow-right"></i>
            </a>

        </div>


        <div class="table-responsive">

            <table class="table result-table align-middle">

                <thead>

                    <tr>

                        <th>Quiz</th>

                        <th>Date</th>

                        <th>Questions</th>

                        <th>Score</th>

                        <th>Result</th>

                        <th></th>

                    </tr>

                </thead>

                <tbody>

                    <tr>

                        <td>
                            <strong>
                                Database Management Systems
                            </strong>
                        </td>

                        <td>
                            30 Aug 2026
                        </td>

                        <td>
                            20
                        </td>

                        <td>
                            <strong>18 / 20</strong>
                        </td>

                        <td>
                            <span class="result-pass">
                                Passed
                            </span>
                        </td>

                        <td>
                            <button class="btn result-btn">
                                View
                            </button>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            <strong>
                                Software Engineering
                            </strong>
                        </td>

                        <td>
                            27 Aug 2026
                        </td>

                        <td>
                            30
                        </td>

                        <td>
                            <strong>24 / 30</strong>
                        </td>

                        <td>
                            <span class="result-pass">
                                Passed
                            </span>
                        </td>

                        <td>
                            <button class="btn result-btn">
                                View
                            </button>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            <strong>
                                Computer Networks
                            </strong>
                        </td>

                        <td>
                            24 Aug 2026
                        </td>

                        <td>
                            20
                        </td>

                        <td>
                            <strong>12 / 20</strong>
                        </td>

                        <td>
                            <span class="result-warning">
                                Needs Improvement
                            </span>
                        </td>

                        <td>
                            <button class="btn result-btn">
                                View
                            </button>
                        </td>

                    </tr>

                </tbody>

            </table>

        </div>

    </div>


    <!-- Footer -->

    <footer class="dashboard-footer">

        <p>
            © 2026 UDOM Online Quiz System.
            University of Dodoma.
        </p>

        <div>

            <a href="#">Help</a>

            <a href="#">Privacy</a>

            <a href="#">Support</a>

        </div>

    </footer>

</div>

</main>

<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
