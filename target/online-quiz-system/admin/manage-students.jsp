<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
/* ============================================================
ADMIN SESSION
============================================================ */
String adminFirstName = (String) session.getAttribute("adminFirstName");
String adminLastName = (String) session.getAttribute("adminLastName");

if (adminFirstName == null || adminFirstName.trim().isEmpty()) {
adminFirstName = "Administrator";
}

if (adminLastName == null) {
adminLastName = "";
}

String adminFullName = adminFirstName + " " + adminLastName;

/* ============================================================
SEARCH AND FILTER VALUES
============================================================ */
String search = request.getParameter("search");
String gender = request.getParameter("gender");
String collegeId = request.getParameter("college");
String programmeId = request.getParameter("programme");
String yearOfStudy = request.getParameter("yearOfStudy");

if (search == null) search = "";
if (gender == null) gender = "";
if (collegeId == null) collegeId = "";
if (programmeId == null) programmeId = "";
if (yearOfStudy == null) yearOfStudy = "";

search = search.trim();
gender = gender.trim();
collegeId = collegeId.trim();
programmeId = programmeId.trim();
yearOfStudy = yearOfStudy.trim();

/* ============================================================
TOTAL STUDENTS
============================================================ */
int totalStudents = 0;

try (Connection conn = DBConnection.getConnection();
PreparedStatement ps = conn.prepareStatement(
"SELECT COUNT(*) FROM students");
ResultSet rs = ps.executeQuery()) {

if (rs.next()) {
    totalStudents = rs.getInt(1);
}

} catch (Exception e) {
e.printStackTrace();
}

/* ============================================================
BUILD FILTERED STUDENT QUERY
============================================================ */
StringBuilder studentSql = new StringBuilder();

studentSql.append(
"SELECT id, first_name, middle_name, last_name, gender, " +
"date_of_birth, registration_number, college, programme, " +
"year_of_study, email, phone " +
"FROM students s " +
"WHERE 1=1 "
);

/* SEARCH */
if (!search.isEmpty()) {

studentSql.append(
    "AND (" +
    "LOWER(s.first_name) LIKE LOWER(?) " +
    "OR LOWER(s.middle_name) LIKE LOWER(?) " +
    "OR LOWER(s.last_name) LIKE LOWER(?) " +
    "OR LOWER(s.first_name || ' ' || s.last_name) LIKE LOWER(?) " +
    "OR LOWER(s.registration_number) LIKE LOWER(?) " +
    "OR LOWER(s.email) LIKE LOWER(?) " +
    "OR LOWER(s.phone) LIKE LOWER(?)" +
    ") "
);

}

/* GENDER */
if (!gender.isEmpty()) {
studentSql.append("AND s.gender = ? ");
}

/* COLLEGE */
if (!collegeId.isEmpty()) {

studentSql.append(
    "AND EXISTS (" +
    "SELECT 1 " +
    "FROM colleges c " +
    "WHERE c.id = ? " +
    "AND s.college = c.name" +
    ") "
);

}

/* PROGRAMME */
if (!programmeId.isEmpty()) {

studentSql.append(
    "AND EXISTS (" +
    "SELECT 1 " +
    "FROM programmes p " +
    "JOIN colleges c ON c.id = p.college_id " +
    "WHERE p.id = ? " +
    "AND s.programme = p.name " +
    "AND s.college = c.name" +
    ") "
);

}

/* YEAR */
if (!yearOfStudy.isEmpty()) {
studentSql.append("AND s.year_of_study = ? ");
}

studentSql.append("ORDER BY s.id DESC");

int filteredStudents = 0;

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
   content="width=device-width, initial-scale=1.0">

<title>Manage Students | UDOM Online Quiz System</title>

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
    href="../css/dashboard.css">

</head>

<body>

<!-- ============================================================
     TOP NAVBAR
     ============================================================ -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">

