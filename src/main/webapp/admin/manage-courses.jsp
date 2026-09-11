<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
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

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();

    int totalCourses = 0;
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Manage Courses | UDOM Online Quiz System
</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

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

<button
    class="btn sidebar-toggle d-lg-none me-2"
    type="button"
    data-bs-toggle="offcanvas"
    data-bs-target="#adminSidebar">

    <i class="bi bi-list"></i>

</button>

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

<div class="d-flex align-items-center ms-auto">

<button
    class="notification-btn me-3"
    type="button">

    <i class="bi bi-bell"></i>

    <span class="notification-badge">
        4
    </span>

</button>

<div class="dropdown">

<button
    class="profile-button dropdown-toggle"
    type="button"
    data-bs-toggle="dropdown">

    <div class="student-avatar">
        <%= adminFirstName.substring(0,1).toUpperCase() %>
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

<ul class="dropdown-menu dropdown-menu-end shadow">

<li>
<a
    class="dropdown-item"
    href="profile.jsp">

    <i class="bi bi-person me-2"></i>
    My Profile

</a>
</li>

<li>
<a
    class="dropdown-item"
    href="settings.jsp">

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


<!-- =========================================================
     SIDEBAR
========================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">

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

<div class="sidebar-profile">

<div class="sidebar-avatar">
    <%= adminFirstName.substring(0,1).toUpperCase() %>
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


<div class="sidebar-menu">

<p class="menu-title">
    MAIN MENU
</p>

<a
    href="dashboard.jsp"
    class="sidebar-link">

    <i class="bi bi-grid-1x2-fill"></i>
    <span>Dashboard</span>

</a>

<a
    href="create-teacher.jsp"
    class="sidebar-link">

    <i class="bi bi-person-plus-fill"></i>
    <span>Create Teacher</span>

</a>

<a
    href="manage-teachers.jsp"
    class="sidebar-link">

    <i class="bi bi-people-fill"></i>
    <span>Manage Teachers</span>

</a>


<!-- NEW -->

<a
    href="manage-courses.jsp"
    class="sidebar-link active">

    <i class="bi bi-book-fill"></i>
    <span>Manage Courses</span>

</a>


<a
    href="assign-courses.jsp"
    class="sidebar-link">

    <i class="bi bi-journal-check"></i>
    <span>Assign Courses</span>

</a>

<a
    href="manage-students.jsp"
    class="sidebar-link">

    <i class="bi bi-mortarboard-fill"></i>
    <span>Manage Students</span>

</a>

<a
    href="manage-quizzes.jsp"
    class="sidebar-link">

    <i class="bi bi-journal-text"></i>
    <span>Manage Quizzes</span>

</a>

<a
    href="results.jsp"
    class="sidebar-link">

    <i class="bi bi-bar-chart-fill"></i>
    <span>Student Results</span>

</a>

<a
    href="reports.jsp"
    class="sidebar-link">

    <i class="bi bi-file-earmark-bar-graph-fill"></i>
    <span>Reports</span>

</a>


<p class="menu-title mt-4">
    ACCOUNT
</p>

<a
    href="profile.jsp"
    class="sidebar-link">

    <i class="bi bi-person-fill"></i>
    <span>My Profile</span>

</a>

<a
    href="settings.jsp"
    class="sidebar-link">

    <i class="bi bi-gear-fill"></i>
    <span>Settings</span>

</a>

</div>


<div class="sidebar-bottom">

<a
    href="<%= request.getContextPath() %>/logout"
    class="logout-link">

    <i class="bi bi-box-arrow-left"></i>
    <span>Logout</span>

</a>

</div>

</div>

</div>


<!-- =========================================================
     MAIN
========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


<div class="welcome-section">

<div>

<span class="welcome-label">
    COURSE MANAGEMENT
</span>

<h1>
    Manage Courses
</h1>

<p>
    Add and manage courses according to college,
    programme and year of study.
</p>

</div>

<div>

<a
    href="#courseForm"
    class="btn btn-primary">

    <i class="bi bi-plus-circle-fill me-2"></i>

    Add Course

</a>

</div>

</div>


<!-- =========================================================
     STATISTICS
========================================================= -->

<div class="row g-4 mb-4">

<div class="col-xl-4 col-md-6">

<div class="stat-card">

<div class="stat-icon">

<i class="bi bi-book-fill"></i>

</div>

<div>

<p>
    Total Courses
</p>

<h3>

<%
try (Connection connection =
        DBConnection.getConnection()) {

    String sql =
        "SELECT COUNT(*) FROM courses";

    try (
        PreparedStatement ps =
            connection.prepareStatement(sql);
        ResultSet rs =
            ps.executeQuery()
    ) {

        if (rs.next()) {
            totalCourses = rs.getInt(1);
        }
    }

} catch (Exception e) {
    e.printStackTrace();
}
%>

<%= totalCourses %>

</h3>

<span>
    Courses in the curriculum
</span>

</div>

</div>

</div>

</div>


<!-- =========================================================
     ADD COURSE
========================================================= -->

<div
    class="content-card mb-4"
    id="courseForm">

<div class="card-header-custom">

<div>

<h4>
    Add New Course
</h4>

<p>
    Enter the course according to its college,
    programme and year.
</p>

</div>

</div>


<form
    action="<%= request.getContextPath() %>/createCourse"
    method="post">

<div class="row g-4">


