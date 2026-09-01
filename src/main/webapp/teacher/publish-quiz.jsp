<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Publish Quiz | UDOM Online Quiz System</title>

<!-- Bootstrap 5.3.3 -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- Bootstrap Icons -->
<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- SAME Dashboard CSS -->
<link rel="stylesheet" href="../css/dashboard.css">

</head>

<body>

<!-- =========================================================
     TOP NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#teacherSidebar">

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

            <span>UDOM</span>

            <small>
                Online Quiz System
            </small>

        </div>

    </a>


    <!-- Right side -->

    <div class="d-flex align-items-center ms-auto">


        <!-- Notification -->

        <button class="notification-btn me-3">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                4
            </span>

        </button>


        <!-- Lecturer profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                data-bs-toggle="dropdown">

                <div class="student-avatar">
                    RO
                </div>


                <div class="student-name d-none d-md-block">

                    <strong>
                        Lecturer
                    </strong>

                    <small>
                        Academic Staff
                    </small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end shadow">

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

<!-- Mobile header -->

<div class="offcanvas-header d-lg-none">

    <h5 class="offcanvas-title">
        Lecturer Menu
    </h5>


    <button
        type="button"
        class="btn-close"
        data-bs-dismiss="offcanvas">

    </button>

</div>



<div class="sidebar-content">


    <!-- Lecturer information -->

    <div class="sidebar-profile">

        <div class="sidebar-avatar">
            RO
        </div>


        <div>

            <h6>
                Lecturer
            </h6>

            <span>
                Academic Staff
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
            class="sidebar-link">

            <i class="bi bi-grid-1x2-fill"></i>

            <span>
                Dashboard
            </span>

        </a>


        <!-- Create Quiz -->

        <a
            href="create-quiz.jsp"
            class="sidebar-link active">

            <i class="bi bi-plus-circle-fill"></i>

            <span>
                Create Quiz
            </span>

        </a>


        <!-- My Quizzes -->

        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-journal-text"></i>

            <span>
                My Quizzes
            </span>

            <span class="menu-badge">
                18
            </span>

        </a>


        <!-- Questions -->

        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-question-circle-fill"></i>

            <span>
                Questions
            </span>

        </a>


        <!-- Results -->

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
                Quiz Reports
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

<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


    <!-- =================================================
         PAGE HEADER
    ================================================== -->

    <div class="welcome-section">

        <div>

            <span class="welcome-label">
                QUIZ MANAGEMENT
            </span>


            <h1>
                Publish Quiz
            </h1>


            <p>
                Your quiz is ready. Review the information below
                before making it available to students.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-send-fill"></i>

        </div>

    </div>



    <!-- =================================================
         PUBLISH CONFIRMATION
    ================================================== -->

    <div class="row justify-content-center">

        <div class="col-xl-8">


            <div class="content-card text-center">


                <!-- Success icon -->

                <div class="mb-4">

                    <div
                        class="mx-auto d-flex align-items-center
                               justify-content-center rounded-circle"
                        style="
                            width: 90px;
                            height: 90px;
                            background: rgba(25, 135, 84, 0.1);
                        ">

                        <i
                            class="bi bi-check-circle-fill text-success"
                            style="font-size: 3.5rem;">
                        </i>

                    </div>

                </div>



                <h2 class="mb-3">
                    Ready to Publish?
                </h2>


                <p class="text-muted mb-4">

                    Your quiz has been reviewed successfully.
                    Once published, students will be able to see
                    and attempt this quiz.

                </p>



                <!-- =================================================
                     QUIZ SUMMARY
                ================================================== -->

                <div class="content-card text-start mb-4">


                    <div class="card-header-custom">

                        <div>

                            <h4>
                                Quiz Summary
                            </h4>

                            <p>
                                Final quiz information
                            </p>

                        </div>


                        <span class="quiz-status">
                            Ready
                        </span>

                    </div>



                    <div class="quiz-item">

                        <div class="quiz-icon">

                            <i class="bi bi-journal-text"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                Quiz Title
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    Database Management Systems
                                </span>

                            </div>

                        </div>

                    </div>



                    <div class="quiz-item">

                        <div class="quiz-icon software-icon">

                            <i class="bi bi-book-fill"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                Course
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    Database Management Systems
                                </span>

                            </div>

                        </div>

                    </div>



                    <div class="quiz-item">

                        <div class="quiz-icon network-icon">

                            <i class="bi bi-clock-fill"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                Duration
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    60 Minutes
                                </span>

                            </div>

                        </div>

                    </div>



                    <div class="quiz-item">

                        <div class="quiz-icon security-icon">

                            <i class="bi bi-list-ol"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                Questions
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    20 Questions
                                </span>

                            </div>

                        </div>

                    </div>



                    <div class="quiz-item">

                        <div class="quiz-icon">

                            <i class="bi bi-percent"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                Pass Mark
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    50%
                                </span>

                            </div>

                        </div>

                    </div>


                </div>



                <!-- =================================================
                     IMPORTANT WARNING
                ================================================== -->

                <div class="alert alert-warning text-start">


                    <i class="bi bi-exclamation-triangle-fill me-2"></i>


                    <strong>
                        Important:
                    </strong>


                    After publishing, students will be able to
                    access and attempt this quiz. Make sure all
                    questions and answers are correct before
                    publishing.

                </div>



                <!-- =================================================
                     ACTION BUTTONS
                ================================================== -->

                <div
                    class="d-flex justify-content-center
                           flex-wrap gap-2 mt-4">


                    <a
                        href="review-quiz.jsp"
                        class="btn btn-outline-secondary">

                        <i class="bi bi-arrow-left me-1"></i>

                        Back to Review

                    </a>


                    <button
                        type="button"
                        class="btn btn-outline-primary">

                        <i class="bi bi-save me-1"></i>

                        Save as Draft

                    </button>


                    <button
                        type="button"
                        class="btn btn-success"
                        data-bs-toggle="modal"
                        data-bs-target="#publishModal">

                        <i class="bi bi-send-fill me-1"></i>

                        Publish Quiz

                    </button>

                </div>


            </div>

        </div>

    </div>



    <!-- =================================================
         FOOTER
    ================================================== -->

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

<!-- =========================================================
     PUBLISH CONFIRMATION MODAL
========================================================= -->

<div
    class="modal fade"
    id="publishModal"
    tabindex="-1"
    aria-hidden="true">

<div class="modal-dialog modal-dialog-centered">


    <div class="modal-content">


        <div class="modal-header">

            <h5 class="modal-title">

                <i class="bi bi-send-fill me-2"></i>

                Publish Quiz

            </h5>


            <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal">

            </button>

        </div>



        <div class="modal-body text-center py-4">


            <i
                class="bi bi-question-circle-fill text-primary"
                style="font-size: 3rem;">
            </i>


            <h5 class="mt-3">

                Are you sure you want to publish this quiz?

            </h5>


            <p class="text-muted mb-0">

                Students will be able to access and attempt
                the quiz after it is published.

            </p>

        </div>



        <div class="modal-footer">


            <button
                type="button"
                class="btn btn-outline-secondary"
                data-bs-dismiss="modal">

                Cancel

            </button>


            <a
                href="dashboard.jsp"
                class="btn btn-success">

                <i class="bi bi-send-fill me-1"></i>

                Confirm Publish

            </a>

        </div>


    </div>

</div>

</div>

<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
