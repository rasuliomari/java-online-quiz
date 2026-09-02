<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession quizSession = request.getSession(false);

    if (quizSession == null
            || quizSession.getAttribute("quizResultQuizId") == null) {

        response.sendRedirect("dashboard.jsp");
        return;
    }

    int quizId =
            (Integer) quizSession.getAttribute("quizResultQuizId");

    String quizTitle =
            (String) quizSession.getAttribute("quizResultTitle");

    int score =
            (Integer) quizSession.getAttribute("quizResultScore");

    int totalQuestions =
            (Integer) quizSession.getAttribute("quizResultTotal");

    double percentage =
            (Double) quizSession.getAttribute("quizResultPercentage");

    int passMark =
            (Integer) quizSession.getAttribute("quizResultPassMark");

    boolean passed =
            (Boolean) quizSession.getAttribute("quizResultPassed");

    String resultMessage;

    if (passed) {
        resultMessage = "Congratulations! You have passed the quiz.";
    } else {
        resultMessage = "You did not reach the required pass mark.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Quiz Result - UDOM Online Quiz System</title>

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

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn sidebar-toggle d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#studentSidebar">

            <i class="bi bi-list"></i>

        </button>

        <a class="navbar-brand d-flex align-items-center"
           href="dashboard.jsp">

            <div class="brand-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </div>

            <div class="brand-text">
                <span>UDOM</span>
                <small>Online Quiz System</small>
            </div>

        </a>

        <div class="d-flex align-items-center ms-auto">

            <button class="notification-btn me-3">

                <i class="bi bi-bell"></i>

                <span class="notification-badge">
                    3
                </span>

            </button>

            <div class="dropdown">

                <button
                    class="profile-button dropdown-toggle"
                    data-bs-toggle="dropdown">

                    <div class="student-avatar">
                        RO
                    </div>

                    <div class="student-name d-none d-md-block">

                        <strong>Student</strong>

                        <small>
                            Student Account
                        </small>

                    </div>

                </button>

                <ul class="dropdown-menu dropdown-menu-end shadow">

                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-person me-2"></i>
                            My Profile
                        </a>
                    </li>

                    <li>
                        <a class="dropdown-item" href="#">
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
                            href="../login.jsp">

                            <i class="bi bi-box-arrow-right me-2"></i>
                            Logout

                        </a>
                    </li>

                </ul>

            </div>

        </div>

    </div>

</nav>


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

                <h6>Student</h6>

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
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-check"></i>

                <span>
                    Available Quizzes
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-clock-history"></i>

                <span>
                    Quiz History
                </span>

            </a>


            <a
                href="#"
                class="sidebar-link active">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    My Results
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <a
                href="#"
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
                href="../login.jsp"
                class="logout-link">

                <i class="bi bi-box-arrow-left"></i>

                <span>
                    Logout
                </span>

            </a>

        </div>

    </div>

</div>


<main class="dashboard-main">

    <div class="container-fluid dashboard-container">


        <div class="welcome-section">

            <div>

                <h2>
                    Quiz Result
                </h2>

                <p>
                    Your quiz submission has been evaluated.
                </p>

            </div>

        </div>


        <div class="content-card mb-4">

            <div class="card-body p-4">

                <div class="text-center">

                    <% if (passed) { %>

                        <div class="mb-3">

                            <i
                                class="bi bi-check-circle-fill text-success"
                                style="font-size: 4rem;">
                            </i>

                        </div>

                        <h3 class="fw-bold text-success">
                            Quiz Passed
                        </h3>

                    <% } else { %>

                        <div class="mb-3">

                            <i
                                class="bi bi-x-circle-fill text-danger"
                                style="font-size: 4rem;">
                            </i>

                        </div>

                        <h3 class="fw-bold text-danger">
                            Quiz Not Passed
                        </h3>

                    <% } %>


                    <p class="text-muted mb-4">
                        <%= resultMessage %>
                    </p>

                </div>


                <div class="row g-4">


                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-journal-text fs-2 mb-2">
                            </i>

                            <h6 class="text-muted">
                                Quiz
                            </h6>

                            <h5 class="fw-bold">
                                <%= quizTitle %>
                            </h5>

                        </div>

                    </div>


                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-check2-square fs-2 mb-2">
                            </i>

                            <h6 class="text-muted">
                                Score
                            </h6>

                            <h2 class="fw-bold">
                                <%= score %>/<%= totalQuestions %>
                            </h2>

                        </div>

                    </div>


                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-percent fs-2 mb-2">
                            </i>

                            <h6 class="text-muted">
                                Percentage
                            </h6>

                            <h2 class="fw-bold">
                                <%= String.format("%.1f", percentage) %>%
                            </h2>

                        </div>

                    </div>


                    <div class="col-md-6 col-xl-3">

                        <div
                            class="border rounded p-4 text-center h-100">

                            <i
                                class="bi bi-flag-fill fs-2 mb-2">
                            </i>

                            <h6 class="text-muted">
                                Pass Mark
                            </h6>

                            <h2 class="fw-bold">
                                <%= passMark %>%
                            </h2>

                        </div>

                    </div>

                </div>


                <div class="mt-4">

                    <div class="d-flex justify-content-between mb-2">

                        <span class="fw-semibold">
                            Your Performance
                        </span>

                        <span class="fw-semibold">
                            <%= String.format("%.1f", percentage) %>%
                        </span>

                    </div>


                    <div
                        class="progress"
                        style="height: 12px;">

                        <div
                            class="progress-bar <%= passed ? "bg-success" : "bg-danger" %>"
                            role="progressbar"
                            style="width: <%= Math.min(percentage, 100) %>%;">
                        </div>

                    </div>

                </div>

            </div>

        </div>


        <div class="content-card">

            <div class="card-body p-4">

                <h5 class="fw-bold mb-3">

                    <i class="bi bi-info-circle me-2"></i>

                    Result Summary

                </h5>


                <div class="alert <%= passed
                        ? "alert-success"
                        : "alert-danger" %>">

                    <% if (passed) { %>

                        <strong>Well done!</strong>

                        You achieved
                        <strong>
                            <%= String.format("%.1f", percentage) %>%
                        </strong>
                        which is above the required pass mark of
                        <strong>
                            <%= passMark %>%
                        </strong>.

                    <% } else { %>

                        <strong>Keep practicing.</strong>

                        You achieved
                        <strong>
                            <%= String.format("%.1f", percentage) %>%
                        </strong>
                        while the required pass mark is
                        <strong>
                            <%= passMark %>%
                        </strong>.

                    <% } %>

                </div>


                <div class="d-flex flex-wrap gap-2 mt-4">

                    <a
                        href="dashboard.jsp"
                        class="btn btn-primary">

                        <i class="bi bi-grid-1x2-fill me-1"></i>

                        Back to Dashboard

                    </a>


                    <a
                        href="take-quiz.jsp?quizId=<%= quizId %>"
                        class="btn btn-outline-primary">

                        <i class="bi bi-arrow-repeat me-1"></i>

                        Take Quiz Again

                    </a>

                </div>

            </div>

        </div>


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