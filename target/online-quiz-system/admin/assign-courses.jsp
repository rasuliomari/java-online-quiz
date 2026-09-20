<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ============================================================
    // SESSION CHECK
    // ============================================================
    if (session.getAttribute("adminLoggedIn") == null ||
        !(Boolean) session.getAttribute("adminLoggedIn")) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String contextPath = request.getContextPath();

    // ============================================================
    // CURRENT ADMIN DETAILS
    // ============================================================
    String adminFirstName = (String) session.getAttribute("adminFirstName");
    String adminLastName = (String) session.getAttribute("adminLastName");
    String adminUsername = (String) session.getAttribute("adminUsername");

    if (adminFirstName == null) adminFirstName = "Admin";
    if (adminLastName == null) adminLastName = "";
    if (adminUsername == null) adminUsername = "Administrator";

    String adminFullName =
            (adminFirstName + " " + adminLastName).trim();

    String adminInitials =
            ((adminFirstName.length() > 0)
                    ? adminFirstName.substring(0, 1).toUpperCase()
                    : "A")
            +
            ((adminLastName.length() > 0)
                    ? adminLastName.substring(0, 1).toUpperCase()
                    : "");

    // ============================================================
    // PARAMETERS
    // ============================================================
    String selectedTeacherId =
            request.getParameter("teacherId");

    String selectedProgrammeId =
            request.getParameter("programmeId");

    String selectedYear =
            request.getParameter("year");

    String message =
            request.getParameter("message");

    String messageType =
            request.getParameter("messageType");

    if (messageType == null || messageType.trim().isEmpty()) {
        messageType = "info";
    }

    // ============================================================
    // LOAD TEACHERS
    // ============================================================
    java.util.List<java.util.Map<String, String>> teachers =
            new java.util.ArrayList<>();

    // ============================================================
    // LOAD COLLEGES
    // ============================================================
    java.util.List<java.util.Map<String, String>> colleges =
            new java.util.ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {

        // --------------------------------------------------------
        // TEACHERS
        // --------------------------------------------------------
        String teacherSql =
                "SELECT id, staff_number, first_name, middle_name, last_name " +
                "FROM teachers " +
                "ORDER BY first_name, last_name";

        try (PreparedStatement ps =
                     conn.prepareStatement(teacherSql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                java.util.Map<String, String> teacher =
                        new java.util.HashMap<>();

                String firstName = rs.getString("first_name");
                String middleName = rs.getString("middle_name");
                String lastName = rs.getString("last_name");

                String fullName =
                        java.util.Arrays.asList(
                                firstName,
                                middleName,
                                lastName
                        ).stream()
                         .filter(java.util.Objects::nonNull)
                         .map(String::trim)
                         .filter(s -> !s.isEmpty())
                         .collect(java.util.stream.Collectors.joining(" "));

                teacher.put(
                        "id",
                        String.valueOf(rs.getInt("id"))
                );

                teacher.put(
                        "staffNumber",
                        rs.getString("staff_number")
                );

                teacher.put(
                        "name",
                        fullName
                );

                teachers.add(teacher);
            }
        }

        // --------------------------------------------------------
        // COLLEGES
        // --------------------------------------------------------
        String collegeSql =
                "SELECT id, name " +
                "FROM colleges " +
                "ORDER BY name";

        try (PreparedStatement ps =
                     conn.prepareStatement(collegeSql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                java.util.Map<String, String> college =
                        new java.util.HashMap<>();

                college.put(
                        "id",
                        String.valueOf(rs.getInt("id"))
                );

                college.put(
                        "name",
                        rs.getString("name")
                );

                colleges.add(college);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    // ============================================================
    // INITIAL COLLEGE
    //
    // If a teacher is already selected and a programme was supplied,
    // determine its college so the page can restore the selection.
    // ============================================================
    String initialCollegeId = "";

    if (selectedProgrammeId != null &&
        !selectedProgrammeId.trim().isEmpty()) {

        try (Connection conn = DBConnection.getConnection()) {

            String sql =
                    "SELECT college_id " +
                    "FROM programmes " +
                    "WHERE id = ?";

            try (PreparedStatement ps =
                         conn.prepareStatement(sql)) {

                ps.setInt(
                        1,
                        Integer.parseInt(selectedProgrammeId)
                );

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        initialCollegeId =
                                String.valueOf(
                                        rs.getInt("college_id")
                                );
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Assign Courses | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Dashboard CSS -->
    <link
        rel="stylesheet"
        href="<%= contextPath %>/css/dashboard.css">

    <style>

        /* ========================================================
           PAGE HEADER
           ======================================================== */

        .assign-page-header {
            margin-bottom: 25px;
        }

        .assign-page-title {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 6px;
        }

        .assign-page-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(13, 110, 253, 0.10);
            color: #0d6efd;
            font-size: 23px;
        }

        .assign-page-title h2 {
            margin: 0;
            font-size: 1.65rem;
            font-weight: 700;
        }

        .assign-page-header p {
            margin: 0;
            color: #6c757d;
        }


        /* ========================================================
           FILTER CARD
           ======================================================== */

        .assignment-filter-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            margin-bottom: 25px;
        }

        .assignment-filter-card .card-header {
            background: transparent;
            border-bottom: 1px solid #edf0f4;
            padding: 20px 22px;
        }

        .assignment-filter-card .card-body {
            padding: 22px;
        }

        .filter-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            color: #212529;
        }

        .filter-title i {
            color: #0d6efd;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 7px;
        }

        .form-select {
            min-height: 44px;
            border-radius: 10px;
            border-color: #dee2e6;
        }

        .form-select:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.12);
        }


        /* ========================================================
           COURSE SUMMARY
           ======================================================== */

        .course-summary {
            margin-bottom: 20px;
        }

        .course-summary-card {
            border: 0;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            padding: 18px 20px;
        }

        .course-summary-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .course-summary-title {
            font-weight: 700;
            margin-bottom: 4px;
        }

        .course-summary-text {
            color: #6c757d;
            margin: 0;
            font-size: 0.9rem;
        }

        .course-count-badge {
            background: rgba(13, 110, 253, 0.1);
            color: #0d6efd;
            border-radius: 50px;
            padding: 8px 14px;
            font-weight: 700;
            font-size: 0.85rem;
        }


        /* ========================================================
           COURSE ITEMS
           ======================================================== */

        .assignment-course-item {
            border: 1px solid #e9ecef;
            border-radius: 15px;
            background: #fff;
            padding: 17px;
            margin-bottom: 14px;
            transition: all 0.2s ease;
        }

        .assignment-course-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 16px rgba(0, 0, 0, 0.06);
        }

        .assignment-course-row {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .assignment-course-icon {
            width: 45px;
            height: 45px;
            min-width: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(13, 110, 253, 0.09);
            color: #0d6efd;
            font-size: 20px;
        }

        .assignment-course-information {
            flex: 1;
            min-width: 0;
        }

        .assignment-course-code {
            font-size: 0.8rem;
            font-weight: 700;
            color: #0d6efd;
            margin-bottom: 3px;
        }

        .assignment-course-name {
            font-weight: 700;
            margin-bottom: 3px;
            color: #212529;
        }

        .assignment-course-year {
            color: #6c757d;
            font-size: 0.84rem;
        }

        .assignment-status {
            text-align: right;
            min-width: 150px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            border-radius: 50px;
            padding: 7px 11px;
            font-size: 0.76rem;
            font-weight: 700;
        }

        .status-current {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-other {
            background: #fff3cd;
            color: #664d03;
        }

        .status-available {
            background: #e9ecef;
            color: #495057;
        }

        .assignment-course-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .assignment-course-checkbox:disabled {
            cursor: not-allowed;
        }


        /* ========================================================
           SAVE CARD
           ======================================================== */

        .assignment-save-card {
            border: 0;
            border-radius: 17px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            margin-top: 20px;
            margin-bottom: 30px;
        }

        .assignment-save-card .card-body {
            padding: 20px;
        }

        .save-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .save-description {
            color: #6c757d;
            margin: 0;
            font-size: 0.9rem;
        }

        .save-button {
            min-width: 150px;
            border-radius: 10px;
            font-weight: 600;
            padding: 10px 18px;
        }


        /* ========================================================
           EMPTY STATE
           ======================================================== */

        .assignment-empty-state {
            text-align: center;
            background: #fff;
            border-radius: 17px;
            padding: 55px 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .assignment-empty-icon {
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background: #f1f3f5;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 27px;
        }

        .assignment-empty-state h5 {
            font-weight: 700;
            margin-bottom: 8px;
        }

        .assignment-empty-state p {
            color: #6c757d;
            margin: 0;
        }


        /* ========================================================
           LEGEND
           ======================================================== */

        .assignment-legend {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 15px;
            color: #6c757d;
            font-size: 0.82rem;
        }

        .legend-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        .legend-current {
            background: #198754;
        }

        .legend-other {
            background: #ffc107;
        }

        .legend-available {
            background: #adb5bd;
        }


        /* ========================================================
           ALERT
           ======================================================== */

        .assignment-alert {
            border: 0;
            border-radius: 12px;
            margin-bottom: 20px;
        }


        /* ========================================================
           RESPONSIVE
           ======================================================== */

        @media (max-width: 768px) {

            .assignment-course-row {
                align-items: flex-start;
            }

            .assignment-status {
                min-width: auto;
                text-align: left;
            }

            .assignment-course-information {
                width: 100%;
            }

            .course-summary-content,
            .save-content {
                align-items: flex-start;
                flex-direction: column;
            }

            .save-button {
                width: 100%;
            }
        }

    </style>

</head>

<body>

<!-- ============================================================
     NAVBAR
     ============================================================ -->

<nav class="navbar navbar-expand-lg dashboard-navbar fixed-top">

    <div class="container-fluid">

        <!-- Mobile Sidebar Button -->
        <button
            class="btn d-lg-none me-2"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#adminSidebar">

            <i class="bi bi-list fs-4"></i>

        </button>


        <!-- Brand -->
        <a
            class="navbar-brand d-flex align-items-center"
            href="dashboard.jsp">

            <i class="bi bi-mortarboard-fill me-2"></i>

            <span>
                <strong>UDOM</strong>
                <span class="d-none d-sm-inline">
                    / Online Quiz System
                </span>
            </span>

        </a>


        <!-- Right Side -->
        <div class="ms-auto d-flex align-items-center">

            <!-- Notification -->
            <button
                class="btn btn-link text-decoration-none position-relative me-2">

                <i class="bi bi-bell fs-5"></i>

                <span
                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                    style="font-size: 0.55rem;">
                    3
                </span>

            </button>


            <!-- Profile Dropdown -->
            <div class="dropdown">

                <button
                    class="btn d-flex align-items-center border-0"
                    type="button"
                    data-bs-toggle="dropdown">

                    <div
                        class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-2"
                        style="width: 38px; height: 38px; font-size: 0.8rem; font-weight: 700;">

                        <%= adminInitials %>

                    </div>

                    <div class="d-none d-md-block text-start">

                        <div
                            style="font-size: 0.85rem; font-weight: 700;">

                            <%= adminFullName %>

                        </div>

                        <div
                            style="font-size: 0.72rem; color: #6c757d;">

                            System Administrator

                        </div>

                    </div>

                    <i class="bi bi-chevron-down ms-2 small"></i>

                </button>


                <ul class="dropdown-menu dropdown-menu-end shadow border-0">

                    <li>
                        <h6 class="dropdown-header">
                            <%= adminUsername %>
                        </h6>
                    </li>

                    <li>
                        <a
                            class="dropdown-item"
                            href="profile.jsp">

                            <i class="bi bi-person me-2"></i>
                            My Profile

                        </a>
                    </li>

                    <li>
                        <a
                            class="dropdown-item"
                            href="settings.jsp">

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
                            href="<%= contextPath %>/logout">

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
    id="adminSidebar">

    <div class="offcanvas-header d-lg-none">

        <h5 class="offcanvas-title">
            UDOM Online Quiz System
        </h5>

        <button
            type="button"
            class="btn-close"
            data-bs-dismiss="offcanvas"
            data-bs-target="#adminSidebar">
        </button>

    </div>


    <div class="offcanvas-body d-flex flex-column p-0">

        <!-- Sidebar Profile -->
        <div class="sidebar-profile">

            <div class="sidebar-avatar">
                <%= adminInitials %>
            </div>

            <div class="sidebar-profile-info">

                <div class="sidebar-profile-name">
                    <%= adminFullName %>
                </div>

                <div class="sidebar-profile-role">
                    System Administrator
                </div>

            </div>

        </div>


        <!-- Main Navigation -->
        <div class="sidebar-menu">

            <div class="sidebar-section-title">
                MAIN MENU
            </div>

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

                <i class="bi bi-people"></i>
                <span>Manage Teachers</span>

            </a>


            <a
                href="manage-courses.jsp"
                class="sidebar-link">

                <i class="bi bi-journal-bookmark"></i>
                <span>Manage Courses</span>

            </a>


            <a
                href="assign-courses.jsp"
                class="sidebar-link active">

                <i class="bi bi-person-check"></i>
                <span>Assign Courses</span>

            </a>


            <a
                href="manage-students.jsp"
                class="sidebar-link">

                <i class="bi bi-mortarboard"></i>
                <span>Manage Students</span>

            </a>


            <a
                href="manage-quizzes.jsp"
                class="sidebar-link">

                <i class="bi bi-ui-checks-grid"></i>
                <span>Manage Quizzes</span>

            </a>


            <a
                href="results.jsp"
                class="sidebar-link">

                <i class="bi bi-bar-chart"></i>
                <span>Student Results</span>

            </a>


            <a
                href="reports.jsp"
                class="sidebar-link">

                <i class="bi bi-file-earmark-bar-graph"></i>
                <span>Reports</span>

            </a>


            <div class="sidebar-section-title mt-4">
                ACCOUNT
            </div>


            <a
                href="profile.jsp"
                class="sidebar-link">

                <i class="bi bi-person-circle"></i>
                <span>My Profile</span>

            </a>


            <a
                href="settings.jsp"
                class="sidebar-link">

                <i class="bi bi-gear"></i>
                <span>Settings</span>

            </a>

        </div>


        <!-- Logout -->
        <div class="sidebar-logout mt-auto">

            <a
                href="<%= contextPath %>/logout"
                class="sidebar-link text-danger">

                <i class="bi bi-box-arrow-right"></i>
                <span>Logout</span>

            </a>

        </div>

    </div>

</div>


<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="dashboard-main">

    <div class="dashboard-container">


        <!-- ====================================================
             PAGE HEADER
             ==================================================== -->

        <div class="assign-page-header">

            <div class="assign-page-title">

                <div class="assign-page-icon">

                    <i class="bi bi-person-check"></i>

                </div>

                <div>

                    <h2>Assign Courses</h2>

                    <p>
                        Assign courses to teachers by programme and year of study.
                    </p>

                </div>

            </div>

        </div>


        <!-- ====================================================
             ALERT
             ==================================================== -->

        <% if (message != null &&
               !message.trim().isEmpty()) { %>

            <div
                class="alert alert-<%= messageType %> assignment-alert d-flex align-items-center"
                role="alert">

                <i class="bi
                    <%= "success".equals(messageType)
                        ? "bi-check-circle"
                        : "warning".equals(messageType)
                            ? "bi-exclamation-triangle"
                            : "info".equals(messageType)
                                ? "bi-info-circle"
                                : "bi-exclamation-circle"
                    %> me-2">
                </i>

                <%= message %>

            </div>

        <% } %>


        <!-- ====================================================
             FILTER CARD
             ==================================================== -->

        <div class="card assignment-filter-card">

            <div class="card-header">

                <div class="filter-title">

                    <i class="bi bi-funnel"></i>

                    <span>
                        Select Assignment Details
                    </span>

                </div>

            </div>


            <div class="card-body">

                <div class="row g-3">


                    <!-- ==================================================
                         TEACHER
                         ================================================== -->

                    <div class="col-lg-3 col-md-6">

                        <label
                            for="teacherSelect"
                            class="form-label">

                            Teacher

                        </label>

                        <select
                            id="teacherSelect"
                            class="form-select">

                            <option value="">
                                Select Teacher
                            </option>

                            <% for (java.util.Map<String, String> teacher : teachers) { %>

                                <option
                                    value="<%= teacher.get("id") %>"
                                    <%= teacher.get("id").equals(selectedTeacherId)
                                        ? "selected"
                                        : "" %>>

                                    <%= teacher.get("name") %>
                                    -
                                    <%= teacher.get("staffNumber") %>

                                </option>

                            <% } %>

                        </select>

                    </div>


                    <!-- ==================================================
                         COLLEGE
                         ================================================== -->

                    <div class="col-lg-3 col-md-6">

                        <label
                            for="collegeSelect"
                            class="form-label">

                            College

                        </label>

                        <select
                            id="collegeSelect"
                            class="form-select">

                            <option value="">
                                Select College
                            </option>

                            <% for (java.util.Map<String, String> college : colleges) { %>

                                <option
                                    value="<%= college.get("id") %>"
                                    <%= college.get("id").equals(initialCollegeId)
                                        ? "selected"
                                        : "" %>>

                                    <%= college.get("name") %>

                                </option>

                            <% } %>

                        </select>

                    </div>


                    <!-- ==================================================
                         PROGRAMME
                         ================================================== -->

                    <div class="col-lg-3 col-md-6">

                        <label
                            for="programmeSelect"
                            class="form-label">

                            Programme

                        </label>

                        <select
                            id="programmeSelect"
                            class="form-select"
                            disabled>

                            <option value="">
                                Select College First
                            </option>

                        </select>

                    </div>


                    <!-- ==================================================
                         YEAR
                         ================================================== -->

                    <div class="col-lg-3 col-md-6">

                        <label
                            for="yearSelect"
                            class="form-label">

                            Year of Study

                        </label>

                        <select
                            id="yearSelect"
                            class="form-select">

                            <option value="">
                                Select Year
                            </option>

                            <option
                                value="1"
                                <%= "1".equals(selectedYear)
                                    ? "selected"
                                    : "" %>>
                                Year 1
                            </option>

                            <option
                                value="2"
                                <%= "2".equals(selectedYear)
                                    ? "selected"
                                    : "" %>>
                                Year 2
                            </option>

                            <option
                                value="3"
                                <%= "3".equals(selectedYear)
                                    ? "selected"
                                    : "" %>>
                                Year 3
                            </option>

                            <option
                                value="4"
                                <%= "4".equals(selectedYear)
                                    ? "selected"
                                    : "" %>>
                                Year 4
                            </option>

                            <option
                                value="5"
                                <%= "5".equals(selectedYear)
                                    ? "selected"
                                    : "" %>>
                                Year 5
                            </option>

                        </select>

                    </div>

                </div>

            </div>

        </div>


        <!-- ====================================================
             COURSE SUMMARY
             ==================================================== -->

        <div
            id="courseSummary"
            class="course-summary d-none">

            <div class="course-summary-card">

                <div class="course-summary-content">

                    <div>

                        <div class="course-summary-title">
                            Available Courses
                        </div>

                        <p
                            id="courseSummaryText"
                            class="course-summary-text">
                            Courses available for assignment.
                        </p>

                    </div>

                    <div
                        id="courseCount"
                        class="course-count-badge">
                        0 Courses
                    </div>

                </div>

            </div>

        </div>


        <!-- ====================================================
             COURSES CONTAINER
             ==================================================== -->

        <div
            id="coursesContainer"
            class="row g-0">

            <div class="col-12">

                <div class="assignment-empty-state">

                    <div class="assignment-empty-icon">

                        <i class="bi bi-funnel"></i>

                    </div>

                    <h5>
                        Select Assignment Details
                    </h5>

                    <p>
                        Select a teacher, college, programme and year
                        to load courses.
                    </p>

                </div>

            </div>

        </div>


        <!-- ====================================================
             SAVE CARD
             ==================================================== -->

        <div
            id="saveCard"
            class="card assignment-save-card d-none">

            <div class="card-body">

                <div class="save-content">

                    <div>

                        <div
                            class="fw-bold mb-1">

                            Save Course Assignments

                        </div>

                        <p class="save-description">

                            Select the courses that should belong to
                            this teacher, then save the changes.

                        </p>

                    </div>

                    <button
                        type="button"
                        id="saveAssignmentsButton"
                        class="btn btn-primary save-button">

                        <i class="bi bi-check2-circle me-1"></i>

                        Save Assignments

                    </button>

                </div>

            </div>

        </div>


        <!-- ====================================================
             LEGEND
             ==================================================== -->

        <div class="assignment-legend">

            <div class="legend-item">

                <span
                    class="legend-dot legend-current">
                </span>

                Assigned to this teacher

            </div>


            <div class="legend-item">

                <span
                    class="legend-dot legend-other">
                </span>

                Assigned elsewhere

            </div>


            <div class="legend-item">

                <span
                    class="legend-dot legend-available">
                </span>

                Available

            </div>

        </div>


    </div>


    <!-- ========================================================
         FOOTER
         ======================================================== -->

    <footer class="dashboard-footer">

        <div class="container-fluid">

            <div class="text-center">

                <small class="text-muted">

                    © <%= java.time.Year.now().getValue() %>
                    University of Dodoma
                    — Online Quiz System

                </small>

            </div>

        </div>

    </footer>

</main>


<!-- ============================================================
     HIDDEN FORM FOR SAVING ASSIGNMENTS
     ============================================================ -->

<form
    id="assignmentForm"
    method="post"
    action="<%= contextPath %>/assignCourse">

    <input
        type="hidden"
        name="teacherId"
        id="formTeacherId">

    <input
        type="hidden"
        name="programmeId"
        id="formProgrammeId">

    <input
        type="hidden"
        name="year"
        id="formYear">

    <div id="selectedCoursesInputs"></div>

</form>


<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script>

    /* ============================================================
       CONTEXT PATH
       ============================================================ */

    const contextPath = "<%= contextPath %>";


    /* ============================================================
       ELEMENTS
       ============================================================ */

    const teacherSelect =
        document.getElementById("teacherSelect");

    const collegeSelect =
        document.getElementById("collegeSelect");

    const programmeSelect =
        document.getElementById("programmeSelect");

    const yearSelect =
        document.getElementById("yearSelect");

    const coursesContainer =
        document.getElementById("coursesContainer");

    const courseSummary =
        document.getElementById("courseSummary");

    const courseSummaryText =
        document.getElementById("courseSummaryText");

    const courseCount =
        document.getElementById("courseCount");

    const saveCard =
        document.getElementById("saveCard");

    const saveAssignmentsButton =
        document.getElementById("saveAssignmentsButton");

    const assignmentForm =
        document.getElementById("assignmentForm");

    const formTeacherId =
        document.getElementById("formTeacherId");

    const formProgrammeId =
        document.getElementById("formProgrammeId");

    const formYear =
        document.getElementById("formYear");

    const selectedCoursesInputs =
        document.getElementById("selectedCoursesInputs");


    /* ============================================================
       INITIAL VALUES
       ============================================================ */

    const initialCollegeId =
        "<%= initialCollegeId %>";

    const initialProgrammeId =
        "<%= selectedProgrammeId == null ? "" : selectedProgrammeId %>";

    const initialTeacherId =
        "<%= selectedTeacherId == null ? "" : selectedTeacherId %>";

    const initialYear =
        "<%= selectedYear == null ? "" : selectedYear %>";


    /* ============================================================
       EMPTY STATE
       ============================================================ */

    function showEmptyState(title, text) {

        coursesContainer.innerHTML =
            "<div class=\"col-12\">" +

                "<div class=\"assignment-empty-state\">" +

                    "<div class=\"assignment-empty-icon\">" +

                        "<i class=\"bi bi-funnel\"></i>" +

                    "</div>" +

                    "<h5>" +
                        title +
                    "</h5>" +

                    "<p>" +
                        text +
                    "</p>" +

                "</div>" +

            "</div>";

        courseSummary.classList.add("d-none");
        saveCard.classList.add("d-none");
    }


    /* ============================================================
       LOAD PROGRAMMES
       ============================================================ */

    async function loadProgrammes(collegeId, selectedProgramme) {

        /*
         * No college selected.
         */
        if (!collegeId) {

            programmeSelect.innerHTML =
                "<option value=\"\">" +
                    "Select College First" +
                "</option>";

            programmeSelect.disabled = true;

            return;
        }


        /*
         * Show loading state.
         */
        programmeSelect.disabled = true;

        programmeSelect.innerHTML =
            "<option value=\"\">" +
                "Loading programmes..." +
            "</option>";


        try {

            const url =
                contextPath +
                "/getProgrammes?collegeId=" +
                encodeURIComponent(collegeId);


            console.log(
                "Loading programmes from:",
                url
            );


            const response =
                await fetch(url, {
                    method: "GET",
                    headers: {
                        "Accept": "application/json"
                    },
                    cache: "no-store"
                });


            console.log(
                "Programme response status:",
                response.status
            );


            if (!response.ok) {

                throw new Error(
                    "HTTP " + response.status
                );

            }


            const data =
                await response.json();


            console.log(
                "Programme data:",
                data
            );


            /*
             * Reset dropdown.
             */
            programmeSelect.innerHTML =
                "<option value=\"\">" +
                    "Select Programme" +
                "</option>";


            /*
             * Check returned data.
             */
            if (!Array.isArray(data) ||
                data.length === 0) {

                programmeSelect.innerHTML =
                    "<option value=\"\">" +
                        "No programmes found" +
                    "</option>";

                programmeSelect.disabled = true;

                showEmptyState(
                    "No Programmes Found",
                    "The selected college does not have any programmes."
                );

                return;
            }


            /*
             * Add programmes.
             *
             * IMPORTANT:
             * GetProgrammesServlet returns:
             *
             * id
             * name
             *
             */
            data.forEach(function (programme) {

                const option =
                    document.createElement("option");

                option.value =
                    programme.id;

                option.textContent =
                    programme.name;

                if (
                    selectedProgramme &&
                    String(programme.id) ===
                    String(selectedProgramme)
                ) {

                    option.selected = true;

                }

                programmeSelect.appendChild(option);

            });


            /*
             * Enable programme dropdown.
             */
            programmeSelect.disabled = false;


            /*
             * If everything is already selected,
             * load courses automatically.
             */
            if (
                teacherSelect.value &&
                programmeSelect.value &&
                yearSelect.value
            ) {

                loadCourses();

            }

        } catch (error) {

            console.error(
                "Error loading programmes:",
                error
            );


            programmeSelect.innerHTML =
                "<option value=\"\">" +
                    "Unable to load programmes" +
                "</option>";

            programmeSelect.disabled = true;


            showEmptyState(
                "Unable to Load Programmes",
                "Please check the server and try selecting the college again."
            );

        }

    }


    /* ============================================================
       LOAD COURSES
       ============================================================ */

    async function loadCourses() {

        const teacherId =
            teacherSelect.value;

        const programmeId =
            programmeSelect.value;

        const year =
            yearSelect.value;


        /*
         * Check all required selections.
         */
        if (
            !teacherId ||
            !programmeId ||
            !year
        ) {

            showEmptyState(
                "Complete the Selection",
                "Select a teacher, programme and year to load courses."
            );

            return;
        }


        /*
         * Show loading state.
         */
        coursesContainer.innerHTML =
            "<div class=\"col-12\">" +

                "<div class=\"assignment-empty-state\">" +

                    "<div class=\"assignment-empty-icon\">" +

                        "<div class=\"spinner-border text-primary\" role=\"status\">" +
                            "<span class=\"visually-hidden\">" +
                                "Loading..." +
                            "</span>" +
                        "</div>" +

                    "</div>" +

                    "<h5>Loading Courses</h5>" +

                    "<p>Please wait while the courses are loaded.</p>" +

                "</div>" +

            "</div>";

        courseSummary.classList.add("d-none");
        saveCard.classList.add("d-none");


        try {

            const url =
                contextPath +
                "/assignCourse?action=list" +
                "&teacherId=" +
                encodeURIComponent(teacherId) +
                "&programmeId=" +
                encodeURIComponent(programmeId) +
                "&year=" +
                encodeURIComponent(year);


            console.log(
                "Loading courses from:",
                url
            );


            const response =
                await fetch(url, {
                    method: "GET",
                    headers: {
                        "Accept": "application/json"
                    },
                    cache: "no-store"
                });


            console.log(
                "Course response status:",
                response.status
            );


            if (!response.ok) {

                throw new Error(
                    "HTTP " + response.status
                );

            }


            const data =
                await response.json();


            console.log(
                "Course data:",
                data
            );


            /*
             * Expect an array.
             */
            if (!Array.isArray(data)) {

                throw new Error(
                    "Invalid course response."
                );

            }


            renderCourses(data);


        } catch (error) {

            console.error(
                "Error loading courses:",
                error
            );


            showEmptyState(
                "Unable to Load Courses",
                "Please try again or check the server logs."
            );

        }

    }


    /* ============================================================
       RENDER COURSES
       ============================================================ */

    function renderCourses(courses) {

        coursesContainer.innerHTML = "";


        if (
            !courses ||
            courses.length === 0
        ) {

            showEmptyState(
                "No Courses Found",
                "There are no courses for the selected programme and year."
            );

            return;

        }


        /*
         * Update summary.
         */
        courseSummary.classList.remove("d-none");

        courseSummaryText.textContent =
            courses.length +
            " course" +
            (courses.length === 1 ? "" : "s") +
            " found for the selected programme and year.";

        courseCount.textContent =
            courses.length +
            " Course" +
            (courses.length === 1 ? "" : "s");


        /*
         * Show save card.
         */
        saveCard.classList.remove("d-none");


        /*
         * Create each course.
         */
        courses.forEach(function (course) {

            const courseId =
                course.id;

            const courseCode =
                course.course_code || "";

            const courseName =
                course.course_name || "";

            const courseYear =
                course.year_of_study || "";


            const assigned =
                course.assigned === true ||
                course.assigned === "true";


            const assignedElsewhere =
                course.assigned_to_another_teacher === true ||
                course.assigned_to_another_teacher === "true";


            const assignedTeacherName =
                course.assigned_teacher_name || "";


            const assignedTeacherStaff =
                course.assigned_teacher_staff_number || "";


            /*
             * Determine status.
             */
            let statusHtml = "";
            let checkboxDisabled = false;
            let checkboxChecked = false;


            if (assigned) {

                statusHtml =
                    "<span class=\"status-badge status-current\">" +
                        "<i class=\"bi bi-check-circle\"></i>" +
                        " Assigned to this teacher" +
                    "</span>";

                checkboxChecked = true;

            } else if (assignedElsewhere) {

                let teacherText =
                    assignedTeacherName;

                if (assignedTeacherStaff) {

                    teacherText +=
                        " (" +
                        assignedTeacherStaff +
                        ")";

                }

                statusHtml =
                    "<span class=\"status-badge status-other\">" +
                        "<i class=\"bi bi-person-lock\"></i>" +
                        " Assigned Elsewhere" +
                    "</span>";

                if (teacherText) {

                    statusHtml +=
                        "<div class=\"small text-muted mt-1\">" +
                            teacherText +
                        "</div>";

                }

                checkboxDisabled = true;

            } else {

                statusHtml =
                    "<span class=\"status-badge status-available\">" +
                        "<i class=\"bi bi-circle\"></i>" +
                        " Available" +
                    "</span>";

            }


            /*
             * Course item.
             */
            const item =
                document.createElement("div");

            item.className =
                "col-12";


            item.innerHTML =

                "<div class=\"assignment-course-item\">" +

                    "<div class=\"assignment-course-row\">" +

                        "<input " +
                            "type=\"checkbox\" " +
                            "class=\"form-check-input assignment-course-checkbox course-checkbox\" " +
                            "value=\"" +
                                escapeHtml(String(courseId)) +
                            "\" " +
                            (checkboxChecked ? "checked " : "") +
                            (checkboxDisabled ? "disabled " : "") +
                        ">" +

                        "<div class=\"assignment-course-icon\">" +

                            "<i class=\"bi bi-journal-text\"></i>" +

                        "</div>" +

                        "<div class=\"assignment-course-information\">" +

                            "<div class=\"assignment-course-code\">" +
                                escapeHtml(courseCode) +
                            "</div>" +

                            "<div class=\"assignment-course-name\">" +
                                escapeHtml(courseName) +
                            "</div>" +

                            "<div class=\"assignment-course-year\">" +
                                "Year " +
                                escapeHtml(String(courseYear)) +
                            "</div>" +

                        "</div>" +

                        "<div class=\"assignment-status\">" +

                            statusHtml +

                        "</div>" +

                    "</div>" +

                "</div>";


            coursesContainer.appendChild(item);

        });


        /*
         * Add change listeners.
         */
        document
            .querySelectorAll(".course-checkbox")
            .forEach(function (checkbox) {

                checkbox.addEventListener(
                    "change",
                    updateSaveButton
                );

            });


        updateSaveButton();

    }


    /* ============================================================
       UPDATE SAVE BUTTON
       ============================================================ */

    function updateSaveButton() {

        const selected =
            document.querySelectorAll(
                ".course-checkbox:checked:not(:disabled)"
            );


        saveAssignmentsButton.disabled =
            false;


        if (selected.length > 0) {

            saveAssignmentsButton.innerHTML =
                "<i class=\"bi bi-check2-circle me-1\"></i>" +
                "Save " +
                selected.length +
                " Assignment" +
                (selected.length === 1 ? "" : "s");

        } else {

            saveAssignmentsButton.innerHTML =
                "<i class=\"bi bi-check2-circle me-1\"></i>" +
                "Save Assignments";

        }

    }


    /* ============================================================
       ESCAPE HTML
       ============================================================ */

    function escapeHtml(value) {

        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");

    }


    /* ============================================================
       TEACHER CHANGE
       ============================================================ */

    teacherSelect.addEventListener(
        "change",
        function () {

            if (!teacherSelect.value) {

                showEmptyState(
                    "Select a Teacher",
                    "Choose a teacher to continue."
                );

                return;

            }


            if (
                programmeSelect.value &&
                yearSelect.value
            ) {

                loadCourses();

            } else {

                showEmptyState(
                    "Complete the Selection",
                    "Now select a college, programme and year."
                );

            }

        }
    );


    /* ============================================================
       COLLEGE CHANGE
       ============================================================ */

    collegeSelect.addEventListener(
        "change",
        function () {

            const collegeId =
                collegeSelect.value;


            /*
             * Reset courses immediately.
             */
            coursesContainer.innerHTML =
                "<div class=\"col-12\">" +

                    "<div class=\"assignment-empty-state\">" +

                        "<div class=\"assignment-empty-icon\">" +

                            "<i class=\"bi bi-funnel\"></i>" +

                        "</div>" +

                        "<h5>Select a Programme</h5>" +

                        "<p>" +
                            "Choose a programme and year to load courses." +
                        "</p>" +

                    "</div>" +

                "</div>";


            courseSummary.classList.add("d-none");
            saveCard.classList.add("d-none");


            /*
             * Load programmes for selected college.
             *
             * THIS IS THE IMPORTANT FIX.
             */
            loadProgrammes(
                collegeId,
                ""
            );

        }
    );


    /* ============================================================
       PROGRAMME CHANGE
       ============================================================ */

    programmeSelect.addEventListener(
        "change",
        function () {

            if (
                teacherSelect.value &&
                programmeSelect.value &&
                yearSelect.value
            ) {

                loadCourses();

            } else {

                showEmptyState(
                    "Complete the Selection",
                    "Select a teacher and year to load courses."
                );

            }

        }
    );


    /* ============================================================
       YEAR CHANGE
       ============================================================ */

    yearSelect.addEventListener(
        "change",
        function () {

            if (
                teacherSelect.value &&
                programmeSelect.value &&
                yearSelect.value
            ) {

                loadCourses();

            } else {

                showEmptyState(
                    "Complete the Selection",
                    "Select a teacher, programme and year to load courses."
                );

            }

        }
    );


    /* ============================================================
       SAVE ASSIGNMENTS
       ============================================================ */

    saveAssignmentsButton.addEventListener(
        "click",
        function () {

            const teacherId =
                teacherSelect.value;

            const programmeId =
                programmeSelect.value;

            const year =
                yearSelect.value;


            /*
             * Validate selections.
             */
            if (
                !teacherId ||
                !programmeId ||
                !year
            ) {

                alert(
                    "Please select a teacher, programme and year."
                );

                return;

            }


            /*
             * Get selected courses.
             */
            const selectedCheckboxes =
                document.querySelectorAll(
                    ".course-checkbox:checked:not(:disabled)"
                );


            /*
             * Clear previous hidden inputs.
             */
            selectedCoursesInputs.innerHTML = "";


            /*
             * Add teacher/programme/year.
             */
            formTeacherId.value =
                teacherId;

            formProgrammeId.value =
                programmeId;

            formYear.value =
                year;


            /*
             * Add selected course IDs.
             */
            selectedCheckboxes.forEach(
                function (checkbox) {

                    const input =
                        document.createElement("input");

                    input.type =
                        "hidden";

                    input.name =
                        "courseIds";

                    input.value =
                        checkbox.value;

                    selectedCoursesInputs.appendChild(
                        input
                    );

                }
            );


            /*
             * Confirm.
             */
            const count =
                selectedCheckboxes.length;


            const confirmed =
                confirm(
                    "Save " +
                    count +
                    " selected course" +
                    (count === 1 ? "" : "s") +
                    " for this teacher?"
                );


            if (!confirmed) {
                return;
            }


            /*
             * Submit.
             */
            assignmentForm.submit();

        }
    );


    /* ============================================================
       INITIAL PAGE LOAD
       ============================================================ */

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            /*
             * If a college is already known,
             * load its programmes.
             */
            if (initialCollegeId) {

                loadProgrammes(
                    initialCollegeId,
                    initialProgrammeId
                );

            }

        }
    );

</script>

</body>
</html>