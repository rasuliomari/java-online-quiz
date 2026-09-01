<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Add Questions | UDOM Online Quiz System</title>

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
                Add Questions
            </h1>

            <p>
                Create questions and define the correct answers
                for your quiz.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-question-circle-fill"></i>

        </div>

    </div>



    <!-- =================================================
         QUIZ PROGRESS
    ================================================== -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>
                    Database Management Systems
                </h4>

                <p>
                    Add questions for this quiz.
                </p>

            </div>


            <div class="quiz-status">

                <span>
                    Question 1
                </span>

            </div>

        </div>

    </div>



    <!-- =================================================
         QUESTION FORM
    ================================================== -->

    <div class="row g-4">


        <!-- LEFT SIDE -->

        <div class="col-xl-8">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Question 1
                        </h4>

                        <p>
                            Enter the question and its answers.
                        </p>

                    </div>


                    <div class="quiz-icon">

                        <i class="bi bi-question-lg"></i>

                    </div>

                </div>



                <form action="../saveQuestion" method="post">


                    <!-- Question -->

                    <div class="mb-4">

                        <label
                            for="questionText"
                            class="form-label">

                            Question

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <textarea
                            class="form-control"
                            id="questionText"
                            name="questionText"
                            rows="4"
                            placeholder="Enter your question here..."
                            required></textarea>

                    </div>



                    <!-- Answer A -->

                    <div class="mb-3">

                        <label
                            for="answerA"
                            class="form-label">

                            Answer A

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                A
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerA"
                                name="answerA"
                                placeholder="Enter answer A"
                                required>

                        </div>

                    </div>



                    <!-- Answer B -->

                    <div class="mb-3">

                        <label
                            for="answerB"
                            class="form-label">

                            Answer B

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                B
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerB"
                                name="answerB"
                                placeholder="Enter answer B"
                                required>

                        </div>

                    </div>



                    <!-- Answer C -->

                    <div class="mb-3">

                        <label
                            for="answerC"
                            class="form-label">

                            Answer C

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                C
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerC"
                                name="answerC"
                                placeholder="Enter answer C"
                                required>

                        </div>

                    </div>



                    <!-- Answer D -->

                    <div class="mb-4">

                        <label
                            for="answerD"
                            class="form-label">

                            Answer D

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                D
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerD"
                                name="answerD"
                                placeholder="Enter answer D"
                                required>

                        </div>

                    </div>



                    <!-- Correct answer -->

                    <div class="mb-4">

                        <label
                            for="correctAnswer"
                            class="form-label">

                            Correct Answer

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <select
                            class="form-select"
                            id="correctAnswer"
                            name="correctAnswer"
                            required>

                            <option
                                value=""
                                selected
                                disabled>

                                Select the correct answer

                            </option>

                            <option value="A">
                                Answer A
                            </option>

                            <option value="B">
                                Answer B
                            </option>

                            <option value="C">
                                Answer C
                            </option>

                            <option value="D">
                                Answer D
                            </option>

                        </select>

                    </div>



                    <!-- Buttons -->

                    <div
                        class="d-flex justify-content-between align-items-center mt-4">


                        <a
                            href="create-quiz.jsp"
                            class="btn btn-outline-secondary">

                            <i class="bi bi-arrow-left me-1"></i>

                            Back

                        </a>


                        <div class="d-flex gap-2">

                            <button
                                type="submit"
                                name="action"
                                value="add"
                                class="btn btn-outline-primary">

                                <i class="bi bi-plus-circle me-1"></i>

                                Add Question

                            </button>


                            <button
                                type="submit"
                                name="action"
                                value="review"
                                class="btn btn-primary">

                                <!-- Review Quiz -->
                                <a href="review-quiz.jsp"
                                    class="btn btn-primary">

                                     Review Quiz

                                     <i class="bi bi-arrow-right ms-1"></i>

                                </a>

                                <i class="bi bi-arrow-right ms-1"></i>

                            </button>

                        </div>

                    </div>


                </form>

            </div>

        </div>



        <!-- =================================================
             RIGHT SIDE
        ================================================== -->

        <div class="col-xl-4">


            <!-- Quiz summary -->

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Quiz Summary
                        </h4>

                        <p>
                            Current quiz information.
                        </p>

                    </div>

                </div>


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
                                1 of 20
                            </span>

                        </div>

                    </div>

                </div>



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



            <!-- Instructions -->

            <div class="content-card mt-4">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Instructions
                        </h4>

                        <p>
                            Before adding questions
                        </p>

                    </div>

                </div>


                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-lightbulb-fill"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Write Clear Questions
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                Make each question simple and easy
                                for students to understand.
                            </span>

                        </div>

                    </div>

                </div>


                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-check-circle-fill"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Select Correct Answer
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                Always select one correct answer
                                before continuing.
                            </span>

                        </div>

                    </div>

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

<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
