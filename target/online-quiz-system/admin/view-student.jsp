<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
if (session == null
|| !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))
|| !"ADMIN".equals(session.getAttribute("userRole"))) {

    response.sendRedirect("../login.jsp");
    return;
}

String adminFirstName =
        (String) session.getAttribute("adminFirstName");

String adminLastName =
        (String) session.getAttribute("adminLastName");

String studentIdParameter = request.getParameter("id");

if (studentIdParameter == null || studentIdParameter.trim().isEmpty()) {
    response.sendRedirect("manage-students.jsp?error=invalid_student");
    return;
}

int studentId;

try {
    studentId = Integer.parseInt(studentIdParameter);
} catch (NumberFormatException e) {
    response.sendRedirect("manage-students.jsp?error=invalid_student");
    return;
}

String firstName = "";
String middleName = "";
String lastName = "";
String gender = "";
String dateOfBirth = "";
String registrationNumber = "";
String college = "";
String programme = "";
String yearOfStudy = "";
String email = "";
String phone = "";
String createdAt = "";
String updatedAt = "";

boolean studentFound = false;

String sql =
        "SELECT id, first_name, middle_name, last_name, gender, " +
        "date_of_birth, registration_number, college, programme, " +
        "year_of_study, email, phone, created_at, updated_at " +
        "FROM students WHERE id = ?";

try (Connection conn = DBConnection.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

    ps.setInt(1, studentId);

    try (ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {

            studentFound = true;

            firstName = rs.getString("first_name");
            middleName = rs.getString("middle_name");
            lastName = rs.getString("last_name");
            gender = rs.getString("gender");
            dateOfBirth = rs.getString("date_of_birth");
            registrationNumber =
                    rs.getString("registration_number");
            college = rs.getString("college");
            programme = rs.getString("programme");
            yearOfStudy =
                    String.valueOf(rs.getInt("year_of_study"));
            email = rs.getString("email");
            phone = rs.getString("phone");

            if (rs.getTimestamp("created_at") != null) {
                createdAt =
                        rs.getTimestamp("created_at").toString();
            }

            if (rs.getTimestamp("updated_at") != null) {
                updatedAt =
                        rs.getTimestamp("updated_at").toString();
            }
        }
    }

} catch (Exception e) {
    e.printStackTrace();
}

if (!studentFound) {
    response.sendError(
            HttpServletResponse.SC_NOT_FOUND,
            "Student not found"
    );
    return;
}

String fullName = firstName;

if (middleName != null && !middleName.trim().isEmpty()) {
    fullName += " " + middleName;
}

fullName += " " + lastName;

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Student Details - UDOM Online Quiz System</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
      href="../css/dashboard.css">

</head>

<body>

<!-- ================= NAVBAR ================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar">

<div class="container-fluid">

    <button
        class="btn btn-link text-white d-lg-none"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#adminSidebar">

        <i class="bi bi-list fs-4"></i>

    </button>

    <a class="navbar-brand text-white fw-bold"
       href="dashboard.jsp">

        <i class="bi bi-mortarboard-fill me-2"></i>

        UDOM
        <span class="fw-normal">
            / Online Quiz System
        </span>

    </a>

    <div class="d-flex align-items-center ms-auto">

        <button class="btn btn-link text-white position-relative me-3">

            <i class="bi bi-bell fs-5"></i>

            <span class="position-absolute top-0 start-100
                         translate-middle badge rounded-pill bg-danger">

                4

            </span>

        </button>

        <div class="dropdown">

            <button
                class="btn btn-link text-white dropdown-toggle
                       text-decoration-none"
                data-bs-toggle="dropdown">

                <span class="dashboard-avatar me-2">

                    <%= adminFirstName != null
                            ? adminFirstName.substring(0, 1).toUpperCase()
                            : "A" %>

                </span>

                <span class="d-none d-md-inline">

                    <%= adminFirstName != null
                            ? adminFirstName
                            : "Admin" %>

                    <%= adminLastName != null
                            ? adminLastName
                            : "" %>

                </span>

            </button>

            <ul class="dropdown-menu dropdown-menu-end">

                <li>
                    <a class="dropdown-item"
                       href="dashboard.jsp">

                        <i class="bi bi-speedometer2 me-2"></i>
                        Dashboard

                    </a>
                </li>

                <li>
                    <hr class="dropdown-divider">
                </li>

                <li>
                    <a class="dropdown-item"
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

