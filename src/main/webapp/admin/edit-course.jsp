<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    if (session.getAttribute("adminLoggedIn") == null ||
            !(Boolean) session.getAttribute("adminLoggedIn")) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String courseIdText = request.getParameter("id");

    if (courseIdText == null || courseIdText.trim().isEmpty()) {
        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage-courses.jsp?error=invalid_course"
        );
        return;
    }

    int courseId;

    try {
        courseId = Integer.parseInt(courseIdText);
    } catch (NumberFormatException e) {
        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage-courses.jsp?error=invalid_course"
        );
        return;
    }

    String courseCode = "";
    String courseName = "";
    int yearOfStudy = 1;
    int programmeId = 0;

    String programmeName = "";
    String collegeName = "";

    boolean courseFound = false;

    String sql =
            "SELECT c.course_code, c.course_name, c.year_of_study, "
                    + "c.programme_id, "
                    + "p.name AS programme_name, "
                    + "col.name AS college_name "
                    + "FROM courses c "
                    + "JOIN programmes p ON c.programme_id = p.id "
                    + "JOIN colleges col ON p.college_id = col.id "
                    + "WHERE c.id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setInt(1, courseId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {

                courseFound = true;

                courseCode =
                        resultSet.getString("course_code");

                courseName =
                        resultSet.getString("course_name");

                yearOfStudy =
                        resultSet.getInt("year_of_study");

                programmeId =
                        resultSet.getInt("programme_id");

                programmeName =
                        resultSet.getString("programme_name");

                collegeName =
                        resultSet.getString("college_name");
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage-courses.jsp?error=course_failed"
        );
        return;
    }

    if (!courseFound) {

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage-courses.jsp?error=course_not_found"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit Course - UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
            rel="stylesheet">

    <!-- Dashboard CSS -->
    <link
            rel="stylesheet"
            href="<%= request.getContextPath() %>/css/dashboard.css">

</head>

<body>

<!-- ================= NAVBAR ================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
                class="btn sidebar-toggle d-lg-none me-2"
                type="button"
                data-bs-toggle="offcanvas"
                data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>

        <a
                class="navbar-brand d-flex align-items-center"
                href="<%= request.getContextPath() %>/admin/dashboard.jsp">

            <span class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </span>

            <span class="brand-text">
                UDOM
                <small>Online Quiz System</small>
            </span>

        </a>

        <div class="ms-auto d-flex align-items-center">

            <!-- Notification -->

            <button
                    class="btn notification-btn position-relative me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    3
                </span>

            </button>

            <!-- Profile -->

            <div class="dropdown">

                <button
                        class="btn profile-button dropdown-toggle"
                        type="button"
                        data-bs-toggle="dropdown">

                    <span class="student-avatar">
                        SA
                    </span>

                    <span class="student-name d-none d-md-inline">
                        System Administrator
                    </span>

                </button>

                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a
                                class="dropdown-item"
                                href="<%= request.getContextPath() %>/admin/profile.jsp">

                            <i class="bi bi-person me-2"></i>
                            Profile

                        </a>
                    </li>

                    <li>
                        <a
                                class="dropdown-item"
                                href="<%= request.getContextPath() %>/admin/settings.jsp">

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


<!-- ================= SIDEBAR ================= -->

<div
        class="offcanvas-lg offcanvas-start student-sidebar"
        tabindex="-1"
        id="adminSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            UDOM Online Quiz System
        </h5>

        <button
                type="button"
                class="btn-close"
                data-bs-dismiss="offcanvas">
        </button>

    </div>

    <div class="sidebar-content">

        <div class="sidebar-profile">

            <div class="student-avatar">
                SA
            </div>

            <div>

                <h6>
                    System Administrator
                </h6>

                <small>
                    Administrator
                </small>

            </div>

        </div>


        <div class="sidebar-menu">

            <div class="menu-title">
                MAIN MENU
            </div>

            <a
                    href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                    class="sidebar-link">

                <i class="bi bi-speedometer2"></i>
                Dashboard

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/create-teacher.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-plus"></i>
                Create Teacher

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-teachers.jsp"
                    class="sidebar-link">

                <i class="bi bi-people"></i>
                Manage Teachers

            </a>


            <div class="menu-title mt-4">
                ACADEMIC MANAGEMENT
            </div>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-courses.jsp"
                    class="sidebar-link active">

                <i class="bi bi-book"></i>
                Colleges & Courses

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/assign-courses.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-workspace"></i>
                Assign Courses

            </a>


            <div class="menu-title mt-4">
                STUDENTS & QUIZZES
            </div>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-students.jsp"
                    class="sidebar-link">

                <i class="bi bi-mortarboard"></i>
                Manage Students

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-quizzes.jsp"
                    class="sidebar-link">

                <i class="bi bi-ui-checks"></i>
                Manage Quizzes

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/results.jsp"
                    class="sidebar-link">

                <i class="bi bi-bar-chart"></i>
                Results

            </a>


            <div class="menu-title mt-4">
                SYSTEM
            </div>

            <a
                    href="<%= request.getContextPath() %>/admin/reports.jsp"
                    class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>
                Reports

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/profile.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-circle"></i>
                Profile

            </a>

            <a
                    href="<%= request.getContextPath() %>/admin/settings.jsp"
                    class="sidebar-link">

                <i class="bi bi-gear"></i>
                Settings

            </a>

        </div>


        <div class="sidebar-bottom">

            <a
                    href="<%= request.getContextPath() %>/logout"
                    class="sidebar-link logout-link">

                <i class="bi bi-box-arrow-right"></i>
                Logout

            </a>

        </div>

    </div>

</div>


<!-- ================= MAIN CONTENT ================= -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <!-- Header -->

        <div class="welcome-section mb-4">

            <div>

                <div class="welcome-label">
                    ACADEMIC MANAGEMENT
                </div>

                <h1>
                    Edit Course
                </h1>

                <p>
                    Update course information and academic assignment.
                </p>

            </div>

            <div>

                <a
                        href="<%= request.getContextPath() %>/admin/manage-courses.jsp"
                        class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left me-1"></i>
                    Back to Courses

                </a>

            </div>

        </div>


        <!-- Course Information -->

        <div class="content-card mb-4">

            <div class="card-header-custom">

                <div>

                    <h5>
                        <i class="bi bi-book me-2"></i>
                        Course Information
                    </h5>

                    <p>
                        Update the details of this course.
                    </p>

                </div>

            </div>


            <div class="p-4">

                <!-- Academic hierarchy -->

                <div class="alert alert-light border mb-4">

                    <div class="row">

                        <div class="col-md-4">

                            <strong>
                                College
                            </strong>

                            <div class="mt-1">
                                <%= collegeName %>
                            </div>

                        </div>

                        <div class="col-md-4">

                            <strong>
                                Programme
                            </strong>

                            <div class="mt-1">
                                <%= programmeName %>
                            </div>

                        </div>

                        <div class="col-md-4">

                            <strong>
                                Current Year
                            </strong>

                            <div class="mt-1">
                                Year <%= yearOfStudy %>
                            </div>

                        </div>

                    </div>

                </div>


                <form
                        action="<%= request.getContextPath() %>/updateCourse"
                        method="post">

                    <input
                            type="hidden"
                            name="courseId"
                            value="<%= courseId %>">


                    <div class="row g-4">


                        <!-- Programme -->

                        <div class="col-md-6">

                            <label
                                    for="programmeId"
                                    class="form-label">

                                Programme

                            </label>

                            <select
                                    class="form-select"
                                    id="programmeId"
                                    name="programmeId"
                                    required>

                                <option
                                        value="<%= programmeId %>"
                                        selected>

                                    <%= programmeName %>

                                </option>

                            </select>

                            <div class="form-text">

                                The current programme is shown above.
                                Programme management can be changed from the academic management page.

                            </div>

                        </div>


                        <!-- Year -->

                        <div class="col-md-6">

                            <label
                                    for="yearOfStudy"
                                    class="form-label">

                                Year of Study

                            </label>

                            <select
                                    class="form-select"
                                    id="yearOfStudy"
                                    name="yearOfStudy"
                                    required>

                                <option
                                        value="1"
                                        <%= yearOfStudy == 1 ? "selected" : "" %>>

                                    Year 1

                                </option>

                                <option
                                        value="2"
                                        <%= yearOfStudy == 2 ? "selected" : "" %>>

                                    Year 2

                                </option>

                                <option
                                        value="3"
                                        <%= yearOfStudy == 3 ? "selected" : "" %>>

                                    Year 3

                                </option>

                                <option
                                        value="4"
                                        <%= yearOfStudy == 4 ? "selected" : "" %>>

                                    Year 4

                                </option>

                            </select>

                        </div>


                        <!-- Course Code -->

                        <div class="col-md-6">

                            <label
                                    for="courseCode"
                                    class="form-label">

                                Course Code

                            </label>

                            <input
                                    type="text"
                                    class="form-control"
                                    id="courseCode"
                                    name="courseCode"
                                    value="<%= courseCode %>"
                                    placeholder="e.g. CS 111"
                                    required>

                        </div>


                        <!-- Course Name -->

                        <div class="col-md-6">

                            <label
                                    for="courseName"
                                    class="form-label">

                                Course Name

                            </label>

                            <input
                                    type="text"
                                    class="form-control"
                                    id="courseName"
                                    name="courseName"
                                    value="<%= courseName %>"
                                    placeholder="e.g. Introduction to Computer Programming"
                                    required>

                        </div>


                    </div>


                    <!-- Buttons -->

                    <div
                            class="d-flex justify-content-end gap-2 mt-4 pt-4 border-top">

                        <a
                                href="<%= request.getContextPath() %>/admin/manage-courses.jsp"
                                class="btn btn-outline-secondary">

                            Cancel

                        </a>

                        <button
                                type="submit"
                                class="btn btn-primary">

                            <i class="bi bi-check-circle me-1"></i>
                            Update Course

                        </button>

                    </div>

                </form>

            </div>

        </div>


        <!-- Important Information -->

        <div class="content-card">

            <div class="card-header-custom">

                <div>

                    <h5>
                        <i class="bi bi-info-circle me-2"></i>
                        Course Management
                    </h5>

                </div>

            </div>

            <div class="p-4">

                <div class="row g-4">

                    <div class="col-md-4">

                        <div class="quiz-item">

                            <div class="quiz-icon">
                                <i class="bi bi-building"></i>
                            </div>

                            <div class="quiz-information">

                                <h6>
                                    College
                                </h6>

                                <p>
                                    Courses belong to a programme,
                                    and programmes belong to colleges.
                                </p>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-4">

                        <div class="quiz-item">

                            <div class="quiz-icon">
                                <i class="bi bi-diagram-3"></i>
                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Programme
                                </h6>

                                <p>
                                    Each course is associated with
                                    a specific academic programme.
                                </p>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-4">

                        <div class="quiz-item">

                            <div class="quiz-icon">
                                <i class="bi bi-calendar3"></i>
                            </div>

                            <div class="quiz-information">

                                <h6>
                                    Academic Year
                                </h6>

                                <p>
                                    Courses can be assigned to
                                    Year 1 through Year 4.
                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>


    </div>

</main>


<!-- ================= FOOTER ================= -->

<footer class="dashboard-footer">

    <div class="container-fluid">

        <div class="d-flex justify-content-between align-items-center">

            <div>

                © 2026 UDOM Online Quiz System

            </div>

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

        </div>

    </div>

</footer>


<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>