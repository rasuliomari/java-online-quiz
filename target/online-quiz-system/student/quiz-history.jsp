<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
HttpSession quizSession = request.getSession(false);

if (quizSession == null
        || !Boolean.TRUE.equals(
                quizSession.getAttribute("studentLoggedIn"))
        || !"STUDENT".equals(
                quizSession.getAttribute("userRole"))) {

    response.sendRedirect("../login.jsp");
    return;
}

Object studentIdObject =
        quizSession.getAttribute("studentId");

if (studentIdObject == null) {
    response.sendRedirect("../login.jsp");
    return;
}

int studentId;

try {
    studentId =
            Integer.parseInt(
                    studentIdObject.toString()
            );
} catch (NumberFormatException e) {

    response.sendRedirect("../login.jsp");
    return;
}
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        Quiz History - UDOM Online Quiz System
    </title>

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


<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#studentSidebar">

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

                <small>
                    Online Quiz System
                </small>

            </div>

        </a>


        <div class="d-flex align-items-center ms-auto">

            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    type="button"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        RO
                    </div>

                    <div class="student-name d-none d-md-block">

                        <strong>
                            <%= quizSession.getAttribute(
                                    "studentFirstName"
                            ) %>
                        </strong>

                        <small>
                            Student Account
                        </small>

                    </div>

                </button>


                <ul
                    class="dropdown-menu dropdown-menu-end shadow">

                    <li>

                        <a
                            class="dropdown-item"
                            href="profile.jsp">

                            <i class="bi bi-person me-2"></i>

                            My Profile

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



<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="studentSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            Student Menu
        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>


    <div class="sidebar-content">


        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                RO
            </div>

            <div>

                <h6>
                    <%= quizSession.getAttribute(
                            "studentFirstName"
                    ) %>
                </h6>

                <span>
                    Student Account
                </span>

            </div>

        </div>


        <div class="sidebar-menu">

            <p class="menu-title">
                MAIN MENU
            </p>


            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <a
                href="dashboard.jsp#available-quizzes"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

            </a>


            <a
                href="quiz-history.jsp"
                class="sidebar-link active">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <a
                href="quiz-history.jsp"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="profile.jsp"
                class="sidebar-link">

                <i class="bi bi-person-fill"></i>

                <span>
                    My Profile
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear-fill"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>


        <div class="sidebar-bottom">

            <a
                href="../logout"
                class="logout-link">

                <i class="bi bi-box-arrow-left"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>



