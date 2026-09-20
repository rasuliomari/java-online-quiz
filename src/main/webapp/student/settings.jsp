<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ============================================================
    // STUDENT AUTHENTICATION
    // ============================================================

    Boolean studentLoggedIn =
            (Boolean) session.getAttribute("studentLoggedIn");

    if (studentLoggedIn == null || !studentLoggedIn) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userRole =
            (String) session.getAttribute("userRole");

    if (!"STUDENT".equals(userRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }


    // ============================================================
    // STUDENT ID
    // ============================================================

    Object studentIdObject =
            session.getAttribute("studentId");

    if (studentIdObject == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int studentId;

    try {
        studentId =
                Integer.parseInt(studentIdObject.toString());
    } catch (NumberFormatException e) {
        response.sendRedirect("../login.jsp");
        return;
    }


    // ============================================================
    // SESSION DATA
    // ============================================================

    String firstName =
            (String) session.getAttribute("studentFirstName");

    String email =
            (String) session.getAttribute("studentEmail");

    String registrationNumber =
            (String) session.getAttribute(
                    "studentRegistrationNumber");


    if (firstName == null || firstName.trim().isEmpty()) {
        firstName = "Student";
    }

    if (email == null) {
        email = "";
    }

    if (registrationNumber == null) {
        registrationNumber = "";
    }


    // ============================================================
    // LOAD FRESH STUDENT DATA
    // ============================================================

    String dbFirstName = firstName;
    String dbEmail = email;
    String dbRegistrationNumber = registrationNumber;


    String sql =
            "SELECT first_name, email, registration_number " +
            "FROM students " +
            "WHERE id = ?";


    try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
    ) {

        statement.setInt(1, studentId);

        try (
                ResultSet resultSet =
                        statement.executeQuery()
        ) {

            if (resultSet.next()) {

                dbFirstName =
                        resultSet.getString("first_name");

                dbEmail =
                        resultSet.getString("email");

                dbRegistrationNumber =
                        resultSet.getString(
                                "registration_number");
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }


    if (dbFirstName == null ||
        dbFirstName.trim().isEmpty()) {

        dbFirstName = "Student";
    }

    if (dbEmail == null) {
        dbEmail = "";
    }

    if (dbRegistrationNumber == null) {
        dbRegistrationNumber = "";
    }


    // ============================================================
    // AVATAR
    // ============================================================

    String avatarLetter =
            dbFirstName.substring(0, 1).toUpperCase();


    // ============================================================
    // SUCCESS / ERROR MESSAGES
    // ============================================================

    String successMessage =
            request.getParameter("success");

    String errorMessage =
            request.getParameter("error");
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        Settings | UDOM Online Quiz System
    </title>


    <!-- Bootstrap 5.3.3 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- Dashboard CSS -->
    <link
        rel="stylesheet"
        href="../css/dashboard.css">


    <style>

        /* ========================================================
           CHANGE PASSWORD
        ======================================================== */

        .password-section {
            padding: 24px;
        }

        .password-form-group {
            margin-bottom: 20px;
        }

        .password-form-group label {
            font-weight: 600;
            color: #343a40;
            margin-bottom: 8px;
        }

        .password-input-group {
            position: relative;
        }

        .password-input-group .form-control {
            padding-right: 48px;
            min-height: 46px;
            border-radius: 10px;
        }

        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #6c757d;
            padding: 5px 8px;
            z-index: 5;
        }

        .password-toggle:hover {
            color: #0d6efd;
        }

        .password-help {
            font-size: 13px;
            color: #6c757d;
            margin-top: 6px;
        }

        .change-password-btn {
            min-height: 46px;
            border-radius: 10px;
            font-weight: 600;
            padding: 0 22px;
        }

        .security-notice {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 18px;
            margin-top: 20px;
            border: 1px solid #e9ecef;
        }

        .security-notice i {
            font-size: 20px;
            margin-right: 10px;
        }

        .security-notice p {
            margin: 8px 0 0;
            color: #6c757d;
            font-size: 14px;
        }

        .alert {
            border-radius: 10px;
        }

    </style>

</head>


<body>


<!-- ============================================================
     NAVBAR
============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">


        <!-- Mobile Sidebar Button -->

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

            <span class="brand-icon">

                <i class="bi bi-mortarboard-fill"></i>

            </span>

            <span class="brand-text">

                UDOM / Online Quiz System

            </span>

        </a>


        <!-- Right Side -->

        <div class="ms-auto d-flex align-items-center">


            <!-- Notification -->

            <button
                class="btn notification-btn me-3"
                type="button">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    0
                </span>

            </button>


            <!-- Profile Dropdown -->

            <div class="dropdown">

                <button
                    class="btn profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false">

                    <span class="student-avatar">

                        <%= avatarLetter %>

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



<!-- ============================================================
     SIDEBAR
============================================================ -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="studentSidebar">


    <!-- Mobile Header -->

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


    <!-- Sidebar Content -->

    <div class="sidebar-content">


        <!-- Student Profile -->

        <div class="sidebar-profile">

            <div class="student-avatar">

                <%= avatarLetter %>

            </div>

            <div>

                <h6>
                    <%= dbFirstName %>
                </h6>

                <small>
                    Student Account
                </small>

            </div>

        </div>



        <!-- Sidebar Menu -->

        <div class="sidebar-menu">


            <div class="menu-title">
                MAIN MENU
            </div>


            <!-- Dashboard -->

            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- Available Quizzes -->

            <a
                href="dashboard.jsp#available-quizzes"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
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


            <!-- Account -->

            <div class="menu-title mt-3">
                ACCOUNT
            </div>


            <!-- Profile -->

            <a
                href="profile.jsp"
                class="sidebar-link">

                <i class="bi bi-person-circle"></i>

                <span>
                    My Profile
                </span>

            </a>


            <!-- Settings -->

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



<!-- ============================================================
     MAIN CONTENT
============================================================ -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <!-- Page Header -->

        <div class="welcome-section">

            <div class="welcome-label">

                <i class="bi bi-gear"></i>

                ACCOUNT SETTINGS

            </div>

            <h1>
                Settings
            </h1>

            <p>
                Manage your student account and security information.
            </p>

        </div>



        <!-- ====================================================
             SUCCESS MESSAGE
        ===================================================== -->

        <% if (successMessage != null &&
               !successMessage.trim().isEmpty()) { %>

            <div
                class="alert alert-success alert-dismissible fade show"
                role="alert">

                <i class="bi bi-check-circle-fill me-2"></i>

                <%= successMessage %>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>



        <!-- ====================================================
             ERROR MESSAGE
        ===================================================== -->

        <% if (errorMessage != null &&
               !errorMessage.trim().isEmpty()) { %>

            <div
                class="alert alert-danger alert-dismissible fade show"
                role="alert">

                <i class="bi bi-exclamation-triangle-fill me-2"></i>

                <%= errorMessage %>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>



        <!-- ====================================================
             MAIN ROW
        ===================================================== -->

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
                                Your current student account information.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">


                        <!-- Account Name -->

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-person"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Account Name
                                </h6>

                                <p>
                                    <%= dbFirstName %>
                                </p>

                            </div>

                        </div>


                        <!-- Registration Number -->

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-card-text"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Registration Number
                                </h6>

                                <p>
                                    <%= dbRegistrationNumber %>
                                </p>

                            </div>

                        </div>


                        <!-- Email -->

                        <div class="quiz-item">

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


                    </div>

                </div>

            </div>



            <!-- =================================================
                 SECURITY STATUS
            ================================================== -->

            <div class="col-lg-6">

                <div class="content-card h-100">


                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-shield-lock me-2"></i>

                                Security

                            </h5>

                            <p>
                                Information about your account security.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">


                        <!-- Account Status -->

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-shield-check"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Account Status
                                </h6>

                                <p>
                                    Active Student Account
                                </p>

                            </div>

                        </div>


                        <!-- Password -->

                        <div class="quiz-item mb-3">

                            <div class="quiz-icon">

                                <i class="bi bi-lock"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Password
                                </h6>

                                <p>
                                    Password is securely protected
                                </p>

                            </div>

                        </div>


                        <!-- Role -->

                        <div class="quiz-item">

                            <div class="quiz-icon">

                                <i class="bi bi-person-badge"></i>

                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Account Role
                                </h6>

                                <p>
                                    Student
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
                                Change the password provided by the administrator.
                            </p>

                        </div>

                    </div>


                    <div class="password-section">


                        <!-- Information Notice -->

                        <div class="alert alert-info">

                            <i class="bi bi-info-circle-fill me-2"></i>

                            If the administrator gave you a default password,
                            you can change it here after logging in.

                        </div>


                        <!-- Change Password Form -->

                        <form
                            action="../studentChangePassword"
                            method="post"
                            autocomplete="off">


                            <!-- Current Password -->

                            <div class="password-form-group">

                                <label
                                    for="currentPassword"
                                    class="form-label">

                                    Current Password

                                </label>


                                <div class="password-input-group">

                                    <input
                                        type="password"
                                        class="form-control"
                                        id="currentPassword"
                                        name="currentPassword"
                                        placeholder="Enter your current password"
                                        required>


                                    <button
                                        type="button"
                                        class="password-toggle"
                                        onclick="togglePassword('currentPassword', this)"
                                        aria-label="Show current password">

                                        <i class="bi bi-eye"></i>

                                    </button>

                                </div>


                                <div class="password-help">

                                    Enter the password you currently use
                                    to log in.

                                </div>

                            </div>



                            <!-- New Password -->

                            <div class="password-form-group">

                                <label
                                    for="newPassword"
                                    class="form-label">

                                    New Password

                                </label>


                                <div class="password-input-group">

                                    <input
                                        type="password"
                                        class="form-control"
                                        id="newPassword"
                                        name="newPassword"
                                        placeholder="Enter your new password"
                                        minlength="6"
                                        required>


                                    <button
                                        type="button"
                                        class="password-toggle"
                                        onclick="togglePassword('newPassword', this)"
                                        aria-label="Show new password">

                                        <i class="bi bi-eye"></i>

                                    </button>

                                </div>


                                <div class="password-help">

                                    Your new password must contain at least
                                    6 characters.

                                </div>

                            </div>



                            <!-- Confirm Password -->

                            <div class="password-form-group">

                                <label
                                    for="confirmPassword"
                                    class="form-label">

                                    Confirm New Password

                                </label>


                                <div class="password-input-group">

                                    <input
                                        type="password"
                                        class="form-control"
                                        id="confirmPassword"
                                        name="confirmPassword"
                                        placeholder="Confirm your new password"
                                        minlength="6"
                                        required>


                                    <button
                                        type="button"
                                        class="password-toggle"
                                        onclick="togglePassword('confirmPassword', this)"
                                        aria-label="Show password confirmation">

                                        <i class="bi bi-eye"></i>

                                    </button>

                                </div>


                            </div>



                            <!-- Submit -->

                            <button
                                type="submit"
                                class="btn btn-primary change-password-btn">

                                <i class="bi bi-shield-lock me-2"></i>

                                Change Password

                            </button>


                        </form>



                        <!-- Security Notice -->

                        <div class="security-notice">

                            <div>

                                <i class="bi bi-shield-check text-success"></i>

                                <strong>
                                    Password Security
                                </strong>

                            </div>

                            <p>

                                Your password is stored securely using
                                password hashing. Never share your password
                                with another person.

                            </p>

                        </div>


                    </div>

                </div>

            </div>



            <!-- =================================================
                 SYSTEM INFORMATION
            ================================================== -->

            <div class="col-12">

                <div class="content-card">


                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-info-circle me-2"></i>

                                System Information

                            </h5>

                            <p>
                                Information about your access to the quiz system.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <div class="row g-4">


                            <!-- System -->

                            <div class="col-md-4">

                                <div class="quiz-item">

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

                            </div>


                            <!-- User Type -->

                            <div class="col-md-4">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-person-check"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>
                                            User Type
                                        </h6>

                                        <p>
                                            Student
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <!-- Access -->

                            <div class="col-md-4">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-shield-check"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>
                                            Access
                                        </h6>

                                        <p>
                                            Student Dashboard
                                        </p>

                                    </div>

                                </div>

                            </div>


                        </div>

                    </div>

                </div>

            </div>


        </div>


        <!-- ====================================================
             FOOTER
        ===================================================== -->

        <footer class="dashboard-footer mt-5">

            <div class="d-flex flex-column flex-md-row
                        justify-content-between align-items-center">

                <p class="mb-2 mb-md-0">

                    &copy; <%= java.time.Year.now().getValue() %>
                    UDOM Online Quiz System.
                    All rights reserved.

                </p>


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

        </footer>


    </div>

</main>



<!-- ============================================================
     BOOTSTRAP
============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>



<!-- ============================================================
     PASSWORD TOGGLE
============================================================ -->

<script>

    function togglePassword(fieldId, button) {

        const field =
            document.getElementById(fieldId);

        const icon =
            button.querySelector("i");


        if (field.type === "password") {

            field.type = "text";

            icon.classList.remove("bi-eye");

            icon.classList.add("bi-eye-slash");

            button.setAttribute(
                "aria-label",
                "Hide password"
            );

        } else {

            field.type = "password";

            icon.classList.remove("bi-eye-slash");

            icon.classList.add("bi-eye");

            button.setAttribute(
                "aria-label",
                "Show password"
            );
        }
    }


    // ============================================================
    // CONFIRM PASSWORD CHECK
    // ============================================================

    document
        .querySelector("form")
        .addEventListener("submit", function(event) {

            const newPassword =
                document.getElementById("newPassword").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;


            if (newPassword !== confirmPassword) {

                event.preventDefault();

                alert(
                    "New password and confirmation do not match."
                );

            }

        });

</script>


</body>

</html>