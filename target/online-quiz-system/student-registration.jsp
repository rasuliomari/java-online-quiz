<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Registration | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/auth.css">

</head>

<body class="auth-page">


<div class="container-fluid">

    <div class="row min-vh-100">


        <!-- ================= LEFT SIDE ================= -->

        <div class="col-lg-5 auth-intro d-none d-lg-flex">

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
                        STUDENT PORTAL
                    </span>

                    <h1>
                        Start your
                        <span>learning journey.</span>
                    </h1>

                    <p>
                        Create your student account and gain access
                        to online quizzes, assessments and academic
                        performance tracking.
                    </p>


                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>
                            <strong>Online Assessments</strong>

                            <small>
                                Access quizzes from anywhere.
                            </small>
                        </div>

                    </div>


                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>
                            <strong>Instant Results</strong>

                            <small>
                                View your performance after submission.
                            </small>
                        </div>

                    </div>


                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>
                            <strong>Track Progress</strong>

                            <small>
                                Keep your assessment history organized.
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


        <!-- ================= FORM SIDE ================= -->

        <div class="col-lg-7 auth-form-side">

            <div class="registration-container">

                <div class="mobile-brand d-lg-none mb-4">

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
                        CREATE ACCOUNT
                    </span>

                    <h2>
                        Student Registration
                    </h2>

                    <p>
                        Enter your information below to create
                        your student account.
                    </p>

                </div>


                <!-- ================= REGISTRATION FORM ================= -->

                <form action="student-register"
                      method="post"
                      id="registrationForm"
                      novalidate>


                    <!-- PERSONAL INFORMATION -->

                    <div class="form-section-title">

                        <i class="bi bi-person"></i>

                        Personal Information

                    </div>


                    <div class="row g-3">


                        <div class="col-md-4">

                            <label for="firstName"
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
                                required>

                        </div>


                        <div class="col-md-4">

                            <label for="middleName"
                                   class="form-label">

                                Middle Name

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="middleName"
                                name="middleName"
                                placeholder="Middle name">

                        </div>


                        <div class="col-md-4">

                            <label for="lastName"
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
                                required>

                        </div>


                        <div class="col-md-6">

                            <label for="gender"
                                   class="form-label">

                                Gender
                                <span>*</span>

                            </label>

                            <select
                                class="form-select"
                                id="gender"
                                name="gender"
                                required>

                                <option value="">
                                    Select gender
                                </option>

                                <option value="MALE">
                                    Male
                                </option>

                                <option value="FEMALE">
                                    Female
                                </option>

                                <!-- <option value="OTHER">
                                    Other
                                </option> -->

                            </select>

                        </div>


                        <div class="col-md-6">

                            <label for="dateOfBirth"
                                   class="form-label">

                                Date of Birth
                                <span>*</span>

                            </label>

                            <input
                                type="date"
                                class="form-control"
                                id="dateOfBirth"
                                name="dateOfBirth"
                                required>

                        </div>


                    </div>


                    <!-- ACADEMIC INFORMATION -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-mortarboard"></i>

                        Academic Information

                    </div>


                    <div class="row g-3">


                        <div class="col-md-6">

                            <label for="registrationNumber"
                                   class="form-label">

                                Registration Number
                                <span>*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="registrationNumber"
                                name="registrationNumber"
                                placeholder="e.g. T25-03-17792"
                                required>

                        </div>


                        <div class="col-md-6">

                            <label for="college"
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

                                <option>
                                    College of Informatics and Virtual Education
                                </option>

                                <option>
                                    College of Natural and Mathematical Sciences
                                </option>

                                <option>
                                    College of Business and Economics
                                </option>

                                <option>
                                    College of Education
                                </option>

                                <option>
                                    College of Humanities and Social Sciences
                                </option>

                                <option>
                                    College of Earth Sciences
                                </option>

                                <option>
                                    College of Health Sciences
                                </option>

                                <option>
                                    Other
                                </option>

                            </select>

                        </div>


                        <div class="col-md-6">

                            <label for="department"
                                   class="form-label">

                                Department
                                <span>*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="department"
                                name="department"
                                placeholder="Department"
                                required>

                        </div>


                        <div class="col-md-6">

                            <label for="programme"
                                   class="form-label">

                                Programme / Course
                                <span>*</span>

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="programme"
                                name="programme"
                                placeholder="e.g. BSc.CSDFE OR BSc.SE"
                                required>

                        </div>


                        <div class="col-md-6">

                            <label for="yearOfStudy"
                                   class="form-label">

                                Year of Study
                                <span>*</span>

                            </label>

                            <select
                                class="form-select"
                                id="yearOfStudy"
                                name="yearOfStudy"
                                required>

                                <option value="">
                                    Select year
                                </option>

                                <option value="1">
                                    Year 1
                                </option>

                                <option value="2">
                                    Year 2
                                </option>

                                <option value="3">
                                    Year 3
                                </option>

                                <option value="4">
                                    Year 4
                                </option>

                                <!-- <option value="5">
                                    Year 5
                                </option> -->

                            </select>

                        </div>


                    </div>


                    <!-- CONTACT INFORMATION -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-telephone"></i>

                        Contact Information

                    </div>


                    <div class="row g-3">


                        <div class="col-md-6">

                            <label for="email"
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
                                    placeholder="rasuliomari4@gmail.com"
                                    required>

                            </div>

                        </div>


                        <div class="col-md-6">

                            <label for="phone"
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
                                    placeholder="+255 657 707 046"
                                    required>

                            </div>

                        </div>


                    </div>


                    <!-- ACCOUNT INFORMATION -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-shield-lock"></i>

                        Account Security

                    </div>


                    <div class="row g-3">


                        <div class="col-md-6">

                            <label for="password"
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
                                    onclick="togglePassword('password', this)">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                            <div class="password-help">
                                Minimum 8 characters
                            </div>

                        </div>


                        <div class="col-md-6">

                            <label for="confirmPassword"
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
                                    onclick="togglePassword('confirmPassword', this)">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                        </div>


                    </div>


                    <!-- TERMS -->

                    <div class="form-check terms-check mt-4">

                        <input
                            class="form-check-input"
                            type="checkbox"
                            id="terms"
                            required>

                        <label
                            class="form-check-label"
                            for="terms">

                            I confirm that the information provided
                            is accurate and I agree to the platform's
                            terms of use.

                        </label>

                    </div>


                    <!-- SUBMIT -->

                    <button
                        type="submit"
                        class="btn btn-register w-100 mt-4">

                        <i class="bi bi-person-plus-fill me-2"></i>

                        Create Student Account

                    </button>


                    <div class="login-link text-center mt-4">

                        Already have an account?

                        <a href="login.jsp">
                            Login here
                        </a>

                    </div>


                </form>

            </div>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<script>

function togglePassword(fieldId, button) {

    const field = document.getElementById(fieldId);

    const icon = button.querySelector("i");

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
