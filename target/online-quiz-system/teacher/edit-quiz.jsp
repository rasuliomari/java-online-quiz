<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
if (session.getAttribute("teacherLoggedIn") == null ||
!Boolean.TRUE.equals(session.getAttribute("teacherLoggedIn")) ||
!"TEACHER".equals(session.getAttribute("userRole"))) {
response.sendRedirect("../login.jsp");
return;
}

Integer teacherId = (Integer) session.getAttribute("teacherId");

if (teacherId == null) {
    response.sendRedirect("../login.jsp");
    return;
}

String quizIdParam = request.getParameter("quizId");

if (quizIdParam == null || quizIdParam.trim().isEmpty()) {
    response.sendRedirect("dashboard.jsp");
    return;
}

int quizId;

try {
    quizId = Integer.parseInt(quizIdParam);
} catch (NumberFormatException e) {
    response.sendRedirect("dashboard.jsp");
    return;
}

String title = "";
String course = "";
String description = "";
int courseId = 0;
int duration = 30;
int questionCount = 1;
int passMark = 50;
int savedQuestions = 0;
String status = "";

boolean quizFound = false;

try (Connection conn = DBConnection.getConnection()) {

    String quizSql =
        "SELECT q.id, q.title, q.course, q.course_id, q.description, " +
        "q.duration_minutes, q.question_count, q.pass_mark, q.status " +
        "FROM quizzes q " +
        "WHERE q.id = ? AND q.teacher_id = ?";

    try (PreparedStatement ps = conn.prepareStatement(quizSql)) {

        ps.setInt(1, quizId);
        ps.setInt(2, teacherId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                quizFound = true;

                title = rs.getString("title");
                course = rs.getString("course");
                courseId = rs.getInt("course_id");
                description = rs.getString("description");
                duration = rs.getInt("duration_minutes");
                questionCount = rs.getInt("question_count");
                passMark = rs.getInt("pass_mark");
                status = rs.getString("status");
            }
        }
    }

    if (!quizFound || !"DRAFT".equalsIgnoreCase(status)) {
        response.sendRedirect("review-quiz.jsp?quizId=" + quizId);
        return;
    }

    String countSql =
        "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

    try (PreparedStatement ps = conn.prepareStatement(countSql)) {

        ps.setInt(1, quizId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                savedQuestions = rs.getInt(1);
            }
        }
    }

} catch (SQLException e) {
    e.printStackTrace();

%>

<div class="alert alert-danger m-4">
    Unable to load quiz information.
</div>

<%
return;
}
%>

<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Quiz Information - UDOM Online Quiz System</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    rel="stylesheet">

<link rel="stylesheet" href="../css/dashboard.css">

</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">

    <a class="navbar-brand fw-bold" href="dashboard.jsp">
        <i class="bi bi-mortarboard-fill me-2"></i>
        UDOM Online Quiz System
    </a>

    <div class="d-flex align-items-center text-white">

        <div class="text-end me-3">
            <div class="fw-bold">
                <%= session.getAttribute("teacherFirstName") %>
                <%= session.getAttribute("teacherLastName") %>
            </div>

            <small>Teacher</small>
        </div>

        <a href="../logout" class="btn btn-light btn-sm">
            <i class="bi bi-box-arrow-right me-1"></i>
            Logout
        </a>

    </div>
</div>

</nav>

<div class="container-fluid">

