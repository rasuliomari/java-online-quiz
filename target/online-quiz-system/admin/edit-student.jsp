<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
/* =========================================================
ADMIN AUTHENTICATION
========================================================= */

HttpSession adminSession = request.getSession(false);

if (adminSession == null
        || !Boolean.TRUE.equals(
                adminSession.getAttribute("adminLoggedIn"))
        || !"ADMIN".equals(
                adminSession.getAttribute("userRole"))) {

    response.sendRedirect("../login.jsp");
    return;
}

String adminFirstName =
        (String) adminSession.getAttribute("adminFirstName");

String adminLastName =
        (String) adminSession.getAttribute("adminLastName");


/* =========================================================
   GET STUDENT ID
   ========================================================= */

String studentIdParameter =
        request.getParameter("id");

if (studentIdParameter == null
        || studentIdParameter.trim().isEmpty()) {

    response.sendRedirect("manage-students.jsp?error=invalid_student");
    return;
}

int studentId;

try {

    studentId =
            Integer.parseInt(studentIdParameter);

} catch (NumberFormatException e) {

    response.sendRedirect("manage-students.jsp?error=invalid_student");
    return;
}


/* =========================================================
   STUDENT VARIABLES
   ========================================================= */

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


/* =========================================================
   LOAD STUDENT
   ========================================================= */

String sql =
        "SELECT first_name, middle_name, last_name, gender, " +
        "date_of_birth, registration_number, college, programme, " +
        "year_of_study, email, phone " +
        "FROM students " +
        "WHERE id = ?";


try (Connection connection =
             DBConnection.getConnection();

     PreparedStatement statement =
             connection.prepareStatement(sql)) {

    statement.setInt(1, studentId);

    try (ResultSet resultSet =
                 statement.executeQuery()) {

        if (resultSet.next()) {

            studentFound = true;

            firstName =
                    resultSet.getString("first_name");

            middleName =
                    resultSet.getString("middle_name");

            lastName =
                    resultSet.getString("last_name");

            gender =
                    resultSet.getString("gender");

            if (resultSet.getDate("date_of_birth") != null) {

                dateOfBirth =
                        resultSet.getDate("date_of_birth")
                                .toString();
            }

            registrationNumber =
                    resultSet.getString("registration_number");

            college =
                    resultSet.getString("college");

            programme =
                    resultSet.getString("programme");

            yearOfStudy =
                    resultSet.getInt("year_of_study");

            email =
                    resultSet.getString("email");

            phone =
                    resultSet.getString("phone");
        }
    }

} catch (Exception e) {

    e.printStackTrace();

    response.sendError(
            500,
            "Unable to load student information."
    );

    return;
}


if (!studentFound) {

    response.sendError(
            404,
            "Student not found."
    );

    return;
}


/* =========================================================
   ERROR MESSAGE
   ========================================================= */

String error =
        request.getParameter("error");

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Edit Student | UDOM Online Quiz System</title>


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


<style>

    .form-section {
        background: #ffffff;
        border-radius: 14px;
        padding: 25px;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);
        margin-bottom: 25px;
    }

    .form-section-title {
        font-weight: 700;
        margin-bottom: 5px;
    }

    .form-section-subtitle {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 20px;
    }

    .form-label {
        font-weight: 600;
    }

    .required-star {
        color: #dc3545;
    }

    .password-note {
        font-size: 13px;
        color: #6c757d;
        margin-top: 6px;
    }

    .danger-password-section {
        border: 1px solid #f1c1c1;
        background: #fffafa;
    }

    .danger-password-title {
        color: #b02a37;
    }

    .action-buttons {
        display: flex;
        justify-content: space-between;
        gap: 10px;
        flex-wrap: wrap;
    }

</style>

</head>

<body>

<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#adminSidebar">

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


    <!-- Right side -->

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


        <!-- Admin profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                type="button"
                data-bs-toggle="dropdown">

                <div class="student-avatar">

                    <%= adminFirstName != null
                            && !adminFirstName.isEmpty()
                            ? adminFirstName.substring(0, 1).toUpperCase()
                            : "A" %>

                </div>


                <div class="student-name d-none d-md-block">

                    <strong>

                        <%= adminFirstName != null
                                ? adminFirstName
                                : "Admin" %>

                        <%= adminLastName != null
                                ? adminLastName
                                : "" %>

                    </strong>

                    <small>
                        Administrator
                    </small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end shadow">

                <li>

                    <a
                        class="dropdown-item"
                        href="dashboard.jsp">

                        <i class="bi bi-speedometer2 me-2"></i>

                        Dashboard

                    </a>

                </li>


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

<!-- Mobile header -->

<div class="offcanvas-header d-lg-none">

    <h5 class="offcanvas-title">
        Admin Menu
    </h5>

    <button
        type="button"
        class="btn-close"
        data-bs-dismiss="offcanvas">
    </button>

</div>