<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <div class="welcome-section">

            <div>

                <h2>
                    Quiz History
                </h2>

                <p>
                    View all quizzes you have completed and
                    review your results.
                </p>

            </div>

        </div>



        <!-- ====================================================
             HISTORY TABLE
             ==================================================== -->

        <div class="content-card">

            <div class="card-header-custom">

                <div>

                    <h4>

                        <i class="bi bi-clock-history me-2"></i>

                        My Quiz Attempts

                    </h4>

                    <p>
                        Your completed quiz attempts.
                    </p>

                </div>

            </div>


            <div class="card-body p-4">

                <div class="table-responsive">

                    <table class="table align-middle">

                        <thead>

                            <tr>

                                <th>
                                    #
                                </th>

                                <th>
                                    Quiz
                                </th>

                                <th>
                                    Score
                                </th>

                                <th>
                                    Percentage
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Submitted
                                </th>

                                <th>
                                    Action
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                        <%
                        boolean hasResults = false;

                        try (
                            Connection connection =
                                    DBConnection.getConnection()
                        ) {

                            String historySql =
                                    "SELECT qa.id AS attempt_id, " +
                                    "       qa.quiz_id, " +
                                    "       q.title, " +
                                    "       qa.score, " +
                                    "       qa.total_questions, " +
                                    "       qa.percentage, " +
                                    "       qa.result_status, " +
                                    "       qa.submitted_at " +
                                    "FROM quiz_attempts qa " +
                                    "INNER JOIN quizzes q " +
                                    "    ON qa.quiz_id = q.id " +
                                    "WHERE qa.student_id = ? " +
                                    "ORDER BY qa.submitted_at DESC";


                            try (
                                PreparedStatement statement =
                                        connection.prepareStatement(
                                                historySql
                                        )
                            ) {

                                statement.setInt(
                                        1,
                                        studentId
                                );


                                try (
                                    ResultSet resultSet =
                                            statement.executeQuery()
                                ) {

                                    int number = 1;


                                    while (resultSet.next()) {

                                        hasResults = true;

                                        int attemptId =
                                                resultSet.getInt(
                                                        "attempt_id"
                                                );

                                        int quizId =
                                                resultSet.getInt(
                                                        "quiz_id"
                                                );

                                        String title =
                                                resultSet.getString(
                                                        "title"
                                                );

                                        int score =
                                                resultSet.getInt(
                                                        "score"
                                                );

                                        int total =
                                                resultSet.getInt(
                                                        "total_questions"
                                                );

                                        double percentage =
                                                resultSet.getDouble(
                                                        "percentage"
                                                );

                                        String status =
                                                resultSet.getString(
                                                        "result_status"
                                                );

                                        String submitted =
                                                resultSet.getTimestamp(
                                                        "submitted_at"
                                                ).toString();

                        %>

                        <tr>

                            <td>
                                <%= number++ %>
                            </td>


                            <td>

                                <strong>
                                    <%= title %>
                                </strong>

                            </td>


                            <td>

                                <strong>
                                    <%= score %>/<%= total %>
                                </strong>

                            </td>


                            <td>

                                <%= String.format(
                                        "%.1f",
                                        percentage
                                ) %>%

                            </td>


                            <td>

                                <% if ("PASS".equalsIgnoreCase(status)) { %>

                                    <span
                                        class="badge bg-success">

                                        <i
                                            class="bi bi-check-circle me-1">
                                        </i>

                                        Passed

                                    </span>

                                <% } else { %>

                                    <span
                                        class="badge bg-danger">

                                        <i
                                            class="bi bi-x-circle me-1">
                                        </i>

                                        Failed

                                    </span>

                                <% } %>

                            </td>


                            <td>

                                <small class="text-muted">

                                    <%= submitted %>

                                </small>

                            </td>


                            <td>

                                <a
                                    href="quiz-result.jsp?quizId=<%= quizId %>&attemptId=<%= attemptId %>"
                                    class="btn btn-sm btn-outline-primary">

                                    <i
                                        class="bi bi-eye me-1">
                                    </i>

                                    View Result

                                </a>

                            </td>

                        </tr>

                        <%
                                    }
                                }
                            }

                        } catch (SQLException e) {

                            e.printStackTrace();
                        %>

                            <tr>

                                <td
                                    colspan="7"
                                    class="text-center text-danger">

                                    <i
                                        class="bi bi-exclamation-triangle me-2">
                                    </i>

                                    Unable to load quiz history.

                                </td>

                            </tr>

                        <%
                        }


                        if (!hasResults) {
                        %>

                            <tr>

                                <td
                                    colspan="7"
                                    class="text-center py-5">

                                    <div class="mb-3">

                                        <i
                                            class="bi bi-journal-x"
                                            style="font-size: 3rem;">
                                        </i>

                                    </div>

                                    <h5>
                                        No Quiz Attempts Yet
                                    </h5>

                                    <p class="text-muted">
                                        You have not completed any
                                        quizzes yet.
                                    </p>

                                    <a
                                        href="dashboard.jsp#available-quizzes"
                                        class="btn btn-primary">

                                        <i
                                            class="bi bi-journal-check me-1">
                                        </i>

                                        Browse Available Quizzes

                                    </a>

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



        <!-- ====================================================
             FOOTER
             ==================================================== -->

        <footer class="dashboard-footer">

            <p>

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

        </footer>

    </div>

</main>



<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>