<!-- ================= SIDEBAR ================= -->

<div class="offcanvas-lg offcanvas-start student-sidebar"
     tabindex="-1"
     id="adminSidebar">

<div class="offcanvas-header d-lg-none">

    <h5 class="offcanvas-title">

        <i class="bi bi-mortarboard-fill me-2"></i>
        UDOM

    </h5>

    <button
        type="button"
        class="btn-close"
        data-bs-dismiss="offcanvas">
    </button>

</div>

<div class="sidebar-profile">

    <div class="sidebar-avatar">

        <%= adminFirstName != null
                ? adminFirstName.substring(0, 1).toUpperCase()
                : "A" %>

    </div>

    <div>

        <h6 class="mb-0">

            <%= adminFirstName != null
                    ? adminFirstName
                    : "Admin" %>

            <%= adminLastName != null
                    ? adminLastName
                    : "" %>

        </h6>

        <small>Administrator</small>

    </div>

</div>


<div class="sidebar-menu">

    <div class="sidebar-menu-title">
        MAIN MENU
    </div>

    <a href="dashboard.jsp"
       class="sidebar-link">

        <i class="bi bi-speedometer2"></i>
        Dashboard

    </a>


    <div class="sidebar-menu-title mt-3">
        USER MANAGEMENT
    </div>

    <a href="manage-students.jsp"
       class="sidebar-link active">

        <i class="bi bi-people"></i>
        Manage Students

    </a>

    <a href="manage-teachers.jsp"
       class="sidebar-link">

        <i class="bi bi-person-badge"></i>
        Manage Teachers

    </a>


    <div class="sidebar-menu-title mt-3">
        ACADEMIC MANAGEMENT
    </div>

    <a href="assign-courses.jsp"
       class="sidebar-link">

        <i class="bi bi-journal-bookmark"></i>
        Assign Courses

    </a>


    <div class="sidebar-menu-title mt-3">
        QUIZ MANAGEMENT
    </div>

    <a href="quizzes.jsp"
       class="sidebar-link">

        <i class="bi bi-question-circle"></i>
        Manage Quizzes

    </a>


    <a href="reports.jsp"
       class="sidebar-link">

        <i class="bi bi-bar-chart"></i>
        Reports

    </a>


    <div class="sidebar-menu-title mt-3">
        SYSTEM
    </div>

    <a href="../logout"
       class="sidebar-link">

        <i class="bi bi-box-arrow-right"></i>
        Logout

    </a>

</div>

</div>

<!-- ================= MAIN CONTENT ================= -->

<main class="dashboard-main">

