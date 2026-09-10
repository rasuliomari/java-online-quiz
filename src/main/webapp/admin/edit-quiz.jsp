
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    /*
     * =========================================================
     * ADMIN SESSION
     * =========================================================
     */

    String adminFirstName =
            (String) session.getAttribute("adminFirstName");

    String adminLastName =
            (String) session.getAttribute("adminLastName");

    if (adminFirstName == null) {
        adminFirstName = "Administrator";
    }

    if (adminLastName == null) {
        adminLastName = "";
    }

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();


    /*
     * =========================================================
     * GET QUIZ ID
     * =========================================================
     */

    String quizIdParameter =
            request.getParameter("id");

    if (quizIdParameter == null
            || quizIdParameter.trim().isEmpty()) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=invalid_quiz");

        return;
    }

    int quizId;

    try {

        quizId =
                Integer.parseInt(quizIdParameter.trim());

    } catch (NumberFormatException e) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=invalid_quiz");

        return;
    }


    /*
     * =========================================================
     * QUIZ VARIABLES
     * =========================================================
     */

    String title = "";
    String course = "";
    String description = "";

    int durationMinutes = 30;
    int questionCount = 0;
    int courseId = 0;
    int passMark = 50;

    String status = "DRAFT";

    boolean quizFound = false;


    /*
     * =========================================================
     * LOAD QUIZ
     * =========================================================
     */

    String quizSql =
            "SELECT id, title, course, description, " +
            "duration_minutes, question_count, pass_mark, " +
            "status, course_id " +
            "FROM quizzes " +
            "WHERE id = ?";

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(quizSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                quizFound = true;

                title =
                        resultSet.getString("title");

                course =
                        resultSet.getString("course");

                description =
                        resultSet.getString("description");

                durationMinutes =
                        resultSet.getInt("duration_minutes");

                questionCount =
                        resultSet.getInt("question_count");

                passMark =
                        resultSet.getInt("pass_mark");

                status =
                        resultSet.getString("status");

                courseId =
                        resultSet.getInt("course_id");
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=database_error");

        return;
    }


    /*
     * =========================================================
     * QUIZ NOT FOUND
     * =========================================================
     */

    if (!quizFound) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-quizzes.jsp?error=quiz_not_found");

        return;
    }


    /*
     * =========================================================
     * GET ACTUAL QUESTION COUNT
     * =========================================================
     */

    String questionCountSql =
            "SELECT COUNT(*) " +
            "FROM questions " +
            "WHERE quiz_id = ?";

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(questionCountSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet =
                     statement.executeQuery()) {

            if (resultSet.next()) {

                questionCount =
                        resultSet.getInt(1);
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }


    /*
     * =========================================================
     * COURSES QUERY
     * =========================================================
     */

    String coursesSql =
            "SELECT id, course_code, course_name " +
            "FROM courses " +
            "ORDER BY course_code";


    /*
     * =========================================================
     * MESSAGES
     * =========================================================
     */

    String updated =
            request.getParameter("updated");

    String error =
            request.getParameter("error");
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        Edit Quiz | UDOM Online Quiz System
    </title>


    <!-- Bootstrap 5.3.3 -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


    <!-- Shared Dashboard CSS -->

    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>


<body>



<!-- =========================================================
     TOP NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile Menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#adminSidebar">

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

            <span>
                UDOM
            </span>

            <small>
                Online Quiz System
            </small>

        </div>

    </a>


    <!-- Right Side -->

    <div class="d-flex align-items-center ms-auto">


        <!-- Notification -->

        <button
            class="notification-btn me-3"
            type="button">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                4
            </span>

        </button>


        <!-- Admin Profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                type="button"
                data-bs-toggle="dropdown">

                <div class="student-avatar">

                    <%= adminFirstName.substring(0, 1).toUpperCase() %>

                </div>


                <div class="student-name d-none d-md-block">

                    <strong>
                        <%= adminFullName %>
                    </strong>

                    <small>
                        System Administrator
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



<!-- =========================================================
     SIDEBAR
========================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">


    <!-- Mobile Header -->

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">

            Administrator Menu

        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">

        </button>

    </div>


    <div class="sidebar-content">


        <!-- Administrator Information -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">

                <%= adminFirstName.substring(0, 1).toUpperCase() %>

            </div>


            <div>

                <h6>
                    <%= adminFullName %>
                </h6>

                <span>
                    System Administrator
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


            <!-- Create Teacher -->

            <a
                href="create-teacher.jsp"
                class="sidebar-link">

                <i class="bi bi-person-plus-fill"></i>

                <span>
                    Create Teacher
                </span>

            </a>


            <!-- Manage Teachers -->

            <a
                href="manage-teachers.jsp"
                class="sidebar-link">

                <i class="bi bi-people-fill"></i>

                <span>
                    Manage Teachers
                </span>

            </a>


            <!-- Assign Courses -->

            <a
                href="assign-courses.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-bookmark-fill"></i>

                <span>
                    Assign Courses
                </span>

            </a>


            <!-- Manage Students -->

            <a
                href="manage-students.jsp"
                class="sidebar-link">

                <i class="bi bi-mortarboard-fill"></i>

                <span>
                    Manage Students
                </span>

            </a>


            <!-- Manage Quizzes -->

            <a
                href="manage-quizzes.jsp"
                class="sidebar-link active">

                <i class="bi bi-journal-text"></i>

                <span>
                    Manage Quizzes
                </span>

            </a>


            <!-- Student Results -->

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
                    Reports
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
                href="../logout"
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
                Edit Quiz
            </h1>

            <p>
                Update quiz information and settings
                for the selected quiz.
            </p>

        </div>


        <div class="d-flex gap-2">

            <a
                href="view-quiz.jsp?id=<%= quizId %>"
                class="btn btn-outline-primary">

                <i class="bi bi-eye-fill me-2"></i>

                View Quiz

            </a>


            <a
                href="manage-quizzes.jsp"
                class="btn btn-outline-secondary">

                <i class="bi bi-arrow-left me-2"></i>

                Back

            </a>

        </div>

    </div>



    <!-- =====================================================
         MESSAGES
    ====================================================== -->

    <% if ("success".equals(updated)) { %>

        <div
            class="alert alert-success alert-dismissible fade show"
            role="alert">

            <i class="bi bi-check-circle-fill me-2"></i>

            <strong>Success!</strong>

            Quiz information has been updated successfully.

            <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert">
            </button>

        </div>

    <% } %>


    <% if ("invalid_data".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            Please provide valid information for all required fields.

        </div>

    <% } else if ("invalid_duration".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-clock-fill me-2"></i>

            Duration must be between 1 and 600 minutes.

        </div>

    <% } else if ("invalid_pass_mark".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-percent me-2"></i>

            Pass mark must be between 1 and 100.

        </div>

    <% } else if ("invalid_course".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-book-fill me-2"></i>

            Please select a valid course.

        </div>

    <% } else if ("invalid_status".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            Please select a valid quiz status.

        </div>

    <% } else if ("database_error".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-database-x me-2"></i>

            A database error occurred while updating the quiz.

        </div>

    <% } %>



    <!-- =====================================================
         QUIZ SUMMARY
    ====================================================== -->

    <div class="row g-4 mb-4">


        <!-- Questions -->

        <div class="col-xl-4 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-list-ol"></i>

                </div>


                <div>

                    <p>
                        Questions
                    </p>

                    <h3>
                        <%= questionCount %>
                    </h3>

                    <span>
                        Questions currently stored
                    </span>

                </div>

            </div>

        </div>



        <!-- Duration -->

        <div class="col-xl-4 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-clock-fill"></i>

                </div>


                <div>

                    <p>
                        Duration
                    </p>

                    <h3>
                        <%= durationMinutes %>
                    </h3>

                    <span>
                        Minutes allowed
                    </span>

                </div>

            </div>

        </div>



        <!-- Pass Mark -->

        <div class="col-xl-4 col-md-6">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-award-fill"></i>

                </div>


                <div>

                    <p>
                        Pass Mark
                    </p>

                    <h3>
                        <%= passMark %>%
                    </h3>

                    <span>
                        Required to pass
                    </span>

                </div>

            </div>

        </div>

    </div>



    <!-- =====================================================
         EDIT QUIZ
    ====================================================== -->

    <div class="content-card">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Information
                </h4>

                <p>
                    Update the information for Quiz #<%= quizId %>
                </p>

            </div>


            <div>

                <span
                    class="badge
                    <%= "PUBLISHED".equalsIgnoreCase(status)
                            ? "bg-success"
                            : "bg-secondary" %>">

                    <i
                        class="bi
                        <%= "PUBLISHED".equalsIgnoreCase(status)
                                ? "bi-check-circle-fill"
                                : "bi-pencil-fill" %>
                        me-1">
                    </i>

                    <%= status %>

                </span>

            </div>

        </div>



        <div class="p-4">


            <!-- FORM -->

            <form
                method="post"
                action="<%= request.getContextPath() %>/adminUpdateQuiz">


                <!-- Quiz ID -->

                <input
                    type="hidden"
                    name="quizId"
                    value="<%= quizId %>">


                <div class="row g-4">


                    <!-- Quiz Title -->

                    <div class="col-md-8">

                        <label
                            class="form-label fw-semibold">

                            Quiz Title

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <input
                            type="text"
                            name="title"
                            class="form-control"
                            value="<%= title != null ? title : "" %>"
                            maxlength="200"
                            required>

                    </div>



                    <!-- Status -->

                    <div class="col-md-4">

                        <label
                            class="form-label fw-semibold">

                            Status

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <select
                            name="status"
                            class="form-select"
                            required>


                            <option
                                value="DRAFT"
                                <%= "DRAFT".equalsIgnoreCase(status)
                                        ? "selected"
                                        : "" %>>

                                Draft

                            </option>


                            <option
                                value="PUBLISHED"
                                <%= "PUBLISHED".equalsIgnoreCase(status)
                                        ? "selected"
                                        : "" %>>

                                Published

                            </option>

                        </select>

                    </div>



                    <!-- Course -->

                    <div class="col-md-8">

                        <label
                            class="form-label fw-semibold">

                            Course

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <select
                            name="courseId"
                            class="form-select"
                            required>


                            <option value="">

                                Select Course

                            </option>


                            <%
                                try (
                                    Connection connection =
                                            DBConnection.getConnection();

                                    PreparedStatement statement =
                                            connection.prepareStatement(
                                                    coursesSql
                                            );

                                    ResultSet resultSet =
                                            statement.executeQuery()
                                ) {

                                    while (resultSet.next()) {

                                        int currentCourseId =
                                                resultSet.getInt("id");

                                        String courseCode =
                                                resultSet.getString(
                                                        "course_code");

                                        String courseName =
                                                resultSet.getString(
                                                        "course_name");
                            %>


                                <option
                                    value="<%= currentCourseId %>"
                                    <%= currentCourseId == courseId
                                            ? "selected"
                                            : "" %>>

                                    <%= courseCode %>
                                    -
                                    <%= courseName %>

                                </option>


                            <%
                                    }

                                } catch (Exception e) {

                                    e.printStackTrace();
                            %>

                                <option value="">

                                    Unable to load courses

                                </option>

                            <%
                                }
                            %>


                        </select>

                    </div>



                    <!-- Question Count -->

                    <div class="col-md-4">

                        <label
                            class="form-label fw-semibold">

                            Number of Questions

                        </label>


                        <input
                            type="text"
                            class="form-control"
                            value="<%= questionCount %>"
                            readonly>


                        <small class="text-muted">

                            Automatically calculated.

                        </small>

                    </div>



                    <!-- Duration -->

                    <div class="col-md-6">

                        <label
                            class="form-label fw-semibold">

                            Duration (Minutes)

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <input
                            type="number"
                            name="durationMinutes"
                            class="form-control"
                            value="<%= durationMinutes %>"
                            min="1"
                            max="600"
                            required>


                        <small class="text-muted">

                            Maximum: 600 minutes.

                        </small>

                    </div>



                    <!-- Pass Mark -->

                    <div class="col-md-6">

                        <label
                            class="form-label fw-semibold">

                            Pass Mark (%)

                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <input
                            type="number"
                            name="passMark"
                            class="form-control"
                            value="<%= passMark %>"
                            min="1"
                            max="100"
                            required>


                        <small class="text-muted">

                            Enter a value between 1 and 100.

                        </small>

                    </div>



                    <!-- Description -->

                    <div class="col-12">

                        <label
                            class="form-label fw-semibold">

                            Description

                        </label>


                        <textarea
                            name="description"
                            class="form-control"
                            rows="5"
                            maxlength="5000"
                            placeholder="Enter quiz description..."><%= description != null ? description : "" %></textarea>

                    </div>

                </div>



                <!-- INFORMATION -->

                <div class="alert alert-info mt-4">

                    <div class="d-flex">

                        <i
                            class="bi bi-info-circle-fill me-2 mt-1">
                        </i>


                        <div>

                            <strong>
                                Question Count:
                            </strong>

                            The number of questions is calculated
                            automatically from the questions stored
                            for this quiz.

                        </div>

                    </div>

                </div>



                <!-- FORM BUTTONS -->

                <div
                    class="d-flex
                           justify-content-between
                           align-items-center
                           mt-4">


                    <a
                        href="manage-quizzes.jsp"
                        class="btn btn-outline-secondary">

                        <i class="bi bi-x-circle me-2"></i>

                        Cancel

                    </a>


                    <button
                        type="submit"
                        class="btn btn-primary">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        Update Quiz

                    </button>

                </div>


            </form>

        </div>

    </div>



    <!-- =====================================================
         QUIZ MANAGEMENT INFORMATION
    ====================================================== -->

    <div class="content-card mt-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Management
                </h4>

                <p>
                    Available administrator functions
                </p>

            </div>

        </div>



        <div class="row g-3">


            <!-- View Quiz -->

            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-eye-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            View Quiz
                        </h5>


                        <div class="quiz-meta">

                            <span>
                                Review the complete quiz and
                                its questions.
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Edit Quiz -->

            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

                        <i class="bi bi-pencil-square"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Edit Information
                        </h5>


                        <div class="quiz-meta">

                            <span>
                                Update quiz title, course,
                                duration and pass mark.
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Status -->

            <div class="col-md-4">

                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-check-circle-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Quiz Status
                        </h5>


                        <div class="quiz-meta">

                            <span>
                                Manage the Draft or Published
                                status of the quiz.
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
     BOOTSTRAP JS
========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>
