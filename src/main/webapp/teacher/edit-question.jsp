
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // =========================================================
    // GET IDs
    // =========================================================

    String quizIdParam = request.getParameter("quizId");
    String questionIdParam = request.getParameter("questionId");

    if (quizIdParam == null || quizIdParam.trim().isEmpty()
            || questionIdParam == null || questionIdParam.trim().isEmpty()) {

        response.sendError(
                400,
                "Quiz ID and Question ID are required."
        );

        return;
    }

    int quizId;
    int questionId;

    try {

        quizId = Integer.parseInt(quizIdParam);
        questionId = Integer.parseInt(questionIdParam);

    } catch (NumberFormatException e) {

        response.sendError(
                400,
                "Invalid quiz ID or question ID."
        );

        return;
    }


    // =========================================================
    // VARIABLES
    // =========================================================

    String quizTitle = "";
    String course = "";

    int questionNumber = 0;

    String questionText = "";

    String answerA = "";
    String answerB = "";
    String answerC = "";
    String answerD = "";

    String correctAnswer = "";


    // =========================================================
    // LOAD QUESTION
    // =========================================================

    String questionSql =
            "SELECT q.question_number, q.question_text, " +
            "a.option_label, a.answer_text, a.is_correct " +
            "FROM questions q " +
            "JOIN answers a ON q.id = a.question_id " +
            "WHERE q.id = ? AND q.quiz_id = ? " +
            "ORDER BY a.option_label";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
                connection.prepareStatement(questionSql)
    ) {

        statement.setInt(1, questionId);
        statement.setInt(2, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            boolean questionFound = false;

            while (resultSet.next()) {

                questionFound = true;

                questionNumber =
                        resultSet.getInt("question_number");

                questionText =
                        resultSet.getString("question_text");

                String option =
                        resultSet.getString("option_label");

                String answer =
                        resultSet.getString("answer_text");

                boolean isCorrect =
                        resultSet.getBoolean("is_correct");


                if ("A".equals(option)) {

                    answerA = answer;

                    if (isCorrect) {
                        correctAnswer = "A";
                    }

                } else if ("B".equals(option)) {

                    answerB = answer;

                    if (isCorrect) {
                        correctAnswer = "B";
                    }

                } else if ("C".equals(option)) {

                    answerC = answer;

                    if (isCorrect) {
                        correctAnswer = "C";
                    }

                } else if ("D".equals(option)) {

                    answerD = answer;

                    if (isCorrect) {
                        correctAnswer = "D";
                    }
                }
            }

            if (!questionFound) {

                response.sendError(
                        404,
                        "Question was not found."
                );

                return;
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendError(
                500,
                "Unable to load question information."
        );

        return;
    }


    // =========================================================
    // LOAD QUIZ INFORMATION
    // =========================================================

    String quizSql =
            "SELECT title, course " +
            "FROM quizzes WHERE id = ?";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
                connection.prepareStatement(quizSql)
    ) {

        statement.setInt(1, quizId);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {

                quizTitle =
                        resultSet.getString("title");

                course =
                        resultSet.getString("course");

            } else {

                response.sendError(
                        404,
                        "Quiz was not found."
                );

                return;
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

        response.sendError(
                500,
                "Unable to load quiz information."
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
    Edit Question | UDOM Online Quiz System
</title>


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

            <span>
                UDOM
            </span>

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


    <!-- PAGE HEADER -->

    <div class="welcome-section">

        <div>

            <span class="welcome-label">
                QUIZ MANAGEMENT
            </span>


            <h1>
                Edit Question
            </h1>


            <p>
                Update the question and its answers.
            </p>

        </div>


        <div class="welcome-icon">

            <i class="bi bi-pencil-square"></i>

        </div>

    </div>



    <!-- QUIZ INFORMATION -->

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

                Question <%= questionNumber %>

            </span>

        </div>

    </div>



    <!-- EDIT FORM -->

    <div class="row g-4">


        <div class="col-xl-8">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Question <%= questionNumber %>
                        </h4>

                        <p>
                            Modify the question and answer options.
                        </p>

                    </div>


                    <div class="quiz-icon">

                        <i class="bi bi-question-lg"></i>

                    </div>

                </div>



                <form
                    action="../updateQuestion"
                    method="post">


                    <!-- IDs -->

                    <input
                        type="hidden"
                        name="quizId"
                        value="<%= quizId %>">


                    <input
                        type="hidden"
                        name="questionId"
                        value="<%= questionId %>">


                    <input
                        type="hidden"
                        name="questionNumber"
                        value="<%= questionNumber %>">



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
                            required><%= questionText %></textarea>

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
                                value="<%= answerA %>"
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
                                value="<%= answerB %>"
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
                                value="<%= answerC %>"
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
                                value="<%= answerD %>"
                                required>

                        </div>

                    </div>



                    <!-- CORRECT ANSWER -->

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
                                disabled>

                                Select the correct answer

                            </option>


                            <option
                                value="A"
                                <%= "A".equals(correctAnswer) ? "selected" : "" %>>

                                Answer A

                            </option>


                            <option
                                value="B"
                                <%= "B".equals(correctAnswer) ? "selected" : "" %>>

                                Answer B

                            </option>


                            <option
                                value="C"
                                <%= "C".equals(correctAnswer) ? "selected" : "" %>>

                                Answer C

                            </option>


                            <option
                                value="D"
                                <%= "D".equals(correctAnswer) ? "selected" : "" %>>

                                Answer D

                            </option>

                        </select>

                    </div>



                    <!-- BUTTONS -->

                    <div
                        class="d-flex justify-content-between
                               align-items-center mt-4">


                        <a
                            href="review-quiz.jsp?quizId=<%= quizId %>"
                            class="btn btn-outline-secondary">

                            <i class="bi bi-arrow-left me-1"></i>

                            Cancel

                        </a>


                        <button
                            type="submit"
                            class="btn btn-primary">

                            <i class="bi bi-check-circle me-1"></i>

                            Save Changes

                        </button>

                    </div>


                </form>

            </div>

        </div>



        <!-- SUMMARY -->

        <div class="col-xl-4">

            <div class="content-card">


                <div class="card-header-custom">

                    <div>

                        <h4>
                            Editing Question
                        </h4>

                        <p>
                            Question information.
                        </p>

                    </div>

                </div>



                <div class="quiz-item">

                    <div class="quiz-icon">

                        <i class="bi bi-hash"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Question Number
                        </h5>


                        <div class="quiz-meta">

                            <span>
                                Question <%= questionNumber %>
                            </span>

                        </div>

                    </div>

                </div>



                <div class="quiz-item">

                    <div class="quiz-icon software-icon">

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



                <div class="quiz-item">

                    <div class="quiz-icon security-icon">

                        <i class="bi bi-check-circle-fill"></i>

                    </div>


                    <div class="quiz-information">

                        <h5>
                            Correct Answer
                        </h5>


                        <div class="quiz-meta">

                            <span>
                                Answer <%= correctAnswer %>
                            </span>

                        </div>

                    </div>

                </div>


            </div>

        </div>

    </div>



    <!-- FOOTER -->

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
