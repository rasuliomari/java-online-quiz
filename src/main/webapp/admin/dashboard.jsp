<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /*
     * =========================================================
     * ADMIN SESSION
     * =========================================================
     */

    String adminFirstName =
            (String) session.getAttribute("adminFirstName");

    String adminLastName =
            (String) session.getAttribute("adminLastName");

    String adminUsername =
            (String) session.getAttribute("adminUsername");

    if (adminFirstName == null) {
        adminFirstName = "Administrator";
    }

    if (adminLastName == null) {
        adminLastName = "";
    }

    if (adminUsername == null) {
        adminUsername = "Administrator";
    }

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();

    /*
     * =========================================================
     * INITIAL STATISTICS
     * =========================================================
     */

    int totalStudents = 0;
    int totalTeachers = 0;
    int totalQuizzes = 0;
    int publishedQuizzes = 0;

    /*
     * =========================================================
     * DATABASE STATISTICS
     * =========================================================
     */

    try (Connection connection = DBConnection.getConnection()) {

        String studentSql =
                "SELECT COUNT(*) FROM students";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(studentSql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            if (resultSet.next()) {
                totalStudents = resultSet.getInt(1);
            }
        }


        String teacherSql =
                "SELECT COUNT(*) FROM teachers";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(teacherSql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            if (resultSet.next()) {
                totalTeachers = resultSet.getInt(1);
            }
        }


        String quizSql =
                "SELECT COUNT(*) FROM quizzes";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(quizSql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            if (resultSet.next()) {
                totalQuizzes = resultSet.getInt(1);
            }
        }


        String publishedSql =
                "SELECT COUNT(*) " +
                "FROM quizzes " +
                "WHERE status = 'PUBLISHED'";

        try (
            PreparedStatement statement =
                    connection.prepareStatement(publishedSql);
            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            if (resultSet.next()) {
                publishedQuizzes = resultSet.getInt(1);
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

<title>
    Admin Dashboard | UDOM Online Quiz System
</title>


<!-- Bootstrap 5.3.3 -->

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


<!-- =========================================================
     TOP NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile Menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#adminSidebar">

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


    <!-- Right Side -->

    <div class="d-flex align-items-center ms-auto">


        <!-- Notification -->

        <button
            class="notification-btn me-3"
            type="button">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                4
            </span>

        </button>


        <!-- Admin Profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                type="button"
                data-bs-toggle="dropdown">


                <div class="student-avatar">

                    <%= adminFirstName.substring(0, 1).toUpperCase() %>

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
    id="adminSidebar">


    <!-- Mobile Header -->

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            Administrator Menu
        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>



    <div class="sidebar-content">


        <!-- Administrator Information -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">

                <%= adminFirstName.substring(0, 1).toUpperCase() %>

            </div>


            <div>

                <h6>
                    <%= adminFullName %>
                </h6>

                <span>
                    System Administrator
                </span>

            </div>

        </div>



        <!-- Navigation -->

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


            <!-- Create Teacher -->

            <a
                href="create-teacher.jsp"
                class="sidebar-link">

                <i class="bi bi-person-plus-fill"></i>

                <span>
                    Create Teacher
                </span>

            </a>


            <!-- Manage Teachers -->

            <a
                href="manage-teachers.jsp"
                class="sidebar-link">

                <i class="bi bi-people-fill"></i>

                <span>
                    Manage Teachers
                </span>

            </a>


            <!-- Manage Students -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-mortarboard-fill"></i>

                <span>
                    Manage Students
                </span>

            </a>


            <!-- Manage Quizzes -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-journal-text"></i>

                <span>
                    Manage Quizzes
                </span>

            </a>


            <!-- Student Results -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    Student Results
                </span>

            </a>


            <!-- Reports -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph-fill"></i>

                <span>
                    Reports
                </span>

            </a>



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



        <!-- Logout -->

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
         PAGE HEADER
    ====================================================== -->

    <div class="welcome-section">


        <div>

            <span class="welcome-label">
                ADMINISTRATION
            </span>


            <h1>
                Welcome, <%= adminFirstName %>
            </h1>


            <p>
                Manage the UDOM Online Quiz System from your
                administrator dashboard.
            </p>

        </div>


        <div>

            <a
                href="create-teacher.jsp"
                class="btn btn-primary">

                <i class="bi bi-person-plus-fill me-2"></i>

                Create Teacher

            </a>

        </div>


    </div>



    <!-- =====================================================
         STATISTICS
    ====================================================== -->

    <div class="row g-4 mb-4">


        <!-- Students -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-mortarboard-fill"></i>

                </div>


                <div>

                    <p>
                        Total Students
                    </p>

                    <h3>
                        <%= totalStudents %>
                    </h3>

                    <span>
                        Registered students
                    </span>

                </div>

            </div>

        </div>



        <!-- Teachers -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-person-workspace"></i>

                </div>


                <div>

                    <p>
                        Total Teachers
                    </p>

                    <h3>
                        <%= totalTeachers %>
                    </h3>

                    <span>
                        Academic staff
                    </span>

                </div>

            </div>

        </div>



        <!-- Quizzes -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-journal-text"></i>

                </div>


                <div>

                    <p>
                        Total Quizzes
                    </p>

                    <h3>
                        <%= totalQuizzes %>
                    </h3>

                    <span>
                        Created quizzes
                    </span>

                </div>

            </div>

        </div>



        <!-- Published -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-check-circle-fill"></i>

                </div>


                <div>

                    <p>
                        Published Quizzes
                    </p>

                    <h3>
                        <%= publishedQuizzes %>
                    </h3>

                    <span>
                        Available to students
                    </span>

                </div>

            </div>

        </div>


    </div>



    <!-- =====================================================
         ADMINISTRATION CONTENT
    ====================================================== -->

    <div class="row g-4">


        <!-- Quick Actions -->

        <div class="col-xl-8">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Administration
                        </h4>

                        <p>
                            Manage users and quiz activities
                        </p>

                    </div>

                </div>



                <div class="row g-4">


                    <!-- Create Teacher -->

                    <div class="col-md-6">

                        <a
                            href="create-teacher.jsp"
                            class="text-decoration-none">

                            <div class="quiz-item">


                                <div class="quiz-icon">

                                    <i class="bi bi-person-plus-fill"></i>

                                </div>


                                <div class="quiz-information">

                                    <h5>
                                        Create Teacher
                                    </h5>

                                    <div class="quiz-meta">

                                        <span>
                                            Add a new academic staff account
                                        </span>

                                    </div>

                                </div>


                            </div>

                        </a>

                    </div>



                    <!-- Manage Teachers -->

                    <div class="col-md-6">

                        <a
                            href="manage-teachers.jsp"
                            class="text-decoration-none">

                            <div class="quiz-item">


                                <div class="quiz-icon software-icon">

                                    <i class="bi bi-people-fill"></i>

                                </div>


                                <div class="quiz-information">

                                    <h5>
                                        Manage Teachers
                                    </h5>

                                    <div class="quiz-meta">

                                        <span>
                                            View and manage teacher accounts
                                        </span>

                                    </div>

                                </div>


                            </div>

                        </a>

                    </div>



                    <!-- Manage Students -->

                    <div class="col-md-6">

                        <a
                            href="#"
                            class="text-decoration-none">

                            <div class="quiz-item">


                                <div class="quiz-icon network-icon">

                                    <i class="bi bi-mortarboard-fill"></i>

                                </div>


                                <div class="quiz-information">

                                    <h5>
                                        Manage Students
                                    </h5>

                                    <div class="quiz-meta">

                                        <span>
                                            View registered students
                                        </span>

                                    </div>

                                </div>


                            </div>

                        </a>

                    </div>



                    <!-- Manage Quizzes -->

                    <div class="col-md-6">

                        <a
                            href="#"
                            class="text-decoration-none">

                            <div class="quiz-item">


                                <div class="quiz-icon security-icon">

                                    <i class="bi bi-journal-check"></i>

                                </div>


                                <div class="quiz-information">

                                    <h5>
                                        Manage Quizzes
                                    </h5>

                                    <div class="quiz-meta">

                                        <span>
                                            Monitor quiz activities
                                        </span>

                                    </div>

                                </div>


                            </div>

                        </a>

                    </div>


                </div>


            </div>

        </div>



        <!-- System Overview -->

        <div class="col-xl-4">


            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            System Overview
                        </h4>

                        <p>
                            Current platform status
                        </p>

                    </div>

                </div>



                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-people-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Users
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= totalStudents + totalTeachers %>
                                registered users
                            </span>

                        </div>

                    </div>

                </div>



                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

                        <i class="bi bi-journal-text"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Quizzes
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= totalQuizzes %>
                                quizzes in the system
                            </span>

                        </div>

                    </div>

                </div>



                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-broadcast-pin"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Published
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= publishedQuizzes %>
                                quizzes available
                            </span>

                        </div>

                    </div>

                </div>


            </div>


        </div>


    </div>



    <!-- =====================================================
         ADMINISTRATOR RESPONSIBILITIES
    ====================================================== -->

    <div class="content-card mt-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    Administrator Responsibilities
                </h4>

                <p>
                    Main functions available to system administrators
                </p>

            </div>

        </div>



        <div class="row g-3">


            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-person-check-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            User Management
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                Manage students and academic staff.
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

                        <i class="bi bi-shield-check"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            System Control
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                Monitor system activities and access.
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon network-icon">

                        <i class="bi bi-bar-chart-line-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Reports
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                Monitor quiz and student performance.
                            </span>

                        </div>

                    </div>

                </div>

            </div>


        </div>


    </div>



</div>



<!-- =========================================================
     FOOTER
========================================================= -->

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


</main>



<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>