
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // =========================================================
    // GET QUIZ ID
    // =========================================================

    String quizIdValue = request.getParameter("quizId");

    if (quizIdValue == null || quizIdValue.trim().isEmpty()) {
        response.sendError(400, "Quiz ID is required.");
        return;
    }

    int quizId;

    try {
        quizId = Integer.parseInt(quizIdValue);
    } catch (NumberFormatException e) {
        response.sendError(400, "Invalid quiz ID.");
        return;
    }


    // =========================================================
    // QUIZ INFORMATION VARIABLES
    // =========================================================

    String quizTitle = "";
    String course = "";
    String description = "";
    int durationMinutes = 0;
    int questionCount = 0;
    int passMark = 0;
    String status = "";

    int savedQuestionCount = 0;


    // =========================================================
    // LOAD QUIZ INFORMATION
    // =========================================================

    String quizSql =
            "SELECT title, course, description, duration_minutes, " +
            "question_count, pass_mark, status " +
            "FROM quizzes WHERE id = ?";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement = connection.prepareStatement(quizSql)
    ) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (!resultSet.next()) {
                response.sendError(404, "Quiz was not found.");
                return;
            }

            quizTitle = resultSet.getString("title");
            course = resultSet.getString("course");
            description = resultSet.getString("description");

            durationMinutes =
                    resultSet.getInt("duration_minutes");

            questionCount =
                    resultSet.getInt("question_count");

            passMark =
                    resultSet.getInt("pass_mark");

            status =
                    resultSet.getString("status");
        }

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                500,
                "Database error while loading quiz information."
        );

        return;
    }


    // =========================================================
    // COUNT SAVED QUESTIONS
    // =========================================================

    String countSql =
            "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement = connection.prepareStatement(countSql)
    ) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                savedQuestionCount = resultSet.getInt(1);
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();

        response.sendError(
                500,
                "Database error while counting questions."
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

<title>
    Review Quiz | UDOM Online Quiz System
</title>


<!-- Bootstrap 5.3.3 -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- Bootstrap Icons -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<!-- SAME Dashboard CSS -->

<link
    rel="stylesheet"
    href="../css/dashboard.css">

</head>


<body>


<!-- =========================================================
     TOP NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">

<div class="container-fluid">


    <!-- Mobile menu -->

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#teacherSidebar">

        <i class="bi bi-list"></i>

    </button>


    <!-- Brand -->

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


    <!-- Right side -->

    <div class="d-flex align-items-center ms-auto">


        <!-- Notification -->

        <button class="notification-btn me-3">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                4
            </span>

        </button>


        <!-- Lecturer profile -->

        <div class="dropdown">

            <button
                class="profile-button dropdown-toggle"
                data-bs-toggle="dropdown">

                <div class="student-avatar">
                    RO
                </div>


                <div class="student-name d-none d-md-block">

                    <strong>
                        Lecturer
                    </strong>

                    <small>
                        Academic Staff
                    </small>

                </div>

            </button>


            <ul class="dropdown-menu dropdown-menu-end shadow">

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



<!-- =========================================================
     SIDEBAR
========================================================= -->

<div
    class="offcanvas-lg offcanvas-start student-sidebar"
    tabindex="-1"
    id="teacherSidebar">


    <!-- Mobile header -->

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            Lecturer Menu
        </h5>


        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas">
        </button>

    </div>



    <div class="sidebar-content">


        <!-- Lecturer information -->

        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                RO
            </div>


            <div>

                <h6>
                    Lecturer
                </h6>

                <span>
                    Academic Staff
                </span>

            </div>

        </div>



        <!-- Navigation -->

        <div class="sidebar-menu">


            <p class="menu-title">
                MAIN MENU
            </p>


            <!-- Dashboard -->

            <a
                href="dashboard.jsp"
                class="sidebar-link">

                <i class="bi bi-grid-1x2-fill"></i>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- Create Quiz -->

            <a
                href="create-quiz.jsp"
                class="sidebar-link active">

                <i class="bi bi-plus-circle-fill"></i>

                <span>
                    Create Quiz
                </span>

            </a>


            <!-- My Quizzes -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-journal-text"></i>

                <span>
                    My Quizzes
                </span>

                <span class="menu-badge">
                    18
                </span>

            </a>


            <!-- Questions -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-question-circle-fill"></i>

                <span>
                    Questions
                </span>

            </a>


            <!-- Results -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-bar-chart-fill"></i>

                <span>
                    Student Results
                </span>

            </a>


            <!-- Reports -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph-fill"></i>

                <span>
                    Quiz Reports
                </span>

            </a>


            <p class="menu-title mt-4">
                ACCOUNT
            </p>


            <!-- Profile -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-person-fill"></i>

                <span>
                    My Profile
                </span>

            </a>


            <!-- Settings -->

            <a
                href="#"
                class="sidebar-link">

                <i class="bi bi-gear-fill"></i>

                <span>
                    Settings
                </span>

            </a>

        </div>



        <!-- Logout -->

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



<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


    <!-- =================================================
         PAGE HEADER
    ================================================== -->

    <div class="welcome-section">

        <div>

            <span class="welcome-label">
                QUIZ MANAGEMENT
            </span>


            <h1>
                Review Quiz
            </h1>


            <p>
                Review all quiz information and questions before
                publishing the assessment.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-clipboard-check-fill"></i>

        </div>

    </div>



    <!-- =================================================
         QUIZ INFORMATION
    ================================================== -->

    <div class="content-card mb-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    <%= quizTitle %>
                </h4>

                <p>
                    <%= course %>
                </p>

            </div>


            <span class="quiz-status">

                <%= status %>

            </span>

        </div>



        <div class="row g-3 mt-2">


            <!-- Course -->

            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-book-fill"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Course
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= course %>
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Duration -->

            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

                        <i class="bi bi-clock-fill"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Duration
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= durationMinutes %> Minutes
                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Questions -->

            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon network-icon">

                        <i class="bi bi-list-ol"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Questions
                        </h5>

                        <div class="quiz-meta">

                            <span>

                                <%= savedQuestionCount %>
                                /
                                <%= questionCount %>
                                Questions

                            </span>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Pass Mark -->

            <div class="col-md-3">

                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-percent"></i>

                    </div>

                    <div class="quiz-information">

                        <h5>
                            Pass Mark
                        </h5>

                        <div class="quiz-meta">

                            <span>
                                <%= passMark %>%
                            </span>

                        </div>

                    </div>

                </div>

            </div>


        </div>

    </div>



    <!-- =================================================
         DESCRIPTION
    ================================================== -->

    <div class="content-card mb-4">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Description
                </h4>

                <p>
                    Description students will see before starting.
                </p>

            </div>

        </div>


        <p class="mb-0">

            <%
                if (description != null
                        && !description.trim().isEmpty()) {
            %>

                <%= description %>

            <%
                } else {
            %>

                No description was provided for this quiz.

            <%
                }
            %>

        </p>


    </div>



    <!-- =================================================
         QUESTIONS
    ================================================== -->

    <div class="content-card">


        <div class="card-header-custom">

            <div>

                <h4>
                    Quiz Questions
                </h4>

                <p>
                    Review each question and its correct answer.
                </p>

            </div>


            <span class="quiz-status">

                <%= savedQuestionCount %>
                /
                <%= questionCount %>
                Questions

            </span>

        </div>



        <!-- =================================================
             LOAD ALL QUESTIONS
        ================================================== -->

        <%
            String questionsSql =
                    "SELECT id, question_text, question_number " +
                    "FROM questions " +
                    "WHERE quiz_id = ? " +
                    "ORDER BY question_number ASC";

            try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement questionStatement =
                        connection.prepareStatement(questionsSql)
            ) {

                questionStatement.setInt(1, quizId);

                try (
                    ResultSet questionResult =
                            questionStatement.executeQuery()
                ) {

                    while (questionResult.next()) {
                            int currentQuestionId = questionResult.getInt("id");
                            int currentQuestionNumber = questionResult.getInt("question_number");
                            String currentQuestionText = questionResult.getString("question_text");
        %>


        <!-- =================================================
             QUESTION
        ================================================== -->

        <div class="quiz-item mb-4">


            <div class="quiz-icon">

                <i class="bi bi-<%= currentQuestionNumber %>-circle-fill"></i>

            </div>


            <div class="quiz-information w-100">


                <h5>
                    Question <%= currentQuestionNumber %>
                </h5>


                <p class="mt-2 mb-3">

                    <%= currentQuestionText %>

                </p>


                <div class="row g-2">


                    <%
                        String answersSql =
                                "SELECT option_label, answer_text, is_correct " +
                                "FROM answers " +
                                "WHERE question_id = ? " +
                                "ORDER BY option_label ASC";

                        try (
                            PreparedStatement answerStatement =
                                    connection.prepareStatement(answersSql)
                        ) {

                            answerStatement.setInt(
                                    1,
                                    currentQuestionId
                            );

                            try (
                                ResultSet answerResult =
                                        answerStatement.executeQuery()
                            ) {

                                while (answerResult.next()) {

                                    String optionLabel =
                                            answerResult.getString(
                                                    "option_label"
                                            );

                                    String answerText =
                                            answerResult.getString(
                                                    "answer_text"
                                            );

                                    boolean isCorrect =
                                            answerResult.getBoolean(
                                                    "is_correct"
                                            );
                    %>


                    <div class="col-md-6">

                        <div
                            class="border rounded p-3
                            <%= isCorrect ? "border-success bg-light" : "" %>">


                            <strong>
                                <%= optionLabel %>.
                            </strong>

                            <%= answerText %>


                            <% if (isCorrect) { %>

                                <span
                                    class="badge bg-success ms-2">

                                    Correct

                                </span>

                            <% } %>


                        </div>

                    </div>


                    <%
                                }
                            }
                        }
                    %>

                </div>


                <%
                    String correctSql =
                            "SELECT option_label, answer_text " +
                            "FROM answers " +
                            "WHERE question_id = ? " +
                            "AND is_correct = TRUE";

                    try (
                        PreparedStatement correctStatement =
                                connection.prepareStatement(correctSql)
                    ) {

                        correctStatement.setInt(
                                1,
                                currentQuestionId
                        );

                        try (
                            ResultSet correctResult =
                                    correctStatement.executeQuery()
                        ) {

                            if (correctResult.next()) {

                                String correctLabel =
                                        correctResult.getString(
                                                "option_label"
                                        );

                                String correctText =
                                        correctResult.getString(
                                                "answer_text"
                                        );
                %>


                <div class="alert alert-success mt-3 mb-0">

                    <i class="bi bi-check-circle-fill me-2"></i>

                    <strong>
                        Correct Answer:
                    </strong>

                    <%= correctLabel %>.
                    <%= correctText %>

                </div>


                <%
                            }
                        }
                    }
                %>


            </div>
              <div class="d-flex justify-content-end mt-3">

                    <a
                        href="edit-question.jsp?quizId=<%= quizId %>&questionId=<%= currentQuestionId %>"
                        class="btn btn-outline-primary">

                        <i class="bi bi-pencil-square me-1"></i>

                        Edit Question

                    </a>

                </div>


            </div>
        </div>


        <%
                    }
                }

            } catch (SQLException e) {

                e.printStackTrace();
        %>


        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            Unable to load quiz questions.

        </div>


        <%
            }
        %>



        <!-- =================================================
             NO QUESTIONS
        ================================================== -->

        <%
            if (savedQuestionCount == 0) {
        %>

        <div class="text-center py-4">

            <i
                class="bi bi-question-circle display-5 text-muted">
            </i>

            <p class="text-muted mt-3 mb-0">

                No questions have been added to this quiz yet.

            </p>

        </div>

        <%
            }
        %>



        <!-- =================================================
             ACTIONS
        ================================================== -->

        <div class="d-flex justify-content-between align-items-center
            border-top pt-4 mt-3">

            <div>

                <a
                    href="add-questions.jsp?quizId=<%= quizId %>"
                    class="btn btn-outline-primary">

                    <i class="bi bi-plus-circle me-1"></i>

                    Continue Adding

                </a>

            </div>

            <div>

                <a
                    href="publish-quiz.jsp?quizId=<%= quizId %>"
                    class="btn btn-primary">

                    Publish Quiz

                    <i class="bi bi-send-fill ms-1"></i>

                </a>

            </div>

        </div>
        


    </div>



    <!-- =================================================
         FOOTER
    ================================================== -->

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



<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>