<div class="row">

    <!-- SIDEBAR -->
    <div class="col-md-3 col-lg-2 bg-dark text-white min-vh-100 p-3">

        <h5 class="text-center mb-4">
            Teacher Panel
        </h5>

        <div class="text-center mb-4">

            <div class="rounded-circle bg-primary
                        d-flex align-items-center justify-content-center
                        mx-auto mb-2"
                 style="width:70px;height:70px;">

                <span class="fs-3 fw-bold">
                    <%= String.valueOf(session.getAttribute("teacherFirstName")).substring(0,1).toUpperCase() %>
                </span>

            </div>

            <div class="fw-bold">
                <%= session.getAttribute("teacherFirstName") %>
                <%= session.getAttribute("teacherLastName") %>
            </div>

            <small class="text-secondary">
                Academic Staff
            </small>

        </div>

        <div class="nav flex-column">

            <a href="dashboard.jsp"
               class="nav-link text-white">
                <i class="bi bi-speedometer2 me-2"></i>
                Dashboard
            </a>

            <a href="create-quiz.jsp"
               class="nav-link text-white active">
                <i class="bi bi-plus-circle me-2"></i>
                Create Quiz
            </a>

            <a href="dashboard.jsp"
               class="nav-link text-white">
                <i class="bi bi-list-check me-2"></i>
                My Quizzes
            </a>

        </div>

    </div>

    <!-- MAIN CONTENT -->
    <div class="col-md-9 col-lg-10 p-4">

        <div class="d-flex justify-content-between align-items-center mb-4">

            <div>
                <h2 class="fw-bold">
                    <i class="bi bi-pencil-square me-2"></i>
                    Edit Quiz Information
                </h2>

                <p class="text-muted mb-0">
                    Update the preliminary information of your quiz.
                </p>
            </div>

            <a href="review-quiz.jsp?quizId=<%= quizId %>"
               class="btn btn-outline-secondary">

                <i class="bi bi-arrow-left me-1"></i>
                Back to Review

            </a>

        </div>

        <div class="card shadow-sm">

            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">
                    <i class="bi bi-info-circle me-2"></i>
                    Quiz Information
                </h5>
            </div>

            <div class="card-body">

                <form action="../updateQuiz" method="post">

                    <input type="hidden"
                           name="quizId"
                           value="<%= quizId %>">

                    <!-- TITLE -->
                    <div class="mb-3">

                        <label class="form-label fw-semibold">
                            Quiz Title
                        </label>

                        <input
                            type="text"
                            name="quizTitle"
                            class="form-control"
                            value="<%= title != null ? title : "" %>"
                            required>

                    </div>

                    <!-- COURSE -->
                    <div class="mb-3">

                        <label class="form-label fw-semibold">
                            Course / Subject
                        </label>

                        <select name="courseId"
                                class="form-select"
                                required>

                            <option value="">
                                Select Course
                            </option>

                            <%
                                try (Connection conn = DBConnection.getConnection()) {

                                    String courseSql =
                                        "SELECT c.id, c.course_code, c.course_name, " +
                                        "c.year_of_study, p.name AS programme_name " +
                                        "FROM teacher_courses tc " +
                                        "INNER JOIN courses c ON tc.course_id = c.id " +
                                        "INNER JOIN programmes p ON c.programme_id = p.id " +
                                        "WHERE tc.teacher_id = ? " +
                                        "ORDER BY p.name, c.year_of_study, c.course_code";

                                    try (PreparedStatement ps =
                                             conn.prepareStatement(courseSql)) {

                                        ps.setInt(1, teacherId);

                                        try (ResultSet rs = ps.executeQuery()) {

                                            while (rs.next()) {

                                                int id = rs.getInt("id");
                                                String code = rs.getString("course_code");
                                                String name = rs.getString("course_name");
                                                int year = rs.getInt("year_of_study");
                                                String programme =
                                                    rs.getString("programme_name");

                                                String selected =
                                                    id == courseId ? "selected" : "";
                            %>

                            <option value="<%= id %>" <%= selected %>>
                                <%= code %> - <%= name %>
                                (Year <%= year %> - <%= programme %>)
                            </option>

                            <%
                                            }
                                        }
                                    }

                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>

                        </select>

                    </div>

                    <!-- DESCRIPTION -->
                    <div class="mb-3">

                        <label class="form-label fw-semibold">
                            Description
                        </label>

                        <textarea
                            name="description"
                            class="form-control"
                            rows="4"><%= description != null ? description : "" %></textarea>

                    </div>

                    <div class="row">

                        <!-- DURATION -->
                        <div class="col-md-4 mb-3">

                            <label class="form-label fw-semibold">
                                Duration (Minutes)
                            </label>

                            <input
                                type="number"
                                name="duration"
                                class="form-control"
                                min="1"
                                value="<%= duration %>"
                                required>

                        </div>

                        <!-- QUESTION COUNT -->
                        <div class="col-md-4 mb-3">

                            <label class="form-label fw-semibold">
                                Number of Questions
                            </label>

                            <input
                                type="number"
                                name="questionCount"
                                class="form-control"
                                min="<%= Math.max(1, savedQuestions) %>"
                                value="<%= questionCount %>"
                                required>

                            <small class="text-muted">
                                Saved questions: <%= savedQuestions %>
                            </small>

                        </div>

                        <!-- PASS MARK -->
                        <div class="col-md-4 mb-3">

                            <label class="form-label fw-semibold">
                                Pass Mark (%)
                            </label>

                            <input
                                type="number"
                                name="passMark"
                                class="form-control"
                                min="1"
                                max="100"
                                value="<%= passMark %>"
                                required>

                        </div>

                    </div>

                    <div class="alert alert-info">

                        <i class="bi bi-info-circle me-2"></i>

                        This quiz is currently a
                        <strong>DRAFT</strong>.
                        You can modify its information before publishing.

                    </div>

                    <div class="d-flex justify-content-end gap-2">

                        <a href="review-quiz.jsp?quizId=<%= quizId %>"
                           class="btn btn-secondary">

                            <i class="bi bi-x-circle me-1"></i>
                            Cancel

                        </a>

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="bi bi-check-circle me-1"></i>
                            Save Changes

                        </button>

                    </div>

                </form>

            </div>

        </div>

    </div>

</div>

</div>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