<!-- COLLEGE -->

<div class="col-md-6">

<label class="form-label">
    College
</label>

<select
    class="form-select"
    id="college"
    name="collegeId"
    required>

<option value="">
    Select College
</option>

<%
try (Connection connection =
        DBConnection.getConnection()) {

    String sql =
        "SELECT id, name " +
        "FROM colleges " +
        "ORDER BY name";

    try (
        PreparedStatement ps =
            connection.prepareStatement(sql);
        ResultSet rs =
            ps.executeQuery()
    ) {

        while (rs.next()) {
%>

<option value="<%= rs.getInt("id") %>">
    <%= rs.getString("name") %>
</option>

<%
        }
    }

} catch (Exception e) {
    e.printStackTrace();
}
%>

</select>

</div>


<!-- PROGRAMME -->

<div class="col-md-6">

<label class="form-label">
    Programme
</label>

<select
    class="form-select"
    id="programme"
    name="programmeId"
    required
    disabled>

<option value="">
    Select college first
</option>

</select>

</div>


<!-- YEAR -->

<div class="col-md-4">

<label class="form-label">
    Year of Study
</label>

<select
    class="form-select"
    name="yearOfStudy"
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


<!-- COURSE CODE -->

<div class="col-md-4">

<label class="form-label">
    Course Code
</label>

<input
    type="text"
    class="form-control"
    name="courseCode"
    placeholder="Example: CS 111"
    maxlength="50"
    required>

</div>


<!-- COURSE NAME -->

<div class="col-md-4">

<label class="form-label">
    Course Name
</label>

<input
    type="text"
    class="form-control"
    name="courseName"
    placeholder="Example: Introduction to Computer Programming"
    maxlength="200"
    required>

</div>


<!-- SUBMIT -->

<div class="col-12">

<button
    type="submit"
    class="btn btn-primary">

    <i class="bi bi-save-fill me-2"></i>

    Save Course

</button>

<a
    href="dashboard.jsp"
    class="btn btn-secondary ms-2">

    Cancel

</a>

</div>

</div>

</form>

</div>


<!-- =========================================================
     COURSE LIST
========================================================= -->

<div class="content-card">

<div class="card-header-custom">

<div>

<h4>
    Course Curriculum
</h4>

<p>
    Courses currently registered in the system.
</p>

</div>

</div>


<div class="table-responsive">

<table class="table table-hover align-middle">

<thead>

<tr>

<th>#</th>

<th>College</th>

<th>Programme</th>

<th>Year</th>

<th>Course Code</th>

<th>Course Name</th>

</tr>

</thead>

<tbody>

<%
boolean hasCourses = false;

try (Connection connection =
        DBConnection.getConnection()) {

    String sql =
        "SELECT c.id, c.course_code, c.course_name, " +
        "c.year_of_study, " +
        "p.name AS programme_name, " +
        "col.name AS college_name " +
        "FROM courses c " +
        "JOIN programmes p " +
        "ON c.programme_id = p.id " +
        "JOIN colleges col " +
        "ON p.college_id = col.id " +
        "ORDER BY col.name, p.name, " +
        "c.year_of_study, c.course_code";

    try (
        PreparedStatement ps =
            connection.prepareStatement(sql);
        ResultSet rs =
            ps.executeQuery()
    ) {

        int row = 1;

        while (rs.next()) {

            hasCourses = true;
%>

<tr>

<td>
    <%= row++ %>
</td>

<td>
    <%= rs.getString("college_name") %>
</td>

<td>
    <strong>
        <%= rs.getString("programme_name") %>
    </strong>
</td>

<td>
    Year <%= rs.getInt("year_of_study") %>
</td>

<td>
    <span class="badge text-bg-primary">
        <%= rs.getString("course_code") %>
    </span>
</td>

<td>
    <%= rs.getString("course_name") %>
</td>

</tr>

<%
        }
    }

} catch (Exception e) {

    e.printStackTrace();
%>

<tr>

<td
    colspan="6"
    class="text-center text-danger py-4">

    Unable to load courses.

</td>

</tr>

<%
}

if (!hasCourses) {
%>

<tr>

<td
    colspan="6"
    class="text-center text-muted py-5">

    <i
        class="bi bi-book fs-1 d-block mb-3">
    </i>

    No courses have been registered yet.

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

</main>


<script
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<!-- =========================================================
     PROGRAMME LOADING
========================================================= -->

<script>

document
    .getElementById("college")
    .addEventListener("change", function () {

        const collegeId = this.value;

        const programme =
            document.getElementById("programme");

        programme.innerHTML =
            '<option value="">Loading programmes...</option>';

        programme.disabled = true;

        if (!collegeId) {

            programme.innerHTML =
                '<option value="">Select college first</option>';

            return;
        }


        fetch(
            "<%= request.getContextPath() %>/getProgrammes?collegeId="
            + encodeURIComponent(collegeId)
        )

        .then(response => response.json())

        .then(data => {

            programme.innerHTML =
                '<option value="">Select Programme</option>';

            data.forEach(item => {

                const option =
                    document.createElement("option");

                option.value = item.id;

                option.textContent = item.name;

                programme.appendChild(option);

            });

            programme.disabled = false;

        })

        .catch(error => {

            console.error(error);

            programme.innerHTML =
                '<option value="">Unable to load programmes</option>';

        });

    });

</script>

</body>

</html>