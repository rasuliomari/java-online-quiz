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
 * STUDENT COUNT
 * =========================================================
 */

int totalStudents = 0;


/*
 * =========================================================
 * DATABASE CONNECTION
 * =========================================================
 */

try (Connection connection =
             DBConnection.getConnection()) {

    String countSql =
            "SELECT COUNT(*) FROM students";

    try (
        PreparedStatement statement =
                connection.prepareStatement(countSql);
        ResultSet resultSet =
                statement.executeQuery()
    ) {

        if (resultSet.next()) {

            totalStudents =
                    resultSet.getInt(1);
        }
    }

} catch (Exception e) {

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
    Manage Students | UDOM Online Quiz System
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
            class="sidebar-link active">

            <i class="bi bi-mortarboard-fill"></i>

            <span>
                Manage Students
            </span>

        </a>


        <!-- Manage Quizzes -->

        <a
            href="#"
            class="sidebar-link">

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

<!-- PAGE HEADER -->

<div class="welcome-section">

    <div>

        <span class="welcome-label">
            USER MANAGEMENT
        </span>

        <h1>
            Manage Students
        </h1>

        <p>
            View and manage student accounts registered
            in the UDOM Online Quiz System.
        </p>

    </div>


    <div>

        <a
            href="../student-registration.jsp"
            class="btn btn-primary">

            <i class="bi bi-person-plus-fill me-2"></i>

            Register Student

        </a>

    </div>

</div>



<!-- =====================================================
     STUDENT STATISTICS
====================================================== -->

<div class="row g-4 mb-4">

    <div class="col-xl-4 col-md-6">

        <div class="stat-card">

            <div class="stat-icon">

                <i class="bi bi-mortarboard-fill"></i>

            </div>


            <div>

                <p>
                    Total Students
                </p>

                <h3>
                    <%= totalStudents %>
                </h3>

                <span>
                    Registered university students
                </span>

            </div>

        </div>

    </div>

</div>



<!-- =====================================================
     STUDENT LIST
====================================================== -->

<div class="content-card">

    <div class="card-header-custom">

        <div>

            <h4>
                Student Accounts
            </h4>

            <p>
                All students currently registered in the system
            </p>

        </div>

    </div>



    <div class="table-responsive">

        <table class="table table-hover align-middle">

            <thead>

                <tr>

                    <th>#</th>

                    <th>Name</th>

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
boolean hasStudents = false;

try (Connection connection =
             DBConnection.getConnection()) {

    String studentSql =
            "SELECT id, first_name, middle_name, "
            + "last_name, gender, date_of_birth, "
            + "registration_number, college, "
            + "programme, year_of_study, "
            + "email, phone "
            + "FROM students "
            + "ORDER BY id DESC";

    try (
        PreparedStatement statement =
                connection.prepareStatement(studentSql);

        ResultSet resultSet =
                statement.executeQuery()
    ) {

        int rowNumber = 1;

        while (resultSet.next()) {

            hasStudents = true;

            int studentId =
                    resultSet.getInt("id");

            String firstName =
                    resultSet.getString("first_name");

            String middleName =
                    resultSet.getString("middle_name");

            String lastName =
                    resultSet.getString("last_name");

            String gender =
                    resultSet.getString("gender");

            String registrationNumber =
                    resultSet.getString(
                            "registration_number");

            String college =
                    resultSet.getString("college");

            String programme =
                    resultSet.getString("programme");

            int yearOfStudy =
                    resultSet.getInt("year_of_study");

            String email =
                    resultSet.getString("email");

            String phone =
                    resultSet.getString("phone");

            String fullName =
                    (firstName
                    + " "
                    + (middleName == null
                        ? ""
                        : middleName + " ")
                    + lastName).trim();

%>

                <tr>

                    <td>
                        <%= rowNumber++ %>
                    </td>


                    <td>

                        <strong>
                            <%= fullName %>
                        </strong>

                    </td>


                    <td>
                        <%= registrationNumber %>
                    </td>


                    <td>
                        <%= gender %>
                    </td>


                    <td>
                        <%= college %>
                    </td>


                    <td>
                        <%= programme %>
                    </td>


                    <td>
                        <%= yearOfStudy %>
                    </td>


                    <td>
                        <%= email %>
                    </td>


                    <td>
                        <%= phone %>
                    </td>


                    <td>

                        <div class="d-flex gap-2">


                            <!-- VIEW -->

                            <a
                                href="view-student.jsp?id=<%= studentId %>"
                                class="btn btn-sm btn-outline-success"
                                title="View Student">

                                <i class="bi bi-eye"></i>

                            </a>


                            <!-- EDIT -->

                            <a
                                href="edit-student.jsp?id=<%= studentId %>"
                                class="btn btn-sm btn-outline-primary"
                                title="Edit Student">

                                <i class="bi bi-pencil"></i>

                            </a>


                            <!-- DELETE -->

                            <form
                                action="<%= request.getContextPath() %>/deleteStudent"
                                method="post"
                                class="d-inline">

                                <input
                                    type="hidden"
                                    name="studentId"
                                    value="<%= studentId %>">


                                <button
                                    type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    title="Delete Student"
                                    onclick="openDeleteModal(
                                        '<%= studentId %>',
                                        '<%= firstName %> <%= lastName %>'
                                    )">

                                    <i class="bi bi-trash"></i>

                                </button>

                            </form>

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
                        class="text-center text-danger py-4">

                        Unable to load student accounts.

                    </td>

                </tr>

<%
}

if (!hasStudents) {

%>
                <tr>

                    <td
                        colspan="10"
                        class="text-center text-muted py-5">

                        <i
                            class="bi bi-mortarboard fs-1 d-block mb-3">
                        </i>

                        No student accounts have been registered yet.

                    </td>

                </tr>

<%
}
%>
            </tbody>

        </table>

    </div>

</div>



<!-- INFORMATION -->

<div class="content-card mt-4">

    <div class="card-header-custom">

        <div>

            <h4>
                Student Management
            </h4>

            <p>
                Available administrator functions
            </p>

        </div>

    </div>


    <div class="row g-3">


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon">

                    <i class="bi bi-eye-fill"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        View Students
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Review registered student accounts.
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon software-icon">

                    <i class="bi bi-pencil-square"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        Edit Accounts
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Update student information.
                        </span>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-md-4">

            <div class="quiz-item">

                <div class="quiz-icon security-icon">

                    <i class="bi bi-person-check-fill"></i>

                </div>

                <div class="quiz-information">

                    <h5>
                        Student Records
                    </h5>

                    <div class="quiz-meta">

                        <span>
                            Manage registered student records.
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

</main>

<!-- =========================================================
     DELETE STUDENT MODAL
========================================================= -->

<div
    class="modal fade"
    id="deleteStudentModal"
    tabindex="-1">

<div class="modal-dialog modal-dialog-centered">

    <div class="modal-content">

        <div class="modal-header">

            <h5 class="modal-title">

                Delete Student?

            </h5>

            <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal">
            </button>

        </div>


        <div class="modal-body text-center">

            <div class="delete-icon">

                <i class="bi bi-trash3"></i>

            </div>


            <p class="mt-3">

                Are you sure you want to permanently
                delete

                <strong id="deleteStudentName">
                    this student
                </strong>?

            </p>


            <div class="alert alert-warning">

                <i class="bi bi-exclamation-triangle-fill me-2"></i>

                This action cannot be undone.

            </div>


            <form
                method="post"
                action="<%= request.getContextPath() %>/deleteStudent">

                <input
                    type="hidden"
                    name="studentId"
                    id="deleteStudentId">


                <div class="d-flex justify-content-center gap-2">

                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">

                        Cancel

                    </button>


                    <button
                        type="submit"
                        class="btn btn-danger">

                        <i class="bi bi-trash3 me-1"></i>

                        Delete Permanently

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

</div>

<script>

function openDeleteModal(studentId, studentName) {

    document.getElementById("deleteStudentId").value =
        studentId;

    document.getElementById("deleteStudentName").textContent =
        studentName;

    const modalElement =
        document.getElementById("deleteStudentModal");

    const modal =
        bootstrap.Modal.getOrCreateInstance(modalElement);

    modal.show();
}

</script>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
