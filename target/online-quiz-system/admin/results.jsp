<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    HttpSession currentSession = request.getSession(false);

    if (currentSession == null ||
        !Boolean.TRUE.equals(currentSession.getAttribute("adminLoggedIn")) ||
        !"ADMIN".equals(currentSession.getAttribute("userRole"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String adminFirstName =
            (String) currentSession.getAttribute("adminFirstName");

    String adminLastName =
            (String) currentSession.getAttribute("adminLastName");

    if (adminFirstName == null) {
        adminFirstName = "Administrator";
    }

    if (adminLastName == null) {
        adminLastName = "";
    }

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();

    String search =
            request.getParameter("search");

    if (search == null) {
        search = "";
    }

    String resultFilter =
            request.getParameter("result");

    if (resultFilter == null ||
        resultFilter.trim().isEmpty()) {

        resultFilter = "ALL";
    }

    String searchPattern = "%" + search.trim() + "%";

    int totalAttempts = 0;
    int passedAttempts = 0;
    int failedAttempts = 0;
    double averagePercentage = 0.0;

    String statsSql =
            "SELECT " +
            "COUNT(*) AS total_attempts, " +
            "COUNT(*) FILTER (WHERE result_status = 'PASS') AS passed, " +
            "COUNT(*) FILTER (WHERE result_status = 'FAIL') AS failed, " +
            "COALESCE(ROUND(AVG(percentage), 2), 0) AS average_percentage " +
            "FROM quiz_attempts";

    String resultsSql =
            "SELECT " +
            "qa.id AS attempt_id, " +
            "s.id AS student_id, " +
            "s.first_name, " +
            "s.middle_name, " +
            "s.last_name, " +
            "s.registration_number, " +
            "q.id AS quiz_id, " +
            "q.title AS quiz_title, " +
            "COALESCE(c.course_code, q.course) AS course_code, " +
            "COALESCE(c.course_name, q.course) AS course_name, " +
            "qa.score, " +
            "qa.total_questions, " +
            "qa.percentage, " +
            "qa.result_status, " +
            "qa.submitted_at " +
            "FROM quiz_attempts qa " +
            "JOIN students s ON qa.student_id = s.id " +
            "JOIN quizzes q ON qa.quiz_id = q.id " +
            "LEFT JOIN courses c ON q.course_id = c.id " +
            "WHERE " +
            "(s.first_name ILIKE ? " +
            "OR s.last_name ILIKE ? " +
            "OR s.registration_number ILIKE ? " +
            "OR q.title ILIKE ? " +
            "OR COALESCE(c.course_code, q.course) ILIKE ?) ";

    if ("PASS".equals(resultFilter)) {
        resultsSql += "AND qa.result_status = 'PASS' ";
    } else if ("FAIL".equals(resultFilter)) {
        resultsSql += "AND qa.result_status = 'FAIL' ";
    }

    resultsSql +=
            "ORDER BY qa.submitted_at DESC";

    try (Connection conn = DBConnection.getConnection()) {

        try (PreparedStatement ps =
                     conn.prepareStatement(statsSql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalAttempts = rs.getInt("total_attempts");
                passedAttempts = rs.getInt("passed");
                failedAttempts = rs.getInt("failed");
                averagePercentage =
                        rs.getDouble("average_percentage");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Results | UDOM Online Quiz System</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="../css/dashboard.css">

</head>

<body>

<!-- ================= NAVBAR ================= -->

<nav class="navbar dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list"></i>

        </button>

        <a
            class="navbar-brand d-flex align-items-center"
            href="dashboard.jsp">

            <div class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </div>

            <div class="brand-text">

                <span>UDOM</span>

                <small>Online Quiz System</small>

            </div>

        </a>


        <div class="ms-auto d-flex align-items-center">

            <button
                class="notification-btn me-3"
                type="button">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    4
                </span>

            </button>


            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">

                        <%= adminFirstName.substring(0, 1).toUpperCase() %>

                    </div>

                    <div class="student-name d-none d-md-block">

                        <strong>
                            <%= adminFullName %>
                        </strong>

                        <small>
                            System Administrator
                        </small>

                    </div>

                </button>


                <ul class="dropdown-menu dropdown-menu-end">

                    <li>
                        <a
                            class="dropdown-item"
                            href="#">

                            <i class="bi bi-person me-2"></i>
                            My Profile

                        </a>
                    </li>

                    <li>
                        <a
                            class="dropdown-item"
                            href="#">

                            <i class="bi bi-gear me-2"></i>
                            Settings

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


<!-- ================= SIDEBAR ================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="adminSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            UDOM Online Quiz System
        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="sidebar-content">

        <div class="sidebar-profile">

            <div class="student-avatar">

                <%= adminFirstName.substring(0, 1).toUpperCase() %>

            </div>

            <div>

                <strong>
                    <%= adminFullName %>
                </strong>

                <small>
                    Administrator
                </small>

            </div>

        </div>


        <div class="sidebar-menu">

            <p class="menu-title">
                MAIN MENU
            </p>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-speedometer2"></i>

                <span>Dashboard</span>

            </a>


            <a
                href="create-teacher.jsp"
                class="sidebar-link">

                <i class="bi bi-person-plus"></i>

                <span>Create Teacher</span>

            </a>


            <a
                href="manage-teachers.jsp"
                class="sidebar-link">

                <i class="bi bi-person-badge"></i>

                <span>Manage Teachers</span>

            </a>


            <a
                href="assign-courses.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>Assign Courses</span>

            </a>


            <a
                href="manage-students.jsp"
                class="sidebar-link">

                <i class="bi bi-people"></i>

                <span>Manage Students</span>

            </a>


            <a
                href="manage-quizzes.jsp"
                class="sidebar-link">

                <i class="bi bi-question-circle"></i>

                <span>Manage Quizzes</span>

            </a>


            <a
                href="results.jsp"
                class="sidebar-link active">

                <i class="bi bi-bar-chart-line"></i>

                <span>Student Results</span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>

                <span>Reports</span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person"></i>

                <span>My Profile</span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear"></i>

                <span>Settings</span>

            </a>

        </div>


        <div class="sidebar-bottom">

            <a
                href="../logout"
                class="logout-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- ================= MAIN ================= -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <!-- HEADER -->

        <div class="welcome-section">

            <span class="welcome-label">
                ACADEMIC PERFORMANCE
            </span>

            <h1>
                Student Results
            </h1>

            <p>
                View and monitor student quiz performance
                across the UDOM Online Quiz System.
            </p>

        </div>


        <!-- ================= STATISTICS ================= -->

        <div class="row g-4 mb-4">


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-clipboard-check"></i>

                    </div>

                    <div>

                        <small>
                            Total Attempts
                        </small>

                        <h3>
                            <%= totalAttempts %>
                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-check-circle"></i>

                    </div>

                    <div>

                        <small>
                            Passed
                        </small>

                        <h3>
                            <%= passedAttempts %>
                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-x-circle"></i>

                    </div>

                    <div>

                        <small>
                            Failed
                        </small>

                        <h3>
                            <%= failedAttempts %>
                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-6 col-xl-3">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-graph-up-arrow"></i>

                    </div>

                    <div>

                        <small>
                            Average Score
                        </small>

                        <h3>
                            <%= String.format("%.2f", averagePercentage) %>%
                        </h3>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================= RESULTS ================= -->

        <div class="content-card mb-4">

            <div class="card-header-custom">

                <div>

                    <h5>
                        Student Quiz Results
                    </h5>

                    <p>
                        Review submitted quiz attempts and scores.
                    </p>

                </div>

            </div>


            <!-- FILTER -->

            <form
                method="get"
                action="results.jsp"
                class="row g-3 mb-4">

                <div class="col-lg-7">

                    <label class="form-label">
                        Search
                    </label>

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-search"></i>
                        </span>

                        <input
                            type="text"
                            name="search"
                            class="form-control"
                            placeholder="Search student, registration number or quiz..."
                            value="<%= search %>">

                    </div>

                </div>


                <div class="col-lg-3">

                    <label class="form-label">
                        Result
                    </label>

                    <select
                        name="result"
                        class="form-select">

                        <option
                            value="ALL"
                            <%= "ALL".equals(resultFilter) ? "selected" : "" %>>
                            All Results
                        </option>

                        <option
                            value="PASS"
                            <%= "PASS".equals(resultFilter) ? "selected" : "" %>>
                            Passed
                        </option>

                        <option
                            value="FAIL"
                            <%= "FAIL".equals(resultFilter) ? "selected" : "" %>>
                            Failed
                        </option>

                    </select>

                </div>


                <div class="col-lg-2 d-flex align-items-end">

                    <button
                        type="submit"
                        class="btn btn-primary w-100">

                        <i class="bi bi-funnel me-1"></i>

                        Filter

                    </button>

                </div>

            </form>


            <!-- TABLE -->

            <div class="table-responsive">

                <table class="table align-middle">

                    <thead>

                        <tr>

                            <th>#</th>

                            <th>Student</th>

                            <th>Registration No.</th>

                            <th>Quiz</th>

                            <th>Course</th>

                            <th>Score</th>

                            <th>Percentage</th>

                            <th>Result</th>

                            <th>Submitted</th>

                            <th>Action</th>

                        </tr>

                    </thead>


                    <tbody>

<%
    int counter = 0;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps =
             conn.prepareStatement(resultsSql)) {

        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        ps.setString(3, searchPattern);
        ps.setString(4, searchPattern);
        ps.setString(5, searchPattern);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                counter++;

                int attemptId =
                        rs.getInt("attempt_id");

                String firstName =
                        rs.getString("first_name");

                String middleName =
                        rs.getString("middle_name");

                String lastName =
                        rs.getString("last_name");

                String registrationNumber =
                        rs.getString("registration_number");

                String studentName =
                        ((firstName == null ? "" : firstName)
                        + " "
                        + (middleName == null ? "" : middleName)
                        + " "
                        + (lastName == null ? "" : lastName))
                        .trim();

                String quizTitle =
                        rs.getString("quiz_title");

                String courseCode =
                        rs.getString("course_code");

                int score =
                        rs.getInt("score");

                int totalQuestions =
                        rs.getInt("total_questions");

                double percentage =
                        rs.getDouble("percentage");

                String resultStatus =
                        rs.getString("result_status");

                Timestamp submittedAt =
                        rs.getTimestamp("submitted_at");
%>

                        <tr>

                            <td>
                                <%= counter %>
                            </td>


                            <td>

                                <strong>
                                    <%= studentName %>
                                </strong>

                            </td>


                            <td>
                                <%= registrationNumber %>
                            </td>


                            <td>
                                <%= quizTitle %>
                            </td>


                            <td>
                                <%= courseCode == null
                                    ? "-"
                                    : courseCode %>
                            </td>


                            <td>
                                <strong>
                                    <%= score %>/<%= totalQuestions %>
                                </strong>
                            </td>


                            <td>

                                <%= String.format(
                                    "%.2f",
                                    percentage
                                ) %>%

                            </td>


                            <td>

<%
    if ("PASS".equals(resultStatus)) {
%>

                                <span class="badge bg-success">
                                    PASS
                                </span>

<%
    } else {
%>

                                <span class="badge bg-danger">
                                    FAIL
                                </span>

<%
    }
%>

                            </td>


                            <td>

<%
    if (submittedAt != null) {
%>

                                <%= submittedAt %>

<%
    } else {
%>

                                -

<%
    }
%>

                            </td>


                            <td>

                                <a
                                    href="view-attempt.jsp?id=<%= attemptId %>"
                                    class="btn btn-sm btn-outline-primary"
                                    title="View Result">

                                    <i class="bi bi-eye"></i>

                                </a>

                            </td>

                        </tr>

<%
            }

            if (counter == 0) {
%>

                        <tr>

                            <td
                                colspan="10"
                                class="text-center py-5">

                                <div class="text-muted">

                                    <i
                                        class="bi bi-inbox fs-1 d-block mb-3">
                                    </i>

                                    <h6>
                                        No quiz results found
                                    </h6>

                                    <p class="mb-0">
                                        There are no submitted quiz attempts
                                        matching your search.
                                    </p>

                                </div>

                            </td>

                        </tr>

<%
            }
        }

    } catch (Exception e) {

        e.printStackTrace();
%>

                        <tr>

                            <td
                                colspan="10"
                                class="text-center text-danger py-5">

                                <i class="bi bi-exclamation-triangle fs-1 d-block mb-3"></i>

                                Unable to load student results.

                            </td>

                        </tr>

<%
    }
%>

                    </tbody>

                </table>

            </div>

        </div>


        <!-- ================= INFORMATION ================= -->

        <div class="content-card mb-4">

            <div class="card-header-custom">

                <div>

                    <h5>
                        Results Management
                    </h5>

                    <p>
                        Monitor overall student performance.
                    </p>

                </div>

            </div>


            <div class="row g-4">


                <div class="col-md-4">

                    <div class="quiz-item">

                        <div class="quiz-icon">

                            <i class="bi bi-bar-chart-line"></i>

                        </div>

                        <div class="quiz-information">

                            <h6>
                                Performance
                            </h6>

                            <p>
                                Review student scores and percentages
                                for completed quizzes.
                            </p>

                        </div>

                    </div>

                </div>


                <div class="col-md-4">

                    <div class="quiz-item">

                        <div class="quiz-icon software-icon">

                            <i class="bi bi-check2-square"></i>

                        </div>

                        <div class="quiz-information">

                            <h6>
                                Results
                            </h6>

                            <p>
                                Quickly identify passed and failed
                                quiz attempts.
                            </p>

                        </div>

                    </div>

                </div>


                <div class="col-md-4">

                    <div class="quiz-item">

                        <div class="quiz-icon security-icon">

                            <i class="bi bi-file-earmark-text"></i>

                        </div>

                        <div class="quiz-information">

                            <h6>
                                Reports
                            </h6>

                            <p>
                                Individual attempt details can be
                                reviewed from the results table.
                            </p>

                        </div>

                    </div>

                </div>

            </div>

        </div>


    </div>

</main>


<!-- ================= FOOTER ================= -->

<footer class="dashboard-footer">

    <div class="container-fluid">

        <div class="d-flex justify-content-between align-items-center flex-wrap">

            <p class="mb-0">
                © 2026 UDOM Online Quiz System.
                University of Dodoma.
            </p>

            <div>

                <a href="#">
                    Help
                </a>

                <a href="#">
                    Privacy
                </a>

                <a href="#">
                    Support
                </a>

            </div>

        </div>

    </div>

</footer>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>