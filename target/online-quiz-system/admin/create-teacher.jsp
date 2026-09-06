<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Teacher | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

    <!-- SAME AUTH CSS AS STUDENT REGISTRATION -->
    <link
        rel="stylesheet"
        href="<%= request.getContextPath() %>/css/auth.css">

</head>


<body class="auth-page">


<div class="container-fluid">

    <div class="row min-vh-100">


        <!-- =====================================================
             LEFT SIDE
        ====================================================== -->

        <div class="col-lg-5 auth-intro d-none d-lg-flex">

            <div class="auth-intro-content">


                <!-- BRAND -->

                <a
                    href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                    class="auth-brand">

                    <div class="brand-icon">

                        <i class="bi bi-mortarboard-fill"></i>

                    </div>

                    <div>

                        <strong>UDOM</strong>

                        <small>
                            Online Quiz System
                        </small>

                    </div>

                </a>


                <!-- INTRO -->

                <div class="intro-content mt-5">

                    <span class="intro-label">
                        ADMINISTRATION PORTAL
                    </span>


                    <h1>

                        Create a
                        <span>teacher account.</span>

                    </h1>


                    <p>

                        Register authorized academic staff and
                        give them access to create, manage and
                        publish online quizzes.

                    </p>


                    <!-- FEATURE 1 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>Teacher Management</strong>

                            <small>
                                Create and manage academic staff accounts.
                            </small>

                        </div>

                    </div>


                    <!-- FEATURE 2 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>Quiz Management</strong>

                            <small>
                                Teachers can create and manage assessments.
                            </small>

                        </div>

                    </div>


                    <!-- FEATURE 3 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>Secure Access</strong>

                            <small>
                                Teacher passwords are securely protected.
                            </small>

                        </div>

                    </div>


                </div>


                <!-- FOOTER -->

                <div class="intro-footer">

                    <i class="bi bi-geo-alt me-2"></i>

                    Dodoma, Tanzania

                </div>


            </div>

        </div>



        <!-- =====================================================
             FORM SIDE
        ====================================================== -->

        <div class="col-lg-7 auth-form-side">


            <div class="registration-container">


                <!-- MOBILE BRAND -->

                <div class="mobile-brand d-lg-none mb-4">

                    <a
                        href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                        class="auth-brand">

                        <div class="brand-icon">

                            <i class="bi bi-mortarboard-fill"></i>

                        </div>

                        <div>

                            <strong>UDOM</strong>

                            <small>
                                Online Quiz System
                            </small>

                        </div>

                    </a>

                </div>



                <!-- =================================================
                     FORM HEADER
                ================================================== -->

                <div class="form-header">

                    <span class="form-label-custom">
                        CREATE TEACHER
                    </span>


                    <h2>
                        Teacher Registration
                    </h2>


                    <p>

                        Enter the teacher's information below
                        to create their account.

                    </p>

                </div>



                <!-- =================================================
                     SUCCESS MESSAGE
                ================================================== -->

                <%
                    String success =
                            request.getParameter("success");

                    String status =
                            request.getParameter("status");

                    String message =
                            request.getParameter("message");
                %>


                <% if ("teacherCreated".equals(success)) { %>

                    <div
                        class="alert alert-success d-flex align-items-center"
                        role="alert">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        <div>

                            Teacher account created successfully.

                        </div>

                    </div>

                <% } %>



                <!-- =================================================
                     ERROR MESSAGE
                ================================================== -->

                <% if ("error".equals(status)) { %>

                    <div
                        class="alert alert-danger d-flex align-items-center"
                        role="alert">

                        <i class="bi bi-exclamation-triangle-fill me-2"></i>

                        <div>

                            <%= message != null
                                    ? message
                                    : "Unable to create teacher account." %>

                        </div>

                    </div>

                <% } %>



                <!-- =================================================
                     TEACHER FORM
                ================================================== -->

                <form
                    action="<%= request.getContextPath() %>/createTeacher"
                    method="post"
                    id="teacherRegistrationForm"
                    novalidate>


                    <!-- =================================================
                         PERSONAL INFORMATION
                    ================================================== -->

                    <div class="form-section-title">

                        <i class="bi bi-person"></i>

                        Personal Information

                    </div>


                    <div class="row g-3">


                        <!-- FIRST NAME -->

                        <div class="col-md-4">

                            <label
                                for="firstName"
                                class="form-label">

                                First Name
                                <span>*</span>

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="firstName"
                                name="firstName"
                                placeholder="First name"
                                value="<%= request.getParameter("firstName") != null
                                        ? request.getParameter("firstName")
                                        : "" %>"
                                required>

                        </div>



                        <!-- MIDDLE NAME -->

                        <div class="col-md-4">

                            <label
                                for="middleName"
                                class="form-label">

                                Middle Name

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="middleName"
                                name="middleName"
                                placeholder="Middle name"
                                value="<%= request.getParameter("middleName") != null
                                        ? request.getParameter("middleName")
                                        : "" %>">

                        </div>



                        <!-- LAST NAME -->

                        <div class="col-md-4">

                            <label
                                for="lastName"
                                class="form-label">

                                Last Name
                                <span>*</span>

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="lastName"
                                name="lastName"
                                placeholder="Last name"
                                value="<%= request.getParameter("lastName") != null
                                        ? request.getParameter("lastName")
                                        : "" %>"
                                required>

                        </div>


                    </div>



                    <!-- =================================================
                         STAFF INFORMATION
                    ================================================== -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-person-badge"></i>

                        Staff Information

                    </div>


                    <div class="row g-3">


                        <!-- STAFF NUMBER -->

                        <div class="col-md-6">

                            <label
                                for="staffNumber"
                                class="form-label">

                                Staff Number
                                <span>*</span>

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="staffNumber"
                                name="staffNumber"
                                placeholder="e.g. UDOM/STAFF/001"
                                value="<%= request.getParameter("staffNumber") != null
                                        ? request.getParameter("staffNumber")
                                        : "" %>"
                                required>

                        </div>



                        <!-- COLLEGE -->

                        <div class="col-md-6">

                            <label
                                for="college"
                                class="form-label">

                                College / School
                                <span>*</span>

                            </label>


                            <select
                                class="form-select"
                                id="college"
                                name="college"
                                required>

                                <option value="">
                                    Select college / school
                                </option>


                                <option value="College of Informatics and Virtual Education">
                                    College of Informatics and Virtual Education
                                </option>


                                <option value="College of Natural and Mathematical Sciences">
                                    College of Natural and Mathematical Sciences
                                </option>


                                <option value="College of Business and Economics">
                                    College of Business and Economics
                                </option>


                                <option value="College of Education">
                                    College of Education
                                </option>


                                <option value="College of Humanities and Social Sciences">
                                    College of Humanities and Social Sciences
                                </option>


                                <option value="College of Earth Sciences">
                                    College of Earth Sciences
                                </option>


                                <option value="College of Health Sciences">
                                    College of Health Sciences
                                </option>


                                <option value="Other">
                                    Other
                                </option>

                            </select>

                        </div>



                        <!-- DEPARTMENT -->

                        <div class="col-md-12">

                            <label
                                for="department"
                                class="form-label">

                                Department
                                <span>*</span>

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="department"
                                name="department"
                                placeholder="Enter department"
                                value="<%= request.getParameter("department") != null
                                        ? request.getParameter("department")
                                        : "" %>"
                                required>

                        </div>


                    </div>



                    <!-- =================================================
                         CONTACT INFORMATION
                    ================================================== -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-telephone"></i>

                        Contact Information

                    </div>


                    <div class="row g-3">


                        <!-- EMAIL -->

                        <div class="col-md-6">

                            <label
                                for="email"
                                class="form-label">

                                Email Address
                                <span>*</span>

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
                                    placeholder="teacher@udom.ac.tz"
                                    value="<%= request.getParameter("email") != null
                                            ? request.getParameter("email")
                                            : "" %>"
                                    required>

                            </div>

                        </div>



                        <!-- PHONE -->

                        <div class="col-md-6">

                            <label
                                for="phone"
                                class="form-label">

                                Phone Number
                                <span>*</span>

                            </label>


                            <div class="input-group">

                                <span class="input-group-text">

                                    <i class="bi bi-phone"></i>

                                </span>


                                <input
                                    type="tel"
                                    class="form-control"
                                    id="phone"
                                    name="phone"
                                    placeholder="+255 7XX XXX XXX"
                                    value="<%= request.getParameter("phone") != null
                                            ? request.getParameter("phone")
                                            : "" %>"
                                    required>

                            </div>

                        </div>


                    </div>



                    <!-- =================================================
                         ACCOUNT SECURITY
                    ================================================== -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-shield-lock"></i>

                        Account Security

                    </div>


                    <div class="row g-3">


                        <!-- PASSWORD -->

                        <div class="col-md-6">

                            <label
                                for="password"
                                class="form-label">

                                Password
                                <span>*</span>

                            </label>


                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control"
                                    id="password"
                                    name="password"
                                    placeholder="Create password"
                                    minlength="8"
                                    required>


                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword(
                                        'password',
                                        this
                                    )">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>


                            <div class="password-help">

                                Minimum 8 characters

                            </div>

                        </div>



                        <!-- CONFIRM PASSWORD -->

                        <div class="col-md-6">

                            <label
                                for="confirmPassword"
                                class="form-label">

                                Confirm Password
                                <span>*</span>

                            </label>


                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    placeholder="Repeat password"
                                    required>


                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword(
                                        'confirmPassword',
                                        this
                                    )">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                        </div>


                    </div>



                    <!-- =================================================
                         ADMIN CONFIRMATION
                    ================================================== -->

                    <div class="form-check terms-check mt-4">

                        <input
                            class="form-check-input"
                            type="checkbox"
                            id="terms"
                            required>


                        <label
                            class="form-check-label"
                            for="terms">

                            I confirm that the teacher information
                            provided is accurate and that I am
                            authorized to create this account.

                        </label>

                    </div>



                    <!-- =================================================
                         SUBMIT BUTTON
                    ================================================== -->

                    <button
                        type="submit"
                        class="btn btn-register w-100 mt-4">

                        <i class="bi bi-person-plus-fill me-2"></i>

                        Create Teacher Account

                    </button>



                    <!-- =================================================
                         BACK TO ADMIN
                    ================================================== -->

                    <div class="login-link text-center mt-4">

                        <a
                            href="<%= request.getContextPath() %>/admin/dashboard.jsp">

                            <i class="bi bi-arrow-left me-1"></i>

                            Back to Admin Dashboard

                        </a>

                    </div>


                </form>


            </div>

        </div>


    </div>

</div>



<!-- Bootstrap JavaScript -->

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