<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

    <!-- Authentication CSS -->
    <link rel="stylesheet" href="css/auth.css">

</head>

<body class="auth-page">


<div class="container-fluid">

    <div class="row min-vh-100">


        <!-- ================= LEFT SIDE ================= -->

        <div class="col-lg-6 auth-intro d-none d-lg-flex">

            <div class="auth-intro-content">

                <a href="index.html"
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


                <div class="intro-content mt-5">

                    <span class="intro-label">
                        WELCOME BACK
                    </span>

                    <h1>
                        Continue your
                        <span>learning journey.</span>
                    </h1>

                    <p>
                        Sign in to access your personalized quiz
                        dashboard, assessments and academic results.
                    </p>


                    <div class="intro-feature">

                        <i class="bi bi-shield-check"></i>

                        <div>

                            <strong>
                                Secure Access
                            </strong>

                            <small>
                                Your account is protected.
                            </small>

                        </div>

                    </div>


                    <div class="intro-feature">

                        <i class="bi bi-speedometer2"></i>

                        <div>

                            <strong>
                                Personalized Dashboard
                            </strong>

                            <small>
                                Access tools based on your role.
                            </small>

                        </div>

                    </div>


                    <div class="intro-feature">

                        <i class="bi bi-bar-chart-line"></i>

                        <div>

                            <strong>
                                Track Performance
                            </strong>

                            <small>
                                Monitor your assessment results.
                            </small>

                        </div>

                    </div>

                </div>


                <div class="intro-footer">

                    <i class="bi bi-geo-alt me-2"></i>
                    Dodoma, Tanzania

                </div>

            </div>

        </div>


        <!-- ================= LOGIN SIDE ================= -->

        <div class="col-lg-6 auth-form-side">


            <div class="registration-container">


                <div class="mobile-brand d-lg-none mb-5">

                    <a href="index.html"
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


                <div class="form-header">

                    <span class="form-label-custom">
                        ACCOUNT LOGIN
                    </span>

                    <h2>
                        Welcome back
                    </h2>

                    <p>
                        Sign in to continue to your dashboard.
                    </p>

                </div>


                <!-- LOGIN FORM -->

                <form action="login"
                      method="post">


                    <!-- EMAIL -->

                    <div class="mb-4">

                        <label
                            for="email"
                            class="form-label">

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
                                placeholder="Enter your email"
                                required>

                        </div>

                    </div>


                    <!-- PASSWORD -->

                    <div class="mb-3">

                        <div class="d-flex justify-content-between">

                            <label
                                for="password"
                                class="form-label">

                                Password

                            </label>

                            <a href="#"
                               class="small"
                               style="color:#003b73;">

                                Forgot password?

                            </a>

                        </div>


                        <div class="password-field">

                            <input
                                type="password"
                                class="form-control"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                required>

                            <button
                                type="button"
                                class="password-toggle"
                                onclick="toggleLoginPassword()">

                                <i
                                    id="passwordIcon"
                                    class="bi bi-eye">
                                </i>

                            </button>

                        </div>

                    </div>


                    <!-- REMEMBER -->

                    <div class="form-check mb-4">

                        <input
                            class="form-check-input"
                            type="checkbox"
                            id="rememberMe"
                            name="rememberMe">

                        <label
                            class="form-check-label small text-muted"
                            for="rememberMe">

                            Remember me

                        </label>

                    </div>


                    <!-- LOGIN BUTTON -->

                    <button
                        type="submit"
                        class="btn btn-register w-100">

                        <i class="bi bi-box-arrow-in-right me-2"></i>

                        Sign In

                    </button>


                </form>


                <!-- REGISTRATION -->

                <div class="text-center mt-4">

                    <span class="text-muted small">
                        Don't have a student account?
                    </span>

                    <a
                        href="student-registration.jsp"
                        class="fw-bold ms-1"
                        style="color:#003b73;">

                        Register now

                    </a>

                </div>


                <!-- ROLE INFORMATION -->

                <div class="mt-5">

                    <div class="text-center text-muted small mb-3">

                        <span>
                            ACCESS AVAILABLE FOR
                        </span>

                    </div>


                    <div class="row g-2">

                        <div class="col-4">

                            <div class="text-center border rounded-3 p-3">

                                <i
                                    class="bi bi-mortarboard-fill"
                                    style="color:#003b73;font-size:20px;">
                                </i>

                                <small class="d-block mt-1">
                                    Student
                                </small>

                            </div>

                        </div>


                        <div class="col-4">

                            <div class="text-center border rounded-3 p-3">

                                <i
                                    class="bi bi-person-workspace"
                                    style="color:#003b73;font-size:20px;">
                                </i>

                                <small class="d-block mt-1">
                                    Teacher
                                </small>

                            </div>

                        </div>


                        <div class="col-4">

                            <div class="text-center border rounded-3 p-3">

                                <i
                                    class="bi bi-speedometer2"
                                    style="color:#003b73;font-size:20px;">
                                </i>

                                <small class="d-block mt-1">
                                    Admin
                                </small>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="text-center mt-5">

                    <a href="index.html"
                       class="small text-muted">

                        <i class="bi bi-arrow-left me-1"></i>

                        Back to homepage

                    </a>

                </div>


            </div>

        </div>

    </div>

</div>


<script>

function toggleLoginPassword() {

    const password =
        document.getElementById("password");

    const icon =
        document.getElementById("passwordIcon");


    if (password.type === "password") {

        password.type = "text";

        icon.classList.remove("bi-eye");

        icon.classList.add("bi-eye-slash");

    } else {

        password.type = "password";

        icon.classList.remove("bi-eye-slash");

        icon.classList.add("bi-eye");

    }

}

</script>


</body>
</html>