<!-- Mobile Sidebar Button -->
<button
    class="btn sidebar-toggle d-lg-none me-2"
    type="button"
    data-bs-toggle="offcanvas"
    data-bs-target="#studentSidebar">

    <i class="bi bi-list"></i>

</button>


<!-- Brand -->
<a
    class="navbar-brand d-flex align-items-center"
    href="dashboard.jsp">

    <span class="brand-icon">
        <i class="bi bi-mortarboard-fill"></i>
    </span>

    <span class="brand-text">
        UDOM
        <small>Online Quiz System</small>
    </span>

</a>


<!-- Right Navbar -->
<div class="ms-auto d-flex align-items-center">

    <!-- Notification -->
    <button
        class="btn notification-btn me-3"
        type="button">

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
                <%= adminFirstName.substring(0, 1).toUpperCase() %>
            </span>

            <span class="student-name d-none d-md-inline">
                <%= adminFirstName %>
            </span>

        </button>


        <ul class="dropdown-menu dropdown-menu-end">

            <li>

                <a
                    class="dropdown-item"
                    href="#">

                    <i class="bi bi-person me-2"></i>

                    My Profile

                </a>

            </li>

            <li>

                <hr class="dropdown-divider">

            </li>

            <li>

                <a
                    class="dropdown-item"
                    href="../LogoutServlet">

                    <i class="bi bi-box-arrow-right me-2"></i>

                    Logout

                </a>

            </li>

        </ul>

    </div>

</div>

</div>

</nav>

<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="studentSidebar">

<div class="offcanvas-header d-lg-none">

<h5 class="offcanvas-title">

    <i class="bi bi-mortarboard-fill me-2"></i>

    UDOM Online Quiz System

</h5>

<button
    type="button"
    class="btn-close"
    data-bs-dismiss="offcanvas">
</button>

</div>

<div class="sidebar-content">

<!-- Sidebar Profile -->
<div class="sidebar-profile">

    <div class="student-avatar large">

        <%= adminFirstName.substring(0, 1).toUpperCase() %>

    </div>

    <div>

        <h6>
            <%= adminFullName %>
        </h6>

        <small>
            System Administrator
        </small>

    </div>

</div>


<!-- Sidebar Menu -->
<div class="sidebar-menu">

    <div class="menu-title">
        MAIN MENU
    </div>


    <a
        href="dashboard.jsp"
        class="sidebar-link">

        <i class="bi bi-speedometer2"></i>

        <span>Dashboard</span>

    </a>


    <div class="menu-title mt-4">
        MANAGEMENT
    </div>


    <a
        href="create-teacher.jsp"
        class="sidebar-link">

        <i class="bi bi-person-plus"></i>

        <span>Create Teacher</span>

    </a>


    <a
        href="manage-teachers.jsp"
        class="sidebar-link">

        <i class="bi bi-people"></i>

        <span>Manage Teachers</span>

    </a>


    <a
        href="assign-courses.jsp"
        class="sidebar-link">

        <i class="bi bi-journal-check"></i>

        <span>Assign Courses</span>

    </a>


    <a
        href="manage-students.jsp"
        class="sidebar-link active">

        <i class="bi bi-mortarboard"></i>

        <span>Manage Students</span>

    </a>


    <a
        href="manage-quizzes.jsp"
        class="sidebar-link">

        <i class="bi bi-question-circle"></i>

        <span>Manage Quizzes</span>

    </a>


    <a
        href="results.jsp"
        class="sidebar-link">

        <i class="bi bi-bar-chart"></i>

        <span>Results</span>

    </a>


    <div class="menu-title mt-4">
        SYSTEM
    </div>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-file-earmark-bar-graph"></i>

        <span>Reports</span>

    </a>


    <a
        href="#"
        class="sidebar-link">

        <i class="bi bi-gear"></i>

        <span>Settings</span>

    </a>

</div>


