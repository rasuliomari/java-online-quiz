
<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ==============================
    // ADMIN AUTHENTICATION
    // ==============================

    if (session.getAttribute("adminLoggedIn") == null ||
        !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String adminFirstName =
        (String) session.getAttribute("adminFirstName");

    if (adminFirstName == null || adminFirstName.trim().isEmpty()) {
        adminFirstName = "Administrator";
    }

    // ==============================
    // REPORT VARIABLES
    // ==============================

    int totalStudents = 0;
    int totalTeachers = 0;
    int totalQuizzes = 0;
    int totalAttempts = 0;

    int passedAttempts = 0;
    int failedAttempts = 0;

    double averageScore = 0.0;
    double passRate = 0.0;

    int publishedQuizzes = 0;
    int draftQuizzes = 0;

    // ==============================
    // DATABASE CONNECTION
    // ==============================

    try (Connection conn = DBConnection.getConnection()) {

        // ------------------------------
        // TOTAL STUDENTS
        // ------------------------------

        String sqlStudents =
            "SELECT COUNT(*) FROM students";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlStudents);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalStudents = rs.getInt(1);
            }
        }

        // ------------------------------
        // TOTAL TEACHERS
        // ------------------------------

        String sqlTeachers =
            "SELECT COUNT(*) FROM teachers";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlTeachers);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalTeachers = rs.getInt(1);
            }
        }

        // ------------------------------
        // TOTAL QUIZZES
        // ------------------------------

        String sqlQuizzes =
            "SELECT COUNT(*) FROM quizzes";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlQuizzes);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalQuizzes = rs.getInt(1);
            }
        }

        // ------------------------------
        // PUBLISHED QUIZZES
        // ------------------------------

        String sqlPublished =
            "SELECT COUNT(*) FROM quizzes " +
            "WHERE status = 'PUBLISHED'";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlPublished);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                publishedQuizzes = rs.getInt(1);
            }
        }

        // ------------------------------
        // DRAFT QUIZZES
        // ------------------------------

        String sqlDraft =
            "SELECT COUNT(*) FROM quizzes " +
            "WHERE status = 'DRAFT'";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlDraft);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                draftQuizzes = rs.getInt(1);
            }
        }

        // ------------------------------
        // TOTAL ATTEMPTS
        // ------------------------------

        String sqlAttempts =
            "SELECT COUNT(*) FROM quiz_attempts";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlAttempts);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalAttempts = rs.getInt(1);
            }
        }

        // ------------------------------
        // PASSED ATTEMPTS
        // ------------------------------

        String sqlPassed =
            "SELECT COUNT(*) FROM quiz_attempts " +
            "WHERE result_status = 'PASS'";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlPassed);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                passedAttempts = rs.getInt(1);
            }
        }

        // ------------------------------
        // FAILED ATTEMPTS
        // ------------------------------

        String sqlFailed =
            "SELECT COUNT(*) FROM quiz_attempts " +
            "WHERE result_status = 'FAIL'";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlFailed);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                failedAttempts = rs.getInt(1);
            }
        }

        // ------------------------------
        // AVERAGE SCORE
        // ------------------------------

        String sqlAverage =
            "SELECT COALESCE(AVG(percentage), 0) " +
            "FROM quiz_attempts";

        try (PreparedStatement ps =
                conn.prepareStatement(sqlAverage);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                averageScore = rs.getDouble(1);
            }
        }

        // ------------------------------
        // PASS RATE
        // ------------------------------

        if (totalAttempts > 0) {
            passRate =
                ((double) passedAttempts / totalAttempts) * 100;
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Reports - UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

    <!-- Dashboard CSS -->
    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>

<body>

<!-- ================================================= -->
<!-- NAVBAR -->
<!-- ================================================= -->

<nav class="navbar dashboard-navbar">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>

        <a
            href="dashboard.jsp"
            class="navbar-brand d-flex align-items-center">

            <span class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </span>

            <span class="brand-text">
                UDOM / Online Quiz System
            </span>

        </a>

        <div class="d-flex align-items-center ms-auto">

            <!-- Notification -->

            <button
                class="btn notification-btn me-3"
                type="button">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    0
                </span>

            </button>

            <!-- Profile -->

            <div class="dropdown">

                <button
                    class="btn profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">

                    <span class="student-avatar">
                        <%= adminFirstName.substring(0, 1).toUpperCase() %>
                    </span>

                    <span class="student-name d-none d-md-inline">
                        <%= adminFirstName %>
                    </span>

                </button>

                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a
                            class="dropdown-item"
                            href="#">

                            <i class="bi bi-person me-2"></i>
                            Profile

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


<!-- ================================================= -->
<!-- SIDEBAR -->
<!-- ================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM Online Quiz

        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas"
            data-bs-target="#adminSidebar">

        </button>

    </div>

    <div class="sidebar-content">

        <!-- Sidebar Profile -->

        <div class="sidebar-profile">

            <div class="student-avatar">

                <%= adminFirstName.substring(0, 1).toUpperCase() %>

            </div>

            <div>

                <h6>
                    <%= adminFirstName %>
                </h6>

                <small>
                    System Administrator
                </small>

            </div>

        </div>


        <!-- Menu -->

        <div class="sidebar-menu">

            <div class="menu-title">
                MAIN MENU
            </div>

            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <div class="menu-title mt-3">
                MANAGEMENT
            </div>

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

                <i class="bi bi-people"></i>

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

                <i class="bi bi-mortarboard"></i>

                <span>
                    Manage Students
                </span>

            </a>

            <a
                href="manage-quizzes.jsp"
                class="sidebar-link">

                <i class="bi bi-ui-checks"></i>

                <span>
                    Manage Quizzes
                </span>

            </a>

            <a
                href="results.jsp"
                class="sidebar-link">

                <i class="bi bi-bar-chart"></i>

                <span>
                    Results
                </span>

            </a>

            <a
                href="reports.jsp"
                class="sidebar-link active">

                <i class="bi bi-file-earmark-bar-graph"></i>

                <span>
                    Reports
                </span>

            </a>

        </div>


        <!-- Bottom -->

        <div class="sidebar-bottom">

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear"></i>

                <span>
                    Settings
                </span>

            </a>

            <a
                href="../logout"
                class="sidebar-link logout-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>


<!-- ================================================= -->
<!-- MAIN CONTENT -->
<!-- ================================================= -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <!-- Header -->

        <div class="welcome-section">

            <div>

                <div class="welcome-label">
                    ADMINISTRATION
                </div>

                <h1>
                    Reports & Analytics
                </h1>

                <p>
                    Monitor the overall performance of the
                    UDOM Online Quiz System.
                </p>

            </div>

        </div>


        <!-- ================================================= -->
        <!-- SYSTEM STATISTICS -->
        <!-- ================================================= -->

        <div class="row g-4 mb-4">

            <!-- Students -->

            <div class="col-xl-3 col-md-6">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-mortarboard-fill"></i>

                    </div>

                    <div>

                        <span class="stat-label">
                            Total Students
                        </span>

                        <h3>
                            <%= totalStudents %>
                        </h3>

                    </div>

                </div>

            </div>


            <!-- Teachers -->

            <div class="col-xl-3 col-md-6">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-people-fill"></i>

                    </div>

                    <div>

                        <span class="stat-label">
                            Total Teachers
                        </span>

                        <h3>
                            <%= totalTeachers %>
                        </h3>

                    </div>

                </div>

            </div>


            <!-- Quizzes -->

            <div class="col-xl-3 col-md-6">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-ui-checks-grid"></i>

                    </div>

                    <div>

                        <span class="stat-label">
                            Total Quizzes
                        </span>

                        <h3>
                            <%= totalQuizzes %>
                        </h3>

                    </div>

                </div>

            </div>


            <!-- Attempts -->

            <div class="col-xl-3 col-md-6">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-pencil-square"></i>

                    </div>

                    <div>

                        <span class="stat-label">
                            Quiz Attempts
                        </span>

                        <h3>
                            <%= totalAttempts %>
                        </h3>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================================================= -->
        <!-- PERFORMANCE -->
        <!-- ================================================= -->

        <div class="row g-4 mb-4">


            <!-- Pass / Fail -->

            <div class="col-lg-6">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h5>
                                Quiz Performance
                            </h5>

                            <p>
                                Overall student performance
                            </p>

                        </div>

                        <i class="bi bi-bar-chart-line"></i>

                    </div>


                    <div class="row g-3">


                        <div class="col-md-6">

                            <div class="quiz-item">

                                <div class="quiz-icon">

                                    <i class="bi bi-check-circle"></i>

                                </div>

                                <div class="quiz-information">

                                    <h6>
                                        Passed Attempts
                                    </h6>

                                    <div class="quiz-meta">

                                        <strong>
                                            <%= passedAttempts %>
                                        </strong>

                                        attempts

                                    </div>

                                </div>

                            </div>

                        </div>


                        <div class="col-md-6">

                            <div class="quiz-item">

                                <div class="quiz-icon">

                                    <i class="bi bi-x-circle"></i>

                                </div>

                                <div class="quiz-information">

                                    <h6>
                                        Failed Attempts
                                    </h6>

                                    <div class="quiz-meta">

                                        <strong>
                                            <%= failedAttempts %>
                                        </strong>

                                        attempts

                                    </div>

                                </div>

                            </div>

                        </div>


                    </div>


                    <hr>


                    <div class="d-flex justify-content-between mb-2">

                        <span>
                            Pass Rate
                        </span>

                        <strong>
                            <%= String.format("%.2f", passRate) %>%
                        </strong>

                    </div>

                    <div class="progress">

                        <div
                            class="progress-bar"
                            role="progressbar"
                            style="width: <%= passRate %>%">

                        </div>

                    </div>

                </div>

            </div>


            <!-- Average Score -->

            <div class="col-lg-6">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h5>
                                Average Performance
                            </h5>

                            <p>
                                Overall quiz score
                            </p>

                        </div>

                        <i class="bi bi-speedometer2"></i>

                    </div>


                    <div class="text-center py-4">

                        <div
                            style="font-size: 3rem;
                                   font-weight: 700;">

                            <%= String.format("%.2f", averageScore) %>%

                        </div>

                        <p class="text-muted mb-0">

                            Average score across
                            all quiz attempts

                        </p>

                    </div>


                    <div class="row text-center">

                        <div class="col-6">

                            <h5>
                                <%= publishedQuizzes %>
                            </h5>

                            <small class="text-muted">
                                Published Quizzes
                            </small>

                        </div>

                        <div class="col-6">

                            <h5>
                                <%= draftQuizzes %>
                            </h5>

                            <small class="text-muted">
                                Draft Quizzes
                            </small>

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================================================= -->
        <!-- REPORT SUMMARY -->
        <!-- ================================================= -->

        <div class="content-card mb-4">

            <div class="card-header-custom">

                <div>

                    <h5>
                        System Summary
                    </h5>

                    <p>
                        Current state of the online quiz system
                    </p>

                </div>

                <i class="bi bi-clipboard-data"></i>

            </div>


            <div class="table-responsive">

                <table class="table align-middle">

                    <thead>

                        <tr>

                            <th>
                                Category
                            </th>

                            <th>
                                Total
                            </th>

                            <th>
                                Description
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <tr>

                            <td>

                                <i class="bi bi-mortarboard me-2"></i>

                                Students

                            </td>

                            <td>
                                <strong>
                                    <%= totalStudents %>
                                </strong>
                            </td>

                            <td>
                                Registered students
                            </td>

                        </tr>


                        <tr>

                            <td>

                                <i class="bi bi-person-badge me-2"></i>

                                Teachers

                            </td>

                            <td>
                                <strong>
                                    <%= totalTeachers %>
                                </strong>
                            </td>

                            <td>
                                Registered teaching staff
                            </td>

                        </tr>


                        <tr>

                            <td>

                                <i class="bi bi-ui-checks me-2"></i>

                                Quizzes

                            </td>

                            <td>
                                <strong>
                                    <%= totalQuizzes %>
                                </strong>
                            </td>

                            <td>
                                Total quizzes created
                            </td>

                        </tr>


                        <tr>

                            <td>

                                <i class="bi bi-check2-square me-2"></i>

                                Attempts

                            </td>

                            <td>
                                <strong>
                                    <%= totalAttempts %>
                                </strong>
                            </td>

                            <td>
                                Total quiz attempts submitted
                            </td>

                        </tr>


                        <tr>

                            <td>

                                <i class="bi bi-check-circle me-2"></i>

                                Passed

                            </td>

                            <td>
                                <strong>
                                    <%= passedAttempts %>
                                </strong>
                            </td>

                            <td>
                                Attempts that met the pass mark
                            </td>

                        </tr>


                        <tr>

                            <td>

                                <i class="bi bi-x-circle me-2"></i>

                                Failed

                            </td>

                            <td>
                                <strong>
                                    <%= failedAttempts %>
                                </strong>
                            </td>

                            <td>
                                Attempts below the pass mark
                            </td>

                        </tr>

                    </tbody>

                </table>

            </div>

        </div>


        <!-- ================================================= -->
        <!-- FOOTER -->
        <!-- ================================================= -->

        <footer class="dashboard-footer">

            <div>

                © 2026 UDOM Online Quiz System

            </div>

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
