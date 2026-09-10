<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ============================
    // ADMIN AUTHENTICATION
    // ============================
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

    String quizIdParameter =
            request.getParameter("id");

    if (quizIdParameter == null
            || quizIdParameter.trim().isEmpty()) {

        response.sendRedirect("manage-quizzes.jsp?error=invalid_quiz");
        return;
    }

    int quizId;

    try {
        quizId = Integer.parseInt(quizIdParameter);
    } catch (NumberFormatException e) {

        response.sendRedirect("manage-quizzes.jsp?error=invalid_quiz");
        return;
    }

    // ============================
    // QUIZ VARIABLES
    // ============================
    String title = "";
    String course = "";
    String description = "";
    int durationMinutes = 30;
    int questionCount = 0;
    int passMark = 50;
    String status = "DRAFT";
    int courseId = 0;

    boolean quizFound = false;

    // ============================
    // LOAD QUIZ
    // ============================
    String quizSql =
            "SELECT q.id, q.title, q.course, q.description, " +
            "q.duration_minutes, q.question_count, q.pass_mark, " +
            "q.status, q.course_id " +
            "FROM quizzes q " +
            "WHERE q.id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(quizSql)) {

        ps.setInt(1, quizId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                quizFound = true;

                title = rs.getString("title");
                course = rs.getString("course");
                description = rs.getString("description");

                durationMinutes =
                        rs.getInt("duration_minutes");

                questionCount =
                        rs.getInt("question_count");

                passMark =
                        rs.getInt("pass_mark");

                status =
                        rs.getString("status");

                courseId =
                        rs.getInt("course_id");
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                "manage-quizzes.jsp?error=database_error");

        return;
    }

    if (!quizFound) {

        response.sendRedirect(
                "manage-quizzes.jsp?error=quiz_not_found");

        return;
    }

    // ============================
    // GET ACTUAL QUESTION COUNT
    // ============================
    String questionCountSql =
            "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps =
                 conn.prepareStatement(questionCountSql)) {

        ps.setInt(1, quizId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                questionCount = rs.getInt(1);
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
    }

    // ============================
    // LOAD COURSES
    // ============================
    String coursesSql =
            "SELECT id, course_code, course_name " +
            "FROM courses " +
            "ORDER BY course_code";
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit Quiz - UDOM Online Quiz System</title>

    <!-- Bootstrap -->
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

</head>

<body>

<!-- =========================================
     NAVBAR
========================================= -->

<nav class="navbar navbar-expand-lg dashboard-navbar">

    <div class="container-fluid">

        <!-- Brand -->

        <a class="navbar-brand d-flex align-items-center"
           href="dashboard.jsp">

            <i class="bi bi-mortarboard-fill me-2"></i>

            <span>
                <strong>UDOM</strong>
                <small>Online Quiz System</small>
            </span>

        </a>


        <!-- Mobile Sidebar Button -->

        <button
            class="btn btn-outline-light d-lg-none"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>


        <!-- Right Side -->

        <div class="d-flex align-items-center ms-auto">

            <!-- Notification -->

            <button
                class="btn btn-link text-white position-relative me-3">

                <i class="bi bi-bell fs-5"></i>

                <span
                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">

                    4

                </span>

            </button>


            <!-- Admin Profile -->

            <div class="dropdown">

                <button
                    class="btn btn-link text-white dropdown-toggle text-decoration-none"
                    data-bs-toggle="dropdown">

                    <span class="dashboard-avatar">

                        <%= adminFirstName != null
                                ? adminFirstName.substring(0, 1).toUpperCase()
                                : "A" %>

                    </span>

                    <span class="d-none d-md-inline ms-2">

                        <%= adminFirstName != null
                                ? adminFirstName
                                : "Admin" %>

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
                        <a class="dropdown-item"
                           href="../LogoutServlet">

                            <i class="bi bi-box-arrow-right me-2"></i>
                            Logout

                        </a>
                    </li>

                </ul>

            </div>

        </div>

    </div>

</nav>


<!-- =========================================
     SIDEBAR
========================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">

    <div class="offcanvas-header">

        <h5 class="offcanvas-title">

            <i class="bi bi-speedometer2 me-2"></i>

            Admin Panel

        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="offcanvas-body p-0">

        <!-- Sidebar Profile -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">

                <%= adminFirstName != null
                        ? adminFirstName.substring(0, 1).toUpperCase()
                        : "A" %>

            </div>

            <div>

                <strong>

                    <%= adminFirstName != null
                            ? adminFirstName
                            : "Admin" %>

                    <%= adminLastName != null
                            ? adminLastName
                            : "" %>

                </strong>

                <small>Administrator</small>

            </div>

        </div>


        <!-- Menu -->

        <div class="sidebar-menu">

            <div class="sidebar-menu-title">
                MAIN
            </div>


            <a href="dashboard.jsp"
               class="sidebar-link">

                <i class="bi bi-speedometer2"></i>

                Dashboard

            </a>


            <div class="sidebar-menu-title">
                USER MANAGEMENT
            </div>


            <a href="manage-students.jsp"
               class="sidebar-link">

                <i class="bi bi-people"></i>

                Manage Students

            </a>


            <a href="manage-teachers.jsp"
               class="sidebar-link">

                <i class="bi bi-person-workspace"></i>

                Manage Teachers

            </a>


            <div class="sidebar-menu-title">
                ACADEMIC
            </div>


            <a href="manage-quizzes.jsp"
               class="sidebar-link active">

                <i class="bi bi-question-circle"></i>

                Manage Quizzes

            </a>


            <a href="manage-courses.jsp"
               class="sidebar-link">

                <i class="bi bi-book"></i>

                Manage Courses

            </a>


            <a href="assign-courses.jsp"
               class="sidebar-link">

                <i class="bi bi-person-plus"></i>

                Assign Courses

            </a>


            <div class="sidebar-menu-title">
                SYSTEM
            </div>


            <a href="#"
               class="sidebar-link">

                <i class="bi bi-bar-chart"></i>

                Reports

            </a>


            <a href="#"
               class="sidebar-link">

                <i class="bi bi-gear"></i>

                Settings

            </a>


            <a href="../LogoutServlet"
               class="sidebar-link text-danger">

                <i class="bi bi-box-arrow-right"></i>

                Logout

            </a>

        </div>

    </div>

</div>


<!-- =========================================
     MAIN CONTENT
========================================= -->

<main class="dashboard-main">

    <div class="dashboard-container">


        <!-- Breadcrumb / Header -->

        <div class="mb-4">

            <div class="text-muted small mb-2">

                QUIZ MANAGEMENT

            </div>

            <div class="d-flex flex-wrap
                        justify-content-between
                        align-items-center">

                <div>

                    <h2 class="mb-1">

                        <i class="bi bi-pencil-square me-2"></i>

                        Edit Quiz

                    </h2>

                    <p class="text-muted mb-0">

                        Update quiz information and settings.

                    </p>

                </div>


                <a href="view-quiz.jsp?id=<%= quizId %>"
                   class="btn btn-outline-primary">

                    <i class="bi bi-eye me-1"></i>

                    View Quiz

                </a>

            </div>

        </div>


        <!-- =====================================
             SUCCESS MESSAGE
        ====================================== -->

        <%
            String updated =
                    request.getParameter("updated");

            if ("success".equals(updated)) {
        %>

            <div class="alert alert-success alert-dismissible fade show">

                <i class="bi bi-check-circle me-2"></i>

                Quiz updated successfully.

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        <%
            }
        %>


        <!-- =====================================
             ERROR MESSAGES
        ====================================== -->

        <%
            String error =
                    request.getParameter("error");

            if ("invalid_data".equals(error)) {
        %>

            <div class="alert alert-danger">

                <i class="bi bi-exclamation-triangle me-2"></i>

                Please provide valid information for all required fields.

            </div>

        <%
            } else if ("invalid_duration".equals(error)) {
        %>

            <div class="alert alert-danger">

                Duration must be greater than zero.

            </div>

        <%
            } else if ("invalid_pass_mark".equals(error)) {
        %>

            <div class="alert alert-danger">

                Pass mark must be between 1 and 100.

            </div>

        <%
            } else if ("invalid_course".equals(error)) {
        %>

            <div class="alert alert-danger">

                Please select a valid course.

            </div>

        <%
            } else if ("database_error".equals(error)) {
        %>

            <div class="alert alert-danger">

                A database error occurred while updating the quiz.

            </div>

        <%
            }
        %>


        <!-- =====================================
             EDIT FORM
        ====================================== -->

        <div class="content-card">

            <div class="card-header-custom">

                <div>

                    <h5 class="mb-1">

                        <i class="bi bi-question-circle me-2"></i>

                        Quiz Information

                    </h5>

                    <small class="text-muted">

                        Quiz ID: #<%= quizId %>

                    </small>

                </div>

            </div>


            <div class="p-4">

                <form
                    method="post"
                    action="../adminUpdateQuiz">


                    <!-- Hidden Quiz ID -->

                    <input
                        type="hidden"
                        name="quizId"
                        value="<%= quizId %>">


                    <div class="row g-4">


                        <!-- Quiz Title -->

                        <div class="col-md-8">

                            <label class="form-label fw-semibold">

                                Quiz Title

                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="text"
                                name="title"
                                class="form-control"
                                value="<%= title != null ? title : "" %>"
                                maxlength="200"
                                required>

                        </div>


                        <!-- Status -->

                        <div class="col-md-4">

                            <label class="form-label fw-semibold">

                                Status

                                <span class="text-danger">*</span>

                            </label>

                            <select
                                name="status"
                                class="form-select"
                                required>

                                <option
                                    value="DRAFT"
                                    <%= "DRAFT".equals(status)
                                            ? "selected"
                                            : "" %>>

                                    Draft

                                </option>

                                <option
                                    value="PUBLISHED"
                                    <%= "PUBLISHED".equals(status)
                                            ? "selected"
                                            : "" %>>

                                    Published

                                </option>

                            </select>

                        </div>


                        <!-- Course -->

                        <div class="col-md-8">

                            <label class="form-label fw-semibold">

                                Course

                                <span class="text-danger">*</span>

                            </label>

                            <select
                                name="courseId"
                                class="form-select"
                                required>

                                <option value="">

                                    Select Course

                                </option>

                                <%
                                    try (Connection conn =
                                            DBConnection.getConnection();
                                         PreparedStatement ps =
                                            conn.prepareStatement(coursesSql);
                                         ResultSet rs =
                                            ps.executeQuery()) {

                                        while (rs.next()) {

                                            int currentCourseId =
                                                    rs.getInt("id");

                                            String courseCode =
                                                    rs.getString("course_code");

                                            String courseName =
                                                    rs.getString("course_name");
                                %>

                                    <option
                                        value="<%= currentCourseId %>"
                                        <%= currentCourseId == courseId
                                                ? "selected"
                                                : "" %>>

                                        <%= courseCode %>
                                        -
                                        <%= courseName %>

                                    </option>

                                <%
                                        }

                                    } catch (Exception e) {

                                        e.printStackTrace();
                                %>

                                    <option value="">

                                        Unable to load courses

                                    </option>

                                <%
                                    }
                                %>

                            </select>

                        </div>


                        <!-- Question Count -->

                        <div class="col-md-4">

                            <label class="form-label fw-semibold">

                                Questions

                            </label>

                            <input
                                type="text"
                                class="form-control"
                                value="<%= questionCount %>"
                                readonly>

                            <small class="text-muted">

                                Automatically calculated from quiz questions.

                            </small>

                        </div>


                        <!-- Duration -->

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">

                                Duration (Minutes)

                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="number"
                                name="durationMinutes"
                                class="form-control"
                                value="<%= durationMinutes %>"
                                min="1"
                                max="600"
                                required>

                        </div>


                        <!-- Pass Mark -->

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">

                                Pass Mark (%)

                                <span class="text-danger">*</span>

                            </label>

                            <input
                                type="number"
                                name="passMark"
                                class="form-control"
                                value="<%= passMark %>"
                                min="1"
                                max="100"
                                required>

                        </div>


                        <!-- Description -->

                        <div class="col-12">

                            <label class="form-label fw-semibold">

                                Description

                            </label>

                            <textarea
                                name="description"
                                class="form-control"
                                rows="5"
                                maxlength="5000"
                                placeholder="Enter quiz description..."><%= description != null ? description : "" %></textarea>

                        </div>


                    </div>


                    <!-- Information -->

                    <div class="alert alert-info mt-4">

                        <div class="d-flex">

                            <i class="bi bi-info-circle-fill me-2"></i>

                            <div>

                                <strong>Important:</strong>

                                The number of questions is calculated
                                automatically from the questions stored
                                for this quiz.

                            </div>

                        </div>

                    </div>


                    <!-- Buttons -->

                    <div class="d-flex
                                justify-content-between
                                align-items-center
                                mt-4">

                        <a href="manage-quizzes.jsp"
                           class="btn btn-outline-secondary">

                            <i class="bi bi-arrow-left me-1"></i>

                            Cancel

                        </a>


                        <button
                            type="submit"
                            class="btn btn-primary">

                            <i class="bi bi-check-circle me-1"></i>

                            Update Quiz

                        </button>

                    </div>


                </form>

            </div>

        </div>


        <!-- =====================================
             MANAGEMENT INFORMATION
        ====================================== -->

        <div class="content-card mt-4">

            <div class="card-header-custom">

                <h5 class="mb-0">

                    <i class="bi bi-shield-check me-2"></i>

                    Quiz Management

                </h5>

            </div>

            <div class="p-4">

                <div class="row g-4">

                    <div class="col-md-4">

                        <div class="d-flex">

                            <i class="bi bi-pencil-square
                                      fs-3
                                      text-primary
                                      me-3"></i>

                            <div>

                                <h6>Edit Information</h6>

                                <p class="text-muted small mb-0">

                                    Update the quiz title, course,
                                    description and settings.

                                </p>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-4">

                        <div class="d-flex">

                            <i class="bi bi-list-ol
                                      fs-3
                                      text-success
                                      me-3"></i>

                            <div>

                                <h6>Questions</h6>

                                <p class="text-muted small mb-0">

                                    The question count is automatically
                                    synchronized with stored questions.

                                </p>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-4">

                        <div class="d-flex">

                            <i class="bi bi-check2-circle
                                      fs-3
                                      text-warning
                                      me-3"></i>

                            <div>

                                <h6>Quiz Status</h6>

                                <p class="text-muted small mb-0">

                                    Draft quizzes can be prepared before
                                    publishing them to students.

                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- Footer -->

        <footer class="dashboard-footer mt-5">

            <p class="mb-0">

                &copy; <%= java.time.Year.now() %>
                University of Dodoma.
                UDOM Online Quiz System.

            </p>

        </footer>


    </div>

</main>


<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>