<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // =========================================================
    // TEACHER AUTHENTICATION
    // =========================================================

    Integer teacherIdSession =
            (Integer) session.getAttribute("teacherId");

    if (teacherIdSession == null ||
        !Boolean.TRUE.equals(session.getAttribute("teacherLoggedIn")) ||
        !"TEACHER".equals(session.getAttribute("userRole"))) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int teacherId = teacherIdSession;


    // =========================================================
    // SESSION INFORMATION
    // =========================================================

    String teacherFirstName =
            (String) session.getAttribute("teacherFirstName");

    String teacherLastName =
            (String) session.getAttribute("teacherLastName");

    String teacherStaffNumber =
            (String) session.getAttribute("teacherStaffNumber");

    String teacherEmail =
            (String) session.getAttribute("teacherEmail");


    if (teacherFirstName == null) {
        teacherFirstName = "Teacher";
    }

    if (teacherLastName == null) {
        teacherLastName = "";
    }

    if (teacherStaffNumber == null) {
        teacherStaffNumber = "";
    }

    if (teacherEmail == null) {
        teacherEmail = "";
    }


    // =========================================================
    // LOAD FRESH DATA
    // =========================================================

    String dbFirstName = teacherFirstName;
    String dbLastName = teacherLastName;
    String dbStaffNumber = teacherStaffNumber;
    String dbEmail = teacherEmail;


    String sql =
            "SELECT first_name, last_name, staff_number, email " +
            "FROM teachers " +
            "WHERE id = ?";


    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement ps =
                 connection.prepareStatement(sql)) {

        ps.setInt(1, teacherId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                dbFirstName =
                        rs.getString("first_name");

                dbLastName =
                        rs.getString("last_name");

                dbStaffNumber =
                        rs.getString("staff_number");

                dbEmail =
                        rs.getString("email");
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    if (dbFirstName == null) dbFirstName = "Teacher";
    if (dbLastName == null) dbLastName = "";
    if (dbStaffNumber == null) dbStaffNumber = "";
    if (dbEmail == null) dbEmail = "";


    String initials = "";

    if (!dbFirstName.isEmpty()) {
        initials +=
                dbFirstName.substring(0, 1).toUpperCase();
    }

    if (!dbLastName.isEmpty()) {
        initials +=
                dbLastName.substring(0, 1).toUpperCase();
    }

    if (initials.isEmpty()) {
        initials = "T";
    }


    String successMessage =
            request.getParameter("success");

    String errorMessage =
            request.getParameter("error");
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Settings - UDOM Online Quiz System
    </title>


    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">


    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>


<body>


<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

    <div class="container-fluid">


        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#teacherSidebar">

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

                        <%= initials %>

                    </span>

                    <span class="student-name d-none d-md-inline">

                        <%= dbFirstName %>

                    </span>

                </button>


                <ul class="dropdown-menu dropdown-menu-end">

                    <li>

                        <a
                            class="dropdown-item"
                            href="profile.jsp">

                            <i class="bi bi-person me-2"></i>

                            My Profile

                        </a>

                    </li>


                    <li>

                        <a
                            class="dropdown-item active"
                            href="settings.jsp">

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
    id="teacherSidebar">


    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM Online Quiz

        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">

        </button>

    </div>


    <div class="sidebar-content">


        <!-- Sidebar Profile -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">

                <%= initials %>

            </div>


            <div>

                <h6>

                    <%= dbFirstName %>
                    <%= dbLastName %>

                </h6>

                <span>
                    Academic Staff
                </span>

            </div>

        </div>


        <!-- Main Menu -->

        <div class="sidebar-menu">

            <div class="menu-title">
                MAIN MENU
            </div>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="create-quiz.jsp"
                class="sidebar-link">

                <i class="bi bi-plus-square"></i>

                <span>
                    Create Quiz
                </span>

            </a>


            <a
                href="my-courses.jsp"
                class="sidebar-link">

                <i class="bi bi-book-half"></i>

                <span>
                    My Courses
                </span>

            </a>


            <a
                href="results.jsp"
                class="sidebar-link">

                <i class="bi bi-bar-chart"></i>

                <span>
                    Student Results
                </span>

            </a>


            <div class="menu-title mt-3">
                ACCOUNT
            </div>


            <a
                href="profile.jsp"
                class="sidebar-link">

                <i class="bi bi-person-circle"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="settings.jsp"
                class="sidebar-link active">

                <i class="bi bi-gear"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>


        <!-- Sidebar Bottom -->

        <div class="sidebar-bottom">

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


<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <!-- Header -->

        <div class="welcome-section">

            <div class="welcome-label">

                <i class="bi bi-gear"></i>

                ACCOUNT SETTINGS

            </div>


            <h1>
                Settings
            </h1>


            <p>
                Manage your teacher account and security settings.
            </p>

        </div>


        <!-- =================================================
             SUCCESS MESSAGE
        ================================================== -->

        <% if (successMessage != null) { %>

            <div
                class="alert alert-success alert-dismissible fade show">

                <i class="bi bi-check-circle me-2"></i>

                <%= successMessage %>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>


        <!-- =================================================
             ERROR MESSAGE
        ================================================== -->

        <% if (errorMessage != null) { %>

            <div
                class="alert alert-danger alert-dismissible fade show">

                <i class="bi bi-exclamation-triangle me-2"></i>

                <%= errorMessage %>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>


        <div class="row g-4">


            <!-- =================================================
                 ACCOUNT INFORMATION
            ================================================== -->

            <div class="col-lg-6">

                <div class="content-card h-100">

                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-person-gear me-2"></i>

                                Account Information

                            </h5>

                            <p>
                                Your current teacher account details.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">


                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-person-badge"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Staff Number
                                </h6>

                                <p>
                                    <%= dbStaffNumber %>
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-envelope"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Email Address
                                </h6>

                                <p>
                                    <%= dbEmail %>
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item">

                            <div class="quiz-icon">

                                <i class="bi bi-shield-check"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Account Role
                                </h6>

                                <p>
                                    Academic Staff / Teacher
                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 SYSTEM INFORMATION
            ================================================== -->

            <div class="col-lg-6">

                <div class="content-card h-100">

                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-info-circle me-2"></i>

                                System Information

                            </h5>

                            <p>
                                Information about the quiz system.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">


                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-mortarboard-fill"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    System
                                </h6>

                                <p>
                                    UDOM Online Quiz System
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item mb-3">

                            <div class="quiz-icon security-icon">

                                <i class="bi bi-shield-lock"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Security
                                </h6>

                                <p>
                                    Passwords are securely protected.
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item">

                            <div class="quiz-icon">

                                <i class="bi bi-database-check"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Database
                                </h6>

                                <p>
                                    PostgreSQL
                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 CHANGE PASSWORD
            ================================================== -->

            <div class="col-12">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-key me-2"></i>

                                Change Password

                            </h5>

                            <p>
                                Update your teacher account password.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">


                        <form
                            method="post"
                            action="<%= request.getContextPath() %>/teacherChangePassword">


                            <div class="row g-4">


                                <!-- Current Password -->

                                <div class="col-md-4">

                                    <label
                                        class="form-label fw-semibold">

                                        Current Password

                                    </label>


                                    <div class="input-group">

                                        <span class="input-group-text">

                                            <i class="bi bi-lock"></i>

                                        </span>


                                        <input
                                            type="password"
                                            name="currentPassword"
                                            class="form-control"
                                            required>

                                    </div>

                                </div>


                                <!-- New Password -->

                                <div class="col-md-4">

                                    <label
                                        class="form-label fw-semibold">

                                        New Password

                                    </label>


                                    <div class="input-group">

                                        <span class="input-group-text">

                                            <i class="bi bi-key"></i>

                                        </span>


                                        <input
                                            type="password"
                                            name="newPassword"
                                            class="form-control"
                                            minlength="6"
                                            required>

                                    </div>

                                    <small class="text-muted">
                                        Minimum 6 characters.
                                    </small>

                                </div>


                                <!-- Confirm -->

                                <div class="col-md-4">

                                    <label
                                        class="form-label fw-semibold">

                                        Confirm New Password

                                    </label>


                                    <div class="input-group">

                                        <span class="input-group-text">

                                            <i class="bi bi-check2-circle"></i>

                                        </span>


                                        <input
                                            type="password"
                                            name="confirmPassword"
                                            class="form-control"
                                            minlength="6"
                                            required>

                                    </div>

                                </div>


                                <!-- Button -->

                                <div class="col-12">

                                    <button
                                        type="submit"
                                        class="btn btn-primary">

                                        <i class="bi bi-shield-lock me-2"></i>

                                        Update Password

                                    </button>

                                </div>

                            </div>

                        </form>

                    </div>

                </div>

            </div>


        </div>

    </div>

</main>


<!-- =========================================================
     FOOTER
========================================================= -->

<footer class="dashboard-footer">

    <div class="container-fluid">

        <div
            class="d-flex justify-content-between align-items-center flex-wrap gap-2">

            <span>
                © 2026 UDOM Online Quiz System
            </span>

            <div>

                <a href="#" class="me-3">
                    Help
                </a>

                <a href="#" class="me-3">
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