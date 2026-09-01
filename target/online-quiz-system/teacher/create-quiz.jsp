<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Create Quiz | UDOM Online Quiz System</title>

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



        <!-- Create Quiz - ACTIVE -->

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

<!-- =====================================================
     PAGE HEADER
====================================================== -->

<div class="welcome-section">


    <div>


        <span class="welcome-label">

            QUIZ MANAGEMENT

        </span>


        <h1>

            Create New Quiz

        </h1>


        <p>

            Create a new online assessment and prepare questions
            for your students.

        </p>


    </div>


    <div class="welcome-icon">

        <i class="bi bi-plus-circle-fill"></i>

    </div>


</div>



<!-- =====================================================
     QUIZ INFORMATION
====================================================== -->

<div class="row g-4">


    <!-- LEFT SIDE -->

    <div class="col-xl-8">


        <div class="content-card">


            <div class="card-header-custom">


                <div>

                    <h4>
                        Quiz Information
                    </h4>

                    <p>

                        Enter the basic information for the new quiz.

                    </p>

                </div>


            </div>



            <!-- FORM -->

            <form
                action="../createQuiz"
                method="post">


                <!-- Quiz title -->

                <div class="mb-3">


                    <label
                        for="quizTitle"
                        class="form-label">

                        Quiz Title

                        <span class="text-danger">
                            *
                        </span>

                    </label>


                    <input
                        type="text"
                        class="form-control"
                        id="quizTitle"
                        name="quizTitle"
                        placeholder="Enter quiz title"
                        required>


                </div>



                <!-- Course -->

                <div class="mb-3">


                    <label
                        for="course"
                        class="form-label">

                        Course

                        <span class="text-danger">
                            *
                        </span>

                    </label>


                    <select
                        class="form-select"
                        id="course"
                        name="course"
                        required>


                        <option
                            value=""
                            selected
                            disabled>

                            Select Course

                        </option>


                        <option value="Database Management Systems">

                            Database Management Systems

                        </option>


                        <option value="Computer Security">

                            Computer Security

                        </option>


                        <option value="Software Engineering">

                            Software Engineering

                        </option>


                        <option value="Computer Networks">

                            Computer Networks

                        </option>


                    </select>


                </div>



                <!-- Description -->

                <div class="mb-3">


                    <label
                        for="description"
                        class="form-label">

                        Quiz Description

                        <span class="text-danger">
                            *
                        </span>

                    </label>


                    <textarea
                        class="form-control"
                        id="description"
                        name="description"
                        rows="4"
                        placeholder="Enter a short description of this quiz"
                        required></textarea>


                </div>



                <!-- SETTINGS -->

                <div class="row g-3">


                    <!-- Duration -->

                    <div class="col-md-4">


                        <label
                            for="duration"
                            class="form-label">

                            Duration

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">


                            <input
                                type="number"
                                class="form-control"
                                id="duration"
                                name="duration"
                                min="1"
                                placeholder="60"
                                required>


                            <span class="input-group-text">

                                Min

                            </span>


                        </div>

                    </div>



                    <!-- Questions -->

                    <div class="col-md-4">


                        <label
                            for="questionCount"
                            class="form-label">

                            Questions

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <input
                            type="number"
                            class="form-control"
                            id="questionCount"
                            name="questionCount"
                            min="1"
                            placeholder="20"
                            required>


                    </div>



                    <!-- Pass mark -->

                    <div class="col-md-4">


                        <label
                            for="passMark"
                            class="form-label">

                            Pass Mark

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">


                            <input
                                type="number"
                                class="form-control"
                                id="passMark"
                                name="passMark"
                                min="1"
                                max="100"
                                placeholder="50"
                                required>


                            <span class="input-group-text">

                                %

                            </span>


                        </div>

                    </div>


                </div>



                <!-- BUTTONS -->

                <div
                    class="d-flex justify-content-end gap-2 mt-4">


                    <a
                        href="dashboard.jsp"
                        class="btn btn-outline-secondary">

                        <i class="bi bi-x-circle me-1"></i>

                        Cancel

                    </a>


                    <button
                        type="submit"
                        name="action"
                        value="draft"
                        class="btn btn-outline-primary">

                        <i class="bi bi-save me-1"></i>

                        Save Draft

                    </button>


                    <button
                        type="submit"
                        name="action"
                        value="continue"
                        class="btn btn-primary">

                        Continue

                        <i class="bi bi-arrow-right ms-1"></i>

                    </button>


                </div>


            </form>


        </div>


    </div>



    <!-- =================================================
         RIGHT SIDE
    ================================================== -->

    <div class="col-xl-4">


        <!-- Creation guide -->

        <div class="content-card">


            <div class="card-header-custom">


                <div>

                    <h4>
                        Quiz Creation
                    </h4>

                    <p>
                        Follow these steps to create your quiz.
                    </p>

                </div>


            </div>



            <!-- Step 1 -->

            <div class="quiz-item">


                <div class="quiz-icon">

                    <i class="bi bi-info-circle-fill"></i>

                </div>


                <div class="quiz-information">

                    <h5>
                        Quiz Information
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Basic quiz details
                        </span>

                    </div>

                </div>


            </div>



            <!-- Step 2 -->

            <div class="quiz-item">


                <div class="quiz-icon software-icon">

                    <i class="bi bi-question-circle-fill"></i>

                </div>


                <div class="quiz-information">

                    <h5>
                        Add Questions
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Create quiz questions
                        </span>

                    </div>

                </div>


            </div>



            <!-- Step 3 -->

            <div class="quiz-item">


                <div class="quiz-icon network-icon">

                    <i class="bi bi-check-circle-fill"></i>

                </div>


                <div class="quiz-information">

                    <h5>
                        Review & Publish
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Review and publish
                        </span>

                    </div>

                </div>


            </div>


        </div>



        <!-- Important information -->

        <div class="content-card mt-4">


            <div class="card-header-custom">


                <div>

                    <h4>
                        Important
                    </h4>

                    <p>
                        Before continuing
                    </p>

                </div>


            </div>


            <div class="quiz-item">


                <div class="quiz-icon security-icon">

                    <i class="bi bi-clock-fill"></i>

                </div>


                <div class="quiz-information">


                    <h5>
                        Quiz Duration
                    </h5>


                    <div class="quiz-meta">

                        <span>
                            Set the time students have to complete the quiz.
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
                            Set the minimum percentage required to pass.
                        </span>

                    </div>


                </div>


            </div>


        </div>


    </div>


</div>



<!-- =====================================================
     FOOTER
====================================================== -->

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
     BOOTSTRAP JAVASCRIPT
========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
