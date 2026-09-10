<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    if (session.getAttribute("adminLoggedIn") == null ||
        !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String adminFirstName = (String) session.getAttribute("adminFirstName");
    String adminUsername = (String) session.getAttribute("adminUsername");
    String adminEmail = (String) session.getAttribute("adminEmail");

    if (adminFirstName == null) {
        adminFirstName = "Administrator";
    }

    if (adminUsername == null) {
        adminUsername = "admin";
    }

    if (adminEmail == null) {
        adminEmail = "";
    }

    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Settings - UDOM Online Quiz System</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="../css/dashboard.css">
</head>

<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>
        </button>

        <a class="navbar-brand d-flex align-items-center" href="dashboard.jsp">

            <span class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </span>

            <span class="brand-text">
                UDOM / Online Quiz System
            </span>

        </a>

        <div class="ms-auto d-flex align-items-center">

            <!-- Notification -->
            <button class="btn notification-btn me-3 position-relative">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">0</span>

            </button>

            <!-- Profile Dropdown -->
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
                        <a class="dropdown-item" href="profile.jsp">
                            <i class="bi bi-person me-2"></i>
                            Profile
                        </a>
                    </li>

                    <li>
                        <a class="dropdown-item active" href="settings.jsp">
                            <i class="bi bi-gear me-2"></i>
                            Settings
                        </a>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li>
                        <a class="dropdown-item text-danger" href="../logout">
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

        <!-- Sidebar Profile -->
        <div class="sidebar-profile">

            <div class="student-avatar large">
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

            <a href="dashboard.jsp" class="sidebar-link">
                <i class="bi bi-speedometer2"></i>
                <span>Dashboard</span>
            </a>


            <div class="menu-title mt-3">
                MANAGEMENT
            </div>

            <a href="create-teacher.jsp" class="sidebar-link">
                <i class="bi bi-person-plus"></i>
                <span>Create Teacher</span>
            </a>

            <a href="manage-teachers.jsp" class="sidebar-link">
                <i class="bi bi-people"></i>
                <span>Manage Teachers</span>
            </a>

            <a href="assign-courses.jsp" class="sidebar-link">
                <i class="bi bi-journal-check"></i>
                <span>Assign Courses</span>
            </a>

            <a href="manage-students.jsp" class="sidebar-link">
                <i class="bi bi-mortarboard"></i>
                <span>Manage Students</span>
            </a>

            <a href="manage-quizzes.jsp" class="sidebar-link">
                <i class="bi bi-ui-checks-grid"></i>
                <span>Manage Quizzes</span>
            </a>


            <div class="menu-title mt-3">
                REPORTS
            </div>

            <a href="results.jsp" class="sidebar-link">
                <i class="bi bi-bar-chart"></i>
                <span>Results</span>
            </a>

            <a href="reports.jsp" class="sidebar-link">
                <i class="bi bi-file-earmark-bar-graph"></i>
                <span>Reports</span>
            </a>


            <div class="menu-title mt-3">
                ACCOUNT
            </div>

            <a href="profile.jsp" class="sidebar-link">
                <i class="bi bi-person-circle"></i>
                <span>Profile</span>
            </a>

            <a href="settings.jsp" class="sidebar-link active">
                <i class="bi bi-gear"></i>
                <span>Settings</span>
            </a>

        </div>


        <!-- Sidebar Bottom -->
        <div class="sidebar-bottom">

            <a href="../logout" class="sidebar-link logout-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- ================= MAIN CONTENT ================= -->
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
                Manage your administrator account and security settings.
            </p>

        </div>


        <!-- Messages -->
        <% if (successMessage != null) { %>

            <div class="alert alert-success alert-dismissible fade show">

                <i class="bi bi-check-circle me-2"></i>

                <%= successMessage %>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>


        <% if (errorMessage != null) { %>

            <div class="alert alert-danger alert-dismissible fade show">

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


            <!-- ================= ACCOUNT PREFERENCES ================= -->
            <div class="col-lg-6">

                <div class="content-card h-100">

                    <div class="card-header-custom">

                        <div>

                            <h5>
                                <i class="bi bi-person-gear me-2"></i>
                                Account Preferences
                            </h5>

                            <p>
                                Your current administrator account information.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-person"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>Username</h6>

                                <p>
                                    <%= adminUsername %>
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-envelope"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>Email Address</h6>

                                <p>
                                    <%= adminEmail %>
                                </p>

                            </div>

                        </div>


                        <div class="quiz-item">

                            <div class="quiz-icon">

                                <i class="bi bi-shield-check"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>Account Role</h6>

                                <p>
                                    System Administrator
                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- ================= SYSTEM INFORMATION ================= -->
            <div class="col-lg-6">

                <div class="content-card h-100">

                    <div class="card-header-custom">

                        <div>

                            <h5>
                                <i class="bi bi-info-circle me-2"></i>
                                System Information
                            </h5>

                            <p>
                                Information about the current quiz system.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon software-icon">

                                <i class="bi bi-mortarboard-fill"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>System</h6>

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

                                <h6>Security</h6>

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

                                <h6>Database</h6>

                                <p>
                                    PostgreSQL
                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- ================= CHANGE PASSWORD ================= -->
            <div class="col-12">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h5>
                                <i class="bi bi-key me-2"></i>
                                Change Password
                            </h5>

                            <p>
                                Update your administrator password.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <form
                            action="../adminChangePassword"
                            method="post">

                            <div class="row g-4">

                                <div class="col-md-4">

                                    <label class="form-label">
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


                                <div class="col-md-4">

                                    <label class="form-label">
                                        New Password
                                    </label>

                                    <div class="input-group">

                                        <span class="input-group-text">
                                            <i class="bi bi-lock-fill"></i>
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


                                <div class="col-md-4">

                                    <label class="form-label">
                                        Confirm New Password
                                    </label>

                                    <div class="input-group">

                                        <span class="input-group-text">
                                            <i class="bi bi-check2-square"></i>
                                        </span>

                                        <input
                                            type="password"
                                            name="confirmPassword"
                                            class="form-control"
                                            minlength="6"
                                            required>

                                    </div>

                                </div>

                            </div>


                            <div class="mt-4">

                                <button
                                    type="submit"
                                    class="btn btn-primary">

                                    <i class="bi bi-shield-lock me-2"></i>
                                    Update Password

                                </button>

                            </div>

                        </form>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================= FOOTER ================= -->
        <footer class="dashboard-footer mt-5">

            <div>
                © 2026 UDOM Online Quiz System
            </div>

            <div class="d-flex gap-3">

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


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>