<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ==============================
    // TEACHER AUTHENTICATION
    // ==============================
    if (session == null
            || session.getAttribute("teacherLoggedIn") == null
            || !Boolean.TRUE.equals(session.getAttribute("teacherLoggedIn"))
            || !"TEACHER".equals(session.getAttribute("userRole"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    Integer teacherId = (Integer) session.getAttribute("teacherId");

    if (teacherId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String teacherFirstName =
            (String) session.getAttribute("teacherFirstName");

    String teacherLastName =
            (String) session.getAttribute("teacherLastName");

    String selectedQuizId = request.getParameter("quizId");

    int selectedQuiz = 0;

    if (selectedQuizId != null && !selectedQuizId.trim().isEmpty()) {
        try {
            selectedQuiz = Integer.parseInt(selectedQuizId);
        } catch (NumberFormatException e) {
            selectedQuiz = 0;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Student Results - UDOM Online Quiz System</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="../css/dashboard.css">
</head>

<body>

<div class="container-fluid">

    <div class="row">

        <!-- ================= SIDEBAR ================= -->
        <div class="offcanvas-lg offcanvas-start col-lg-2 teacher-sidebar"
             tabindex="-1"
             id="teacherSidebar">

            <div class="offcanvas-header d-lg-none">
                <h5 class="fw-bold">UDOM Online Quiz</h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="offcanvas"
                        data-bs-target="#teacherSidebar">
                </button>
            </div>

            <div class="offcanvas-body p-0">

                <div class="p-4">

                    <h5 class="fw-bold">
                        <i class="bi bi-mortarboard-fill me-2"></i>
                        UDOM
                    </h5>

                    <small class="text-muted">
                        Online Quiz System
                    </small>

                </div>

                <div class="px-3">

                    <a href="dashboard.jsp"
                       class="sidebar-link">
                        <i class="bi bi-speedometer2"></i>
                        Dashboard
                    </a>

                    <a href="create-quiz.jsp"
                       class="sidebar-link">
                        <i class="bi bi-plus-circle"></i>
                        Create Quiz
                    </a>

                    <a href="review-quiz.jsp"
                       class="sidebar-link">
                        <i class="bi bi-journal-text"></i>
                        My Quizzes
                    </a>

                    <a href="add-questions.jsp"
                       class="sidebar-link">
                        <i class="bi bi-question-circle"></i>
                        Questions
                    </a>

                    <a href="results.jsp"
                       class="sidebar-link active">
                        <i class="bi bi-bar-chart-fill"></i>
                        Student Results
                    </a>

                    <a href="results.jsp"
                       class="sidebar-link">
                        <i class="bi bi-file-earmark-bar-graph"></i>
                        Quiz Reports
                    </a>

                    <hr>

                    <a href="../logout"
                       class="sidebar-link text-danger">
                        <i class="bi bi-box-arrow-right"></i>
                        Logout
                    </a>

                </div>

            </div>
        </div>


        <!-- ================= MAIN CONTENT ================= -->
        <div class="col-lg-10 ms-auto p-0">

            <!-- NAVBAR -->
            <nav class="navbar navbar-expand-lg dashboard-navbar px-4">

                <button class="btn btn-outline-primary d-lg-none"
                        type="button"
                        data-bs-toggle="offcanvas"
                        data-bs-target="#teacherSidebar">

                    <i class="bi bi-list"></i>

                </button>

                <div class="ms-auto dropdown">

                    <button class="btn dropdown-toggle d-flex align-items-center"
                            data-bs-toggle="dropdown">

                        <div class="rounded-circle bg-primary text-white
                                    d-flex align-items-center justify-content-center me-2"
                             style="width:40px;height:40px;">

                            <%= teacherFirstName != null
                                    ? teacherFirstName.substring(0, 1).toUpperCase()
                                    : "T" %>

                        </div>

                        <span>
                            <%= teacherFirstName != null
                                    ? teacherFirstName
                                    : "Teacher" %>
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
                               href="../logout">
                                <i class="bi bi-box-arrow-right me-2"></i>
                                Logout
                            </a>
                        </li>

                    </ul>

                </div>

            </nav>


            <!-- CONTENT -->
            <main class="p-4">

                <div class="mb-4">

                    <h2 class="fw-bold">
                        <i class="bi bi-bar-chart-fill me-2"></i>
                        Student Results
                    </h2>

                    <p class="text-muted">
                        View student performance for your quizzes.
                    </p>

                </div>


                <!-- ================= QUIZ SELECTION ================= -->

                <div class="card border-0 shadow-sm rounded-4 mb-4">

                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-3">
                            <i class="bi bi-journal-check me-2"></i>
                            Select Quiz
                        </h5>

                        <form method="get"
                              action="results.jsp">

                            <div class="row g-3 align-items-end">

                                <div class="col-md-9">

                                    <label class="form-label fw-semibold">
                                        Quiz
                                    </label>

                                    <select name="quizId"
                                            class="form-select"
                                            required>

                                        <option value="">
                                            -- Select Your Quiz --
                                        </option>

                                        <%
                                            try (Connection conn =
                                                     DBConnection.getConnection();
                                                 PreparedStatement ps =
                                                     conn.prepareStatement(
                                                         "SELECT id, title, course, status " +
                                                         "FROM quizzes " +
                                                         "WHERE teacher_id = ? " +
                                                         "ORDER BY created_at DESC")) {

                                                ps.setInt(1, teacherId);

                                                try (ResultSet rs = ps.executeQuery()) {

                                                    while (rs.next()) {

                                                        int id = rs.getInt("id");
                                                        String title = rs.getString("title");
                                                        String course = rs.getString("course");
                                                        String status = rs.getString("status");
                                        %>

                                        <option value="<%= id %>"
                                            <%= selectedQuiz == id ? "selected" : "" %>>

                                            <%= title %>
                                            -
                                            <%= course %>
                                            [<%= status %>]

                                        </option>

                                        <%
                                                    }
                                                }

                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        %>

                                    </select>

                                </div>

                                <div class="col-md-3">

                                    <button type="submit"
                                            class="btn btn-primary w-100">

                                        <i class="bi bi-search me-1"></i>
                                        View Results

                                    </button>

                                </div>

                            </div>

                        </form>

                    </div>

                </div>


                <% if (selectedQuiz > 0) { %>

                <!-- ================= RESULTS ================= -->

                <div class="card border-0 shadow-sm rounded-4">

                    <div class="card-body p-4">

                        <div class="d-flex justify-content-between
                                    align-items-center mb-4">

                            <div>

                                <h5 class="fw-bold mb-1">
                                    Student Attempts
                                </h5>

                                <small class="text-muted">
                                    Results for the selected quiz
                                </small>

                            </div>

                        </div>


                        <div class="table-responsive">

                            <table class="table table-hover align-middle">

                                <thead class="table-light">

                                <tr>
                                    <th>#</th>
                                    <th>Student</th>
                                    <th>Registration Number</th>
                                    <th>Score</th>
                                    <th>Percentage</th>
                                    <th>Status</th>
                                    <th>Submitted</th>
                                    <th>Action</th>
                                </tr>

                                </thead>

                                <tbody>

                                <%
                                    int number = 1;
                                    boolean found = false;

                                    try (Connection conn =
                                             DBConnection.getConnection();
                                         PreparedStatement ps =
                                             conn.prepareStatement(

                                                 "SELECT qa.id AS attempt_id, " +
                                                 "qa.quiz_id, " +
                                                 "s.first_name, " +
                                                 "s.middle_name, " +
                                                 "s.last_name, " +
                                                 "s.registration_number, " +
                                                 "qa.score, " +
                                                 "qa.total_questions, " +
                                                 "qa.percentage, " +
                                                 "qa.result_status, " +
                                                 "qa.submitted_at " +

                                                 "FROM quiz_attempts qa " +

                                                 "INNER JOIN students s " +
                                                 "ON qa.student_id = s.id " +

                                                 "INNER JOIN quizzes q " +
                                                 "ON qa.quiz_id = q.id " +

                                                 "WHERE qa.quiz_id = ? " +
                                                 "AND q.teacher_id = ? " +

                                                 "ORDER BY qa.submitted_at DESC")) {

                                        ps.setInt(1, selectedQuiz);
                                        ps.setInt(2, teacherId);

                                        try (ResultSet rs =
                                                 ps.executeQuery()) {

                                            while (rs.next()) {

                                                found = true;

                                                int attemptId =
                                                        rs.getInt("attempt_id");

                                                String middle =
                                                        rs.getString("middle_name");

                                                String fullName =
                                                        rs.getString("first_name")
                                                        + " "
                                                        + (middle != null
                                                        ? middle + " "
                                                        : "")
                                                        + rs.getString("last_name");

                                                int score =
                                                        rs.getInt("score");

                                                int total =
                                                        rs.getInt("total_questions");

                                                double percentage =
                                                        rs.getDouble("percentage");

                                                String status =
                                                        rs.getString("result_status");

                                                Timestamp submitted =
                                                        rs.getTimestamp("submitted_at");
                                %>

                                <tr>

                                    <td>
                                        <%= number++ %>
                                    </td>

                                    <td class="fw-semibold">
                                        <%= fullName %>
                                    </td>

                                    <td>
                                        <%= rs.getString("registration_number") %>
                                    </td>

                                    <td>
                                        <%= score %> / <%= total %>
                                    </td>

                                    <td>
                                        <%= String.format("%.2f", percentage) %>%
                                    </td>

                                    <td>

                                        <% if ("PASS".equalsIgnoreCase(status)) { %>

                                            <span class="badge bg-success">
                                                PASS
                                            </span>

                                        <% } else { %>

                                            <span class="badge bg-danger">
                                                FAIL
                                            </span>

                                        <% } %>

                                    </td>

                                    <td>
                                        <%= submitted != null
                                                ? submitted.toString()
                                                : "-" %>
                                    </td>

                                    <td>

                                        <a href="attempt-result.jsp?attemptId=<%= attemptId %>"
                                           class="btn btn-sm btn-outline-primary">

                                            <i class="bi bi-eye me-1"></i>
                                            View

                                        </a>

                                    </td>

                                </tr>

                                <%
                                            }
                                        }

                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                %>

                                <tr>
                                    <td colspan="8"
                                        class="text-center text-danger">

                                        Error loading results.

                                    </td>
                                </tr>

                                <%
                                    }

                                    if (!found) {
                                %>

                                <tr>

                                    <td colspan="8"
                                        class="text-center py-5">

                                        <i class="bi bi-inbox fs-1 text-muted"></i>

                                        <h5 class="mt-3">
                                            No Student Attempts
                                        </h5>

                                        <p class="text-muted">
                                            No students have attempted this quiz yet.
                                        </p>

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

                <% } %>

            </main>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>