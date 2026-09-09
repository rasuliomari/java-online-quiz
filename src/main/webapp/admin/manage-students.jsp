<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
// =========================================================
// ADMIN AUTHENTICATION
// =========================================================

if (session == null
        || session.getAttribute("adminLoggedIn") == null
        || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))
        || !"ADMIN".equals(session.getAttribute("userRole"))) {

    response.sendRedirect("../login.jsp");
    return;
}

String adminFirstName =
        (String) session.getAttribute("adminFirstName");

String adminLastName =
        (String) session.getAttribute("adminLastName");

String adminUsername =
        (String) session.getAttribute("adminUsername");

if (adminFirstName == null || adminFirstName.trim().isEmpty()) {
    adminFirstName = "Admin";
}

if (adminLastName == null) {
    adminLastName = "";
}

if (adminUsername == null || adminUsername.trim().isEmpty()) {
    adminUsername = "Administrator";
}

String adminFullName =
        (adminFirstName + " " + adminLastName).trim();

String search = request.getParameter("search");

if (search == null) {
    search = "";
}

search = search.trim();

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

int studentCount = 0;

try {
    conn = DBConnection.getConnection();

    // -----------------------------------------------------
    // Count students
    // -----------------------------------------------------

    String countSql =
            "SELECT COUNT(*) FROM students";

    ps = conn.prepareStatement(countSql);
    rs = ps.executeQuery();

    if (rs.next()) {
        studentCount = rs.getInt(1);
    }

    rs.close();
    ps.close();

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
    if (ps != null) try { ps.close(); } catch (Exception ignored) {}
    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
}


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

<!-- =========================================================
     TOP NAVBAR
     ========================================================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

<div class="container-fluid">

    <!-- Mobile Sidebar Button -->
    <button
        class="btn btn-outline-primary d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#adminSidebar">

        <i class="bi bi-list"></i>

    </button>

    <!-- Brand -->
    <a class="navbar-brand d-flex align-items-center"
       href="dashboard.jsp">

        <i class="bi bi-mortarboard-fill me-2"></i>

        <div>
            <strong>UDOM</strong>
            <small class="d-block">
                Online Quiz System
            </small>
        </div>

    </a>


    <!-- Right Side -->
    <div class="d-flex align-items-center ms-auto">

        <!-- Notifications -->
        <button
            class="btn btn-light position-relative me-3"
            type="button">

            <i class="bi bi-bell-fill"></i>

            <span
                class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">

                4

            </span>

        </button>


        <!-- Profile -->
        <div class="dropdown">

            <button
                class="btn btn-light dropdown-toggle d-flex align-items-center"
                type="button"
                data-bs-toggle="dropdown">

                <span class="student-avatar me-2">

                    <%= adminFirstName.substring(0, 1).toUpperCase() %>

                </span>

                <div class="text-start">

                    <strong>
                        <%= adminFullName %>
                    </strong>

                    <small class="d-block text-muted">
                        System Administrator
                    </small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end">

                <li>
                    <a class="dropdown-item" href="#">
                        <i class="bi bi-person me-2"></i>
                        My Profile
                    </a>
                </li>

                <li>
                    <a class="dropdown-item" href="#">
                        <i class="bi bi-gear me-2"></i>
                        Settings
                    </a>
                </li>

                <li>
                    <hr class="dropdown-divider">
                </li>

                <li>
                    <a class="dropdown-item text-danger"
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


