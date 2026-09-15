<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
/*
* =========================================================
* TEACHER AUTHENTICATION
* =========================================================
*/

HttpSession teacherSession = request.getSession(false);

if (teacherSession == null ||
    teacherSession.getAttribute("teacherLoggedIn") == null ||
    !(Boolean) teacherSession.getAttribute("teacherLoggedIn") ||
    !"TEACHER".equals(teacherSession.getAttribute("userRole"))) {

    response.sendRedirect(
        request.getContextPath() + "/login.jsp"
    );

    return;
}


/*
 * =========================================================
 * GET LOGGED-IN TEACHER
 * =========================================================
 */

Integer teacherId =
    (Integer) teacherSession.getAttribute("teacherId");

if (teacherId == null) {

    response.sendRedirect(
        request.getContextPath() + "/login.jsp"
    );

    return;
}


String firstName =
    (String) teacherSession.getAttribute("teacherFirstName");

String lastName =
    (String) teacherSession.getAttribute("teacherLastName");

String teacherCollege =
    (String) teacherSession.getAttribute("teacherCollege");

String teacherDepartment =
    (String) teacherSession.getAttribute("teacherDepartment");


if (firstName == null) {
    firstName = "Teacher";
}

if (lastName == null) {
    lastName = "";
}

String teacherName =
    (firstName + " " + lastName).trim();


String firstInitial =
    firstName.substring(0, 1).toUpperCase();

String lastInitial = "";

if (!lastName.isEmpty()) {
    lastInitial =
        lastName.substring(0, 1).toUpperCase();
}

String initials =
    firstInitial + lastInitial;


/*
 * =========================================================
 * COURSE STATISTICS
 * =========================================================
 */

int totalCourses = 0;
int year1Courses = 0;
int year2Courses = 0;
int year3Courses = 0;
int year4Courses = 0;


String countSql =
    "SELECT "
    + "COUNT(*) AS total_courses, "
    + "COUNT(*) FILTER (WHERE c.year_of_study = 1) AS year1, "
    + "COUNT(*) FILTER (WHERE c.year_of_study = 2) AS year2, "
    + "COUNT(*) FILTER (WHERE c.year_of_study = 3) AS year3, "
    + "COUNT(*) FILTER (WHERE c.year_of_study = 4) AS year4 "
    + "FROM teacher_courses tc "
    + "JOIN courses c ON tc.course_id = c.id "
    + "WHERE tc.teacher_id = ?";


