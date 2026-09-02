<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String quizIdValue =
            request.getParameter("quizId");
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Attempt Already Completed - UDOM Online Quiz System
    </title>


    <!-- Bootstrap -->

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


        <div class="d-flex align-items-center ms-auto">


            <button
                class="notification-btn me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    3
                </span>

            </button>


            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        RO
                    </div>


                    <div class="student-name d-none d-md-block">

                        <strong>
                            Student
                        </strong>

                        <small>
                            Student Account
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
                            href="../login.jsp">

                            <i
                                class="bi bi-box-arrow-right me-2">
                            </i>

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
            Student Menu
        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="sidebar-content">


        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                RO
            </div>


            <div>

                <h6>
                    Student
                </h6>

                <span>
                    Student Account
                </span>

            </div>

        </div>


        <div class="sidebar-menu">


            <p class="menu-title">
                MAIN MENU
            </p>


            <a
                href="dashboard.jsp"
                class="sidebar-link active">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person-fill"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear-fill"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>


        <div class="sidebar-bottom">

            <a
                href="../login.jsp"
                class="logout-link">

                <i class="bi bi-box-arrow-left"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>



<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <div class="welcome-section">

            <div>

                <h1>
                    Attempt Already Completed
                </h1>

                <p>
                    This quiz allows only one attempt.
                </p>

            </div>


            <div class="welcome-icon">

                <i class="bi bi-shield-check"></i>

            </div>

        </div>



        <!-- MESSAGE -->

        <div class="content-card">

            <div class="card-body p-5 text-center">


                <div class="mb-4">

                    <i
                        class="bi bi-check-circle-fill text-success"
                        style="font-size: 5rem;">
                    </i>

                </div>


                <h3 class="fw-bold mb-3">

                    Quiz Already Submitted

                </h3>


                <p class="text-muted mb-4">

                    You have already completed this quiz.
                    Each student is allowed only one attempt,
                    so you cannot take this quiz again.

                </p>


                <div class="alert alert-warning text-start">

                    <i
                        class="bi bi-exclamation-triangle-fill me-2">
                    </i>

                    <strong>
                        One Attempt Policy:
                    </strong>

                    Your previous submission has already been
                    recorded and evaluated.

                </div>


                <div class="d-flex justify-content-center gap-2 mt-4">

                    <a
                        href="quiz-result.jsp"
                        class="btn btn-primary">

                        <i class="bi bi-bar-chart-fill me-1"></i>

                        View My Result

                    </a>


                    <a
                        href="dashboard.jsp"
                        class="btn btn-outline-secondary">

                        <i class="bi bi-grid-1x2-fill me-1"></i>

                        Back to Dashboard

                    </a>

                </div>

            </div>

        </div>



        <!-- FOOTER -->

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

    </div>

</main>



<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>