<div class="offcanvas-body p-0">

    <!-- Sidebar Profile -->
    <div class="sidebar-profile">

        <div class="student-avatar">

            <%= adminFirstName.substring(0, 1).toUpperCase() %>

        </div>

        <div>

            <strong>
                <%= adminFullName %>
            </strong>

            <small>
                Administrator
            </small>

        </div>

    </div>


    <!-- Main Menu -->
    <div class="sidebar-section">

        <div class="sidebar-heading">
            MAIN MENU
        </div>


        <a href="dashboard.jsp"
           class="sidebar-link">

            <i class="bi bi-speedometer2"></i>

            <span>Dashboard</span>

        </a>


        <a href="create-teacher.jsp"
           class="sidebar-link">

            <i class="bi bi-person-plus-fill"></i>

            <span>Create Teacher</span>

        </a>


        <a href="<%= request.getContextPath() %>/admin/manage-teachers.jsp"
           class="sidebar-link">

            <i class="bi bi-people-fill"></i>

            <span>Manage Teachers</span>

        </a>


        <a href="manage-students.jsp"
           class="sidebar-link active">

            <i class="bi bi-mortarboard-fill"></i>

            <span>Manage Students</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-journal-text"></i>

            <span>Manage Quizzes</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>Student Results</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-file-earmark-bar-graph-fill"></i>

            <span>Reports</span>

        </a>

    </div>


    <!-- Account -->
    <div class="sidebar-section">

        <div class="sidebar-heading">
            ACCOUNT
        </div>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-person-circle"></i>

            <span>My Profile</span>

        </a>


        <a href="#"
           class="sidebar-link">

            <i class="bi bi-gear-fill"></i>

            <span>Settings</span>

        </a>

    </div>


    <!-- Logout -->
    <div class="sidebar-bottom">

        <a href="../logout"
           class="sidebar-link text-danger">

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


    <!-- Page Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">

        <div>

            <div class="text-primary fw-semibold small">
                ADMINISTRATION
            </div>

            <h2 class="fw-bold mb-1">
                Manage Students
            </h2>

            <p class="text-muted mb-0">
                View, search and manage students registered in the system.
            </p>

        </div>


        <div class="mt-3 mt-md-0">

            <div class="stat-card px-4 py-3">

                <div class="d-flex align-items-center">

                    <div class="me-3">

                        <i class="bi bi-mortarboard-fill fs-2 text-primary"></i>

                    </div>

                    <div>

                        <small class="text-muted">
                            Total Students
                        </small>

                        <h4 class="fw-bold mb-0">
                            <%= studentCount %>
                        </h4>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         SEARCH CARD
         ================================================= -->

    <div class="content-card mb-4">

        <div class="card-body">

            <form
                method="get"
                action="manage-students.jsp">

                <div class="row g-3 align-items-end">

                    <div class="col-md-10">

                        <label class="form-label fw-semibold">
                            Search Students
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-search"></i>
                            </span>

                            <input
                                type="text"
                                name="search"
                                class="form-control"
                                placeholder="Search by name, registration number or email..."
                                value="<%= search %>">

                        </div>

                    </div>


                    <div class="col-md-2">

                        <button
                            type="submit"
                            class="btn btn-primary w-100">

                            <i class="bi bi-search me-1"></i>
                            Search

                        </button>

                    </div>

                </div>

            </form>

        </div>

    </div>


    <!-- =================================================
         STUDENTS TABLE
         ================================================= -->

    <div class="content-card">

        <div class="card-header bg-transparent border-0 p-4">

            <div class="d-flex justify-content-between align-items-center">

                <div>

                    <h5 class="fw-bold mb-1">
                        Registered Students
                    </h5>

                    <p class="text-muted mb-0">
                        Student accounts currently registered in the system.
                    </p>

                </div>

                <span class="badge bg-primary rounded-pill">

                    <%= studentCount %> Students

                </span>

            </div>

        </div>


        <div class="card-body p-0">

            <div class="table-responsive">

                <table class="table table-hover align-middle mb-0">

                    <thead class="table-light">

                        <tr>

                            <th class="ps-4">
                                #
                            </th>

                            <th>
                                Student
                            </th>

                            <th>
                                Registration Number
                            </th>

                            <th>
                                Gender
                            </th>

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
                                Email
                            </th>

                            <th>
                                Phone
                            </th>

                            <th class="text-center">
                                Action
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                    <%
                        conn = null;
                        ps = null;
                        rs = null;

                        int number = 1;

                        try {

                            conn = DBConnection.getConnection();

                            String sql =
                                "SELECT id, first_name, middle_name, last_name, " +
                                "gender, date_of_birth, registration_number, " +
                                "college, programme, year_of_study, email, phone " +
                                "FROM students ";

                            if (!search.isEmpty()) {

                                sql +=
                                    "WHERE LOWER(first_name) LIKE LOWER(?) " +
                                    "OR LOWER(middle_name) LIKE LOWER(?) " +
                                    "OR LOWER(last_name) LIKE LOWER(?) " +
                                    "OR LOWER(registration_number) LIKE LOWER(?) " +
                                    "OR LOWER(email) LIKE LOWER(?) ";

                            }

                            sql +=
                                "ORDER BY created_at DESC";

                            ps = conn.prepareStatement(sql);

                            if (!search.isEmpty()) {

                                String keyword = "%" + search + "%";

                                ps.setString(1, keyword);
                                ps.setString(2, keyword);
                                ps.setString(3, keyword);
                                ps.setString(4, keyword);
                                ps.setString(5, keyword);

                            }

                            rs = ps.executeQuery();


                            while (rs.next()) {

                                int studentId =
                                        rs.getInt("id");

                                String firstName =
                                        rs.getString("first_name");

                                String middleName =
                                        rs.getString("middle_name");

                                String lastName =
                                        rs.getString("last_name");

                                String gender =
                                        rs.getString("gender");

                                String registrationNumber =
                                        rs.getString("registration_number");

                                String college =
                                        rs.getString("college");

                                String programme =
                                        rs.getString("programme");

                                int year =
                                        rs.getInt("year_of_study");

                                String email =
                                        rs.getString("email");

                                String phone =
                                        rs.getString("phone");

                                String fullName =
                                        firstName +
                                        (middleName != null && !middleName.trim().isEmpty()
                                                ? " " + middleName
                                                : "") +
                                        " " +
                                        lastName;
                    %>

                        <tr>

                            <td class="ps-4 fw-semibold">
                                <%= number++ %>
                            </td>


                            <td>

                                <div class="d-flex align-items-center">

                                    <div class="student-avatar me-2">

                                        <%= firstName.substring(0, 1).toUpperCase() %>

                                    </div>

                                    <div>

                                        <strong>
                                            <%= fullName %>
                                        </strong>

                                        <small class="d-block text-muted">
                                            Student
                                        </small>

                                    </div>

                                </div>

                            </td>


                            <td>

                                <span class="fw-semibold">
                                    <%= registrationNumber %>
                                </span>

                            </td>


                            <td>

                                <span class="badge bg-light text-dark border">

                                    <%= gender %>

                                </span>

                            </td>


                            <td>
                                <%= college %>
                            </td>


                            <td>
                                <%= programme %>
                            </td>


                            <td>

                                <span class="badge bg-primary-subtle text-primary">

                                    Year <%= year %>

                                </span>

                            </td>


                            <td>
                                <%= email %>
                            </td>


                            <td>
                                <%= phone %>
                            </td>


                            <td class="text-center">

                                <button
                                    type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteStudentModal<%= studentId %>">

                                    <i class="bi bi-trash3"></i>

                                </button>


                                <!-- Delete Confirmation Modal -->

                                <div
                                    class="modal fade"
                                    id="deleteStudentModal<%= studentId %>"
                                    tabindex="-1">

                                    <div class="modal-dialog modal-dialog-centered">

                                        <div class="modal-content">

                                            <div class="modal-header">

                                                <h5 class="modal-title">
                                                    Delete Student
                                                </h5>

                                                <button
                                                    type="button"
                                                    class="btn-close"
                                                    data-bs-dismiss="modal">
                                                </button>

                                            </div>


                                            <div class="modal-body text-start">

                                                <div class="text-center mb-3">

                                                    <i class="bi bi-exclamation-triangle-fill text-danger fs-1"></i>

                                                </div>

                                                <p class="text-center">

                                                    Are you sure you want to delete

                                                    <strong>
                                                        <%= fullName %>
                                                    </strong>?

                                                </p>

                                                <p class="text-muted small text-center mb-0">

                                                    This will permanently remove the student
                                                    account and associated quiz attempts.

                                                </p>

                                            </div>


                                            <div class="modal-footer">

                                                <button
                                                    type="button"
                                                    class="btn btn-secondary"
                                                    data-bs-dismiss="modal">

                                                    Cancel

                                                </button>


                                                <form
                                                    method="post"
                                                    action="../deleteStudent">

                                                    <input
                                                        type="hidden"
                                                        name="studentId"
                                                        value="<%= studentId %>">

                                                    <button
                                                        type="submit"
                                                        class="btn btn-danger">

                                                        <i class="bi bi-trash3 me-1"></i>
                                                        Delete Student

                                                    </button>

                                                </form>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </td>

                        </tr>

                    <%
                            }

                        } catch (Exception e) {

                            e.printStackTrace();
                    %>

                        <tr>

                            <td colspan="10"
                                class="text-center py-5 text-danger">

                                <i class="bi bi-exclamation-circle fs-3 d-block mb-2"></i>

                                Unable to load students.

                            </td>

                        </tr>

                    <%
                        } finally {

                            if (rs != null)
                                try { rs.close(); } catch (Exception ignored) {}

                            if (ps != null)
                                try { ps.close(); } catch (Exception ignored) {}

                            if (conn != null)
                                try { conn.close(); } catch (Exception ignored) {}
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>


</div>


<!-- =====================================================
     FOOTER
     ===================================================== -->

<footer class="mt-5 py-4">

    <div class="dashboard-container">

        <div class="d-flex flex-wrap justify-content-between align-items-center">

            <div class="text-muted small">

                © 2026 UDOM Online Quiz System.
                University of Dodoma.

            </div>

            <div>

                <a href="#" class="text-muted small me-3">
                    Help
                </a>

                <a href="#" class="text-muted small me-3">
                    Privacy
                </a>

                <a href="#" class="text-muted small">
                    Support
                </a>

            </div>

        </div>

    </div>

</footer>

</main>

<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
