<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>  
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Review Quiz | UDOM Online Quiz System</title>

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
                Review Quiz
            </h1>


            <p>
                Review all quiz information and questions before
                publishing the assessment.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-clipboard-check-fill"></i>

        </div>

    </div>



    <!-- =================================================
         QUIZ INFORMATION
    ================================================== -->

    <div class="content-card mb-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    Database Management Systems
                </h4>

                <p>
                    Introduction to Database Concepts
                </p>

            </div>


            <span class="quiz-status">
                Draft
            </span>

        </div>


        <div class="row g-3 mt-2">


            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon">

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

            </div>



            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

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

            </div>



            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon network-icon">

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

            </div>



            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

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


        </div>

    </div>



    <!-- =================================================
         DESCRIPTION
    ================================================== -->

    <div class="content-card mb-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Description
                </h4>

                <p>
                    Description students will see before starting.
                </p>

            </div>

        </div>


        <p class="mb-0">

            This quiz evaluates students' understanding of
            database management systems, including database
            concepts, SQL, normalization, keys and relationships.

        </p>


    </div>



    <!-- =================================================
         QUESTIONS
    ================================================== -->

    <div class="content-card">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Questions
                </h4>

                <p>
                    Review each question and its correct answer.
                </p>

            </div>


            <span class="quiz-status">
                20 Questions
            </span>

        </div>



        <!-- =================================================
             QUESTION 1
        ================================================== -->

        <div class="quiz-item mb-4">


            <div class="quiz-icon">

                <i class="bi bi-1-circle-fill"></i>

            </div>


            <div class="quiz-information w-100">

                <h5>
                    Question 1
                </h5>


                <p class="mt-2 mb-3">

                    What is a database?

                </p>


                <div class="row g-2">


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                A.
                            </strong>

                            Collection of related data

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                B.
                            </strong>

                            A computer program

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                C.
                            </strong>

                            An operating system

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                D.
                            </strong>

                            A computer network

                        </div>

                    </div>

                </div>


                <div class="alert alert-success mt-3 mb-0">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <strong>
                        Correct Answer:
                    </strong>

                    A. Collection of related data

                </div>

            </div>

        </div>



        <!-- =================================================
             QUESTION 2
        ================================================== -->

        <div class="quiz-item mb-4">


            <div class="quiz-icon software-icon">

                <i class="bi bi-2-circle-fill"></i>

            </div>


            <div class="quiz-information w-100">

                <h5>
                    Question 2
                </h5>


                <p class="mt-2 mb-3">

                    Which key uniquely identifies a record
                    in a database table?

                </p>


                <div class="row g-2">


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                A.
                            </strong>

                            Foreign Key

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                B.
                            </strong>

                            Primary Key

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                C.
                            </strong>

                            Alternate Key

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                D.
                            </strong>

                            Composite Key

                        </div>

                    </div>

                </div>


                <div class="alert alert-success mt-3 mb-0">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <strong>
                        Correct Answer:
                    </strong>

                    B. Primary Key

                </div>

            </div>

        </div>



        <!-- =================================================
             QUESTION 3
        ================================================== -->

        <div class="quiz-item mb-4">


            <div class="quiz-icon network-icon">

                <i class="bi bi-3-circle-fill"></i>

            </div>


            <div class="quiz-information w-100">

                <h5>
                    Question 3
                </h5>


                <p class="mt-2 mb-3">

                    What language is commonly used to
                    communicate with relational databases?

                </p>


                <div class="row g-2">


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                A.
                            </strong>

                            HTML

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                B.
                            </strong>

                            CSS

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                C.
                            </strong>

                            SQL

                        </div>

                    </div>


                    <div class="col-md-6">

                        <div class="border rounded p-3">

                            <strong>
                                D.
                            </strong>

                            XML

                        </div>

                    </div>

                </div>


                <div class="alert alert-success mt-3 mb-0">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <strong>
                        Correct Answer:
                    </strong>

                    C. SQL

                </div>

            </div>

        </div>



        <!-- =================================================
             MORE QUESTIONS
        ================================================== -->

        <div class="text-center py-3">

            <span class="text-muted">

                <i class="bi bi-three-dots me-2"></i>

                More questions will appear here...

            </span>

        </div>



        <!-- =================================================
             ACTIONS
        ================================================== -->

        <div
            class="d-flex justify-content-between align-items-center
                   border-top pt-4 mt-3">


            <a
                href="add-questions.jsp"
                class="btn btn-outline-secondary">

                <i class="bi bi-arrow-left me-1"></i>

                Edit Questions

            </a>


            <div class="d-flex gap-2">


                <button
                    type="button"
                    class="btn btn-outline-primary">

                    <i class="bi bi-save me-1"></i>

                    Save Draft

                </button>


                <a
                    href="publish-quiz.jsp"
                    class="btn btn-primary">

                    Publish Quiz

                    <i class="bi bi-send-fill ms-1"></i>

                </a>


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

<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
