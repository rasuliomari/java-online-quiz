<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    if (session.getAttribute("adminLoggedIn") == null
            || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(session.getAttribute("userRole"))) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=adminLoginRequired"
        );
        return;
    }

    String teacherIdParam = request.getParameter("id");

    if (teacherIdParam == null || teacherIdParam.trim().isEmpty()) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-teachers.jsp?status=error&message=Teacher%20ID%20is%20required"
        );
        return;
    }

    int teacherId;

    try {
        teacherId = Integer.parseInt(teacherIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-teachers.jsp?status=error&message=Invalid%20teacher%20ID"
        );
        return;
    }

    String firstName = "";
    String middleName = "";
    String lastName = "";
    String staffNumber = "";
    String college = "";
    String department = "";
    String email = "";
    String phone = "";

    boolean teacherFound = false;

    String sql =
            "SELECT first_name, middle_name, last_name, "
            + "staff_number, college, department, email, phone "
            + "FROM teachers "
            + "WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setInt(1, teacherId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {

                teacherFound = true;

                firstName = resultSet.getString("first_name");
                middleName = resultSet.getString("middle_name");
                lastName = resultSet.getString("last_name");
                staffNumber = resultSet.getString("staff_number");
                college = resultSet.getString("college");
                department = resultSet.getString("department");
                email = resultSet.getString("email");
                phone = resultSet.getString("phone");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    if (!teacherFound) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/manage-teachers.jsp?status=error&message=Teacher%20not%20found"
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

    <title>Edit Teacher | UDOM Online Quiz System</title>

    <!-- Bootstrap 5.3.3 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Shared authentication CSS -->
    <link
        rel="stylesheet"
        href="<%= request.getContextPath() %>/css/auth.css">

</head>

<body class="auth-page">

