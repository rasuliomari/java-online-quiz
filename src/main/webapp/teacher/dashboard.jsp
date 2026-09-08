<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
/*
* ============================================================
* TEACHER SESSION
* ============================================================
*/

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

String teacherFirstName =
        (String) session.getAttribute("teacherFirstName");

String teacherMiddleName =
        (String) session.getAttribute("teacherMiddleName");

String teacherLastName =
        (String) session.getAttribute("teacherLastName");

String teacherStaffNumber =
        (String) session.getAttribute("teacherStaffNumber");

String teacherCollege =
        (String) session.getAttribute("teacherCollege");

String teacherDepartment =
        (String) session.getAttribute("teacherDepartment");

if (teacherFirstName == null) {
    teacherFirstName = "Teacher";
}

if (teacherLastName == null) {
    teacherLastName = "";
}

String teacherFullName =
        teacherFirstName + " " + teacherLastName;

String initials = "";

if (teacherFirstName != null &&
    !teacherFirstName.trim().isEmpty()) {

    initials +=
            teacherFirstName.trim().substring(0, 1).toUpperCase();
}

if (teacherLastName != null &&
    !teacherLastName.trim().isEmpty()) {

    initials +=
            teacherLastName.trim().substring(0, 1).toUpperCase();
}

if (initials.isEmpty()) {
    initials = "T";
}


/*
 * ============================================================
 * DASHBOARD STATISTICS
 * ============================================================
 */

int totalQuizzes = 0;
int publishedQuizzes = 0;
int draftQuizzes = 0;
int totalQuestions = 0;

String successMessage =
        request.getParameter("published");

SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy");


try (Connection connection =
             DBConnection.getConnection()) {


    /*
     * --------------------------------------------------------
     * QUIZ STATISTICS
     * --------------------------------------------------------
     */

    String statisticsSql =
            "SELECT " +
            "COUNT(*) AS total_quizzes, " +
            "COUNT(*) FILTER " +
            "(WHERE status = 'PUBLISHED') AS published_quizzes, " +
            "COUNT(*) FILTER " +
            "(WHERE status = 'DRAFT') AS draft_quizzes " +
            "FROM quizzes " +
            "WHERE teacher_id = ?";


    try (PreparedStatement statement =
                 connection.prepareStatement(statisticsSql)) {

        statement.setInt(1, teacherId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                totalQuizzes =
                        resultSet.getInt("total_quizzes");

                publishedQuizzes =
                        resultSet.getInt("published_quizzes");

                draftQuizzes =
                        resultSet.getInt("draft_quizzes");
            }
        }
    }


    /*
     * --------------------------------------------------------
     * QUESTION STATISTICS
     * --------------------------------------------------------
     */

    String questionsSql =
            "SELECT COUNT(*) AS total_questions " +
            "FROM questions q " +
            "INNER JOIN quizzes z " +
            "ON q.quiz_id = z.id " +
            "WHERE z.teacher_id = ?";


    try (PreparedStatement statement =
                 connection.prepareStatement(questionsSql)) {

        statement.setInt(1, teacherId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                totalQuestions =
                        resultSet.getInt("total_questions");
            }
        }
    }

} catch (SQLException e) {

    e.printStackTrace();
}


/*
 * ============================================================
 * PUBLICATION PERCENTAGE
 * ============================================================
 */

int publicationPercentage = 0;

if (totalQuizzes > 0) {

    publicationPercentage =
            (publishedQuizzes * 100) / totalQuizzes;
}

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Teacher Dashboard | UDOM Online Quiz System
</title>


<!-- Bootstrap -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- Bootstrap Icons -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    rel="stylesheet">


<!-- Dashboard CSS -->