<div class="sidebar-content">


    <!-- Admin profile -->

    <div class="sidebar-profile">

        <div class="sidebar-avatar">

            <%= adminFirstName != null
                    && !adminFirstName.isEmpty()
                    ? adminFirstName.substring(0, 1).toUpperCase()
                    : "A" %>

        </div>


        <div>

            <h6>

                <%= adminFirstName != null
                        ? adminFirstName
                        : "Administrator" %>

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


        <!-- Students -->

        <a
            href="manage-students.jsp"
            class="sidebar-link active">

            <i class="bi bi-people-fill"></i>

            <span>
                Manage Students
            </span>

        </a>


        <!-- Teachers -->

        <a
            href="manage-teachers.jsp"
            class="sidebar-link">

            <i class="bi bi-person-badge-fill"></i>

            <span>
                Manage Teachers
            </span>

        </a>


        <!-- Quizzes -->

        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-journal-text"></i>

            <span>
                Quizzes
            </span>

        </a>


        <!-- Courses -->

        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-book-fill"></i>

            <span>
                Courses
            </span>

        </a>


        <!-- Reports -->

        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>
                Reports
            </span>

        </a>


        <p class="menu-title mt-4">
            SYSTEM
        </p>


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
                Edit Student
            </h1>

            <p class="text-muted mb-0">
                Update student information and account password.
            </p>

        </div>


        <div>

            <a
                href="view-student.jsp?id=<%= studentId %>"
                class="btn btn-outline-secondary">

                <i class="bi bi-arrow-left me-1"></i>

                Back to Student

            </a>

        </div>

    </div>



    <!-- ERROR MESSAGES -->

    <% if ("password_mismatch".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-shield-exclamation me-2"></i>

            New password and confirmation password do not match.

        </div>

    <% } else if ("password_required".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-shield-exclamation me-2"></i>

            Please enter the confirmation password.

        </div>

    <% } else if ("password_short".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-shield-exclamation me-2"></i>

            Password must contain at least 8 characters.

        </div>

    <% } else if ("duplicate".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            Registration number or email already exists.

        </div>

    <% } else if ("invalid_student".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            Invalid student information.

        </div>

    <% } else if ("update_failed".equals(error)) { %>

        <div class="alert alert-danger">

            <i class="bi bi-database-x me-2"></i>

            Unable to update student information.

        </div>

    <% } %>



    <!-- =====================================================
         STUDENT INFORMATION FORM
    ====================================================== -->

    <form
        action="../updateStudent"
        method="POST"
        autocomplete="off">


        <!-- Student ID -->

        <input
            type="hidden"
            name="studentId"
            value="<%= studentId %>">



        <!-- =================================================
             PERSONAL INFORMATION
        ================================================== -->

        <div class="form-section">

            <h4 class="form-section-title">

                <i class="bi bi-person-fill text-primary me-2"></i>

                Personal Information

            </h4>

            <p class="form-section-subtitle">
                Update the student's personal details.
            </p>


            <div class="row g-3">


                <!-- First Name -->

                <div class="col-md-4">

                    <label class="form-label">

                        First Name

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="firstName"
                        value="<%= firstName %>"
                        required>

                </div>


                <!-- Middle Name -->

                <div class="col-md-4">

                    <label class="form-label">

                        Middle Name

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="middleName"
                        value="<%= middleName != null
                                ? middleName
                                : "" %>">

                </div>


                <!-- Last Name -->

                <div class="col-md-4">

                    <label class="form-label">

                        Last Name

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="lastName"
                        value="<%= lastName %>"
                        required>

                </div>


                <!-- Gender -->

                <div class="col-md-6">

                    <label class="form-label">

                        Gender

                        <span class="required-star">*</span>

                    </label>

                    <select
                        class="form-select"
                        name="gender"
                        required>

                        <option value="">
                            Select Gender
                        </option>

                        <option
                            value="MALE"
                            <%= "MALE".equals(gender)
                                    ? "selected"
                                    : "" %>>

                            Male

                        </option>

                        <option
                            value="FEMALE"
                            <%= "FEMALE".equals(gender)
                                    ? "selected"
                                    : "" %>>

                            Female

                        </option>

                    </select>

                </div>


                <!-- Date of Birth -->

                <div class="col-md-6">

                    <label class="form-label">

                        Date of Birth

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="date"
                        class="form-control"
                        name="dateOfBirth"
                        value="<%= dateOfBirth %>"
                        required>

                </div>

            </div>

        </div>



        <!-- =================================================
             ACADEMIC INFORMATION
        ================================================== -->

        <div class="form-section">

            <h4 class="form-section-title">

                <i class="bi bi-mortarboard-fill text-primary me-2"></i>

                Academic Information

            </h4>

            <p class="form-section-subtitle">
                Update the student's academic details.
            </p>


            <div class="row g-3">


                <!-- Registration Number -->

                <div class="col-md-6">

                    <label class="form-label">

                        Registration Number

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="registrationNumber"
                        value="<%= registrationNumber %>"
                        required>

                </div>


                <!-- College -->

                <div class="col-md-6">

                    <label class="form-label">

                        College

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="college"
                        value="<%= college %>"
                        required>

                </div>


                <!-- Programme -->

                <div class="col-md-6">

                    <label class="form-label">

                        Programme

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="programme"
                        value="<%= programme %>"
                        required>

                </div>


                <!-- Year -->

                <div class="col-md-6">

                    <label class="form-label">

                        Year of Study

                        <span class="required-star">*</span>

                    </label>

                    <select
                        class="form-select"
                        name="yearOfStudy"
                        required>

                        <option
                            value="1"
                            <%= yearOfStudy == 1
                                    ? "selected"
                                    : "" %>>

                            Year 1

                        </option>

                        <option
                            value="2"
                            <%= yearOfStudy == 2
                                    ? "selected"
                                    : "" %>>

                            Year 2

                        </option>

                        <option
                            value="3"
                            <%= yearOfStudy == 3
                                    ? "selected"
                                    : "" %>>

                            Year 3

                        </option>

                        <option
                            value="4"
                            <%= yearOfStudy == 4
                                    ? "selected"
                                    : "" %>>

                            Year 4

                        </option>

                    </select>

                </div>

            </div>

        </div>



        <!-- =================================================
             CONTACT INFORMATION
        ================================================== -->

        <div class="form-section">

            <h4 class="form-section-title">

                <i class="bi bi-telephone-fill text-primary me-2"></i>

                Contact Information

            </h4>

            <p class="form-section-subtitle">
                Update the student's contact information.
            </p>


            <div class="row g-3">


                <!-- Email -->

                <div class="col-md-6">

                    <label class="form-label">

                        Email

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="email"
                        class="form-control"
                        name="email"
                        value="<%= email %>"
                        required>

                </div>


                <!-- Phone -->

                <div class="col-md-6">

                    <label class="form-label">

                        Phone Number

                        <span class="required-star">*</span>

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="phone"
                        value="<%= phone %>"
                        required>

                </div>

            </div>

        </div>



        <!-- =================================================
             PASSWORD
        ================================================== -->

        <div class="form-section danger-password-section">

            <h4 class="form-section-title danger-password-title">

                <i class="bi bi-shield-lock-fill me-2"></i>

                Change Password

            </h4>

            <p class="form-section-subtitle">

                Change the student's login password.

                Leave both fields empty if the current password
                should remain unchanged.

            </p>


            <div class="row g-3">


                <!-- New Password -->

                <div class="col-md-6">

                    <label class="form-label">

                        New Password

                    </label>


                    <div class="input-group">

                        <input
                            type="password"
                            class="form-control"
                            id="newPassword"
                            name="newPassword"
                            minlength="8"
                            autocomplete="new-password"
                            placeholder="Enter new password">


                        <button
                            class="btn btn-outline-secondary"
                            type="button"
                            onclick="togglePassword(
                                'newPassword',
                                this
                            )">

                            <i class="bi bi-eye"></i>

                        </button>

                    </div>


                    <div class="password-note">

                        Minimum 8 characters.

                    </div>

                </div>



                <!-- Confirm Password -->

                <div class="col-md-6">

                    <label class="form-label">

                        Confirm New Password

                    </label>


                    <div class="input-group">

                        <input
                            type="password"
                            class="form-control"
                            id="confirmPassword"
                            name="confirmPassword"
                            minlength="8"
                            autocomplete="new-password"
                            placeholder="Confirm new password">


                        <button
                            class="btn btn-outline-secondary"
                            type="button"
                            onclick="togglePassword(
                                'confirmPassword',
                                this
                            )">

                            <i class="bi bi-eye"></i>

                        </button>

                    </div>


                    <div class="password-note">

                        Enter the same password again.

                    </div>

                </div>

            </div>


            <div class="alert alert-warning mt-4 mb-0">

                <i class="bi bi-info-circle-fill me-2"></i>

                <strong>Important:</strong>

                The password will be securely hashed before it
                is stored in the database.

            </div>

        </div>



        <!-- =================================================
             ACTION BUTTONS
        ================================================== -->

        <div class="form-section">

            <div class="action-buttons">

                <a
                    href="view-student.jsp?id=<%= studentId %>"
                    class="btn btn-outline-secondary">

                    <i class="bi bi-x-circle me-1"></i>

                    Cancel

                </a>


                <button
                    type="submit"
                    class="btn btn-primary">

                    <i class="bi bi-check-circle-fill me-1"></i>

                    Save Changes

                </button>

            </div>

        </div>


    </form>


</div>

</main>

<!-- =========================================================
     FOOTER
========================================================= -->

<footer class="dashboard-footer">

<p>

    © 2026 UDOM Online Quiz System.
    University of Dodoma.

</p>

</footer>

<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- Password Toggle -->

<script>

function togglePassword(fieldId, button) {

    const field =
        document.getElementById(fieldId);

    const icon =
        button.querySelector("i");


    if (field.type === "password") {

        field.type = "text";

        icon.classList.remove("bi-eye");

        icon.classList.add("bi-eye-slash");

    } else {

        field.type = "password";

        icon.classList.remove("bi-eye-slash");

        icon.classList.add("bi-eye");

    }

}

</script>

</body>

</html>
