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

    String teacherMiddleName =
            (String) session.getAttribute("teacherMiddleName");

    String teacherLastName =
            (String) session.getAttribute("teacherLastName");

    String teacherStaffNumber =
            (String) session.getAttribute("teacherStaffNumber");

    String teacherEmail =
            (String) session.getAttribute("teacherEmail");

    String teacherPhone =
            (String) session.getAttribute("teacherPhone");

    String teacherCollege =
            (String) session.getAttribute("teacherCollege");

    String teacherDepartment =
            (String) session.getAttribute("teacherDepartment");


    // =========================================================
    // DEFAULT VALUES
    // =========================================================

    if (teacherFirstName == null) teacherFirstName = "";
    if (teacherMiddleName == null) teacherMiddleName = "";
    if (teacherLastName == null) teacherLastName = "";
    if (teacherStaffNumber == null) teacherStaffNumber = "";
    if (teacherEmail == null) teacherEmail = "";
    if (teacherPhone == null) teacherPhone = "";
    if (teacherCollege == null) teacherCollege = "";
    if (teacherDepartment == null) teacherDepartment = "";


    // =========================================================
    // LOAD FRESH TEACHER DATA
    // =========================================================

    String dbFirstName = teacherFirstName;
    String dbMiddleName = teacherMiddleName;
    String dbLastName = teacherLastName;
    String dbStaffNumber = teacherStaffNumber;
    String dbEmail = teacherEmail;
    String dbPhone = teacherPhone;
    String dbCollege = teacherCollege;
    String dbDepartment = teacherDepartment;


    String sql =
            "SELECT first_name, middle_name, last_name, " +
            "staff_number, email, phone, college, department " +
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

                dbMiddleName =
                        rs.getString("middle_name");

                dbLastName =
                        rs.getString("last_name");

                dbStaffNumber =
                        rs.getString("staff_number");

                dbEmail =
                        rs.getString("email");

                dbPhone =
                        rs.getString("phone");

                dbCollege =
                        rs.getString("college");

                dbDepartment =
                        rs.getString("department");
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    // =========================================================
    // NULL PROTECTION
    // =========================================================

    if (dbFirstName == null) dbFirstName = "";
    if (dbMiddleName == null) dbMiddleName = "";
    if (dbLastName == null) dbLastName = "";
    if (dbStaffNumber == null) dbStaffNumber = "";
    if (dbEmail == null) dbEmail = "";
    if (dbPhone == null) dbPhone = "";
    if (dbCollege == null) dbCollege = "";
    if (dbDepartment == null) dbDepartment = "";


    String displayName =
            (dbFirstName + " " +
             dbMiddleName + " " +
             dbLastName)
            .replaceAll("\\s+", " ")
            .trim();


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
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        My Profile - UDOM Online Quiz System
    </title>


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


<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

    <div class="container-fluid">


        <!-- Mobile Sidebar -->

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#teacherSidebar">

            <i class="bi bi-list"></i>

        </button>


        <!-- Brand -->

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


        <!-- Right Side -->

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
                            class="dropdown-item active"
                            href="profile.jsp">

                            <i class="bi bi-person me-2"></i>

                            My Profile

                        </a>

                    </li>


                    <li>

                        <a
                            class="dropdown-item"
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
                class="sidebar-link active">

                <i class="bi bi-person-circle"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="settings.jsp"
                class="sidebar-link">

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

                <i class="bi bi-person-circle"></i>

                TEACHER ACCOUNT

            </div>


            <h1>
                My Profile
            </h1>


            <p>
                View your academic staff account information.
            </p>

        </div>


        <div class="row g-4">


            <!-- =================================================
                 PROFILE SUMMARY
            ================================================== -->

            <div class="col-lg-4">

                <div class="content-card h-100">

                    <div class="p-4 text-center">


                        <div
                            class="sidebar-avatar mx-auto mb-3"
                            style="width:90px;height:90px;font-size:28px;">

                            <%= initials %>

                        </div>


                        <h4 class="mb-1">

                            <%= displayName %>

                        </h4>


                        <p class="text-muted mb-3">

                            Academic Staff

                        </p>


                        <span class="badge bg-primary">

                            Teacher

                        </span>


                        <hr class="my-4">


                        <div class="text-start">

                            <div class="quiz-item mb-3">

                                <div class="quiz-icon">

                                    <i class="bi bi-person-badge"></i>

                                </div>

                                <div class="quiz-information">

                                    <h6>Staff Number</h6>

                                    <p>
                                        <%= dbStaffNumber %>
                                    </p>

                                </div>

                            </div>


                            <div class="quiz-item">

                                <div class="quiz-icon">

                                    <i class="bi bi-envelope"></i>

                                </div>

                                <div class="quiz-information">

                                    <h6>Email</h6>

                                    <p>
                                        <%= dbEmail %>
                                    </p>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 PERSONAL INFORMATION
            ================================================== -->

            <div class="col-lg-8">

                <div class="content-card h-100">

                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-person-vcard me-2"></i>

                                Personal Information

                            </h5>

                            <p>
                                Your registered teacher information.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <div class="row g-4">


                            <div class="col-md-4">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-person"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>First Name</h6>

                                        <p>
                                            <%= dbFirstName %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-4">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-person"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Middle Name</h6>

                                        <p>
                                            <%= dbMiddleName.isEmpty()
                                                ? "Not provided"
                                                : dbMiddleName %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-4">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-person"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Last Name</h6>

                                        <p>
                                            <%= dbLastName %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-envelope"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Email Address</h6>

                                        <p>
                                            <%= dbEmail %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-telephone"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Phone Number</h6>

                                        <p>
                                            <%= dbPhone %>
                                        </p>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================================
                 ACADEMIC INFORMATION
            ================================================== -->

            <div class="col-12">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h5>

                                <i class="bi bi-building me-2"></i>

                                Academic Information

                            </h5>

                            <p>
                                Your current academic staff assignment.
                            </p>

                        </div>

                    </div>


                    <div class="p-4">

                        <div class="row g-4">


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon software-icon">

                                        <i class="bi bi-building"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>College</h6>

                                        <p>
                                            <%= dbCollege %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon security-icon">

                                        <i class="bi bi-diagram-3"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Department</h6>

                                        <p>
                                            <%= dbDepartment %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-person-badge"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Staff Number</h6>

                                        <p>
                                            <%= dbStaffNumber %>
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="quiz-item">

                                    <div class="quiz-icon">

                                        <i class="bi bi-shield-check"></i>

                                    </div>

                                    <div class="quiz-information">

                                        <h6>Account Role</h6>

                                        <p>
                                            Academic Staff / Teacher
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


<!-- =========================================================
     FOOTER
========================================================= -->

<footer class="dashboard-footer">

    <div class="container-fluid">

        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">

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