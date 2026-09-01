<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Lecturer Dashboard | UDOM Online Quiz System</title>

<!-- Bootstrap 5.3.3 -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- Bootstrap Icons -->
<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Dashboard CSS -->
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

    <a class="navbar-brand d-flex align-items-center" href="#">

        <div class="brand-icon">
            <i class="bi bi-mortarboard-fill"></i>
        </div>

        <div class="brand-text">

            <span>UDOM</span>

            <small>Online Quiz System</small>

        </div>

    </a>


    <!-- Right side -->

    <div class="d-flex align-items-center ms-auto">

        <!-- Notification -->

        <button class="notification-btn me-3">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">4</span>

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

                    <strong>Lecturer</strong>

                    <small>Academic Staff</small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end shadow">

                <li>

                    <a class="dropdown-item" href="#">

                        <i class="bi bi-person me-2"></i>

                        My Profile

                    </a>

                </li>


                <li>

                    <a class="dropdown-item" href="#">

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

            <h6>Lecturer</h6>

            <span>Academic Staff</span>

        </div>

    </div>


    <!-- Navigation -->

    <div class="sidebar-menu">


        <p class="menu-title">

            MAIN MENU

        </p>


        <!-- Dashboard -->

        <a href="#" class="sidebar-link active">

            <i class="bi bi-grid-1x2-fill"></i>

            <span>Dashboard</span>

        </a>

        <!-- Create Quiz -->

        <a href="create-quiz.jsp" class="sidebar-link">

            <i class="bi bi-plus-circle-fill"></i>

            <span>Create Quiz</span>

        </a>


        <!-- My Quizzes -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-journal-text"></i>

            <span>My Quizzes</span>

            <span class="menu-badge">18</span>

        </a>


        <!-- Questions -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-question-circle-fill"></i>

            <span>Questions</span>

        </a>


        <!-- Results -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>Student Results</span>

        </a>


        <!-- Reports -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-file-earmark-bar-graph-fill"></i>

            <span>Quiz Reports</span>

        </a>


        <p class="menu-title mt-4">

            ACCOUNT

        </p>


        <!-- Profile -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-person-fill"></i>

            <span>My Profile</span>

        </a>


        <!-- Settings -->

        <a href="#" class="sidebar-link">

            <i class="bi bi-gear-fill"></i>

            <span>Settings</span>

        </a>


    </div>


    <!-- Logout -->

    <div class="sidebar-bottom">

        <a href="../login.jsp" class="logout-link">

            <i class="bi bi-box-arrow-left"></i>

            <span>Logout</span>

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
         WELCOME
    ================================================== -->

    <div class="welcome-section">


        <div>

            <span class="welcome-label">

                LECTURER DASHBOARD

            </span>


            <h1>

                Welcome, Lecturer! 👋

            </h1>


            <p>

                Manage your quizzes, create assessments,
                monitor student performance and view quiz reports.

            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-person-workspace"></i>

        </div>

    </div>


    <!-- =================================================
         STATISTICS
    ================================================== -->

    <div class="row g-4 mb-4">


        <!-- Total quizzes -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">


                <div class="stat-icon icon-blue">

                    <i class="bi bi-journal-text"></i>

                </div>


                <div>

                    <span>Total Quizzes</span>

                    <h2>18</h2>

                    <small>

                        <i class="bi bi-arrow-up"></i>

                        3 created this month

                    </small>

                </div>

            </div>

        </div>


        <!-- Published -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">


                <div class="stat-icon icon-green">

                    <i class="bi bi-check-circle-fill"></i>

                </div>


                <div>

                    <span>Published Quizzes</span>

                    <h2>14</h2>

                    <small>

                        <i class="bi bi-check2"></i>

                        Currently active

                    </small>

                </div>

            </div>

        </div>


        <!-- Draft -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">


                <div class="stat-icon icon-orange">

                    <i class="bi bi-pencil-square"></i>

                </div>


                <div>

                    <span>Draft Quizzes</span>

                    <h2>4</h2>

                    <small>

                        <i class="bi bi-clock"></i>

                        Awaiting publication

                    </small>

                </div>

            </div>

        </div>


        <!-- Students -->

        <div class="col-xl-3 col-md-6">

            <div class="stat-card">


                <div class="stat-icon icon-purple">

                    <i class="bi bi-people-fill"></i>

                </div>


                <div>

                    <span>Students Attempted</span>

                    <h2>642</h2>

                    <small>

                        <i class="bi bi-arrow-up"></i>

                        8% this month

                    </small>

                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         MAIN ROW
    ================================================== -->

    <div class="row g-4">


        <!-- My quizzes -->

        <div class="col-xl-8">


            <div class="content-card">


                <div class="card-header-custom">


                    <div>

                        <h4>My Quizzes</h4>

                        <p>

                            Manage your recently created quizzes

                        </p>

                    </div>


                    <a href="#">

                        View All

                        <i class="bi bi-arrow-right"></i>

                    </a>

                </div>


                <!-- Quiz 1 -->

                <div class="quiz-item">


                    <div class="quiz-icon">

                        <i class="bi bi-database-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>

                            Database Management Systems

                        </h5>


                        <div class="quiz-meta">

                            <span>

                                <i class="bi bi-question-circle"></i>

                                20 Questions

                            </span>


                            <span>

                                <i class="bi bi-people"></i>

                                126 Attempts

                            </span>


                            <span>

                                <i class="bi bi-calendar3"></i>

                                30 Aug 2026

                            </span>

                        </div>

                    </div>


                    <div class="quiz-action">


                        <span class="quiz-status">

                            Published

                        </span>


                        <button class="btn start-quiz-btn">

                            Manage

                            <i class="bi bi-arrow-right"></i>

                        </button>

                    </div>

                </div>


                <!-- Quiz 2 -->

                <div class="quiz-item">


                    <div class="quiz-icon security-icon">

                        <i class="bi bi-shield-lock-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>

                            Computer Security

                        </h5>


                        <div class="quiz-meta">

                            <span>

                                <i class="bi bi-question-circle"></i>

                                25 Questions

                            </span>


                            <span>

                                <i class="bi bi-people"></i>

                                184 Attempts

                            </span>


                            <span>

                                <i class="bi bi-calendar3"></i>

                                28 Aug 2026

                            </span>

                        </div>

                    </div>


                    <div class="quiz-action">


                        <span class="quiz-status">

                            Published

                        </span>


                        <button class="btn start-quiz-btn">

                            Manage

                            <i class="bi bi-arrow-right"></i>

                        </button>

                    </div>

                </div>


                <!-- Quiz 3 -->

                <div class="quiz-item">


                    <div class="quiz-icon software-icon">

                        <i class="bi bi-code-slash"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>

                            Software Engineering

                        </h5>


                        <div class="quiz-meta">

                            <span>

                                <i class="bi bi-question-circle"></i>

                                30 Questions

                            </span>


                            <span>

                                <i class="bi bi-people"></i>

                                205 Attempts

                            </span>


                            <span>

                                <i class="bi bi-calendar3"></i>

                                25 Aug 2026

                            </span>

                        </div>

                    </div>


                    <div class="quiz-action">


                        <span class="quiz-status">

                            Published

                        </span>


                        <button class="btn start-quiz-btn">

                            Manage

                            <i class="bi bi-arrow-right"></i>

                        </button>

                    </div>

                </div>


                <!-- Quiz 4 -->

                <div class="quiz-item">


                    <div class="quiz-icon network-icon">

                        <i class="bi bi-diagram-3-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>

                            Computer Networks

                        </h5>


                        <div class="quiz-meta">

                            <span>

                                <i class="bi bi-question-circle"></i>

                                20 Questions

                            </span>


                            <span>

                                <i class="bi bi-people"></i>

                                127 Attempts

                            </span>


                            <span>

                                <i class="bi bi-calendar3"></i>

                                22 Aug 2026

                            </span>

                        </div>

                    </div>


                    <div class="quiz-action">


                        <span
                            class="quiz-status"
                            style="color:#d97706;">

                            Draft

                        </span>


                        <button class="btn start-quiz-btn">

                            Edit

                            <i class="bi bi-pencil"></i>

                        </button>

                    </div>

                </div>


            </div>

        </div>


        <!-- Quick actions -->

        <div class="col-xl-4">


            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>Quick Actions</h4>

                        <p>

                            Frequently used lecturer tools

                        </p>

                    </div>

                </div>

                <!-- Create quiz -->

                <a href="create-quiz.jsp" class="quick-action">

                    <div class="quick-action-icon icon-blue">

                        <i class="bi bi-plus-circle-fill"></i>

                    </div>

                    <div>

                        <h6>Create New Quiz</h6>

                        <span>
                            Create a new assessment
                        </span>

                    </div>

                    <i class="bi bi-chevron-right ms-auto"></i>

                </a>


                <!-- Questions -->

                <a href="#" class="quick-action">

                    <div class="quick-action-icon icon-purple">

                        <i class="bi bi-question-circle-fill"></i>

                    </div>


                    <div>

                        <h6>Manage Questions</h6>

                        <span>

                            Add or edit quiz questions

                        </span>

                    </div>


                    <i class="bi bi-chevron-right ms-auto"></i>

                </a>


                <!-- Results -->

                <a href="#" class="quick-action">

                    <div class="quick-action-icon icon-green">

                        <i class="bi bi-bar-chart-fill"></i>

                    </div>


                    <div>

                        <h6>View Student Results</h6>

                        <span>

                            Monitor student performance

                        </span>

                    </div>


                    <i class="bi bi-chevron-right ms-auto"></i>

                </a>


                <!-- Reports -->

                <a href="#" class="quick-action">

                    <div class="quick-action-icon icon-orange">

                        <i class="bi bi-file-earmark-bar-graph-fill"></i>

                    </div>


                    <div>

                        <h6>Generate Report</h6>

                        <span>

                            Generate quiz performance reports

                        </span>

                    </div>


                    <i class="bi bi-chevron-right ms-auto"></i>

                </a>


            </div>


            <!-- Performance -->

            <div class="content-card mt-4">


                <div class="card-header-custom">

                    <div>

                        <h4>Average Performance</h4>

                        <p>

                            Student performance across quizzes

                        </p>

                    </div>

                </div>


                <div class="performance-circle">

                    <div class="circle-inner">

                        <strong>76%</strong>

                        <span>Average Score</span>

                    </div>

                </div>


                <div class="performance-info">


                    <div>

                        <span>Highest</span>

                        <strong>94%</strong>

                    </div>


                    <div>

                        <span>Lowest</span>

                        <strong>51%</strong>

                    </div>


                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         RECENT STUDENT RESULTS
    ================================================== -->

    <div class="content-card mt-4">


        <div class="card-header-custom">


            <div>

                <h4>Recent Student Results</h4>

                <p>

                    Latest quiz submissions from students

                </p>

            </div>


            <a href="#">

                View All

                <i class="bi bi-arrow-right"></i>

            </a>

        </div>


        <div class="table-responsive">


            <table class="table result-table align-middle">


                <thead>

                    <tr>

                        <th>Student</th>

                        <th>Quiz</th>

                        <th>Date</th>

                        <th>Score</th>

                        <th>Percentage</th>

                        <th>Result</th>

                        <th></th>

                    </tr>

                </thead>


                <tbody>


                    <tr>

                        <td>

                            <strong>

                                Student One

                            </strong>

                        </td>


                        <td>

                            Database Systems

                        </td>


                        <td>

                            30 Aug 2026

                        </td>


                        <td>

                            <strong>18 / 20</strong>

                        </td>


                        <td>

                            <strong>90%</strong>

                        </td>


                        <td>

                            <span class="result-pass">

                                Passed

                            </span>

                        </td>


                        <td>

                            <button class="btn result-btn">

                                View

                            </button>

                        </td>

                    </tr>


                    <tr>

                        <td>

                            <strong>

                                Student Two

                            </strong>

                        </td>


                        <td>

                            Computer Security

                        </td>


                        <td>

                            29 Aug 2026

                        </td>


                        <td>

                            <strong>21 / 25</strong>

                        </td>


                        <td>

                            <strong>84%</strong>

                        </td>


                        <td>

                            <span class="result-pass">

                                Passed

                            </span>

                        </td>


                        <td>

                            <button class="btn result-btn">

                                View

                            </button>

                        </td>

                    </tr>


                    <tr>

                        <td>

                            <strong>

                                Student Three

                            </strong>

                        </td>


                        <td>

                            Software Engineering

                        </td>


                        <td>

                            28 Aug 2026

                        </td>


                        <td>

                            <strong>14 / 30</strong>

                        </td>


                        <td>

                            <strong>47%</strong>

                        </td>


                        <td>

                            <span class="result-warning">

                                Failed

                            </span>

                        </td>


                        <td>

                            <button class="btn result-btn">

                                View

                            </button>

                        </td>

                    </tr>


                </tbody>

            </table>

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

            <a href="#">Help</a>

            <a href="#">Privacy</a>

            <a href="#">Support</a>

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