<link rel="stylesheet"
      href="../css/dashboard.css">

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

                <small>
                    Online Quiz System
                </small>

            </div>


        </a>


    </div>


    <div class="d-flex align-items-center gap-3">


        <!-- Notifications -->

        <button class="notification-btn">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                0
            </span>

        </button>


        <!-- Profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                data-bs-toggle="dropdown">


                <div class="student-avatar">

                    <%= initials %>

                </div>


                <div class="student-name">

                    <strong>
                        <%= teacherFirstName %>
                        <%= teacherLastName %>
                    </strong>

                    <small>
                        Academic Staff
                    </small>

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
                       href="<%= request.getContextPath() %>/logout">

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

            <%= initials %>

        </div>


        <div>

            <h6>

                <%= teacherFirstName %>
                <%= teacherLastName %>

            </h6>

            <span>
                Academic Staff
            </span>

        </div>


    </div>



    <!-- Main Menu -->

    <div class="menu-title">

        MAIN MENU

    </div>



    <a href="dashboard.jsp"
       class="sidebar-link active">

        <i class="bi bi-grid-1x2-fill"></i>

        <span>
            Dashboard
        </span>

    </a>



    <a href="create-quiz.jsp"
       class="sidebar-link">

        <i class="bi bi-plus-square"></i>

        <span>
            Create Quiz
        </span>

    </a>



    <a href="#my-quizzes"
       class="sidebar-link">

        <i class="bi bi-journal-text"></i>

        <span>
            My Quizzes
        </span>

        <span class="menu-badge">

            <%= totalQuizzes %>

        </span>

    </a>



    <a href="#assigned-courses"
       class="sidebar-link">

        <i class="bi bi-book"></i>

        <span>
            Assigned Courses
        </span>

    </a>



    <a href="#"
       class="sidebar-link">

        <i class="bi bi-question-circle"></i>

        <span>
            Questions
        </span>

    </a>



    <a href="#"
       class="sidebar-link">

        <i class="bi bi-people"></i>

        <span>
            Student Results
        </span>

    </a>



    <a href="#"
       class="sidebar-link">

        <i class="bi bi-bar-chart"></i>

        <span>
            Quiz Reports
        </span>

    </a>



    <!-- Account -->

    <div class="menu-title">

        ACCOUNT

    </div>



    <a href="#"
       class="sidebar-link">

        <i class="bi bi-person"></i>

        <span>
            My Profile
        </span>

    </a>



    <a href="#"
       class="sidebar-link">

        <i class="bi bi-gear"></i>

        <span>
            Settings
        </span>

    </a>



    <div class="sidebar-bottom">


        <a href="<%= request.getContextPath() %>/logout"
           class="logout-link">

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

                Welcome,
                <%= teacherFirstName %>! 👋

            </h1>


            <p>

                Manage your assigned courses, quizzes,
                questions and academic assessments from
                your dashboard.

            </p>


            <% if (teacherStaffNumber != null) { %>

                <small class="text-muted">

                    <i class="bi bi-person-badge me-1"></i>

                    <%= teacherStaffNumber %>

                </small>

            <% } %>


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

                    <span>
                        My Quizzes
                    </span>

                    <h2>

                        <%= totalQuizzes %>

                    </h2>

                    <small>
                        Your quizzes
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

                    <span>
                        Published Quizzes
                    </span>

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

                    <span>
                        Draft Quizzes
                    </span>

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

                    <span>
                        My Questions
                    </span>

                    <h2>

                        <%= totalQuestions %>

                    </h2>

                    <small>
                        Across your quizzes
                    </small>

                </div>


            </div>


        </div>


    </div>



    <!-- =====================================================
         ASSIGNED COURSES
    ====================================================== -->

    <div class="row g-4 mb-4"
         id="assigned-courses">


        <div class="col-12">


            <div class="content-card">


                <div class="card-header-custom">


                    <div>

                        <h4>

                            Assigned Courses

                        </h4>

                        <p>

                            Courses assigned to you by the
                            system administrator

                        </p>

                    </div>


                </div>



                <%
                    String assignedCoursesSql =
                            "SELECT " +
                            "c.id AS course_id, " +
                            "c.course_code, " +
                            "c.course_name, " +
                            "c.year_of_study, " +
                            "p.name AS programme_name " +
                            "FROM teacher_courses tc " +
                            "INNER JOIN courses c " +
                            "ON tc.course_id = c.id " +
                            "INNER JOIN programmes p " +
                            "ON c.programme_id = p.id " +
                            "WHERE tc.teacher_id = ? " +
                            "ORDER BY p.name, " +
                            "c.year_of_study, " +
                            "c.course_code";


                    boolean hasAssignedCourses = false;


                    try (Connection connection =
                                 DBConnection.getConnection();
                         PreparedStatement statement =
                                 connection.prepareStatement(
                                         assignedCoursesSql)) {


                        statement.setInt(1, teacherId);


                        try (ResultSet resultSet =
                                     statement.executeQuery()) {


                            while (resultSet.next()) {


                                hasAssignedCourses = true;


                                int courseId =
                                        resultSet.getInt("course_id");


                                String courseCode =
                                        resultSet.getString(
                                                "course_code");


                                String courseName =
                                        resultSet.getString(
                                                "course_name");


                                int yearOfStudy =
                                        resultSet.getInt(
                                                "year_of_study");


                                String programmeName =
                                        resultSet.getString(
                                                "programme_name");

                %>


                <div class="quiz-item">


                    <div class="quiz-icon">

                        <i class="bi bi-book"></i>

                    </div>


                    <div class="quiz-information">


                        <h5>

                            <%= courseCode %>

                        </h5>


                        <div class="quiz-meta">


                            <span>

                                <i class="bi bi-bookmark"></i>

                                <%= courseName %>

                            </span>


                            <span>

                                <i class="bi bi-mortarboard"></i>

                                <%= programmeName %>

                            </span>


                            <span>

                                <i class="bi bi-calendar3"></i>

                                Year <%= yearOfStudy %>

                            </span>


                        </div>


                    </div>


                    <div class="quiz-action">


                        <span class="quiz-status"
                              style="color:#10b981;">

                            ASSIGNED

                        </span>


                        <a href="create-quiz.jsp?courseId=<%= courseId %>"
                           class="start-quiz-btn">

                            Create Quiz

                        </a>


                    </div>


                </div>


                <%

                            }


                        }


                    } catch (SQLException e) {

                        e.printStackTrace();

                %>


                    <div class="alert alert-danger">

                        Unable to load assigned courses.

                    </div>


                <%

                    }


                    if (!hasAssignedCourses) {

                %>


                    <div class="text-center py-4">


                        <i class="bi bi-book fs-2 text-muted"></i>


                        <p class="text-muted mt-2 mb-1">

                            No courses have been assigned to you yet.

                        </p>


                        <small class="text-muted">

                            Contact the system administrator
                            to assign your courses.

                        </small>


                    </div>


                <%

                    }

                %>


            </div>


        </div>


    </div>



    <!-- =====================================================
         QUIZZES + QUICK ACTIONS
    ====================================================== -->

    <div class="row g-4">


        <!-- MY QUIZZES -->

        <div class="col-lg-8"
             id="my-quizzes">


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


                    <a href="create-quiz.jsp">

                        View All

                    </a>


                </div>



                <%
                    String quizSql =
                            "SELECT " +
                            "q.id, " +
                            "q.title, " +
                            "q.course, " +
                            "q.question_count, " +
                            "q.status, " +
                            "q.created_at, " +
                            "(SELECT COUNT(*) " +
                            "FROM questions " +
                            "WHERE quiz_id = q.id) " +
                            "AS saved_questions " +
                            "FROM quizzes q " +
                            "WHERE q.teacher_id = ? " +
                            "ORDER BY q.created_at DESC " +
                            "LIMIT 5";


                    try (Connection connection =
                                 DBConnection.getConnection();
                         PreparedStatement statement =
                                 connection.prepareStatement(
                                         quizSql)) {


                        statement.setInt(1, teacherId);


                        try (ResultSet resultSet =
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
                                        resultSet.getInt(
                                                "question_count");


                                int savedQuestions =
                                        resultSet.getInt(
                                                "saved_questions");


                                String status =
                                        resultSet.getString("status");


                                Timestamp createdAt =
                                        resultSet.getTimestamp(
                                                "created_at");


                                String formattedDate =
                                        createdAt != null
                                        ? dateFormat.format(createdAt)
                                        : "-";


                                boolean published =
                                        "PUBLISHED".equalsIgnoreCase(
                                                status);


                                String actionUrl =
                                        published
                                        ? "review-quiz.jsp?quizId="
                                            + quizId
                                        : "add-questions.jsp?quizId="
                                            + quizId;


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

                            }


                            if (!hasQuizzes) {

                %>


                    <div class="text-center py-4">


                        <i class="bi bi-journal-x fs-2 text-muted"></i>


                        <p class="text-muted mt-2 mb-2">

                            You have not created any quizzes yet.

                        </p>


                        <a href="#assigned-courses"
                           class="btn btn-primary btn-sm">

                            <i class="bi bi-book me-1"></i>

                            View Assigned Courses

                        </a>


                    </div>


                <%

                            }


                        }


                    } catch (SQLException e) {

                %>


                    <div class="alert alert-danger">

                        Unable to load your quizzes.

                    </div>


                <%

                        e.printStackTrace();

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



                <a href="#assigned-courses"
                   class="quick-action">


                    <div class="quick-action-icon icon-blue">

                        <i class="bi bi-book"></i>

                    </div>


                    <div>

                        <h6>
                            My Assigned Courses
                        </h6>

                        <span>
                            View courses assigned to you
                        </span>

                    </div>


                    <i class="bi bi-chevron-right"></i>


                </a>



                <a href="create-quiz.jsp"
                   class="quick-action">


                    <div class="quick-action-icon icon-purple">

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
                            My Quizzes
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



        <!-- =================================================
             TEACHER INFORMATION
        ================================================== -->

        <div class="col-lg-6">


            <div class="content-card">


                <div class="card-header-custom">


                    <div>

                        <h4>
                            Academic Information
                        </h4>


                        <p>
                            Your lecturer account information
                        </p>

                    </div>


                </div>



                <div class="upcoming-item">


                    <div class="calendar-icon">

                        <i class="bi bi-person-badge"></i>

                    </div>


                    <div>

                        <h6>
                            Staff Number
                        </h6>


                        <small>

                            <%= teacherStaffNumber != null
                                ? teacherStaffNumber
                                : "-" %>

                        </small>

                    </div>


                </div>



                <div class="upcoming-item">


                    <div class="calendar-icon">

                        <i class="bi bi-building"></i>

                    </div>


                    <div>

                        <h6>
                            College / School
                        </h6>


                        <small>

                            <%= teacherCollege != null
                                ? teacherCollege
                                : "-" %>

                        </small>

                    </div>


                </div>



                <div class="upcoming-item">


                    <div class="calendar-icon">

                        <i class="bi bi-diagram-3"></i>

                    </div>


                    <div>

                        <h6>
                            Department
                        </h6>


                        <small>

                            <%= teacherDepartment != null
                                ? teacherDepartment
                                : "-" %>

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
