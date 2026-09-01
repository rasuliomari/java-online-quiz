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
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Dashboard CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">

    <style>
        .page-header {
            margin-bottom: 24px;
        }

        .page-header h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .page-header p {
            color: var(--text-muted);
            font-size: 13px;
            margin: 0;
        }

        .breadcrumb {
            font-size: 12px;
            margin-bottom: 8px;
        }

        .breadcrumb-item a {
            color: var(--udom-secondary);
            text-decoration: none;
        }

        .quiz-form-card {
            background: var(--white);
            border: 1px solid var(--border-color);
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .form-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .form-header-icon {
            width: 44px;
            height: 44px;
            border-radius: 11px;
            background: #eaf3ff;
            color: var(--udom-secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
        }

        .form-card-header h5 {
            margin: 0;
            font-size: 15px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .form-card-header p {
            margin: 3px 0 0;
            font-size: 11px;
            color: var(--text-muted);
        }

        .form-card-body {
            padding: 25px;
        }

        .form-label {
            font-size: 12px;
            font-weight: 650;
            color: var(--text-dark);
            margin-bottom: 7px;
        }

        .form-control,
        .form-select {
            min-height: 44px;
            border: 1px solid #dfe4ea;
            border-radius: 9px;
            font-size: 13px;
            padding: 10px 13px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--udom-secondary);
            box-shadow: 0 0 0 3px rgba(0, 86, 166, 0.10);
        }

        textarea.form-control {
            min-height: 110px;
            resize: vertical;
        }

        .input-group-text {
            background: #f7f9fc;
            border-color: #dfe4ea;
            color: var(--text-muted);
            font-size: 13px;
        }

        .form-section {
            margin-bottom: 25px;
        }

        .form-section-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-dark);
            padding-bottom: 10px;
            margin-bottom: 18px;
            border-bottom: 1px solid #edf0f3;
        }

        .form-section-title i {
            color: var(--udom-secondary);
            margin-right: 7px;
        }

        .required {
            color: #dc3545;
        }

        .form-help {
            display: block;
            margin-top: 5px;
            font-size: 10px;
            color: var(--text-muted);
        }

        .step-indicator {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            overflow-x: auto;
        }

        .step {
            display: flex;
            align-items: center;
            white-space: nowrap;
        }

        .step-number {
            width: 29px;
            height: 29px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            background: #e9eef5;
            color: #7b8794;
        }

        .step.active .step-number {
            background: var(--udom-secondary);
            color: white;
        }

        .step-label {
            margin-left: 7px;
            font-size: 11px;
            color: #7b8794;
            font-weight: 600;
        }

        .step.active .step-label {
            color: var(--udom-secondary);
        }

        .step-line {
            width: 45px;
            height: 1px;
            background: #dfe4ea;
            margin: 0 12px;
        }

        .form-actions {
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            gap: 12px;
        }

        .btn-draft {
            border: 1px solid #d9dee5;
            background: white;
            color: var(--text-dark);
            border-radius: 8px;
            padding: 10px 17px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-draft:hover {
            background: #f7f9fc;
        }

        .btn-continue {
            background: var(--udom-secondary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-continue:hover {
            background: var(--udom-primary);
            color: white;
        }

        @media (max-width: 576px) {
            .form-card-body {
                padding: 18px;
            }

            .form-card-header {
                padding: 18px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-draft,
            .btn-continue {
                width: 100%;
            }

            .step-line {
                width: 20px;
                margin: 0 7px;
            }
        }
    </style>
</head>

<body>

<!-- =========================
     TOP NAVBAR
========================= -->
<nav class="navbar navbar-expand-lg dashboard-navbar">

    <div class="container-fluid">

        <!-- Mobile Sidebar Button -->
        <button
            class="btn d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#teacherSidebar">

            <i class="bi bi-list fs-4"></i>

        </button>

        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center"
           href="${pageContext.request.contextPath}/teacher/dashboard.jsp">

            <div class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </div>

            <div class="brand-text">
                <strong>UDOM</strong>
                <span>Online Quiz System</span>
            </div>

        </a>

        <!-- Right Side -->
        <div class="d-flex align-items-center ms-auto">

            <!-- Notifications -->
            <button class="btn notification-button position-relative me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">3</span>

            </button>

            <!-- Profile -->
            <div class="dropdown">

                <button
                    class="btn profile-button dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        L
                    </div>

                    <div class="profile-info d-none d-md-block">
                        <strong>Lecturer</strong>
                        <small>Teacher</small>
                    </div>

                </button>

                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a class="dropdown-item"
                           href="${pageContext.request.contextPath}/teacher/profile.jsp">

                            <i class="bi bi-person me-2"></i>
                            My Profile

                        </a>
                    </li>

                    <li>
                        <a class="dropdown-item"
                           href="${pageContext.request.contextPath}/teacher/settings.jsp">

                            <i class="bi bi-gear me-2"></i>
                            Settings

                        </a>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li>
                        <a class="dropdown-item text-danger"
                           href="${pageContext.request.contextPath}/logout">

                            <i class="bi bi-box-arrow-right me-2"></i>
                            Logout

                        </a>
                    </li>

                </ul>

            </div>

        </div>

    </div>

</nav>


<!-- =========================
     SIDEBAR
========================= -->

<div class="offcanvas-lg offcanvas-start student-sidebar"
     tabindex="-1"
     id="teacherSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            Menu
        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>

    <div class="sidebar-content">

        <div class="sidebar-user">

            <div class="student-avatar large">
                L
            </div>

            <div>
                <strong>Lecturer</strong>
                <small>Teacher Account</small>
            </div>

        </div>

        <div class="sidebar-menu">

            <div class="sidebar-title">
                MAIN MENU
            </div>

            <a href="${pageContext.request.contextPath}/teacher/dashboard.jsp"
               class="sidebar-link">

                <i class="bi bi-grid"></i>
                <span>Dashboard</span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/create-quiz.jsp"
               class="sidebar-link active">

                <i class="bi bi-plus-square"></i>
                <span>Create Quiz</span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/quizzes.jsp"
               class="sidebar-link">

                <i class="bi bi-journal-text"></i>
                <span>My Quizzes</span>

                <span class="menu-badge">
                    18
                </span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/questions.jsp"
               class="sidebar-link">

                <i class="bi bi-question-circle"></i>
                <span>Questions</span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/results.jsp"
               class="sidebar-link">

                <i class="bi bi-bar-chart"></i>
                <span>Student Results</span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/reports.jsp"
               class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>
                <span>Quiz Reports</span>

            </a>


            <div class="sidebar-title mt-4">
                ACCOUNT
            </div>

            <a href="${pageContext.request.contextPath}/teacher/profile.jsp"
               class="sidebar-link">

                <i class="bi bi-person"></i>
                <span>My Profile</span>

            </a>

            <a href="${pageContext.request.contextPath}/teacher/settings.jsp"
               class="sidebar-link">

                <i class="bi bi-gear"></i>
                <span>Settings</span>

            </a>

            <a href="${pageContext.request.contextPath}/logout"
               class="sidebar-link logout-link">

                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- =========================
     MAIN CONTENT
========================= -->

<main class="dashboard-main">

    <!-- Page Header -->

    <div class="page-header">

        <nav aria-label="breadcrumb">

            <ol class="breadcrumb">

                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/teacher/dashboard.jsp">
                        Dashboard
                    </a>
                </li>

                <li class="breadcrumb-item active">
                    Create Quiz
                </li>

            </ol>

        </nav>

        <h2>
            Create New Quiz
        </h2>

        <p>
            Create and configure a new online quiz for your students.
        </p>

    </div>


    <!-- Step Indicator -->

    <div class="step-indicator">

        <div class="step active">

            <div class="step-number">
                1
            </div>

            <span class="step-label">
                Quiz Information
            </span>

        </div>

        <div class="step-line"></div>

        <div class="step">

            <div class="step-number">
                2
            </div>

            <span class="step-label">
                Questions
            </span>

        </div>

        <div class="step-line"></div>

        <div class="step">

            <div class="step-number">
                3
            </div>

            <span class="step-label">
                Review & Publish
            </span>

        </div>

    </div>


    <!-- Quiz Form -->

    <div class="quiz-form-card">

        <div class="form-card-header">

            <div class="form-header-icon">
                <i class="bi bi-journal-plus"></i>
            </div>

            <div>

                <h5>
                    Quiz Information
                </h5>

                <p>
                    Enter the basic information about your quiz.
                </p>

            </div>

        </div>


        <div class="form-card-body">

            <form action="${pageContext.request.contextPath}/createQuiz"
                  method="post">


                <!-- BASIC INFORMATION -->

                <div class="form-section">

                    <div class="form-section-title">

                        <i class="bi bi-info-circle"></i>

                        Basic Information

                    </div>


                    <!-- Quiz Title -->

                    <div class="mb-4">

                        <label for="quizTitle"
                               class="form-label">

                            Quiz Title
                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            class="form-control"
                            id="quizTitle"
                            name="quizTitle"
                            placeholder="e.g. Database Management Systems"
                            required>

                        <small class="form-help">
                            Enter a clear and descriptive title for the quiz.
                        </small>

                    </div>


                    <!-- Course -->

                    <div class="mb-4">

                        <label for="course"
                               class="form-label">

                            Course
                            <span class="required">*</span>

                        </label>

                        <select
                            class="form-select"
                            id="course"
                            name="course"
                            required>

                            <option value="">
                                Select Course
                            </option>

                            <option value="Computer Science">
                                Computer Science
                            </option>

                            <option value="Information Technology">
                                Information Technology
                            </option>

                            <option value="Software Engineering">
                                Software Engineering
                            </option>

                            <option value="Cyber Security">
                                Cyber Security
                            </option>

                            <option value="Information Systems">
                                Information Systems
                            </option>

                        </select>

                    </div>


                    <!-- Description -->

                    <div class="mb-3">

                        <label for="description"
                               class="form-label">

                            Quiz Description
                            <span class="required">*</span>

                        </label>

                        <textarea
                            class="form-control"
                            id="description"
                            name="description"
                            placeholder="Enter a short description explaining what this quiz covers..."
                            required></textarea>

                    </div>

                </div>


                <!-- QUIZ SETTINGS -->

                <div class="form-section">

                    <div class="form-section-title">

                        <i class="bi bi-sliders"></i>

                        Quiz Settings

                    </div>


                    <div class="row g-4">


                        <!-- Duration -->

                        <div class="col-md-4">

                            <label for="duration"
                                   class="form-label">

                                Duration
                                <span class="required">*</span>

                            </label>

                            <div class="input-group">

                                <input
                                    type="number"
                                    class="form-control"
                                    id="duration"
                                    name="duration"
                                    min="1"
                                    placeholder="30"
                                    required>

                                <span class="input-group-text">
                                    minutes
                                </span>

                            </div>

                            <small class="form-help">
                                How long students have to complete the quiz.
                            </small>

                        </div>


                        <!-- Question Count -->

                        <div class="col-md-4">

                            <label for="questionCount"
                                   class="form-label">

                                Number of Questions
                                <span class="required">*</span>

                            </label>

                            <input
                                type="number"
                                class="form-control"
                                id="questionCount"
                                name="questionCount"
                                min="1"
                                placeholder="20"
                                required>

                            <small class="form-help">
                                Number of questions to be included.
                            </small>

                        </div>


                        <!-- Pass Mark -->

                        <div class="col-md-4">

                            <label for="passMark"
                                   class="form-label">

                                Pass Mark
                                <span class="required">*</span>

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

                            <small class="form-help">
                                Minimum percentage required to pass.
                            </small>

                        </div>

                    </div>

                </div>


                <!-- ACTIONS -->

                <div class="form-actions">

                    <button
                        type="submit"
                        name="action"
                        value="draft"
                        class="btn btn-draft">

                        <i class="bi bi-save me-1"></i>

                        Save as Draft

                    </button>


                    <button
                        type="submit"
                        name="action"
                        value="continue"
                        class="btn btn-continue">

                        Continue to Questions

                        <i class="bi bi-arrow-right ms-1"></i>

                    </button>

                </div>

            </form>

        </div>

    </div>

</main>


<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>