<div class="container-fluid">

    <div class="row min-vh-100">

        <!-- =====================================================
             LEFT SIDE
             ===================================================== -->
        <div class="col-lg-5 auth-intro d-none d-lg-flex">

            <div class="auth-intro-content">

                <!-- Brand -->
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                   class="auth-brand text-decoration-none">

                    <span class="brand-icon">
                        <i class="bi bi-mortarboard-fill"></i>
                    </span>

                    <span>
                        <strong>UDOM</strong>
                        <small>Online Quiz System</small>
                    </span>

                </a>

                <div class="mt-5">

                    <div class="intro-label">
                        ADMINISTRATION PORTAL
                    </div>

                    <h1>
                        Manage your
                        <span>teaching staff.</span>
                    </h1>

                    <p class="intro-description">
                        Keep teacher information accurate and up to date
                        from one secure administration portal.
                    </p>

                    <div class="intro-features">

                        <div class="intro-feature">

                            <div class="feature-icon">
                                <i class="bi bi-person-gear"></i>
                            </div>

                            <div>
                                <strong>Teacher Management</strong>
                                <span>
                                    Update teacher account information.
                                </span>
                            </div>

                        </div>

                        <div class="intro-feature">

                            <div class="feature-icon">
                                <i class="bi bi-shield-check"></i>
                            </div>

                            <div>
                                <strong>Secure Access</strong>
                                <span>
                                    Only authorized administrators can make changes.
                                </span>
                            </div>

                        </div>

                        <div class="intro-feature">

                            <div class="feature-icon">
                                <i class="bi bi-database-check"></i>
                            </div>

                            <div>
                                <strong>Reliable Records</strong>
                                <span>
                                    Keep staff records consistent with the system.
                                </span>
                            </div>

                        </div>

                    </div>

                </div>

                <div class="auth-intro-footer">
                    <i class="bi bi-geo-alt-fill"></i>
                    Dodoma, Tanzania
                </div>

            </div>

        </div>


        <!-- =====================================================
             RIGHT SIDE
             ===================================================== -->
        <div class="col-lg-7 auth-form-side">

            <div class="registration-container">

                <!-- Mobile Brand -->
                <div class="mobile-brand d-lg-none">

                    <a
                        href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                        class="auth-brand text-decoration-none">

                        <span class="brand-icon">
                            <i class="bi bi-mortarboard-fill"></i>
                        </span>

                        <span>
                            <strong>UDOM</strong>
                            <small>Online Quiz System</small>
                        </span>

                    </a>

                </div>


                <!-- Form Header -->
                <div class="form-header">

                    <div class="form-label-custom">
                        TEACHER MANAGEMENT
                    </div>

                    <h2>Edit Teacher</h2>

                    <p>
                        Update the teacher's account information below.
                    </p>

                </div>


                <!-- Error Message -->
                <%
                    String status = request.getParameter("status");
                    String message = request.getParameter("message");

                    if ("error".equals(status) && message != null) {
                %>

                    <div class="alert alert-danger d-flex align-items-center"
                         role="alert">

                        <i class="bi bi-exclamation-triangle-fill me-2"></i>

                        <div>
                            <%= message %>
                        </div>

                    </div>

                <%
                    }
                %>


                <!-- =================================================
                     EDIT FORM
                     ================================================= -->
                <form
                    action="<%= request.getContextPath() %>/updateTeacher"
                    method="post"
                    id="teacherEditForm"
                    novalidate>

                    <input
                        type="hidden"
                        name="teacherId"
                        value="<%= teacherId %>">


                    <!-- Personal Information -->
                    <div class="form-section-title">

                        <i class="bi bi-person-fill"></i>

                        Personal Information

                    </div>


                    <div class="row g-3">

                        <!-- First Name -->
                        <div class="col-md-6">

                            <label
                                for="firstName"
                                class="form-label form-label-custom">

                                First Name
                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="firstName"
                                name="firstName"
                                value="<%= firstName %>"
                                required>

                        </div>


                        <!-- Middle Name -->
                        <div class="col-md-6">

                            <label
                                for="middleName"
                                class="form-label form-label-custom">

                                Middle Name

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="middleName"
                                name="middleName"
                                value="<%= middleName == null ? "" : middleName %>">

                        </div>


                        <!-- Last Name -->
                        <div class="col-md-6">

                            <label
                                for="lastName"
                                class="form-label form-label-custom">

                                Last Name
                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="lastName"
                                name="lastName"
                                value="<%= lastName %>"
                                required>

                        </div>


                        <!-- Staff Number -->
                        <div class="col-md-6">

                            <label
                                for="staffNumber"
                                class="form-label form-label-custom">

                                Staff Number
                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="staffNumber"
                                name="staffNumber"
                                value="<%= staffNumber %>"
                                required>

                        </div>

                    </div>


                    <!-- Academic Information -->
                    <div class="form-section-title mt-4">

                        <i class="bi bi-building"></i>

                        Academic Information

                    </div>


                    <div class="row g-3">

                        <!-- College -->
                        <div class="col-md-6">

                            <label
                                for="college"
                                class="form-label form-label-custom">

                                College / School
                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="college"
                                name="college"
                                value="<%= college %>"
                                required>

                        </div>


                        <!-- Department -->
                        <div class="col-md-6">

                            <label
                                for="department"
                                class="form-label form-label-custom">

                                Department
                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="department"
                                name="department"
                                value="<%= department %>"
                                required>

                        </div>

                    </div>


                    <!-- Contact Information -->
                    <div class="form-section-title mt-4">

                        <i class="bi bi-telephone-fill"></i>

                        Contact Information

                    </div>


                    <div class="row g-3">

                        <!-- Email -->
                        <div class="col-md-6">

                            <label
                                for="email"
                                class="form-label form-label-custom">

                                Email Address
                                <span class="text-danger">*</span>

                            </label>

                            <div class="input-group">

                                <span class="input-group-text">
                                    <i class="bi bi-envelope"></i>
                                </span>

                                <input
                                    type="email"
                                    class="form-control"
                                    id="email"
                                    name="email"
                                    value="<%= email %>"
                                    required>

                            </div>

                        </div>


                        <!-- Phone -->
                        <div class="col-md-6">

                            <label
                                for="phone"
                                class="form-label form-label-custom">

                                Phone Number
                                <span class="text-danger">*</span>

                            </label>

                            <div class="input-group">

                                <span class="input-group-text">
                                    <i class="bi bi-phone"></i>
                                </span>

                                <input
                                    type="text"
                                    class="form-control"
                                    id="phone"
                                    name="phone"
                                    value="<%= phone %>"
                                    required>

                            </div>

                        </div>

                    </div>


                    <!-- Password -->
                    <div class="form-section-title mt-4">

                        <i class="bi bi-lock-fill"></i>

                        Password

                    </div>

                    <div class="password-help mb-3">

                        Leave the password fields empty if you do not
                        want to change the teacher's password.

                    </div>


                    <div class="row g-3">

                        <!-- New Password -->
                        <div class="col-md-6">

                            <label
                                for="password"
                                class="form-label form-label-custom">

                                New Password

                            </label>

                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control"
                                    id="password"
                                    name="password">

                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword('password', 'passwordIcon')">

                                    <i
                                        class="bi bi-eye"
                                        id="passwordIcon">
                                    </i>

                                </button>

                            </div>

                        </div>


                        <!-- Confirm Password -->
                        <div class="col-md-6">

                            <label
                                for="confirmPassword"
                                class="form-label form-label-custom">

                                Confirm New Password

                            </label>

                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control"
                                    id="confirmPassword"
                                    name="confirmPassword">

                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword('confirmPassword', 'confirmPasswordIcon')">

                                    <i
                                        class="bi bi-eye"
                                        id="confirmPasswordIcon">
                                    </i>

                                </button>

                            </div>

                        </div>

                    </div>


                    <!-- Submit -->
                    <button
                        type="submit"
                        class="btn btn-register w-100 mt-4">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        Update Teacher Account

                    </button>


                    <!-- Back -->
                    <div class="login-link">

                        <a
                            href="<%= request.getContextPath() %>/admin/manage-teachers.jsp">

                            <i class="bi bi-arrow-left me-1"></i>

                            Back to Manage Teachers

                        </a>

                    </div>

                </form>

            </div>

        </div>

    </div>

</div>


<script>

function togglePassword(inputId, iconId) {

    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);

    if (input.type === "password") {

        input.type = "text";

        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");

    } else {

        input.type = "password";

        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");

    }

}

</script>

</body>
</html>