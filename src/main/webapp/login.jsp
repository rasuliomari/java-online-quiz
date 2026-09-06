<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login | UDOM Online Quiz System</title>

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
          href="css/auth.css">

</head>

<body>

<%
    String error = request.getParameter("error");
    String registered = request.getParameter("registered");
    String logout = request.getParameter("logout");
%>


<div class="auth-page">

    <div class="auth-container">

        <!-- =====================================================
             LEFT SIDE
        ====================================================== -->

        <div class="auth-intro">

            <div class="auth-brand">

                <div class="brand-icon">
                    <i class="bi bi-mortarboard-fill"></i>
                </div>

                <div>
                    <h2>UDOM</h2>
                    <span>Online Quiz System</span>
                </div>

            </div>


            <div class="auth-intro-content">

                <span class="intro-label">
                    STUDENT PORTAL
                </span>

                <h1>
                    Welcome Back!
                </h1>

                <p>
                    Sign in to access your quizzes, track your
                    academic performance, and view your results.
                </p>


                <!-- Features -->

                <div class="auth-features">

                    <div class="auth-feature">

                        <div class="feature-icon">
                            <i class="bi bi-journal-check"></i>
                        </div>

                        <div>
                            <h6>Online Assessments</h6>

                            <p>
                                Access your available quizzes
                                anytime.
                            </p>
                        </div>

                    </div>


                    <div class="auth-feature">

                        <div class="feature-icon">
                            <i class="bi bi-lightning-charge-fill"></i>
                        </div>

                        <div>
                            <h6>Instant Results</h6>

                            <p>
                                Get your quiz performance
                                immediately after submission.
                            </p>
                        </div>

                    </div>


                    <div class="auth-feature">

                        <div class="feature-icon">
                            <i class="bi bi-bar-chart-fill"></i>
                        </div>

                        <div>
                            <h6>Track Progress</h6>

                            <p>
                                Monitor your academic performance
                                over time.
                            </p>
                        </div>

                    </div>

                </div>

            </div>


            <div class="auth-footer">

                <span>
                    © 2026 University of Dodoma
                </span>

                <span>
                    UDOM Online Quiz System
                </span>

            </div>

        </div>


        <!-- =====================================================
             RIGHT SIDE
        ====================================================== -->

        <div class="auth-form-side">

            <div class="auth-form-wrapper">


                <!-- Header -->

                <div class="form-header">

                    <div class="mobile-brand-icon">

                        <i class="bi bi-mortarboard-fill"></i>

                    </div>

                    <h2>
                        Sign In
                    </h2>

                    <p>
                        Enter your credentials to access your account.
                    </p>

                </div>


                <!-- =================================================
                     ALERT MESSAGES
                ================================================== -->

                <% if ("success".equals(registered)) { %>

                    <div
                        class="alert alert-success alert-dismissible fade show"
                        role="alert">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        <strong>Registration successful!</strong>
                        You can now log in to your account.

                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <% if ("success".equals(logout)) { %>

                    <div
                        class="alert alert-success alert-dismissible fade show"
                        role="alert">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        <strong>Logged out successfully!</strong>
                        Your session has been ended.

                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <% if ("loginRequired".equals(error)) { %>

                    <div
                        class="alert alert-warning alert-dismissible fade show"
                        role="alert">

                        <i class="bi bi-shield-lock-fill me-2"></i>

                        <strong>Login required.</strong>
                        Please sign in to access the student portal.

                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <% if ("invalid".equals(error)) { %>

                    <div
                        class="alert alert-danger alert-dismissible fade show"
                        role="alert">

                        <i class="bi bi-exclamation-triangle-fill me-2"></i>

                        Invalid email or password.

                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <!-- =================================================
                     LOGIN FORM
                ================================================== -->

                <form
                    action="login"
                    method="post"
                    class="auth-form">


                    <!-- Email -->

                    <div class="mb-3">

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
                                placeholder="Enter your email address"
                                autocomplete="email"
                                required>

                        </div>

                    </div>


                    <!-- Password -->

                    <div class="mb-3">

                        <div class="d-flex justify-content-between">

                            <label
                                for="password"
                                class="form-label">

                                Password

                            </label>

                        </div>


                        <div class="input-group">

                            <span class="input-group-text">

                                <i class="bi bi-lock"></i>

                            </span>

                            <input
                                type="password"
                                class="form-control"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>

                            <button
                                type="button"
                                class="btn password-toggle"
                                id="togglePassword">

                                <i class="bi bi-eye"
                                   id="passwordIcon">
                                </i>

                            </button>

                        </div>

                    </div>


                    <!-- Remember Me -->

                    <div
                        class="d-flex align-items-center justify-content-between mb-4">

                        <div class="form-check">

                            <input
                                class="form-check-input"
                                type="checkbox"
                                id="rememberMe"
                                name="rememberMe">

                            <label
                                class="form-check-label"
                                for="rememberMe">

                                Remember me

                            </label>

                        </div>

                    </div>


                    <!-- Sign In Button -->

                    <button
                        type="submit"
                        class="btn auth-submit w-100">

                        <span>
                            Sign In
                        </span>

                        <i class="bi bi-arrow-right"></i>

                    </button>


                </form>


                <!-- =================================================
                     REGISTER
                ================================================== -->

                <div class="auth-divider">

                    <span>
                        Don't have an account?
                    </span>

                </div>


                <a
                    href="student-registration.jsp"
                    class="btn btn-outline-primary w-100 register-button">

                    <i class="bi bi-person-plus me-2"></i>

                    Create Student Account

                </a>


                <!-- =================================================
                     ACCOUNT INFORMATION
                ================================================== -->

                <div class="login-info mt-4">

                    <div class="info-item">

                        <i class="bi bi-shield-check"></i>

                        <span>
                            Your account information is protected.
                        </span>

                    </div>

                    <div class="info-item">

                        <i class="bi bi-person-badge"></i>

                        <span>
                            Student accounts are for UDOM students.
                        </span>

                    </div>

                </div>


                <!-- Back Home -->

                <div class="text-center mt-4">

                    <a
                        href="index.html"
                        class="back-home">

                        <i class="bi bi-arrow-left me-1"></i>

                        Back to Homepage

                    </a>

                </div>


            </div>

        </div>

    </div>

</div>


<!-- =========================================================
     PASSWORD TOGGLE
========================================================= -->

<script>

    const togglePassword =
        document.getElementById("togglePassword");

    const password =
        document.getElementById("password");

    const passwordIcon =
        document.getElementById("passwordIcon");


    if (togglePassword && password && passwordIcon) {

        togglePassword.addEventListener("click", function () {

            if (password.type === "password") {

                password.type = "text";

                passwordIcon.classList.remove("bi-eye");

                passwordIcon.classList.add("bi-eye-slash");

            } else {

                password.type = "password";

                passwordIcon.classList.remove("bi-eye-slash");

                passwordIcon.classList.add("bi-eye");

            }

        });

    }

</script>


<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>