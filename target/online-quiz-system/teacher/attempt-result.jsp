<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
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

    String attemptParam = request.getParameter("attemptId");

    if (attemptParam == null) {
        response.sendRedirect("results.jsp");
        return;
    }

    int attemptId;

    try {
        attemptId = Integer.parseInt(attemptParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("results.jsp");
        return;
    }

    String studentName = "";
    String registrationNumber = "";
    String quizTitle = "";
    String course = "";
    String resultStatus = "";
    int score = 0;
    int totalQuestions = 0;
    double percentage = 0;
    int passMark = 0;
    Timestamp submittedAt = null;

    boolean found = false;

    try (Connection conn = DBConnection.getConnection()) {

        /*
         * IMPORTANT:
         * teacher_id check prevents one teacher
         * from viewing another teacher's results.
         */
        String sql =
            "SELECT qa.score, " +
            "qa.total_questions, " +
            "qa.percentage, " +
            "qa.result_status, " +
            "qa.submitted_at, " +
            "s.first_name, " +
            "s.middle_name, " +
            "s.last_name, " +
            "s.registration_number, " +
            "q.title, " +
            "q.course, " +
            "q.pass_mark " +

            "FROM quiz_attempts qa " +

            "INNER JOIN students s " +
            "ON qa.student_id = s.id " +

            "INNER JOIN quizzes q " +
            "ON qa.quiz_id = q.id " +

            "WHERE qa.id = ? " +
            "AND q.teacher_id = ?";

        try (PreparedStatement ps =
                 conn.prepareStatement(sql)) {

            ps.setInt(1, attemptId);
            ps.setInt(2, teacherId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    found = true;

                    String middle =
                            rs.getString("middle_name");

                    studentName =
                            rs.getString("first_name")
                            + " "
                            + (middle != null
                            ? middle + " "
                            : "")
                            + rs.getString("last_name");

                    registrationNumber =
                            rs.getString("registration_number");

                    quizTitle =
                            rs.getString("title");

                    course =
                            rs.getString("course");

                    score =
                            rs.getInt("score");

                    totalQuestions =
                            rs.getInt("total_questions");

                    percentage =
                            rs.getDouble("percentage");

                    resultStatus =
                            rs.getString("result_status");

                    passMark =
                            rs.getInt("pass_mark");

                    submittedAt =
                            rs.getTimestamp("submitted_at");
                }
            }
        }
    }

    if (!found) {
        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Result not found or you do not have permission to view it."
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

    <title>Attempt Result - UDOM Online Quiz System</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet"
          href="../css/dashboard.css">

</head>

<body>

<div class="container-fluid">

    <div class="row">

        <div class="col-lg-10 mx-auto">

            <nav class="navbar dashboard-navbar px-4">

                <a href="results.jsp"
                   class="btn btn-outline-primary">

                    <i class="bi bi-arrow-left me-1"></i>
                    Back to Results

                </a>

                <span class="fw-bold">
                    <i class="bi bi-mortarboard-fill me-1"></i>
                    UDOM Online Quiz System
                </span>

                <a href="../logout"
                   class="btn btn-outline-danger">

                    <i class="bi bi-box-arrow-right me-1"></i>
                    Logout

                </a>

            </nav>


            <main class="p-4">

                <div class="mb-4">

                    <h2 class="fw-bold">
                        Student Attempt Result
                    </h2>

                    <p class="text-muted">
                        Detailed performance information
                    </p>

                </div>


                <!-- STUDENT + QUIZ -->

                <div class="card border-0 shadow-sm rounded-4 mb-4">

                    <div class="card-body p-4">

                        <div class="row g-4">

                            <div class="col-md-6">

                                <small class="text-muted">
                                    Student
                                </small>

                                <h5 class="fw-bold">
                                    <%= studentName %>
                                </h5>

                            </div>

                            <div class="col-md-6">

                                <small class="text-muted">
                                    Registration Number
                                </small>

                                <h5 class="fw-bold">
                                    <%= registrationNumber %>
                                </h5>

                            </div>

                            <div class="col-md-6">

                                <small class="text-muted">
                                    Quiz
                                </small>

                                <h5 class="fw-bold">
                                    <%= quizTitle %>
                                </h5>

                            </div>

                            <div class="col-md-6">

                                <small class="text-muted">
                                    Course
                                </small>

                                <h5 class="fw-bold">
                                    <%= course %>
                                </h5>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- RESULT CARDS -->

                <div class="row g-4 mb-4">

                    <div class="col-md-3">

                        <div class="card border-0 shadow-sm rounded-4 h-100">

                            <div class="card-body text-center">

                                <i class="bi bi-check2-square fs-1 text-primary"></i>

                                <h6 class="text-muted mt-2">
                                    Score
                                </h6>

                                <h3 class="fw-bold">
                                    <%= score %>/<%= totalQuestions %>
                                </h3>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-3">

                        <div class="card border-0 shadow-sm rounded-4 h-100">

                            <div class="card-body text-center">

                                <i class="bi bi-percent fs-1 text-primary"></i>

                                <h6 class="text-muted mt-2">
                                    Percentage
                                </h6>

                                <h3 class="fw-bold">
                                    <%= String.format("%.2f", percentage) %>%
                                </h3>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-3">

                        <div class="card border-0 shadow-sm rounded-4 h-100">

                            <div class="card-body text-center">

                                <i class="bi bi-flag fs-1 text-success"></i>

                                <h6 class="text-muted mt-2">
                                    Pass Mark
                                </h6>

                                <h3 class="fw-bold">
                                    <%= passMark %>%
                                </h3>

                            </div>

                        </div>

                    </div>


                    <div class="col-md-3">

                        <div class="card border-0 shadow-sm rounded-4 h-100">

                            <div class="card-body text-center">

                                <i class="bi bi-award fs-1
                                    <%= "PASS".equalsIgnoreCase(resultStatus)
                                            ? "text-success"
                                            : "text-danger" %>">
                                </i>

                                <h6 class="text-muted mt-2">
                                    Result
                                </h6>

                                <h3 class="fw-bold">

                                    <% if ("PASS".equalsIgnoreCase(resultStatus)) { %>

                                        <span class="text-success">
                                            PASS
                                        </span>

                                    <% } else { %>

                                        <span class="text-danger">
                                            FAIL
                                        </span>

                                    <% } %>

                                </h3>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- SUBMISSION -->

                <div class="card border-0 shadow-sm rounded-4">

                    <div class="card-body p-4">

                        <h5 class="fw-bold">
                            <i class="bi bi-clock-history me-2"></i>
                            Submission Information
                        </h5>

                        <hr>

                        <p class="mb-0">

                            <strong>Submitted:</strong>

                            <%= submittedAt != null
                                    ? submittedAt.toString()
                                    : "-" %>

                        </p>

                    </div>

                </div>

            </main>

        </div>

    </div>

</div>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>