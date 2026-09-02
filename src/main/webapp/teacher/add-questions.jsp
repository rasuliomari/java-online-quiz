<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
// Get quiz ID from the URL
String quizIdParam = request.getParameter("quizId");

if (quizIdParam == null || quizIdParam.trim().isEmpty()) {
    response.sendError(400, "Quiz ID is missing.");
    return;
}

int quizId;

try {
    quizId = Integer.parseInt(quizIdParam);
} catch (NumberFormatException e) {
    response.sendError(400, "Invalid quiz ID.");
    return;
}

// Quiz information
String quizTitle = "";
String course = "";
String description = "";
int duration = 0;
int questionCount = 0;
int passMark = 0;
int existingQuestions = 0;

try (Connection connection = DBConnection.getConnection()) {

    // Get quiz information
    String quizSql =
            "SELECT title, course, description, " +
            "duration_minutes, question_count, pass_mark " +
            "FROM quizzes WHERE id = ?";

    try (PreparedStatement statement =
                 connection.prepareStatement(quizSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {

                quizTitle = resultSet.getString("title");
                course = resultSet.getString("course");
                description = resultSet.getString("description");

                duration =
                        resultSet.getInt("duration_minutes");

                questionCount =
                        resultSet.getInt("question_count");

                passMark =
                        resultSet.getInt("pass_mark");

            } else {

                response.sendError(404, "Quiz not found.");
                return;
            }
        }
    }

    // Count questions already saved
    String countSql =
            "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

    try (PreparedStatement statement =
                 connection.prepareStatement(countSql)) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                existingQuestions = resultSet.getInt(1);
            }
        }
    }

} catch (Exception e) {

    e.printStackTrace();

    response.sendError(
            500,
            "Unable to retrieve quiz information."
    );

    return;
}

// Next question number
int nextQuestionNumber = existingQuestions + 1;

// Check whether this is the final question
boolean lastQuestion =
        nextQuestionNumber == questionCount;

// Check whether all questions have already been saved
boolean quizComplete =
        existingQuestions >= questionCount;

