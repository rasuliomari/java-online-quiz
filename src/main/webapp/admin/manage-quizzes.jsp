<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    if (session == null
            || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(session.getAttribute("userRole"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String adminFirstName =
            (String) session.getAttribute("adminFirstName");

    String adminLastName =
            (String) session.getAttribute("adminLastName");

    int totalQuizzes = 0;
    int publishedQuizzes = 0;
    int draftQuizzes = 0;

    String countSql =
            "SELECT " +
            "COUNT(*) AS total, " +
            "COUNT(*) FILTER (WHERE status = 'PUBLISHED') AS published, " +
            "COUNT(*) FILTER (WHERE status = 'DRAFT') AS draft " +
            "FROM quizzes";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(countSql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            totalQuizzes = rs.getInt("total");
            publishedQuizzes = rs.getInt("published");
            draftQuizzes = rs.getInt("draft");
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

    <title>Manage Quizzes - UDOM Online Quiz System</title>

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

<!-- ================= NAVBAR ================= -->

<nav class="navbar navbar-dark dashboard-navbar fixed-top">

    <div class="container-fluid">

        <button
            class="btn btn-link text-white d-lg-none"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list fs-3"></i>

        </button>

        <a class="navbar-brand fw-bold"
           href="dashboard.jsp">

            <i class="bi bi-mortarboard-fill me-2"></i>

            UDOM
            <span class="fw-normal">
                Online Quiz System
            </span>

        </a>

        <div class="d-flex align-items-center gap-3">

            <button class="btn btn-link text-white position-relative">

                <i class="bi bi-bell fs-5"></i>

                <span
                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">

                    4

                </span>

            </button>

            <div class="dropdown">

                <button
                    class="btn btn-link text-white dropdown-toggle text-decoration-none"
                    data-bs-toggle="dropdown">

                    <span class="dashboard-avatar">

                        <%= adminFirstName != null
                                ? adminFirstName.substring(0, 1).toUpperCase()
                                : "A" %>

                    </span>

                    <span class="d-none d-md-inline ms-2">

                        <%= adminFirstName != null
                                ? adminFirstName
                                : "Admin" %>

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
                           href="../LogoutServlet">

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

            <i class="bi bi-mortarboard-fill me-2"></i>
            UDOM Admin

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

                <%= adminFirstName != null
                        ? adminFirstName.substring(0, 1).toUpperCase()
                        : "A" %>

            </div>

            <div>

                <h6 class="mb-0">

                    <%= adminFirstName != null
                            ? adminFirstName
                            : "Administrator" %>

                    <%= adminLastName != null
                            ? adminLastName
                            : "" %>

                </h6>

                <small>Administrator</small>

            </div>

        </div>


        <div class="sidebar-menu">

            <div class="sidebar-menu-title">
                MAIN
            </div>

            <a href="dashboard.jsp"
               class="sidebar-link">

                <i class="bi bi-speedometer2"></i>
                <span>Dashboard</span>

            </a>


            <div class="sidebar-menu-title">
                USER MANAGEMENT
            </div>

            <a href="manage-students.jsp"
               class="sidebar-link">

                <i class="bi bi-people"></i>
                <span>Manage Students</span>

            </a>

            <a href="manage-teachers.jsp"
               class="sidebar-link">

                <i class="bi bi-person-workspace"></i>
                <span>Manage Teachers</span>

            </a>


            <div class="sidebar-menu-title">
                ACADEMIC MANAGEMENT
            </div>

            <a href="assign-courses.jsp"
               class="sidebar-link">

                <i class="bi bi-person-plus"></i>
                <span>Assign Courses</span>

            </a>

            <a href="manage-courses.jsp"
               class="sidebar-link">

                <i class="bi bi-book"></i>
                <span>Manage Courses</span>

            </a>

            <a href="manage-quizzes.jsp"
               class="sidebar-link active">

                <i class="bi bi-question-circle"></i>
                <span>Manage Quizzes</span>

            </a>


            <div class="sidebar-menu-title">
                REPORTS
            </div>

            <a href="reports.jsp"
               class="sidebar-link">

                <i class="bi bi-bar-chart"></i>
                <span>Reports</span>

            </a>


            <div class="sidebar-menu-title">
                SYSTEM
            </div>

            <a href="../LogoutServlet"
               class="sidebar-link">

                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- ================= MAIN CONTENT ================= -->

<main class="dashboard-main">

    <div class="dashboard-container">


        <!-- PAGE HEADER -->

        <div class="d-flex justify-content-between
                    align-items-center
                    flex-wrap gap-3 mb-4">

            <div>

                <small class="text-uppercase text-muted fw-semibold">
                    Academic Management
                </small>

                <h2 class="fw-bold mb-1">
                    Manage Quizzes
                </h2>

                <p class="text-muted mb-0">
                    View and manage all quizzes in the system.
                </p>

            </div>

        </div>


        <!-- ================= STAT CARDS ================= -->

        <div class="row g-4 mb-4">

            <div class="col-md-4">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-question-circle"></i>

                    </div>

                    <div>

                        <small class="text-muted">
                            Total Quizzes
                        </small>

                        <h3 class="mb-0">
                            <%= totalQuizzes %>
                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-4">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-check-circle"></i>

                    </div>

                    <div>

                        <small class="text-muted">
                            Published
                        </small>

                        <h3 class="mb-0">
                            <%= publishedQuizzes %>
                        </h3>

                    </div>

                </div>

            </div>


            <div class="col-md-4">

                <div class="stat-card">

                    <div class="stat-icon">

                        <i class="bi bi-pencil-square"></i>

                    </div>

                    <div>

                        <small class="text-muted">
                            Drafts
                        </small>

                        <h3 class="mb-0">
                            <%= draftQuizzes %>
                        </h3>

                    </div>

                </div>

            </div>

        </div>


        <!-- ================= QUIZ TABLE ================= -->

        <div class="content-card">

            <div class="card-header-custom">

                <div>

                    <h5 class="mb-1">
                        All Quizzes
                    </h5>

                    <small class="text-muted">
                        Manage quizzes created by teachers.
                    </small>

                </div>

            </div>


            <div class="table-responsive">

                <table class="table align-middle mb-0">

                    <thead>

                    <tr>

                        <th>#</th>
                        <th>Quiz</th>
                        <th>Course</th>
                        <th>Teacher</th>
                        <th>Questions</th>
                        <th>Duration</th>
                        <th>Pass Mark</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>

                    </tr>

                    </thead>

                    <tbody>

<%
    String quizSql =
        "SELECT q.id, q.title, q.description, " +
        "q.duration_minutes, q.question_count, " +
        "q.pass_mark, q.status, " +
        "c.course_code, c.course_name, " +
        "t.first_name, t.middle_name, t.last_name " +
        "FROM quizzes q " +
        "LEFT JOIN courses c ON q.course_id = c.id " +
        "LEFT JOIN teachers t ON q.teacher_id = t.id " +
        "ORDER BY q.id DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps =
             conn.prepareStatement(quizSql);
         ResultSet rs = ps.executeQuery()) {

        int number = 1;

        while (rs.next()) {

            int quizId = rs.getInt("id");

            String title = rs.getString("title");

            String courseCode =
                    rs.getString("course_code");

            String courseName =
                    rs.getString("course_name");

            String teacherFirstName =
                    rs.getString("first_name");

            String teacherMiddleName =
                    rs.getString("middle_name");

            String teacherLastName =
                    rs.getString("last_name");

            String teacherName = "";

            if (teacherFirstName != null)
                teacherName += teacherFirstName;

            if (teacherMiddleName != null
                    && !teacherMiddleName.trim().isEmpty()) {

                teacherName += " " + teacherMiddleName;

            }

            if (teacherLastName != null)
                teacherName += " " + teacherLastName;

            if (teacherName.trim().isEmpty())
                teacherName = "Not Assigned";

            String courseDisplay =
                    (courseCode != null
                    ? courseCode
                    : "N/A");

            String status =
                    rs.getString("status");

            String statusClass =
                    "PUBLISHED".equalsIgnoreCase(status)
                    ? "bg-success"
                    : "bg-warning text-dark";
%>

                    <tr>

                        <td>
                            <%= number++ %>
                        </td>


                        <td>

                            <div class="fw-semibold">
                                <%= title %>
                            </div>

                        </td>


                        <td>

                            <span class="fw-semibold">
                                <%= courseDisplay %>
                            </span>

                            <br>

                            <small class="text-muted">
                                <%= courseName != null
                                        ? courseName
                                        : "No course assigned" %>
                            </small>

                        </td>


                        <td>
                            <%= teacherName %>
                        </td>


                        <td>
                            <%= rs.getInt("question_count") %>
                        </td>


                        <td>

                            <%= rs.getInt("duration_minutes") %>
                            min

                        </td>


                        <td>

                            <%= rs.getInt("pass_mark") %>%

                        </td>


                        <td>

                            <span class="badge <%= statusClass %>">

                                <%= status %>

                            </span>

                        </td>


                        <td class="text-end">

                            <div class="btn-group">

                                <a
                                    href="view-quiz.jsp?id=<%= quizId %>"
                                    class="btn btn-sm btn-outline-primary"
                                    title="View">

                                    <i class="bi bi-eye"></i>

                                </a>


                                <a
                                    href="edit-quiz.jsp?id=<%= quizId %>"
                                    class="btn btn-sm btn-outline-secondary"
                                    title="Edit">

                                    <i class="bi bi-pencil"></i>

                                </a>


                                <button
                                    type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    title="Delete"
                                    onclick="openDeleteModal(<%= quizId %>, '<%= title.replace("'", "\\'") %>')">

                                    <i class="bi bi-trash"></i>

                                </button>

                            </div>

                        </td>

                    </tr>

<%
        }

    } catch (Exception e) {
%>

                    <tr>

                        <td colspan="9"
                            class="text-center text-danger py-4">

                            <i class="bi bi-exclamation-triangle me-2"></i>

                            Unable to load quizzes.

                        </td>

                    </tr>

<%
        e.printStackTrace();
    }
%>

                    </tbody>

                </table>

            </div>

        </div>


        <!-- ================= INFORMATION CARD ================= -->

        <div class="content-card mt-4">

            <div class="d-flex gap-3">

                <div class="quiz-icon">

                    <i class="bi bi-info-circle"></i>

                </div>

                <div>

                    <h5>
                        Quiz Management
                    </h5>

                    <p class="text-muted mb-0">

                        Administrators can monitor quizzes created
                        by teachers, review their status, inspect
                        questions, edit quiz information, and remove
                        quizzes when necessary.

                    </p>

                </div>

            </div>

        </div>


        <!-- ================= FOOTER ================= -->

        <footer class="dashboard-footer">

            <p class="mb-0">

                &copy; 2026
                University of Dodoma (UDOM).
                Online Quiz System.

            </p>

        </footer>

    </div>

</main>


<!-- ================= DELETE MODAL ================= -->

<div class="modal fade"
     id="deleteQuizModal"
     tabindex="-1">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content">

            <div class="modal-header">

                <h5 class="modal-title">

                    <i class="bi bi-exclamation-triangle text-danger me-2"></i>

                    Delete Quiz

                </h5>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal">
                </button>

            </div>

            <div class="modal-body">

                <p>

                    Are you sure you want to delete:

                </p>

                <p class="fw-bold"
                   id="deleteQuizName">
                </p>

                <div class="alert alert-warning">

                    <i class="bi bi-info-circle me-2"></i>

                    Deleting a quiz will also delete its
                    questions and answers because of the
                    database cascade rules.

                </div>

            </div>

            <div class="modal-footer">

                <button
                    type="button"
                    class="btn btn-secondary"
                    data-bs-dismiss="modal">

                    Cancel

                </button>


                <form method="post"
                      action="../deleteQuiz"
                      class="d-inline">

                    <input
                        type="hidden"
                        name="quizId"
                        id="deleteQuizId">

                    <button
                        type="submit"
                        class="btn btn-danger">

                        <i class="bi bi-trash me-1"></i>

                        Delete Quiz

                    </button>

                </form>

            </div>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>

function openDeleteModal(id, name) {

    document.getElementById("deleteQuizId").value = id;

    document.getElementById("deleteQuizName").textContent = name;

    const modal =
        new bootstrap.Modal(
            document.getElementById("deleteQuizModal")
        );

    modal.show();
}

</script>

</body>

</html>