<div class="dashboard-container">


    <!-- HEADER -->

    <div class="welcome-section mb-4">

        <div>

            <div class="text-muted small mb-1">
                USER MANAGEMENT
            </div>

            <h2 class="fw-bold mb-1">
                Student Details
            </h2>

            <p class="text-muted mb-0">
                View complete information about this student.
            </p>

        </div>

        <div class="d-flex gap-2 mt-3 mt-md-0">

            <a href="manage-students.jsp"
               class="btn btn-outline-secondary">

                <i class="bi bi-arrow-left me-1"></i>
                Back

            </a>

            <a href="edit-student.jsp?id=<%= studentId %>"
               class="btn btn-primary">

                <i class="bi bi-pencil-square me-1"></i>
                Edit Student

            </a>

        </div>

    </div>


    <% if ("success".equals(request.getParameter("updated"))) { %>

        <div class="alert alert-success alert-dismissible fade show">

            <i class="bi bi-check-circle me-2"></i>

            Student information has been updated successfully.

            <button type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>

    <% } %>


    <!-- STUDENT PROFILE -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div class="d-flex align-items-center">

                <div class="quiz-icon me-3">

                    <i class="bi bi-person-fill"></i>

                </div>

                <div>

                    <h5 class="mb-1 fw-bold">
                        <%= fullName %>
                    </h5>

                    <p class="text-muted mb-0">

                        <%= registrationNumber %>

                    </p>

                </div>

            </div>

        </div>


        <div class="p-4">

            <div class="row g-4">


                <!-- PERSONAL INFORMATION -->

                <div class="col-lg-6">

                    <div class="border rounded-3 p-4 h-100">

                        <h6 class="fw-bold mb-4">

                            <i class="bi bi-person me-2 text-primary"></i>

                            Personal Information

                        </h6>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                First Name
                            </small>

                            <strong>
                                <%= firstName %>
                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Middle Name
                            </small>

                            <strong>

                                <%= middleName != null
                                        && !middleName.trim().isEmpty()
                                        ? middleName
                                        : "—" %>

                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Last Name
                            </small>

                            <strong>
                                <%= lastName %>
                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Gender
                            </small>

                            <strong>
                                <%= gender %>
                            </strong>

                        </div>


                        <div>

                            <small class="text-muted d-block">
                                Date of Birth
                            </small>

                            <strong>
                                <%= dateOfBirth %>
                            </strong>

                        </div>

                    </div>

                </div>


                <!-- ACADEMIC INFORMATION -->

                <div class="col-lg-6">

                    <div class="border rounded-3 p-4 h-100">

                        <h6 class="fw-bold mb-4">

                            <i class="bi bi-mortarboard me-2 text-primary"></i>

                            Academic Information

                        </h6>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Registration Number
                            </small>

                            <strong>
                                <%= registrationNumber %>
                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                College
                            </small>

                            <strong>
                                <%= college %>
                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Programme
                            </small>

                            <strong>
                                <%= programme %>
                            </strong>

                        </div>


                        <div>

                            <small class="text-muted d-block">
                                Year of Study
                            </small>

                            <strong>
                                Year <%= yearOfStudy %>
                            </strong>

                        </div>

                    </div>

                </div>


                <!-- CONTACT INFORMATION -->

                <div class="col-lg-6">

                    <div class="border rounded-3 p-4 h-100">

                        <h6 class="fw-bold mb-4">

                            <i class="bi bi-telephone me-2 text-primary"></i>

                            Contact Information

                        </h6>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Email Address
                            </small>

                            <strong>
                                <%= email %>
                            </strong>

                        </div>


                        <div>

                            <small class="text-muted d-block">
                                Phone Number
                            </small>

                            <strong>
                                <%= phone %>
                            </strong>

                        </div>

                    </div>

                </div>


                <!-- SYSTEM INFORMATION -->

                <div class="col-lg-6">

                    <div class="border rounded-3 p-4 h-100">

                        <h6 class="fw-bold mb-4">

                            <i class="bi bi-clock-history me-2 text-primary"></i>

                            System Information

                        </h6>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Student ID
                            </small>

                            <strong>
                                #<%= studentId %>
                            </strong>

                        </div>


                        <div class="mb-3">

                            <small class="text-muted d-block">
                                Created At
                            </small>

                            <strong>
                                <%= createdAt %>
                            </strong>

                        </div>


                        <div>

                            <small class="text-muted d-block">
                                Last Updated
                            </small>

                            <strong>
                                <%= updatedAt %>
                            </strong>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <footer class="dashboard-footer">

        <p class="mb-0">
            © 2026 University of Dodoma — Online Quiz System
        </p>

    </footer>

</div>

</main>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
