<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ==============================
    // ADMIN AUTHENTICATION
    // ==============================

    if (session == null
            || !Boolean.TRUE.equals(
                    session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(
                    session.getAttribute("userRole"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String adminFirstName =
            (String) session.getAttribute("adminFirstName");

    String adminLastName =
            (String) session.getAttribute("adminLastName");


    // ==============================
    // GET QUIZ ID
    // ==============================

    String quizIdParameter =
            request.getParameter("id");

    if (quizIdParameter == null
            || quizIdParameter.trim().isEmpty()) {

        response.sendRedirect("manage-quizzes.jsp");
        return;
    }

    int quizId;

    try {

        quizId = Integer.parseInt(quizIdParameter);

    } catch (NumberFormatException e) {

        response.sendRedirect("manage-quizzes.jsp");
        return;
    }


    // ==============================
    // QUIZ VARIABLES
    // ==============================

    String title = "";
    String course = "";
    String courseCode = "";
    String courseName = "";
    String description = "";

    int durationMinutes = 0;
    int questionCount = 0;
    int passMark = 0;

    String status = "";

    String teacherName = "Not assigned";

    boolean quizFound = false;


    // ==============================
    // LOAD QUIZ
    // ==============================

    String quizSql =
            "SELECT q.id, " +
            "q.title, " +
            "q.course, " +
            "q.description, " +
            "q.duration_minutes, " +
            "q.question_count, " +
            "q.pass_mark, " +
            "q.status, " +
            "c.course_code, " +
            "c.course_name, " +
            "t.first_name, " +
            "t.middle_name, " +
            "t.last_name " +
            "FROM quizzes q " +
            "LEFT JOIN courses c " +
            "ON q.course_id = c.id " +
            "LEFT JOIN teachers t " +
            "ON q.teacher_id = t.id " +
            "WHERE q.id = ?";


    try (Connection conn =
                 DBConnection.getConnection();

         PreparedStatement ps =
                 conn.prepareStatement(quizSql)) {

        ps.setInt(1, quizId);

        try (ResultSet rs =
                     ps.executeQuery()) {

            if (rs.next()) {

                quizFound = true;

                title =
                        rs.getString("title");

                course =
                        rs.getString("course");

                courseCode =
                        rs.getString("course_code");

                courseName =
                        rs.getString("course_name");

                description =
                        rs.getString("description");

                durationMinutes =
                        rs.getInt("duration_minutes");

                questionCount =
                        rs.getInt("question_count");

                passMark =
                        rs.getInt("pass_mark");

                status =
                        rs.getString("status");


                String firstName =
                        rs.getString("first_name");

                String middleName =
                        rs.getString("middle_name");

                String lastName =
                        rs.getString("last_name");


                StringBuilder teacher =
                        new StringBuilder();

                if (firstName != null
                        && !firstName.trim().isEmpty()) {

                    teacher.append(firstName);
                }

                if (middleName != null
                        && !middleName.trim().isEmpty()) {

                    if (teacher.length() > 0) {
                        teacher.append(" ");
                    }

                    teacher.append(middleName);
                }

                if (lastName != null
                        && !lastName.trim().isEmpty()) {

                    if (teacher.length() > 0) {
                        teacher.append(" ");
                    }

                    teacher.append(lastName);
                }

                if (teacher.length() > 0) {
                    teacherName = teacher.toString();
                }
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
%>

<div class="alert alert-danger">
    Unable to load quiz information.
</div>

<%
        return;
    }


    if (!quizFound) {

        response.sendRedirect("manage-quizzes.jsp?error=not_found");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>View Quiz - UDOM Online Quiz System</title>


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


<!-- ===================================================== -->
<!-- NAVBAR -->
<!-- ===================================================== -->

<nav class="navbar dashboard-navbar">

    <div class="container-fluid">

        <button
            class="btn btn-light d-lg-none"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>


        <a
            href="dashboard.jsp"
            class="navbar-brand dashboard-brand">

            <i class="bi bi-mortarboard-fill"></i>

            <span>
                UDOM
                <small>Online Quiz System</small>
            </span>

        </a>


        <div class="ms-auto d-flex align-items-center">


            <!-- Notification -->

            <button
                class="btn notification-btn me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    4
                </span>

            </button>


            <!-- Admin Profile -->

            <div class="dropdown">

                <button
                    class="btn profile-btn dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <span class="profile-avatar">

                        <%= adminFirstName != null
                                ? adminFirstName.substring(0, 1).toUpperCase()
                                : "A" %>

                    </span>

                    <span class="d-none d-md-inline">

                        <%= adminFirstName != null
                                ? adminFirstName
                                : "Admin" %>

                    </span>

                </button>


                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a
                            class="dropdown-item"
                            href="dashboard.jsp">

                            <i class="bi bi-speedometer2 me-2"></i>
                            Dashboard

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



<!-- ===================================================== -->
<!-- SIDEBAR -->
<!-- ===================================================== -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">


    <div class="offcanvas-header">

        <h5 class="offcanvas-title">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM Admin

        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas"
            data-bs-target="#adminSidebar">
        </button>

    </div>


    <div class="offcanvas-body d-flex flex-column">


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

                <small>
                    Administrator
                </small>

            </div>

        </div>


        <!-- MENU -->

        <div class="sidebar-menu-title">
            MAIN MENU
        </div>


        <a
            href="dashboard.jsp"
            class="sidebar-link">

            <i class="bi bi-speedometer2"></i>

            <span>Dashboard</span>

        </a>


        <a
            href="manage-students.jsp"
            class="sidebar-link">

            <i class="bi bi-people-fill"></i>

            <span>Manage Students</span>

        </a>


        <a
            href="manage-teachers.jsp"
            class="sidebar-link">

            <i class="bi bi-person-badge-fill"></i>

            <span>Manage Teachers</span>

        </a>


        <a
            href="manage-quizzes.jsp"
            class="sidebar-link active">

            <i class="bi bi-question-circle-fill"></i>

            <span>Manage Quizzes</span>

        </a>


        <a
            href="assign-courses.jsp"
            class="sidebar-link">

            <i class="bi bi-journal-bookmark-fill"></i>

            <span>Assign Courses</span>

        </a>


        <div class="sidebar-menu-title mt-4">
            SYSTEM
        </div>


        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>Reports</span>

        </a>


        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-gear-fill"></i>

            <span>Settings</span>

        </a>


        <div class="mt-auto">

            <a
                href="../logout"
                class="sidebar-link text-danger">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </div>

</div>



<!-- ===================================================== -->
<!-- MAIN CONTENT -->
<!-- ===================================================== -->

<main class="dashboard-main">


    <div class="dashboard-container">


        <!-- Breadcrumb -->

        <div class="mb-3">

            <a
                href="manage-quizzes.jsp"
                class="text-decoration-none">

                <i class="bi bi-arrow-left"></i>

                Back to Manage Quizzes

            </a>

        </div>


        <!-- PAGE HEADER -->

        <div class="welcome-section mb-4">

            <div>

                <div class="text-muted small">
                    QUIZ MANAGEMENT
                </div>

                <h2 class="fw-bold mb-1">
                    View Quiz
                </h2>

                <p class="text-muted mb-0">
                    View complete quiz information, questions and answers.
                </p>

            </div>


            <div class="mt-3 mt-md-0">

                <a
                    href="edit-quiz.jsp?id=<%= quizId %>"
                    class="btn btn-primary">

                    <i class="bi bi-pencil-square me-1"></i>

                    Edit Quiz

                </a>

            </div>

        </div>



        <!-- ================================================= -->
        <!-- QUIZ INFORMATION -->
        <!-- ================================================= -->

        <div class="content-card mb-4">

            <div class="card-header-custom">

                <div>

                    <h5 class="mb-1">

                        <i class="bi bi-question-circle-fill me-2"></i>

                        <%= title %>

                    </h5>

                    <small class="text-muted">
                        Quiz ID: <%= quizId %>
                    </small>

                </div>


                <div>

                    <%
                        if ("PUBLISHED".equalsIgnoreCase(status)) {
                    %>

                        <span class="badge bg-success">
                            Published
                        </span>

                    <%
                        } else {
                    %>

                        <span class="badge bg-warning text-dark">
                            Draft
                        </span>

                    <%
                        }
                    %>

                </div>

            </div>


            <div class="p-4">


                <div class="row g-4">


                    <!-- Course -->

                    <div class="col-md-6">

                        <div class="quiz-detail-box">

                            <small class="text-muted">
                                COURSE
                            </small>

                            <h6 class="mb-0 mt-1">

                                <%= courseCode != null
                                        ? courseCode
                                        : course %>

                            </h6>

                            <small class="text-muted">

                                <%= courseName != null
                                        ? courseName
                                        : "" %>

                            </small>

                        </div>

                    </div>


                    <!-- Teacher -->

                    <div class="col-md-6">

                        <div class="quiz-detail-box">

                            <small class="text-muted">
                                TEACHER
                            </small>

                            <h6 class="mb-0 mt-1">
                                <%= teacherName %>
                            </h6>

                        </div>

                    </div>


                    <!-- Duration -->

                    <div class="col-md-4">

                        <div class="quiz-detail-box">

                            <small class="text-muted">
                                DURATION
                            </small>

                            <h6 class="mb-0 mt-1">

                                <%= durationMinutes %> minutes

                            </h6>

                        </div>

                    </div>


                    <!-- Questions -->

                    <div class="col-md-4">

                        <div class="quiz-detail-box">

                            <small class="text-muted">
                                QUESTIONS
                            </small>

                            <h6 class="mb-0 mt-1">

                                <%= questionCount %>

                            </h6>

                        </div>

                    </div>


                    <!-- Pass Mark -->

                    <div class="col-md-4">

                        <div class="quiz-detail-box">

                            <small class="text-muted">
                                PASS MARK
                            </small>

                            <h6 class="mb-0 mt-1">

                                <%= passMark %>%

                            </h6>

                        </div>

                    </div>


                </div>


                <!-- Description -->

                <div class="mt-4">

                    <small class="text-muted">
                        DESCRIPTION
                    </small>

                    <p class="mt-2 mb-0">

                        <%= description != null
                                && !description.trim().isEmpty()
                                ? description
                                : "No description provided." %>

                    </p>

                </div>

            </div>

        </div>



        <!-- ================================================= -->
        <!-- QUESTIONS -->
        <!-- ================================================= -->

        <div class="content-card">

            <div class="card-header-custom">

                <div>

                    <h5 class="mb-0">

                        <i class="bi bi-list-ol me-2"></i>

                        Quiz Questions

                    </h5>

                    <small class="text-muted">
                        Questions and answer choices
                    </small>

                </div>

                <span class="badge bg-primary">

                    <%= questionCount %> Questions

                </span>

            </div>


            <div class="p-4">


<%
    String questionsSql =
            "SELECT id, question_number, question_text " +
            "FROM questions " +
            "WHERE quiz_id = ? " +
            "ORDER BY question_number";

    try (Connection conn =
                 DBConnection.getConnection();

         PreparedStatement questionPs =
                 conn.prepareStatement(questionsSql)) {

        questionPs.setInt(1, quizId);

        try (ResultSet questionRs =
                     questionPs.executeQuery()) {

            boolean hasQuestions = false;

            while (questionRs.next()) {

                hasQuestions = true;

                int questionId =
                        questionRs.getInt("id");

                int questionNumber =
                        questionRs.getInt("question_number");

                String questionText =
                        questionRs.getString("question_text");
%>


                <div class="quiz-question-item mb-4">

                    <div class="d-flex align-items-start">


                        <div class="quiz-question-number">

                            <%= questionNumber %>

                        </div>


                        <div class="flex-grow-1 ms-3">

                            <h6 class="fw-semibold mb-3">

                                <%= questionText %>

                            </h6>


<%
                String answersSql =
                        "SELECT option_label, answer_text, is_correct " +
                        "FROM answers " +
                        "WHERE question_id = ? " +
                        "ORDER BY option_label";

                try (PreparedStatement answerPs =
                             conn.prepareStatement(answersSql)) {

                    answerPs.setInt(1, questionId);

                    try (ResultSet answerRs =
                                 answerPs.executeQuery()) {

                        while (answerRs.next()) {

                            String optionLabel =
                                    answerRs.getString("option_label");

                            String answerText =
                                    answerRs.getString("answer_text");

                            boolean isCorrect =
                                    answerRs.getBoolean("is_correct");
%>


                            <div class="quiz-answer-option
                                <%= isCorrect
                                        ? "correct-answer"
                                        : "" %>">

                                <span class="answer-label">

                                    <%= optionLabel %>

                                </span>

                                <span class="answer-text">

                                    <%= answerText %>

                                </span>


                                <%
                                    if (isCorrect) {
                                %>

                                    <span class="ms-auto text-success">

                                        <i class="bi bi-check-circle-fill"></i>

                                        Correct

                                    </span>

                                <%
                                    }
                                %>

                            </div>


<%
                        }
                    }
                }
%>

                        </div>

                    </div>

                </div>


<%
            }

            if (!hasQuestions) {
%>

                <div class="text-center py-5">

                    <i
                        class="bi bi-question-circle display-4 text-muted">
                    </i>

                    <h5 class="mt-3">
                        No Questions Found
                    </h5>

                    <p class="text-muted">
                        This quiz does not have any questions yet.
                    </p>

                </div>

<%
            }

        }

    } catch (Exception e) {

        e.printStackTrace();
%>

        <div class="alert alert-danger">

            Unable to load quiz questions.

        </div>

<%
    }
%>

            </div>

        </div>



        <!-- FOOTER -->

        <div class="dashboard-footer mt-4">

            <p class="mb-0">

                &copy; 2026 University of Dodoma.
                UDOM Online Quiz System.

            </p>

        </div>

    </div>

</main>



<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>