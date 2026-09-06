<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // =========================================================
    // ADMIN SESSION
    // =========================================================

    String firstName =
            (String) session.getAttribute("adminFirstName");

    String middleName =
            (String) session.getAttribute("adminMiddleName");

    String lastName =
            (String) session.getAttribute("adminLastName");

    String username =
            (String) session.getAttribute("adminUsername");

    String email =
            (String) session.getAttribute("adminEmail");

    if (firstName == null || firstName.trim().isEmpty()) {
        firstName = "Administrator";
    }

    if (lastName == null) {
        lastName = "";
    }

    if (username == null) {
        username = "admin";
    }

    String fullName = firstName + " " + lastName;

    // =========================================================
    // DATABASE STATISTICS
    // =========================================================

    int totalStudents = 0;
    int totalTeachers = 0;
    int totalQuizzes = 0;
    int publishedQuizzes = 0;

    try {
        Class.forName("org.postgresql.Driver");

        String url =
                "jdbc:postgresql://localhost:5432/online_quiz_db";

        String dbUser = "admin";
        String dbPassword = "admin";

        try (
            java.sql.Connection connection =
                    java.sql.DriverManager.getConnection(
                            url,
                            dbUser,
                            dbPassword
                    )
        ) {

            // Total students
            String studentSql =
                    "SELECT COUNT(*) FROM students";

            try (
                java.sql.PreparedStatement statement =
                        connection.prepareStatement(studentSql);
                java.sql.ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    totalStudents = resultSet.getInt(1);
                }
            }

            // Total teachers
            String teacherSql =
                    "SELECT COUNT(*) FROM teachers";

            try (
                java.sql.PreparedStatement statement =
                        connection.prepareStatement(teacherSql);
                java.sql.ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    totalTeachers = resultSet.getInt(1);
                }
            }

            // Total quizzes
            String quizSql =
                    "SELECT COUNT(*) FROM quizzes";

            try (
                java.sql.PreparedStatement statement =
                        connection.prepareStatement(quizSql);
                java.sql.ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    totalQuizzes = resultSet.getInt(1);
                }
            }

            // Published quizzes
            String publishedSql =
                    SELECT COUNT(*)
                    FROM quizzes
                    WHERE status = 'PUBLISHED';

            try (
                java.sql.PreparedStatement statement =
                        connection.prepareStatement(publishedSql);
                java.sql.ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    publishedQuizzes = resultSet.getInt(1);
                }
            }
        }

    } catch (Exception e) {
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

    <title>Admin Dashboard | UDOM Online Quiz System</title>

    <!-- Bootstrap 5.3.3 -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
            rel="stylesheet">

    <!-- Shared Dashboard CSS -->
    <link
            rel="stylesheet"
            href="<%= request.getContextPath() %>/css/dashboard.css">

</head>

<body>

<div class="dashboard-wrapper">

    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">

        <div class="sidebar-header">

            <div class="brand-logo">
                <span>UDOM</span>
            </div>

            <div class="brand-text">
                <h5>Online Quiz</h5>
                <small>Administration</small>
            </div>

        </div>


        <!-- Navigation -->

        <nav class="sidebar-nav">

            <a
                    href="dashboard.jsp"
                    class="nav-item active">

                <i class="bi bi-speedometer2"></i>

                <span>Dashboard</span>

            </a>


            <a
                    href="create-teacher.jsp"
                    class="nav-item">

                <i class="bi bi-person-plus"></i>

                <span>Create Teacher</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-people"></i>

                <span>Manage Teachers</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-mortarboard"></i>

                <span>Manage Students</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-journal-text"></i>

                <span>Manage Quizzes</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-bar-chart"></i>

                <span>Student Results</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-file-earmark-bar-graph"></i>

                <span>Reports</span>

            </a>


            <div class="sidebar-divider"></div>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-person-circle"></i>

                <span>My Profile</span>

            </a>


            <a
                    href="#"
                    class="nav-item">

                <i class="bi bi-gear"></i>

                <span>Settings</span>

            </a>

        </nav>


        <!-- Logout -->

        <div class="sidebar-footer">

            <a
                    href="<%= request.getContextPath() %>/logout"
                    class="nav-item logout-item">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </aside>


    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">


        <!-- =================================================
             TOP NAVBAR
             ================================================= -->

        <header class="top-navbar">

            <div>

                <h4 class="page-title">
                    Administration Dashboard
                </h4>

                <p class="page-subtitle">
                    Manage the UDOM Online Quiz System
                </p>

            </div>


            <div class="profile-section">

                <div class="profile-info">

                    <strong>
                        <%= fullName %>
                    </strong>

                    <small>
                        System Administrator
                    </small>

                </div>


                <div class="profile-avatar">

                    <%= firstName.substring(0, 1).toUpperCase() %>

                </div>

            </div>

        </header>


        <!-- =================================================
             CONTENT
             ================================================= -->

        <div class="content-container">


            <!-- Welcome -->

            <div class="welcome-card">

                <div>

                    <h3>
                        Welcome, <%= firstName %>!
                    </h3>

                    <p>
                        Monitor and manage the UDOM Online Quiz
                        System from your administration panel.
                    </p>

                </div>

                <div class="welcome-icon">

                    <i class="bi bi-shield-check"></i>

                </div>

            </div>


            <!-- =================================================
                 STATISTICS
                 ================================================= -->

            <div class="row g-4 mt-1">


                <!-- Students -->

                <div class="col-md-6 col-xl-3">

                    <div class="stat-card">

                        <div class="stat-icon">

                            <i class="bi bi-mortarboard-fill"></i>

                        </div>

                        <div>

                            <h6>Total Students</h6>

                            <h3>
                                <%= totalStudents %>
                            </h3>

                            <small>
                                Registered students
                            </small>

                        </div>

                    </div>

                </div>


                <!-- Teachers -->

                <div class="col-md-6 col-xl-3">

                    <div class="stat-card">

                        <div class="stat-icon">

                            <i class="bi bi-person-workspace"></i>

                        </div>

                        <div>

                            <h6>Total Teachers</h6>

                            <h3>
                                <%= totalTeachers %>
                            </h3>

                            <small>
                                Teaching staff
                            </small>

                        </div>

                    </div>

                </div>


                <!-- Quizzes -->

                <div class="col-md-6 col-xl-3">

                    <div class="stat-card">

                        <div class="stat-icon">

                            <i class="bi bi-journal-check"></i>

                        </div>

                        <div>

                            <h6>Total Quizzes</h6>

                            <h3>
                                <%= totalQuizzes %>
                            </h3>

                            <small>
                                Created quizzes
                            </small>

                        </div>

                    </div>

                </div>


                <!-- Published -->

                <div class="col-md-6 col-xl-3">

                    <div class="stat-card">

                        <div class="stat-icon">

                            <i class="bi bi-check-circle-fill"></i>

                        </div>

                        <div>

                            <h6>Published Quizzes</h6>

                            <h3>
                                <%= publishedQuizzes %>
                            </h3>

                            <small>
                                Available to students
                            </small>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 ADMIN QUICK ACTIONS
                 ================================================= -->

            <div class="row g-4 mt-2">


                <div class="col-lg-8">

                    <div class="dashboard-card">

                        <div class="card-header">

                            <div>

                                <h5>
                                    Administration
                                </h5>

                                <p>
                                    Common administrative actions
                                </p>

                            </div>

                        </div>


                        <div class="row g-3 mt-1">


                            <!-- Create Teacher -->

                            <div class="col-md-6">

                                <a
                                        href="create-teacher.jsp"
                                        class="quick-action">

                                    <div class="quick-action-icon">

                                        <i class="bi bi-person-plus-fill"></i>

                                    </div>

                                    <div>

                                        <h6>
                                            Create Teacher
                                        </h6>

                                        <p>
                                            Create a teacher account
                                        </p>

                                    </div>

                                    <i class="bi bi-arrow-right"></i>

                                </a>

                            </div>


                            <!-- Manage Teachers -->

                            <div class="col-md-6">

                                <a
                                        href="#"
                                        class="quick-action">

                                    <div class="quick-action-icon">

                                        <i class="bi bi-people-fill"></i>

                                    </div>

                                    <div>

                                        <h6>
                                            Manage Teachers
                                        </h6>

                                        <p>
                                            View and manage teachers
                                        </p>

                                    </div>

                                    <i class="bi bi-arrow-right"></i>

                                </a>

                            </div>


                            <!-- Manage Students -->

                            <div class="col-md-6">

                                <a
                                        href="#"
                                        class="quick-action">

                                    <div class="quick-action-icon">

                                        <i class="bi bi-mortarboard-fill"></i>

                                    </div>

                                    <div>

                                        <h6>
                                            Manage Students
                                        </h6>

                                        <p>
                                            View registered students
                                        </p>

                                    </div>

                                    <i class="bi bi-arrow-right"></i>

                                </a>

                            </div>


                            <!-- Reports -->

                            <div class="col-md-6">

                                <a
                                        href="#"
                                        class="quick-action">

                                    <div class="quick-action-icon">

                                        <i class="bi bi-file-earmark-bar-graph-fill"></i>

                                    </div>

                                    <div>

                                        <h6>
                                            System Reports
                                        </h6>

                                        <p>
                                            View system reports
                                        </p>

                                    </div>

                                    <i class="bi bi-arrow-right"></i>

                                </a>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     SYSTEM OVERVIEW
                     ================================================= -->

                <div class="col-lg-4">

                    <div class="dashboard-card">

                        <div class="card-header">

                            <div>

                                <h5>
                                    System Overview
                                </h5>

                                <p>
                                    Current platform status
                                </p>

                            </div>

                        </div>


                        <div class="overview-list">

                            <div class="overview-item">

                                <span>
                                    <i class="bi bi-circle-fill text-success"></i>
                                    System Status
                                </span>

                                <strong>
                                    Active
                                </strong>

                            </div>


                            <div class="overview-item">

                                <span>
                                    <i class="bi bi-database-check"></i>
                                    Database
                                </span>

                                <strong>
                                    Connected
                                </strong>

                            </div>


                            <div class="overview-item">

                                <span>
                                    <i class="bi bi-person-workspace"></i>
                                    Teachers
                                </span>

                                <strong>
                                    <%= totalTeachers %>
                                </strong>

                            </div>


                            <div class="overview-item">

                                <span>
                                    <i class="bi bi-mortarboard"></i>
                                    Students
                                </span>

                                <strong>
                                    <%= totalStudents %>
                                </strong>

                            </div>


                            <div class="overview-item">

                                <span>
                                    <i class="bi bi-journal-check"></i>
                                    Published
                                </span>

                                <strong>
                                    <%= publishedQuizzes %>
                                </strong>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 ADMIN ACCOUNT INFORMATION
                 ================================================= -->

            <div class="dashboard-card mt-4">

                <div class="card-header">

                    <div>

                        <h5>
                            Administrator Account
                        </h5>

                        <p>
                            Currently signed-in administrator
                        </p>

                    </div>

                    <i class="bi bi-shield-lock-fill fs-4"></i>

                </div>


                <div class="row mt-2">

                    <div class="col-md-4">

                        <small class="text-muted">
                            Name
                        </small>

                        <p class="fw-semibold mb-3">
                            <%= fullName %>
                        </p>

                    </div>


                    <div class="col-md-4">

                        <small class="text-muted">
                            Username
                        </small>

                        <p class="fw-semibold mb-3">
                            <%= username %>
                        </p>

                    </div>


                    <div class="col-md-4">

                        <small class="text-muted">
                            Email
                        </small>

                        <p class="fw-semibold mb-3">
                            <%= email != null ? email : "—" %>
                        </p>

                    </div>

                </div>

            </div>

        </div>


        <!-- =================================================
             FOOTER
             ================================================= -->

        <footer class="dashboard-footer">

            <p>
                © <%= java.time.Year.now() %>
                University of Dodoma —
                Online Quiz System
            </p>

            <span>
                Administration Portal
            </span>

        </footer>

    </main>

</div>


<!-- Bootstrap JS -->

<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>