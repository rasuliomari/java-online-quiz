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
int yearOfStudy = 1;
String email = "";
String phone = "";

boolean studentFound = false;

String sql =
        "SELECT first_name, middle_name, last_name, gender, " +
        "date_of_birth, registration_number, college, programme, " +
        "year_of_study, email, phone " +
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
                    rs.getInt("year_of_study");

            email = rs.getString("email");

            phone = rs.getString("phone");
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

String error = request.getParameter("error");

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Edit Student - UDOM Online Quiz System</title>

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

<nav class="navbar dashboard-navbar">

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

<!-- ================= MAIN ================= -->

<main class="dashboard-main">

<div class="dashboard-container">


    <div class="welcome-section mb-4">

        <div>

            <div class="text-muted small mb-1">
                USER MANAGEMENT
            </div>

            <h2 class="fw-bold mb-1">
                Edit Student
            </h2>

            <p class="text-muted mb-0">
                Update the student's information below.
            </p>

        </div>


        <a href="view-student.jsp?id=<%= studentId %>"
           class="btn btn-outline-secondary mt-3 mt-md-0">

            <i class="bi bi-arrow-left me-1"></i>
            Cancel

        </a>

    </div>


    <% if ("duplicate".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Registration number or email already exists.

        </div>

    <% } else if ("invalid".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Please check the information you entered.

        </div>

    <% } else if ("update_failed".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Unable to update student information.

        </div>

    <% } %>


    <div class="content-card">

        <div class="card-header-custom">

            <div>

                <h5 class="mb-1 fw-bold">

                    <i class="bi bi-person-gear me-2"></i>

                    Student Information

                </h5>

                <small class="text-muted">
                    Student ID #<%= studentId %>
                </small>

            </div>

        </div>


        <div class="p-4">

            <form action="../updateStudent"
                  method="post">

                <input type="hidden"
                       name="studentId"
                       value="<%= studentId %>">


                <!-- PERSONAL INFORMATION -->

                <h6 class="fw-bold mb-3">

                    <i class="bi bi-person me-2 text-primary"></i>

                    Personal Information

                </h6>


                <div class="row g-3 mb-4">


                    <div class="col-md-4">

                        <label class="form-label">
                            First Name
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="firstName"
                            value="<%= firstName %>"
                            required>

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Middle Name
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="middleName"
                            value="<%= middleName != null ? middleName : "" %>">

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Last Name
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="lastName"
                            value="<%= lastName %>"
                            required>

                    </div>


                    <div class="col-md-6">

                        <label class="form-label">
                            Gender
                        </label>

                        <select
                            class="form-select"
                            name="gender"
                            required>

                            <option value="MALE"
                                <%= "MALE".equals(gender)
                                        ? "selected"
                                        : "" %>>

                                Male

                            </option>

                            <option value="FEMALE"
                                <%= "FEMALE".equals(gender)
                                        ? "selected"
                                        : "" %>>

                                Female

                            </option>

                        </select>

                    </div>


                    <div class="col-md-6">

                        <label class="form-label">
                            Date of Birth
                        </label>

                        <input
                            type="date"
                            class="form-control"
                            name="dateOfBirth"
                            value="<%= dateOfBirth %>"
                            required>

                    </div>

                </div>


                <hr class="my-4">


                <!-- ACADEMIC INFORMATION -->

                <h6 class="fw-bold mb-3">

                    <i class="bi bi-mortarboard me-2 text-primary"></i>

                    Academic Information

                </h6>


                <div class="row g-3 mb-4">


                    <div class="col-md-6">

                        <label class="form-label">
                            Registration Number
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="registrationNumber"
                            value="<%= registrationNumber %>"
                            required>

                    </div>


                    <div class="col-md-6">

                        <label class="form-label">
                            College
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="college"
                            value="<%= college %>"
                            required>

                    </div>


                    <div class="col-md-8">

                        <label class="form-label">
                            Programme
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="programme"
                            value="<%= programme %>"
                            required>

                    </div>


                    <div class="col-md-4">

                        <label class="form-label">
                            Year of Study
                        </label>

                        <select
                            class="form-select"
                            name="yearOfStudy"
                            required>

                            <option value="1"
                                <%= yearOfStudy == 1
                                        ? "selected"
                                        : "" %>>
                                Year 1
                            </option>

                            <option value="2"
                                <%= yearOfStudy == 2
                                        ? "selected"
                                        : "" %>>
                                Year 2
                            </option>

                            <option value="3"
                                <%= yearOfStudy == 3
                                        ? "selected"
                                        : "" %>>
                                Year 3
                            </option>

                            <option value="4"
                                <%= yearOfStudy == 4
                                        ? "selected"
                                        : "" %>>
                                Year 4
                            </option>

                        </select>

                    </div>

                </div>


                <hr class="my-4">


                <!-- CONTACT INFORMATION -->

                <h6 class="fw-bold mb-3">

                    <i class="bi bi-telephone me-2 text-primary"></i>

                    Contact Information

                </h6>


                <div class="row g-3 mb-4">


                    <div class="col-md-6">

                        <label class="form-label">
                            Email Address
                        </label>

                        <input
                            type="email"
                            class="form-control"
                            name="email"
                            value="<%= email %>"
                            required>

                    </div>


                    <div class="col-md-6">

                        <label class="form-label">
                            Phone Number
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            name="phone"
                            value="<%= phone %>"
                            required>

                    </div>

                </div>


                <!-- BUTTONS -->

                <div class="d-flex justify-content-end gap-2">

                    <a
                        href="view-student.jsp?id=<%= studentId %>"
                        class="btn btn-outline-secondary">

                        <i class="bi bi-x-circle me-1"></i>
                        Cancel

                    </a>


                    <button
                        type="submit"
                        class="btn btn-primary">

                        <i class="bi bi-check-circle me-1"></i>
                        Save Changes

                    </button>

                </div>

            </form>

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
