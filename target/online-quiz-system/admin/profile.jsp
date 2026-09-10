
<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ==========================================
    // ADMIN AUTHENTICATION
    // ==========================================

    if (session.getAttribute("adminLoggedIn") == null ||
        !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    // ==========================================
    // SESSION INFORMATION
    // ==========================================

    Integer adminId =
        (Integer) session.getAttribute("adminId");

    String adminUsername =
        (String) session.getAttribute("adminUsername");

    String adminFirstName =
        (String) session.getAttribute("adminFirstName");

    String adminMiddleName =
        (String) session.getAttribute("adminMiddleName");

    String adminLastName =
        (String) session.getAttribute("adminLastName");

    String adminEmail =
        (String) session.getAttribute("adminEmail");


    // ==========================================
    // DEFAULT VALUES
    // ==========================================

    if (adminFirstName == null) {
        adminFirstName = "";
    }

    if (adminMiddleName == null) {
        adminMiddleName = "";
    }

    if (adminLastName == null) {
        adminLastName = "";
    }

    if (adminUsername == null) {
        adminUsername = "";
    }

    if (adminEmail == null) {
        adminEmail = "";
    }


    String fullName =
        (adminFirstName + " " +
         adminMiddleName + " " +
         adminLastName)
        .replaceAll("\\s+", " ")
        .trim();


    String avatarLetter = "A";

    if (!adminFirstName.isEmpty()) {
        avatarLetter =
            adminFirstName.substring(0, 1).toUpperCase();
    }


    // ==========================================
    // LOAD FRESH DATA FROM DATABASE
    // ==========================================

    String dbFirstName = adminFirstName;
    String dbMiddleName = adminMiddleName;
    String dbLastName = adminLastName;
    String dbUsername = adminUsername;
    String dbEmail = adminEmail;

    if (adminId != null) {

        String sql =
            "SELECT first_name, middle_name, last_name, " +
            "username, email " +
            "FROM admins " +
            "WHERE id = ?";

        try (Connection conn =
                DBConnection.getConnection();
             PreparedStatement ps =
                conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    dbFirstName =
                        rs.getString("first_name");

                    dbMiddleName =
                        rs.getString("middle_name");

                    dbLastName =
                        rs.getString("last_name");

                    dbUsername =
                        rs.getString("username");

                    dbEmail =
                        rs.getString("email");
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }


    if (dbFirstName == null) dbFirstName = "";
    if (dbMiddleName == null) dbMiddleName = "";
    if (dbLastName == null) dbLastName = "";
    if (dbUsername == null) dbUsername = "";
    if (dbEmail == null) dbEmail = "";


    String displayName =
        (dbFirstName + " " +
         dbMiddleName + " " +
         dbLastName)
        .replaceAll("\\s+", " ")
        .trim();


    String displayAvatar = "A";

    if (!dbFirstName.isEmpty()) {
        displayAvatar =
            dbFirstName.substring(0, 1).toUpperCase();
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Admin Profile - UDOM Online Quiz System
    </title>


    <!-- Bootstrap 5.3.3 -->

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


        <!-- Mobile Sidebar Button -->

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

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


            <!-- Profile Dropdown -->

            <div class="dropdown">

                <button
                    class="btn profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">

                    <span class="student-avatar">

                        <%= displayAvatar %>

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


    <!-- Mobile Header -->

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

                <%= displayAvatar %>

            </div>


            <div>

                <h6>

                    <%= dbFirstName %>

                </h6>

                <small>

                    System Administrator

                </small>

            </div>

        </div>



        <!-- Sidebar Menu -->

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
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>

                <span>

                    Reports

                </span>

            </a>

        </div>



        <!-- Sidebar Bottom -->

        <div class="sidebar-bottom">


            <a
                href="settings.jsp"
                class="sidebar-link">

                <i class="bi bi-gear"></i>

                <span>

                    Settings

                </span>

            </a>


            <a
                href="profile.jsp"
                class="sidebar-link active">

                <i class="bi bi-person-circle"></i>

                <span>

                    Profile

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


        <!-- Page Header -->

        <div class="welcome-section">

            <div>

                <div class="welcome-label">

                    ADMINISTRATION

                </div>


                <h1>

                    Administrator Profile

                </h1>


                <p>

                    View your administrator account information.

                </p>

            </div>

        </div>



        <!-- ================================================= -->
        <!-- PROFILE CONTENT -->
        <!-- ================================================= -->

        <div class="row g-4">


            <!-- Profile Card -->

            <div class="col-lg-4">

                <div class="content-card text-center">


                    <div class="py-3">


                        <!-- Avatar -->

                        <div
                            class="student-avatar mx-auto mb-3"
                            style="
                                width: 90px;
                                height: 90px;
                                font-size: 2rem;
                            ">

                            <%= displayAvatar %>

                        </div>


                        <h4 class="mb-1">

                            <%= displayName %>

                        </h4>


                        <p class="text-muted mb-3">

                            System Administrator

                        </p>


                        <span class="badge bg-success">

                            Active Account

                        </span>

                    </div>

                </div>

            </div>



            <!-- Account Information -->

            <div class="col-lg-8">

                <div class="content-card">


                    <div class="card-header-custom">

                        <div>

                            <h5>

                                Account Information

                            </h5>

                            <p>

                                Administrator account details

                            </p>

                        </div>


                        <i class="bi bi-person-vcard"></i>

                    </div>



                    <!-- First Name -->

                    <div class="row mb-3">

                        <div class="col-md-4">

                            <strong>

                                First Name

                            </strong>

                        </div>


                        <div class="col-md-8">

                            <%= dbFirstName %>

                        </div>

                    </div>



                    <!-- Middle Name -->

                    <div class="row mb-3">

                        <div class="col-md-4">

                            <strong>

                                Middle Name

                            </strong>

                        </div>


                        <div class="col-md-8">

                            <%= dbMiddleName.isEmpty()
                                ? "Not provided"
                                : dbMiddleName %>

                        </div>

                    </div>



                    <!-- Last Name -->

                    <div class="row mb-3">

                        <div class="col-md-4">

                            <strong>

                                Last Name

                            </strong>

                        </div>


                        <div class="col-md-8">

                            <%= dbLastName %>

                        </div>

                    </div>



                    <!-- Username -->

                    <div class="row mb-3">

                        <div class="col-md-4">

                            <strong>

                                Username

                            </strong>

                        </div>


                        <div class="col-md-8">

                            <%= dbUsername %>

                        </div>

                    </div>



                    <!-- Email -->

                    <div class="row mb-3">

                        <div class="col-md-4">

                            <strong>

                                Email Address

                            </strong>

                        </div>


                        <div class="col-md-8">

                            <%= dbEmail %>

                        </div>

                    </div>



                    <!-- Role -->

                    <div class="row">

                        <div class="col-md-4">

                            <strong>

                                Account Role

                            </strong>

                        </div>


                        <div class="col-md-8">

                            System Administrator

                        </div>

                    </div>

                </div>

            </div>

        </div>



        <!-- ================================================= -->
        <!-- SECURITY INFORMATION -->
        <!-- ================================================= -->

        <div class="content-card mt-4">


            <div class="card-header-custom">

                <div>

                    <h5>

                        Account Security

                    </h5>


                    <p>

                        Manage your administrator account security.

                    </p>

                </div>


                <i class="bi bi-shield-lock"></i>

            </div>


            <div class="row g-3">


                <div class="col-md-6">

                    <div class="quiz-item">

                        <div class="quiz-icon">

                            <i class="bi bi-key"></i>

                        </div>


                        <div class="quiz-information">

                            <h6>

                                Password

                            </h6>


                            <div class="quiz-meta">

                                Your password is securely stored
                                using password hashing.

                            </div>

                        </div>

                    </div>

                </div>



                <div class="col-md-6">

                    <div class="quiz-item">

                        <div class="quiz-icon">

                            <i class="bi bi-shield-check"></i>

                        </div>


                        <div class="quiz-information">

                            <h6>

                                Account Status

                            </h6>


                            <div class="quiz-meta">

                                Your administrator account is active.

                            </div>

                        </div>

                    </div>

                </div>

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
