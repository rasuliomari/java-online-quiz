<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    int totalQuizzes = 0;
    int publishedQuizzes = 0;
    int draftQuizzes = 0;
    int totalQuestions = 0;

    String successMessage = request.getParameter("published");

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd MMM yyyy");

    /*
     * Load dashboard statistics
     */
    try (Connection connection = DBConnection.getConnection()) {

        String statisticsSql =
                "SELECT " +
                "COUNT(*) AS total_quizzes, " +
                "COUNT(*) FILTER (WHERE status = 'PUBLISHED') AS published_quizzes, " +
                "COUNT(*) FILTER (WHERE status = 'DRAFT') AS draft_quizzes " +
                "FROM quizzes";

        try (PreparedStatement statement =
                     connection.prepareStatement(statisticsSql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                totalQuizzes =
                        resultSet.getInt("total_quizzes");

                publishedQuizzes =
                        resultSet.getInt("published_quizzes");

                draftQuizzes =
                        resultSet.getInt("draft_quizzes");
            }
        }

        String questionsSql =
                "SELECT COUNT(*) AS total_questions FROM questions";

        try (PreparedStatement statement =
                     connection.prepareStatement(questionsSql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                totalQuestions =
                        resultSet.getInt("total_questions");
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Teacher Dashboard | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Dashboard CSS -->
    <link rel="stylesheet" href="../css/dashboard.css">

</head>

<body>

<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

    <div class="container-fluid">

        <div class="d-flex align-items-center">

            <button
                class="btn sidebar-toggle d-lg-none me-2"
                type="button"
                data-bs-toggle="offcanvas"
                data-bs-target="#teacherSidebar">

                <i class="bi bi-list"></i>

            </button>

            <a href="dashboard.jsp"
               class="navbar-brand d-flex align-items-center">

                <div class="brand-icon">
                    <i class="bi bi-mortarboard-fill"></i>
                </div>

                <div class="brand-text">

                    <span>UDOM</span>

                    <small>Online Quiz System</small>

                </div>

            </a>

        </div>


        <div class="d-flex align-items-center gap-3">

            <!-- Notifications -->

            <button class="notification-btn">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    4
                </span>

            </button>


            <!-- Profile -->

            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        RO
                    </div>

                    <div class="student-name">

                        <strong>Lecturer</strong>

                        <small>Academic Staff</small>

                    </div>

                </button>

                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a class="dropdown-item"
                           href="#">
                            <i class="bi bi-person me-2"></i>
                            My Profile
                        </a>
                    </li>

                    <li>
                        <a class="dropdown-item"
                           href="#">
                            <i class="bi bi-gear me-2"></i>
                            Settings
                        </a>
                    </li>

                    <li>
                        <hr class="dropdown-divider">
                    </li>

                    <li>
                        <a class="dropdown-item text-danger"
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

    <div class="sidebar-content">

        <!-- Sidebar Profile -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                RO
            </div>

            <div>

                <h6>Lecturer</h6>

                <span>Academic Staff</span>

            </div>

        </div>


        <!-- Main Menu -->

        <div class="menu-title">
            MAIN MENU
        </div>


        <a href="dashboard.jsp"
           class="sidebar-link active">

            <i class="bi bi-grid-1x2-fill"></i>

            <span>Dashboard</span>

        </a>


        <a href="create-quiz.jsp"
           class="sidebar-link">

            <i class="bi bi-plus-square"></i>

            <span>Create Quiz</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-journal-text"></i>

            <span>My Quizzes</span>

            <span class="menu-badge">
                <%= totalQuizzes %>
            </span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-question-circle"></i>

            <span>Questions</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-people"></i>

            <span>Student Results</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-bar-chart"></i>

            <span>Quiz Reports</span>

        </a>


        <!-- Account -->

        <div class="menu-title">
            ACCOUNT
        </div>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-person"></i>

            <span>My Profile</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-gear"></i>

            <span>Settings</span>

        </a>


        <div class="sidebar-bottom">

            <a href="../login.jsp"
               class="logout-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

    <div class="dashboard-container">


        <!-- Success Message -->

        <% if ("success".equalsIgnoreCase(successMessage)) { %>

            <div class="alert alert-success alert-dismissible fade show"
                 role="alert">

                <i class="bi bi-check-circle-fill me-2"></i>

                Quiz published successfully!

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <% } %>


        <!-- =====================================================
             WELCOME
        ====================================================== -->

        <section class="welcome-section">

            <div>

                <div class="welcome-label">
                    LECTURER DASHBOARD
                </div>

                <h1>
                    Welcome, Lecturer! 👋
                </h1>

                <p>
                    Manage your quizzes, questions and academic
                    assessments from your dashboard.
                </p>

            </div>

            <div class="welcome-icon">

                <i class="bi bi-mortarboard-fill"></i>

            </div>

        </section>


        <!-- =====================================================
             STATISTICS
        ====================================================== -->

        <div class="row g-3 mb-4">


            <!-- Total Quizzes -->

            <div class="col-12 col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon icon-blue">

                        <i class="bi bi-journal-text"></i>

                    </div>

                    <div>

                        <span>Total Quizzes</span>

                        <h2>
                            <%= totalQuizzes %>
                        </h2>

                        <small>
                            All quizzes
                        </small>

                    </div>

                </div>

            </div>


            <!-- Published -->

            <div class="col-12 col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon icon-green">

                        <i class="bi bi-check-circle"></i>

                    </div>

                    <div>

                        <span>Published Quizzes</span>

                        <h2>
                            <%= publishedQuizzes %>
                        </h2>

                        <small>
                            Currently published
                        </small>

                    </div>

                </div>

            </div>


            <!-- Draft -->

            <div class="col-12 col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon icon-purple">

                        <i class="bi bi-file-earmark"></i>

                    </div>

                    <div>

                        <span>Draft Quizzes</span>

                        <h2>
                            <%= draftQuizzes %>
                        </h2>

                        <small>
                            Awaiting publication
                        </small>

                    </div>

                </div>

            </div>


            <!-- Questions -->

            <div class="col-12 col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon icon-orange">

                        <i class="bi bi-question-circle"></i>

                    </div>

                    <div>

                        <span>Total Questions</span>

                        <h2>
                            <%= totalQuestions %>
                        </h2>

                        <small>
                            Across all quizzes
                        </small>

                    </div>

                </div>

            </div>

        </div>


        <!-- =====================================================
             QUIZZES + QUICK ACTIONS
        ====================================================== -->

        <div class="row g-4">


            <!-- MY QUIZZES -->

            <div class="col-lg-8">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h4>
                                My Quizzes
                            </h4>

                            <p>
                                Recently created quizzes
                            </p>

                        </div>

                        <a href="#">
                            View All
                        </a>

                    </div>


                    <%
                        String quizSql =
                                "SELECT q.id, q.title, q.course, " +
                                "q.question_count, q.status, q.created_at, " +
                                "(SELECT COUNT(*) FROM questions " +
                                "WHERE quiz_id = q.id) AS saved_questions " +
                                "FROM quizzes q " +
                                "ORDER BY q.created_at DESC " +
                                "LIMIT 5";

                        try (Connection connection =
                                     DBConnection.getConnection();
                             PreparedStatement statement =
                                     connection.prepareStatement(quizSql);
                             ResultSet resultSet =
                                     statement.executeQuery()) {

                            boolean hasQuizzes = false;

                            while (resultSet.next()) {

                                hasQuizzes = true;

                                int quizId =
                                        resultSet.getInt("id");

                                String title =
                                        resultSet.getString("title");

                                String course =
                                        resultSet.getString("course");

                                int requiredQuestions =
                                        resultSet.getInt("question_count");

                                int savedQuestions =
                                        resultSet.getInt("saved_questions");

                                String status =
                                        resultSet.getString("status");

                                Timestamp createdAt =
                                        resultSet.getTimestamp("created_at");

                                String formattedDate =
                                        createdAt != null
                                        ? dateFormat.format(createdAt)
                                        : "-";

                                boolean published =
                                        "PUBLISHED".equalsIgnoreCase(status);

                                String actionUrl =
                                        published
                                        ? "review-quiz.jsp?quizId=" + quizId
                                        : "add-questions.jsp?quizId=" + quizId;

                                String actionText =
                                        published
                                        ? "Manage"
                                        : "Continue";

                                String statusStyle =
                                        published
                                        ? "color:#10b981;"
                                        : "color:#d97706;";
                    %>


                    <div class="quiz-item">


                        <div class="quiz-icon">

                            <i class="bi bi-journal-text"></i>

                        </div>


                        <div class="quiz-information">

                            <h5>
                                <%= title %>
                            </h5>

                            <div class="quiz-meta">

                                <span>
                                    <i class="bi bi-book"></i>
                                    <%= course %>
                                </span>

                                <span>
                                    <i class="bi bi-question-circle"></i>
                                    <%= savedQuestions %>/<%= requiredQuestions %>
                                    Questions
                                </span>

                                <span>
                                    <i class="bi bi-calendar3"></i>
                                    <%= formattedDate %>
                                </span>

                            </div>

                        </div>


                        <div class="quiz-action">

                            <span class="quiz-status"
                                  style="<%= statusStyle %>">

                                <%= status %>

                            </span>

                            <a href="<%= actionUrl %>"
                               class="start-quiz-btn">

                                <%= actionText %>

                            </a>

                        </div>

                    </div>


                    <%
                            } // end while

                            if (!hasQuizzes) {
                    %>

                        <div class="text-center py-4">

                            <i class="bi bi-journal-x fs-2 text-muted"></i>

                            <p class="text-muted mt-2 mb-2">
                                No quizzes have been created yet.
                            </p>

                            <a href="create-quiz.jsp"
                               class="btn btn-primary btn-sm">

                                <i class="bi bi-plus-lg me-1"></i>
                                Create Your First Quiz

                            </a>

                        </div>

                    <%
                            } // end if
                        } catch (SQLException e) {
                    %>

                        <div class="alert alert-danger">

                            Unable to load quizzes.

                        </div>

                    <%
                        }
                    %>

                </div>

            </div>


            <!-- QUICK ACTIONS -->

            <div class="col-lg-4">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h4>
                                Quick Actions
                            </h4>

                            <p>
                                Frequently used actions
                            </p>

                        </div>

                    </div>


                    <a href="create-quiz.jsp"
                       class="quick-action">

                        <div class="quick-action-icon icon-blue">

                            <i class="bi bi-plus-circle"></i>

                        </div>

                        <div>

                            <h6>
                                Create New Quiz
                            </h6>

                            <span>
                                Create a new assessment
                            </span>

                        </div>

                        <i class="bi bi-chevron-right"></i>

                    </a>


                    <a href="#"
                       class="quick-action">

                        <div class="quick-action-icon icon-purple">

                            <i class="bi bi-question-circle"></i>

                        </div>

                        <div>

                            <h6>
                                Manage Questions
                            </h6>

                            <span>
                                Review quiz questions
                            </span>

                        </div>

                        <i class="bi bi-chevron-right"></i>

                    </a>


                    <a href="#"
                       class="quick-action">

                        <div class="quick-action-icon icon-green">

                            <i class="bi bi-people"></i>

                        </div>

                        <div>

                            <h6>
                                Student Results
                            </h6>

                            <span>
                                View student performance
                            </span>

                        </div>

                        <i class="bi bi-chevron-right"></i>

                    </a>


                    <a href="#"
                       class="quick-action">

                        <div class="quick-action-icon icon-orange">

                            <i class="bi bi-bar-chart"></i>

                        </div>

                        <div>

                            <h6>
                                Generate Report
                            </h6>

                            <span>
                                View quiz reports
                            </span>

                        </div>

                        <i class="bi bi-chevron-right"></i>

                    </a>

                </div>

            </div>

        </div>


        <!-- =====================================================
             QUIZ STATUS OVERVIEW
        ====================================================== -->

        <div class="row g-4 mt-1">


            <div class="col-lg-6">

                <div class="content-card performance-card">

                    <div class="card-header-custom">

                        <div class="text-start">

                            <h4>
                                Quiz Status Overview
                            </h4>

                            <p>
                                Current quiz publication status
                            </p>

                        </div>

                    </div>


                    <div class="performance-circle">

                        <div class="circle-inner">

                            <strong>
                                <%= totalQuizzes %>
                            </strong>

                            <span>
                                Total Quizzes
                            </span>

                        </div>

                    </div>


                    <div class="performance-info">

                        <div>

                            <span>
                                Published
                            </span>

                            <strong>
                                <%= publishedQuizzes %>
                            </strong>

                        </div>


                        <div>

                            <span>
                                Draft
                            </span>

                            <strong>
                                <%= draftQuizzes %>
                            </strong>

                        </div>


                        <div>

                            <span>
                                Questions
                            </span>

                            <strong>
                                <%= totalQuestions %>
                            </strong>

                        </div>

                    </div>


                    <div class="progress-section">

                        <div class="d-flex justify-content-between">

                            <span>
                                Publication progress
                            </span>

                            <strong>

                                <%
                                    int publicationPercentage = 0;

                                    if (totalQuizzes > 0) {
                                        publicationPercentage =
                                                (publishedQuizzes * 100)
                                                / totalQuizzes;
                                    }
                                %>

                                <%= publicationPercentage %>%

                            </strong>

                        </div>

                        <div class="progress">

                            <div
                                class="progress-bar"
                                role="progressbar"
                                style="width: <%= publicationPercentage %>%;">
                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- System Information -->

            <div class="col-lg-6">

                <div class="content-card">

                    <div class="card-header-custom">

                        <div>

                            <h4>
                                System Overview
                            </h4>

                            <p>
                                Your current quiz system activity
                            </p>

                        </div>

                    </div>


                    <div class="upcoming-item">

                        <div class="calendar-icon">

                            <i class="bi bi-journal-check"></i>

                        </div>

                        <div>

                            <h6>
                                Published Quizzes
                            </h6>

                            <small>
                                <%= publishedQuizzes %> quiz(es) available
                            </small>

                        </div>

                    </div>


                    <div class="upcoming-item">

                        <div class="calendar-icon">

                            <i class="bi bi-pencil-square"></i>

                        </div>

                        <div>

                            <h6>
                                Draft Quizzes
                            </h6>

                            <small>
                                <%= draftQuizzes %> quiz(es) need attention
                            </small>

                        </div>

                    </div>


                    <div class="upcoming-item">

                        <div class="calendar-icon">

                            <i class="bi bi-question-circle"></i>

                        </div>

                        <div>

                            <h6>
                                Question Bank
                            </h6>

                            <small>
                                <%= totalQuestions %> question(s) created
                            </small>

                        </div>

                    </div>


                    <div class="upcoming-item">

                        <div class="calendar-icon">

                            <i class="bi bi-database-check"></i>

                        </div>

                        <div>

                            <h6>
                                Database Status
                            </h6>

                            <small>
                                Connected to PostgreSQL
                            </small>

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
                © 2026 University of Dodoma.
                Online Quiz System.
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


<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>