<!-- Sidebar Bottom -->
<div class="sidebar-bottom">

    <a
        href="../LogoutServlet"
        class="sidebar-link logout-link">

        <i class="bi bi-box-arrow-right"></i>

        <span>Logout</span>

    </a>

</div>

</div>

</div>

<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">

<!-- PAGE HEADER -->

<div
    class="welcome-section d-flex flex-wrap justify-content-between align-items-center">

    <div>

        <div class="welcome-label">
            STUDENT MANAGEMENT
        </div>

        <h1>
            Manage Students
        </h1>

        <p>
            Search, filter and manage registered students.
        </p>

    </div>


    <div class="mt-3 mt-md-0">

        <a
            href="../student-registration.jsp"
            class="btn btn-primary">

            <i class="bi bi-person-plus me-2"></i>

            Register Student

        </a>

    </div>

</div>


<!-- STAT CARD -->

<div class="row g-4 mb-4">

    <div class="col-md-6 col-xl-4">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-people-fill"></i>

            </div>

            <div>

                <h6>
                    Total Students
                </h6>

                <h3>
                    <%= totalStudents %>
                </h3>

            </div>

        </div>

    </div>

</div>


<!-- ========================================================
     SEARCH AND FILTER CARD
     ======================================================== -->

<div class="content-card mb-4">

    <div class="card-header-custom">

        <div>

            <h5 class="mb-1">

                <i class="bi bi-search me-2"></i>

                Search & Filter Students

            </h5>

            <p class="text-muted mb-0">

                Find students using the available search and filter options.

            </p>

        </div>

    </div>


    <div class="card-body">

        <form
            method="GET"
            action="manage-students.jsp">

            <div class="row g-3">


                <!-- SEARCH -->

                <div class="col-lg-5">

                    <label
                        class="form-label fw-semibold">

                        Search Student

                    </label>

                    <div class="input-group">

                        <span class="input-group-text">

                            <i class="bi bi-search"></i>

                        </span>

                        <input
                            type="text"
                            name="search"
                            class="form-control"
                            placeholder="Name, registration number, email or phone"
                            value="<%= search.replace("&", "&amp;").replace("\"", "&quot;") %>">

                    </div>

                </div>


                <!-- GENDER -->

                <div class="col-md-6 col-lg-2">

                    <label
                        class="form-label fw-semibold">

                        Gender

                    </label>

                    <select
                        name="gender"
                        class="form-select">

                        <option value="">
                            All Genders
                        </option>

                        <option
                            value="MALE"
                            <%= "MALE".equals(gender) ? "selected" : "" %>>

                            Male

                        </option>

                        <option
                            value="FEMALE"
                            <%= "FEMALE".equals(gender) ? "selected" : "" %>>

                            Female

                        </option>

                    </select>

                </div>


                <!-- YEAR -->

                <div class="col-md-6 col-lg-2">

                    <label
                        class="form-label fw-semibold">

                        Year

                    </label>

                    <select
                        name="yearOfStudy"
                        class="form-select">

                        <option value="">
                            All Years
                        </option>

                        <option
                            value="1"
                            <%= "1".equals(yearOfStudy) ? "selected" : "" %>>

                            Year 1

                        </option>

                        <option
                            value="2"
                            <%= "2".equals(yearOfStudy) ? "selected" : "" %>>

                            Year 2

                        </option>

                        <option
                            value="3"
                            <%= "3".equals(yearOfStudy) ? "selected" : "" %>>

                            Year 3

                        </option>

                        <option
                            value="4"
                            <%= "4".equals(yearOfStudy) ? "selected" : "" %>>

                            Year 4

                        </option>

                    </select>

                </div>


                <!-- BUTTONS -->

                <div class="col-lg-3 d-flex align-items-end">

                    <div class="d-flex gap-2 w-100">

                        <button
                            type="submit"
                            class="btn btn-primary flex-grow-1">

                            <i class="bi bi-search me-1"></i>

                            Search

                        </button>


                        <a
                            href="manage-students.jsp"
                            class="btn btn-outline-secondary"
                            title="Clear Filters">

                            <i class="bi bi-arrow-counterclockwise"></i>

                        </a>

                    </div>

                </div>


                <!-- COLLEGE -->

                <div class="col-md-6">

                    <label
                        class="form-label fw-semibold">

                        College

                    </label>

                    <select
                        name="college"
                        id="collegeFilter"
                        class="form-select">

                        <option value="">
                            All Colleges
                        </option>

                        <%
                        try (
                            Connection conn =
                                DBConnection.getConnection();

                            PreparedStatement ps =
                                conn.prepareStatement(
                                    "SELECT id, name " +
                                    "FROM colleges " +
                                    "ORDER BY name"
                                );

                            ResultSet rs =
                                ps.executeQuery()
                        ) {

                            while (rs.next()) {

                                int id =
                                    rs.getInt("id");

                                String name =
                                    rs.getString("name");

                        %>

                        <option
                            value="<%= id %>"
                            <%= String.valueOf(id).equals(collegeId)
                                ? "selected"
                                : "" %>>

                            <%= name %>

                        </option>

                        <%

                            }

                        } catch (Exception e) {

                            e.printStackTrace();

                        }

                        %>

                    </select>

                </div>


                <!-- PROGRAMME -->

                <div class="col-md-6">

                    <label
                        class="form-label fw-semibold">

                        Programme

                    </label>

                    <select
                        name="programme"
                        id="programmeFilter"
                        class="form-select">

                        <option value="">
                            All Programmes
                        </option>

                        <%
                        try (
                            Connection conn =
                                DBConnection.getConnection();

                            PreparedStatement ps =
                                conn.prepareStatement(
                                    "SELECT p.id, p.name, " +
                                    "c.id AS college_id, " +
                                    "c.name AS college_name " +
                                    "FROM programmes p " +
                                    "JOIN colleges c " +
                                    "ON p.college_id = c.id " +
                                    "ORDER BY c.name, p.name"
                                );

                            ResultSet rs =
                                ps.executeQuery()
                        ) {

                            while (rs.next()) {

                                int id =
                                    rs.getInt("id");

                                String name =
                                    rs.getString("name");

                                int pCollegeId =
                                    rs.getInt("college_id");

                                String pCollegeName =
                                    rs.getString("college_name");

                        %>

                        <option
                            value="<%= id %>"
                            data-college-id="<%= pCollegeId %>"
                            <%= String.valueOf(id).equals(programmeId)
                                ? "selected"
                                : "" %>>

                            <%= name %> (<%= pCollegeName %>)

                        </option>

                        <%

                            }

                        } catch (Exception e) {

                            e.printStackTrace();

                        }

                        %>

                    </select>

                </div>

            </div>

        </form>

    </div>

