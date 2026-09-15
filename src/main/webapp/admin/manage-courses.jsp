<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
Boolean adminLoggedIn =
(Boolean) session.getAttribute("adminLoggedIn");


if (adminLoggedIn == null || !adminLoggedIn) {
    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );
    return;
}

String adminFirstName =
        (String) session.getAttribute("adminFirstName");

String adminLastName =
        (String) session.getAttribute("adminLastName");

if (adminFirstName == null || adminFirstName.trim().isEmpty()) {
    adminFirstName = "Administrator";
}

if (adminLastName == null) {
    adminLastName = "";
}

int totalColleges = 0;
int totalProgrammes = 0;
int totalCourses = 0;

String success = request.getParameter("success");
String error = request.getParameter("error");

/*
 * =========================================================
 * LOAD ACADEMIC STATISTICS
 * =========================================================
 */

try (Connection connection = DBConnection.getConnection()) {

    // Total colleges
    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            "SELECT COUNT(*) FROM colleges"
                    );
            ResultSet resultSet =
                    statement.executeQuery()
    ) {

        if (resultSet.next()) {
            totalColleges = resultSet.getInt(1);
        }
    }

    // Total programmes
    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            "SELECT COUNT(*) FROM programmes"
                    );
            ResultSet resultSet =
                    statement.executeQuery()
    ) {

        if (resultSet.next()) {
            totalProgrammes = resultSet.getInt(1);
        }
    }

    // Total courses
    try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            "SELECT COUNT(*) FROM courses"
                    );
            ResultSet resultSet =
                    statement.executeQuery()
    ) {

        if (resultSet.next()) {
            totalCourses = resultSet.getInt(1);
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

<meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

<title>
    Academic Management - UDOM Online Quiz System
</title>

<!-- Bootstrap 5.3.3 -->
<link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

<!-- Bootstrap Icons -->
<link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

<!-- Dashboard CSS -->
<link
        rel="stylesheet"
        href="<%= request.getContextPath() %>/css/dashboard.css">

</head>

<body>

<!-- ========================================================= -->

<!-- NAVBAR -->

<!-- ========================================================= -->

<nav class="navbar dashboard-navbar">

<div class="container-fluid">

    <!-- Mobile Sidebar Button -->
    <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

        <i class="bi bi-list"></i>

    </button>


    <!-- Brand -->
    <a
            href="<%= request.getContextPath() %>/admin/dashboard.jsp"
            class="navbar-brand d-flex align-items-center">

        <span class="brand-icon">
            <i class="bi bi-mortarboard-fill"></i>
        </span>

        <span class="brand-text">
            UDOM / Online Quiz System
        </span>

    </a>


    <!-- Navbar Right -->
    <div class="d-flex align-items-center ms-auto">

        <!-- Notification -->
        <button
                class="notification-btn me-3"
                type="button">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                0
            </span>

        </button>


        <!-- Profile Dropdown -->
        <div class="dropdown">

            <button
                    class="btn profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false">

                <span class="student-avatar">

                    <%= adminFirstName
                            .substring(0, 1)
                            .toUpperCase() %>

                </span>

                <span class="student-name d-none d-md-inline">

                    <%= adminFirstName %>

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

                    <hr class="dropdown-divider">

                </li>

                <li>

                    <a
                            class="dropdown-item"
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

<!-- ========================================================= -->

<!-- SIDEBAR -->

<!-- ========================================================= -->

<div
        class="offcanvas-lg offcanvas-start student-sidebar"
        tabindex="-1"
        id="adminSidebar">

<!-- Mobile Sidebar Header -->
<div class="offcanvas-header">

    <h5 class="offcanvas-title">

        <i class="bi bi-mortarboard-fill me-2"></i>

        UDOM

    </h5>

    <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas"
            data-bs-target="#adminSidebar">
    </button>

</div>


<div class="sidebar-content">


    <!-- Sidebar Profile -->
    <div class="sidebar-profile">

        <div class="student-avatar">

            <%= adminFirstName
                    .substring(0, 1)
                    .toUpperCase() %>

        </div>

        <div>

            <strong>

                <%= adminFirstName %>
                <%= adminLastName %>

            </strong>

            <small>
                System Administrator
            </small>

        </div>

    </div>


    <!-- Sidebar Menu -->
    <ul class="sidebar-menu">


        <!-- MAIN -->
        <li class="menu-title">
            MAIN
        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                    class="sidebar-link">

                <i class="bi bi-speedometer2"></i>

                Dashboard

            </a>

        </li>


        <!-- USER MANAGEMENT -->
        <li class="menu-title">
            USER MANAGEMENT
        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/create-teacher.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-plus"></i>

                Create Teacher

            </a>

        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-teachers.jsp"
                    class="sidebar-link">

                <i class="bi bi-people"></i>

                Manage Teachers

            </a>

        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-students.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-lines-fill"></i>

                Manage Students

            </a>

        </li>


        <!-- ACADEMIC MANAGEMENT -->
        <li class="menu-title">
            ACADEMIC MANAGEMENT
        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-courses.jsp"
                    class="sidebar-link active">

                <i class="bi bi-building"></i>

                Colleges & Programmes

            </a>

        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/assign-courses.jsp"
                    class="sidebar-link">

                <i class="bi bi-person-check"></i>

                Assign Courses

            </a>

        </li>


        <!-- QUIZ MANAGEMENT -->
        <li class="menu-title">
            QUIZ MANAGEMENT
        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/manage-quizzes.jsp"
                    class="sidebar-link">

                <i class="bi bi-journal-text"></i>

                Manage Quizzes

            </a>

        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/results.jsp"
                    class="sidebar-link">

                <i class="bi bi-bar-chart"></i>

                Results

            </a>

        </li>


        <li>

            <a
                    href="<%= request.getContextPath() %>/admin/reports.jsp"
                    class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>

                Reports

            </a>

        </li>

    </ul>


    <!-- Sidebar Bottom -->
    <div class="sidebar-bottom">


        <a
                href="<%= request.getContextPath() %>/admin/profile.jsp"
                class="sidebar-link">

            <i class="bi bi-person-circle"></i>

            Profile

        </a>


        <a
                href="<%= request.getContextPath() %>/logout"
                class="sidebar-link logout-link">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>

    </div>

</div>

</div>

<!-- ========================================================= -->

<!-- MAIN CONTENT -->

<!-- ========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


    <!-- ================================================= -->
    <!-- HEADER -->
    <!-- ================================================= -->

    <div class="welcome-section mb-4">

        <div class="welcome-label">
            ACADEMIC MANAGEMENT
        </div>

        <h1>
            Colleges, Programmes & Courses
        </h1>

        <p>
            Manage colleges, programmes and courses used by
            the UDOM Online Quiz System.
        </p>

    </div>


    <!-- ================================================= -->
    <!-- SUCCESS ALERTS -->
    <!-- ================================================= -->

    <% if ("college_added".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            College added successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } else if ("college_deleted".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            College and its associated academic structure
            were deleted successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } else if ("programme_added".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            Programme added successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } else if ("course_added".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            Course added successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } else if ("course_updated".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            Course updated successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } else if ("course_deleted".equals(success)) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            Course deleted successfully.

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } %>


    <!-- ================================================= -->
    <!-- ERROR ALERTS -->
    <!-- ================================================= -->

    <% if ("college_exists".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            This college already exists.

        </div>

    <% } else if ("college_required".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            College name is required.

        </div>

    <% } else if ("college_not_found".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            The selected college could not be found.

        </div>

    <% } else if ("invalid_college".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Invalid college information was provided.

        </div>

    <% } else if ("college_delete_failed".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            The college could not be deleted. Check the server
            logs for more information.

        </div>

    <% } else if ("programme_exists".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            This programme already exists in the selected college.

        </div>

    <% } else if ("programme_required".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Select a college and enter a programme name.

        </div>

    <% } else if ("course_exists".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            This course code already exists in the selected programme.

        </div>

    <% } else if ("course_required".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            All course fields are required.

        </div>

    <% } else if ("invalid_course_data".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Invalid course information was provided.

        </div>

    <% } else if ("invalid_year".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Year of study must be between Year 1 and Year 4.

        </div>

    <% } else if ("invalid_programme".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            The selected programme does not exist.

        </div>

    <% } else if ("course_not_found".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            The selected course could not be found.

        </div>

    <% } else if ("course_assigned".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            This course is currently assigned to a teacher and
            cannot be deleted.

        </div>

    <% } else if ("course_used_quiz".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            This course is already being used by a quiz and
            cannot be deleted.

        </div>

    <% } else if ("course_delete_failed".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            The course could not be deleted.

        </div>

    <% } %>


    <!-- ================================================= -->
    <!-- STATISTICS -->
    <!-- ================================================= -->

    <div class="row g-4 mb-4">


        <!-- Colleges -->
        <div class="col-md-4">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-building"></i>

                </div>

                <div>

                    <span>
                        Colleges
                    </span>

                    <h3>
                        <%= totalColleges %>
                    </h3>

                </div>

            </div>

        </div>


        <!-- Programmes -->
        <div class="col-md-4">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-mortarboard"></i>

                </div>

                <div>

                    <span>
                        Programmes
                    </span>

                    <h3>
                        <%= totalProgrammes %>
                    </h3>

                </div>

            </div>

        </div>


        <!-- Courses -->
        <div class="col-md-4">

            <div class="stat-card">

                <div class="stat-icon">

                    <i class="bi bi-book"></i>

                </div>

                <div>

                    <span>
                        Courses
                    </span>

                    <h3>
                        <%= totalCourses %>
                    </h3>

                </div>

            </div>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- REGISTERED COLLEGES -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>

                    <i class="bi bi-buildings-fill me-2"></i>

                    Registered Colleges

                </h4>

                <p>
                    View and manage colleges registered in
                    the system.
                </p>

            </div>

        </div>


        <div class="table-responsive">

            <table class="table align-middle">

                <thead>

                <tr>

                    <th>
                        #
                    </th>

                    <th>
                        College Name
                    </th>

                    <th>
                        Programmes
                    </th>

                    <th class="text-end">
                        Actions
                    </th>

                </tr>

                </thead>


                <tbody>

                <%
                    String registeredCollegeSql =
                            "SELECT "
                                    + "c.id, "
                                    + "c.name, "
                                    + "COUNT(p.id) AS programme_count "
                                    + "FROM colleges c "
                                    + "LEFT JOIN programmes p "
                                    + "ON c.id = p.college_id "
                                    + "GROUP BY c.id, c.name "
                                    + "ORDER BY c.name";

                    boolean hasColleges = false;

                    try (
                            Connection connection =
                                    DBConnection.getConnection();

                            PreparedStatement statement =
                                    connection.prepareStatement(
                                            registeredCollegeSql
                                    );

                            ResultSet resultSet =
                                    statement.executeQuery()
                    ) {

                        int counter = 1;

                        while (resultSet.next()) {

                            hasColleges = true;

                            int collegeId =
                                    resultSet.getInt("id");

                            String registeredCollegeName =
                                    resultSet.getString("name");

                            int programmeCount =
                                    resultSet.getInt(
                                            "programme_count"
                                    );
                %>

                <tr>

                    <td>
                        <%= counter++ %>
                    </td>

                    <td>

                        <strong>
                            <%= registeredCollegeName %>
                        </strong>

                    </td>

                    <td>

                        <span class="badge bg-secondary">

                            <%= programmeCount %>

                            Programme<%= programmeCount == 1
                                    ? ""
                                    : "s" %>

                        </span>

                    </td>

                    <td class="text-end">

                        <button
                                type="button"
                                class="btn btn-sm btn-outline-danger"
                                data-bs-toggle="modal"
                                data-bs-target="#deleteCollegeModal"
                                data-college-id="<%= collegeId %>"
                                data-college-name="<%= registeredCollegeName.replace("\"", "&quot;") %>"
                                data-programme-count="<%= programmeCount %>"
                                title="Delete College">

                            <i class="bi bi-trash"></i>

                        </button>

                    </td>

                </tr>

                <%
                        }

                        if (!hasColleges) {
                %>

                <tr>

                    <td
                            colspan="4"
                            class="text-center py-5">

                        <i
                                class="bi bi-building fs-1 text-muted">
                        </i>

                        <p
                                class="mt-3 mb-0 text-muted">

                            No colleges have been registered yet.

                        </p>

                    </td>

                </tr>

                <%
                        }

                    } catch (SQLException e) {

                        e.printStackTrace();
                %>

                <tr>

                    <td
                            colspan="4"
                            class="text-center text-danger py-4">

                        <i
                                class="bi bi-exclamation-triangle me-2">
                        </i>

                        Unable to load colleges.

                    </td>

                </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>


    <!-- ================================================= -->
    <!-- ADD COLLEGE -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>

                    <i class="bi bi-building-add me-2"></i>

                    Add New College

                </h4>

                <p>
                    Register a new college in the system.
                </p>

            </div>

        </div>


        <form
                action="<%= request.getContextPath() %>/createCollege"
                method="post">

            <div class="row g-3 align-items-end">

                <div class="col-md-9">

                    <label class="form-label">

                        College Name

                    </label>

                    <input
                            type="text"
                            name="collegeName"
                            class="form-control"
                            placeholder="Example: College of Informatics and Virtual Education"
                            required>

                </div>


                <div class="col-md-3">

                    <button
                            type="submit"
                            class="btn btn-primary w-100">

                        <i class="bi bi-plus-circle me-1"></i>

                        Add College

                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- ================================================= -->
    <!-- ADD PROGRAMME -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>

                    <i class="bi bi-mortarboard-fill me-2"></i>

                    Add New Programme

                </h4>

                <p>
                    Add a programme under an existing college.
                </p>

            </div>

        </div>


        <form
                action="<%= request.getContextPath() %>/createProgramme"
                method="post">

            <div class="row g-3">


                <!-- College -->
                <div class="col-md-6">

                    <label class="form-label">
                        College
                    </label>

                    <select
                            name="collegeId"
                            class="form-select"
                            required>

                        <option value="">
                            Select College
                        </option>

                        <%
                            String collegeSql =
                                    "SELECT id, name "
                                            + "FROM colleges "
                                            + "ORDER BY name";

                            try (
                                    Connection connection =
                                            DBConnection.getConnection();

                                    PreparedStatement statement =
                                            connection.prepareStatement(
                                                    collegeSql
                                            );

                                    ResultSet resultSet =
                                            statement.executeQuery()
                            ) {

                                while (resultSet.next()) {
                        %>

                        <option
                                value="<%= resultSet.getInt("id") %>">

                            <%= resultSet.getString("name") %>

                        </option>

                        <%
                                }

                            } catch (SQLException e) {

                                e.printStackTrace();
                            }
                        %>

                    </select>

                </div>


                <!-- Programme Name -->
                <div class="col-md-6">

                    <label class="form-label">

                        Programme Name

                    </label>

                    <input
                            type="text"
                            name="programmeName"
                            class="form-control"
                            placeholder="Example: BSc Software Engineering"
                            required>

                </div>


                <div class="col-12">

                    <button
                            type="submit"
                            class="btn btn-primary">

                        <i class="bi bi-plus-circle me-1"></i>

                        Add Programme

                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- ================================================= -->
    <!-- ADD COURSE -->
    <!-- ================================================= -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>

                    <i class="bi bi-book-fill me-2"></i>

                    Add New Course

                </h4>

                <p>
                    Add a course under a specific programme and year.
                </p>

            </div>

        </div>


        <form
                action="<%= request.getContextPath() %>/createCourse"
                method="post">

            <div class="row g-3">


                <!-- College -->
                <div class="col-md-6">

                    <label class="form-label">

                        College

                    </label>

                    <select
                            id="courseCollege"
                            class="form-select"
                            required>

                        <option value="">
                            Select College
                        </option>

                        <%
                            try (
                                    Connection connection =
                                            DBConnection.getConnection();

                                    PreparedStatement statement =
                                            connection.prepareStatement(
                                                    collegeSql
                                            );

                                    ResultSet resultSet =
                                            statement.executeQuery()
                            ) {

                                while (resultSet.next()) {
                        %>

                        <option
                                value="<%= resultSet.getInt("id") %>">

                            <%= resultSet.getString("name") %>

                        </option>

                        <%
                                }

                            } catch (SQLException e) {

                                e.printStackTrace();
                            }
                        %>

                    </select>

                </div>


                <!-- Programme -->
                <div class="col-md-6">

                    <label class="form-label">

                        Programme

                    </label>

                    <select
                            id="courseProgramme"
                            name="programmeId"
                            class="form-select"
                            disabled
                            required>

                        <option value="">
                            Select College First
                        </option>

                    </select>

                </div>


                <!-- Year -->
                <div class="col-md-4">

                    <label class="form-label">

                        Year of Study

                    </label>

                    <select
                            name="yearOfStudy"
                            class="form-select"
                            required>

                        <option value="">
                            Select Year
                        </option>

                        <option value="1">
                            Year 1
                        </option>

                        <option value="2">
                            Year 2
                        </option>

                        <option value="3">
                            Year 3
                        </option>

                        <option value="4">
                            Year 4
                        </option>

                    </select>

                </div>


                <!-- Course Code -->
                <div class="col-md-4">

                    <label class="form-label">

                        Course Code

                    </label>

                    <input
                            type="text"
                            name="courseCode"
                            class="form-control"
                            placeholder="Example: SE 211"
                            required>

                </div>


                <!-- Course Name -->
                <div class="col-md-4">

                    <label class="form-label">

                        Course Name

                    </label>

                    <input
                            type="text"
                            name="courseName"
                            class="form-control"
                            placeholder="Example: Object-Oriented Programming"
                            required>

                </div>


                <!-- Submit -->
                <div class="col-12">

                    <button
                            type="submit"
                            class="btn btn-primary">

                        <i class="bi bi-plus-circle me-1"></i>

                        Add Course

                    </button>

                </div>

            </div>

        </form>

    </div>


    <!-- ================================================= -->
    <!-- REGISTERED ACADEMIC STRUCTURE -->
    <!-- ================================================= -->

    <div class="content-card">

        <div class="card-header-custom">

            <div>

                <h4>

                    <i class="bi bi-diagram-3-fill me-2"></i>

                    Registered Academic Structure

                </h4>

                <p>
                    Colleges, programmes and their registered courses.
                </p>

            </div>

        </div>


        <div class="table-responsive">

            <table class="table align-middle">


                <!-- TABLE HEADER -->
                <thead>

                <tr>

                    <th>
                        College
                    </th>

                    <th>
                        Programme
                    </th>

                    <th>
                        Year
                    </th>

                    <th>
                        Course Code
                    </th>

                    <th>
                        Course Name
                    </th>

                    <th class="text-end">
                        Actions
                    </th>

                </tr>

                </thead>


                <!-- TABLE BODY -->
                <tbody>

                <%
                    String courseSql =
                            "SELECT "
                                    + "co.id AS course_id, "
                                    + "c.name AS college_name, "
                                    + "p.name AS programme_name, "
                                    + "co.year_of_study, "
                                    + "co.course_code, "
                                    + "co.course_name "
                                    + "FROM courses co "
                                    + "JOIN programmes p "
                                    + "ON co.programme_id = p.id "
                                    + "JOIN colleges c "
                                    + "ON p.college_id = c.id "
                                    + "ORDER BY "
                                    + "c.name, "
                                    + "p.name, "
                                    + "co.year_of_study, "
                                    + "co.course_code";

                    boolean hasCourses = false;

                    try (
                            Connection connection =
                                    DBConnection.getConnection();

                            PreparedStatement statement =
                                    connection.prepareStatement(
                                            courseSql
                                    );

                            ResultSet resultSet =
                                    statement.executeQuery()
                    ) {

                        while (resultSet.next()) {

                            hasCourses = true;

                            int courseId =
                                    resultSet.getInt("course_id");

                            String collegeName =
                                    resultSet.getString(
                                            "college_name"
                                    );

                            String programmeName =
                                    resultSet.getString(
                                            "programme_name"
                                    );

                            int year =
                                    resultSet.getInt(
                                            "year_of_study"
                                    );

                            String courseCode =
                                    resultSet.getString(
                                            "course_code"
                                    );

                            String courseName =
                                    resultSet.getString(
                                            "course_name"
                                    );
                %>


                <tr>


                    <!-- College -->
                    <td>

                        <strong>

                            <%= collegeName %>

                        </strong>

                    </td>


                    <!-- Programme -->
                    <td>

                        <%= programmeName %>

                    </td>


                    <!-- Year -->
                    <td>

                        Year <%= year %>

                    </td>


                    <!-- Course Code -->
                    <td>

                        <span class="badge bg-primary">

                            <%= courseCode %>

                        </span>

                    </td>


                    <!-- Course Name -->
                    <td>

                        <%= courseName %>

                    </td>


                    <!-- Actions -->
                    <td class="text-end">


                        <!-- EDIT -->
                        <a
                                href="<%= request.getContextPath() %>/admin/edit-course.jsp?id=<%= courseId %>"
                                class="btn btn-sm btn-outline-primary me-1"
                                title="Edit Course">

                            <i class="bi bi-pencil"></i>

                        </a>


                        <!-- DELETE -->
                        <form
                                action="<%= request.getContextPath() %>/deleteCourse"
                                method="post"
                                class="d-inline"
                                onsubmit="return confirm('Are you sure you want to delete this course?');">

                            <input
                                    type="hidden"
                                    name="courseId"
                                    value="<%= courseId %>">

                            <button
                                    type="submit"
                                    class="btn btn-sm btn-outline-danger"
                                    title="Delete Course">

                                <i class="bi bi-trash"></i>

                            </button>

                        </form>


                    </td>


                </tr>


                <%
                        }

                        if (!hasCourses) {
                %>


                <tr>

                    <td
                            colspan="6"
                            class="text-center py-5">

                        <i
                                class="bi bi-book fs-1 text-muted">
                        </i>

                        <p
                                class="mt-3 mb-0 text-muted">

                            No courses have been registered yet.

                        </p>

                    </td>

                </tr>


                <%
                        }

                    } catch (SQLException e) {

                        e.printStackTrace();
                %>


                <tr>

                    <td
                            colspan="6"
                            class="text-center text-danger py-4">

                        <i
                                class="bi bi-exclamation-triangle me-2">
                        </i>

                        Unable to load courses.

                    </td>

                </tr>


                <%
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>


</div>

</main>

<!-- ========================================================= -->

<!-- DELETE COLLEGE MODAL -->

<!-- ========================================================= -->

<div
        class="modal fade"
        id="deleteCollegeModal"
        tabindex="-1"
        aria-labelledby="deleteCollegeModalLabel"
        aria-hidden="true">

<div class="modal-dialog modal-dialog-centered">

    <div class="modal-content">


        <!-- Modal Header -->
        <div class="modal-header">

            <h5
                    class="modal-title"
                    id="deleteCollegeModalLabel">

                <i
                        class="bi bi-exclamation-triangle text-danger me-2">
                </i>

                Delete College

            </h5>

            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal">
            </button>

        </div>


        <!-- Modal Body -->
        <div class="modal-body">

            <p>
                Are you sure you want to delete:
            </p>

            <p
                    class="fw-bold"
                    id="deleteCollegeName">
            </p>


            <div
                    id="collegeDeleteWarning"
                    class="alert alert-warning">

                <i
                        class="bi bi-exclamation-triangle me-2">
                </i>

                This college has registered programmes.
                Deleting it will also delete its programmes
                and their courses.

            </div>


            <div
                    id="collegeNoProgrammeInfo"
                    class="alert alert-info d-none">

                <i
                        class="bi bi-info-circle me-2">
                </i>

                This college currently has no registered
                programmes.

            </div>


            <p class="text-danger mb-0">

                <strong>
                    This action cannot be undone.
                </strong>

            </p>

        </div>


        <!-- Modal Footer -->
        <div class="modal-footer">

            <button
                    type="button"
                    class="btn btn-secondary"
                    data-bs-dismiss="modal">

                Cancel

            </button>


            <form
                    action="<%= request.getContextPath() %>/deleteCollege"
                    method="post">

                <input
                        type="hidden"
                        name="collegeId"
                        id="deleteCollegeId">


                <button
                        type="submit"
                        class="btn btn-danger">

                    <i
                            class="bi bi-trash me-1">
                    </i>

                    Delete College

                </button>

            </form>

        </div>

    </div>

</div>

</div>

<!-- ========================================================= -->

<!-- FOOTER -->

<!-- ========================================================= -->

<footer class="dashboard-footer">

<div class="container-fluid dashboard-container">

    <div
            class="d-flex justify-content-between align-items-center">

        <span>
            © 2026 UDOM Online Quiz System
        </span>

        <div>

            <a
                    href="#"
                    class="me-3">

                Help

            </a>

            <a
                    href="#"
                    class="me-3">

                Privacy

            </a>

            <a href="#">

                Support

            </a>

        </div>

    </div>

</div>

</footer>

<!-- ========================================================= -->

<!-- BOOTSTRAP JAVASCRIPT -->

<!-- ========================================================= -->

<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- ========================================================= -->

<!-- DELETE COLLEGE MODAL SCRIPT -->

<!-- ========================================================= -->

<script>

    const deleteCollegeModal =
        document.getElementById("deleteCollegeModal");

    if (deleteCollegeModal) {

        deleteCollegeModal.addEventListener(
            "show.bs.modal",
            function (event) {

                const button =
                    event.relatedTarget;

                const collegeId =
                    button.getAttribute(
                        "data-college-id"
                    );

                const collegeName =
                    button.getAttribute(
                        "data-college-name"
                    );

                const programmeCount =
                    parseInt(
                        button.getAttribute(
                            "data-programme-count"
                        )
                    );


                /*
                 * Set college ID
                 */

                document.getElementById(
                    "deleteCollegeId"
                ).value = collegeId;


                /*
                 * Set college name
                 */

                document.getElementById(
                    "deleteCollegeName"
                ).textContent = collegeName;


                /*
                 * Display appropriate warning
                 */

                const warning =
                    document.getElementById(
                        "collegeDeleteWarning"
                    );

                const noProgrammeInfo =
                    document.getElementById(
                        "collegeNoProgrammeInfo"
                    );


                if (programmeCount > 0) {

                    warning.classList.remove(
                        "d-none"
                    );

                    warning.innerHTML =
                        '<i class="bi bi-exclamation-triangle me-2"></i>'
                        + 'This college has <strong>'
                        + programmeCount
                        + '</strong> registered programme'
                        + (programmeCount === 1
                            ? ''
                            : 's')
                        + '. Deleting it will also delete '
                        + 'its programmes and their courses.';

                    noProgrammeInfo.classList.add(
                        "d-none"
                    );

                } else {

                    warning.classList.add(
                        "d-none"
                    );

                    noProgrammeInfo.classList.remove(
                        "d-none"
                    );

                }

            }
        );

    }

</script>

<!-- ========================================================= -->

<!-- PROGRAMME LOADING -->

<!-- ========================================================= -->

<script>

    const courseCollege =
        document.getElementById("courseCollege");

    const courseProgramme =
        document.getElementById("courseProgramme");


    if (courseCollege && courseProgramme) {

        courseCollege.addEventListener(
            "change",
            function () {

                const collegeId =
                    this.value;


                /*
                 * Reset programme dropdown
                 */

                courseProgramme.innerHTML =
                    '<option value="">Loading programmes...</option>';

                courseProgramme.disabled = true;


                /*
                 * No college selected
                 */

                if (!collegeId) {

                    courseProgramme.innerHTML =
                        '<option value="">Select College First</option>';

                    return;
                }


                /*
                 * Load programmes from servlet
                 */

                fetch(
                    "<%= request.getContextPath() %>/getProgrammes?collegeId="
                    + encodeURIComponent(collegeId)
                )

                .then(function (response) {

                    if (!response.ok) {

                        throw new Error(
                            "Unable to load programmes"
                        );

                    }

                    return response.json();

                })

                .then(function (programmes) {

                    /*
                     * Clear existing options
                     */

                    courseProgramme.innerHTML =
                        '<option value="">Select Programme</option>';


                    /*
                     * No programmes
                     */

                    if (programmes.length === 0) {

                        courseProgramme.innerHTML =
                            '<option value="">No programmes registered</option>';

                        return;
                    }


                    /*
                     * Add programmes
                     */

                    programmes.forEach(
                        function (programme) {

                            const option =
                                document.createElement(
                                    "option"
                                );

                            option.value =
                                programme.id;

                            option.textContent =
                                programme.name;

                            courseProgramme.appendChild(
                                option
                            );

                        }
                    );


                    /*
                     * Enable programme dropdown
                     */

                    courseProgramme.disabled =
                        false;

                })

                .catch(function (error) {

                    console.error(error);

                    courseProgramme.innerHTML =
                        '<option value="">Unable to load programmes</option>';

                });

            }
        );

    }

</script>

</body>

</html>