// If the quiz is already complete,
// go directly to the review page.
if (quizComplete) {

    response.sendRedirect(
            "review-quiz.jsp?quizId=" + quizId
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

<title>Add Questions | UDOM Online Quiz System</title>

<!-- Bootstrap -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- Bootstrap Icons -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    rel="stylesheet">

<!-- Shared Dashboard CSS -->
<link
    rel="stylesheet"
    href="../css/dashboard.css">

</head>

<body>

<!-- =========================================================
     NAVBAR
========================================================= -->

<nav class="navbar dashboard-navbar fixed-top">
<div class="container-fluid">

    <button
        class="btn sidebar-toggle d-lg-none me-2"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#teacherSidebar">

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

        <button
            class="notification-btn me-3">

            <i class="bi bi-bell"></i>

            <span class="notification-badge">
                4
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
            href="create-quiz.jsp"
            class="sidebar-link active">

            <i class="bi bi-plus-circle-fill"></i>

            <span>
                Create Quiz
            </span>

        </a>


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


        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-question-circle-fill"></i>

            <span>
                Questions
            </span>

        </a>


        <a
            href="#"
            class="sidebar-link">

            <i class="bi bi-bar-chart-fill"></i>

            <span>
                Student Results
            </span>

        </a>


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

<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<main class="dashboard-main">

<div class="container-fluid dashboard-container">


    <!-- Welcome Section -->

    <div class="welcome-section">

        <div>

            <span class="welcome-label">
                QUIZ MANAGEMENT
            </span>

            <h1>
                Add Questions
            </h1>

            <p>
                Create questions and define the correct
                answers for your quiz.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-question-circle-fill"></i>

        </div>

    </div>


    <!-- Quiz Header -->

    <div class="content-card mb-4">

        <div class="card-header-custom">

            <div>

                <h4>
                    <%= quizTitle %>
                </h4>

                <p>
                    Add questions for this quiz.
                </p>

            </div>


            <div class="quiz-status">

                <span>

                    Question
                    <%= nextQuestionNumber %>
                    of
                    <%= questionCount %>

                </span>

            </div>

        </div>

    </div>


    <div class="row g-4">


        <!-- =================================================
             QUESTION FORM
        ================================================= -->

        <div class="col-xl-8">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Question
                            <%= nextQuestionNumber %>
                        </h4>

                        <p>
                            Enter the question and its answers.
                        </p>

                    </div>


                    <div class="quiz-icon">

                        <i class="bi bi-question-lg"></i>

                    </div>

                </div>


                <form
                    action="../saveQuestion"
                    method="post">


                    <!-- Quiz ID -->

                    <input
                        type="hidden"
                        name="quizId"
                        value="<%= quizId %>">


                    <!-- Question Number -->

                    <input
                        type="hidden"
                        name="questionNumber"
                        value="<%= nextQuestionNumber %>">


                    <!-- Question -->

                    <div class="mb-4">

                        <label
                            for="questionText"
                            class="form-label">

                            Question
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <textarea
                            class="form-control"
                            id="questionText"
                            name="questionText"
                            rows="4"
                            placeholder="Enter your question here..."
                            required></textarea>

                    </div>


                    <!-- Answer A -->

                    <div class="mb-3">

                        <label
                            for="answerA"
                            class="form-label">

                            Answer A
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                A
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerA"
                                name="answerA"
                                placeholder="Enter answer A"
                                required>

                        </div>

                    </div>


                    <!-- Answer B -->

                    <div class="mb-3">

                        <label
                            for="answerB"
                            class="form-label">

                            Answer B
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                B
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerB"
                                name="answerB"
                                placeholder="Enter answer B"
                                required>

                        </div>

                    </div>


                    <!-- Answer C -->

                    <div class="mb-3">

                        <label
                            for="answerC"
                            class="form-label">

                            Answer C
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                C
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerC"
                                name="answerC"
                                placeholder="Enter answer C"
                                required>

                        </div>

                    </div>


                    <!-- Answer D -->

                    <div class="mb-4">

                        <label
                            for="answerD"
                            class="form-label">

                            Answer D
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <div class="input-group">

                            <span class="input-group-text">
                                D
                            </span>

                            <input
                                type="text"
                                class="form-control"
                                id="answerD"
                                name="answerD"
                                placeholder="Enter answer D"
                                required>

                        </div>

                    </div>


                    <!-- Correct Answer -->

                    <div class="mb-4">

                        <label
                            for="correctAnswer"
                            class="form-label">

                            Correct Answer
                            <span class="text-danger">
                                *
                            </span>

                        </label>


                        <select
                            class="form-select"
                            id="correctAnswer"
                            name="correctAnswer"
                            required>

                            <option
                                value=""
                                selected
                                disabled>

                                Select the correct answer

                            </option>

                            <option value="A">
                                Answer A
                            </option>

                            <option value="B">
                                Answer B
                            </option>

                            <option value="C">
                                Answer C
                            </option>

                            <option value="D">
                                Answer D
                            </option>

                        </select>

                    </div>


                    <!-- Buttons -->
                    <div
                        class="d-flex justify-content-between
                            align-items-center mt-4">

                        <!-- Back -->

                        <a
                            href="create-quiz.jsp"
                            class="btn btn-outline-secondary">

                            <i class="bi bi-arrow-left me-1"></i>

                            Back

                        </a>


                        <div class="d-flex gap-2">

                            <% if (lastQuestion) { %>

                                <!-- =========================================
                                    LAST QUESTION
                                    ========================================= -->

                                <button
                                    type="submit"
                                    name="action"
                                    value="review"
                                    class="btn btn-primary">

                                    <i class="bi bi-check-circle-fill me-1"></i>

                                    Save & Review

                                </button>


                            <% } else { %>

                                <!-- =========================================
                                    MORE QUESTIONS REMAIN
                                    ========================================= -->

                                <button
                                    type="submit"
                                    name="action"
                                    value="add"
                                    class="btn btn-outline-primary">

                                    <i class="bi bi-plus-circle me-1"></i>

                                    Save & Next

                                </button>


                                <a
                                    href="review-quiz.jsp?quizId=<%= quizId %>"
                                    class="btn btn-primary">

                                    Review Quiz

                                    <i class="bi bi-arrow-right ms-1"></i>

                                </a>

                            <% } %>

                        </div>

                    </div>


                </form>

            </div>

        </div>


        <!-- =================================================
             QUIZ SUMMARY
        ================================================= -->

        <div class="col-xl-4">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Quiz Summary
                        </h4>

                        <p>
                            Current quiz information.
                        </p>

                    </div>

                </div>


                <!-- Course -->

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


                <!-- Duration -->

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
                                <%= duration %> Minutes
                            </span>

                        </div>

                    </div>

                </div>


                <!-- Questions -->

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

                                <%= existingQuestions %>
                                of
                                <%= questionCount %>

                            </span>

                        </div>

                    </div>

                </div>


                <!-- Pass Mark -->

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


            <!-- Instructions -->

            <div class="content-card mt-4">

                <div class="card-header-custom">

                    <div>

                        <h4>
                            Instructions
                        </h4>

                        <p>
                            Before adding questions
                        </p>

                    </div>

                </div>


                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-lightbulb-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Write Clear Questions
                        </h5>

                        <div class="quiz-meta">

                            <span>

                                Make each question simple
                                and easy for students to
                                understand.

                            </span>

                        </div>

                    </div>

                </div>


                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-check-circle-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Select Correct Answer
                        </h5>

                        <div class="quiz-meta">

                            <span>

                                Always select one correct
                                answer before continuing.

                            </span>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         FOOTER
    ================================================= -->

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
