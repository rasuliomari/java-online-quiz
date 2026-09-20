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
    // LOAD FRESH DATA
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

        try (ResultSet resultSet =
                statement.executeQuery()) {

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


    if (dbFirstName == null) dbFirstName = "Student";
    if (dbEmail == null) dbEmail = "";
    if (dbRegistrationNumber == null) {
        dbRegistrationNumber = "";
    }


    // ============================================================
    // AVATAR
    // ============================================================

    String avatarLetter =
            dbFirstName
            .substring(0, 1)
            .toUpperCase();
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

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>

<body>


<!-- ============================================================
     NAVBAR
============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#studentSidebar">

            <i class="bi bi-list"></i>

        </button>


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


        <div class="ms-auto d-flex align-items-center">

            <button
                class="btn notification-btn me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    0
                </span>

            </button>


            <div class="dropdown">

                <button
                    class="btn profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">

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
                href="dashboard.jsp#available-quizzes"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

            </a>


            <a
                href="quiz-history.jsp"
                class="sidebar-link">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <a
                href="quiz-history.jsp"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
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
                 SECURITY
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

    </div>

</main>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>