try (
    Connection connection =
        DBConnection.getConnection();

    PreparedStatement statement =
        connection.prepareStatement(countSql)
) {

    statement.setInt(1, teacherId);

    try (ResultSet rs =
             statement.executeQuery()) {

        if (rs.next()) {

            totalCourses =
                rs.getInt("total_courses");

            year1Courses =
                rs.getInt("year1");

            year2Courses =
                rs.getInt("year2");

            year3Courses =
                rs.getInt("year3");

            year4Courses =
                rs.getInt("year4");
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

<title>
    My Courses | UDOM Online Quiz System
</title>


<!-- Bootstrap 5.3.3 -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- Bootstrap Icons -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<!-- Dashboard CSS -->

<link
    rel="stylesheet"
    href="../css/dashboard.css">

</head>

<body>

<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile Menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#teacherSidebar">

        <i class="bi bi-list"></i>

    </button>


    <!-- Brand -->

    <a
        href="dashboard.jsp"
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


    <!-- Right Side -->

    <div class="d-flex align-items-center ms-auto">


        <!-- Notification -->

        <button
            class="notification-btn me-3">

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

                    <%= initials %>

                </div>


                <div class="student-name d-none d-md-block">

                    <strong>
                        <%= teacherName %>
                    </strong>

                    <small>
                        Academic Staff
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


<!-- Mobile Header -->

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


    <!-- Teacher Profile -->

    <div class="sidebar-profile">

        <div class="sidebar-avatar">

            <%= initials %>

        </div>


        <div>

            <h6>
                <%= teacherName %>
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


        <!-- My Courses -->

        <a
            href="my-courses.jsp"
            class="sidebar-link active">

            <i class="bi bi-book-half"></i>

            <span>
                My Courses
            </span>

            <span class="menu-badge">
                <%= totalCourses %>
            </span>

        </a>


        <!-- Create Quiz -->

        <a
            href="create-quiz.jsp"
            class="sidebar-link">

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

<!-- PAGE HEADER -->

<div class="welcome-section">

    <div>

        <span class="welcome-label">
            ACADEMIC MANAGEMENT
        </span>

        <h1>
            My Courses
        </h1>

        <p>
            Courses assigned to you by the system administrator.
        </p>

    </div>


    <div class="d-flex gap-2">

        <a
            href="dashboard.jsp"
            class="btn btn-outline-secondary">

            <i class="bi bi-arrow-left me-1"></i>

            Dashboard

        </a>


        <a
            href="create-quiz.jsp"
            class="btn btn-primary">

            <i class="bi bi-plus-circle me-1"></i>

            Create Quiz

        </a>

    </div>

</div>


<!-- =====================================================
     STATISTICS
====================================================== -->

<div class="row g-4 mb-4">


    <!-- Total -->

    <div class="col-md-6 col-xl-3">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-book-fill"></i>

            </div>

            <div>

                <span>
                    Assigned Courses
                </span>

                <h2>
                    <%= totalCourses %>
                </h2>

                <small>
                    All your courses
                </small>

            </div>

        </div>

    </div>


    <!-- Year 1 -->

    <div class="col-md-6 col-xl-3">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-1-circle-fill"></i>

            </div>

            <div>

                <span>
                    Year 1
                </span>

                <h2>
                    <%= year1Courses %>
                </h2>

                <small>
                    Assigned courses
                </small>

            </div>

        </div>

    </div>


    <!-- Year 2 -->

    <div class="col-md-6 col-xl-3">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-2-circle-fill"></i>

            </div>

            <div>

                <span>
                    Year 2
                </span>

                <h2>
                    <%= year2Courses %>
                </h2>

                <small>
                    Assigned courses
                </small>

            </div>

        </div>

    </div>


    <!-- Year 3/4 -->

    <div class="col-md-6 col-xl-3">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-mortarboard-fill"></i>

            </div>

            <div>

                <span>
                    Year 3 & 4
                </span>

                <h2>
                    <%= year3Courses + year4Courses %>
                </h2>

                <small>
                    Advanced courses
                </small>

            </div>

        </div>

    </div>

</div>


<!-- =====================================================
     TEACHER INFORMATION
====================================================== -->

<div class="content-card mb-4">

    <div class="card-header-custom">

        <div>

            <h4>
                Lecturer Information
            </h4>

            <p>
                Your current academic assignment information
            </p>

        </div>

    </div>


    <div class="row g-3">


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon">

                    <i class="bi bi-person-badge-fill"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        <%= teacherName %>
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            <i class="bi bi-person"></i>
                            Lecturer
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon software-icon">

                    <i class="bi bi-building"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        <%= teacherCollege != null
                            ? teacherCollege
                            : "Not specified" %>
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            <i class="bi bi-bank"></i>
                            College
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon security-icon">

                    <i class="bi bi-diagram-3-fill"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        <%= teacherDepartment != null
                            ? teacherDepartment
                            : "Not specified" %>
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            <i class="bi bi-diagram-3"></i>
                            Department
                        </span>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>


<!-- =====================================================
     ASSIGNED COURSES
====================================================== -->

<div class="content-card">

    <div class="card-header-custom">

        <div>

            <h4>
                Assigned Courses
            </h4>

            <p>
                Courses you are authorized to teach and use when creating quizzes.
            </p>

        </div>

        <span class="badge bg-primary">
            <%= totalCourses %> Courses
        </span>

    </div>


    <div class="table-responsive">

        <table class="table align-middle">

            <thead>

            <tr>

                <th>
                    #
                </th>

                <th>
                    Course Code
                </th>

                <th>
                    Course Name
                </th>

                <th>
                    Programme
                </th>

                <th>
                    College
                </th>

                <th>
                    Year
                </th>

                <th>
                    Action
                </th>

            </tr>

            </thead>


            <tbody>


            <%
                String courseSql =
                "SELECT "
                + "c.id AS course_id, "
                + "c.course_code, "
                + "c.course_name, "
                + "c.year_of_study, "
                + "p.name AS programme_name, "
                + "col.name AS college_name "
                + "FROM teacher_courses tc "
                + "JOIN courses c ON tc.course_id = c.id "
                + "JOIN programmes p ON c.programme_id = p.id "
                + "JOIN colleges col ON p.college_id = col.id "
                + "WHERE tc.teacher_id = ? "
                + "ORDER BY c.year_of_study, c.course_code";


                boolean hasCourses = false;

                int number = 0;


                try (
                    Connection connection =
                        DBConnection.getConnection();

                    PreparedStatement statement =
                        connection.prepareStatement(courseSql)
                ) {

                    statement.setInt(1, teacherId);


                    try (
                        ResultSet rs =
                            statement.executeQuery()
                    ) {

                        while (rs.next()) {

                            hasCourses = true;

                            number++;


                            int courseId =
                                rs.getInt("course_id");

                            String courseCode =
                                rs.getString("course_code");

                            String courseName =
                                rs.getString("course_name");

                            String programmeName =
                                rs.getString("programme_name");

                            String collegeName =
                                rs.getString("college_name");

                            int year =
                                rs.getInt("year_of_study");

            %>


            <tr>

                <td>
                    <%= number %>
                </td>


                <td>

                    <strong>
                        <%= courseCode %>
                    </strong>

                </td>


                <td>

                    <%= courseName %>

                </td>


                <td>

                    <span class="badge bg-light text-dark">

                        <%= programmeName %>

                    </span>

                </td>


                <td>

                    <%= collegeName %>

                </td>


                <td>

                    <span class="badge bg-primary">

                        Year <%= year %>

                    </span>

                </td>


                <td>

                    <a
                        href="create-quiz.jsp?courseId=<%= courseId %>"
                        class="btn btn-sm btn-primary">

                        <i class="bi bi-plus-circle me-1"></i>

                        Create Quiz

                    </a>

                </td>

            </tr>


            <%
                        }
                    }

                } catch (SQLException e) {

                    e.printStackTrace();
            %>


            <tr>

                <td
                    colspan="7"
                    class="text-center text-danger py-4">

                    <i class="bi bi-exclamation-triangle me-2"></i>

                    Unable to load your assigned courses.

                </td>

            </tr>


            <%
                }


                if (!hasCourses) {
            %>


            <tr>

                <td
                    colspan="7"
                    class="text-center text-muted py-5">

                    <i
                        class="bi bi-book fs-1 d-block mb-3">
                    </i>

                    <h5>
                        No Courses Assigned
                    </h5>

                    <p class="mb-0">

                        The administrator has not assigned
                        any courses to your account yet.

                    </p>

                </td>

            </tr>


            <%
                }
            %>


            </tbody>

        </table>

    </div>

</div>


<!-- =====================================================
     INFORMATION
====================================================== -->

<div class="content-card mt-4">

    <div class="card-header-custom">

        <div>

            <h4>
                How Course Assignment Works
            </h4>

            <p>
                Your course permissions are controlled by the administrator.
            </p>

        </div>

    </div>


    <div class="row g-3">


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon">

                    <i class="bi bi-person-check-fill"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        Administrator Assignment
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Administrators assign courses to teachers.
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon software-icon">

                    <i class="bi bi-journal-plus"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        Create Quiz
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Create quizzes only for assigned courses.
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon security-icon">

                    <i class="bi bi-shield-check"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        Secure Access
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Your course assignments are linked to your teacher account.
                        </span>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>


</div>

<!-- FOOTER -->

<footer class="dashboard-footer">

<div class="container-fluid dashboard-container">

    <div class="d-flex justify-content-between align-items-center">

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

</main>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
