
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /*
     * ============================================================
     * PRESERVE FORM VALUES AFTER VALIDATION ERROR
     * ============================================================
     */

    String firstName = (String) request.getAttribute("firstName");
    String middleName = (String) request.getAttribute("middleName");
    String lastName = (String) request.getAttribute("lastName");
    String gender = (String) request.getAttribute("gender");
    String dateOfBirth = (String) request.getAttribute("dateOfBirth");
    String registrationNumber =
            (String) request.getAttribute("registrationNumber");
    String college = (String) request.getAttribute("college");
    String programme = (String) request.getAttribute("programme");
    String yearOfStudy =
            (String) request.getAttribute("yearOfStudy");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");

    /*
     * ============================================================
     * VALIDATION ERROR MESSAGES
     * ============================================================
     */

    String firstNameError =
            (String) request.getAttribute("firstNameError");

    String lastNameError =
            (String) request.getAttribute("lastNameError");

    String genderError =
            (String) request.getAttribute("genderError");

    String dateOfBirthError =
            (String) request.getAttribute("dateOfBirthError");

    String registrationNumberError =
            (String) request.getAttribute("registrationNumberError");

    String collegeError =
            (String) request.getAttribute("collegeError");

    String programmeError =
            (String) request.getAttribute("programmeError");

    String yearOfStudyError =
            (String) request.getAttribute("yearOfStudyError");

    String emailError =
            (String) request.getAttribute("emailError");

    String phoneError =
            (String) request.getAttribute("phoneError");

    String passwordError =
            (String) request.getAttribute("passwordError");

    String confirmPasswordError =
            (String) request.getAttribute("confirmPasswordError");

    String termsError =
            (String) request.getAttribute("termsError");

    String generalError =
            (String) request.getAttribute("generalError");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Student Registration | UDOM Online Quiz System
    </title>

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

        <!-- =======================================================
             LEFT SIDE
             ======================================================= -->

        <div class="col-lg-5 auth-intro d-none d-lg-flex">

            <div class="auth-intro-content">

                <!-- BRAND -->

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


                <!-- INTRODUCTION -->

                <div class="intro-content mt-5">

                    <span class="intro-label">
                        STUDENT PORTAL
                    </span>

                    <h1>

                        Start your

                        <span>
                            learning journey.
                        </span>

                    </h1>

                    <p>

                        Create your student account and gain access
                        to online quizzes, assessments and academic
                        performance tracking.

                    </p>


                    <!-- FEATURE 1 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>
                                Online Assessments
                            </strong>

                            <small>
                                Access quizzes from anywhere.
                            </small>

                        </div>

                    </div>


                    <!-- FEATURE 2 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>
                                Instant Results
                            </strong>

                            <small>
                                View your performance after submission.
                            </small>

                        </div>

                    </div>


                    <!-- FEATURE 3 -->

                    <div class="intro-feature">

                        <i class="bi bi-check-circle-fill"></i>

                        <div>

                            <strong>
                                Track Progress
                            </strong>

                            <small>
                                Keep your assessment history organized.
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


        <!-- =======================================================
             FORM SIDE
             ======================================================= -->

        <div class="col-lg-7 auth-form-side">

            <div class="registration-container">


                <!-- MOBILE BRAND -->

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


                <!-- =================================================
                     FORM HEADER
                     ================================================= -->

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


                    <!-- GENERAL ERROR -->

                    <% if (generalError != null) { %>

                        <div class="alert alert-danger mt-3"
                             role="alert">

                            <i class="bi bi-exclamation-triangle-fill me-2"></i>

                            <%= generalError %>

                        </div>

                    <% } %>

                </div>


                <!-- =================================================
                     REGISTRATION FORM
                     ================================================= -->

                <form action="student-register"
                      method="post"
                      id="registrationForm"
                      novalidate>


                    <!-- =================================================
                         PERSONAL INFORMATION
                         ================================================= -->

                    <div class="form-section-title">

                        <i class="bi bi-person"></i>

                        Personal Information

                    </div>


                    <div class="row g-3">


                        <!-- FIRST NAME -->

                        <div class="col-md-4">

                            <label for="firstName"
                                   class="form-label">

                                First Name

                            </label>

                            <input
                                type="text"
                                class="form-control <%= firstNameError != null ? "is-invalid" : "" %>"
                                id="firstName"
                                name="firstName"
                                placeholder="First name"
                                value="<%= firstName != null ? firstName : "" %>"
                                required>

                            <% if (firstNameError != null) { %>

                                <div class="invalid-feedback">

                                    <%= firstNameError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- MIDDLE NAME -->

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
                                placeholder="Middle name"
                                value="<%= middleName != null ? middleName : "" %>">

                        </div>


                        <!-- LAST NAME -->

                        <div class="col-md-4">

                            <label for="lastName"
                                   class="form-label">

                                Last Name

                            </label>

                            <input
                                type="text"
                                class="form-control <%= lastNameError != null ? "is-invalid" : "" %>"
                                id="lastName"
                                name="lastName"
                                placeholder="Last name"
                                value="<%= lastName != null ? lastName : "" %>"
                                required>

                            <% if (lastNameError != null) { %>

                                <div class="invalid-feedback">

                                    <%= lastNameError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- GENDER -->

                        <div class="col-md-6">

                            <label for="gender"
                                   class="form-label">

                                Gender

                            </label>

                            <select
                                class="form-select <%= genderError != null ? "is-invalid" : "" %>"
                                id="gender"
                                name="gender"
                                required>

                                <option value="">
                                    Select gender
                                </option>

                                <option value="MALE"
                                    <%= "MALE".equals(gender) ? "selected" : "" %>>
                                    MALE
                                </option>

                                <option value="FEMALE"
                                    <%= "FEMALE".equals(gender) ? "selected" : "" %>>
                                    FEMALE
                                </option>

                                <!--
                                <option value="OTHER">
                                    OTHER
                                </option>
                                -->

                            </select>

                            <% if (genderError != null) { %>

                                <div class="invalid-feedback">

                                    <%= genderError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- DATE OF BIRTH -->

                        <div class="col-md-6">

                            <label for="dateOfBirth"
                                   class="form-label">

                                Date of Birth

                            </label>

                            <input
                                type="date"
                                class="form-control <%= dateOfBirthError != null ? "is-invalid" : "" %>"
                                id="dateOfBirth"
                                name="dateOfBirth"
                                value="<%= dateOfBirth != null ? dateOfBirth : "" %>"
                                required>

                            <% if (dateOfBirthError != null) { %>

                                <div class="invalid-feedback">

                                    <%= dateOfBirthError %>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- =================================================
                         ACADEMIC INFORMATION
                         ================================================= -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-mortarboard"></i>

                        Academic Information

                    </div>


                    <div class="row g-3">


                        <!-- REGISTRATION NUMBER -->

                        <div class="col-md-6">

                            <label for="registrationNumber"
                                   class="form-label">

                                Registration Number

                            </label>

                            <input
                                type="text"
                                class="form-control <%= registrationNumberError != null ? "is-invalid" : "" %>"
                                id="registrationNumber"
                                name="registrationNumber"
                                placeholder="e.g. T25-03-17792"
                                value="<%= registrationNumber != null ? registrationNumber : "" %>"
                                required>

                            <% if (registrationNumberError != null) { %>

                                <div class="invalid-feedback">

                                    <%= registrationNumberError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- COLLEGE -->

                        <div class="col-md-6">

                            <label for="college"
                                   class="form-label">

                                College / School

                            </label>

                            <select
                                class="form-select <%= collegeError != null ? "is-invalid" : "" %>"
                                id="college"
                                name="college"
                                required>

                                <option value="">
                                    Select college / school
                                </option>

                                <option value="College of Informatics and Virtual Education"
                                    <%= "College of Informatics and Virtual Education".equals(college) ? "selected" : "" %>>
                                    College of Informatics and Virtual Education
                                </option>

                                <option value="College of Natural and Mathematical Sciences"
                                    <%= "College of Natural and Mathematical Sciences".equals(college) ? "selected" : "" %>>
                                    College of Natural and Mathematical Sciences
                                </option>

                                <option value="College of Business and Economics"
                                    <%= "College of Business and Economics".equals(college) ? "selected" : "" %>>
                                    College of Business and Economics
                                </option>

                                <option value="College of Education"
                                    <%= "College of Education".equals(college) ? "selected" : "" %>>
                                    College of Education
                                </option>

                                <option value="College of Humanities and Social Sciences"
                                    <%= "College of Humanities and Social Sciences".equals(college) ? "selected" : "" %>>
                                    College of Humanities and Social Sciences
                                </option>

                                <option value="College of Earth Sciences"
                                    <%= "College of Earth Sciences".equals(college) ? "selected" : "" %>>
                                    College of Earth Sciences
                                </option>

                                <option value="College of Health Sciences"
                                    <%= "College of Health Sciences".equals(college) ? "selected" : "" %>>
                                    College of Health Sciences
                                </option>

                                <option value="Other"
                                    <%= "Other".equals(college) ? "selected" : "" %>>
                                    Other
                                </option>

                            </select>

                            <% if (collegeError != null) { %>

                                <div class="invalid-feedback">

                                    <%= collegeError %>

                                </div>

                            <% } %>

                        </div>


                        <!--
                        ====================================================
                        DEPARTMENT
                        INTENTIONALLY EXCLUDED
                        ====================================================

                        <div class="col-md-6">

                            <label for="department"
                                   class="form-label">

                                Department

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                id="department"
                                name="department">

                        </div>

                        -->


                        <!-- PROGRAMME -->

                        <div class="col-md-8">

                            <label for="programme"
                                   class="form-label">

                                Programme / Course

                            </label>

                            <input
                                type="text"
                                class="form-control <%= programmeError != null ? "is-invalid" : "" %>"
                                id="programme"
                                name="programme"
                                placeholder="e.g. BSc.CSDFE OR BSc.SE"
                                value="<%= programme != null ? programme : "" %>"
                                required>

                            <% if (programmeError != null) { %>

                                <div class="invalid-feedback">

                                    <%= programmeError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- YEAR OF STUDY -->

                        <div class="col-md-4">

                            <label for="yearOfStudy"
                                   class="form-label">

                                Year of Study

                            </label>

                            <select
                                class="form-select <%= yearOfStudyError != null ? "is-invalid" : "" %>"
                                id="yearOfStudy"
                                name="yearOfStudy"
                                required>

                                <option value="">
                                    Select year
                                </option>

                                <option value="1"
                                    <%= "1".equals(yearOfStudy) ? "selected" : "" %>>
                                    Year 1
                                </option>

                                <option value="2"
                                    <%= "2".equals(yearOfStudy) ? "selected" : "" %>>
                                    Year 2
                                </option>

                                <option value="3"
                                    <%= "3".equals(yearOfStudy) ? "selected" : "" %>>
                                    Year 3
                                </option>

                                <option value="4"
                                    <%= "4".equals(yearOfStudy) ? "selected" : "" %>>
                                    Year 4
                                </option>

                                <!--
                                <option value="5">
                                    Year 5
                                </option>
                                -->

                            </select>

                            <% if (yearOfStudyError != null) { %>

                                <div class="invalid-feedback">

                                    <%= yearOfStudyError %>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- =================================================
                         CONTACT INFORMATION
                         ================================================= -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-telephone"></i>

                        Contact Information

                    </div>


                    <div class="row g-3">


                        <!-- EMAIL -->

                        <div class="col-md-6">

                            <label for="email"
                                   class="form-label">

                                Email Address

                            </label>

                            <input
                                type="email"
                                class="form-control <%= emailError != null ? "is-invalid" : "" %>"
                                id="email"
                                name="email"
                                placeholder="rasuliomari4@gmail.com"
                                value="<%= email != null ? email : "" %>"
                                required>

                            <% if (emailError != null) { %>

                                <div class="invalid-feedback">

                                    <%= emailError %>

                                </div>

                            <% } %>

                        </div>


                        <!-- PHONE -->

                        <div class="col-md-6">

                            <label for="phone"
                                   class="form-label">

                                Phone Number

                            </label>

                            <input
                                type="tel"
                                class="form-control <%= phoneError != null ? "is-invalid" : "" %>"
                                id="phone"
                                name="phone"
                                placeholder="+255 657 707 046"
                                value="<%= phone != null ? phone : "" %>"
                                required>

                            <% if (phoneError != null) { %>

                                <div class="invalid-feedback">

                                    <%= phoneError %>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- =================================================
                         ACCOUNT SECURITY
                         ================================================= -->

                    <div class="form-section-title mt-4">

                        <i class="bi bi-shield-lock"></i>

                        Account Security

                    </div>


                    <div class="row g-3">


                        <!-- PASSWORD -->

                        <div class="col-md-6">

                            <label for="password"
                                   class="form-label">

                                Password

                            </label>


                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control <%= passwordError != null ? "is-invalid" : "" %>"
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


                            <% if (passwordError != null) { %>

                                <div class="invalid-feedback d-block">

                                    <%= passwordError %>

                                </div>

                            <% } %>


                            <small class="text-muted">

                                Minimum 8 characters

                            </small>

                        </div>


                        <!-- CONFIRM PASSWORD -->

                        <div class="col-md-6">

                            <label for="confirmPassword"
                                   class="form-label">

                                Confirm Password

                            </label>


                            <div class="password-field">

                                <input
                                    type="password"
                                    class="form-control <%= confirmPasswordError != null ? "is-invalid" : "" %>"
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


                            <% if (confirmPasswordError != null) { %>

                                <div class="invalid-feedback d-block">

                                    <%= confirmPasswordError %>

                                </div>

                            <% } %>

                        </div>

                    </div>


                    <!-- =================================================
                         TERMS AND CONDITIONS
                         ================================================= -->

                    <div class="form-check terms-check mt-4">

                        <input
                            class="form-check-input <%= termsError != null ? "is-invalid" : "" %>"
                            type="checkbox"
                            id="terms"
                            name="terms"
                            value="accepted"
                            required>

                        <label class="form-check-label"
                               for="terms">

                            I confirm that the information provided is
                            accurate and I agree to the platform's
                            terms of use.

                        </label>


                        <% if (termsError != null) { %>

                            <div class="invalid-feedback d-block">

                                <%= termsError %>

                            </div>

                        <% } %>

                    </div>


                    <!-- =================================================
                         SUBMIT BUTTON
                         ================================================= -->

                    <button
                        type="submit"
                        class="btn btn-register w-100 mt-4">

                        <i class="bi bi-person-plus-fill me-2"></i>

                        Create Student Account

                    </button>


                    <!-- =================================================
                         LOGIN LINK
                         ================================================= -->

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


<!-- ===============================================================
     BOOTSTRAP JS
     =============================================================== -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<!-- ===============================================================
     PASSWORD TOGGLE
     =============================================================== -->

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