</div>


<!-- ========================================================
     RESULTS CARD
     ======================================================== -->

<div class="content-card">

    <div
        class="card-header-custom d-flex flex-wrap justify-content-between align-items-center">

        <div>

            <h5 class="mb-1">

                <i class="bi bi-people me-2"></i>

                Student List

            </h5>

            <p class="text-muted mb-0">

                Students matching your search and filters.

            </p>

        </div>


        <div class="mt-2 mt-md-0">

            <span class="badge bg-primary rounded-pill px-3 py-2">

                <i class="bi bi-people me-1"></i>

                <span id="studentCount">
                    Loading...
                </span>

            </span>

        </div>

    </div>


    <div class="table-responsive">

        <table
            class="table table-hover align-middle mb-0">

            <thead>

            <tr>

                <th>#</th>

                <th>Student</th>

                <th>Registration Number</th>

                <th>Gender</th>

                <th>College</th>

                <th>Programme</th>

                <th>Year</th>

                <th>Email</th>

                <th>Phone</th>

                <th>Actions</th>

            </tr>

            </thead>


            <tbody>

            <%

            int rowNumber = 1;

            try (
                Connection conn =
                    DBConnection.getConnection();

                PreparedStatement ps =
                    conn.prepareStatement(
                        studentSql.toString()
                    )
            ) {

                int parameterIndex = 1;


                /* SEARCH PARAMETERS */

                if (!search.isEmpty()) {

                    String searchPattern =
                        "%" + search + "%";

                    for (int i = 0; i < 7; i++) {

                        ps.setString(
                            parameterIndex++,
                            searchPattern
                        );

                    }

                }


                /* GENDER */

                if (!gender.isEmpty()) {

                    ps.setString(
                        parameterIndex++,
                        gender
                    );

                }


                /* COLLEGE */

                if (!collegeId.isEmpty()) {

                    ps.setInt(
                        parameterIndex++,
                        Integer.parseInt(collegeId)
                    );

                }


                /* PROGRAMME */

                if (!programmeId.isEmpty()) {

                    ps.setInt(
                        parameterIndex++,
                        Integer.parseInt(programmeId)
                    );

                }


                /* YEAR */

                if (!yearOfStudy.isEmpty()) {

                    ps.setInt(
                        parameterIndex++,
                        Integer.parseInt(yearOfStudy)
                    );

                }


                try (
                    ResultSet rs =
                        ps.executeQuery()
                ) {

                    while (rs.next()) {

                        filteredStudents++;

                        int studentId =
                            rs.getInt("id");

                        String firstName =
                            rs.getString("first_name");

                        String middleName =
                            rs.getString("middle_name");

                        String lastName =
                            rs.getString("last_name");

                        String studentGender =
                            rs.getString("gender");

                        String registrationNumber =
                            rs.getString(
                                "registration_number"
                            );

                        String studentCollege =
                            rs.getString("college");

                        String studentProgramme =
                            rs.getString("programme");

                        int studentYear =
                            rs.getInt(
                                "year_of_study"
                            );

                        String email =
                            rs.getString("email");

                        String phone =
                            rs.getString("phone");


                        String displayName =
                            firstName +
                            (
                                middleName != null &&
                                !middleName.trim().isEmpty()
                                ? " " + middleName
                                : ""
                            ) +
                            " " +
                            lastName;

            %>

            <tr>

                <!-- NUMBER -->

                <td>
                    <%= rowNumber++ %>
                </td>


                <!-- STUDENT -->

                <td>

                    <div class="d-flex align-items-center">

                        <div class="student-avatar me-2">

                            <%= firstName
                                .substring(0, 1)
                                .toUpperCase() %>

                        </div>

                        <div>

                            <div class="fw-semibold">

                                <%= displayName %>

                            </div>

                            <small class="text-muted">

                                Student ID:
                                <%= studentId %>

                            </small>

                        </div>

                    </div>

                </td>


                <!-- REGISTRATION -->

                <td>

                    <span class="fw-semibold">

                        <%= registrationNumber %>

                    </span>

                </td>


                <!-- GENDER -->

                <td>

                    <%
                    if ("MALE".equals(studentGender)) {
                    %>

                        <span
                            class="badge bg-primary-subtle text-primary">

                            Male

                        </span>

                    <%
                    } else {
                    %>

                        <span
                            class="badge bg-danger-subtle text-danger">

                            Female

                        </span>

                    <%
                    }
                    %>

                </td>


                <!-- COLLEGE -->

                <td>
                    <%= studentCollege %>
                </td>


                <!-- PROGRAMME -->

                <td>
                    <%= studentProgramme %>
                </td>


                <!-- YEAR -->

                <td>

                    <span
                        class="badge bg-secondary-subtle text-dark">

                        Year <%= studentYear %>

                    </span>

                </td>


                <!-- EMAIL -->

                <td>

                    <a
                        href="mailto:<%= email %>"
                        class="text-decoration-none">

                        <%= email %>

                    </a>

                </td>


                <!-- PHONE -->

                <td>
                    <%= phone %>
                </td>


                <!-- ACTIONS -->

                <td>

                    <div class="d-flex gap-1">


                        <!-- VIEW -->

                        <a
                            href="view-student.jsp?id=<%= studentId %>"
                            class="btn btn-sm btn-outline-primary"
                            title="View Student">

                            <i class="bi bi-eye"></i>

                        </a>


                        <!-- EDIT -->

                        <a
                            href="edit-student.jsp?id=<%= studentId %>"
                            class="btn btn-sm btn-outline-warning"
                            title="Edit Student">

                            <i class="bi bi-pencil"></i>

                        </a>


                        <!-- DELETE -->

                        

                        <button
                            type="button"
                            class="btn btn-sm btn-outline-danger"
                            title="Delete Student"
                            onclick="openDeleteModal(
                                <%= studentId %>,
                                '<%= firstName.replace("'", "\\'") %>',
                                '<%= lastName.replace("'", "\\'") %>'
                            )">

                            <i class="bi bi-trash"></i>

                        </button>

                    </div>

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
                    colspan="10"
                    class="text-center py-5">

                    <div class="text-danger">

                        <i class="bi bi-exclamation-triangle fs-2"></i>

                        <p class="mt-2 mb-0">

                            Unable to load students.

                        </p>

                    </div>

                </td>

            </tr>

            <%

            }

            if (filteredStudents == 0) {

            %>

            <tr>

                <td
                    colspan="10"
                    class="text-center py-5">

                    <div class="text-muted">

                        <i class="bi bi-search fs-1"></i>

                        <h5 class="mt-3">

                            No students found

                        </h5>

                        <p>

                            Try changing your search
                            or filter options.

                        </p>

                        <a
                            href="manage-students.jsp"
                            class="btn btn-outline-primary">

                            <i class="bi bi-arrow-counterclockwise me-1"></i>

                            Clear Filters

                        </a>

                    </div>

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

<!-- ============================================================
     DELETE MODAL
     ============================================================ -->

<div
    class="modal fade"
    id="deleteStudentModal"
    tabindex="-1"
    aria-hidden="true">

<div
    class="modal-dialog modal-dialog-centered">

<div class="modal-content">

    <div class="modal-header">

        <h5 class="modal-title">

            <i
                class="bi bi-exclamation-triangle text-danger me-2">
            </i>

            Delete Student

        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal">
        </button>

    </div>


    <div class="modal-body">

        <p>

            Are you sure you want to delete
            <strong id="deleteStudentName"></strong>?

        </p>

        <div class="alert alert-warning mb-0">

            <i class="bi bi-exclamation-circle me-2"></i>

            This action cannot be undone.

        </div>

    </div>


    <div class="modal-footer">

        <button
            type="button"
            class="btn btn-secondary"
            data-bs-dismiss="modal">

            Cancel

        </button>


        <form
            method="POST"
            action="../deleteStudent">

            <input
                type="hidden"
                name="studentId"
                id="deleteStudentId">

            <button
                type="submit"
                class="btn btn-danger">

                <i class="bi bi-trash me-1"></i>

                Delete Student

            </button>

        </form>

    </div>

</div>

</div>

</div>

<!-- ============================================================
     FOOTER
     ============================================================ -->

<footer class="dashboard-footer">

<div class="container-fluid">

<div
    class="d-flex flex-wrap justify-content-between align-items-center">

    <div>

        &copy; 2026 UDOM Online Quiz System

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

<!-- ============================================================
     BOOTSTRAP JS
     ============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- ============================================================
     JAVASCRIPT
     ============================================================ -->

<script>

/* ============================================================
   COLLEGE → PROGRAMME DEPENDENT FILTER
   ============================================================ */

document.addEventListener("DOMContentLoaded", function () {

    const collegeFilter =
        document.getElementById("collegeFilter");

    const programmeFilter =
        document.getElementById("programmeFilter");

    if (!collegeFilter || !programmeFilter) {
        return;
    }


    /*
     * Store all programme options.
     */
    const allProgrammeOptions =
        Array.from(
            programmeFilter.querySelectorAll(
                "option[data-college-id]"
            )
        ).map(function (option) {

            return {
                value: option.value,
                text: option.textContent.trim(),
                collegeId:
                    option.getAttribute(
                        "data-college-id"
                    )
            };

        });


    /*
     * Remember currently selected programme.
     */
    const selectedProgramme =
        "<%= programmeId %>";


    /*
     * Rebuild programme dropdown.
     */
    function updateProgrammeOptions() {

        const selectedCollege =
            collegeFilter.value;


        /*
         * Clear existing programme options.
         */
        programmeFilter.innerHTML = "";


        /*
         * Add All Programmes.
         */
        const allOption =
            document.createElement("option");

        allOption.value = "";

        allOption.textContent =
            "All Programmes";

        programmeFilter.appendChild(
            allOption
        );


        /*
         * Add matching programmes.
         */
        allProgrammeOptions.forEach(
            function (programme) {

                if (
                    selectedCollege === "" ||
                    programme.collegeId === selectedCollege
                ) {

                    const option =
                        document.createElement("option");

                    option.value =
                        programme.value;

                    option.textContent =
                        programme.text;

                    option.setAttribute(
                        "data-college-id",
                        programme.collegeId
                    );


                    /*
                     * Restore selected programme
                     * when it belongs to selected college.
                     */
                    if (
                        programme.value ===
                        selectedProgramme
                    ) {

                        option.selected = true;

                    }


                    programmeFilter.appendChild(
                        option
                    );

                }

            }
        );


        /*
         * If selected programme does not belong
         * to selected college, select All Programmes.
         */
        const programmeStillExists =
            Array.from(
                programmeFilter.options
            ).some(
                function (option) {
                    return (
                        option.value ===
                        selectedProgramme
                    );
                }
            );

        if (
            selectedProgramme !== "" &&
            !programmeStillExists
        ) {

            programmeFilter.value = "";

        }

    }


    /*
     * Run when page loads.
     */
    updateProgrammeOptions();


    /*
     * Run when college changes.
     */
    collegeFilter.addEventListener(
        "change",
        function () {

            /*
             * When the user manually changes
             * college, rebuild the programmes.
             */
            const selectedCollege =
                collegeFilter.value;

            programmeFilter.innerHTML = "";


            const allOption =
                document.createElement("option");

            allOption.value = "";

            allOption.textContent =
                "All Programmes";

            programmeFilter.appendChild(
                allOption
            );


            allProgrammeOptions.forEach(
                function (programme) {

                    if (
                        selectedCollege === "" ||
                        programme.collegeId ===
                        selectedCollege
                    ) {

                        const option =
                            document.createElement("option");

                        option.value =
                            programme.value;

                        option.textContent =
                            programme.text;

                        option.setAttribute(
                            "data-college-id",
                            programme.collegeId
                        );

                        programmeFilter.appendChild(
                            option
                        );

                    }

                }
            );

            programmeFilter.value = "";

        }
    );

});


/* ============================================================
   DELETE STUDENT MODAL
   ============================================================ */

function openDeleteModal(
    studentId,
    firstName,
    lastName
) {

    document.getElementById(
        "deleteStudentId"
    ).value = studentId;


    document.getElementById(
        "deleteStudentName"
    ).textContent =
        firstName + " " + lastName;


    const modalElement =
        document.getElementById(
            "deleteStudentModal"
        );


    const modal =
        new bootstrap.Modal(
            modalElement
        );


    modal.show();

}

</script>

</body>

</html>
