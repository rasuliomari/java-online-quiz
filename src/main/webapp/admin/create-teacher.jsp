<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Create Teacher - UDOM Online Quiz System</title>

    <!-- Bootstrap 5.3.3 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Authentication CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/auth.css">
</head>

<body>

<div class="auth-container">

    <!-- LEFT SIDE -->
    <div class="auth-left">

        <div class="auth-brand">
            <div class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </div>

            <h1>UDOM</h1>
            <p>Online Quiz System</p>
        </div>

        <div class="auth-message">
            <h2>Create Teacher Account</h2>

            <p>
                Use this form to create an official teacher account
                for the UDOM Online Quiz System.
            </p>

            <div class="auth-info">
                <div class="info-item">
                    <i class="bi bi-shield-check"></i>
                    <span>Admin-controlled registration</span>
                </div>

                <div class="info-item">
                    <i class="bi bi-person-badge"></i>
                    <span>Teacher access</span>
                </div>

                <div class="info-item">
                    <i class="bi bi-lock"></i>
                    <span>Secure password protection</span>
                </div>
            </div>
        </div>

    </div>


    <!-- RIGHT SIDE -->
    <div class="auth-right">

        <div class="auth-form-container">

            <div class="form-header">

                <div class="form-icon">
                    <i class="bi bi-person-plus-fill"></i>
                </div>

                <h2>Create Teacher</h2>

                <p>
                    Enter the teacher's information below.
                </p>

            </div>


            <!-- SUCCESS MESSAGE -->
            <% if ("teacherCreated".equals(request.getParameter("success"))) { %>

                <div class="alert alert-success d-flex align-items-center"
                     role="alert">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <div>
                        Teacher account created successfully.
                    </div>

                </div>

            <% } %>


            <!-- ERROR MESSAGE -->
            <% if ("error".equals(request.getParameter("status"))) { %>

                <div class="alert alert-danger d-flex align-items-center"
                     role="alert">

                    <i class="bi bi-exclamation-triangle-fill me-2"></i>

                    <div>
                        <%= request.getParameter("message") != null
                                ? request.getParameter("message")
                                : "Unable to create teacher account." %>
                    </div>

                </div>

            <% } %>


            <form
                action="<%= request.getContextPath() %>/createTeacher"
                method="post">

                <!-- FIRST NAME -->
                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label for="firstName" class="form-label">
                            First Name
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="firstName"
                                name="firstName"
                                placeholder="Enter first name"
                                value="<%= request.getParameter("firstName") != null
                                        ? request.getParameter("firstName")
                                        : "" %>"
                                required>

                        </div>

                    </div>


                    <!-- MIDDLE NAME -->
                    <div class="col-md-6 mb-3">

                        <label for="middleName" class="form-label">
                            Middle Name
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="middleName"
                                name="middleName"
                                placeholder="Enter middle name"
                                value="<%= request.getParameter("middleName") != null
                                        ? request.getParameter("middleName")
                                        : "" %>">

                        </div>

                    </div>

                </div>


                <!-- LAST NAME + STAFF NUMBER -->
                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label for="lastName" class="form-label">
                            Last Name
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="lastName"
                                name="lastName"
                                placeholder="Enter last name"
                                value="<%= request.getParameter("lastName") != null
                                        ? request.getParameter("lastName")
                                        : "" %>"
                                required>

                        </div>

                    </div>


                    <div class="col-md-6 mb-3">

                        <label for="staffNumber" class="form-label">
                            Staff Number
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-person-badge"></i>
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="staffNumber"
                                name="staffNumber"
                                placeholder="Enter staff number"
                                value="<%= request.getParameter("staffNumber") != null
                                        ? request.getParameter("staffNumber")
                                        : "" %>"
                                required>

                        </div>

                    </div>

                </div>


                <!-- COLLEGE -->
                <div class="mb-3">

                    <label for="college" class="form-label">
                        College
                    </label>

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-building"></i>
                        </span>

                        <input
                            type="text"
                            class="form-control"
                            id="college"
                            name="college"
                            placeholder="Enter college"
                            value="<%= request.getParameter("college") != null
                                    ? request.getParameter("college")
                                    : "" %>"
                            required>

                    </div>

                </div>


                <!-- DEPARTMENT -->
                <div class="mb-3">

                    <label for="department" class="form-label">
                        Department
                    </label>

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-diagram-3"></i>
                        </span>

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


                <!-- EMAIL + PHONE -->
                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label for="email" class="form-label">
                            Email Address
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
                                placeholder="teacher@example.com"
                                value="<%= request.getParameter("email") != null
                                        ? request.getParameter("email")
                                        : "" %>"
                                required>

                        </div>

                    </div>


                    <div class="col-md-6 mb-3">

                        <label for="phone" class="form-label">
                            Phone Number
                        </label>

                        <div class="input-group">

                            <span class="input-group-text">
                                <i class="bi bi-telephone"></i>
                            </span>

                            <input
                                type="tel"
                                class="form-control"
                                id="phone"
                                name="phone"
                                placeholder="Enter phone number"
                                value="<%= request.getParameter("phone") != null
                                        ? request.getParameter("phone")
                                        : "" %>"
                                required>

                        </div>

                    </div>

                </div>


                <!-- PASSWORD -->
                <div class="mb-3">

                    <label for="password" class="form-label">
                        Password
                    </label>

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-lock"></i>
                        </span>

                        <input
                            type="password"
                            class="form-control"
                            id="password"
                            name="password"
                            placeholder="Create password"
                            required>

                    </div>

                </div>


                <!-- CONFIRM PASSWORD -->
                <div class="mb-4">

                    <label for="confirmPassword" class="form-label">
                        Confirm Password
                    </label>

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-lock-fill"></i>
                        </span>

                        <input
                            type="password"
                            class="form-control"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Confirm password"
                            required>

                    </div>

                </div>


                <!-- SUBMIT -->
                <button
                    type="submit"
                    class="btn btn-primary w-100">

                    <i class="bi bi-person-plus-fill me-2"></i>
                    Create Teacher Account

                </button>

            </form>


            <!-- BACK TO ADMIN -->
            <div class="text-center mt-4">

                <a
                    href="<%= request.getContextPath() %>/admin/dashboard.jsp"
                    class="text-decoration-none">

                    <i class="bi bi-arrow-left me-1"></i>
                    Back to Admin Dashboard

                </a>

            </div>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>